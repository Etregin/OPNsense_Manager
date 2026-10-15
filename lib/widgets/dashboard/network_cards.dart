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

import '../../l10n/app_localizations.dart';
import '../../models/network_host.dart';
import '../../utils/app_colors.dart';
import '../../utils/constants.dart';
import '../../utils/formatters.dart';

/// Dashboard card showing aggregate live download / upload rates across all
/// active hosts on the selected interface.
class NetworkTotalsCard extends StatelessWidget {
  /// Hosts for the currently selected interface. Null means still loading.
  final List<NetworkHost>? hosts;
  final bool isLoading;

  /// Map of interface ID → human label, e.g. `{'lan': 'LAN', 'wan': 'WAN'}`.
  final Map<String, String> availableInterfaces;

  /// The currently selected interface ID.
  final String selectedInterface;

  /// Called when the user picks a different interface.
  final ValueChanged<String> onInterfaceChanged;

  /// Called when the user taps the "View All" link.
  final VoidCallback? onViewAll;

  const NetworkTotalsCard({
    super.key,
    required this.hosts,
    required this.isLoading,
    required this.availableInterfaces,
    required this.selectedInterface,
    required this.onInterfaceChanged,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    final totalDown =
        hosts?.fold<int>(0, (sum, h) => sum + h.rateIn) ?? 0;
    final totalUp =
        hosts?.fold<int>(0, (sum, h) => sum + h.rateOut) ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CardHeader(
          title: l10n.networkTotals,
          icon: Icons.network_check,
          availableInterfaces: availableInterfaces,
          selectedInterface: selectedInterface,
          onInterfaceChanged: onInterfaceChanged,
          onViewAll: onViewAll,
          viewAllLabel: l10n.viewAll,
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.standardPadding),
            child: isLoading && hosts == null
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: CircularProgressIndicator(),
                    ),
                  )
                : hosts == null || hosts!.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Text(
                            l10n.noDataAvailable,
                            style: TextStyle(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: _RateTile(
                              icon: Icons.arrow_downward,
                              iconColor: AppColors.success,
                              label: l10n.totalDownload,
                              value: Formatters.formatBytesPerSecond(totalDown),
                            ),
                          ),
                          const SizedBox(width: AppConstants.standardPadding),
                          Expanded(
                            child: _RateTile(
                              icon: Icons.arrow_upward,
                              iconColor: AppColors.warning,
                              label: l10n.totalUpload,
                              value: Formatters.formatBytesPerSecond(totalUp),
                            ),
                          ),
                        ],
                      ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------

/// Dashboard card showing the top 5 highest-bandwidth devices on the selected
/// interface.
class TopDevicesCard extends StatelessWidget {
  /// Hosts for the currently selected interface. Null means still loading.
  final List<NetworkHost>? hosts;
  final bool isLoading;

  /// Map of interface ID → human label.
  final Map<String, String> availableInterfaces;

  /// The currently selected interface ID.
  final String selectedInterface;

  /// Called when the user picks a different interface.
  final ValueChanged<String> onInterfaceChanged;

  /// Called when the user taps the "View All" link.
  final VoidCallback? onViewAll;

  static const int _maxDevices = 5;

  const TopDevicesCard({
    super.key,
    required this.hosts,
    required this.isLoading,
    required this.availableInterfaces,
    required this.selectedInterface,
    required this.onInterfaceChanged,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    final sorted = hosts == null
        ? null
        : (List<NetworkHost>.from(hosts!)
          ..sort((a, b) => b.totalRate.compareTo(a.totalRate)));
    final top = sorted?.take(_maxDevices).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CardHeader(
          title: l10n.topDevices,
          icon: Icons.devices,
          availableInterfaces: availableInterfaces,
          selectedInterface: selectedInterface,
          onInterfaceChanged: onInterfaceChanged,
          onViewAll: onViewAll,
          viewAllLabel: l10n.viewAll,
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.standardPadding,
              vertical: AppConstants.compactPadding,
            ),
            child: isLoading && hosts == null
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: CircularProgressIndicator(),
                    ),
                  )
                : top == null || top.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Text(
                            l10n.noActiveDevices,
                            style: TextStyle(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      )
                    : Column(
                        children: [
                          // Column headers
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: AppConstants.compactPadding,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: Text(
                                    l10n.deviceName,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                  ),
                                ),
                                SizedBox(
                                  width: 70,
                                  child: Text(
                                    l10n.download,
                                    textAlign: TextAlign.end,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color: AppColors.success,
                                        ),
                                  ),
                                ),
                                const SizedBox(width: AppConstants.compactPadding),
                                SizedBox(
                                  width: 70,
                                  child: Text(
                                    l10n.upload,
                                    textAlign: TextAlign.end,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color: AppColors.warning,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(height: 1),
                          ...top.map((host) => _DeviceRow(host: host)),
                        ],
                      ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Private shared widgets
// ---------------------------------------------------------------------------

/// Shared card header with title, icon, interface selector, and View All link.
class _CardHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Map<String, String> availableInterfaces;
  final String selectedInterface;
  final ValueChanged<String> onInterfaceChanged;
  final VoidCallback? onViewAll;
  final String viewAllLabel;

  const _CardHeader({
    required this.title,
    required this.icon,
    required this.availableInterfaces,
    required this.selectedInterface,
    required this.onInterfaceChanged,
    required this.viewAllLabel,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // Fall back to 'lan' if saved interface is no longer in the list.
    final effectiveInterface = availableInterfaces.containsKey(selectedInterface)
        ? selectedInterface
        : (availableInterfaces.keys.firstOrNull ?? 'lan');

    return Row(
      children: [
        Icon(icon, size: 20, color: colorScheme.primary),
        const SizedBox(width: AppConstants.compactPadding),
        // Flexible so the title shrinks before the right-side controls overflow.
        Flexible(
          child: Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        const SizedBox(width: AppConstants.compactPadding),
        if (availableInterfaces.isNotEmpty)
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 110),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: effectiveInterface,
                isDense: true,
                isExpanded: true,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.primary,
                    ),
                items: availableInterfaces.entries
                    .map(
                      (e) => DropdownMenuItem(
                        value: e.key,
                        child: Text(e.value, overflow: TextOverflow.ellipsis),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) onInterfaceChanged(value);
                },
              ),
            ),
          ),
        if (onViewAll != null) ...[
          const SizedBox(width: 4),
          TextButton(
            onPressed: onViewAll,
            style: TextButton.styleFrom(
              minimumSize: Size.zero,
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.compactPadding,
                vertical: 4,
              ),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(viewAllLabel),
          ),
        ],
      ],
    );
  }
}

/// A labelled rate tile used inside [NetworkTotalsCard].
class _RateTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _RateTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: iconColor),
            const SizedBox(width: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}

/// A single row in [TopDevicesCard] showing hostname and rates.
class _DeviceRow extends StatelessWidget {
  final NetworkHost host;

  const _DeviceRow({required this.host});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppConstants.compactPadding,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Text(
              host.hostname,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          SizedBox(
            width: 70,
            child: Text(
              Formatters.formatBytesPerSecond(host.rateIn),
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.success,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
            ),
          ),
          const SizedBox(width: AppConstants.compactPadding),
          SizedBox(
            width: 70,
            child: Text(
              Formatters.formatBytesPerSecond(host.rateOut),
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.warning,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
