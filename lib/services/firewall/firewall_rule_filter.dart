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

/// Canonical key used for rules that have no interface (floating/global rules).
const String kFloatingInterfaceKey = '(floating)';

/// Utility class for filtering and grouping firewall rules
class FirewallRuleFilter {
  /// Filter rules to show only user-created (non-system-generated) rules.
  /// Kept for any future filtered views; not used in the main display path.
  static List<FirewallRule> filterAutomationRules(List<FirewallRule> rules) {
    return rules.where((rule) => !rule.isSystemGenerated).toList();
  }

  /// Group rules by interface, sorted ascending by sort_order within each group.
  /// Rules with an empty interfaceName are placed under [kFloatingInterfaceKey].
  /// The returned map's keys are sorted alphabetically.
  static Map<String, List<FirewallRule>> groupByInterface(
      List<FirewallRule> rules) {
    // Sort: user-created rules first (alphabetically by description),
    // then automatic rules (alphabetically by description).
    final sorted = List<FirewallRule>.from(rules)
      ..sort((a, b) {
        final aAuto = a.isSystemGenerated ? 1 : 0;
        final bAuto = b.isSystemGenerated ? 1 : 0;
        if (aAuto != bAuto) return aAuto.compareTo(bAuto);
        return a.description.toLowerCase().compareTo(b.description.toLowerCase());
      });

    final Map<String, List<FirewallRule>> rulesByInterface = {};

    for (final rule in sorted) {
      // Normalise to lowercase so 'LAN' and 'lan' collapse into one bucket.
      final name = rule.interfaceName.toLowerCase();
      final key = name.isEmpty ? kFloatingInterfaceKey : name;
      rulesByInterface.putIfAbsent(key, () => []).add(rule);
    }

    // Return keys in alphabetical order.
    final sortedKeys = rulesByInterface.keys.toList()..sort();
    return {for (final k in sortedKeys) k: rulesByInterface[k]!};
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

  /// Group all rules by interface (no filtering — automatic rules are included)
  static Map<String, List<FirewallRule>> filterAndGroup(
      List<FirewallRule> allRules) {
    return groupByInterface(allRules);
  }
}
