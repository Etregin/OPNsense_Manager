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
import 'package:qr_flutter/qr_flutter.dart';
import '../models/wireguard_client_builder.dart';
import '../models/system_info.dart';
import '../services/opnsense_api_service.dart';
import '../viewmodels/wireguard_peer_generator_view_model.dart';
import '../widgets/app_drawer.dart';
import '../widgets/common/loading_overlay.dart';
import '../utils/common_validators.dart';
import '../l10n/app_localizations.dart';

/// Screen for generating WireGuard peer configurations
class WireGuardPeerGeneratorScreen extends StatefulWidget {
  const WireGuardPeerGeneratorScreen({super.key});

  @override
  State<WireGuardPeerGeneratorScreen> createState() =>
      _WireGuardPeerGeneratorScreenState();
}

class _WireGuardPeerGeneratorScreenState
    extends State<WireGuardPeerGeneratorScreen> {
  late WireGuardPeerGeneratorViewModel _viewModel;
  final _formKey = GlobalKey<FormState>();
  SystemInfo? _systemInfo;
  bool _isInitialized = false;

  // Controllers
  final _nameController = TextEditingController();
  final _endpointController = TextEditingController();
  final _addressController = TextEditingController();
  final _allowedIpsController = TextEditingController(text: '0.0.0.0/0,::/0');
  final _keepaliveController = TextEditingController();
  final _dnsController = TextEditingController();
  final _pskController = TextEditingController();
  final _privateKeyController = TextEditingController();
  final _publicKeyController = TextEditingController();

  String? _selectedServerUuid;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final apiService = context.read<OPNsenseApiService>();
      _viewModel = WireGuardPeerGeneratorViewModel(
        apiService: apiService,
      );
      _viewModel.addListener(_onViewModelChanged);
      _isInitialized = true;
      _loadData();
    }
  }

  Future<void> _loadData() async {
    await Future.wait([
      _viewModel.loadBuilderData(),
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

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    _nameController.dispose();
    _endpointController.dispose();
    _addressController.dispose();
    _allowedIpsController.dispose();
    _keepaliveController.dispose();
    _dnsController.dispose();
    _pskController.dispose();
    _privateKeyController.dispose();
    _publicKeyController.dispose();
    super.dispose();
  }

  void _onViewModelChanged() {
    if (mounted) {
      // Update text controllers when view model changes
      if (_viewModel.keyPair != null) {
        if (_privateKeyController.text != _viewModel.keyPair!.privateKey) {
          _privateKeyController.text = _viewModel.keyPair!.privateKey;
        }
        if (_publicKeyController.text != _viewModel.keyPair!.publicKey) {
          _publicKeyController.text = _viewModel.keyPair!.publicKey;
        }
      }
      if (_viewModel.psk != null && _pskController.text != _viewModel.psk!) {
        _pskController.text = _viewModel.psk!;
      }
      setState(() {});
    }
  }

  Future<void> _onServerSelected(String? serverUuid) async {
    if (serverUuid == null) return;

    setState(() {
      _selectedServerUuid = serverUuid;
    });

    await _viewModel.loadServerInfo(serverUuid);

    if (!mounted) return;

    final serverInfo = _viewModel.selectedServerInfo;
    if (serverInfo != null) {
      setState(() {
        // Build endpoint only when both parts are present
        final endpoint = serverInfo.endpoint.isNotEmpty && serverInfo.port.isNotEmpty
            ? '${serverInfo.endpoint}:${serverInfo.port}'
            : serverInfo.endpoint.isNotEmpty
                ? serverInfo.endpoint
                : serverInfo.port.isNotEmpty
                    ? serverInfo.port
                    : '';
        _endpointController.text = endpoint;
        
        // Use tunneladdress (client IP) if available, otherwise fall back to address
        // tunneladdress contains the next available client IP (e.g., 10.1.1.1/24)
        // address contains the server's network address (e.g., 10.0.0.0/24)
        _addressController.text = serverInfo.tunneladdress.isNotEmpty
            ? serverInfo.tunneladdress
            : serverInfo.address;
        _dnsController.text = serverInfo.peerDns;
      });
    }
  }

  Future<void> _generatePsk() async {
    await _viewModel.generatePsk();

    if (!mounted) return;

    if (_viewModel.psk != null) {
      _pskController.text = _viewModel.psk!;
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.presharedKeyGeneratedSuccessfully),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _saveAndGenerateNext() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final l10n = AppLocalizations.of(context)!;

    if (_selectedServerUuid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.selectServerInstance),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Use edited values from text controllers
    final privateKey = _privateKeyController.text.trim();
    final publicKey = _publicKeyController.text.trim();
    
    if (privateKey.isEmpty || publicKey.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.keysRequired),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final serverInfo = _viewModel.selectedServerInfo;
    if (serverInfo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.serverInfoNotLoaded),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final request = WireGuardClientBuilderRequest(
      name: _nameController.text.trim(),
      pubkey: publicKey,
      privkey: privateKey,
      tunneladdress: _addressController.text.trim(),
      serveraddress: serverInfo.endpoint,
      serverport: serverInfo.port,
      serverpubkey: serverInfo.pubkey,
      servers: _selectedServerUuid!,
      psk: _pskController.text.trim(),
      keepalive: _keepaliveController.text.trim(),
      endpoint: _endpointController.text.trim(),
    );

    final success = await _viewModel.saveAndGenerateNext(request);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.peerCreatedReadyForNext),
            backgroundColor: Colors.green,
          ),
        );
        // Reset form for next peer
        _nameController.clear();
        _pskController.clear();
        _viewModel.clearPsk();
        setState(() {
          _selectedServerUuid = null;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _viewModel.errorMessage ?? 'Failed to create peer',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _applyConfiguration() async {
    final success = await _viewModel.applyConfiguration();

    if (mounted) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? l10n.configurationAppliedSuccessfully
                : _viewModel.errorMessage ?? l10n.failedToApplyConfiguration,
          ),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
    }
  }

  String _generateConfigPreview() {
    final serverInfo = _viewModel.selectedServerInfo;
    final privateKey = _privateKeyController.text.trim();

    if (privateKey.isEmpty || serverInfo == null) {
      return '# Select a server and generate keys to preview configuration';
    }

    final config = StringBuffer();
    config.writeln('[Interface]');
    config.writeln('PrivateKey = $privateKey');
    config.writeln('Address = ${_addressController.text.trim()}');
    if (_dnsController.text.trim().isNotEmpty) {
      config.writeln('DNS = ${_dnsController.text.trim()}');
    }
    config.writeln();
    config.writeln('[Peer]');
    config.writeln('PublicKey = ${serverInfo.pubkey}');
    final psk = _pskController.text.trim();
    if (psk.isNotEmpty) {
      config.writeln('PresharedKey = $psk');
    }
    config.writeln('Endpoint = ${_endpointController.text.trim()}');
    config.writeln('AllowedIPs = ${_allowedIpsController.text.trim()}');
    if (_keepaliveController.text.trim().isNotEmpty) {
      config.writeln('PersistentKeepalive = ${_keepaliveController.text.trim()}');
    }

    return config.toString();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final builderData = _viewModel.builderData;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.peerGenerator),
      ),
      drawer: AppDrawer(
        currentRoute: 'wireguard_peer_generator',
        systemInfo: _systemInfo,
      ),
      body: LoadingOverlay(
        isLoading: _viewModel.isLoading || _viewModel.loadingBuilder,
        child: _viewModel.errorMessage != null
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
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        _viewModel.errorMessage!,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        _viewModel.clearError();
                        _loadData();
                      },
                      icon: const Icon(Icons.refresh),
                      label: Text(l10n.retry),
                    ),
                  ],
                ),
              )
            : builderData == null
                ? const Center(child: CircularProgressIndicator())
                : Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Instance Dropdown
                    DropdownButtonFormField<String>(
                      initialValue: _selectedServerUuid,
                      decoration: InputDecoration(
                        labelText: l10n.instance,
                        prefixIcon: const Icon(Icons.dns),
                      ),
                      items: builderData.serverUuids.map((uuid) {
                        final server = builderData.servers[uuid]!;
                        return DropdownMenuItem(
                          value: uuid,
                          child: Text(server.value),
                        );
                      }).toList(),
                      onChanged: _viewModel.loadingServerInfo
                          ? null
                          : _onServerSelected,
                      validator: (value) =>
                          value == null ? l10n.pleaseSelectAnInstance : null,
                    ),
                    const SizedBox(height: 16),

                    // Endpoint
                    TextFormField(
                      controller: _endpointController,
                      decoration: InputDecoration(
                        labelText: l10n.endpoint,
                        hintText: 'server.example.com:51820',
                        prefixIcon: const Icon(Icons.public),
                      ),
                      validator: (value) =>
                          CommonValidators.required(value, fieldName: l10n.endpoint),
                      enabled: !_viewModel.isLoading,
                    ),
                    const SizedBox(height: 16),

                    // Name
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: l10n.name,
                        hintText: l10n.clientName,
                        prefixIcon: const Icon(Icons.label),
                      ),
                      validator: (value) =>
                          CommonValidators.required(value, fieldName: l10n.name),
                      enabled: !_viewModel.isLoading,
                    ),
                    const SizedBox(height: 16),

                    // Public Key
                    TextFormField(
                      controller: _publicKeyController,
                      decoration: InputDecoration(
                        labelText: l10n.publicKey,
                        hintText: l10n.enterOrGeneratePublicKey,
                        prefixIcon: const Icon(Icons.key),
                      ),
                      validator: (value) =>
                          CommonValidators.required(value, fieldName: l10n.publicKey),
                      enabled: !_viewModel.isLoading,
                      maxLines: 2,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Private Key
                    TextFormField(
                      controller: _privateKeyController,
                      decoration: InputDecoration(
                        labelText: l10n.privateKey,
                        hintText: l10n.enterOrGeneratePrivateKey,
                        prefixIcon: const Icon(Icons.vpn_key),
                      ),
                      validator: (value) =>
                          CommonValidators.required(value, fieldName: l10n.privateKey),
                      enabled: !_viewModel.isLoading,
                      maxLines: 2,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Generate Key Pair Button
                    OutlinedButton.icon(
                      onPressed: _viewModel.generatingKeys || _viewModel.isLoading
                          ? null
                          : _viewModel.regenerateKeyPair,
                      icon: _viewModel.generatingKeys
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.refresh),
                      label: Text(l10n.generateNewKeyPair),
                    ),
                    const SizedBox(height: 16),

                    // Address
                    TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        labelText: l10n.address,
                        hintText: '10.10.10.2/24',
                        prefixIcon: const Icon(Icons.location_on),
                      ),
                      validator: (value) =>
                          CommonValidators.required(value, fieldName: l10n.address),
                      enabled: !_viewModel.isLoading,
                    ),
                    const SizedBox(height: 16),

                    // Pre-shared Key
                    TextFormField(
                      controller: _pskController,
                      decoration: InputDecoration(
                        labelText: l10n.presharedKeyOptional,
                        hintText: l10n.enterOrGeneratePresharedKey,
                        prefixIcon: const Icon(Icons.security),
                        suffixIcon: IconButton(
                          icon: _viewModel.generatingPsk
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.vpn_key),
                          onPressed: _viewModel.generatingPsk
                              ? null
                              : _generatePsk,
                          tooltip: l10n.generatePresharedKey,
                        ),
                      ),
                      enabled: !_viewModel.isLoading,
                      maxLines: 2,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Allowed IPs
                    TextFormField(
                      controller: _allowedIpsController,
                      decoration: InputDecoration(
                        labelText: l10n.allowedIpsLabel,
                        hintText: '0.0.0.0/0,::/0',
                        prefixIcon: const Icon(Icons.network_check),
                      ),
                      validator: (value) =>
                          CommonValidators.required(value, fieldName: l10n.allowedIpsLabel),
                      enabled: !_viewModel.isLoading,
                    ),
                    const SizedBox(height: 16),

                    // Keep Alive
                    TextFormField(
                      controller: _keepaliveController,
                      decoration: InputDecoration(
                        labelText: l10n.keepAliveIntervalOptional,
                        hintText: '25',
                        prefixIcon: const Icon(Icons.timer),
                        helperText: l10n.seconds,
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      enabled: !_viewModel.isLoading,
                    ),
                    const SizedBox(height: 16),

                    // DNS Server
                    TextFormField(
                      controller: _dnsController,
                      decoration: InputDecoration(
                        labelText: l10n.dnsServerOptional,
                        hintText: '1.1.1.1',
                        prefixIcon: const Icon(Icons.dns),
                      ),
                      enabled: !_viewModel.isLoading,
                    ),
                    const SizedBox(height: 24),

                    // Config Preview
                    Text(
                      l10n.configurationPreview,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: SelectableText(
                          _generateConfigPreview(),
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // QR Code
                    Text(
                      l10n.qrCode,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Center(
                          child: _privateKeyController.text.trim().isNotEmpty &&
                                  _viewModel.selectedServerInfo != null
                              ? Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: QrImageView(
                                    data: _generateConfigPreview(),
                                    version: QrVersions.auto,
                                    size: 200.0,
                                  ),
                                )
                              : Text(l10n.selectServerToGenerateQrCode),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Store and Generate Next Button
                    ElevatedButton(
                      onPressed: _viewModel.isLoading
                          ? null
                          : _saveAndGenerateNext,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        l10n.storeAndGenerateNext,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Enable WireGuard Toggle
                    SwitchListTile(
                      title: Text(l10n.enableWireguard),
                      subtitle: Text(l10n.startWireguardService),
                      value: _viewModel.wireguardEnabled,
                      onChanged: _viewModel.isLoading
                          ? null
                          : (value) async {
                              final messenger = ScaffoldMessenger.of(context);
                              final success =
                                  await _viewModel.toggleWireGuardService(value);
                              if (mounted && success) {
                                messenger.showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      value
                                          ? l10n.wireguardServiceStarted
                                          : l10n.wireguardServiceStopped,
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }
                            },
                    ),
                    const SizedBox(height: 8),

                    // Apply Button
                    OutlinedButton(
                      onPressed: _viewModel.isLoading
                          ? null
                          : _applyConfiguration,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        l10n.apply,
                        style: TextStyle(
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


