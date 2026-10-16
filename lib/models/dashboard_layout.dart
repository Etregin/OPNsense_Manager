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

/// Identifies each configurable card on the dashboard.
enum DashboardCardType {
  cpuUsage,
  memoryUsage,
  diskUsage,
  thermalSensors,
  services,
  gateways,
  networkTotals,
  topDevices,
}

/// Configuration for a single dashboard card — its visibility, order, and
/// (for network cards) the interface it monitors.
class DashboardCardConfig {
  final DashboardCardType type;
  final bool isVisible;

  /// Only meaningful for [DashboardCardType.networkTotals] and
  /// [DashboardCardType.topDevices]. Defaults to `'lan'`.
  final String? selectedInterface;

  const DashboardCardConfig({
    required this.type,
    required this.isVisible,
    this.selectedInterface,
  });

  DashboardCardConfig copyWith({
    bool? isVisible,
    String? selectedInterface,
  }) {
    return DashboardCardConfig(
      type: type,
      isVisible: isVisible ?? this.isVisible,
      selectedInterface: selectedInterface ?? this.selectedInterface,
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type.name,
        'isVisible': isVisible,
        if (selectedInterface != null) 'selectedInterface': selectedInterface,
      };

  factory DashboardCardConfig.fromJson(Map<String, dynamic> json) {
    final typeName = json['type'] as String? ?? '';
    final type = DashboardCardType.values.firstWhere(
      (e) => e.name == typeName,
      orElse: () => DashboardCardType.cpuUsage,
    );
    return DashboardCardConfig(
      type: type,
      isVisible: json['isVisible'] as bool? ?? true,
      selectedInterface: json['selectedInterface'] as String?,
    );
  }
}

/// The full ordered list of dashboard card configs for one profile.
class DashboardLayout {
  final List<DashboardCardConfig> cards;

  const DashboardLayout({required this.cards});

  /// Default layout matching the original hardcoded order with all cards visible.
  factory DashboardLayout.defaults() => const DashboardLayout(
        cards: [
          DashboardCardConfig(type: DashboardCardType.cpuUsage, isVisible: true),
          DashboardCardConfig(type: DashboardCardType.memoryUsage, isVisible: true),
          DashboardCardConfig(type: DashboardCardType.diskUsage, isVisible: true),
          DashboardCardConfig(type: DashboardCardType.thermalSensors, isVisible: true),
          DashboardCardConfig(type: DashboardCardType.services, isVisible: true),
          DashboardCardConfig(type: DashboardCardType.gateways, isVisible: true),
          DashboardCardConfig(
            type: DashboardCardType.networkTotals,
            isVisible: true,
            selectedInterface: 'lan',
          ),
          DashboardCardConfig(
            type: DashboardCardType.topDevices,
            isVisible: true,
            selectedInterface: 'lan',
          ),
        ],
      );

  /// Returns only the cards that are visible.
  List<DashboardCardConfig> get visibleCards =>
      cards.where((c) => c.isVisible).toList();

  DashboardLayout copyWithUpdatedCard(DashboardCardConfig updated) {
    return DashboardLayout(
      cards: cards
          .map((c) => c.type == updated.type ? updated : c)
          .toList(),
    );
  }

  /// Reorders cards. [newIndex] is the final position after the item at
  /// [oldIndex] has been conceptually removed (as provided by
  /// [ReorderableListView.onReorderItem]).
  DashboardLayout copyWithReorder(int oldIndex, int newIndex) {
    final list = List<DashboardCardConfig>.from(cards);
    final item = list.removeAt(oldIndex);
    list.insert(newIndex, item);
    return DashboardLayout(cards: list);
  }

  Map<String, dynamic> toJson() => {
        'cards': cards.map((c) => c.toJson()).toList(),
      };

  factory DashboardLayout.fromJson(Map<String, dynamic> json) {
    final rawCards = json['cards'] as List<dynamic>? ?? [];
    final cards = rawCards
        .map((c) => DashboardCardConfig.fromJson(c as Map<String, dynamic>))
        .toList();
    return DashboardLayout(cards: cards);
  }

  /// Merges this layout with the defaults, appending any card types that are
  /// missing (e.g. new cards added after a user's layout was saved).
  DashboardLayout mergedWithDefaults() {
    final existingTypes = cards.map((c) => c.type).toSet();
    final missing = DashboardLayout.defaults()
        .cards
        .where((c) => !existingTypes.contains(c.type))
        .toList();
    if (missing.isEmpty) return this;
    return DashboardLayout(cards: [...cards, ...missing]);
  }
}
