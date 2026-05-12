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
import '../models/wireguard_peer.dart';
import '../models/system_info.dart';
import '../services/opnsense_api_service.dart';
import '../widgets/app_drawer.dart';
import '../l10n/app_localizations.dart';
import 'wireguard_peer_form_screen.dart';

/// Screen for managing WireGuard peers
class WireGuardPeersScreen extends StatefulWidget {
  const WireGuardPeersScreen({super.key});

  @override
  State<WireGuardPeersScreen> createState() => _WireGuardPeersScreenState();
}

class _WireGuardPeersScreenState extends State<WireGuardPeersScreen> {
  List<WireGuardPeer> _peers = [];
  SystemInfo? _systemInfo;
  bool _isLoading = true;
  String? _errorMessage;
  String _searchQuery = '';
  final Set<String> _togglingPeers = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.wait([
      _loadPeers(),
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

  Future<void> _loadPeers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final apiService = context.read<OPNsenseApiService>();
      final peers = await apiService.getWireGuardPeers();

      if (mounted) {
        setState(() {
          _peers = peers;
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

  List<WireGuardPeer> get _filteredPeers {
    if (_searchQuery.isEmpty) {
      return _peers;
    }

    final query = _searchQuery.toLowerCase();
    return _peers.where((peer) {
      return peer.name.toLowerCase().contains(query) ||
          peer.pubkey.toLowerCase().contains(query) ||
          peer.tunnelAddressList.any((addr) => addr.toLowerCase().contains(query)) ||
          (peer.hasEndpoint && peer.endpoint.toLowerCase().contains(query));
    }).toList();
  }

  Future<void> _togglePeer(WireGuardPeer peer) async {
    if (_togglingPeers.contains(peer.uuid)) {
      return;
    }

    setState(() {
      _togglingPeers.add(peer.uuid);
    });

    try {
      final apiService = context.read<OPNsenseApiService>();
      await apiService.toggleWireGuardPeer(peer.uuid, !peer.isEnabled);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Peer ${peer.isEnabled ? "disabled" : "enabled"} successfully'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
        await _loadPeers();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to toggle peer: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _togglingPeers.remove(peer.uuid);
        });
      }
    }
  }

  Future<void> _deletePeer(WireGuardPeer peer) async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteRule),
        content: Text(
          'Are you sure you want to delete peer "${peer.name}"? This action cannot be undone.',
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
        await apiService.deleteWireGuardPeer(peer.uuid);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Peer deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
          _loadPeers();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to delete peer: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _showPeerDetails(WireGuardPeer peer) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(peer.name),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Enabled', peer.isEnabled ? 'Yes' : 'No'),
              _buildDetailRow('Public Key', '${peer.pubkey.substring(0, 20)}...'),
              if (peer.hasEndpoint)
                _buildDetailRow('Endpoint', peer.endpoint),
              if (peer.keepaliveInterval != null)
                _buildDetailRow('Keepalive', '${peer.keepaliveInterval} seconds'),
              _buildDetailRow('Pre-shared Key', peer.hasPresharedKey ? 'Configured' : 'Not configured'),
              const Divider(),
              const Text(
                'Allowed Tunnel Addresses:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...peer.tunnelAddressList.map((addr) => Padding(
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

  void _navigateToForm([WireGuardPeer? peer]) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WireGuardPeerFormScreen(peer: peer),
      ),
    ).then((_) => _loadPeers());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final filteredPeers = _filteredPeers;

    return Scaffold(
      appBar: AppBar(
        title: const Text('WireGuard Peers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPeers,
            tooltip: l10n.refresh,
          ),
        ],
      ),
      drawer: AppDrawer(
        currentRoute: 'wireguard_peers',
        systemInfo: _systemInfo,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search peers...',
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
          // Peers list
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
                              onPressed: _loadPeers,
                              icon: const Icon(Icons.refresh),
                              label: Text(l10n.retry),
                            ),
                          ],
                        ),
                      )
                    : filteredPeers.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.people, size: 48, color: Colors.grey),
                                const SizedBox(height: 16),
                                Text(
                                  _searchQuery.isNotEmpty
                                      ? 'No peers match your search'
                                      : 'No WireGuard peers configured',
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _loadPeers,
                            child: ListView.builder(
                              itemCount: filteredPeers.length,
                              itemBuilder: (context, index) {
                                final peer = filteredPeers[index];
                                final isToggling = _togglingPeers.contains(peer.uuid);

                                return Card(
                                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: peer.isEnabled
                                          ? Colors.green
                                          : Colors.grey,
                                      child: const Icon(
                                        Icons.people,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                    title: Text(
                                      peer.name,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Key: ${peer.pubkey.substring(0, 20)}...'),
                                        Text('Allowed IPs: ${peer.tunnelAddressList.join(", ")}'),
                                        if (peer.hasEndpoint)
                                          Text('Endpoint: ${peer.endpoint}'),
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
                                            value: peer.isEnabled,
                                            onChanged: (value) => _togglePeer(peer),
                                            activeTrackColor: Colors.green,
                                          ),
                                        const SizedBox(width: 8),
                                        PopupMenuButton<String>(
                                          onSelected: (value) {
                                            switch (value) {
                                              case 'view':
                                                _showPeerDetails(peer);
                                                break;
                                              case 'edit':
                                                _navigateToForm(peer);
                                                break;
                                              case 'delete':
                                                _deletePeer(peer);
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
                                    onTap: () => _showPeerDetails(peer),
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


