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

import '../models/wireguard_server.dart';
import '../models/wireguard_peer.dart';
import '../models/wireguard_key_pair.dart';
import '../services/opnsense_api_service.dart';
import 'base/base_form_view_model.dart';

/// ViewModel for WireGuard server form
class WireGuardServerFormViewModel extends BaseFormViewModel {
  final OPNsenseApiService _apiService;
  final WireGuardServer? _existingServer;

  List<WireGuardPeer> _availablePeers = [];
  List<CarpVipOption> _carpVipOptions = [];
  bool _isGeneratingKeys = false;
  bool _loadingPeers = true;
  bool _loadingCarpOptions = true;

  List<WireGuardPeer> get availablePeers => _availablePeers;
  List<CarpVipOption> get carpVipOptions => _carpVipOptions;
  bool get isGeneratingKeys => _isGeneratingKeys;
  bool get loadingPeers => _loadingPeers;
  bool get loadingCarpOptions => _loadingCarpOptions;
  bool get isEditing => _existingServer != null;
  WireGuardServer? get existingServer => _existingServer;

  WireGuardServerFormViewModel({
    required this._apiService,
    this._existingServer,
  });

  /// Load available peers from API
  Future<void> loadPeers() async {
    _loadingPeers = true;
    notifyListeners();

    try {
      _availablePeers = await _apiService.getWireGuardPeers();
      _loadingPeers = false;
      notifyListeners();
    } catch (e) {
      _loadingPeers = false;
      setError('Failed to load peers: $e');
    }
  }

  /// Load CARP VIP options from API
  Future<void> loadCarpVipOptions() async {
    _loadingCarpOptions = true;
    notifyListeners();

    try {
      _carpVipOptions = await _apiService.getCarpVipOptions();
      _loadingCarpOptions = false;
      notifyListeners();
    } catch (e) {
      _loadingCarpOptions = false;
      // Don't set error for CARP options as it's optional
    }
  }

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
      return null;
    }
  }

  /// Save server (create or update)
  Future<bool> saveServer(WireGuardServerRequest request) async {
    final result = await executeWithLoading(() async {
      if (isEditing) {
        await _apiService.updateWireGuardServer(_existingServer!.uuid, request);
      } else {
        await _apiService.createWireGuardServer(request);
      }
      return true;
    });
    return result == true;
  }
}


