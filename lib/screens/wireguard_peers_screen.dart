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
import '../utils/constants.dart';
import '../services/demo_api_service.dart';
import '../utils/snackbar_helper.dart';
import '../viewmodels/wireguard_peers_view_model.dart';
import '../widgets/app_drawer.dart';
import '../widgets/wireguard/peer_card.dart';
import '../l10n/app_localizations.dart';
import 'wireguard_peer_form_screen.dart';
import '../widgets/common/confirmation_dialog.dart';


/// Screen for managing WireGuard peers
class WireGuardPeersScreen extends StatefulWidget {
  const WireGuardPeersScreen({super.key});

  @override
  State<WireGuardPeersScreen> createState() => _WireGuardPeersScreenState();
}

class _WireGuardPeersScreenState extends State<WireGuardPeersScreen> {
  late WireGuardPeersViewModel _viewModel;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final apiService = context.read<DemoApiService>();
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
    ]);
  }

  Future<void> _togglePeer(WireGuardPeer peer) async {
    try {
      await _viewModel.togglePeer(peer.uuid, !peer.isEnabled);
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        SnackBarHelper.showSuccess(context, peer.isEnabled
            ? l10n.peerDisabledSuccessfully
            : l10n.peerEnabledSuccessfully);
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        SnackBarHelper.showError(context, l10n.failedToTogglePeer(e.toString()));
      }
    }
  }

  Future<void> _deletePeer(WireGuardPeer peer) async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await ConfirmationDialog.show(
      context: context,
      title: l10n.deletePeer,
      message: l10n.deletePeerConfirmation(peer.name),
      confirmText: l10n.delete,
      cancelText: l10n.cancel,
      isDestructive: true,
    );

    if (confirmed == true && mounted) {
      try {
        await _viewModel.deletePeer(peer.uuid);
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          SnackBarHelper.showSuccess(context, l10n.peerDeletedSuccessfully);
        }
      } catch (e) {
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          SnackBarHelper.showError(context, l10n.failedToDeletePeer(e.toString()));
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
              _buildDetailRow(l10n.enabled, peer.isEnabled ? l10n.yes : l10n.no),
              if (peer.serverName != null && peer.serverName!.isNotEmpty)
                _buildDetailRow(l10n.server, peer.serverName!),
              if (peer.tunneladdress != null && peer.tunneladdress!.isNotEmpty)
                _buildDetailRow(l10n.tunnelAddress, peer.tunneladdress!),
              if (peer.serveraddress != null && peer.serveraddress!.isNotEmpty)
                _buildDetailRow(l10n.serverAddress, peer.serveraddress!),
              if (peer.serverport != null && peer.serverport!.isNotEmpty)
                _buildDetailRow(l10n.serverPort, peer.serverport!),
              if (peer.endpoint != null && peer.endpoint!.isNotEmpty)
                _buildDetailRow(l10n.endpoint, peer.endpoint!),
              if (peer.keepaliveInterval != null)
                _buildDetailRow(l10n.keepalive, '${peer.keepaliveInterval}s'),
              if (peer.hasPresharedKey)
                _buildDetailRow(l10n.presharedKeyOptional, l10n.configured),
              const Divider(),
              Text(
                l10n.publicKeyColon,
                style: const TextStyle(fontWeight: FontWeight.bold),
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
      await _viewModel.refresh();
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
            title: Text(l10n.wireguardPeers),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _viewModel.refresh,
                tooltip: l10n.refresh,
              ),
            ],
          ),
          drawer: const AppDrawer(
            currentRoute: 'wireguard_peers'
          ),
          body: Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: l10n.searchPeers,
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
                                  color: AppColors.error,
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
                                  onPressed: _viewModel.refresh,
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
                                      color: AppColors.disabled,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      _viewModel.searchQuery.isNotEmpty
                                          ? l10n.noPeersMatchSearch
                                          : l10n.noWireguardPeersConfigured,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                  ],
                                ),
                              )
                            : RefreshIndicator(
                                onRefresh: _viewModel.refresh,
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


