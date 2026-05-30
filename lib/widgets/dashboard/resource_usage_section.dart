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
import '../../models/system_info.dart';
import '../../utils/formatters.dart';
import '../../widgets/stat_card.dart';
import '../../l10n/app_localizations.dart';

/// Widget for displaying resource usage (CPU, Memory, Disk)
class ResourceUsageSection extends StatelessWidget {
  final SystemInfo systemInfo;

  const ResourceUsageSection({
    super.key,
    required this.systemInfo,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${l10n.cpuUsage} / ${l10n.memoryUsage}',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        _buildResourceCards(context),
      ],
    );
  }

  Widget _buildResourceCards(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        // CPU Usage
        ProgressStatCard(
          title: l10n.cpuUsage,
          value: Formatters.formatPercentage(systemInfo.cpuUsage),
          progress: systemInfo.cpuUsage / 100,
          icon: Icons.speed,
        ),
        const SizedBox(height: 12),

        // Memory Usage with ARC visualization
        StackedProgressStatCard(
          title: l10n.memoryUsage,
          value: '${Formatters.formatMemoryGB(systemInfo.memoryActualUsed, context)} / '
              '${Formatters.formatMemoryGB(systemInfo.memoryTotal, context)}',
          primaryProgress: systemInfo.memoryUsagePercentage / 100,
          secondaryProgress: systemInfo.memoryTotal > 0
              ? (systemInfo.memoryArc / systemInfo.memoryTotal)
              : 0.0,
          icon: Icons.memory,
          primaryLabel: 'Actual Used',
          primaryValue: '${Formatters.formatPercentage(systemInfo.memoryUsagePercentage)} '
              '(${Formatters.formatMemoryGB(systemInfo.memoryActualUsed, context)})',
          secondaryLabel: systemInfo.memoryArc > 0 ? 'ARC Cache' : null,
          secondaryValue: systemInfo.memoryArc > 0
              ? '${Formatters.formatPercentage((systemInfo.memoryArc / systemInfo.memoryTotal) * 100)} '
                  '(${Formatters.formatMemoryGB(systemInfo.memoryArc, context)})'
              : null,
        ),
        const SizedBox(height: 12),

        // Disk Usage
        if (systemInfo.diskTotal > 0)
          ProgressStatCard(
            title: l10n.diskUsage,
            value: '${Formatters.formatMemoryGB(systemInfo.diskUsed, context)} / '
                '${Formatters.formatMemoryGB(systemInfo.diskTotal, context)}',
            progress: systemInfo.diskUsagePercentage / 100,
            icon: Icons.storage,
            subtitle: Formatters.formatPercentage(
              systemInfo.diskUsagePercentage,
            ),
          ),
      ],
    );
  }
}


