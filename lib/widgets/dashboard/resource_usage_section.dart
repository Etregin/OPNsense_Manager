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
import '../../models/disk_device.dart';
import '../../models/system_info.dart';
import '../../utils/app_colors.dart';
import '../../utils/color_helpers.dart';
import '../../utils/constants.dart';
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
          l10n.cpuUsage,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        _buildResourceCards(context, l10n),
      ],
    );
  }

  Widget _buildResourceCards(BuildContext context, AppLocalizations l10n) {
    return Column(
      children: [
        // CPU Usage
        ProgressStatCard(
          title: l10n.cpuUsage,
          value: '${systemInfo.cpuUsage.toStringAsFixed(1)}%',
          progress: systemInfo.cpuUsage / 100,
          icon: Icons.speed,
        ),
        const SizedBox(height: 12),

        // Memory Usage with ARC visualization
        StackedProgressStatCard(
          title: l10n.memoryUsage,
          value: '${_formatSize(systemInfo.memoryActualUsed)} / '
              '${_formatSize(systemInfo.memoryTotal)}',
          primaryProgress: systemInfo.memoryUsagePercentage / 100,
          secondaryProgress: systemInfo.memoryTotal > 0
              ? (systemInfo.memoryArc / systemInfo.memoryTotal)
              : 0.0,
          icon: Icons.memory,
          primaryLabel: l10n.actualUsed,
          primaryValue: '${systemInfo.memoryUsagePercentage.toStringAsFixed(1)}% '
              '(${_formatSize(systemInfo.memoryActualUsed)})',
          secondaryLabel: systemInfo.memoryArc > 0 ? l10n.arcCache : null,
          secondaryValue: systemInfo.memoryArc > 0
              ? '${((systemInfo.memoryArc / systemInfo.memoryTotal) * 100).toStringAsFixed(1)}% '
                  '(${_formatSize(systemInfo.memoryArc)})'
              : null,
        ),

        // Expandable Disk Usage Card
        if (systemInfo.diskDevices.isNotEmpty) ...[
          const SizedBox(height: 12),
          ExpandableDiskCard(
            diskDevices: systemInfo.diskDevices,
            rootDisk: systemInfo.rootDisk,
          ),
        ],
      ],
    );
  }

  /// Format bytes to a human-readable string (KB/MB/GB).
  String _formatSize(int bytes) {
    if (bytes >= 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    } else if (bytes >= 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
  }
}

/// Expandable card for displaying disk usage.
///
/// When collapsed, it presents the primary `/` filesystem matching [ProgressStatCard] style.
/// When expanded, it reveals all individual filesystems dynamically with their specific details.
class ExpandableDiskCard extends StatefulWidget {
  final List<DiskDevice> diskDevices;
  final DiskDevice? rootDisk;

  const ExpandableDiskCard({
    super.key,
    required this.diskDevices,
    this.rootDisk,
  });

  @override
  State<ExpandableDiskCard> createState() => _ExpandableDiskCardState();
}

class _ExpandableDiskCardState extends State<ExpandableDiskCard> {
  bool _isExpanded = false;

  DiskDevice get _primaryDevice =>
      widget.rootDisk ?? widget.diskDevices.first;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final primary = _primaryDevice;
    final hasMultiple = widget.diskDevices.length > 1;
    final progress = primary.usedPct / 100.0;
    final color = resourceUsageColor(progress);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.standardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row with Icon, Percentage, and optional Expand Toggle
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: AppColors.opacitySubtle),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.storage,
                    color: color,
                    size: 28,
                  ),
                ),
                const Spacer(),
                Text(
                  '${primary.usedPct}%',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                ),
                if (hasMultiple) ...[
                  const SizedBox(width: 4),
                  IconButton(
                    icon: Icon(
                      _isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                    ),
                    tooltip: _isExpanded ? l10n.collapseAll : l10n.expandAll,
                    onPressed: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),

            // Title
            Text(
              l10n.diskUsage,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 4),

            // Value: Primary device used / total + mountpoint
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${primary.used} / ${primary.blocks}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                Text(
                  primary.mountpoint,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Primary Progress Bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                backgroundColor:
                    Theme.of(context).colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 8),

            // Primary subtitle / details
            Text(
              '${primary.available} ${l10n.diskAvailable} · ${primary.type} (${primary.device})',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),

            // Expanded: list of all filesystems
            if (hasMultiple)
              AnimatedSize(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                child: _isExpanded
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Divider(height: 24),
                          ...widget.diskDevices.asMap().entries.map((entry) {
                            final i = entry.key;
                            final device = entry.value;
                            return Column(
                              children: [
                                if (i > 0) const Divider(height: 16),
                                _buildDeviceRow(context, l10n, device),
                              ],
                            );
                          }),
                        ],
                      )
                    : const SizedBox.shrink(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceRow(
      BuildContext context, AppLocalizations l10n, DiskDevice device) {
    final progress = device.usedPct / 100.0;
    final color = resourceUsageColor(progress);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                device.mountpoint,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            Text(
              '${device.used} / ${device.blocks}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(width: 8),
            Text(
              '${device.usedPct}%',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            backgroundColor:
                Theme.of(context).colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${device.available} ${l10n.diskAvailable} · ${device.type} (${device.device})',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onSurfaceVariant
                    .withValues(alpha: AppColors.opacitySubdued),
              ),
        ),
      ],
    );
  }
}


