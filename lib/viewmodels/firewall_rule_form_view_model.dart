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

import '../models/firewall_rule.dart';
import '../models/firewall_form_options.dart';
import '../services/demo_api_service.dart';
import 'base/base_form_view_model.dart';

/// ViewModel for Firewall Rule form screen
class FirewallRuleFormViewModel extends BaseFormViewModel {
  final DemoApiService _apiService;
  final FirewallRule? _existingRule;

  Map<String, dynamic> _availableInterfaces = {};
  bool _loadingInterfaces = true;

  FirewallFormOptions _formOptions = FirewallFormOptions.defaults();
  bool _loadingOptions = true;

  /// alias name → alias name (used to populate net/dest dropdowns)
  Map<String, String> _aliases = {};
  bool _loadingAliases = true;

  Map<String, dynamic> get availableInterfaces => _availableInterfaces;
  bool get loadingInterfaces => _loadingInterfaces;
  bool get isEditing => _existingRule != null;
  FirewallRule? get existingRule => _existingRule;

  FirewallFormOptions get formOptions => _formOptions;
  bool get loadingOptions => _loadingOptions;

  Map<String, String> get aliases => _aliases;
  bool get loadingAliases => _loadingAliases;

  FirewallRuleFormViewModel({
    required this._apiService,
    this._existingRule,
  });

  /// Load firewall aliases (names only — used in source/dest pickers)
  Future<void> loadAliases() async {
    _loadingAliases = true;
    notifyListeners();
    try {
      final list = await _apiService.getFirewallAliases();
      _aliases = { for (final a in list) a.name: a.name };
    } catch (_) {
      _aliases = {};
    } finally {
      _loadingAliases = false;
      notifyListeners();
    }
  }

  /// Load available interfaces from API
  Future<void> loadInterfaces() async {
    _loadingInterfaces = true;
    notifyListeners();

    try {
      _availableInterfaces = await _apiService.getAvailableInterfaces();
    } catch (e) {
      _availableInterfaces = {
        'lan': 'LAN',
        'wan': 'WAN',
        'opt1': 'OPT1',
        'opt2': 'OPT2',
      };
    } finally {
      _loadingInterfaces = false;
      notifyListeners();
    }
  }

  /// Load all dynamic dropdown option maps (gateway, shaper, TOS, etc.)
  Future<void> loadFormOptions() async {
    _loadingOptions = true;
    notifyListeners();

    try {
      _formOptions = await _apiService.getFirewallRuleFormOptions();
    } catch (e) {
      _formOptions = FirewallFormOptions.defaults();
    } finally {
      _loadingOptions = false;
      notifyListeners();
    }
  }

  /// Save rule (create or update)
  Future<bool> saveRule(FirewallRuleRequest request) async {
    final result = await executeWithLoading(() async {
      if (isEditing) {
        await _apiService.updateFirewallRule(_existingRule!.uuid, request);
      } else {
        await _apiService.createFirewallRule(request);
      }
      return true;
    });
    return result == true;
  }
}
