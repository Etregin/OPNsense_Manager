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
import '../models/openvpn_instance.dart';
import '../models/openvpn_dropdown_option.dart';
import '../services/opnsense_api_service.dart';
import '../widgets/common/loading_overlay.dart';
import '../widgets/openvpn/openvpn_form_field_widgets.dart';
import '../utils/common_validators.dart';

/// Form screen for adding/editing OpenVPN instances
class OpenvpnInstanceFormScreen extends StatefulWidget {
  final String? vpnid;

  const OpenvpnInstanceFormScreen({super.key, this.vpnid});

  @override
  State<OpenvpnInstanceFormScreen> createState() => _OpenvpnInstanceFormScreenState();
}

class _OpenvpnInstanceFormScreenState extends State<OpenvpnInstanceFormScreen> {
  final _formKey = GlobalKey<FormState>();
  
  bool _isLoading = false;
  bool _isSaving = false;
  String? _errorMessage;
  bool _showAdvanced = false;
  
  // Form data
  String _role = 'server';
  
  // Controllers
  final _descriptionController = TextEditingController();
  final _portController = TextEditingController();
  final _localController = TextEditingController();
  final _serverController = TextEditingController();
  final _serverIpv6Controller = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _renegSecController = TextEditingController();
  final _authTokenLifetimeController = TextEditingController();
  final _authTokenRenewalController = TextEditingController();
  final _authTokenSecretController = TextEditingController();
  final _httpProxyController = TextEditingController();
  final _verifyX509NameController = TextEditingController();
  final _tunMtuController = TextEditingController();
  final _fragmentController = TextEditingController();
  final _mssfixController = TextEditingController();
  final _pushInactiveController = TextEditingController();
  final _routeMetricController = TextEditingController();
  final _certDepthController = TextEditingController();
  final _dnsDomainController = TextEditingController();
  
  // State variables
  bool _enabled = true;
  bool _nopool = false;
  bool _useOcsp = false;
  final bool _usernameAsCommonName = false;
  bool _strictusercn = false;
  bool _authGenToken = false;
  bool _provisionExclusive = false;
  bool _redirectGateway = false;
  bool _registerDns = false;
  bool _ifconfigPoolPersist = false;
  
  // Dropdown selections
  String? _selectedDevType;
  String? _selectedProto;
  String? _selectedTopology;
  String? _selectedCert;
  String? _selectedCrl;
  String? _selectedRemoteCertTls;
  String? _selectedVerifyClientCert;
  String? _selectedAuth;
  String? _selectedAuthmode;
  String? _selectedLocalGroup;
  String? _selectedCarpDependOn;
  String? _selectedCompressMigrate;
  String? _selectedTlsKey;
  
  // Multi-select
  final List<String> _selectedDataCiphers = [];
  final List<String> _selectedDataCiphersFallback = [];
  
  // Arrays
  List<String> _remoteAddresses = [];
  List<String> _localNetworks = [];
  List<String> _remoteNetworks = [];
  List<String> _dnsDomainSearch = [];
  List<String> _dnsServers = [];
  List<String> _ntpServers = [];
  
  // Dropdown options (loaded from API)
  final Map<String, OpenvpnDropdownOption> _devTypeOptions = {};
  final Map<String, OpenvpnDropdownOption> _protoOptions = {};
  final Map<String, OpenvpnDropdownOption> _topologyOptions = {};
  final Map<String, OpenvpnDropdownOption> _certOptions = {};
  final Map<String, OpenvpnDropdownOption> _crlOptions = {};
  final Map<String, OpenvpnDropdownOption> _remoteCertTlsOptions = {};
  final Map<String, OpenvpnDropdownOption> _verifyClientCertOptions = {};
  final Map<String, OpenvpnDropdownOption> _authmodeOptions = {};
  final Map<String, OpenvpnDropdownOption> _localGroupOptions = {};
  final Map<String, OpenvpnDropdownOption> _carpDependOnOptions = {};
  final Map<String, OpenvpnDropdownOption> _compressMigrateOptions = {};
  final Map<String, OpenvpnDropdownOption> _tlsKeyOptions = {};

  @override
  void initState() {
    super.initState();
    // Load instance after the first frame to ensure context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadInstance();
      }
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _portController.dispose();
    _localController.dispose();
    _serverController.dispose();
    _serverIpv6Controller.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _renegSecController.dispose();
    _authTokenLifetimeController.dispose();
    _authTokenRenewalController.dispose();
    _authTokenSecretController.dispose();
    _httpProxyController.dispose();
    _verifyX509NameController.dispose();
    _tunMtuController.dispose();
    _fragmentController.dispose();
    _mssfixController.dispose();
    _pushInactiveController.dispose();
    _routeMetricController.dispose();
    _certDepthController.dispose();
    _dnsDomainController.dispose();
    super.dispose();
  }

  bool get _isEditMode => widget.vpnid != null;

  Future<void> _loadInstance() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final apiService = context.read<OPNsenseApiService>();
      final instance = await apiService.getOpenvpnInstance(widget.vpnid);
      
      if (mounted) {
        setState(() {
          _loadInstanceData(instance);
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

  void _loadInstanceData(OpenvpnInstance instance) {
    // Note: Dropdown options are loaded separately via _loadDropdownOptions()
    // The instance now stores only the selected values as strings
    
    // Load basic fields
    _role = instance.role;
    _descriptionController.text = instance.description;
    _enabled = instance.enabled;
    _portController.text = instance.port;
    _localController.text = instance.local ?? '';
    
    // Load selected dropdown values (now stored as strings)
    _selectedDevType = instance.devType;
    _selectedProto = instance.proto;
    _selectedTopology = instance.topology;
    _selectedCert = instance.cert;
    _selectedCrl = instance.crl;
    _selectedRemoteCertTls = instance.remoteCertTls;
    _selectedVerifyClientCert = instance.verifyClientCert;
    _selectedAuth = instance.auth;
    _selectedAuthmode = instance.authmode;
    _selectedLocalGroup = instance.localGroup;
    _selectedCarpDependOn = instance.carpDependOn;
    _selectedCompressMigrate = instance.compressMigrate;
    _selectedTlsKey = instance.tlsKey;
    
    // Load multi-select values (now stored as comma-separated strings)
    _selectedDataCiphers.clear();
    if (instance.dataCiphers != null && instance.dataCiphers!.isNotEmpty) {
      _selectedDataCiphers.addAll(instance.dataCiphers!.split(','));
    }
    
    _selectedDataCiphersFallback.clear();
    if (instance.dataCiphersFallback != null && instance.dataCiphersFallback!.isNotEmpty) {
      _selectedDataCiphersFallback.addAll(instance.dataCiphersFallback!.split(','));
    }
    
    // Load role-specific fields
    if (instance.isClient) {
      _remoteAddresses = List.from(instance.remote?.split(',') ?? []);
      _usernameController.text = instance.username ?? '';
      _passwordController.text = instance.password ?? '';
      _httpProxyController.text = instance.httpProxy ?? '';
    } else {
      _serverController.text = instance.server ?? '';
      _serverIpv6Controller.text = instance.serverIpv6 ?? '';
      _nopool = instance.nopool;
      _useOcsp = instance.useOcsp;
      _strictusercn = instance.strictusercn;
      _authGenToken = instance.authGenToken;
      _provisionExclusive = instance.provisionExclusive;
      _redirectGateway = instance.redirectGateway;
      _registerDns = instance.registerDns;
      _ifconfigPoolPersist = instance.ifconfigPoolPersist;
      _certDepthController.text = instance.certDepth ?? '';
      _dnsDomainController.text = instance.dnsDomain ?? '';
      _dnsDomainSearch = List.from(instance.dnsDomainSearch);
      _dnsServers = List.from(instance.dnsServers);
      _ntpServers = List.from(instance.ntpServers);
    }
    
    // Common fields
    _renegSecController.text = instance.renegSec ?? '';
    _localNetworks = List.from(instance.route);
    _remoteNetworks = List.from(instance.pushRoute);
    
    // Advanced fields
    _verifyX509NameController.text = instance.verifyX509Name ?? '';
    _tunMtuController.text = instance.tunMtu ?? '';
    _fragmentController.text = instance.fragment ?? '';
    _mssfixController.text = instance.mssfix ?? '';
    
    if (instance.isServer) {
      _authTokenRenewalController.text = instance.authGenTokenRenewal ?? '';
      _authTokenSecretController.text = instance.authGenTokenSecret ?? '';
      _pushInactiveController.text = instance.pushInactive ?? '';
      _routeMetricController.text = instance.routeMetric ?? '';
    }
  }

  Future<void> _saveInstance() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fix the errors in the form'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final apiService = context.read<OPNsenseApiService>();
      final instance = _buildInstanceFromForm();
      
      if (_isEditMode) {
        await apiService.updateOpenvpnInstance(widget.vpnid!, instance);
      } else {
        await apiService.addOpenvpnInstance(instance);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isEditMode
                  ? 'Instance updated successfully'
                  : 'Instance created successfully',
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save instance: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  OpenvpnInstance _buildInstanceFromForm() {
    return OpenvpnInstance(
      vpnid: widget.vpnid,
      enabled: _enabled,
      role: _role,
      description: _descriptionController.text.trim(),
      devType: _selectedDevType ?? 'tun',
      proto: _selectedProto ?? 'udp',
      port: _portController.text.trim(),
      local: _localController.text.trim().isEmpty ? null : _localController.text.trim(),
      portShare: null,
      topology: _selectedTopology ?? 'subnet',
      remote: _role == 'client' ? _remoteAddresses.join(',') : null,
      server: _role == 'server' ? _serverController.text.trim() : null,
      serverIpv6: _role == 'server' ? _serverIpv6Controller.text.trim() : null,
      nopool: _role == 'server' ? _nopool : false,
      bridgeGateway: null,
      bridgePool: null,
      route: _localNetworks,
      pushRoute: _remoteNetworks,
      pushExcludedRoutes: [],
      cert: _selectedCert,
      crl: _selectedCrl,
      ca: null,
      certDepth: _certDepthController.text.trim().isEmpty ? null : _certDepthController.text.trim(),
      remoteCertTls: _selectedRemoteCertTls,
      verifyClientCert: _selectedVerifyClientCert,
      useOcsp: _role == 'server' ? _useOcsp : false,
      tlsKey: _selectedTlsKey,
      auth: _selectedAuth,
      dataCiphers: _selectedDataCiphers.isNotEmpty ? _selectedDataCiphers.join(',') : null,
      dataCiphersFallback: _selectedDataCiphersFallback.isNotEmpty ? _selectedDataCiphersFallback.join(',') : null,
      authmode: _selectedAuthmode,
      localGroup: _selectedLocalGroup,
      usernameAsCommonName: _usernameAsCommonName,
      strictusercn: _role == 'server' ? _strictusercn : false,
      username: _role == 'client' ? _usernameController.text.trim() : null,
      password: _role == 'client' ? _passwordController.text.trim() : null,
      maxclients: null,
      keepaliveInterval: null,
      keepaliveTimeout: null,
      renegSec: _renegSecController.text.trim().isEmpty ? null : _renegSecController.text.trim(),
      authGenToken: _role == 'server' ? _authGenToken : false,
      authGenTokenRenewal: _authTokenRenewalController.text.trim().isEmpty ? null : _authTokenRenewalController.text.trim(),
      authGenTokenSecret: _authTokenSecretController.text.trim().isEmpty ? null : _authTokenSecretController.text.trim(),
      provisionExclusive: _role == 'server' ? _provisionExclusive : false,
      redirectGateway: _role == 'server' ? _redirectGateway : false,
      routeMetric: _routeMetricController.text.trim().isEmpty ? null : _routeMetricController.text.trim(),
      registerDns: _role == 'server' ? _registerDns : false,
      dnsDomain: _dnsDomainController.text.trim().isEmpty ? null : _dnsDomainController.text.trim(),
      dnsDomainSearch: _dnsDomainSearch,
      dnsServers: _dnsServers,
      ntpServers: _ntpServers,
      tunMtu: _tunMtuController.text.trim().isEmpty ? null : _tunMtuController.text.trim(),
      fragment: _fragmentController.text.trim().isEmpty ? null : _fragmentController.text.trim(),
      mssfix: _mssfixController.text.trim().isEmpty ? null : _mssfixController.text.trim(),
      carpDependOn: _selectedCarpDependOn,
      variousFlags: {},
      variousPushFlags: {},
      pushInactive: _pushInactiveController.text.trim().isEmpty ? null : _pushInactiveController.text.trim(),
      compressMigrate: _selectedCompressMigrate,
      ifconfigPoolPersist: _role == 'server' ? _ifconfigPoolPersist : false,
      httpProxy: _role == 'client' ? _httpProxyController.text.trim() : null,
      verifyX509Name: _verifyX509NameController.text.trim().isEmpty ? null : _verifyX509NameController.text.trim(),
      verb: null,
    );
  }


  Future<void> _generateAuthToken() async {
    setState(() => _isLoading = true);
    
    try {
      final apiService = context.read<OPNsenseApiService>();
      final token = await apiService.generateOpenvpnAuthToken();
      
      if (!mounted) return;
      
      setState(() {
        _authTokenSecretController.text = token;
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Auth token generated successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to generate token: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Instance' : 'Add Instance'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isSaving ? null : _saveInstance,
            tooltip: 'Save',
          ),
        ],
      ),
      body: LoadingOverlay(
        isLoading: _isSaving,
        message: 'Saving instance...',
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 48, color: Colors.red),
                        const SizedBox(height: 16),
                        Text('Error loading instance'),
                        const SizedBox(height: 8),
                        Text(_errorMessage!),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadInstance,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : Form(
                    key: _formKey,
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        // Role Selector
                        OpenvpnRoleSelector(
                          value: _role,
                          onChanged: (value) {
                            setState(() => _role = value);
                          },
                          enabled: !_isEditMode, // Can't change role in edit mode
                        ),
                        const SizedBox(height: 16),

                        // General Settings
                        _buildGeneralSettings(),
                        
                        // Trust Section
                        _buildTrustSection(),
                        
                        // Authentication Section
                        _buildAuthenticationSection(),
                        
                        // Routing Section
                        _buildRoutingSection(),
                        
                        // Miscellaneous Section
                        _buildMiscellaneousSection(),
                        
                        // Advanced Section
                        if (_showAdvanced) _buildAdvancedSection(),
                        
                        // Advanced Toggle
                        Card(
                          child: SwitchListTile(
                            title: const Text('Show Advanced Settings'),
                            value: _showAdvanced,
                            onChanged: (value) => setState(() => _showAdvanced = value),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Save Button
                        ElevatedButton(
                          onPressed: _isSaving ? null : _saveInstance,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text(
                            _isEditMode ? 'Update Instance' : 'Create Instance',
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
    return FormSectionContainer(
      title: 'General Settings',
      icon: Icons.settings,
      children: [
        OpenvpnTextField(
          controller: _descriptionController,
          labelText: 'Description',
          hintText: 'My OpenVPN Instance',
          prefixIcon: Icons.description,
          validator: (value) => CommonValidators.required(value, fieldName: 'Description'),
        ),
        const SizedBox(height: 16),
        
        OpenvpnToggleField(
          title: 'Enabled',
          subtitle: 'Instance will be active when enabled',
          value: _enabled,
          onChanged: (value) => setState(() => _enabled = value),
        ),
        const SizedBox(height: 16),
        
        if (_protoOptions.isNotEmpty)
          OpenvpnDropdownField(
            labelText: 'Protocol',
            prefixIcon: Icons.network_check,
            options: _protoOptions,
            value: _selectedProto,
            onChanged: (value) => setState(() => _selectedProto = value),
          ),
        const SizedBox(height: 16),
        
        OpenvpnTextField(
          controller: _portController,
          labelText: 'Port',
          hintText: '1194',
          prefixIcon: Icons.settings_ethernet,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: CommonValidators.port,
        ),
        const SizedBox(height: 16),
        
        OpenvpnTextField(
          controller: _localController,
          labelText: 'Bind Address (Optional)',
          hintText: 'Leave empty for all interfaces',
          prefixIcon: Icons.location_on,
        ),
        const SizedBox(height: 16),
        
        if (_devTypeOptions.isNotEmpty)
          OpenvpnDropdownField(
            labelText: 'Device Type',
            prefixIcon: Icons.device_hub,
            options: _devTypeOptions,
            value: _selectedDevType,
            onChanged: (value) => setState(() => _selectedDevType = value),
          ),
        const SizedBox(height: 16),
        
        // Client-specific: Remote addresses
        if (_role == 'client') ...[
          OpenvpnArrayField(
            title: 'Remote Addresses',
            items: _remoteAddresses,
            onAdd: () => setState(() => _remoteAddresses.add('')),
            onRemove: (index) => setState(() => _remoteAddresses.removeAt(index)),
            onUpdate: (index, value) => setState(() => _remoteAddresses[index] = value),
            helperText: 'Remote server addresses (host:port or host)',
            emptyMessage: 'No remote addresses configured',
          ),
          const SizedBox(height: 16),
        ],
        
        // Server-specific fields
        if (_role == 'server') ...[
          OpenvpnTextField(
            controller: _serverController,
            labelText: 'Server (IPv4)',
            hintText: '10.8.0.0/24',
            prefixIcon: Icons.dns,
            helperText: 'IPv4 tunnel network in CIDR notation',
          ),
          const SizedBox(height: 16),
          
          OpenvpnTextField(
            controller: _serverIpv6Controller,
            labelText: 'Server (IPv6)',
            hintText: 'fd00::/64',
            prefixIcon: Icons.dns,
            helperText: 'IPv6 tunnel network in CIDR notation',
          ),
          const SizedBox(height: 16),
          
          OpenvpnToggleField(
            title: 'No Pool',
            subtitle: 'Do not allocate addresses from pool',
            value: _nopool,
            onChanged: (value) => setState(() => _nopool = value),
          ),
          const SizedBox(height: 16),
          
          if (_topologyOptions.isNotEmpty)
            OpenvpnDropdownField(
              labelText: 'Topology',
              prefixIcon: Icons.account_tree,
              options: _topologyOptions,
              value: _selectedTopology,
              onChanged: (value) => setState(() => _selectedTopology = value),
            ),
        ],
        
        // CARP Depend On
        if (_carpDependOnOptions.isNotEmpty) ...[
          const SizedBox(height: 16),
          OpenvpnDropdownField(
            labelText: 'Depend on (CARP)',
            helperText: 'CARP VHID to depend on',
            prefixIcon: Icons.link,
            options: _carpDependOnOptions,
            value: _selectedCarpDependOn,
            onChanged: (value) => setState(() => _selectedCarpDependOn = value),
          ),
        ],
      ],
    );
  }

  Widget _buildTrustSection() {
    return FormSectionContainer(
      title: 'Trust',
      icon: Icons.security,
      children: [
        if (_certOptions.isNotEmpty)
          OpenvpnDropdownField(
            labelText: 'Certificate',
            prefixIcon: Icons.verified_user,
            options: _certOptions,
            value: _selectedCert,
            onChanged: (value) => setState(() => _selectedCert = value),
          ),
        const SizedBox(height: 16),
        
        if (_remoteCertTlsOptions.isNotEmpty)
          OpenvpnDropdownField(
            labelText: 'Verify Remote Certificate',
            prefixIcon: Icons.verified,
            options: _remoteCertTlsOptions,
            value: _selectedRemoteCertTls,
            onChanged: (value) => setState(() => _selectedRemoteCertTls = value),
          ),
        
        // Server-specific trust fields
        if (_role == 'server') ...[
          const SizedBox(height: 16),
          
          if (_crlOptions.isNotEmpty)
            OpenvpnDropdownField(
              labelText: 'Certificate Revocation List (CRL)',
              prefixIcon: Icons.block,
              options: _crlOptions,
              value: _selectedCrl,
              onChanged: (value) => setState(() => _selectedCrl = value),
            ),
          const SizedBox(height: 16),
          
          if (_verifyClientCertOptions.isNotEmpty)
            OpenvpnDropdownField(
              labelText: 'Verify Client Certificate',
              prefixIcon: Icons.verified_user,
              options: _verifyClientCertOptions,
              value: _selectedVerifyClientCert,
              onChanged: (value) => setState(() => _selectedVerifyClientCert = value),
            ),
          const SizedBox(height: 16),
          
          OpenvpnToggleField(
            title: 'Use OCSP',
            subtitle: 'Use Online Certificate Status Protocol',
            value: _useOcsp,
            onChanged: (value) => setState(() => _useOcsp = value),
          ),
          const SizedBox(height: 16),
          
          OpenvpnTextField(
            controller: _certDepthController,
            labelText: 'Certificate Depth',
            hintText: '1',
            prefixIcon: Icons.layers,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
        ],
        
        const SizedBox(height: 16),
        
        // TLS Static Key (both client and server)
        if (_tlsKeyOptions.isNotEmpty)
          OpenvpnDropdownField(
            labelText: 'TLS Static Key',
            prefixIcon: Icons.vpn_key,
            options: _tlsKeyOptions,
            value: _selectedTlsKey,
            onChanged: (value) => setState(() => _selectedTlsKey = value),
          ),
      ],
    );
  }

  Widget _buildAuthenticationSection() {
    return FormSectionContainer(
      title: 'Authentication',
      icon: Icons.lock,
      children: [
        // Server-specific authentication
        if (_role == 'server') ...[
          if (_authmodeOptions.isNotEmpty)
            OpenvpnDropdownField(
              labelText: 'Authentication',
              prefixIcon: Icons.how_to_reg,
              options: _authmodeOptions,
              value: _selectedAuthmode,
              onChanged: (value) => setState(() => _selectedAuthmode = value),
            ),
          const SizedBox(height: 16),
          
          if (_localGroupOptions.isNotEmpty)
            OpenvpnDropdownField(
              labelText: 'Enforce Local Group',
              prefixIcon: Icons.group,
              options: _localGroupOptions,
              value: _selectedLocalGroup,
              onChanged: (value) => setState(() => _selectedLocalGroup = value),
            ),
          const SizedBox(height: 16),
          
          OpenvpnToggleField(
            title: 'Strict User/CN Matching',
            subtitle: 'Enforce username matches certificate CN',
            value: _strictusercn,
            onChanged: (value) => setState(() => _strictusercn = value),
          ),
          const SizedBox(height: 16),
        ],
        
        // Client-specific authentication
        if (_role == 'client') ...[
          OpenvpnTextField(
            controller: _usernameController,
            labelText: 'Username',
            prefixIcon: Icons.person,
          ),
          const SizedBox(height: 16),
          
          OpenvpnPasswordField(
            controller: _passwordController,
            labelText: 'Password',
          ),
          const SizedBox(height: 16),
        ],
        
        // Common authentication fields
        OpenvpnTextField(
          controller: _renegSecController,
          labelText: 'Renegotiate Time (seconds)',
          hintText: '3600',
          prefixIcon: Icons.timer,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        
        // Server auth token (shown in advanced for server)
        if (_role == 'server' && _showAdvanced) ...[
          const SizedBox(height: 16),
          
          OpenvpnToggleField(
            title: 'Auth Token',
            subtitle: 'Enable authentication token',
            value: _authGenToken,
            onChanged: (value) => setState(() => _authGenToken = value),
          ),
          
          if (_authGenToken) ...[
            const SizedBox(height: 16),
            
            OpenvpnTextField(
              controller: _authTokenRenewalController,
              labelText: 'Auth Token Renewal (seconds)',
              hintText: '3600',
              prefixIcon: Icons.refresh,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: OpenvpnTextField(
                    controller: _authTokenSecretController,
                    labelText: 'Auth Token Secret',
                    prefixIcon: Icons.key,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.auto_awesome),
                  onPressed: _generateAuthToken,
                  tooltip: 'Generate Token',
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            OpenvpnToggleField(
              title: 'Require Client Provisioning',
              subtitle: 'Client must be provisioned',
              value: _provisionExclusive,
              onChanged: (value) => setState(() => _provisionExclusive = value),
            ),
          ],
        ],
      ],
    );
  }

  Widget _buildRoutingSection() {
    return FormSectionContainer(
      title: 'Routing',
      icon: Icons.route,
      children: [
        OpenvpnArrayField(
          title: 'Local Networks',
          items: _localNetworks,
          onAdd: () => setState(() => _localNetworks.add('')),
          onRemove: (index) => setState(() => _localNetworks.removeAt(index)),
          onUpdate: (index, value) => setState(() => _localNetworks[index] = value),
          helperText: 'Networks accessible from this instance (CIDR)',
          emptyMessage: 'No local networks configured',
        ),
        const SizedBox(height: 16),
        
        OpenvpnArrayField(
          title: 'Remote Networks',
          items: _remoteNetworks,
          onAdd: () => setState(() => _remoteNetworks.add('')),
          onRemove: (index) => setState(() => _remoteNetworks.removeAt(index)),
          onUpdate: (index, value) => setState(() => _remoteNetworks[index] = value),
          helperText: 'Networks to push to clients (CIDR)',
          emptyMessage: 'No remote networks configured',
        ),
      ],
    );
  }

  Widget _buildMiscellaneousSection() {
    return FormSectionContainer(
      title: 'Miscellaneous',
      icon: Icons.more_horiz,
      children: [
        // Client-specific: HTTP Proxy (NOT in advanced)
        if (_role == 'client') ...[
          OpenvpnTextField(
            controller: _httpProxyController,
            labelText: 'HTTP Proxy',
            hintText: 'proxy.example.com:8080',
            prefixIcon: Icons.http,
            helperText: 'HTTP proxy server (host:port)',
          ),
          const SizedBox(height: 16),
        ],
        
        // Server-specific miscellaneous
        if (_role == 'server') ...[
          OpenvpnToggleField(
            title: 'Redirect Gateway',
            subtitle: 'Redirect client default gateway',
            value: _redirectGateway,
            onChanged: (value) => setState(() => _redirectGateway = value),
          ),
          const SizedBox(height: 16),
          
          OpenvpnToggleField(
            title: 'Register DNS',
            subtitle: 'Register connected clients in DNS',
            value: _registerDns,
            onChanged: (value) => setState(() => _registerDns = value),
          ),
          const SizedBox(height: 16),
          
          OpenvpnTextField(
            controller: _dnsDomainController,
            labelText: 'DNS Domain',
            hintText: 'example.com',
            prefixIcon: Icons.dns,
          ),
          const SizedBox(height: 16),
          
          OpenvpnArrayField(
            title: 'DNS Domain Search List',
            items: _dnsDomainSearch,
            onAdd: () => setState(() => _dnsDomainSearch.add('')),
            onRemove: (index) => setState(() => _dnsDomainSearch.removeAt(index)),
            onUpdate: (index, value) => setState(() => _dnsDomainSearch[index] = value),
            helperText: 'DNS search domains',
            emptyMessage: 'No DNS search domains configured',
          ),
          const SizedBox(height: 16),
          
          OpenvpnArrayField(
            title: 'DNS Servers',
            items: _dnsServers,
            onAdd: () => setState(() => _dnsServers.add('')),
            onRemove: (index) => setState(() => _dnsServers.removeAt(index)),
            onUpdate: (index, value) => setState(() => _dnsServers[index] = value),
            helperText: 'DNS server IP addresses',
            emptyMessage: 'No DNS servers configured',
          ),
          const SizedBox(height: 16),
          
          OpenvpnArrayField(
            title: 'NTP Servers',
            items: _ntpServers,
            onAdd: () => setState(() => _ntpServers.add('')),
            onRemove: (index) => setState(() => _ntpServers.removeAt(index)),
            onUpdate: (index, value) => setState(() => _ntpServers[index] = value),
            helperText: 'NTP server IP addresses',
            emptyMessage: 'No NTP servers configured',
          ),
        ],
      ],
    );
  }

  Widget _buildAdvancedSection() {
    return FormSectionContainer(
      title: 'Advanced Settings',
      icon: Icons.tune,
      children: [
        // Server-specific advanced (already shown in auth section)
        if (_role == 'server') ...[
          if (_compressMigrateOptions.isNotEmpty)
            OpenvpnDropdownField(
              labelText: 'Compression Migrate',
              prefixIcon: Icons.compress,
              options: _compressMigrateOptions,
              value: _selectedCompressMigrate,
              onChanged: (value) => setState(() => _selectedCompressMigrate = value),
            ),
          const SizedBox(height: 16),
          
          OpenvpnToggleField(
            title: 'Persist Address Pool',
            subtitle: 'Persist client IP address assignments',
            value: _ifconfigPoolPersist,
            onChanged: (value) => setState(() => _ifconfigPoolPersist = value),
          ),
          const SizedBox(height: 16),
          
          OpenvpnTextField(
            controller: _pushInactiveController,
            labelText: 'Push Inactivity Timeout (seconds)',
            hintText: '600',
            prefixIcon: Icons.timer_off,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          const SizedBox(height: 16),
          
          OpenvpnTextField(
            controller: _routeMetricController,
            labelText: 'Route Metric',
            hintText: '100',
            prefixIcon: Icons.speed,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          const SizedBox(height: 16),
        ],
        
        // Common advanced fields
        OpenvpnTextField(
          controller: _verifyX509NameController,
          labelText: 'Verify X.509 Name',
          hintText: 'server.example.com',
          prefixIcon: Icons.verified,
        ),
        const SizedBox(height: 16),
        
        OpenvpnTextField(
          controller: _tunMtuController,
          labelText: 'TUN Device MTU',
          hintText: '1500',
          prefixIcon: Icons.settings_ethernet,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        const SizedBox(height: 16),
        
        OpenvpnTextField(
          controller: _fragmentController,
          labelText: 'Fragment Size',
          hintText: '1300',
          prefixIcon: Icons.splitscreen,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        const SizedBox(height: 16),
        
        OpenvpnTextField(
          controller: _mssfixController,
          labelText: 'MSS Fix',
          hintText: '1450',
          prefixIcon: Icons.build,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
      ],
    );
  }
}


