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
import '../services/opnsense_api_service.dart';
import '../utils/constants.dart';
import '../utils/formatters.dart';
import '../widgets/app_drawer.dart';

/// Screen for managing VPN connections
class VPNConnectionsScreen extends StatefulWidget {
  const VPNConnectionsScreen({super.key});

  @override
  State<VPNConnectionsScreen> createState() => _VPNConnectionsScreenState();
}

class _VPNConnectionsScreenState extends State<VPNConnectionsScreen> {
  List<VPNConnection> _connections = [];
  SystemInfo? _systemInfo;
  bool _isLoading = true;
  String? _errorMessage;
  Timer? _refreshTimer;
  String _filterType = 'all'; // 'all', 'openvpn', 'tailscale'

  @override
  void initState() {
    super.initState();
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
      final apiService = context.read<OPNsenseApiService>();
      
      final results = await Future.wait([
        apiService.getVPNConnections(),
        apiService.getSystemInfo(),
      ]);

      if (mounted) {
        setState(() {
          _connections = results[0] as List<VPNConnection>;
          _systemInfo = results[1] as SystemInfo;
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
    final action = connection.isConnected ? 'disconnect' : 'connect';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${action[0].toUpperCase()}${action.substring(1)} VPN'),
        content: Text(
          'Are you sure you want to $action "${connection.name}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: connection.isConnected ? Colors.red : Colors.green,
            ),
            child: Text(action[0].toUpperCase() + action.substring(1)),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    try {
      final apiService = context.read<OPNsenseApiService>();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${action[0].toUpperCase()}${action.substring(1)}ing ${connection.name}...'),
          duration: const Duration(seconds: 2),
        ),
      );

      final success = await apiService.toggleVPNConnection(
        connection.id,
        connection.type,
        connection.isConnected,
      );

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Successfully ${action}ed ${connection.name}'),
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
              content: Text('Failed to $action ${connection.name}'),
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
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _restartService(String type) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Restart VPN Service'),
        content: Text(
          'Are you sure you want to restart the ${type.toUpperCase()} service?\n\n'
          'This will temporarily disconnect all active connections.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
            ),
            child: const Text('Restart'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    try {
      final apiService = context.read<OPNsenseApiService>();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Restarting ${type.toUpperCase()} service...'),
          duration: const Duration(seconds: 2),
        ),
      );

      final success = await apiService.restartVPNService(type);

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Successfully restarted ${type.toUpperCase()} service'),
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
              content: Text('Failed to restart ${type.toUpperCase()} service'),
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
            content: Text('Error: ${e.toString()}'),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('VPN Connections'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filter by type',
            onSelected: (value) {
              setState(() {
                _filterType = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'all',
                child: Text('All VPNs'),
              ),
              const PopupMenuItem(
                value: 'openvpn',
                child: Text('OpenVPN'),
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
            tooltip: 'Refresh',
          ),
        ],
      ),
      drawer: AppDrawer(
        currentRoute: 'vpn_connections',
        systemInfo: _systemInfo,
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
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
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[300],
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading VPN connections',
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
              label: const Text('Retry'),
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
            Icon(
              Icons.vpn_lock_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              _filterType == 'all' 
                  ? 'No VPN connections found'
                  : 'No ${_filterType.toUpperCase()} connections found',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'VPN connections will appear here when configured',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
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
                    const Text('Connected'),
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
                    const Text('Total VPNs'),
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
              tooltip: connection.isConnected ? 'Disconnect' : 'Connect',
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
                  child: Text('Restart ${connection.typeDisplay} Service'),
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
          _buildDetailRow('Description', connection.description!),
          const SizedBox(height: 8),
        ],
        if (connection.remoteAddress != null) ...[
          _buildDetailRow('Remote Address', connection.remoteAddress!),
          const SizedBox(height: 8),
        ],
        if (connection.localAddress != null) ...[
          _buildDetailRow('Local Address', connection.localAddress!),
          const SizedBox(height: 8),
        ],
        if (connection.virtualAddress != null) ...[
          _buildDetailRow('Virtual Address', connection.virtualAddress!),
          const SizedBox(height: 8),
        ],
        if (connection.protocol != null) ...[
          _buildDetailRow('Protocol', connection.protocol!),
          const SizedBox(height: 8),
        ],
        if (connection.port != null) ...[
          _buildDetailRow('Port', connection.port.toString()),
          const SizedBox(height: 8),
        ],
        if (connection.bytesReceived != null || connection.bytesSent != null) ...[
          Row(
            children: [
              if (connection.bytesReceived != null)
                Expanded(
                  child: _buildDetailRow(
                    'Received',
                    Formatters.formatBytes(connection.bytesReceived!),
                  ),
                ),
              if (connection.bytesSent != null)
                Expanded(
                  child: _buildDetailRow(
                    'Sent',
                    Formatters.formatBytes(connection.bytesSent!),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
        ],
        if (connection.connectedSince != null) ...[
          _buildDetailRow(
            'Connected Since',
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
      case 'tailscale':
        return Icons.cloud_queue;
      default:
        return Icons.vpn_lock_outlined;
    }
  }
}
