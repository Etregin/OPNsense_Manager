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
import '../viewmodels/wireguard_peers_view_model.dart';
import '../widgets/app_drawer.dart';
import '../widgets/wireguard/peer_card.dart';
import '../l10n/app_localizations.dart';
import 'wireguard_peer_form_screen.dart';

/// Screen for managing WireGuard peers
class WireGuardPeersScreen extends StatefulWidget {
  const WireGuardPeersScreen({super.key});

  @override
  State<WireGuardPeersScreen> createState() => _WireGuardPeersScreenState();
}

class _WireGuardPeersScreenState extends State<WireGuardPeersScreen> {
  late WireGuardPeersViewModel _viewModel;
  SystemInfo? _systemInfo;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final apiService = context.read<OPNsenseApiService>();
      _viewModel = WireGuardPeersViewModel(apiService);
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

  Future<void> _togglePeer(WireGuardPeer peer) async {
    try {
      await _viewModel.togglePeer(peer.uuid, !peer.isEnabled);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Peer ${peer.isEnabled ? "disabled" : "enabled"} successfully'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
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
    }
  }

  Future<void> _deletePeer(WireGuardPeer peer) async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Peer'),
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
        await _viewModel.deletePeer(peer.uuid);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Peer deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
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
              if (peer.serverName != null && peer.serverName!.isNotEmpty)
                _buildDetailRow('Server', peer.serverName!),
              if (peer.tunneladdress != null && peer.tunneladdress!.isNotEmpty)
                _buildDetailRow('Tunnel Address', peer.tunneladdress!),
              if (peer.serveraddress != null && peer.serveraddress!.isNotEmpty)
                _buildDetailRow('Server Address', peer.serveraddress!),
              if (peer.serverport != null && peer.serverport!.isNotEmpty)
                _buildDetailRow('Server Port', peer.serverport!),
              if (peer.endpoint != null && peer.endpoint!.isNotEmpty)
                _buildDetailRow('Endpoint', peer.endpoint!),
              if (peer.keepaliveInterval != null)
                _buildDetailRow('Keepalive', '${peer.keepaliveInterval}s'),
              if (peer.hasPresharedKey)
                _buildDetailRow('Pre-shared Key', 'Configured'),
              const Divider(),
              const Text(
                'Public Key:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (peer.pubkey != null)
                SelectableText(
                  peer.pubkey!,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                  ),
                ),
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

  Future<void> _navigateToForm([WireGuardPeer? peer]) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => WireGuardPeerFormScreen(
          peerUuid: peer?.uuid,
        ),
      ),
    );

    // Refresh the list if the form was saved successfully
    if (result == true && mounted) {
      await _viewModel.refreshPeers();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        final peers = _viewModel.items;
        final isLoading = _viewModel.isLoading;
        final errorMessage = _viewModel.errorMessage;

        return Scaffold(
          appBar: AppBar(
            title: const Text('WireGuard Peers'),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _viewModel.refreshPeers,
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
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  onChanged: _viewModel.setSearchQuery,
                ),
              ),
              // Peers list
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : errorMessage != null
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  size: 48,
                                  color: Colors.red,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  l10n.error,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(height: 8),
                                Text(errorMessage),
                                const SizedBox(height: 16),
                                ElevatedButton.icon(
                                  onPressed: _viewModel.refreshPeers,
                                  icon: const Icon(Icons.refresh),
                                  label: Text(l10n.retry),
                                ),
                              ],
                            ),
                          )
                        : peers.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.vpn_key,
                                      size: 48,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      _viewModel.searchQuery.isNotEmpty
                                          ? 'No peers match your search'
                                          : 'No WireGuard peers configured',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                  ],
                                ),
                              )
                            : RefreshIndicator(
                                onRefresh: _viewModel.refreshPeers,
                                child: ListView.builder(
                                  itemCount: peers.length,
                                  itemBuilder: (context, index) {
                                    final peer = peers[index];
                                    return PeerCard(
                                      peer: peer,
                                      isToggling: _viewModel.isToggling(peer.uuid),
                                      onTap: () => _showPeerDetails(peer),
                                      onToggle: (value) => _togglePeer(peer),
                                      onEdit: () => _navigateToForm(peer),
                                      onDelete: () => _deletePeer(peer),
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


