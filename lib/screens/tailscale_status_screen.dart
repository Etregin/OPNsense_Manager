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
import '../models/tailscale_status.dart';
import '../models/system_info.dart';
import '../services/demo_api_service.dart';
import '../utils/formatters.dart';
import '../widgets/app_drawer.dart';

/// Screen for displaying Tailscale status information
class TailscaleStatusScreen extends StatefulWidget {
  const TailscaleStatusScreen({super.key});

  @override
  State<TailscaleStatusScreen> createState() => _TailscaleStatusScreenState();
}

class _TailscaleStatusScreenState extends State<TailscaleStatusScreen> {
  TailscaleStatus? _status;
  SystemInfo? _systemInfo;
  bool _isLoading = true;
  String? _errorMessage;
  Timer? _refreshTimer;

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
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final demoApiService = context.read<DemoApiService>();
      final results = await Future.wait([
        demoApiService.getTailscaleDetails(),
        demoApiService.getSystemInfo(),
      ]);

      if (mounted) {
        setState(() {
          _status = results[0] as TailscaleStatus;
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

  Future<void> _controlService(String action) async {
    final actionTitle = action == 'start'
        ? 'Start'
        : action == 'stop'
            ? 'Stop'
            : 'Restart';

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$actionTitle Tailscale Service'),
        content: Text(
            'Are you sure you want to $action the Tailscale service?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: action == 'stop' ? Colors.red : null,
            ),
            child: Text(actionTitle),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    // Show progress
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${actionTitle}ing Tailscale service...'),
          duration: const Duration(seconds: 2),
        ),
      );
    }

    try {
      final demoApiService = context.read<DemoApiService>();
      final success = await demoApiService.controlTailscaleService(action);

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Tailscale service ${action}ed successfully'),
              backgroundColor: Colors.green,
            ),
          );
          _loadData();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to $action Tailscale service'),
              backgroundColor: Colors.red,
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
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tailscale Status'),
        actions: [
          // Service control buttons
          if (_status != null) ...[
            if (!_status!.serviceRunning)
              IconButton(
                icon: const Icon(Icons.play_arrow, color: Colors.green),
                tooltip: 'Start Service',
                onPressed: () => _controlService('start'),
              ),
            if (_status!.serviceRunning) ...[
              IconButton(
                icon: const Icon(Icons.stop, color: Colors.red),
                tooltip: 'Stop Service',
                onPressed: () => _controlService('stop'),
              ),
              IconButton(
                icon: const Icon(Icons.restart_alt, color: Colors.orange),
                tooltip: 'Restart Service',
                onPressed: () => _controlService('restart'),
              ),
            ],
          ],
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      drawer: AppDrawer(
        currentRoute: 'tailscale_status',
        systemInfo: _systemInfo,
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error loading data',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(_errorMessage!),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loadData,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_status == null) {
      return const Center(child: Text('No data available'));
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildStatusCard(),
        const SizedBox(height: 16),
        _buildConnectionCard(),
        const SizedBox(height: 16),
        _buildNetworkCard(),
        const SizedBox(height: 16),
        _buildHealthCard(),
      ],
    );
  }

  Widget _buildStatusCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.info_outline, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Service Status',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const Divider(height: 24),
            _buildInfoRow('Service Running',
                _status!.serviceRunning ? 'Yes' : 'No',
                valueColor:
                    _status!.serviceRunning ? Colors.green : Colors.red),
            _buildInfoRow('Backend State', _status!.backendState,
                valueColor: _status!.isConnected ? Colors.green : null),
            _buildInfoRow('Status', _status!.statusDisplay),
            if (_status!.version != null)
              _buildInfoRow('Version', _status!.version!),
            _buildInfoRow('Peers Count', _status!.peersCount.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectionCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.cloud_outlined, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Connection Details',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const Divider(height: 24),
            if (_status!.ips.isNotEmpty) ...[
              _buildInfoRow('IP Addresses', _status!.ips.join(', ')),
            ] else
              _buildInfoRow('IP Addresses', 'None'),
            if (_status!.connectedSince != null)
              _buildInfoRow('Connected Since',
                  Formatters.formatDateTime(_status!.connectedSince!)),
            if (_status!.bytesReceived != null)
              _buildInfoRow('Bytes Received',
                  Formatters.formatBytes(_status!.bytesReceived!, context)),
            if (_status!.bytesSent != null)
              _buildInfoRow(
                  'Bytes Sent', Formatters.formatBytes(_status!.bytesSent!, context)),
          ],
        ),
      ),
    );
  }

  Widget _buildNetworkCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.network_check, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Network Configuration',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const Divider(height: 24),
            _buildInfoRow('Accept Routes',
                _status!.acceptRoutes ? 'Enabled' : 'Disabled'),
            if (_status!.advertiseRoutes != null &&
                _status!.advertiseRoutes!.isNotEmpty)
              _buildInfoRow('Advertise Routes', _status!.advertiseRoutes!),
            _buildInfoRow(
                'Use Exit Node', _status!.useExitNode ? 'Enabled' : 'Disabled'),
            if (_status!.exitNode != null && _status!.exitNode!.isNotEmpty)
              _buildInfoRow('Exit Node', _status!.exitNode!),
            _buildInfoRow(
                'DNS Enabled', _status!.dnsEnabled ? 'Enabled' : 'Disabled'),
            _buildInfoRow(
                'Magic DNS', _status!.magicDns ? 'Enabled' : 'Disabled'),
            _buildInfoRow(
                'SSH Enabled', _status!.sshEnabled ? 'Enabled' : 'Disabled'),
            if (_status!.tags.isNotEmpty)
              _buildInfoRow('Tags', _status!.tags.join(', ')),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthCard() {
    final isHealthy = _status!.isHealthy;
    return Card(
      color: isHealthy ? null : Colors.orange.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isHealthy ? Icons.check_circle : Icons.warning,
                  size: 24,
                  color: isHealthy ? Colors.green : Colors.orange,
                ),
                const SizedBox(width: 8),
                Text(
                  'Health Status',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                Icon(
                  isHealthy ? Icons.check_circle : Icons.warning,
                  color: isHealthy ? Colors.green : Colors.orange,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _status!.healthDisplay,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isHealthy ? Colors.green : Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: valueColor,
                fontWeight: valueColor != null ? FontWeight.bold : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


