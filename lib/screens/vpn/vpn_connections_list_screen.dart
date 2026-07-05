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
import '../../models/vpn_connection.dart';
import '../../models/system_info.dart';
import '../../services/demo_api_service.dart';
import '../../services/vpn/vpn_connection_manager.dart';
import '../../utils/snackbar_helper.dart';
import '../../utils/constants.dart';
import '../../widgets/common/confirmation_dialog.dart';
import '../../widgets/vpn/vpn_connection_card.dart';
import '../../widgets/vpn/vpn_summary_cards.dart';
import '../../l10n/app_localizations.dart';
import '../wireguard_servers_screen.dart';

/// Screen for displaying and managing VPN connections list
class VPNConnectionsListScreen extends StatefulWidget {
  final String filterType;
  final SystemInfo? systemInfo;

  const VPNConnectionsListScreen({
    super.key,
    this.filterType = 'all',
    this.systemInfo,
  });

  @override
  State<VPNConnectionsListScreen> createState() => _VPNConnectionsListScreenState();
}

class _VPNConnectionsListScreenState extends State<VPNConnectionsListScreen> {
  List<VPNConnection> _connections = [];
  bool _isLoading = true;
  String? _errorMessage;
  Timer? _refreshTimer;
  late VPNConnectionManager _connectionManager;
  String _filterType = 'all';

  @override
  void initState() {
    super.initState();
    _filterType = widget.filterType;
    final demoApiService = context.read<DemoApiService>();
    _connectionManager = VPNConnectionManager(demoApiService);
    _loadData();
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
          _loadData();
        }
      },
    );
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await _connectionManager.loadVPNConnections();

      if (mounted) {
        setState(() {
          _connections = data.connections;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _toggleConnection(VPNConnection connection) async {
    final l10n = AppLocalizations.of(context)!;
    final actionTitle = connection.isConnected ? l10n.disconnectVpn : l10n.connectVpn;
    final action = connection.isConnected ? l10n.disconnect : l10n.connect;
    
    final confirmed = await ConfirmationDialog.show(
      context: context,
      title: actionTitle,
      message: '${l10n.deleteRuleConfirmation(connection.name).split('"')[0]}"${connection.name}"?',
      confirmText: action,
      cancelText: l10n.cancel,
      isDestructive: connection.isConnected,
    );

    if (confirmed != true || !mounted) return;

    try {
      SnackBarHelper.showInfo(context, connection.isConnected
          ? l10n.disconnectingVPN(connection.name)
          : l10n.connectingVPN(connection.name));

      final success = await _connectionManager.toggleConnection(
        connection.id,
        connection.type,
        connection.isConnected,
      );

      if (mounted) {
        if (success) {
          SnackBarHelper.showSuccess(context, connection.isConnected
              ? l10n.successfullyDisconnected(connection.name)
              : l10n.successfullyConnected(connection.name));
          await Future.delayed(const Duration(seconds: 1));
          if (mounted) {
            _loadData();
          }
        } else {
          SnackBarHelper.showError(context, connection.isConnected
              ? l10n.failedToDisconnect(connection.name)
              : l10n.failedToConnect(connection.name));
        }
      }
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showError(context, '${l10n.error}: ${e.toString()}');
      }
    }
  }

  Future<void> _restartService(String type) async {
    final l10n = AppLocalizations.of(context)!;
    
    final confirmed = await ConfirmationDialog.show(
      context: context,
      title: l10n.restartVpnService,
      message: l10n.restartServiceConfirmation(type.toUpperCase()),
      confirmText: l10n.restart,
      cancelText: l10n.cancel,
      isDestructive: false,
    );

    if (confirmed != true || !mounted) return;

    try {
      SnackBarHelper.showInfo(context, l10n.restartingService(type.toUpperCase()));

      final success = await _connectionManager.restartService(type);

      if (mounted) {
        if (success) {
          SnackBarHelper.showSuccess(context, l10n.successfullyRestartedService(type.toUpperCase()));
          await Future.delayed(const Duration(seconds: 2));
          if (mounted) {
            _loadData();
          }
        } else {
          SnackBarHelper.showError(context, l10n.failedToRestartService(type.toUpperCase()));
        }
      }
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showError(context, '${l10n.error}: ${e.toString()}');
      }
    }
  }

  List<VPNConnection> get _filteredConnections {
    return _connectionManager.filterConnections(_connections, _filterType);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_isLoading && _connections.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_errorMessage != null && _connections.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.danger,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.errorLoadingVpnConnections,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadData,
              icon: const Icon(Icons.refresh),
              label: Text(l10n.retry),
            ),
          ],
        ),
      );
    }

    final filteredConnections = _filteredConnections;

    if (filteredConnections.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.vpn_lock_outlined,
              size: 64,
              color: AppColors.iconMuted,
            ),
            const SizedBox(height: 16),
            Text(
              _filterType == 'all'
                  ? l10n.noVpnConnectionsFound
                  : l10n.noConnectionsFound(_filterType.toUpperCase()),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.vpnConnectionsWillAppear,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    final stats = _connectionManager.getStatistics(_connections);

    return Column(
      children: [
        // Manage WireGuard button
        if (_filterType == 'wireguard' || _filterType == 'all')
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const WireGuardServersScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.settings),
                label: const Text('Manage WireGuard'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
        
        // Summary cards
        VPNSummaryCards(
          connectedCount: stats.connectedCount,
          totalCount: stats.totalCount,
        ),
        
        // Connections list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(AppConstants.standardPadding),
            itemCount: filteredConnections.length,
            itemBuilder: (context, index) {
              final connection = filteredConnections[index];
              return VPNConnectionCard(
                connection: connection,
                onToggle: () => _toggleConnection(connection),
                onRestartService: () => _restartService(connection.type),
              );
            },
          ),
        ),
      ],
    );
  }
}


