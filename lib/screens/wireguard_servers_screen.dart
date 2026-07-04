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
import '../models/system_info.dart';
import '../services/demo_api_service.dart';
import '../utils/snackbar_helper.dart';
import '../widgets/app_drawer.dart';
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
  List<WireGuardServer> _servers = [];
  SystemInfo? _systemInfo;
  bool _isLoading = true;
  String? _errorMessage;
  String _searchQuery = '';
  final Set<String> _togglingServers = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.wait([
      _loadServers(),
      _loadSystemInfo(),
    ]);
  }

  Future<void> _loadSystemInfo() async {
    try {
      final apiService = context.read<DemoApiService>();
      final systemInfo = await apiService.getSystemInfo();

      if (mounted) {
        setState(() {
          _systemInfo = systemInfo;
        });
      }
    } catch (e) {
      // Silently fail - system info is optional for drawer
    }
  }

  Future<void> _loadServers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final apiService = context.read<DemoApiService>();
      final servers = await apiService.getWireGuardServers();

      if (mounted) {
        setState(() {
          _servers = servers;
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

  List<WireGuardServer> get _filteredServers {
    if (_searchQuery.isEmpty) {
      return _servers;
    }

    final query = _searchQuery.toLowerCase();
    return _servers.where((server) {
      return server.name.toLowerCase().contains(query) ||
          server.tunnelAddressList.any((addr) => addr.toLowerCase().contains(query)) ||
          server.port.contains(query);
    }).toList();
  }

  Future<void> _toggleServer(WireGuardServer server) async {
    if (_togglingServers.contains(server.uuid)) {
      return;
    }

    setState(() {
      _togglingServers.add(server.uuid);
    });

    try {
      final apiService = context.read<DemoApiService>();
      await apiService.toggleWireGuardServer(server.uuid, !server.isEnabled);

      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        SnackBarHelper.showSuccess(context, server.isEnabled
            ? l10n.serverDisabledSuccessfully
            : l10n.serverEnabledSuccessfully);
        await _loadServers();
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        SnackBarHelper.showError(context, l10n.failedToToggleServer(e.toString()));
      }
    } finally {
      if (mounted) {
        setState(() {
          _togglingServers.remove(server.uuid);
        });
      }
    }
  }

  Future<void> _deleteServer(WireGuardServer server) async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.delete),
        content: Text(l10n.deleteServerConfirmation(server.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        final apiService = context.read<DemoApiService>();
        await apiService.deleteWireGuardServer(server.uuid);

        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          SnackBarHelper.showSuccess(context, l10n.serverDeletedSuccessfully);
          _loadServers();
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
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  void _navigateToForm([WireGuardServer? server]) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WireGuardServerFormScreen(server: server),
      ),
    ).then((_) => _loadServers());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final filteredServers = _filteredServers;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.wireguardServers),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadServers,
            tooltip: l10n.refresh,
          ),
        ],
      ),
      drawer: AppDrawer(
        currentRoute: 'wireguard_servers',
        systemInfo: _systemInfo,
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
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          // Servers list
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                    ? ErrorDisplay(message: _errorMessage!, onRetry: _loadServers)
                    : filteredServers.isEmpty
                        ? EmptyStateWidget(
                            icon: Icons.security,
                            title: _searchQuery.isNotEmpty
                                ? l10n.noServersMatchSearch
                                : l10n.noWireguardServersConfigured,
                          )
                        : RefreshIndicator(
                            onRefresh: _loadServers,
                            child: ListView.builder(
                              itemCount: filteredServers.length,
                              itemBuilder: (context, index) {
                                final server = filteredServers[index];
                                final isToggling = _togglingServers.contains(server.uuid);

                                return Card(
                                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: server.isEnabled
                                          ? Colors.green
                                          : Colors.grey,
                                      child: const Icon(
                                        Icons.security,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                    title: Text(
                                      server.name,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(l10n.portLabel(server.port)),
                                        Text(l10n.tunnelLabel(server.tunnelAddressList.join(", "))),
                                        Text(
                                          l10n.peersConfigured(server.peerUuidList.length),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
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
                                            child: CircularProgressIndicator(strokeWidth: 2),
                                          )
                                        else
                                          Switch(
                                            value: server.isEnabled,
                                            onChanged: (value) => _toggleServer(server),
                                            activeTrackColor: Colors.green,
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
                                                  const Icon(Icons.visibility),
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
                                                  const Icon(Icons.delete, color: Colors.red),
                                                  const SizedBox(width: 8),
                                                  Text(l10n.delete, style: const TextStyle(color: Colors.red)),
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
  }
}


