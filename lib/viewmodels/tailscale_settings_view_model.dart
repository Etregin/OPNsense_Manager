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

import '../models/tailscale_settings.dart';
import '../models/system_info.dart';
import '../services/demo_api_service.dart';
import '../services/opnsense_api_service.dart';
import 'base/base_form_view_model.dart';

/// ViewModel for Tailscale settings screen
class TailscaleSettingsViewModel extends BaseFormViewModel {
  final DemoApiService _demoApiService;
  final OPNsenseApiService? _opnsenseApiService;

  TailscaleSettings? _settings;
  SystemInfo? _systemInfo;
  TailscaleSettings? _originalSettings;
  TailscaleSettings? _modifiedSettings;

  TailscaleSettings? get settings => _settings;
  SystemInfo? get systemInfo => _systemInfo;
  TailscaleSettings? get modifiedSettings => _modifiedSettings;
  bool get isDemoMode => _demoApiService.isDemoMode;

  TailscaleSettingsViewModel({
    required DemoApiService demoApiService,
    OPNsenseApiService? opnsenseApiService,
  })  : _demoApiService = demoApiService,
        _opnsenseApiService = opnsenseApiService;

  /// Load settings and system info from API
  Future<void> loadData() async {
    return executeWithLoading(() async {
      final settingsResponse = await _demoApiService.getTailscaleSettings();
      final systemInfo = await _demoApiService.getSystemInfo();

      _settings = settingsResponse.settings;
      _originalSettings = settingsResponse.settings;
      _modifiedSettings = settingsResponse.settings;
      _systemInfo = systemInfo;
      
      notifyListeners();
    });
  }

  /// Update modified settings and mark as changed
  void updateSettings(TailscaleSettings newSettings) {
    _modifiedSettings = newSettings;
    markAsChanged();
  }

  /// Save all changes to the API
  Future<bool> saveChanges() async {
    if (!hasUnsavedChanges || _modifiedSettings == null) {
      return false;
    }

    setLoading(true);
    clearError();

    try {
      final result = isDemoMode
          ? await _demoApiService.setTailscaleSettings(_modifiedSettings!)
          : await _opnsenseApiService!.setTailscaleSettings(_modifiedSettings!);

      if (result['result'] == 'saved') {
        // Reload fresh data
        await loadData();
        _originalSettings = _settings;
        _modifiedSettings = _settings;
        markAsSaved();
        return true;
      } else {
        // Handle validation errors
        final validationErrors = result['validations'] as Map<String, dynamic>?;
        if (validationErrors != null) {
          final errorMessages = <String>[];
          validationErrors.forEach((field, errors) {
            if (errors is List) {
              errorMessages.addAll(errors.map((e) => '$field: $e'));
            }
          });
          setError('Validation errors:\n${errorMessages.join('\n')}');
        } else {
          setError('Failed to save settings: ${result['result']}');
        }
        return false;
      }
    } catch (e) {
      setError('Error saving settings: $e');
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// Discard unsaved changes
  void discardChanges() {
    _modifiedSettings = _originalSettings;
    markAsSaved();
  }

  /// Control Tailscale service (start/stop/restart)
  Future<bool> controlService(String action) async {
    setLoading(true);
    clearError();

    try {
      final success = await _demoApiService.controlTailscaleService(action);
      if (success) {
        await loadData();
      }
      return success;
    } catch (e) {
      setError('Error controlling service: $e');
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// Get selected exit node ID
  String? getSelectedExitNode() {
    if (_modifiedSettings?.useExitNode == null) return null;
    
    for (var entry in _modifiedSettings!.useExitNode!.entries) {
      if (entry.value.selected) {
        return entry.key;
      }
    }
    return null;
  }

  /// Get list of available exit nodes
  List<MapEntry<String, dynamic>> getAvailableExitNodes() {
    if (_modifiedSettings?.useExitNode == null) return [];
    
    return _modifiedSettings!.useExitNode!.entries
        .where((entry) => entry.key.isNotEmpty)
        .toList();
  }
}

// Made with Bob
