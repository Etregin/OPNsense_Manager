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
import '../services/demo_api_service.dart';
import '../utils/auto_refresh_mixin.dart';
import '../utils/constants.dart';
import '../viewmodels/vpn_connections_view_model.dart';
import '../widgets/app_drawer.dart';
import '../l10n/app_localizations.dart';
import 'vpn/vpn_connections_list_screen.dart';
import 'vpn/tailscale_status_screen.dart' show TailscaleStatusPanel;

/// Coordinator screen for VPN connections - routes to specialized screens
class VPNConnectionsScreen extends StatefulWidget {
  final String? vpnType;

  const VPNConnectionsScreen({super.key, this.vpnType});

  @override
  State<VPNConnectionsScreen> createState() => _VPNConnectionsScreenState();
}

class _VPNConnectionsScreenState extends State<VPNConnectionsScreen>
    with AutoRefreshMixin {
  late VpnConnectionsViewModel _viewModel;
  bool _isInitialized = false;
  String _filterType = 'all';

  /// Check if we're in Tailscale-specific mode
  bool get _isTailscaleMode => widget.vpnType == 'tailscale';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      if (widget.vpnType != null) {
        _filterType = widget.vpnType!;
      }
      final apiService = context.read<DemoApiService>();
      _viewModel = VpnConnectionsViewModel(apiService);
      _isInitialized = true;
      _viewModel.loadItems();
      startAutoRefresh(AppConstants.dashboardRefreshInterval, _viewModel.loadItems);
    }
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
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
                      child: Text(l10n.allVpns),
                    ),
                    const PopupMenuItem(
                      value: 'openvpn',
                      child: Text(StringConstants.openvpn),
                    ),
                    const PopupMenuItem(
                      value: 'wireguard',
                      child: Text(StringConstants.wireguard),
                    ),
                    const PopupMenuItem(
                      value: 'tailscale',
                      child: Text(StringConstants.tailscale),
                    ),
                  ],
                ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _viewModel.isLoading ? null : _viewModel.loadItems,
                tooltip: l10n.refresh,
              ),
            ],
          ),
          drawer: AppDrawer(
            currentRoute: widget.vpnType != null
                ? 'vpn_${widget.vpnType}'
                : 'vpn_connections',
            systemInfo: _viewModel.systemInfo,
          ),
          body: _buildBody(),
        );
      },
    );
  }

  Widget _buildBody() {
    // Route to appropriate specialized screen
    if (_isTailscaleMode) {
      return RefreshIndicator(
        onRefresh: _viewModel.loadItems,
        child: const TailscaleStatusPanel(),
      );
    } else {
      return RefreshIndicator(
        onRefresh: _viewModel.loadItems,
        child: VPNConnectionsListScreen(
          filterType: _filterType,
          systemInfo: _viewModel.systemInfo,
        ),
      );
    }
  }
}
