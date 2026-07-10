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

import '../models/openvpn_static_key.dart';
import '../services/demo_api_service.dart';
import 'base/base_form_view_model.dart';

/// ViewModel for OpenVPN Static Key form screen
class OpenvpnStaticKeyFormViewModel extends BaseFormViewModel {
  final DemoApiService _apiService;
  final String? _keyid;

  OpenvpnStaticKey? _loadedKey;
  bool _isGenerating = false;

  OpenvpnStaticKey? get loadedKey => _loadedKey;
  bool get isGenerating => _isGenerating;
  bool get isEditing => _keyid != null;

  OpenvpnStaticKeyFormViewModel({
    required this._apiService,
    this._keyid,
  });

  /// Load existing static key from API
  Future<void> loadStaticKey() async {
    final keyid = _keyid;
    if (keyid == null || keyid.isEmpty) return;

    setLoading(true);
    clearError();

    try {
      _loadedKey = await _apiService.getOpenvpnStaticKey(keyid);
    } catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }

  /// Generate a new static key for the given API mode
  Future<String?> generateKey(String apiMode) async {
    _isGenerating = true;
    notifyListeners();

    String? key;
    try {
      key = await _apiService.generateOpenvpnStaticKey(apiMode);
      clearError();
      return key;
    } catch (e) {
      setError(e.toString());
      return null;
    } finally {
      _isGenerating = false;
      notifyListeners();
    }
  }

  /// Save static key (create or update)
  Future<bool> saveStaticKey(OpenvpnStaticKey staticKey) async {
    final result = await executeWithLoading(() async {
      if (isEditing) {
        await _apiService.updateOpenvpnStaticKey(_keyid!, staticKey);
      } else {
        await _apiService.addOpenvpnStaticKey(staticKey);
      }
      return true;
    });
    return result == true;
  }
}
