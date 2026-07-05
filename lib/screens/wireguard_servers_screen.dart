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
import '../models/wireguard_server.dart';
import '../utils/app_colors.dart';
import '../services/demo_api_service.dart';
import '../utils/snackbar_helper.dart';
import '../viewmodels/wireguard_servers_view_model.dart';
import '../widgets/app_drawer.dart';
import '../widgets/common/confirmation_dialog.dart';
import '../widgets/common/error_display.dart';
import '../widgets/common/empty_state_widget.dart';
import '../l10n/app_localizations.dart';
import 'wireguard_server_form_screen.dart';

/// Screen for managing WireGuard servers
class WireGuardServersScreen extends StatefulWidget {
  const WireGuardServersScreen({super.key});

  @override
  State<WireGuardServersScreen> createState() => _WireGuardServersScreenState();
}

class _WireGuardServersScreenState extends State<WireGuardServersScreen> {
  late WireGuardServersViewModel _viewModel;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final apiService = context.read<DemoApiService>();
      _viewModel = WireGuardServersViewModel(apiService);
      _isInitialized = true;
      _loadData();
    }
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    await Future.wait([
      _viewModel.loadItems(),
    ]);
  }

  Future<void> _toggleServer(WireGuardServer server) async {
    try {
      await _viewModel.toggleServer(server.uuid, server.isEnabled);
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        SnackBarHelper.showSuccess(
          context,
          server.isEnabled
              ? l10n.serverDisabledSuccessfully
              : l10n.serverEnabledSuccessfully,
        );
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        SnackBarHelper.showError(context, l10n.failedToToggleServer(e.toString()));
      }
    }
  }

  Future<void> _deleteServer(WireGuardServer server) async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await ConfirmationDialog.show(
      context: context,
      title: l10n.delete,
      message: l10n.deleteServerConfirmation(server.name),
      confirmText: l10n.delete,
      cancelText: l10n.cancel,
      isDestructive: true,
    );

    if (confirmed == true && mounted) {
      try {
        await _viewModel.deleteServer(server.uuid);
        if (mounted) {
          SnackBarHelper.showSuccess(context, l10n.serverDeletedSuccessfully);
        }
      } catch (e) {
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          SnackBarHelper.showError(context, l10n.failedToDeleteServer(e.toString()));
        }
      }
    }
  }

  void _showServerDetails(WireGuardServer server) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(server.name),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow(l10n.port, server.port.toString()),
              _buildDetailRow(l10n.enabled, server.isEnabled ? l10n.yes : l10n.no),
              _buildDetailRow(l10n.publicKey, l10n.publicKeyShort(server.pubkey.substring(0, 20))),
              if (server.mtuValue != null)
                _buildDetailRow('MTU', server.mtuValue.toString()),
              if (server.dnsList.isNotEmpty)
                _buildDetailRow(l10n.dnsServers, server.dnsList.join(', ')),
              if (server.gateway.isNotEmpty)
                _buildDetailRow(l10n.gateway, server.gateway),
              _buildDetailRow(l10n.disableRoutes, server.hasRoutesDisabled ? l10n.yes : l10n.no),
              const Divider(),
              Text(
                '${l10n.tunnelAddresses}:',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...server.tunnelAddressList.map((addr) => Padding(
                    padding: const EdgeInsets.only(left: 16, bottom: 4),
                    child: Text('• $addr'),
                  )),
              if (server.peers.isNotEmpty) ...[
                const Divider(),
                Text(
                  '${l10n.peers}:',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(l10n.peersConfigured(server.peerUuidList.length)),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Future<void> _navigateToForm([WireGuardServer? server]) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WireGuardServerFormScreen(server: server),
      ),
    );
    if (mounted) _viewModel.loadItems();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        final isLoading = _viewModel.isLoading;
        final errorMessage = _viewModel.errorMessage;
        final servers = _viewModel.items;

        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.wireguardServers),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _viewModel.loadItems,
                tooltip: l10n.refresh,
              ),
            ],
          ),
          drawer: const AppDrawer(
            currentRoute: 'wireguard_servers'
          ),
          body: Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: l10n.searchServers,
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                  onChanged: _viewModel.setSearchQuery,
                ),
              ),
              // Servers list
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : errorMessage != null
                        ? ErrorDisplay(
                            message: errorMessage,
                            onRetry: _viewModel.loadItems,
                          )
                        : servers.isEmpty
                            ? EmptyStateWidget(
                                icon: Icons.security,
                                title: _viewModel.searchQuery.isNotEmpty
                                    ? l10n.noServersMatchSearch
                                    : l10n.noWireguardServersConfigured,
                              )
                            : RefreshIndicator(
                                onRefresh: _viewModel.loadItems,
                                child: ListView.builder(
                                  itemCount: servers.length,
                                  itemBuilder: (context, index) {
                                    final server = servers[index];
                                    final isToggling =
                                        _viewModel.isToggling(server.uuid);

                                    return Card(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 4),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor: server.isEnabled
                                              ? AppColors.success
                                              : AppColors.disabled,
                                          child: const Icon(
                                            Icons.security,
                                            color: AppColors.onPrimary,
                                            size: 20,
                                          ),
                                        ),
                                        title: Text(
                                          server.name,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(l10n.portLabel(server.port)),
                                            Text(l10n.tunnelLabel(server
                                                .tunnelAddressList
                                                .join(', '))),
                                            Text(
                                              l10n.peersConfigured(
                                                  server.peerUuidList.length),
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: AppColors.textSecondary,
                                              ),
                                            ),
                                          ],
                                        ),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            if (isToggling)
                                              const SizedBox(
                                                width: 24,
                                                height: 24,
                                                child:
                                                    CircularProgressIndicator(
                                                        strokeWidth: 2),
                                              )
                                            else
                                              Switch(
                                                value: server.isEnabled,
                                                onChanged: (value) =>
                                                    _toggleServer(server),
                                                activeTrackColor: AppColors.success,
                                              ),
                                            const SizedBox(width: 8),
                                            PopupMenuButton<String>(
                                              onSelected: (value) {
                                                switch (value) {
                                                  case 'view':
                                                    _showServerDetails(server);
                                                    break;
                                                  case 'edit':
                                                    _navigateToForm(server);
                                                    break;
                                                  case 'delete':
                                                    _deleteServer(server);
                                                    break;
                                                }
                                              },
                                              itemBuilder: (context) => [
                                                PopupMenuItem(
                                                  value: 'view',
                                                  child: Row(
                                                    children: [
                                                      const Icon(
                                                          Icons.visibility),
                                                      const SizedBox(width: 8),
                                                      Text(l10n.viewDetails),
                                                    ],
                                                  ),
                                                ),
                                                PopupMenuItem(
                                                  value: 'edit',
                                                  child: Row(
                                                    children: [
                                                      const Icon(Icons.edit),
                                                      const SizedBox(width: 8),
                                                      Text(l10n.edit),
                                                    ],
                                                  ),
                                                ),
                                                PopupMenuItem(
                                                  value: 'delete',
                                                  child: Row(
                                                    children: [
                                                      const Icon(Icons.delete,
                                                          color: AppColors.error),
                                                      const SizedBox(width: 8),
                                                      Text(l10n.delete,
                                                          style:
                                                              const TextStyle(
                                                                  color: AppColors.error)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        onTap: () => _showServerDetails(server),
                                      ),
                                    );
                                  },
                                ),
                              ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _navigateToForm(),
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
