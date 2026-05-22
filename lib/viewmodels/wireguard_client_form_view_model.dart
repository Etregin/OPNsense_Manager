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
import '../models/wireguard_client.dart';
import '../models/wireguard_key_pair.dart';
import '../services/opnsense_api_service.dart';
import 'base/base_form_view_model.dart';

/// ViewModel for WireGuard client form
class WireGuardClientFormViewModel extends BaseFormViewModel {
  final OPNsenseApiService _apiService;
  final WireGuardClient? _existingClient;

  bool _isGeneratingKeys = false;

  bool get isGeneratingKeys => _isGeneratingKeys;
  bool get isEditing => _existingClient != null;
  WireGuardClient? get existingClient => _existingClient;

  WireGuardClientFormViewModel({
    required OPNsenseApiService apiService,
    WireGuardClient? existingClient,
  })  : _apiService = apiService,
        _existingClient = existingClient;

  /// Generate new WireGuard key pair
  Future<WireGuardKeyPair?> generateKeyPair() async {
    _isGeneratingKeys = true;
    notifyListeners();

    try {
      final keyPair = await _apiService.generateWireGuardKeyPair();
      _isGeneratingKeys = false;
      clearError(); // Clear any previous errors on success
      notifyListeners();
      return keyPair;
    } catch (e) {
      _isGeneratingKeys = false;
      final errorMsg = 'Failed to generate keys: $e';
      setError(errorMsg);
      // Log the error for debugging
      debugPrint('WireGuardClientFormViewModel.generateKeyPair error: $errorMsg');
      return null;
    }
  }

  /// Save client (create or update)
  Future<bool> saveClient(WireGuardClientRequest request) async {
    final result = await executeWithLoading(() async {
      if (isEditing) {
        await _apiService.updateWireGuardClient(_existingClient!.uuid, request);
      } else {
        await _apiService.createWireGuardClient(request);
      }
      return true;
    });
    return result == true;
  }
}

// Made with Bob