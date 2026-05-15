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

import '../models/wireguard_peer.dart';
import '../services/opnsense_api_service.dart';
import 'base/base_form_view_model.dart';

/// ViewModel for WireGuard peer form
class WireGuardPeerFormViewModel extends BaseFormViewModel {
  final OPNsenseApiService _apiService;
  final WireGuardPeer? _existingPeer;

  bool get isEditing => _existingPeer != null;
  WireGuardPeer? get existingPeer => _existingPeer;

  WireGuardPeerFormViewModel({
    required OPNsenseApiService apiService,
    WireGuardPeer? existingPeer,
  })  : _apiService = apiService,
        _existingPeer = existingPeer;

  /// Save peer (create or update)
  Future<bool> savePeer(WireGuardPeerRequest request) async {
    final result = await executeWithLoading(() async {
      if (isEditing) {
        await _apiService.updateWireGuardPeer(_existingPeer!.uuid, request);
      } else {
        await _apiService.createWireGuardPeer(request);
      }
      return true;
    });
    return result == true;
  }
}

// Made with Bob