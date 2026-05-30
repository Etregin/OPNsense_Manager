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
import '../l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../models/wireguard_peer.dart';
import '../viewmodels/wireguard_peer_form_view_model.dart';
import '../widgets/common/loading_overlay.dart';
import '../widgets/wireguard/list_manager_card.dart';
import '../utils/common_validators.dart';
import '../utils/wireguard_validators.dart';

/// Form screen for creating/editing WireGuard peers (clients)
class WireGuardPeerFormScreen extends StatefulWidget {
  final String? peerUuid;

  const WireGuardPeerFormScreen({super.key, this.peerUuid});

  @override
  State<WireGuardPeerFormScreen> createState() =>
      _WireGuardPeerFormScreenState();
}

class _WireGuardPeerFormScreenState extends State<WireGuardPeerFormScreen> {
  late WireGuardPeerFormViewModel _viewModel;
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _publicKeyController = TextEditingController();
  final _privateKeyController = TextEditingController(); // Dummy for KeyPairSection
  final _pskController = TextEditingController();
  final _serverAddressController = TextEditingController();
  final _serverPortController = TextEditingController();
  final _endpointController = TextEditingController();
  final _keepaliveController = TextEditingController();

  // State
  List<String> _tunnelAddresses = [];
  List<String> _selectedServerUuids = [];
  bool _enabled = true;
  bool _publicKeyVisible = false;
  bool _pskVisible = false;

  @override
  void initState() {
    super.initState();
    _viewModel = WireGuardPeerFormViewModel(
      apiService: context.read(),
      existingPeerUuid: widget.peerUuid,
    );
    _viewModel.addListener(_onViewModelChanged);
    _viewModel.loadServers();

    if (_viewModel.isEditing) {
      _loadPeerData();
    } else {
      _serverPortController.text = '51820';
    }
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    _nameController.dispose();
    _publicKeyController.dispose();
    _privateKeyController.dispose();
    _pskController.dispose();
    _serverAddressController.dispose();
    _serverPortController.dispose();
    _endpointController.dispose();
    _keepaliveController.dispose();
    super.dispose();
  }

  void _onViewModelChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _loadPeerData() async {
    await _viewModel.loadPeer(widget.peerUuid!);
    
    if (!mounted) return;
    
    final peerData = _viewModel.loadedPeerData;
    if (peerData != null) {
      setState(() {
        // Update all controllers and state together to ensure proper rebuild
        _nameController.text = peerData.name;
        _publicKeyController.text = peerData.pubkey;
        _pskController.text = peerData.psk;
        _serverAddressController.text = peerData.serveraddress;
        _serverPortController.text = peerData.serverport;
        _endpointController.text = peerData.endpoint;
        _keepaliveController.text = peerData.keepalive;
        _tunnelAddresses = peerData.getSelectedTunnelAddresses();
        _selectedServerUuids = peerData.getSelectedServerUuids();
        _enabled = peerData.enabled == '1';
      });
    }
  }

  Future<void> _generatePsk() async {
    final psk = await _viewModel.generatePsk();
    
    if (!mounted) return;
    
    if (psk != null) {
      setState(() {
        _pskController.text = psk;
      });
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.presharedKeyGeneratedSuccessfully),
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

  Future<void> _savePeer() async {
    if (!_formKey.currentState!.validate()) return;

    final l10n = AppLocalizations.of(context)!;

    if (_tunnelAddresses.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.tunnelAddressRequired),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedServerUuids.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.serverSelectionRequired),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final request = WireGuardPeerRequest(
      name: _nameController.text.trim(),
      pubkey: _publicKeyController.text.trim(),
      privkey: '', // Private key not needed for peer configuration
      tunneladdress: _tunnelAddresses.join(','),
      serveraddress: _serverAddressController.text.trim(),
      serverport: _serverPortController.text.trim(),
      serverpubkey: '', // Server public key will be set by backend
      enabled: _enabled ? '1' : '0',
      endpoint: _endpointController.text.trim().isEmpty 
          ? null 
          : _endpointController.text.trim(),
      servers: _selectedServerUuids.join(','),
      keepalive: _keepaliveController.text.trim().isEmpty 
          ? null 
          : _keepaliveController.text.trim(),
      psk: _pskController.text.trim().isEmpty 
          ? null 
          : _pskController.text.trim(),
    );

    final success = await _viewModel.savePeer(request);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _viewModel.isEditing
                  ? l10n.peerUpdatedSuccessfully
                  : l10n.peerCreatedSuccessfully,
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _viewModel.errorMessage ?? l10n.failedToSavePeer,
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
      hintText: '10.10.10.2/24',
      helperText: l10n.exampleCidr,
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

  Future<void> _selectServers() async {
    final selected = await showDialog<List<String>>(
      context: context,
      builder: (context) => _ServerSelectorDialog(
        availableServers: _viewModel.availableServers,
        selectedServerUuids: _selectedServerUuids,
      ),
    );

    if (selected != null && mounted) {
      setState(() => _selectedServerUuids = selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _viewModel.isEditing ? l10n.editWireguardPeer : l10n.newWireguardPeer,
        ),
      ),
      body: LoadingOverlay(
        isLoading: _viewModel.isLoading || _viewModel.loadingPeer,
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
                  hintText: l10n.myWireguardPeer,
                  prefixIcon: const Icon(Icons.label),
                ),
                validator: (value) => CommonValidators.required(value, fieldName: l10n.name),
                enabled: !_viewModel.isLoading,
              ),
              const SizedBox(height: 16),

              // Public Key
              TextFormField(
                controller: _publicKeyController,
                obscureText: !_publicKeyVisible,
                maxLines: 1,
                decoration: InputDecoration(
                  labelText: l10n.publicKey,
                  prefixIcon: const Icon(Icons.vpn_key),
                  helperText: l10n.base64EncodedPublicKey,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _publicKeyVisible ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _publicKeyVisible = !_publicKeyVisible;
                      });
                    },
                    tooltip: _publicKeyVisible ? l10n.hideKey : l10n.showKey,
                  ),
                ),
                validator: (value) {
                  final trimmed = value?.trim() ?? '';
                  if (trimmed.isEmpty) {
                    return l10n.publicKeyRequired;
                  }
                  // Base64 pattern: allows A-Z, a-z, 0-9, +, /, and up to 2 = for padding
                  final base64Pattern = RegExp(r'^[A-Za-z0-9+/]*={0,2}$');
                  if (!base64Pattern.hasMatch(trimmed)) {
                    return l10n.invalidBase64Format;
                  }
                  return null;
                },
                enabled: !_viewModel.isLoading,
              ),
              const SizedBox(height: 16),

              // Pre-shared Key (Optional)
              TextFormField(
                controller: _pskController,
                obscureText: !_pskVisible,
                maxLines: 1,
                decoration: InputDecoration(
                  labelText: l10n.presharedKeyOptional,
                  hintText: l10n.leaveEmptyOrGenerate,
                  prefixIcon: const Icon(Icons.vpn_key),
                  helperText: l10n.optionalBase64EncodedPresharedKey,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _pskVisible ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _pskVisible = !_pskVisible;
                      });
                    },
                    tooltip: _pskVisible ? l10n.hideKey : l10n.showKey,
                  ),
                ),
                validator: (value) {
                  final trimmed = value?.trim() ?? '';
                  if (trimmed.isEmpty) {
                    return null; // Optional field
                  }
                  // Base64 pattern: allows A-Z, a-z, 0-9, +, /, and up to 2 = for padding
                  final base64Pattern = RegExp(r'^[A-Za-z0-9+/]*={0,2}$');
                  if (!base64Pattern.hasMatch(trimmed)) {
                    return l10n.invalidBase64Format;
                  }
                  return null;
                },
                enabled: !_viewModel.isLoading,
              ),
              const SizedBox(height: 8),

              // Generate PSK Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _viewModel.isLoading || _viewModel.isGeneratingPsk
                      ? null
                      : _generatePsk,
                  icon: _viewModel.isGeneratingPsk
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.refresh),
                  label: Text(
                    _viewModel.isGeneratingPsk ? l10n.generating : l10n.generatePresharedKey,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Allowed IPs
              ListManagerCard(
                title: l10n.allowedIps,
                items: _tunnelAddresses,
                onAdd: _addTunnelAddress,
                onRemove: (address) => setState(() => _tunnelAddresses.remove(address)),
                isLoading: _viewModel.isLoading,
                emptyMessage: l10n.noTunnelAddressesConfigured,
              ),
              const SizedBox(height: 24),

              // Endpoint Address
              TextFormField(
                controller: _serverAddressController,
                decoration: InputDecoration(
                  labelText: l10n.endpointAddress,
                  hintText: '192.168.1.1 or vpn.example.com',
                  prefixIcon: const Icon(Icons.dns),
                ),
                validator: (value) => CommonValidators.required(value, fieldName: l10n.endpointAddress),
                enabled: !_viewModel.isLoading,
              ),
              const SizedBox(height: 16),

              // Endpoint Port
              TextFormField(
                controller: _serverPortController,
                decoration: InputDecoration(
                  labelText: l10n.endpointPort,
                  hintText: '51820',
                  prefixIcon: const Icon(Icons.settings_ethernet),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: CommonValidators.port,
                enabled: !_viewModel.isLoading,
              ),
              const SizedBox(height: 16),

              // Keepalive
              TextFormField(
                controller: _keepaliveController,
                decoration: InputDecoration(
                  labelText: l10n.keepaliveOptional,
                  hintText: '25',
                  prefixIcon: const Icon(Icons.timer),
                  helperText: l10n.persistentKeepaliveSeconds,
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: WireGuardValidators.validateKeepalive,
                enabled: !_viewModel.isLoading,
              ),
              const SizedBox(height: 16),

              // Servers Selection
              Text(
                l10n.instances,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Card(
                child: ListTile(
                  title: Text(l10n.serversSelected(_selectedServerUuids.length)),
                  subtitle: _selectedServerUuids.isEmpty
                      ? Text(l10n.noServersSelected)
                      : null,
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: _viewModel.isLoading || _viewModel.loadingServers
                      ? null
                      : _selectServers,
                ),
              ),
              const SizedBox(height: 16),

              // Enabled Switch
              SwitchListTile(
                title: Text(l10n.enabled),
                subtitle: Text(l10n.peerWillBeActiveWhenEnabled),
                value: _enabled,
                onChanged: _viewModel.isLoading
                    ? null
                    : (value) => setState(() => _enabled = value),
              ),
              const SizedBox(height: 24),

              // Save Button
              ElevatedButton(
                onPressed: _viewModel.isLoading ? null : _savePeer,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  _viewModel.isEditing ? l10n.updatePeer : l10n.createPeer,
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

/// Dialog for selecting servers
class _ServerSelectorDialog extends StatefulWidget {
  final List availableServers;
  final List<String> selectedServerUuids;

  const _ServerSelectorDialog({
    required this.availableServers,
    required this.selectedServerUuids,
  });

  @override
  State<_ServerSelectorDialog> createState() => _ServerSelectorDialogState();
}

class _ServerSelectorDialogState extends State<_ServerSelectorDialog> {
  late List<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = List.from(widget.selectedServerUuids);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.selectServersTitle),
      content: SizedBox(
        width: double.maxFinite,
        child: widget.availableServers.isEmpty
            ? Center(child: Text(l10n.noServersAvailable))
            : ListView.builder(
                shrinkWrap: true,
                itemCount: widget.availableServers.length,
                itemBuilder: (context, index) {
                  final server = widget.availableServers[index];
                  final isSelected = _selected.contains(server.uuid);
                  
                  return CheckboxListTile(
                    title: Text(server.name),
                    subtitle: Text('${server.tunneladdress} (${l10n.port}: ${server.port})'),
                    value: isSelected,
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          _selected.add(server.uuid);
                        } else {
                          _selected.remove(server.uuid);
                        }
                      });
                    },
                  );
                },
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(_selected),
          child: Text(l10n.done),
        ),
      ],
    );
  }
}


