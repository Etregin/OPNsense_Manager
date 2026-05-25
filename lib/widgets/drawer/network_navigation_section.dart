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
import '../../screens/live_network_monitor_screen.dart';
import '../../screens/dhcp_leases_screen.dart';
import '../../screens/wol_screen.dart';
import 'navigation_tile.dart';

/// Network navigation section for the app drawer
class NetworkNavigationSection extends StatelessWidget {
  final String currentRoute;

  const NetworkNavigationSection({
    super.key,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        NavigationTile(
          icon: Icons.network_check,
          title: l10n.liveNetworkMonitor,
          currentRoute: currentRoute,
          targetRoute: 'live_network_monitor',
          destination: const LiveNetworkMonitorScreen(),
        ),
        NavigationTile(
          icon: Icons.dns,
          title: l10n.dhcpLeases,
          currentRoute: currentRoute,
          targetRoute: 'dhcp_leases',
          destination: const DhcpLeasesScreen(),
        ),
        NavigationTile(
          icon: Icons.power_settings_new,
          title: 'Wake-on-LAN',
          currentRoute: currentRoute,
          targetRoute: 'wol',
          destination: const WolScreen(),
        ),
      ],
    );
  }
}


