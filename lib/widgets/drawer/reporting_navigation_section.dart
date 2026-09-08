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
import '../../constants/routes.dart';
import '../../l10n/app_localizations.dart';
import '../../screens/live_network_monitor_screen.dart';
import '../../screens/netflow_screen.dart';
import '../../screens/network_insight_screen.dart';
import '../../screens/unbound_dns_screen.dart';
import 'expansion_navigation_tile.dart';
import 'navigation_tile.dart';

/// Reporting navigation section for the app drawer.
///
/// Contains the Live Network Monitor and Network Insight sub-screens,
/// grouped under an expandable "Reporting" tile.
class ReportingNavigationSection extends StatelessWidget {
  final String currentRoute;
  final bool isExpanded;
  final ValueChanged<bool> onExpansionChanged;

  const ReportingNavigationSection({
    super.key,
    required this.currentRoute,
    required this.isExpanded,
    required this.onExpansionChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ExpansionNavigationTile(
      icon: Icons.bar_chart,
      title: Text(l10n.reporting),
      initiallyExpanded: isExpanded,
      onExpansionChanged: onExpansionChanged,
      children: [
        NavigationTile(
          title: l10n.liveNetworkMonitor,
          currentRoute: currentRoute,
          targetRoute: Routes.liveNetworkMonitor,
          destination: const LiveNetworkMonitorScreen(),
          contentPadding: const EdgeInsets.only(left: 40, right: 16),
        ),
        NavigationTile(
          title: l10n.networkInsight,
          currentRoute: currentRoute,
          targetRoute: Routes.networkInsight,
          destination: const NetworkInsightScreen(),
          contentPadding: const EdgeInsets.only(left: 40, right: 16),
        ),
        NavigationTile(
          title: l10n.netflowConfig,
          currentRoute: currentRoute,
          targetRoute: Routes.netflow,
          destination: const NetflowScreen(),
          contentPadding: const EdgeInsets.only(left: 40, right: 16),
        ),
        NavigationTile(
          title: l10n.unboundDns,
          currentRoute: currentRoute,
          targetRoute: Routes.unboundDns,
          destination: const UnboundDnsScreen(),
          contentPadding: const EdgeInsets.only(left: 40, right: 16),
        ),
      ],
    );
  }
}
