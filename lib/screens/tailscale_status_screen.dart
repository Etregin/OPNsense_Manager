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
import '../services/demo_api_service.dart';
import '../utils/constants.dart';
import '../utils/snackbar_helper.dart';
import '../utils/formatters.dart';
import '../viewmodels/tailscale_status_view_model.dart';
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
  late TailscaleStatusViewModel _viewModel;
  bool _isInitialized = false;
  Timer? _refreshTimer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final apiService = context.read<DemoApiService>();
      _viewModel = TailscaleStatusViewModel(apiService);
      _isInitialized = true;
      _viewModel.loadData();
      _startAutoRefresh();
    }
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _viewModel.dispose();
    super.dispose();
  }

  void _startAutoRefresh() {
    _refreshTimer = Timer.periodic(
      const Duration(seconds: 30),
      (timer) {
        if (mounted) {
          _viewModel.loadData();
        }
      },
    );
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

    SnackBarHelper.showInfo(context, l10n.tailscaleServiceActioning(actionTitle));

    try {
      final success = await _viewModel.controlService(action);
      if (mounted) {
        if (success) {
          SnackBarHelper.showSuccess(
              context, l10n.tailscaleServiceActionSuccess(actionTitle));
          _viewModel.loadData();
        } else {
          SnackBarHelper.showError(
              context, l10n.failedToActionTailscaleService(action));
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

    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        final status = _viewModel.status;

        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.tailscaleStatus),
            actions: [
              if (status != null) ...[
                if (!status.serviceRunning)
                  IconButton(
                    icon: const Icon(Icons.play_arrow, color: AppColors.success),
                    tooltip: l10n.startService,
                    onPressed: () => _controlService('start'),
                  ),
                if (status.serviceRunning) ...[
                  IconButton(
                    icon: const Icon(Icons.stop, color: AppColors.error),
                    tooltip: l10n.stopService,
                    onPressed: () => _controlService('stop'),
                  ),
                  IconButton(
                    icon: const Icon(Icons.restart_alt, color: AppColors.warning),
                    tooltip: l10n.restartService,
                    onPressed: () => _controlService('restart'),
                  ),
                ],
              ],
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _viewModel.loadData,
              ),
            ],
          ),
          drawer: AppDrawer(
            currentRoute: 'tailscale_status',
            systemInfo: _viewModel.systemInfo,
          ),
          body: RefreshIndicator(
            onRefresh: _viewModel.loadData,
            child: _buildBody(l10n, status),
          ),
        );
      },
    );
  }

  Widget _buildBody(AppLocalizations l10n, TailscaleStatus? status) {
    if (_viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_viewModel.errorMessage != null) {
      return ErrorDisplay(
          message: _viewModel.errorMessage!, onRetry: _viewModel.loadData);
    }

    if (status == null) {
      return Center(child: Text(l10n.noDataAvailable));
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildStatusCard(l10n, status),
        const SizedBox(height: 16),
        _buildConnectionCard(l10n, status),
        const SizedBox(height: 16),
        _buildNetworkCard(l10n, status),
        const SizedBox(height: 16),
        _buildHealthCard(l10n, status),
      ],
    );
  }

  Widget _buildStatusCard(AppLocalizations l10n, TailscaleStatus status) {
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
                Text(l10n.serviceStatus,
                    style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
            const Divider(height: 24),
            _buildInfoRow(l10n.serviceRunning,
                status.serviceRunning ? l10n.yes : l10n.no,
                valueColor:
                    status.serviceRunning ? AppColors.success : AppColors.error),
            _buildInfoRow(l10n.backendState, status.backendState,
                valueColor: status.isConnected ? AppColors.success : null),
            _buildInfoRow(l10n.status, status.statusDisplay),
            if (status.version != null)
              _buildInfoRow(l10n.versionLabel, status.version!),
            _buildInfoRow(l10n.peersCount, status.peersCount.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectionCard(AppLocalizations l10n, TailscaleStatus status) {
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
                Text(l10n.connectionDetails,
                    style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
            const Divider(height: 24),
            if (status.ips.isNotEmpty)
              _buildInfoRow(l10n.ipAddresses, status.ips.join(', '))
            else
              _buildInfoRow(l10n.ipAddresses, l10n.none),
            if (status.connectedSince != null)
              _buildInfoRow(l10n.connectedSince,
                  Formatters.formatDateTime(status.connectedSince!)),
            if (status.bytesReceived != null)
              _buildInfoRow(l10n.bytesReceived,
                  Formatters.formatBytes(status.bytesReceived!, context)),
            if (status.bytesSent != null)
              _buildInfoRow(l10n.bytesSent,
                  Formatters.formatBytes(status.bytesSent!, context)),
          ],
        ),
      ),
    );
  }

  Widget _buildNetworkCard(AppLocalizations l10n, TailscaleStatus status) {
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
                Text(l10n.networkConfiguration,
                    style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
            const Divider(height: 24),
            _buildInfoRow(l10n.acceptRoutes,
                status.acceptRoutes ? l10n.enabled : l10n.disabled),
            if (status.advertiseRoutes != null &&
                status.advertiseRoutes!.isNotEmpty)
              _buildInfoRow(l10n.advertiseRoutes, status.advertiseRoutes!),
            _buildInfoRow(l10n.useExitNode,
                status.useExitNode ? l10n.enabled : l10n.disabled),
            if (status.exitNode != null && status.exitNode!.isNotEmpty)
              _buildInfoRow(l10n.exitNode, status.exitNode!),
            _buildInfoRow(
                l10n.dnsEnabled, status.dnsEnabled ? l10n.enabled : l10n.disabled),
            _buildInfoRow(
                StringConstants.magicDns, status.magicDns ? l10n.enabled : l10n.disabled),
            _buildInfoRow(
                l10n.sshEnabled, status.sshEnabled ? l10n.enabled : l10n.disabled),
            if (status.tags.isNotEmpty)
              _buildInfoRow(l10n.tags, status.tags.join(', ')),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthCard(AppLocalizations l10n, TailscaleStatus status) {
    final isHealthy = status.isHealthy;
    return Card(
      color: isHealthy ? null : AppColors.warning.withValues(alpha: 0.1),
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
                  color: isHealthy ? AppColors.success : AppColors.warning,
                ),
                const SizedBox(width: 8),
                Text(l10n.healthStatus,
                    style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                Icon(
                  isHealthy ? Icons.check_circle : Icons.warning,
                  color: isHealthy ? AppColors.success : AppColors.warning,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    status.healthDisplay,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isHealthy ? AppColors.success : AppColors.warning,
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
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38),
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
