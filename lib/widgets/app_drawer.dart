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
import '../models/system_info.dart';
import '../screens/dashboard_screen.dart';
import '../l10n/app_localizations.dart';
import '../services/navigation/navigation_service.dart';
import 'drawer/drawer_header_widget.dart';
import 'drawer/navigation_tile.dart';
import 'drawer/firewall_navigation_section.dart';
import 'drawer/network_navigation_section.dart';
import 'drawer/vpn_navigation_section.dart';
import 'drawer/system_navigation_section.dart';
import 'drawer/settings_navigation_section.dart';

/// Reusable app drawer for navigation
class AppDrawer extends StatefulWidget {
  final String currentRoute;
  final SystemInfo? systemInfo;
  final Future<bool> Function()? onBeforeNavigate;

  const AppDrawer({
    super.key,
    required this.currentRoute,
    this.systemInfo,
    this.onBeforeNavigate,
  });

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool _firewallExpanded = false;
  bool _vpnExpanded = false;

  @override
  void initState() {
    super.initState();
    // Auto-expand sections based on current route
    _firewallExpanded = NavigationService.isRouteInSection(widget.currentRoute, 'firewall_');
    _vpnExpanded = NavigationService.isRouteInSection(widget.currentRoute, 'vpn_') ||
                   NavigationService.isRouteInSection(widget.currentRoute, 'wireguard_') ||
                   NavigationService.isRouteInSection(widget.currentRoute, 'ipsec_') ||
                   NavigationService.isRouteInSection(widget.currentRoute, 'openvpn_') ||
                   NavigationService.isRouteInSection(widget.currentRoute, 'tailscale_');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Drawer header with app branding
          DrawerHeaderWidget(systemInfo: widget.systemInfo),
          
          // Dashboard navigation
          NavigationTile(
            icon: Icons.dashboard,
            title: l10n.dashboard,
            currentRoute: widget.currentRoute,
            targetRoute: 'dashboard',
            destination: const DashboardScreen(),
          ),
          
          const Divider(),
          
          // System navigation section
          SystemNavigationSection(
            currentRoute: widget.currentRoute,
            onBeforeNavigate: widget.onBeforeNavigate,
          ),
          
          // Firewall navigation section
          FirewallNavigationSection(
            currentRoute: widget.currentRoute,
            isExpanded: _firewallExpanded,
            onExpansionChanged: (expanded) {
              setState(() {
                _firewallExpanded = expanded;
              });
            },
          ),
          
          // Network navigation section
          NetworkNavigationSection(
            currentRoute: widget.currentRoute,
          ),
          
          // VPN navigation section
          VPNNavigationSection(
            currentRoute: widget.currentRoute,
            isExpanded: _vpnExpanded,
            onExpansionChanged: (expanded) {
              setState(() {
                _vpnExpanded = expanded;
              });
            },
            onBeforeNavigate: widget.onBeforeNavigate,
          ),
          
          const Divider(),
          
          // Settings navigation section
          SettingsNavigationSection(
            currentRoute: widget.currentRoute,
          ),
        ],
      ),
    );
  }
}


