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
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/wireguard_server.dart';
import '../viewmodels/wireguard_server_form_view_model.dart';
import '../widgets/common/loading_overlay.dart';
import '../widgets/wireguard/key_pair_section.dart';
import '../widgets/wireguard/list_manager_card.dart';
import '../widgets/wireguard/peer_selector_dialog.dart';
import '../utils/common_validators.dart';
import '../utils/wireguard_validators.dart';

/// Refactored form screen for creating/editing WireGuard servers
class WireGuardServerFormScreen extends StatefulWidget {
  final WireGuardServer? server;

  const WireGuardServerFormScreen({super.key, this.server});

  @override
  State<WireGuardServerFormScreen> createState() =>
      _WireGuardServerFormScreenState();
}

class _WireGuardServerFormScreenState
    extends State<WireGuardServerFormScreen> {
  late WireGuardServerFormViewModel _viewModel;
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _portController = TextEditingController();
  final _publicKeyController = TextEditingController();
  final _privateKeyController = TextEditingController();
  final _mtuController = TextEditingController();
  final _gatewayController = TextEditingController();

  // State
  List<String> _tunnelAddresses = [];
  List<String> _dnsServers = [];
  List<String> _selectedPeerUuids = [];
  bool _enabled = true;
  bool _disableRoutes = false;

  @override
  void initState() {
    super.initState();
    _viewModel = WireGuardServerFormViewModel(
      apiService: context.read(),
      existingServer: widget.server,
    );
    _viewModel.addListener(_onViewModelChanged);
    _viewModel.loadPeers();

    if (_viewModel.isEditing) {
      _loadServerData();
    } else {
      _portController.text = '51820';
    }
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    _nameController.dispose();
    _portController.dispose();
    _publicKeyController.dispose();
    _privateKeyController.dispose();
    _mtuController.dispose();
    _gatewayController.dispose();
    super.dispose();
  }

  void _onViewModelChanged() {
    if (mounted) setState(() {});
  }

  void _loadServerData() {
    final server = widget.server!;
    _nameController.text = server.name;
    _portController.text = server.port;
    _publicKeyController.text = server.pubkey;
    _privateKeyController.text = server.privkey;
    _tunnelAddresses = List.from(server.tunnelAddressList);
    _dnsServers = List.from(server.dnsList);
    _selectedPeerUuids = List.from(server.peerUuidList);
    _enabled = server.isEnabled;
    _disableRoutes = server.hasRoutesDisabled;
    if (server.mtuValue != null) {
      _mtuController.text = server.mtuValue.toString();
    }
    if (server.gateway.isNotEmpty) {
      _gatewayController.text = server.gateway;
    }
  }

  Future<void> _generateKeys() async {
    final keyPair = await _viewModel.generateKeyPair();
    if (keyPair != null && mounted) {
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
    }
  }

  Future<void> _saveServer() async {
    if (!_formKey.currentState!.validate()) return;

    if (_tunnelAddresses.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('At least one tunnel address is required'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final request = WireGuardServerRequest(
      name: _nameController.text.trim(),
      pubkey: _publicKeyController.text.trim(),
      privkey: _privateKeyController.text.trim(),
      port: _portController.text.trim(),
      tunneladdress: _tunnelAddresses.join(','),
      enabled: _enabled ? '1' : '0',
      peers: _selectedPeerUuids.join(','),
      disableroutes: _disableRoutes ? '1' : '0',
      gateway: _gatewayController.text.trim(),
      mtu: _mtuController.text.trim(),
      dns: _dnsServers.join(','),
    );

    final success = await _viewModel.saveServer(request);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _viewModel.isEditing
                  ? 'Server updated successfully'
                  : 'Server created successfully',
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _viewModel.errorMessage ?? 'Failed to save server',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _addTunnelAddress() async {
    final address = await AddItemDialog.show(
      context: context,
      title: 'Add Tunnel Address',
      labelText: 'Tunnel Address (CIDR)',
      hintText: '10.10.10.1/24',
      helperText: 'Example: 10.10.10.1/24 or fd00::1/64',
      validator: (value) {
        if (value.isEmpty) return 'Address is required';
        if (!WireGuardValidators.isValidCIDR(value)) {
          return 'Invalid CIDR notation';
        }
        return null;
      },
    );

    if (address != null && mounted) {
      setState(() => _tunnelAddresses.add(address));
    }
  }

  Future<void> _addDnsServer() async {
    final dns = await AddItemDialog.show(
      context: context,
      title: 'Add DNS Server',
      labelText: 'DNS Server IP',
      hintText: '8.8.8.8',
      validator: (value) {
        if (value.isEmpty) return 'DNS server is required';
        if (!WireGuardValidators.isValidIPv4(value) &&
            !WireGuardValidators.isValidIPv6(value)) {
          return 'Invalid IP address';
        }
        return null;
      },
    );

    if (dns != null && mounted) {
      setState(() => _dnsServers.add(dns));
    }
  }

  Future<void> _selectPeers() async {
    final selected = await PeerSelectorDialog.show(
      context: context,
      availablePeers: _viewModel.availablePeers,
      selectedPeerUuids: _selectedPeerUuids,
    );

    if (selected != null && mounted) {
      setState(() => _selectedPeerUuids = selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _viewModel.isEditing ? 'Edit WireGuard Server' : 'New WireGuard Server',
        ),
      ),
      body: LoadingOverlay(
        isLoading: _viewModel.isLoading,
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  hintText: 'My WireGuard Server',
                  prefixIcon: Icon(Icons.label),
                ),
                validator: (value) => CommonValidators.required(value, fieldName: 'Name'),
                enabled: !_viewModel.isLoading,
              ),
              const SizedBox(height: 16),

              // Port
              TextFormField(
                controller: _portController,
                decoration: const InputDecoration(
                  labelText: 'Port',
                  hintText: '51820',
                  prefixIcon: Icon(Icons.settings_ethernet),
                  helperText: 'UDP port (default: 51820)',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: CommonValidators.port,
                enabled: !_viewModel.isLoading,
              ),
              const SizedBox(height: 16),

              // Key Pair Section
              KeyPairSection(
                publicKeyController: _publicKeyController,
                privateKeyController: _privateKeyController,
                onGenerateKeys: _generateKeys,
                isLoading: _viewModel.isLoading,
                isGenerating: _viewModel.isGeneratingKeys,
              ),
              const SizedBox(height: 24),

              // Tunnel Addresses
              ListManagerCard(
                title: 'Tunnel Addresses',
                items: _tunnelAddresses,
                onAdd: _addTunnelAddress,
                onRemove: (address) => setState(() => _tunnelAddresses.remove(address)),
                isLoading: _viewModel.isLoading,
                emptyMessage: 'No tunnel addresses configured',
              ),
              const SizedBox(height: 24),

              // MTU
              TextFormField(
                controller: _mtuController,
                decoration: const InputDecoration(
                  labelText: 'MTU (Optional)',
                  hintText: '1420',
                  prefixIcon: Icon(Icons.settings),
                  helperText: 'Maximum Transmission Unit (576-9000)',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: WireGuardValidators.validateMTU,
                enabled: !_viewModel.isLoading,
              ),
              const SizedBox(height: 16),

              // DNS Servers
              ListManagerCard(
                title: 'DNS Servers (Optional)',
                items: _dnsServers,
                onAdd: _addDnsServer,
                onRemove: (dns) => setState(() => _dnsServers.remove(dns)),
                isLoading: _viewModel.isLoading,
                emptyMessage: 'No DNS servers configured',
              ),
              const SizedBox(height: 16),

              // Gateway
              TextFormField(
                controller: _gatewayController,
                decoration: const InputDecoration(
                  labelText: 'Gateway (Optional)',
                  hintText: '10.10.10.1',
                  prefixIcon: Icon(Icons.router),
                ),
                enabled: !_viewModel.isLoading,
              ),
              const SizedBox(height: 16),

              // Peers
              const Text(
                'Authorized Peers',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Card(
                child: ListTile(
                  title: Text('${_selectedPeerUuids.length} peer(s) selected'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: _viewModel.isLoading || _viewModel.loadingPeers
                      ? null
                      : _selectPeers,
                ),
              ),
              const SizedBox(height: 16),

              // Switches
              SwitchListTile(
                title: const Text('Disable Routes'),
                subtitle: const Text('Prevent automatic route installation'),
                value: _disableRoutes,
                onChanged: _viewModel.isLoading
                    ? null
                    : (value) => setState(() => _disableRoutes = value),
              ),
              SwitchListTile(
                title: const Text('Enabled'),
                subtitle: const Text('Server will be active when enabled'),
                value: _enabled,
                onChanged: _viewModel.isLoading
                    ? null
                    : (value) => setState(() => _enabled = value),
              ),
              const SizedBox(height: 24),

              // Save Button
              ElevatedButton(
                onPressed: _viewModel.isLoading ? null : _saveServer,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  _viewModel.isEditing ? 'Update Server' : 'Create Server',
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
  }
}

// Made with Bob
