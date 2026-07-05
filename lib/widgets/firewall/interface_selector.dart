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

import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../l10n/app_localizations.dart';
import 'rule_filter_chip.dart';

/// Widget for selecting firewall rule interfaces
class InterfaceSelector extends StatelessWidget {
  final Map<String, int> interfaceRuleCounts;
  final String? selectedInterface;
  final ValueChanged<String> onInterfaceSelected;

  const InterfaceSelector({
    super.key,
    required this.interfaceRuleCounts,
    required this.selectedInterface,
    required this.onInterfaceSelected,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppConstants.standardPadding),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outlineVariant,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.selectInterface,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: interfaceRuleCounts.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: RuleFilterChip(
                    label: entry.key,
                    count: entry.value,
                    isSelected: entry.key == selectedInterface,
                    onSelected: () => onInterfaceSelected(entry.key),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}


