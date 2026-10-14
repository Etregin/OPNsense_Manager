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

/// Canonical key used for automatic (system-generated) rules.
const String kAutomaticInterfaceKey = '(automatic)';

/// Utility class for filtering and grouping firewall rules
class FirewallRuleFilter {
  /// Filter rules to show only user-created (non-system-generated) rules.
  static List<FirewallRule> filterAutomationRules(List<FirewallRule> rules) {
    return rules.where((rule) => !rule.isSystemGenerated).toList();
  }

  /// Get automatic (system-generated) rules, sorted ascending by sort_order
  /// (`<prio_group>.<sequence>`), with unparseable sort_orders placed last and
  /// original list order preserved for ties.
  static List<FirewallRule> automaticRules(List<FirewallRule> rules) {
    final autoRules = rules.where((rule) => rule.isSystemGenerated).toList();
    return _sortBySortOrder(autoRules);
  }

  /// Group user-created rules by interface, sorted ascending by sort_order
  /// (`<prio_group>.<sequence>`) within each group, with unparseable sort_orders
  /// placed last and original list order preserved for ties.
  /// Rules with an empty interfaceName are placed under [kFloatingInterfaceKey].
  /// Automatic (system-generated) rules are excluded from all interface buckets.
  /// The returned map's keys are sorted alphabetically.
  static Map<String, List<FirewallRule>> groupByInterface(
      List<FirewallRule> rules) {
    final userRules = rules.where((rule) => !rule.isSystemGenerated).toList();
    final sorted = _sortBySortOrder(userRules);

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

  /// Group user-created rules by interface (excludes automatic rules).
  static Map<String, List<FirewallRule>> filterAndGroup(
      List<FirewallRule> allRules) {
    return groupByInterface(allRules);
  }

  /// Sorts a list of rules ascending by parsed sort_order (`<prio_group>.<sequence>`).
  /// Rules with empty or invalid sort_order sort last.
  /// Ties and invalid sort_orders maintain their original relative order.
  static List<FirewallRule> _sortBySortOrder(List<FirewallRule> rules) {
    final indexed = rules.asMap().entries.toList();
    indexed.sort((a, b) {
      final keyA = _SortKey.tryParse(a.value.sortOrder);
      final keyB = _SortKey.tryParse(b.value.sortOrder);
      if (keyA != null && keyB != null) {
        final keyComp = keyA.compareTo(keyB);
        if (keyComp != 0) return keyComp;
      } else if (keyA != null) {
        return -1;
      } else if (keyB != null) {
        return 1;
      }
      return a.key.compareTo(b.key);
    });
    return indexed.map((e) => e.value).toList();
  }
}

/// Parsed representation of a firewall rule's sort_order (`<prio_group>.<sequence>`).
class _SortKey implements Comparable<_SortKey> {
  final int prioGroup;
  final int sequence;

  const _SortKey(this.prioGroup, this.sequence);

  static _SortKey? tryParse(String sortOrder) {
    if (sortOrder.isEmpty) return null;
    final parts = sortOrder.split('.');
    if (parts.length != 2) return null;
    final prioGroup = int.tryParse(parts[0]);
    final sequence = int.tryParse(parts[1]);
    if (prioGroup == null || sequence == null) return null;
    return _SortKey(prioGroup, sequence);
  }

  @override
  int compareTo(_SortKey other) {
    final prioDiff = prioGroup.compareTo(other.prioGroup);
    if (prioDiff != 0) return prioDiff;
    return sequence.compareTo(other.sequence);
  }
}
