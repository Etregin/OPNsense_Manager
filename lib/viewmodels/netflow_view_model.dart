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
import '../models/netflow_cache_stat.dart';
import '../models/netflow_config.dart';
import '../services/demo_api_service.dart';

/// ViewModel for the NetFlow screen (Capture + Cache tabs).
class NetflowViewModel extends ChangeNotifier {
  final DemoApiService _apiService;

  NetflowViewModel(this._apiService);

  // ── Shared loading/error state ────────────────────────────────────────────

  bool _isLoading = false;
  bool _isSaving = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get errorMessage => _errorMessage;

  // ── Capture tab ───────────────────────────────────────────────────────────

  NetflowConfig? _config;

  NetflowConfig? get config => _config;

  /// Loads the current NetFlow configuration.
  Future<void> loadConfig() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _config = await _apiService.getNetflowConfig();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Applies a local mutation to the config without saving.
  void updateConfig(NetflowConfig updated) {
    _config = updated;
    notifyListeners();
  }

  /// Saves the current config and triggers a reconfigure.
  ///
  /// Returns `true` on success.
  Future<bool> saveConfig() async {
    if (_config == null) return false;
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _apiService.saveNetflowConfig(_config!);
      await _apiService.reconfigureNetflow();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  /// Resets all NetFlow data after user confirmation.
  ///
  /// Returns `true` on success.
  Future<bool> resetData() async {
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _apiService.resetNetflowData();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  // ── Cache tab ─────────────────────────────────────────────────────────────

  List<NetflowCacheStat> _cacheStats = [];
  bool _isCacheLoading = false;
  String? _cacheErrorMessage;

  List<NetflowCacheStat> get cacheStats => List.unmodifiable(_cacheStats);
  bool get isCacheLoading => _isCacheLoading;
  String? get cacheErrorMessage => _cacheErrorMessage;

  /// Loads the cache statistics.
  Future<void> loadCacheStats() async {
    _isCacheLoading = true;
    _cacheErrorMessage = null;
    notifyListeners();

    try {
      _cacheStats = await _apiService.getNetflowCacheStats();
    } catch (e) {
      _cacheErrorMessage = e.toString();
    } finally {
      _isCacheLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshCacheStats() => loadCacheStats();
}
