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
import 'package:opnsense_manager/l10n/app_localizations.dart';

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
  String _carpDependOn = '';
  bool _enabled = true;
  bool _disableRoutes = false;
  bool _debug = false;

  @override
  void initState() {
    super.initState();
    _viewModel = WireGuardServerFormViewModel(
      apiService: context.read(),
      existingServer: widget.server,
    );
    _viewModel.addListener(_onViewModelChanged);
    _viewModel.loadPeers();
    _viewModel.loadCarpVipOptions();

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
    _debug = server.debug == '1';
    if (server.mtuValue != null) {
      _mtuController.text = server.mtuValue.toString();
    }
    if (server.gateway.isNotEmpty) {
      _gatewayController.text = server.gateway;
    }
    _carpDependOn = server.carpDependOn;
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
        SnackBar(
          content: Text(AppLocalizations.of(context)!.keysGeneratedSuccessfully),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
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

  Future<void> _saveServer() async {
    final l10n = AppLocalizations.of(context)!;
    
    if (!_formKey.currentState!.validate()) return;

    if (_tunnelAddresses.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.atLeastOneTunnelAddressRequired),
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
      carpDependOn: _carpDependOn,
      debug: _debug ? '1' : '0',
    );

    final success = await _viewModel.saveServer(request);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _viewModel.isEditing
                  ? l10n.serverUpdatedSuccessfully
                  : l10n.serverCreatedSuccessfully,
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _viewModel.errorMessage ?? l10n.failedToSaveServer,
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _addTunnelAddress() async {
    final l10n = AppLocalizations.of(context)!;
    
    final address = await AddItemDialog.show(
      context: context,
      title: l10n.addTunnelAddress,
      labelText: l10n.tunnelAddressCidr,
      hintText: '10.10.10.1/24',
      helperText: l10n.exampleTunnelAddress,
      validator: (value) {
        if (value.isEmpty) return l10n.addressIsRequired;
        if (!WireGuardValidators.isValidCIDR(value)) {
          return l10n.invalidCidrNotation;
        }
        return null;
      },
    );

    if (address != null && mounted) {
      setState(() => _tunnelAddresses.add(address));
    }
  }

  Future<void> _addDnsServer() async {
    final l10n = AppLocalizations.of(context)!;
    
    final dns = await AddItemDialog.show(
      context: context,
      title: l10n.addDnsServer,
      labelText: l10n.dnsServerIp,
      hintText: '8.8.8.8',
      validator: (value) {
        if (value.isEmpty) return l10n.dnsServerIsRequired;
        if (!WireGuardValidators.isValidIPv4(value) &&
            !WireGuardValidators.isValidIPv6(value)) {
          return l10n.invalidIpAddress;
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
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _viewModel.isEditing ? l10n.editWireguardServer : l10n.newWireguardServer,
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
                decoration: InputDecoration(
                  labelText: l10n.name,
                  hintText: l10n.myWireguardServer,
                  prefixIcon: const Icon(Icons.label),
                ),
                validator: (value) => CommonValidators.required(value, fieldName: l10n.name),
                enabled: !_viewModel.isLoading,
              ),
              const SizedBox(height: 16),

              // Port
              TextFormField(
                controller: _portController,
                decoration: InputDecoration(
                  labelText: l10n.port,
                  hintText: '51820',
                  prefixIcon: const Icon(Icons.settings_ethernet),
                  helperText: l10n.udpPortDefault51820,
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
                title: l10n.tunnelAddresses,
                items: _tunnelAddresses,
                onAdd: _addTunnelAddress,
                onRemove: (address) => setState(() => _tunnelAddresses.remove(address)),
                isLoading: _viewModel.isLoading,
                emptyMessage: l10n.noTunnelAddressesConfigured,
              ),
              const SizedBox(height: 24),

              // MTU
              TextFormField(
                controller: _mtuController,
                decoration: InputDecoration(
                  labelText: l10n.mtuOptional,
                  hintText: '1420',
                  prefixIcon: const Icon(Icons.settings),
                  helperText: l10n.maximumTransmissionUnit,
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: WireGuardValidators.validateMTU,
                enabled: !_viewModel.isLoading,
              ),
              const SizedBox(height: 16),

              // DNS Servers
              ListManagerCard(
                title: l10n.dnsServersOptional,
                items: _dnsServers,
                onAdd: _addDnsServer,
                onRemove: (dns) => setState(() => _dnsServers.remove(dns)),
                isLoading: _viewModel.isLoading,
                emptyMessage: l10n.noDnsServersConfigured,
              ),
              const SizedBox(height: 16),

              // Gateway
              TextFormField(
                controller: _gatewayController,
                decoration: InputDecoration(
                  labelText: l10n.gatewayOptional,
                  hintText: '10.10.10.1',
                  prefixIcon: const Icon(Icons.router),
                ),
                enabled: !_viewModel.isLoading,
              ),
              const SizedBox(height: 16),

              // CARP Depend On
              DropdownButtonFormField<String>(
                initialValue: _carpDependOn.isEmpty ? '' : _carpDependOn,
                decoration: InputDecoration(
                  labelText: l10n.dependOnCarp,
                  hintText: l10n.selectVhid,
                  prefixIcon: const Icon(Icons.link),
                  helperText: l10n.carpVhidToDepend,
                ),
                items: [
                  DropdownMenuItem<String>(
                    value: '',
                    child: Text(l10n.none),
                  ),
                  ..._viewModel.carpVipOptions.map((option) => DropdownMenuItem<String>(
                        value: option.vhid,
                        child: Text(option.displayName),
                      )),
                ],
                onChanged: _viewModel.isLoading || _viewModel.loadingCarpOptions
                    ? null
                    : (value) => setState(() => _carpDependOn = value ?? ''),
              ),
              const SizedBox(height: 16),

              // Peers
              Text(
                l10n.authorizedPeers,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Card(
                child: ListTile(
                  title: Text(l10n.peersSelected(_selectedPeerUuids.length)),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: _viewModel.isLoading || _viewModel.loadingPeers
                      ? null
                      : _selectPeers,
                ),
              ),
              const SizedBox(height: 16),

              // Switches
              SwitchListTile(
                title: Text(l10n.disableRoutes),
                subtitle: Text(l10n.preventAutomaticRouteInstallation),
                value: _disableRoutes,
                onChanged: _viewModel.isLoading
                    ? null
                    : (value) => setState(() => _disableRoutes = value),
              ),
              SwitchListTile(
                title: Text(l10n.debug),
                subtitle: Text(l10n.enableDebugLogging),
                value: _debug,
                onChanged: _viewModel.isLoading
                    ? null
                    : (value) => setState(() => _debug = value),
              ),
              SwitchListTile(
                title: Text(l10n.enabled),
                subtitle: Text(l10n.serverWillBeActiveWhenEnabled),
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
                  _viewModel.isEditing ? l10n.updateServer : l10n.createServer,
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


