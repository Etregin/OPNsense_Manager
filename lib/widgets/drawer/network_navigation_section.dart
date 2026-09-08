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
import 'package:provider/provider.dart';
import '../../constants/routes.dart';
import '../../l10n/app_localizations.dart';
import '../../screens/dhcp_leases_screen.dart';
import '../../screens/neighbor_discovery_screen.dart';
import '../../screens/wol_screen.dart';
import '../../services/demo_api_service.dart';
import 'navigation_tile.dart';

/// Network navigation section for the app drawer
class NetworkNavigationSection extends StatefulWidget {
  final String currentRoute;

  const NetworkNavigationSection({
    super.key,
    required this.currentRoute,
  });

  @override
  State<NetworkNavigationSection> createState() => _NetworkNavigationSectionState();
}

class _NetworkNavigationSectionState extends State<NetworkNavigationSection> {
  bool _wolPluginAvailable = false;
  bool _loadingWolStatus = true;

  @override
  void initState() {
    super.initState();
    _checkWolAvailability();
  }

  Future<void> _checkWolAvailability() async {
    if (!mounted) return;

    try {
      final apiService = context.read<DemoApiService>();
      final isAvailable = await apiService.isWolPluginAvailable();
      
      if (mounted) {
        setState(() {
          _wolPluginAvailable = isAvailable;
          _loadingWolStatus = false;
        });
      }
    } catch (e) {
      // On error, assume plugin is not available
      if (mounted) {
        setState(() {
          _wolPluginAvailable = false;
          _loadingWolStatus = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        NavigationTile(
          icon: Icons.dns,
          title: l10n.dhcpLeases,
          currentRoute: widget.currentRoute,
          targetRoute: Routes.dhcpLeases,
          destination: const DhcpLeasesScreen(),
        ),
        NavigationTile(
          icon: Icons.devices,
          title: l10n.neighborDiscovery,
          currentRoute: widget.currentRoute,
          targetRoute: Routes.neighborDiscovery,
          destination: const NeighborDiscoveryScreen(),
        ),
        // Only show WOL tile if plugin is available and not loading
        if (!_loadingWolStatus && _wolPluginAvailable)
          NavigationTile(
            icon: Icons.power_settings_new,
            title: l10n.wakeOnLan,
            currentRoute: widget.currentRoute,
            targetRoute: Routes.wol,
            destination: const WolScreen(),
          ),
      ],
    );
  }
}


