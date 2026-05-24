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
import '../../models/vpn_connection.dart';
import '../../screens/wireguard_servers_screen.dart';
import '../../screens/wireguard_peers_screen.dart';
import '../../screens/wireguard_peer_generator_screen.dart';
import '../../screens/wireguard_status_screen.dart';
import '../../screens/wireguard_log_file_screen.dart';
import '../../screens/tailscale_authentication_screen.dart';
import '../../screens/tailscale_settings_screen.dart';
import '../../screens/tailscale_status_screen.dart';
import '../../services/opnsense_api_service.dart';
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

  @override
  void initState() {
    super.initState();
    // Auto-expand sub-sections based on current route
    _wireguardExpanded = NavigationService.isRouteInSection(widget.currentRoute, 'wireguard_');
    _openvpnExpanded = NavigationService.isRouteInSection(widget.currentRoute, 'openvpn_');
    _tailscaleExpanded = NavigationService.isRouteInSection(widget.currentRoute, 'tailscale_');
    
    // Load Tailscale status
    _loadTailscaleStatus();
  }

  Future<void> _loadTailscaleStatus() async {
    if (!mounted) return;
    
    setState(() {
      _loadingTailscale = true;
    });

    try {
      final apiService = context.read<OPNsenseApiService>();
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
    return ExpansionNavigationTile(
      icon: Icons.vpn_lock,
      title: const Text('VPN'),
      initiallyExpanded: widget.isExpanded,
      onExpansionChanged: widget.onExpansionChanged,
      children: [
        // WireGuard nested section
        _buildWireGuardSection(),
        
        // OpenVPN nested section
        _buildOpenVPNSection(),
        
        // Tailscale nested section
        _buildTailscaleSection(),
      ],
    );
  }

  Widget _buildWireGuardSection() {
    return ExpansionNavigationTile(
      icon: Icons.vpn_key,
      title: const Text('WireGuard'),
      initiallyExpanded: _wireguardExpanded,
      tilePadding: const EdgeInsets.only(left: 56, right: 16),
      onExpansionChanged: (expanded) {
        setState(() {
          _wireguardExpanded = expanded;
        });
      },
      children: [
        NavigationTile(
          title: 'Servers',
          currentRoute: widget.currentRoute,
          targetRoute: 'wireguard_servers',
          destination: const WireGuardServersScreen(),
          contentPadding: const EdgeInsets.only(left: 96, right: 16),
        ),
        NavigationTile(
          title: 'Peers',
          currentRoute: widget.currentRoute,
          targetRoute: 'wireguard_peers',
          destination: const WireGuardPeersScreen(),
          contentPadding: const EdgeInsets.only(left: 96, right: 16),
        ),
        NavigationTile(
          title: 'Peer Generator',
          currentRoute: widget.currentRoute,
          targetRoute: 'wireguard_peer_generator',
          destination: const WireGuardPeerGeneratorScreen(),
          contentPadding: const EdgeInsets.only(left: 96, right: 16),
        ),
        NavigationTile(
          title: 'Status',
          currentRoute: widget.currentRoute,
          targetRoute: 'wireguard_status',
          destination: const WireGuardStatusScreen(),
          contentPadding: const EdgeInsets.only(left: 96, right: 16),
        ),
        NavigationTile(
          title: 'Logs',
          currentRoute: widget.currentRoute,
          targetRoute: 'wireguard_logs',
          destination: const WireGuardLogFileScreen(),
          contentPadding: const EdgeInsets.only(left: 96, right: 16),
        ),
      ],
    );
  }

  Widget _buildOpenVPNSection() {
    return ExpansionNavigationTile(
      icon: Icons.vpn_lock_outlined,
      title: const Text('OpenVPN'),
      initiallyExpanded: _openvpnExpanded,
      tilePadding: const EdgeInsets.only(left: 56, right: 16),
      onExpansionChanged: (expanded) {
        setState(() {
          _openvpnExpanded = expanded;
        });
      },
      children: [
        NavigationTile(
          title: 'Servers',
          currentRoute: widget.currentRoute,
          targetRoute: 'openvpn_servers',
          contentPadding: const EdgeInsets.only(left: 96, right: 16),
          onTap: () => NavigationService.showComingSoon(context, 'OpenVPN Servers'),
        ),
        NavigationTile(
          title: 'Clients',
          currentRoute: widget.currentRoute,
          targetRoute: 'openvpn_clients',
          contentPadding: const EdgeInsets.only(left: 96, right: 16),
          onTap: () => NavigationService.showComingSoon(context, 'OpenVPN Clients'),
        ),
        NavigationTile(
          title: 'Client Overrides',
          currentRoute: widget.currentRoute,
          targetRoute: 'openvpn_client_overrides',
          contentPadding: const EdgeInsets.only(left: 96, right: 16),
          onTap: () => NavigationService.showComingSoon(context, 'OpenVPN Client Overrides'),
        ),
      ],
    );
  }

  Widget _buildTailscaleSection() {
    return ExpansionNavigationTile(
      icon: Icons.cloud,
      title: Row(
        children: [
          const Expanded(
            child: Text(
              'Tailscale',
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
          title: 'Authentication',
          currentRoute: widget.currentRoute,
          targetRoute: 'tailscale_authentication',
          destination: const TailscaleAuthenticationScreen(),
          contentPadding: const EdgeInsets.only(left: 96, right: 16),
          onBeforeNavigate: widget.onBeforeNavigate,
        ),
        NavigationTile(
          title: 'Settings',
          currentRoute: widget.currentRoute,
          targetRoute: 'tailscale_settings',
          destination: const TailscaleSettingsScreen(),
          contentPadding: const EdgeInsets.only(left: 96, right: 16),
        ),
        NavigationTile(
          title: 'Status',
          currentRoute: widget.currentRoute,
          targetRoute: 'tailscale_status',
          destination: const TailscaleStatusScreen(),
          contentPadding: const EdgeInsets.only(left: 96, right: 16),
        ),
      ],
    );
  }

  Widget _buildTailscaleStatusBadge() {
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
          _tailscaleStatus!.isConnected ? 'Connected' : 'Disconnected',
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
        'Unknown',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.orange.shade700,
        ),
      ),
    );
  }
}


