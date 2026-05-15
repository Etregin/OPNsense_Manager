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
import '../services/opnsense_api_service.dart';
import '../viewmodels/wireguard_peer_form_view_model.dart';
import '../widgets/common/loading_overlay.dart';
import '../widgets/common/form_section_container.dart';
import '../widgets/wireguard/list_manager_card.dart';
import '../widgets/wireguard/peer_settings_card.dart';
import '../utils/wireguard_validators.dart';

/// Refactored form screen for creating/editing WireGuard peers
class WireGuardPeerFormScreen extends StatefulWidget {
  final WireGuardPeer? peer;

  const WireGuardPeerFormScreen({super.key, this.peer});

  bool get isEditing => peer != null;

  @override
  State<WireGuardPeerFormScreen> createState() => _WireGuardPeerFormScreenState();
}

class _WireGuardPeerFormScreenState extends State<WireGuardPeerFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _publicKeyController = TextEditingController();
  final _endpointController = TextEditingController();
  final _keepaliveController = TextEditingController();
  final _pskController = TextEditingController();

  late WireGuardPeerFormViewModel _viewModel;
  List<String> _tunnelAddresses = [];
  bool _enabled = true;

  @override
  void initState() {
    super.initState();
    _viewModel = WireGuardPeerFormViewModel(
      apiService: context.read<OPNsenseApiService>(),
      existingPeer: widget.peer,
    );
    
    if (widget.isEditing) {
      _loadPeerData();
    }
  }

  void _loadPeerData() {
    final peer = widget.peer!;
    _nameController.text = peer.name;
    _publicKeyController.text = peer.pubkey;
    _tunnelAddresses = List.from(peer.tunnelAddressList);
    _enabled = peer.isEnabled;
    if (peer.hasEndpoint) {
      _endpointController.text = peer.endpoint;
    }
    if (peer.keepaliveInterval != null) {
      _keepaliveController.text = peer.keepaliveInterval.toString();
    }
    if (peer.hasPresharedKey) {
      _pskController.text = peer.psk;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _publicKeyController.dispose();
    _endpointController.dispose();
    _keepaliveController.dispose();
    _pskController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _savePeer() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_tunnelAddresses.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('At least one allowed tunnel address is required'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final request = WireGuardPeerRequest(
      name: _nameController.text.trim(),
      pubkey: _publicKeyController.text.trim(),
      tunneladdress: _tunnelAddresses.join(','),
      enabled: _enabled ? '1' : '0',
      endpoint: _endpointController.text.trim(),
      keepalive: _keepaliveController.text.trim(),
      psk: _pskController.text.trim(),
    );

    final success = await _viewModel.savePeer(request);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.isEditing ? 'Peer updated successfully' : 'Peer created successfully',
          ),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop();
    } else if (_viewModel.errorMessage != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_viewModel.errorMessage!),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _addTunnelAddress() async {
    final address = await AddItemDialog.show(
      context: context,
      title: 'Add Allowed IP',
      labelText: 'Allowed IP (CIDR)',
      hintText: '10.10.10.0/24',
      helperText: 'Example: 10.10.10.0/24 or fd00::/64',
      validator: (value) {
        if (value.isEmpty) {
          return 'Address is required';
        }
        if (!WireGuardValidators.isValidCIDR(value)) {
          return 'Invalid CIDR notation';
        }
        return null;
      },
    );

    if (address != null && mounted) {
      setState(() {
        _tunnelAddresses.add(address);
      });
    }
  }

  void _removeTunnelAddress(String address) {
    setState(() {
      _tunnelAddresses.remove(address);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Consumer<WireGuardPeerFormViewModel>(
        builder: (context, viewModel, child) {
          return LoadingOverlay(
            isLoading: viewModel.isLoading,
            child: Scaffold(
              appBar: AppBar(
                title: Text(widget.isEditing ? 'Edit WireGuard Peer' : 'New WireGuard Peer'),
              ),
              body: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Name
                    FormSectionContainer(
                      title: 'Basic Information',
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            hintText: 'My WireGuard Peer',
                            prefixIcon: Icon(Icons.label),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Name is required';
                            }
                            return null;
                          },
                          enabled: !viewModel.isLoading,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Public Key
                    FormSectionContainer(
                      title: 'Peer Public Key',
                      children: [
                        TextFormField(
                          controller: _publicKeyController,
                          decoration: const InputDecoration(
                            labelText: 'Public Key',
                            prefixIcon: Icon(Icons.vpn_key),
                            helperText: 'Base64 encoded public key of the peer',
                          ),
                          validator: WireGuardValidators.validateKey,
                          enabled: !viewModel.isLoading,
                          maxLines: 2,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Allowed IPs (Tunnel Addresses)
                    FormSectionContainer(
                      title: 'Allowed IPs',
                      subtitle: 'IP addresses/networks that can communicate through this peer',
                      children: [
                        ListManagerCard(
                          title: 'Allowed IPs',
                          items: _tunnelAddresses,
                          onAdd: _addTunnelAddress,
                          onRemove: _removeTunnelAddress,
                          isLoading: viewModel.isLoading,
                          emptyMessage: 'No allowed IPs configured',
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Peer Settings
                    FormSectionContainer(
                      title: 'Peer Settings',
                      children: [
                        PeerSettingsCard(
                          endpointController: _endpointController,
                          keepaliveController: _keepaliveController,
                          pskController: _pskController,
                          enabled: _enabled,
                          onEnabledChanged: (value) {
                            setState(() {
                              _enabled = value;
                            });
                          },
                          isLoading: viewModel.isLoading,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Save Button
                    ElevatedButton(
                      onPressed: viewModel.isLoading ? null : _savePeer,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(
                        widget.isEditing ? 'Update Peer' : 'Create Peer',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Made with Bob