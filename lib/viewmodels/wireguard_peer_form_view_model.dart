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
import '../models/wireguard_peer.dart';
import '../models/wireguard_peer_response.dart';
import '../models/wireguard_server.dart';
import '../services/opnsense_api_service.dart';
import 'base/base_form_view_model.dart';

/// ViewModel for WireGuard peer form
class WireGuardPeerFormViewModel extends BaseFormViewModel {
  final OPNsenseApiService _apiService;
  final String? _existingPeerUuid;

  List<WireGuardServer> _availableServers = [];
  bool _isGeneratingPsk = false;
  bool _loadingServers = true;
  bool _loadingPeer = false;
  WireGuardPeerResponse? _loadedPeerData;

  List<WireGuardServer> get availableServers => _availableServers;
  bool get isGeneratingPsk => _isGeneratingPsk;
  bool get loadingServers => _loadingServers;
  bool get loadingPeer => _loadingPeer;
  bool get isEditing => _existingPeerUuid != null;
  String? get existingPeerUuid => _existingPeerUuid;
  WireGuardPeerResponse? get loadedPeerData => _loadedPeerData;

  WireGuardPeerFormViewModel({
    required this._apiService,
    this._existingPeerUuid,
  });

  /// Load available servers from API
  Future<void> loadServers() async {
    _loadingServers = true;
    notifyListeners();

    try {
      _availableServers = await _apiService.getWireGuardServers();
      _loadingServers = false;
      notifyListeners();
    } catch (e) {
      _loadingServers = false;
      setError('Failed to load servers: $e');
    }
  }

  /// Load existing peer data for editing
  Future<void> loadPeer(String uuid) async {
    _loadingPeer = true;
    notifyListeners();

    try {
      final peerData = await _apiService.getPeer(uuid);
      debugPrint('WireGuardPeerFormViewModel: Raw peer data keys: ${peerData.keys.join(", ")}');
      debugPrint('WireGuardPeerFormViewModel: PSK in response: "${peerData['psk']}"');
      debugPrint('WireGuardPeerFormViewModel: PSK type: ${peerData['psk'].runtimeType}');
      debugPrint('WireGuardPeerFormViewModel: PSK is null: ${peerData['psk'] == null}');
      debugPrint('WireGuardPeerFormViewModel: PSK is empty: ${peerData['psk'] == ""}');
      
      _loadedPeerData = WireGuardPeerResponse.fromJson(peerData);
      debugPrint('WireGuardPeerFormViewModel: Parsed PSK: "${_loadedPeerData?.psk}"');
      debugPrint('WireGuardPeerFormViewModel: Parsed PSK length: ${_loadedPeerData?.psk.length}');
      
      _loadingPeer = false;
      notifyListeners();
    } catch (e) {
      _loadingPeer = false;
      setError('Failed to load peer: $e');
    }
  }

  /// Generate new pre-shared key
  Future<String?> generatePsk() async {
    _isGeneratingPsk = true;
    notifyListeners();

    try {
      final psk = await _apiService.generateWireGuardPSK();
      _isGeneratingPsk = false;
      clearError();
      notifyListeners();
      return psk;
    } catch (e) {
      _isGeneratingPsk = false;
      final errorMsg = 'Failed to generate PSK: $e';
      setError(errorMsg);
      debugPrint('WireGuardPeerFormViewModel.generatePsk error: $errorMsg');
      return null;
    }
  }

  /// Save peer (create or update)
  Future<bool> savePeer(WireGuardPeerRequest request) async {
    final result = await executeWithLoading(() async {
      if (isEditing) {
        await _apiService.updateWireGuardPeer(_existingPeerUuid!, request);
      } else {
        await _apiService.createWireGuardPeer(request);
      }
      return true;
    });
    return result == true;
  }
}


