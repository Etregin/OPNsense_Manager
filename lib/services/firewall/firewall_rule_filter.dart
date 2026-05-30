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

import '../../models/firewall_rule.dart';

/// Utility class for filtering and grouping firewall rules
class FirewallRuleFilter {
  /// Filter rules to show only automation rules (non-system-generated)
  static List<FirewallRule> filterAutomationRules(List<FirewallRule> rules) {
    return rules.where((rule) => !rule.isSystemGenerated).toList();
  }

  /// Group rules by interface
  static Map<String, List<FirewallRule>> groupByInterface(
      List<FirewallRule> rules) {
    final Map<String, List<FirewallRule>> rulesByInterface = {};
    
    for (var rule in rules) {
      if (!rulesByInterface.containsKey(rule.interfaceName)) {
        rulesByInterface[rule.interfaceName] = [];
      }
      rulesByInterface[rule.interfaceName]!.add(rule);
    }
    
    return rulesByInterface;
  }

  /// Get rules for a specific interface
  static List<FirewallRule> getRulesForInterface(
    Map<String, List<FirewallRule>> rulesByInterface,
    String? interfaceName,
  ) {
    if (interfaceName == null) return [];
    return rulesByInterface[interfaceName] ?? [];
  }

  /// Get the first available interface name
  static String? getFirstInterface(
      Map<String, List<FirewallRule>> rulesByInterface) {
    return rulesByInterface.isNotEmpty ? rulesByInterface.keys.first : null;
  }

  /// Filter and group rules in one operation
  static Map<String, List<FirewallRule>> filterAndGroup(
      List<FirewallRule> allRules) {
    final automationRules = filterAutomationRules(allRules);
    return groupByInterface(automationRules);
  }
}


