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

import '../models/firewall_alias.dart';
import '../services/demo_api_service.dart';
import 'base/base_form_view_model.dart';

/// ViewModel for Firewall Alias form screen
class FirewallAliasFormViewModel extends BaseFormViewModel {
  final DemoApiService _apiService;
  final FirewallAlias? _existingAlias;

  // Form data loading state
  bool _loadingFormData = true;
  bool _loadingFullAlias = false;
  FirewallAlias? _fullAlias;

  // Option maps for pickers
  Map<String, String> _categories = {};
  Map<String, String> _networkAliases = {};
  Map<String, String> _userGroups = {};
  Map<String, String> _countries = {};
  Map<String, String> _availableInterfaces = {};

  // Getters
  bool get loadingFormData => _loadingFormData;
  bool get loadingFullAlias => _loadingFullAlias;
  FirewallAlias? get fullAlias => _fullAlias;

  Map<String, String> get categories => _categories;
  Map<String, String> get networkAliases => _networkAliases;
  Map<String, String> get userGroups => _userGroups;
  Map<String, String> get countries => _countries;
  Map<String, String> get availableInterfaces => _availableInterfaces;

  bool get isEditing => _existingAlias != null;
  FirewallAlias? get existingAlias => _existingAlias;

  FirewallAliasFormViewModel({
    required this._apiService,
    this._existingAlias,
  });

  /// Parallel-load all option maps required by the form pickers.
  Future<void> loadFormData() async {
    _loadingFormData = true;
    notifyListeners();
    try {
      final results = await Future.wait([
        _apiService.listAliasCategories(),
        _apiService.listNetworkAliases(),
        _apiService.listUserGroups(),
        _apiService.listAliasCountries(),
        _apiService.getAliasItemDefaults(),
      ]);

      // listAliasCategories → List<AliasCategory> → id (name) → name
      final rawCategories = results[0] as List<AliasCategory>;
      _categories = {for (final c in rawCategories) c.name: c.name};

      // listNetworkAliases → Map<String, dynamic> → Map<String, String>
      final rawNetworkAliases = results[1] as Map<String, dynamic>;
      _networkAliases = rawNetworkAliases.map(
        (k, v) => MapEntry(k, v.toString()),
      );

      // listUserGroups → Map<String, dynamic> → Map<String, String>
      final rawUserGroups = results[2] as Map<String, dynamic>;
      _userGroups = rawUserGroups.map(
        (k, v) => MapEntry(k, v.toString()),
      );

      // listAliasCountries → List<AliasCountry> → code → name
      final rawCountries = results[3] as List<AliasCountry>;
      _countries = {for (final c in rawCountries) c.code: c.name};

      // getAliasItemDefaults → extract alias['interface'] map
      // Shape: {'lan': {'value': 'LAN', ...}, 'wan': {'value': 'WAN', ...}}
      final defaults = results[4] as Map<String, dynamic>;
      final aliasNode = defaults['alias'] as Map<String, dynamic>? ?? {};
      final interfaceNode = aliasNode['interface'] as Map<String, dynamic>? ?? {};
      _availableInterfaces = interfaceNode.map(
        (k, v) => MapEntry(k, (v as Map<String, dynamic>)['value'].toString()),
      );
    } catch (_) {
      // Leave empty maps on error; screen can still render
    } finally {
      _loadingFormData = false;
      notifyListeners();
    }
  }

  /// Fetch the full alias data from the edit API endpoint.
  Future<void> loadFullAlias(String uuid) async {
    _loadingFullAlias = true;
    notifyListeners();
    try {
      _fullAlias = await _apiService.getFirewallAlias(uuid);
    } catch (e) {
      _fullAlias = _existingAlias; // fallback to list-view data
      setError(e.toString());
    } finally {
      _loadingFullAlias = false;
      notifyListeners();
    }
  }

  /// Save alias (create or update). Returns true on success.
  Future<bool> saveAlias(FirewallAliasRequest request) async {
    final result = await executeWithLoading(() async {
      if (isEditing) {
        await _apiService.updateFirewallAlias(_existingAlias!.uuid, request);
      } else {
        await _apiService.createFirewallAlias(request);
      }
      return true;
    });
    return result == true;
  }
}
