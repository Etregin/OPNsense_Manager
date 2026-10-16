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
import '../services/demo_api_service.dart';
import '../services/firewall/firewall_rule_filter.dart';
import 'base/base_list_view_model.dart';

/// ViewModel for managing the firewall rules list screen.
class FirewallRulesViewModel extends BaseListViewModel<FirewallRule> {
  final DemoApiService _apiService;

  Map<String, List<FirewallRule>> _rulesByInterface = {};
  String? _selectedInterface;

  FirewallRulesViewModel(this._apiService);

  Map<String, List<FirewallRule>> get rulesByInterface => _rulesByInterface;
  String? get selectedInterface => _selectedInterface;

  void selectInterface(String? interface) {
    _selectedInterface = interface;
    notifyListeners();
  }

  @override
  Future<List<FirewallRule>> fetchItems() async {
    final allRules = await _apiService.getFirewallRules();
    final rulesByInterface = FirewallRuleFilter.filterAndGroup(allRules);

    _rulesByInterface = rulesByInterface;

    // Set default selected interface to the first one if not yet chosen
    if (_selectedInterface == null && rulesByInterface.isNotEmpty) {
      _selectedInterface = FirewallRuleFilter.getFirstInterface(rulesByInterface);
    }

    return allRules;
  }

  @override
  bool matchesFilter(FirewallRule rule, String query) {
    final lower = query.toLowerCase();
    return rule.description.toLowerCase().contains(lower) ||
        rule.interfaceName.toLowerCase().contains(lower);
  }

  /// Toggle a firewall rule enabled/disabled state
  Future<void> toggleRule(String uuid) async {
    await _apiService.toggleFirewallRule(uuid);
    await refresh();
  }

  /// Delete a firewall rule
  Future<void> deleteRule(String uuid) async {
    await _apiService.deleteFirewallRule(uuid);
    await refresh();
  }
}
