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
import '../../models/vpn_connection.dart';
import '../../screens/wireguard_servers_screen.dart';
import '../../screens/wireguard_peers_screen.dart';
import '../../screens/wireguard_peer_generator_screen.dart';
import '../../screens/wireguard_status_screen.dart';
import '../../screens/wireguard_log_file_screen.dart';
import '../../screens/openvpn_instances_screen.dart';
import '../../screens/openvpn_log_file_screen.dart';
import '../../screens/tailscale_authentication_screen.dart';
import '../../screens/tailscale_settings_screen.dart';
import '../../screens/tailscale_status_screen.dart';
import '../../services/demo_api_service.dart';
import '../../services/navigation/navigation_service.dart';
import 'expansion_navigation_tile.dart';
import 'navigation_tile.dart';

/// VPN navigation section for the app drawer with nested sub-sections
class VPNNavigationSection extends StatefulWidget {
  final String currentRoute;
  final bool isExpanded;
  final ValueChanged<bool> onExpansionChanged;
  final Future<bool> Function()? onBeforeNavigate;

  const VPNNavigationSection({
    super.key,
    required this.currentRoute,
    required this.isExpanded,
    required this.onExpansionChanged,
    this.onBeforeNavigate,
  });

  @override
  State<VPNNavigationSection> createState() => _VPNNavigationSectionState();
}

class _VPNNavigationSectionState extends State<VPNNavigationSection> {
  bool _wireguardExpanded = false;
  bool _openvpnExpanded = false;
  bool _tailscaleExpanded = false;
  VPNConnection? _tailscaleStatus;
  bool _loadingTailscale = false;
  bool _tailscalePluginAvailable = false;
  bool _loadingTailscaleAvailability = true;

  @override
  void initState() {
    super.initState();
    // Auto-expand sub-sections based on current route
    _wireguardExpanded = NavigationService.isRouteInSection(widget.currentRoute, Routes.wireguardPrefix);
    _openvpnExpanded = NavigationService.isRouteInSection(widget.currentRoute, Routes.openvpnPrefix);
    _tailscaleExpanded = NavigationService.isRouteInSection(widget.currentRoute, Routes.tailscalePrefix);
    
    // Check Tailscale plugin availability
    _checkTailscaleAvailability();
    
    // Load Tailscale status
    _loadTailscaleStatus();
  }

  @override
  void didUpdateWidget(VPNNavigationSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only update expansion state if the parent VPN section expansion changed
    // Don't reset sub-section expansion when navigating to other screens
    if (oldWidget.isExpanded != widget.isExpanded && !widget.isExpanded) {
      // If parent VPN section is collapsed, collapse all sub-sections
      setState(() {
        _wireguardExpanded = false;
        _openvpnExpanded = false;
        _tailscaleExpanded = false;
      });
    }
  }

  Future<void> _checkTailscaleAvailability() async {
    if (!mounted) return;

    try {
      final apiService = context.read<DemoApiService>();
      final isAvailable = await apiService.isTailscalePluginAvailable();
      
      if (mounted) {
        setState(() {
          _tailscalePluginAvailable = isAvailable;
          _loadingTailscaleAvailability = false;
        });
      }
    } catch (e) {
      // On error, assume plugin is not available
      if (mounted) {
        setState(() {
          _tailscalePluginAvailable = false;
          _loadingTailscaleAvailability = false;
        });
      }
    }
  }

  Future<void> _loadTailscaleStatus() async {
    if (!mounted) return;
    
    setState(() {
      _loadingTailscale = true;
    });

    try {
      final apiService = context.read<DemoApiService>();
      final status = await apiService.getTailscaleStatus();
      
      if (mounted) {
        setState(() {
          _tailscaleStatus = status;
          _loadingTailscale = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _tailscaleStatus = null;
          _loadingTailscale = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ExpansionNavigationTile(
      icon: Icons.vpn_lock,
      title: Text(l10n.vpn),
      initiallyExpanded: widget.isExpanded,
      onExpansionChanged: widget.onExpansionChanged,
      children: [
        // WireGuard nested section
        _buildWireGuardSection(),
        
        // OpenVPN nested section
        _buildOpenVPNSection(),
        
        // Tailscale nested section - only show if plugin is available and not loading
        if (!_loadingTailscaleAvailability && _tailscalePluginAvailable)
          _buildTailscaleSection(),
      ],
    );
  }

  Widget _buildWireGuardSection() {
    final l10n = AppLocalizations.of(context)!;
    return ExpansionNavigationTile(
      icon: Icons.vpn_key,
      title: Text(l10n.wireguard),
      initiallyExpanded: _wireguardExpanded,
      tilePadding: const EdgeInsets.only(left: 56, right: 16),
      onExpansionChanged: (expanded) {
        setState(() {
          _wireguardExpanded = expanded;
        });
      },
      children: [
        NavigationTile(
          title: l10n.servers,
          currentRoute: widget.currentRoute,
          targetRoute: Routes.wireguardServers,
          destination: const WireGuardServersScreen(),
          contentPadding: const EdgeInsets.only(left: 96, right: 16),
        ),
        NavigationTile(
          title: l10n.peers,
          currentRoute: widget.currentRoute,
          targetRoute: Routes.wireguardPeers,
          destination: const WireGuardPeersScreen(),
          contentPadding: const EdgeInsets.only(left: 96, right: 16),
        ),
        NavigationTile(
          title: l10n.peerGenerator,
          currentRoute: widget.currentRoute,
          targetRoute: Routes.wireguardPeerGenerator,
          destination: const WireGuardPeerGeneratorScreen(),
          contentPadding: const EdgeInsets.only(left: 96, right: 16),
        ),
        NavigationTile(
          title: l10n.status,
          currentRoute: widget.currentRoute,
          targetRoute: Routes.wireguardStatus,
          destination: const WireGuardStatusScreen(),
          contentPadding: const EdgeInsets.only(left: 96, right: 16),
        ),
        NavigationTile(
          title: l10n.logs,
          currentRoute: widget.currentRoute,
          targetRoute: Routes.wireguardLogs,
          destination: const WireGuardLogFileScreen(),
          contentPadding: const EdgeInsets.only(left: 96, right: 16),
        ),
      ],
    );
  }

  Widget _buildOpenVPNSection() {
    final l10n = AppLocalizations.of(context)!;
    return ExpansionNavigationTile(
      icon: Icons.vpn_lock_outlined,
      title: Text(l10n.openvpn),
      initiallyExpanded: _openvpnExpanded,
      tilePadding: const EdgeInsets.only(left: 56, right: 16),
      onExpansionChanged: (expanded) {
        setState(() {
          _openvpnExpanded = expanded;
        });
      },
      children: [
        NavigationTile(
          title: l10n.instances,
          currentRoute: widget.currentRoute,
          targetRoute: Routes.openvpnInstances,
          destination: const OpenvpnInstancesScreen(),
          contentPadding: const EdgeInsets.only(left: 96, right: 16),
        ),
        NavigationTile(
          title: l10n.clientOverrides,
          currentRoute: widget.currentRoute,
          targetRoute: Routes.openvpnClientOverrides,
          onTap: () {
            if (widget.currentRoute != Routes.openvpnClientOverrides) {
              Navigator.of(context).pushReplacementNamed('/openvpn/client-overrides');
            } else {
              Navigator.pop(context);
            }
          },
          contentPadding: const EdgeInsets.only(left: 96, right: 16),
        ),
        NavigationTile(
          title: l10n.connectionStatus,
          currentRoute: widget.currentRoute,
          targetRoute: Routes.openvpnConnectionStatus,
          onTap: () {
            if (widget.currentRoute != Routes.openvpnConnectionStatus) {
              Navigator.of(context).pushReplacementNamed('/openvpn/connection-status');
            } else {
              Navigator.pop(context);
            }
          },
          contentPadding: const EdgeInsets.only(left: 96, right: 16),
        ),
        NavigationTile(
          title: l10n.logFile,
          currentRoute: widget.currentRoute,
          targetRoute: Routes.openvpnLogs,
          destination: const OpenvpnLogFileScreen(),
          contentPadding: const EdgeInsets.only(left: 96, right: 16),
        ),
      ],
    );
  }

  Widget _buildTailscaleSection() {
    final l10n = AppLocalizations.of(context)!;
    return ExpansionNavigationTile(
      icon: Icons.cloud,
      title: Row(
        children: [
          Expanded(
            child: Text(
              l10n.tailscale,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          _buildTailscaleStatusBadge(),
        ],
      ),
      initiallyExpanded: _tailscaleExpanded,
      tilePadding: const EdgeInsets.only(left: 56, right: 16),
      onExpansionChanged: (expanded) {
        setState(() {
          _tailscaleExpanded = expanded;
        });
      },
      children: [
        NavigationTile(
          title: l10n.authentication,
          currentRoute: widget.currentRoute,
          targetRoute: Routes.tailscaleAuthentication,
          destination: const TailscaleAuthenticationScreen(),
          contentPadding: const EdgeInsets.only(left: 96, right: 16),
          onBeforeNavigate: widget.onBeforeNavigate,
        ),
        NavigationTile(
          title: l10n.settings,
          currentRoute: widget.currentRoute,
          targetRoute: Routes.tailscaleSettings,
          destination: const TailscaleSettingsScreen(),
          contentPadding: const EdgeInsets.only(left: 96, right: 16),
        ),
        NavigationTile(
          title: l10n.status,
          currentRoute: widget.currentRoute,
          targetRoute: Routes.tailscaleStatus,
          destination: const TailscaleStatusScreen(),
          contentPadding: const EdgeInsets.only(left: 96, right: 16),
        ),
      ],
    );
  }

  Widget _buildTailscaleStatusBadge() {
    final l10n = AppLocalizations.of(context)!;
    if (_loadingTailscale) {
      return const SizedBox(
        width: 12,
        height: 12,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    if (_tailscaleStatus != null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: _tailscaleStatus!.isConnected
              ? Colors.green.withValues(alpha: 0.2)
              : Colors.grey.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _tailscaleStatus!.isConnected
                ? Colors.green
                : Colors.grey,
            width: 1,
          ),
        ),
        child: Text(
          _tailscaleStatus!.isConnected ? l10n.connected : l10n.disconnected,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: _tailscaleStatus!.isConnected
                ? Colors.green.shade700
                : Colors.grey.shade700,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.orange,
          width: 1,
        ),
      ),
      child: Text(
        l10n.unknown,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.orange.shade700,
        ),
      ),
    );
  }
}


