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
import '../../models/tailscale_status.dart';
import '../../models/system_info.dart';
import '../../services/demo_api_service.dart';
import '../../services/vpn/vpn_connection_manager.dart';
import '../../utils/snackbar_helper.dart';
import '../../utils/constants.dart';
import '../../utils/formatters.dart';
import '../../l10n/app_localizations.dart';

/// Screen for displaying Tailscale status and configuration
class TailscaleStatusScreen extends StatefulWidget {
  final SystemInfo? systemInfo;

  const TailscaleStatusScreen({
    super.key,
    this.systemInfo,
  });

  @override
  State<TailscaleStatusScreen> createState() => _TailscaleStatusScreenState();
}

class _TailscaleStatusScreenState extends State<TailscaleStatusScreen> {
  TailscaleStatus? _tailscaleStatus;
  bool _isLoading = true;
  String? _errorMessage;
  Timer? _refreshTimer;
  late VPNConnectionManager _connectionManager;

  @override
  void initState() {
    super.initState();
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
      final data = await _connectionManager.loadTailscaleStatus();

      if (mounted) {
        setState(() {
          _tailscaleStatus = data.status;
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_isLoading && _tailscaleStatus == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_errorMessage != null && _tailscaleStatus == null) {
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
                      SnackBarHelper.showInfo(context, 'Auth URL: ${status.authUrl}');
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
}


