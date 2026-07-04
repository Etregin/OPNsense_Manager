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
import '../l10n/app_localizations.dart';
import '../models/openvpn_client_override.dart';
import '../models/openvpn_dropdown_option.dart';
import '../services/demo_api_service.dart';
import '../utils/snackbar_helper.dart';
import '../widgets/app_drawer.dart';
import '../widgets/common/loading_overlay.dart';
import '../widgets/common/form_section_container.dart';
import '../widgets/openvpn/openvpn_form_field_widgets.dart' hide FormSectionContainer;

/// Form screen for adding or editing OpenVPN Client Specific Overrides
class OpenvpnClientOverrideFormScreen extends StatefulWidget {
  final String? uuid;

  const OpenvpnClientOverrideFormScreen({super.key, this.uuid});

  @override
  State<OpenvpnClientOverrideFormScreen> createState() =>
      _OpenvpnClientOverrideFormScreenState();
}

class _OpenvpnClientOverrideFormScreenState
    extends State<OpenvpnClientOverrideFormScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _isSaving = false;
  String? _errorMessage;

  // Form controllers
  final _commonNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _tunnelNetworkController = TextEditingController();
  final _tunnelNetworkv6Controller = TextEditingController();
  final _routeGatewayController = TextEditingController();

  // Boolean fields
  bool _enabled = true;
  bool _block = false;
  bool _pushReset = false;
  bool _registerDns = false;

  // Dropdown options (loaded from API)
  Map<String, OpenvpnDropdownOption> _serversOptions = {};
  Map<String, OpenvpnDropdownOption> _localNetworksOptions = {};
  Map<String, OpenvpnDropdownOption> _remoteNetworksOptions = {};
  Map<String, OpenvpnDropdownOption> _redirectGatewayOptions = {};
  Map<String, OpenvpnDropdownOption> _dnsDomainOptions = {};
  Map<String, OpenvpnDropdownOption> _dnsDomainSearchOptions = {};
  Map<String, OpenvpnDropdownOption> _dnsServersOptions = {};
  Map<String, OpenvpnDropdownOption> _ntpServersOptions = {};
  Map<String, OpenvpnDropdownOption> _winsServersOptions = {};

  // Selected values for multi-select fields
  List<String> _selectedServers = [];
  List<String> _selectedRedirectGateway = [];

  // List fields for multi-entry inputs
  List<String> _localNetworks = [];
  List<String> _remoteNetworks = [];
  List<String> _dnsDomainList = [];
  List<String> _dnsDomainSearchList = [];
  List<String> _dnsServers = [];
  List<String> _ntpServers = [];
  List<String> _winsServers = [];

  @override
  void initState() {
    super.initState();
    // Load override after the first frame to ensure context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadOverride();
      }
    });
  }

  @override
  void dispose() {
    _commonNameController.dispose();
    _descriptionController.dispose();
    _tunnelNetworkController.dispose();
    _tunnelNetworkv6Controller.dispose();
    _routeGatewayController.dispose();
    super.dispose();
  }

  bool get _isEditMode => widget.uuid != null;

  Future<void> _loadOverride() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final apiService = context.read<DemoApiService>();
      final override = await apiService.getClientOverride(widget.uuid);

      if (mounted) {
        setState(() {
          _loadOverrideData(override);
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

  void _loadOverrideData(OpenvpnClientOverride override) {
    // Load basic fields
    _enabled = override.enabled == '1';
    _block = override.block == '1';
    _pushReset = override.pushReset == '1';
    _registerDns = override.registerDns == '1';

    _commonNameController.text = override.commonName;
    _descriptionController.text = override.description;
    _tunnelNetworkController.text = override.tunnelNetwork;
    _tunnelNetworkv6Controller.text = override.tunnelNetworkv6;
    _routeGatewayController.text = override.routeGateway;

    // Load dropdown options and selected values
    _serversOptions = override.servers;
    _selectedServers = override.servers.entries
        .where((e) => e.value.selected)
        .map((e) => e.key)
        .toList();

    _redirectGatewayOptions = override.redirectGateway;
    _selectedRedirectGateway = override.redirectGateway.entries
        .where((e) => e.value.selected)
        .map((e) => e.key)
        .toList();

    // Load multi-entry list fields - convert from dropdown options to lists
    _localNetworksOptions = override.localNetworks;
    _localNetworks = override.localNetworks.entries
        .where((e) => e.value.selected)
        .map((e) => e.key)
        .toList();

    _remoteNetworksOptions = override.remoteNetworks;
    _remoteNetworks = override.remoteNetworks.entries
        .where((e) => e.value.selected)
        .map((e) => e.key)
        .toList();

    _dnsDomainOptions = override.dnsDomain;
    _dnsDomainList = override.dnsDomain.entries
        .where((e) => e.value.selected)
        .map((e) => e.key)
        .toList();

    _dnsDomainSearchOptions = override.dnsDomainSearch;
    _dnsDomainSearchList = override.dnsDomainSearch.entries
        .where((e) => e.value.selected)
        .map((e) => e.key)
        .toList();

    _dnsServersOptions = override.dnsServers;
    _dnsServers = override.dnsServers.entries
        .where((e) => e.value.selected)
        .map((e) => e.key)
        .toList();

    _ntpServersOptions = override.ntpServers;
    _ntpServers = override.ntpServers.entries
        .where((e) => e.value.selected)
        .map((e) => e.key)
        .toList();

    _winsServersOptions = override.winsServers;
    _winsServers = override.winsServers.entries
        .where((e) => e.value.selected)
        .map((e) => e.key)
        .toList();
  }

  Future<void> _saveOverride() async {
    final l10n = AppLocalizations.of(context)!;
    
    if (!_formKey.currentState!.validate()) {
      SnackBarHelper.showError(context, l10n.fixFormErrors);
      return;
    }

    setState(() => _isSaving = true);

    try {
      final apiService = context.read<DemoApiService>();
      final override = _buildOverrideFromForm();

      await apiService.setClientOverride(widget.uuid ?? '', override);

      if (mounted) {
        SnackBarHelper.showSuccess(context, _isEditMode
            ? l10n.overrideUpdatedSuccessfully
            : l10n.overrideCreatedSuccessfully);
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        SnackBarHelper.showError(context, l10n.failedToSaveOverride(e.toString()), duration: const Duration(seconds: 4));
      }
    }
  }

  /// Helper method to convert List to Map of OpenvpnDropdownOption
  Map<String, OpenvpnDropdownOption> _listToDropdownMap(
    List<String> items,
    Map<String, OpenvpnDropdownOption> existingOptions,
  ) {
    final result = <String, OpenvpnDropdownOption>{};
    
    // First, mark all existing options as not selected
    existingOptions.forEach((key, option) {
      result[key] = OpenvpnDropdownOption(
        value: option.value,
        selected: false,
        optgroup: option.optgroup,
      );
    });
    
    // Then mark the selected values
    for (final value in items) {
      // Try to find the key in existing options
      final entry = existingOptions.entries.firstWhere(
        (e) => e.key == value || e.value.value == value,
        orElse: () => MapEntry(value, OpenvpnDropdownOption(value: value, selected: false)),
      );
      
      result[entry.key] = OpenvpnDropdownOption(
        value: entry.value.value,
        selected: true,
        optgroup: entry.value.optgroup,
      );
    }
    
    return result;
  }

  OpenvpnClientOverride _buildOverrideFromForm() {
    // Build servers map with selected values
    final servers = <String, OpenvpnDropdownOption>{};
    _serversOptions.forEach((key, option) {
      servers[key] = OpenvpnDropdownOption(
        value: option.value,
        selected: _selectedServers.contains(key),
        optgroup: option.optgroup,
      );
    });

    // Build redirect gateway map with selected values
    final redirectGateway = <String, OpenvpnDropdownOption>{};
    _redirectGatewayOptions.forEach((key, option) {
      redirectGateway[key] = OpenvpnDropdownOption(
        value: option.value,
        selected: _selectedRedirectGateway.contains(key),
        optgroup: option.optgroup,
      );
    });

    // Convert list fields to dropdown maps
    final localNetworks = _listToDropdownMap(_localNetworks, _localNetworksOptions);
    final remoteNetworks = _listToDropdownMap(_remoteNetworks, _remoteNetworksOptions);
    final dnsDomain = _listToDropdownMap(_dnsDomainList, _dnsDomainOptions);
    final dnsDomainSearch = _listToDropdownMap(_dnsDomainSearchList, _dnsDomainSearchOptions);
    final dnsServers = _listToDropdownMap(_dnsServers, _dnsServersOptions);
    final ntpServers = _listToDropdownMap(_ntpServers, _ntpServersOptions);
    final winsServers = _listToDropdownMap(_winsServers, _winsServersOptions);

    return OpenvpnClientOverride(
      enabled: _enabled ? '1' : '0',
      servers: servers,
      commonName: _commonNameController.text.trim(),
      block: _block ? '1' : '0',
      pushReset: _pushReset ? '1' : '0',
      tunnelNetwork: _tunnelNetworkController.text.trim(),
      tunnelNetworkv6: _tunnelNetworkv6Controller.text.trim(),
      localNetworks: localNetworks,
      remoteNetworks: remoteNetworks,
      routeGateway: _routeGatewayController.text.trim(),
      redirectGateway: redirectGateway,
      registerDns: _registerDns ? '1' : '0',
      dnsDomain: dnsDomain,
      dnsDomainSearch: dnsDomainSearch,
      dnsServers: dnsServers,
      ntpServers: ntpServers,
      winsServers: winsServers,
      description: _descriptionController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? l10n.editClientOverride : l10n.addClientOverride),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isSaving ? null : _saveOverride,
            tooltip: l10n.save,
          ),
        ],
      ),
      drawer: const AppDrawer(currentRoute: 'openvpn_client_override_form'),
      body: LoadingOverlay(
        isLoading: _isSaving,
        message: l10n.savingOverride,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            size: 48, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(l10n.errorLoadingOverride),
                        const SizedBox(height: 8),
                        Text(_errorMessage!),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadOverride,
                          child: Text(l10n.retry),
                        ),
                      ],
                    ),
                  )
                : Form(
                    key: _formKey,
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        _buildGeneralSettings(),
                        _buildTunnelSettings(),
                        _buildClientSettings(),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _isSaving ? null : _saveOverride,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text(
                            _isEditMode
                                ? l10n.updateOverride
                                : l10n.createOverride,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
      ),
    );
  }

  Widget _buildGeneralSettings() {
    final l10n = AppLocalizations.of(context)!;
    return FormSectionContainer(
      title: l10n.generalSettings,
      children: [
        OpenvpnToggleField(
          title: l10n.enabled,
          subtitle: l10n.enableThisClientOverride,
          value: _enabled,
          onChanged: (value) => setState(() => _enabled = value),
        ),
        const SizedBox(height: 16),
        OpenvpnMultiSelectField(
          labelText: l10n.servers,
          helperText: l10n.selectServersHelperText,
          prefixIcon: Icons.dns,
          options: _serversOptions,
          selectedValues: _selectedServers,
          onChanged: (values) => setState(() => _selectedServers = values),
        ),
        const SizedBox(height: 16),
        OpenvpnTextField(
          controller: _descriptionController,
          labelText: l10n.description,
          hintText: l10n.enterDescriptionForOverride,
          helperText: l10n.descriptionHelperTextOverride,
          prefixIcon: Icons.description,
        ),
        const SizedBox(height: 16),
        OpenvpnTextField(
          controller: _commonNameController,
          labelText: l10n.commonName,
          hintText: l10n.enterClientCertificateCommonName,
          helperText: l10n.clientX509CommonNameHelper,
          prefixIcon: Icons.person,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return l10n.commonNameRequired;
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        OpenvpnToggleField(
          title: 'Connection blocking',
          subtitle: 'Block this client connection based on its common name. Don\'t use this option to permanently disable a client due to a compromised key or password. Use a CRL (certificate revocation list) instead.',
          value: _block,
          onChanged: (value) => setState(() => _block = value),
        ),
        const SizedBox(height: 16),
        OpenvpnToggleField(
          title: 'Push reset',
          subtitle: 'Don\'t inherit the global push list for a specific client instance. NOTE: --push-reset is very thorough: it will remove almost all options from the list of to-be-pushed options. In many cases, some of these options will need to be re-configured afterwards - specifically, --topology subnet and --route-gateway will get lost and this will break client configs in many cases.',
          value: _pushReset,
          onChanged: (value) => setState(() => _pushReset = value),
        ),
      ],
    );
  }

  Widget _buildTunnelSettings() {
    return FormSectionContainer(
      title: 'Tunnel Settings',
      children: [
        OpenvpnTextField(
          controller: _tunnelNetworkController,
          labelText: 'IPv4 Tunnel Network',
          hintText: '10.8.0.0/24',
          helperText: 'Push virtual IP endpoints for client tunnel, overriding dynamic allocation.',
          prefixIcon: Icons.vpn_lock,
          validator: (value) {
            if (value != null && value.trim().isNotEmpty) {
              if (!_isValidCidr(value.trim(), isIPv6: false)) {
                return 'Invalid IPv4 CIDR notation';
              }
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        OpenvpnTextField(
          controller: _tunnelNetworkv6Controller,
          labelText: 'IPv6 Tunnel Network',
          hintText: 'fd00::/64',
          helperText: 'Push virtual IP endpoints for client tunnel, overriding dynamic allocation.',
          prefixIcon: Icons.vpn_lock,
          validator: (value) {
            if (value != null && value.trim().isNotEmpty) {
              if (!_isValidCidr(value.trim(), isIPv6: true)) {
                return 'Invalid IPv6 CIDR notation';
              }
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        OpenvpnArrayField(
          title: 'Local Network',
          items: _localNetworks,
          onAdd: () => setState(() => _localNetworks.add('')),
          onRemove: (index) => setState(() => _localNetworks.removeAt(index)),
          onUpdate: (index, value) => setState(() => _localNetworks[index] = value),
          helperText: 'These are the networks accessible by the client, these are pushed via route{-ipv6} clauses in OpenVPN to the client.',
          emptyMessage: 'No local networks configured',
        ),
        const SizedBox(height: 16),
        OpenvpnArrayField(
          title: 'Remote Network',
          items: _remoteNetworks,
          onAdd: () => setState(() => _remoteNetworks.add('')),
          onRemove: (index) => setState(() => _remoteNetworks.removeAt(index)),
          onUpdate: (index, value) => setState(() => _remoteNetworks[index] = value),
          helperText: 'Remote networks for the server, these are configured via iroute{-ipv6} clauses in OpenVPN and inform the server to send these networks to this specific client.',
          emptyMessage: 'No remote networks configured',
        ),
        const SizedBox(height: 16),
        OpenvpnTextField(
          controller: _routeGatewayController,
          labelText: 'Route gateway',
          hintText: '10.8.0.1',
          helperText: 'Specify a default gateway to use for the connected client. Without one set the first address in the netblock is being offered. When segmenting the tunnel (server) network, this one might not be accessible from the client.',
          prefixIcon: Icons.alt_route,
          validator: (value) {
            if (value != null && value.trim().isNotEmpty) {
              if (!_isValidIpAddress(value.trim())) {
                return 'Invalid IP address';
              }
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        OpenvpnMultiSelectField(
          labelText: 'Redirect gateway',
          helperText: 'Automatically execute routing commands to cause all outgoing IP traffic to be redirected over the VPN.',
          prefixIcon: Icons.alt_route,
          options: _redirectGatewayOptions,
          selectedValues: _selectedRedirectGateway,
          onChanged: (values) =>
              setState(() => _selectedRedirectGateway = values),
        ),
      ],
    );
  }

  Widget _buildClientSettings() {
    return FormSectionContainer(
      title: 'Client Settings',
      children: [
        OpenvpnToggleField(
          title: 'Register DNS',
          subtitle: 'Run ipconfig /flushdns and ipconfig /registerdns on connection initiation. This is known to kick Windows into recognizing pushed DNS servers.',
          value: _registerDns,
          onChanged: (value) => setState(() => _registerDns = value),
        ),
        const SizedBox(height: 16),
        OpenvpnArrayField(
          title: 'DNS Domain List',
          items: _dnsDomainList,
          onAdd: () => setState(() => _dnsDomainList.add('')),
          onRemove: (index) => setState(() => _dnsDomainList.removeAt(index)),
          onUpdate: (index, value) => setState(() => _dnsDomainList[index] = value),
          helperText: 'Set Connection-specific DNS Suffixes.',
          emptyMessage: 'No DNS domains configured',
        ),
        const SizedBox(height: 16),
        OpenvpnArrayField(
          title: 'DNS Domain Search List',
          items: _dnsDomainSearchList,
          onAdd: () => setState(() => _dnsDomainSearchList.add('')),
          onRemove: (index) => setState(() => _dnsDomainSearchList.removeAt(index)),
          onUpdate: (index, value) => setState(() => _dnsDomainSearchList[index] = value),
          helperText: 'Add name to the domain search list. Repeat this option to add more entries. Up to 10 domains are supported.',
          emptyMessage: 'No DNS domain search entries configured',
        ),
        const SizedBox(height: 16),
        OpenvpnArrayField(
          title: 'DNS Servers',
          items: _dnsServers,
          onAdd: () => setState(() => _dnsServers.add('')),
          onRemove: (index) => setState(() => _dnsServers.removeAt(index)),
          onUpdate: (index, value) => setState(() => _dnsServers[index] = value),
          helperText: 'Set primary domain name server IPv4 or IPv6 address. Repeat this option to set secondary DNS server addresses.',
          emptyMessage: 'No DNS servers configured',
        ),
        const SizedBox(height: 16),
        OpenvpnArrayField(
          title: 'NTP Servers',
          items: _ntpServers,
          onAdd: () => setState(() => _ntpServers.add('')),
          onRemove: (index) => setState(() => _ntpServers.removeAt(index)),
          onUpdate: (index, value) => setState(() => _ntpServers[index] = value),
          helperText: 'Set primary NTP server address (Network Time Protocol). Repeat this option to set secondary NTP server addresses.',
          emptyMessage: 'No NTP servers configured',
        ),
        const SizedBox(height: 16),
        OpenvpnArrayField(
          title: 'WINS Servers',
          items: _winsServers,
          onAdd: () => setState(() => _winsServers.add('')),
          onRemove: (index) => setState(() => _winsServers.removeAt(index)),
          onUpdate: (index, value) => setState(() => _winsServers[index] = value),
          helperText: 'Set primary WINS server address (NetBIOS over TCP/IP Name Server). Repeat this option to set secondary WINS server addresses.',
          emptyMessage: 'No WINS servers configured',
        ),
      ],
    );
  }

  /// Validate CIDR notation
  bool _isValidCidr(String value, {required bool isIPv6}) {
    final parts = value.split('/');
    if (parts.length != 2) return false;

    final ip = parts[0].trim();
    final prefix = int.tryParse(parts[1].trim());

    if (prefix == null) return false;

    if (isIPv6) {
      if (prefix < 0 || prefix > 128) return false;
      return _isValidIPv6(ip);
    } else {
      if (prefix < 0 || prefix > 32) return false;
      return _isValidIPv4(ip);
    }
  }

  /// Validate IPv4 address
  bool _isValidIPv4(String ip) {
    final parts = ip.split('.');
    if (parts.length != 4) return false;

    for (final part in parts) {
      final num = int.tryParse(part);
      if (num == null || num < 0 || num > 255) return false;
    }

    return true;
  }

  /// Validate IPv6 address
  bool _isValidIPv6(String ip) {
    final ipv6Pattern = RegExp(
      r'^(([0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}|'
      r'([0-9a-fA-F]{1,4}:){1,7}:|'
      r'([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|'
      r'([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|'
      r'([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|'
      r'([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|'
      r'([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|'
      r'[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|'
      r':((:[0-9a-fA-F]{1,4}){1,7}|:)|'
      r'fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|'
      r'::(ffff(:0{1,4}){0,1}:){0,1}'
      r'((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3}'
      r'(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|'
      r'([0-9a-fA-F]{1,4}:){1,4}:'
      r'((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3}'
      r'(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]))$',
    );

    return ipv6Pattern.hasMatch(ip);
  }

  /// Validate IP address (IPv4 or IPv6)
  bool _isValidIpAddress(String ip) {
    return _isValidIPv4(ip) || _isValidIPv6(ip);
  }
}


