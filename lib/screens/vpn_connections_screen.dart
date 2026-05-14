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
import '../models/vpn_connection.dart';
import '../models/system_info.dart';
import '../models/tailscale_status.dart';
import '../services/demo_api_service.dart';
import '../utils/constants.dart';
import '../utils/formatters.dart';
import '../widgets/app_drawer.dart';
import '../l10n/app_localizations.dart';
import 'wireguard_servers_screen.dart';

/// Screen for managing VPN connections
class VPNConnectionsScreen extends StatefulWidget {
  final String? vpnType;
  
  const VPNConnectionsScreen({super.key, this.vpnType});

  @override
  State<VPNConnectionsScreen> createState() => _VPNConnectionsScreenState();
}

class _VPNConnectionsScreenState extends State<VPNConnectionsScreen> {
  List<VPNConnection> _connections = [];
  SystemInfo? _systemInfo;
  TailscaleStatus? _tailscaleStatus;
  bool _isLoading = true;
  String? _errorMessage;
  Timer? _refreshTimer;
  String _filterType = 'all'; // 'all', 'openvpn', 'tailscale', 'wireguard', 'ipsec'

  /// Check if we're in Tailscale-specific mode
  bool get _isTailscaleMode => widget.vpnType == 'tailscale';

  @override
  void initState() {
    super.initState();
    // Set initial filter based on vpnType parameter
    if (widget.vpnType != null) {
      _filterType = widget.vpnType!;
    }
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
      final demoApiService = context.read<DemoApiService>();
      
      if (_isTailscaleMode) {
        // Load Tailscale-specific data
        final results = await Future.wait([
          demoApiService.getTailscaleDetails(),
          demoApiService.getSystemInfo(),
        ]);

        if (mounted) {
          setState(() {
            _tailscaleStatus = results[0] as TailscaleStatus;
            _systemInfo = results[1] as SystemInfo;
            _isLoading = false;
          });
        }
      } else {
        // Load regular VPN connections
        final results = await Future.wait([
          demoApiService.getVPNConnections(),
          demoApiService.getSystemInfo(),
        ]);

        if (mounted) {
          setState(() {
            _connections = results[0] as List<VPNConnection>;
            _systemInfo = results[1] as SystemInfo;
            _isLoading = false;
          });
        }
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
    final actionTitle = connection.isConnected ? l10n.disconnectVPN : l10n.connectVPN;
    final action = connection.isConnected ? l10n.disconnect : l10n.connect;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(actionTitle),
        content: Text(
          '${l10n.deleteRuleConfirmation(connection.name).split('"')[0]}"${connection.name}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: connection.isConnected ? Colors.red : Colors.green,
            ),
            child: Text(action),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    try {
      final demoApiService = context.read<DemoApiService>();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(connection.isConnected ? l10n.disconnectingVPN(connection.name) : l10n.connectingVPN(connection.name)),
          duration: const Duration(seconds: 2),
        ),
      );

      final success = await demoApiService.toggleVPNConnection(
        connection.id,
        connection.type,
        connection.isConnected,
      );

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(connection.isConnected ? l10n.successfullyDisconnected(connection.name) : l10n.successfullyConnected(connection.name)),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
          await Future.delayed(const Duration(seconds: 1));
          if (mounted) {
            _loadData();
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(connection.isConnected ? l10n.failedToDisconnect(connection.name) : l10n.failedToConnect(connection.name)),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.error}: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _restartService(String type) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.restartVPNService),
        content: Text(
          l10n.restartServiceConfirmation(type.toUpperCase()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
            ),
            child: Text(l10n.restart),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    try {
      final demoApiService = context.read<DemoApiService>();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.restartingService(type.toUpperCase())),
          duration: const Duration(seconds: 2),
        ),
      );

      final success = await demoApiService.restartVPNService(type);

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.successfullyRestartedService(type.toUpperCase())),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
          await Future.delayed(const Duration(seconds: 2));
          if (mounted) {
            _loadData();
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.failedToRestartService(type.toUpperCase())),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.error}: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  List<VPNConnection> get _filteredConnections {
    if (_filterType == 'all') {
      return _connections;
    }
    return _connections.where((conn) => conn.type == _filterType).toList();
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
                  value: 'ipsec',
                  child: Text('IPsec'),
                ),
                const PopupMenuItem(
                  value: 'tailscale',
                  child: Text('Tailscale'),
                ),
              ],
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _loadData,
            tooltip: l10n.refresh,
          ),
        ],
      ),
      drawer: AppDrawer(
        currentRoute: widget.vpnType != null ? 'vpn_${widget.vpnType}' : 'vpn_connections',
        systemInfo: _systemInfo,
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading && (_isTailscaleMode ? _tailscaleStatus == null : _connections.isEmpty)) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_errorMessage != null && (_isTailscaleMode ? _tailscaleStatus == null : _connections.isEmpty)) {
      final l10n = AppLocalizations.of(context)!;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[300],
            ),
            const SizedBox(height: 16),
            Text(
              l10n.errorLoadingVPNConnections,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
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

    // Tailscale mode - show dedicated UI
    if (_isTailscaleMode) {
      return _buildTailscaleBody();
    }

    if (filteredConnections.isEmpty) {
      final l10n = AppLocalizations.of(context)!;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.vpn_lock_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              _filterType == 'all'
                  ? l10n.noVPNConnectionsFound
                  : l10n.noConnectionsFound(_filterType.toUpperCase()),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.vpnConnectionsWillAppear,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

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
        _buildSummaryCards(),
        
        // Connections list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(AppConstants.standardPadding),
            itemCount: filteredConnections.length,
            itemBuilder: (context, index) {
              return _buildConnectionCard(filteredConnections[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCards() {
    final connectedCount = _connections.where((c) => c.isConnected).length;
    final totalCount = _connections.length;
    
    return Container(
      padding: const EdgeInsets.all(AppConstants.standardPadding),
      child: Row(
        children: [
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(
                      Icons.vpn_lock,
                      size: 32,
                      color: connectedCount > 0 ? Colors.green : Colors.grey,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$connectedCount / $totalCount',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: connectedCount > 0 ? Colors.green : Colors.grey,
                      ),
                    ),
                    Builder(
                      builder: (context) {
                        final l10n = AppLocalizations.of(context)!;
                        return Text(l10n.connected);
                      }
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Icon(
                      Icons.router,
                      size: 32,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$totalCount',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    Builder(
                      builder: (context) {
                        final l10n = AppLocalizations.of(context)!;
                        return Text(l10n.totalVPNs);
                      }
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionCard(VPNConnection connection) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: Icon(
          _getVPNIcon(connection.type),
          color: connection.isConnected ? Colors.green : Colors.grey,
          size: 32,
        ),
        title: Text(
          connection.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(connection.typeDisplay),
            Row(
              children: [
                Icon(
                  connection.isConnected ? Icons.check_circle : Icons.cancel,
                  size: 16,
                  color: connection.isConnected ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 4),
                Text(
                  connection.statusDisplay,
                  style: TextStyle(
                    color: connection.isConnected ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                connection.isConnected ? Icons.stop : Icons.play_arrow,
                color: connection.isConnected ? Colors.red : Colors.green,
              ),
              onPressed: () => _toggleConnection(connection),
              tooltip: connection.isConnected ? AppLocalizations.of(context)!.disconnect : AppLocalizations.of(context)!.connect,
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                switch (value) {
                  case 'restart_service':
                    _restartService(connection.type);
                    break;
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'restart_service',
                  child: Builder(
                    builder: (context) {
                      final l10n = AppLocalizations.of(context)!;
                      return Text('${l10n.restart} ${connection.typeDisplay} Service');
                    }
                  ),
                ),
              ],
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: _buildConnectionDetails(connection),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionDetails(VPNConnection connection) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (connection.description != null) ...[
          _buildDetailRow(AppLocalizations.of(context)!.description, connection.description!),
          const SizedBox(height: 8),
        ],
        if (connection.remoteAddress != null) ...[
          _buildDetailRow(AppLocalizations.of(context)!.remoteAddress, connection.remoteAddress!),
          const SizedBox(height: 8),
        ],
        if (connection.localAddress != null) ...[
          _buildDetailRow(AppLocalizations.of(context)!.localAddress, connection.localAddress!),
          const SizedBox(height: 8),
        ],
        if (connection.virtualAddress != null) ...[
          _buildDetailRow(AppLocalizations.of(context)!.virtualAddress, connection.virtualAddress!),
          const SizedBox(height: 8),
        ],
        if (connection.protocol != null) ...[
          _buildDetailRow(AppLocalizations.of(context)!.protocol, connection.protocol!),
          const SizedBox(height: 8),
        ],
        if (connection.port != null) ...[
          _buildDetailRow(AppLocalizations.of(context)!.port, connection.port.toString()),
          const SizedBox(height: 8),
        ],
        if (connection.bytesReceived != null || connection.bytesSent != null) ...[
          Row(
            children: [
              if (connection.bytesReceived != null)
                Expanded(
                  child: _buildDetailRow(
                    AppLocalizations.of(context)!.received,
                    Formatters.formatBytes(connection.bytesReceived!, context),
                  ),
                ),
              if (connection.bytesSent != null)
                Expanded(
                  child: _buildDetailRow(
                    AppLocalizations.of(context)!.sent,
                    Formatters.formatBytes(connection.bytesSent!, context),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
        ],
        if (connection.connectedSince != null) ...[
          _buildDetailRow(
            AppLocalizations.of(context)!.connectedSince,
            Formatters.formatDateTime(connection.connectedSince!),
          ),
        ],
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            '$label:',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  IconData _getVPNIcon(String type) {
    switch (type.toLowerCase()) {
      case 'openvpn':
        return Icons.vpn_key;
      case 'wireguard':
        return Icons.security;
      case 'ipsec':
        return Icons.shield;
      case 'tailscale':
        return Icons.cloud_queue;
      default:
        return Icons.vpn_lock_outlined;
    }
  }

  // ==================== Tailscale-Specific UI ====================

  Widget _buildTailscaleBody() {
    if (_tailscaleStatus == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(AppConstants.standardPadding),
      children: [
        _buildAuthenticationSection(),
        const SizedBox(height: 16),
        _buildSettingsSection(),
        const SizedBox(height: 16),
        _buildStatusSection(),
      ],
    );
  }

  Widget _buildAuthenticationSection() {
    final status = _tailscaleStatus!;

    return Card(
      child: ExpansionTile(
        initiallyExpanded: true,
        leading: Icon(
          status.authenticated ? Icons.verified_user : Icons.warning,
          color: status.authenticated ? Colors.green : Colors.orange,
          size: 32,
        ),
        title: const Text(
          'Authentication',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(
          status.authenticated ? 'Authenticated' : 'Not Authenticated',
          style: TextStyle(
            color: status.authenticated ? Colors.green : Colors.orange,
            fontWeight: FontWeight.w500,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Service State', status.serviceRunning ? 'Running' : 'Stopped'),
                const SizedBox(height: 8),
                _buildDetailRow('Auth Status', status.statusDisplay),
                const SizedBox(height: 8),
                if (status.tailnet != null) ...[
                  _buildDetailRow('Tailnet', status.tailnet!),
                  const SizedBox(height: 8),
                ],
                if (status.deviceName != null) ...[
                  _buildDetailRow('Device Name', status.deviceName!),
                  const SizedBox(height: 8),
                ],
                if (status.user != null) ...[
                  _buildDetailRow('User', status.user!),
                  const SizedBox(height: 8),
                ],
                if (status.authUrl != null) ...[
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () {
                      // In a real app, this would open the auth URL
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Auth URL: ${status.authUrl}')),
                      );
                    },
                    icon: const Icon(Icons.open_in_browser),
                    label: const Text('Authenticate'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection() {
    final status = _tailscaleStatus!;
    final l10n = AppLocalizations.of(context)!;

    return Card(
      child: ExpansionTile(
        initiallyExpanded: true,
        leading: const Icon(
          Icons.settings,
          color: Colors.blue,
          size: 32,
        ),
        title: Text(
          l10n.settings,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Accept Routes', status.acceptRoutes ? l10n.enabled : l10n.disabled),
                const SizedBox(height: 8),
                if (status.advertiseRoutes != null) ...[
                  _buildDetailRow('Advertise Routes', status.advertiseRoutes!),
                  const SizedBox(height: 8),
                ],
                _buildDetailRow('Exit Node', status.exitNode ?? 'None'),
                const SizedBox(height: 8),
                _buildDetailRow('Use Exit Node', status.useExitNode ? l10n.enabled : l10n.disabled),
                const SizedBox(height: 8),
                _buildDetailRow('DNS Enabled', status.dnsEnabled ? l10n.enabled : l10n.disabled),
                const SizedBox(height: 8),
                _buildDetailRow('MagicDNS', status.magicDns ? l10n.enabled : l10n.disabled),
                const SizedBox(height: 8),
                _buildDetailRow('SSH Enabled', status.sshEnabled ? l10n.enabled : l10n.disabled),
                const SizedBox(height: 8),
                if (status.tags.isNotEmpty) ...[
                  _buildDetailRow('Tags', status.tags.join(', ')),
                  const SizedBox(height: 8),
                ],
                if (status.hostname != null) ...[
                  _buildDetailRow(l10n.hostname, status.hostname!),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusSection() {
    final status = _tailscaleStatus!;
    final l10n = AppLocalizations.of(context)!;

    return Card(
      child: ExpansionTile(
        initiallyExpanded: true,
        leading: Icon(
          status.isConnected ? Icons.cloud_done : Icons.cloud_off,
          color: status.isConnected ? Colors.green : Colors.grey,
          size: 32,
        ),
        title: Text(
          l10n.status,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(
          status.backendState,
          style: TextStyle(
            color: status.isConnected ? Colors.green : Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Connection State', status.backendState),
                const SizedBox(height: 8),
                if (status.ips.isNotEmpty) ...[
                  _buildDetailRow('IP Addresses', status.ips.join(', ')),
                  const SizedBox(height: 8),
                ],
                if (status.bytesReceived != null || status.bytesSent != null) ...[
                  Row(
                    children: [
                      if (status.bytesReceived != null)
                        Expanded(
                          child: _buildDetailRow(
                            l10n.received,
                            Formatters.formatBytes(status.bytesReceived!, context),
                          ),
                        ),
                      if (status.bytesSent != null)
                        Expanded(
                          child: _buildDetailRow(
                            l10n.sent,
                            Formatters.formatBytes(status.bytesSent!, context),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
                if (status.connectedSince != null) ...[
                  _buildDetailRow(
                    l10n.connectedSince,
                    Formatters.formatDateTime(status.connectedSince!),
                  ),
                  const SizedBox(height: 8),
                ],
                _buildDetailRow('Peers Count', status.peersCount.toString()),
                const SizedBox(height: 8),
                _buildDetailRow('Health', status.healthDisplay),
                const SizedBox(height: 8),
                if (status.version != null) ...[
                  _buildDetailRow('Version', status.version!),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
