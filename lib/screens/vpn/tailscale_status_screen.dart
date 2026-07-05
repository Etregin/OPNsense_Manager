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
import '../../services/demo_api_service.dart';
import '../../utils/snackbar_helper.dart';
import '../../utils/app_colors.dart';
import '../../utils/constants.dart';
import '../../utils/formatters.dart';
import '../../l10n/app_localizations.dart';
import '../../viewmodels/tailscale_status_view_model.dart';
import '../../widgets/common/error_display.dart';

/// Panel widget displaying Tailscale status — embedded inside VPNConnectionsScreen.
///
/// Distinct from `lib/screens/tailscale_status_screen.dart` which is the
/// standalone full-screen version with its own Scaffold and AppDrawer.
class TailscaleStatusPanel extends StatefulWidget {
  const TailscaleStatusPanel({super.key});

  @override
  State<TailscaleStatusPanel> createState() => _TailscaleStatusPanelState();
}

class _TailscaleStatusPanelState extends State<TailscaleStatusPanel> {
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        if (_viewModel.isLoading && _viewModel.status == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_viewModel.errorMessage != null && _viewModel.status == null) {
          return ErrorDisplay(
            message: _viewModel.errorMessage!,
            onRetry: _viewModel.loadData,
          );
        }

        final status = _viewModel.status;
        if (status == null) {
          return Center(child: Text(l10n.noDataAvailable));
        }

        return ListView(
          padding: const EdgeInsets.all(AppConstants.standardPadding),
          children: [
            _buildAuthenticationSection(l10n, status),
            const SizedBox(height: 16),
            _buildSettingsSection(l10n, status),
            const SizedBox(height: 16),
            _buildStatusSection(l10n, status),
          ],
        );
      },
    );
  }

  Widget _buildAuthenticationSection(
    AppLocalizations l10n,
    TailscaleStatus status,
  ) {

    return Card(
      child: ExpansionTile(
        initiallyExpanded: true,
        leading: Icon(
          status.authenticated ? Icons.verified_user : Icons.warning,
          color: status.authenticated ? AppColors.success : AppColors.warning,
          size: 32,
        ),
        title: Text(
          l10n.authentication,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(
          status.authenticated ? l10n.authenticated : l10n.notAuthenticated,
          style: TextStyle(
            color: status.authenticated ? AppColors.success : AppColors.warning,
            fontWeight: FontWeight.w500,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(AppConstants.standardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow(
                  l10n.serviceStatus,
                  status.serviceRunning ? l10n.running : l10n.stopped,
                ),
                const SizedBox(height: 8),
                _buildDetailRow(l10n.status, status.statusDisplay),
                const SizedBox(height: 8),
                if (status.tailnet != null) ...[
                  _buildDetailRow(l10n.tailnet, status.tailnet!),
                  const SizedBox(height: 8),
                ],
                if (status.deviceName != null) ...[
                  _buildDetailRow(l10n.deviceName, status.deviceName!),
                  const SizedBox(height: 8),
                ],
                if (status.user != null) ...[
                  _buildDetailRow(l10n.user, status.user!),
                  const SizedBox(height: 8),
                ],
                if (status.authUrl != null) ...[
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () {
                      SnackBarHelper.showInfo(
                        context,
                        '${l10n.authUrl}: ${status.authUrl}',
                      );
                    },
                    icon: const Icon(Icons.open_in_browser),
                    label: Text(l10n.authenticate),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.warning,
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

  Widget _buildSettingsSection(AppLocalizations l10n, TailscaleStatus status) {
    return Card(
      child: ExpansionTile(
        initiallyExpanded: true,
        leading: const Icon(
          Icons.settings,
          color: AppColors.primary,
          size: 32,
        ),
        title: Text(
          l10n.settings,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(AppConstants.standardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow(
                  l10n.acceptRoutes,
                  status.acceptRoutes ? l10n.enabled : l10n.disabled,
                ),
                const SizedBox(height: 8),
                if (status.advertiseRoutes != null) ...[
                  _buildDetailRow(l10n.advertiseRoutes, status.advertiseRoutes!),
                  const SizedBox(height: 8),
                ],
                _buildDetailRow(
                  l10n.exitNode,
                  status.exitNode ?? l10n.none,
                ),
                const SizedBox(height: 8),
                _buildDetailRow(
                  l10n.useExitNode,
                  status.useExitNode ? l10n.enabled : l10n.disabled,
                ),
                const SizedBox(height: 8),
                _buildDetailRow(
                  l10n.dnsEnabled,
                  status.dnsEnabled ? l10n.enabled : l10n.disabled,
                ),
                const SizedBox(height: 8),
                _buildDetailRow(
                  StringConstants.magicDns,
                  status.magicDns ? l10n.enabled : l10n.disabled,
                ),
                const SizedBox(height: 8),
                _buildDetailRow(
                  l10n.sshEnabled,
                  status.sshEnabled ? l10n.enabled : l10n.disabled,
                ),
                const SizedBox(height: 8),
                if (status.tags.isNotEmpty) ...[
                  _buildDetailRow(l10n.tags, status.tags.join(', ')),
                  const SizedBox(height: 8),
                ],
                if (status.hostname != null)
                  _buildDetailRow(l10n.hostname, status.hostname!),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusSection(AppLocalizations l10n, TailscaleStatus status) {
    return Card(
      child: ExpansionTile(
        initiallyExpanded: true,
        leading: Icon(
          status.isConnected ? Icons.cloud_done : Icons.cloud_off,
          color: status.isConnected ? AppColors.success : AppColors.disabled,
          size: 32,
        ),
        title: Text(
          l10n.status,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(
          status.backendState,
          style: TextStyle(
            color: status.isConnected ? AppColors.success : AppColors.disabled,
            fontWeight: FontWeight.w500,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(AppConstants.standardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow(l10n.connectionStatus, status.backendState),
                const SizedBox(height: 8),
                if (status.ips.isNotEmpty) ...[
                  _buildDetailRow(
                    l10n.ipAddresses,
                    status.ips.join(', '),
                  ),
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
                _buildDetailRow(l10n.peersCount, status.peersCount.toString()),
                const SizedBox(height: 8),
                _buildDetailRow(l10n.healthStatus, status.healthDisplay),
                const SizedBox(height: 8),
                if (status.version != null)
                  _buildDetailRow(l10n.versionLabel, status.version!),
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
              color: AppColors.disabled,
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
