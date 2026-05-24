/*
 * OPNsense Manager - Flutter application for managing OPNsense firewalls
 * Copyright (C) 2026 OPNsense Manager
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import 'package:flutter/foundation.dart';
import '../models/wireguard_client_builder.dart';
import '../models/wireguard_key_pair.dart';
import '../services/opnsense_api_service.dart';
import 'base/base_form_view_model.dart';

/// ViewModel for WireGuard peer generator screen
class WireGuardPeerGeneratorViewModel extends BaseFormViewModel {
  final OPNsenseApiService _apiService;

  WireGuardClientBuilder? _builderData;
  WireGuardServerInfo? _selectedServerInfo;
  WireGuardKeyPair? _keyPair;
  String? _psk;
  bool _loadingBuilder = true;
  bool _loadingServerInfo = false;
  bool _generatingKeys = false;
  bool _generatingPsk = false;
  bool _wireguardEnabled = true;

  WireGuardClientBuilder? get builderData => _builderData;
  WireGuardServerInfo? get selectedServerInfo => _selectedServerInfo;
  WireGuardKeyPair? get keyPair => _keyPair;
  String? get psk => _psk;
  bool get loadingBuilder => _loadingBuilder;
  bool get loadingServerInfo => _loadingServerInfo;
  bool get generatingKeys => _generatingKeys;
  bool get generatingPsk => _generatingPsk;
  bool get wireguardEnabled => _wireguardEnabled;

  WireGuardPeerGeneratorViewModel({
    required this._apiService,
  });

  /// Load builder data from API
  Future<void> loadBuilderData() async {
    _loadingBuilder = true;
    notifyListeners();

    try {
      _builderData = await _apiService.getClientBuilder();
      
      // Generate initial key pair
      await _generateKeyPair();
      
      clearError();
    } catch (e) {
      setError('Failed to load builder data: $e');
    } finally {
      _loadingBuilder = false;
      notifyListeners();
    }
  }

  /// Load server info when a server is selected
  Future<void> loadServerInfo(String serverUuid) async {
    _loadingServerInfo = true;
    notifyListeners();

    try {
      _selectedServerInfo = await _apiService.getServerInfo(serverUuid);
      clearError();
    } catch (e) {
      setError('Failed to load server info: $e');
    } finally {
      _loadingServerInfo = false;
      notifyListeners();
    }
  }

  /// Generate a new key pair
  Future<void> _generateKeyPair() async {
    _generatingKeys = true;
    notifyListeners();

    try {
      _keyPair = await _apiService.generateWireGuardKeyPair();
      clearError();
    } catch (e) {
      setError('Failed to generate key pair: $e');
    } finally {
      _generatingKeys = false;
      notifyListeners();
    }
  }

  /// Generate a new key pair (public method for manual regeneration)
  Future<void> regenerateKeyPair() async {
    await _generateKeyPair();
  }

  /// Generate a new pre-shared key
  Future<void> generatePsk() async {
    _generatingPsk = true;
    notifyListeners();

    try {
      _psk = await _apiService.generateWireGuardPSK();
      clearError();
    } catch (e) {
      setError('Failed to generate PSK: $e');
    } finally {
      _generatingPsk = false;
      notifyListeners();
    }
  }

  /// Clear the pre-shared key
  void clearPsk() {
    _psk = null;
    notifyListeners();
  }

  /// Set WireGuard enabled state
  void setWireguardEnabled(bool enabled) {
    _wireguardEnabled = enabled;
    notifyListeners();
  }

  /// Save peer and generate next
  Future<bool> saveAndGenerateNext(WireGuardClientBuilderRequest request) async {
    // Save the peer
    final saveResult = await executeWithLoading(() async {
      await _apiService.addClientBuilder(request);
      return true;
    });
    
    if (saveResult != true) {
      return false;
    }
    
    // Reload builder data for next peer (don't fail the save if this fails)
    try {
      await loadBuilderData();
    } catch (e) {
      // Log but don't fail - the peer was saved successfully
      debugPrint('Warning: Failed to reload builder data after save: $e');
    }
    
    return true;
  }

  /// Apply WireGuard configuration
  /// This reconfigures the WireGuard service to apply any pending changes
  Future<bool> applyConfiguration() async {
    final result = await executeWithLoading(() async {
      final response = await _apiService.reconfigureWireGuard();
      
      // Validate the response to ensure reconfiguration was successful
      // OPNsense typically returns {"status": "ok"} or similar on success
      if (response.containsKey('status')) {
        final status = response['status'];
        if (status == 'failed' || status == 'error') {
          final message = response['message'] ?? 'Unknown error';
          throw Exception('Reconfiguration failed: $message');
        }
      }
      
      return true;
    });
    return result == true;
  }

  /// Enable/disable WireGuard service
  Future<bool> toggleWireGuardService(bool enable) async {
    final result = await executeWithLoading(() async {
      if (enable) {
        await _apiService.startWireGuardService();
      } else {
        await _apiService.stopWireGuardService();
      }
      _wireguardEnabled = enable;
      return true;
    });
    return result == true;
  }
}


