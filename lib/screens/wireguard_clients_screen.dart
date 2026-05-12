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
import '../models/wireguard_client.dart';
import '../models/system_info.dart';
import '../services/opnsense_api_service.dart';
import '../widgets/app_drawer.dart';
import '../l10n/app_localizations.dart';
import 'wireguard_client_form_screen.dart';

/// Screen for managing WireGuard clients
class WireGuardClientsScreen extends StatefulWidget {
  const WireGuardClientsScreen({super.key});

  @override
  State<WireGuardClientsScreen> createState() => _WireGuardClientsScreenState();
}

class _WireGuardClientsScreenState extends State<WireGuardClientsScreen> {
  List<WireGuardClient> _clients = [];
  SystemInfo? _systemInfo;
  bool _isLoading = true;
  String? _errorMessage;
  String _searchQuery = '';
  final Set<String> _togglingClients = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.wait([
      _loadClients(),
      _loadSystemInfo(),
    ]);
  }

  Future<void> _loadSystemInfo() async {
    try {
      final apiService = context.read<OPNsenseApiService>();
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

  Future<void> _loadClients() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final apiService = context.read<OPNsenseApiService>();
      final clients = await apiService.getWireGuardClients();

      if (mounted) {
        setState(() {
          _clients = clients;
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

  List<WireGuardClient> get _filteredClients {
    if (_searchQuery.isEmpty) {
      return _clients;
    }

    final query = _searchQuery.toLowerCase();
    return _clients.where((client) {
      return client.name.toLowerCase().contains(query) ||
          client.serveraddress.toLowerCase().contains(query) ||
          client.tunnelAddressList.any((addr) => addr.toLowerCase().contains(query));
    }).toList();
  }

  Future<void> _toggleClient(WireGuardClient client) async {
    if (_togglingClients.contains(client.uuid)) {
      return;
    }

    setState(() {
      _togglingClients.add(client.uuid);
    });

    try {
      final apiService = context.read<OPNsenseApiService>();
      await apiService.toggleWireGuardClient(client.uuid, !client.isEnabled);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Client ${client.isEnabled ? "disabled" : "enabled"} successfully'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
        await _loadClients();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to toggle client: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _togglingClients.remove(client.uuid);
        });
      }
    }
  }

  Future<void> _deleteClient(WireGuardClient client) async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteRule),
        content: Text(
          'Are you sure you want to delete client "${client.name}"? This action cannot be undone.',
        ),
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
        final apiService = context.read<OPNsenseApiService>();
        await apiService.deleteWireGuardClient(client.uuid);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Client deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
          _loadClients();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to delete client: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _showClientDetails(WireGuardClient client) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(client.name),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Enabled', client.isEnabled ? 'Yes' : 'No'),
              _buildDetailRow('Server', '${client.serveraddress}:${client.serverport}'),
              _buildDetailRow('Public Key', '${client.pubkey.substring(0, 20)}...'),
              _buildDetailRow('Server Public Key', '${client.serverpubkey.substring(0, 20)}...'),
              if (client.keepaliveInterval != null)
                _buildDetailRow('Keepalive', '${client.keepaliveInterval} seconds'),
              _buildDetailRow('Pre-shared Key', client.hasPresharedKey ? 'Configured' : 'Not configured'),
              const Divider(),
              const Text(
                'Tunnel Addresses:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...client.tunnelAddressList.map((addr) => Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 4),
                child: Text('• $addr'),
              )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.close),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              _exportClientConfig(client);
            },
            icon: const Icon(Icons.download),
            label: const Text('Export Config'),
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
            width: 140,
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

  void _exportClientConfig(WireGuardClient client) {
    // Generate WireGuard configuration file content
    final config = _generateWireGuardConfig(client);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Configuration'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Configuration File:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SelectableText(
                  config,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Scan this QR code with the WireGuard mobile app:',
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Icon(Icons.qr_code_2, size: 150, color: Colors.grey),
              ),
              const Center(
                child: Text(
                  'QR code generation requires qr_flutter package',
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  String _generateWireGuardConfig(WireGuardClient client) {
    final buffer = StringBuffer();
    buffer.writeln('[Interface]');
    buffer.writeln('PrivateKey = ${client.privkey}');
    buffer.writeln('Address = ${client.tunnelAddressList.join(", ")}');
    if (client.keepaliveInterval != null) {
      buffer.writeln('');
    }
    buffer.writeln('');
    buffer.writeln('[Peer]');
    buffer.writeln('PublicKey = ${client.serverpubkey}');
    if (client.hasPresharedKey) {
      buffer.writeln('PresharedKey = ${client.psk}');
    }
    buffer.writeln('Endpoint = ${client.serveraddress}:${client.serverport}');
    buffer.writeln('AllowedIPs = 0.0.0.0/0, ::/0');
    if (client.keepaliveInterval != null) {
      buffer.writeln('PersistentKeepalive = ${client.keepaliveInterval}');
    }
    return buffer.toString();
  }

  void _navigateToForm([WireGuardClient? client]) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WireGuardClientFormScreen(client: client),
      ),
    ).then((_) => _loadClients());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final filteredClients = _filteredClients;

    return Scaffold(
      appBar: AppBar(
        title: const Text('WireGuard Clients'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadClients,
            tooltip: l10n.refresh,
          ),
        ],
      ),
      drawer: AppDrawer(
        currentRoute: 'wireguard_clients',
        systemInfo: _systemInfo,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search clients...',
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
          // Clients list
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline, size: 48, color: Colors.red),
                            const SizedBox(height: 16),
                            Text(
                              l10n.error,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(_errorMessage!),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: _loadClients,
                              icon: const Icon(Icons.refresh),
                              label: Text(l10n.retry),
                            ),
                          ],
                        ),
                      )
                    : filteredClients.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.vpn_key, size: 48, color: Colors.grey),
                                const SizedBox(height: 16),
                                Text(
                                  _searchQuery.isNotEmpty
                                      ? 'No clients match your search'
                                      : 'No WireGuard clients configured',
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _loadClients,
                            child: ListView.builder(
                              itemCount: filteredClients.length,
                              itemBuilder: (context, index) {
                                final client = filteredClients[index];
                                final isToggling = _togglingClients.contains(client.uuid);

                                return Card(
                                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: client.isEnabled
                                          ? Colors.green
                                          : Colors.grey,
                                      child: const Icon(
                                        Icons.vpn_key,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                    title: Text(
                                      client.name,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Server: ${client.serveraddress}:${client.serverport}'),
                                        Text('Tunnel: ${client.tunnelAddressList.join(", ")}'),
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
                                            value: client.isEnabled,
                                            onChanged: (value) => _toggleClient(client),
                                            activeTrackColor: Colors.green,
                                          ),
                                        const SizedBox(width: 8),
                                        PopupMenuButton<String>(
                                          onSelected: (value) {
                                            switch (value) {
                                              case 'view':
                                                _showClientDetails(client);
                                                break;
                                              case 'edit':
                                                _navigateToForm(client);
                                                break;
                                              case 'export':
                                                _exportClientConfig(client);
                                                break;
                                              case 'delete':
                                                _deleteClient(client);
                                                break;
                                            }
                                          },
                                          itemBuilder: (context) => [
                                            const PopupMenuItem(
                                              value: 'view',
                                              child: Row(
                                                children: [
                                                  Icon(Icons.visibility),
                                                  SizedBox(width: 8),
                                                  Text('View Details'),
                                                ],
                                              ),
                                            ),
                                            const PopupMenuItem(
                                              value: 'edit',
                                              child: Row(
                                                children: [
                                                  Icon(Icons.edit),
                                                  SizedBox(width: 8),
                                                  Text('Edit'),
                                                ],
                                              ),
                                            ),
                                            const PopupMenuItem(
                                              value: 'export',
                                              child: Row(
                                                children: [
                                                  Icon(Icons.download),
                                                  SizedBox(width: 8),
                                                  Text('Export Config'),
                                                ],
                                              ),
                                            ),
                                            const PopupMenuItem(
                                              value: 'delete',
                                              child: Row(
                                                children: [
                                                  Icon(Icons.delete, color: Colors.red),
                                                  SizedBox(width: 8),
                                                  Text('Delete', style: TextStyle(color: Colors.red)),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    onTap: () => _showClientDetails(client),
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


