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

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/system_info.dart';
import '../services/demo_api_service.dart';
import '../widgets/app_drawer.dart';
import '../l10n/app_localizations.dart';
import 'vpn/vpn_connections_list_screen.dart';
import 'vpn/tailscale_status_screen.dart';

/// Coordinator screen for VPN connections - routes to specialized screens
class VPNConnectionsScreen extends StatefulWidget {
  final String? vpnType;
  
  const VPNConnectionsScreen({super.key, this.vpnType});

  @override
  State<VPNConnectionsScreen> createState() => _VPNConnectionsScreenState();
}

class _VPNConnectionsScreenState extends State<VPNConnectionsScreen> {
  SystemInfo? _systemInfo;
  bool _isLoading = true;
  Timer? _refreshTimer;
  String _filterType = 'all';

  /// Check if we're in Tailscale-specific mode
  bool get _isTailscaleMode => widget.vpnType == 'tailscale';

  @override
  void initState() {
    super.initState();
    // Set initial filter based on vpnType parameter
    if (widget.vpnType != null) {
      _filterType = widget.vpnType!;
    }
    _loadSystemInfo();
    _startAutoRefresh();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  void _startAutoRefresh() {
    _refreshTimer = Timer.periodic(
      const Duration(seconds: 30),
      (timer) {
        if (mounted) {
          _loadSystemInfo();
        }
      },
    );
  }

  Future<void> _loadSystemInfo() async {
    try {
      final demoApiService = context.read<DemoApiService>();
      final systemInfo = await demoApiService.getSystemInfo();

      if (mounted) {
        setState(() {
          _systemInfo = systemInfo;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.vpnConnections),
        actions: [
          // Hide filter dropdown in Tailscale mode
          if (!_isTailscaleMode)
            PopupMenuButton<String>(
              icon: const Icon(Icons.filter_list),
              tooltip: l10n.filterByType,
              onSelected: (value) {
                setState(() {
                  _filterType = value;
                });
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'all',
                  child: Text(l10n.allVPNs),
                ),
                const PopupMenuItem(
                  value: 'openvpn',
                  child: Text('OpenVPN'),
                ),
                const PopupMenuItem(
                  value: 'wireguard',
                  child: Text('WireGuard'),
                ),
                const PopupMenuItem(
                  value: 'tailscale',
                  child: Text('Tailscale'),
                ),
              ],
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _loadSystemInfo,
            tooltip: l10n.refresh,
          ),
        ],
      ),
      drawer: AppDrawer(
        currentRoute: widget.vpnType != null ? 'vpn_${widget.vpnType}' : 'vpn_connections',
        systemInfo: _systemInfo,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    // Route to appropriate specialized screen
    if (_isTailscaleMode) {
      return RefreshIndicator(
        onRefresh: _loadSystemInfo,
        child: TailscaleStatusScreen(systemInfo: _systemInfo),
      );
    } else {
      return RefreshIndicator(
        onRefresh: _loadSystemInfo,
        child: VPNConnectionsListScreen(
          filterType: _filterType,
          systemInfo: _systemInfo,
        ),
      );
    }
  }
}
