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
import '../l10n/app_localizations.dart';
import '../models/tailscale_status.dart';
import '../models/system_info.dart';
import '../services/demo_api_service.dart';
import '../utils/snackbar_helper.dart';
import '../utils/formatters.dart';
import '../widgets/app_drawer.dart';
import '../widgets/common/confirmation_dialog.dart';
import '../widgets/common/error_display.dart';

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
    final l10n = AppLocalizations.of(context)!;
    final actionTitle = action == 'start'
        ? l10n.start
        : action == 'stop'
            ? l10n.stop
            : l10n.restart;

    final confirmed = await ConfirmationDialog.show(
      context: context,
      title: l10n.tailscaleServiceAction(actionTitle),
      message: l10n.tailscaleServiceActionConfirmation(action),
      confirmText: actionTitle,
      cancelText: l10n.cancel,
      isDestructive: action == 'stop',
    );

    if (confirmed != true || !mounted) return;

    // Show progress
    if (mounted) {
      SnackBarHelper.showInfo(context, l10n.tailscaleServiceActioning(actionTitle));
    }

    try {
      final demoApiService = context.read<DemoApiService>();
      final success = await demoApiService.controlTailscaleService(action);

      if (mounted) {
        if (success) {
          SnackBarHelper.showSuccess(context, l10n.tailscaleServiceActionSuccess(actionTitle));
          _loadData();
        } else {
          SnackBarHelper.showError(context, l10n.failedToActionTailscaleService(action));
        }
      }
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showError(context, '${l10n.error}: ${e.toString()}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tailscaleStatus),
        actions: [
          // Service control buttons
          if (_status != null) ...[
            if (!_status!.serviceRunning)
              IconButton(
                icon: const Icon(Icons.play_arrow, color: Colors.green),
                tooltip: l10n.startService,
                onPressed: () => _controlService('start'),
              ),
            if (_status!.serviceRunning) ...[
              IconButton(
                icon: const Icon(Icons.stop, color: Colors.red),
                tooltip: l10n.stopService,
                onPressed: () => _controlService('stop'),
              ),
              IconButton(
                icon: const Icon(Icons.restart_alt, color: Colors.orange),
                tooltip: l10n.restartService,
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
      return ErrorDisplay(message: _errorMessage!, onRetry: _loadData);
    }

    if (_status == null) {
      final l10n = AppLocalizations.of(context)!;
      return Center(child: Text(l10n.noDataAvailable));
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
                  AppLocalizations.of(context)!.serviceStatus,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const Divider(height: 24),
            _buildInfoRow(AppLocalizations.of(context)!.serviceRunning,
                _status!.serviceRunning ? AppLocalizations.of(context)!.yes : AppLocalizations.of(context)!.no,
                valueColor:
                    _status!.serviceRunning ? Colors.green : Colors.red),
            _buildInfoRow(AppLocalizations.of(context)!.backendState, _status!.backendState,
                valueColor: _status!.isConnected ? Colors.green : null),
            _buildInfoRow(AppLocalizations.of(context)!.status, _status!.statusDisplay),
            if (_status!.version != null)
              _buildInfoRow(AppLocalizations.of(context)!.versionLabel, _status!.version!),
            _buildInfoRow(AppLocalizations.of(context)!.peersCount, _status!.peersCount.toString()),
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
                  AppLocalizations.of(context)!.connectionDetails,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const Divider(height: 24),
            if (_status!.ips.isNotEmpty) ...[
              _buildInfoRow(AppLocalizations.of(context)!.ipAddresses, _status!.ips.join(', ')),
            ] else
              _buildInfoRow(AppLocalizations.of(context)!.ipAddresses, AppLocalizations.of(context)!.none),
            if (_status!.connectedSince != null)
              _buildInfoRow(AppLocalizations.of(context)!.connectedSince,
                  Formatters.formatDateTime(_status!.connectedSince!)),
            if (_status!.bytesReceived != null)
              _buildInfoRow(AppLocalizations.of(context)!.bytesReceived,
                  Formatters.formatBytes(_status!.bytesReceived!, context)),
            if (_status!.bytesSent != null)
              _buildInfoRow(
                  AppLocalizations.of(context)!.bytesSent, Formatters.formatBytes(_status!.bytesSent!, context)),
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
                  AppLocalizations.of(context)!.networkConfiguration,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const Divider(height: 24),
            _buildInfoRow(AppLocalizations.of(context)!.acceptRoutes,
                _status!.acceptRoutes ? AppLocalizations.of(context)!.enabled : AppLocalizations.of(context)!.disabled),
            if (_status!.advertiseRoutes != null &&
                _status!.advertiseRoutes!.isNotEmpty)
              _buildInfoRow(AppLocalizations.of(context)!.advertiseRoutes, _status!.advertiseRoutes!),
            _buildInfoRow(
                AppLocalizations.of(context)!.useExitNode, _status!.useExitNode ? AppLocalizations.of(context)!.enabled : AppLocalizations.of(context)!.disabled),
            if (_status!.exitNode != null && _status!.exitNode!.isNotEmpty)
              _buildInfoRow(AppLocalizations.of(context)!.exitNode, _status!.exitNode!),
            _buildInfoRow(
                AppLocalizations.of(context)!.dnsEnabled, _status!.dnsEnabled ? AppLocalizations.of(context)!.enabled : AppLocalizations.of(context)!.disabled),
            _buildInfoRow(
                AppLocalizations.of(context)!.magicDns, _status!.magicDns ? AppLocalizations.of(context)!.enabled : AppLocalizations.of(context)!.disabled),
            _buildInfoRow(
                AppLocalizations.of(context)!.sshEnabled, _status!.sshEnabled ? AppLocalizations.of(context)!.enabled : AppLocalizations.of(context)!.disabled),
            if (_status!.tags.isNotEmpty)
              _buildInfoRow(AppLocalizations.of(context)!.tags, _status!.tags.join(', ')),
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
                  AppLocalizations.of(context)!.healthStatus,
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


