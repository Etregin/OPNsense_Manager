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
import '../services/opnsense_api_service.dart';
import '../viewmodels/wireguard_client_form_view_model.dart';
import '../widgets/common/loading_overlay.dart';
import '../widgets/common/form_section_container.dart';
import '../widgets/wireguard/key_pair_section.dart';
import '../widgets/wireguard/list_manager_card.dart';
import '../widgets/wireguard/client_server_settings_card.dart';
import '../widgets/wireguard/client_additional_settings_card.dart';
import '../utils/wireguard_validators.dart';

/// Refactored form screen for creating/editing WireGuard clients
class WireGuardClientFormScreen extends StatefulWidget {
  final WireGuardClient? client;

  const WireGuardClientFormScreen({super.key, this.client});

  bool get isEditing => client != null;

  @override
  State<WireGuardClientFormScreen> createState() => _WireGuardClientFormScreenState();
}

class _WireGuardClientFormScreenState extends State<WireGuardClientFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _serverAddressController = TextEditingController();
  final _serverPortController = TextEditingController();
  final _serverPublicKeyController = TextEditingController();
  final _publicKeyController = TextEditingController();
  final _privateKeyController = TextEditingController();
  final _keepaliveController = TextEditingController();
  final _pskController = TextEditingController();

  late WireGuardClientFormViewModel _viewModel;
  List<String> _tunnelAddresses = [];
  bool _enabled = true;

  @override
  void initState() {
    super.initState();
    _viewModel = WireGuardClientFormViewModel(
      apiService: context.read<OPNsenseApiService>(),
      existingClient: widget.client,
    );
    
    if (widget.isEditing) {
      _loadClientData();
    } else {
      _serverPortController.text = '51820';
      _keepaliveController.text = '25';
    }
  }

  void _loadClientData() {
    final client = widget.client!;
    _nameController.text = client.name;
    _serverAddressController.text = client.serveraddress;
    _serverPortController.text = client.serverport;
    _serverPublicKeyController.text = client.serverpubkey;
    _publicKeyController.text = client.pubkey;
    _privateKeyController.text = client.privkey;
    _tunnelAddresses = List.from(client.tunnelAddressList);
    _enabled = client.isEnabled;
    if (client.keepaliveInterval != null) {
      _keepaliveController.text = client.keepaliveInterval.toString();
    }
    if (client.hasPresharedKey) {
      _pskController.text = client.psk;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _serverAddressController.dispose();
    _serverPortController.dispose();
    _serverPublicKeyController.dispose();
    _publicKeyController.dispose();
    _privateKeyController.dispose();
    _keepaliveController.dispose();
    _pskController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _generateKeys() async {
    final keyPair = await _viewModel.generateKeyPair();
    
    if (!mounted) return;
    
    if (keyPair != null) {
      setState(() {
        _publicKeyController.text = keyPair.publicKey;
        _privateKeyController.text = keyPair.privateKey;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Keys generated successfully'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } else if (_viewModel.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_viewModel.errorMessage!),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  Future<void> _saveClient() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_tunnelAddresses.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('At least one tunnel address is required'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final request = WireGuardClientRequest(
      name: _nameController.text.trim(),
      pubkey: _publicKeyController.text.trim(),
      privkey: _privateKeyController.text.trim(),
      tunneladdress: _tunnelAddresses.join(','),
      serveraddress: _serverAddressController.text.trim(),
      serverport: _serverPortController.text.trim(),
      serverpubkey: _serverPublicKeyController.text.trim(),
      enabled: _enabled ? '1' : '0',
      keepalive: _keepaliveController.text.trim(),
      psk: _pskController.text.trim(),
    );

    final success = await _viewModel.saveClient(request);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.isEditing ? 'Client updated successfully' : 'Client created successfully',
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
      title: 'Add Tunnel Address',
      labelText: 'Tunnel Address (CIDR)',
      hintText: '10.10.10.2/24',
      helperText: 'Example: 10.10.10.2/24 or fd00::2/64',
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
      child: Consumer<WireGuardClientFormViewModel>(
        builder: (context, viewModel, child) {
          return LoadingOverlay(
            isLoading: viewModel.isLoading,
            child: Scaffold(
              appBar: AppBar(
                title: Text(widget.isEditing ? 'Edit WireGuard Client' : 'New WireGuard Client'),
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
                            hintText: 'My WireGuard Client',
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

                    // Server Connection Settings
                    FormSectionContainer(
                      title: 'Server Connection',
                      children: [
                        ClientServerSettingsCard(
                          serverAddressController: _serverAddressController,
                          serverPortController: _serverPortController,
                          serverPublicKeyController: _serverPublicKeyController,
                          isLoading: viewModel.isLoading,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Client Keys
                    FormSectionContainer(
                      title: 'Client Keys',
                      children: [
                        KeyPairSection(
                          publicKeyController: _publicKeyController,
                          privateKeyController: _privateKeyController,
                          onGenerateKeys: _generateKeys,
                          isLoading: viewModel.isLoading,
                          isGenerating: viewModel.isGeneratingKeys,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Tunnel Addresses
                    FormSectionContainer(
                      title: 'Tunnel Addresses',
                      children: [
                        ListManagerCard(
                          title: 'Tunnel Addresses',
                          items: _tunnelAddresses,
                          onAdd: _addTunnelAddress,
                          onRemove: _removeTunnelAddress,
                          isLoading: viewModel.isLoading,
                          emptyMessage: 'No tunnel addresses configured',
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Additional Settings
                    FormSectionContainer(
                      title: 'Additional Settings',
                      children: [
                        ClientAdditionalSettingsCard(
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
                      onPressed: viewModel.isLoading ? null : _saveClient,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(
                        widget.isEditing ? 'Update Client' : 'Create Client',
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