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
import '../models/openvpn_instance.dart';
import '../utils/constants.dart';
import '../models/openvpn_dropdown_option.dart';
import '../utils/snackbar_helper.dart';
import '../viewmodels/openvpn_instance_form_view_model.dart';
import '../widgets/common/loading_overlay.dart';
import '../widgets/openvpn/openvpn_form_field_widgets.dart';
import '../utils/validators.dart';

/// Form screen for adding/editing OpenVPN instances
class OpenvpnInstanceFormScreen extends StatefulWidget {
  final String? vpnid;

  const OpenvpnInstanceFormScreen({super.key, this.vpnid});

  @override
  State<OpenvpnInstanceFormScreen> createState() => _OpenvpnInstanceFormScreenState();
}

class _OpenvpnInstanceFormScreenState extends State<OpenvpnInstanceFormScreen> {
  late OpenvpnInstanceFormViewModel _viewModel;
  final _formKey = GlobalKey<FormState>();

  bool _showAdvanced = false;
  
  // Store the loaded instance's vpnid (the numeric ID from API, not the UUID)
  String? _loadedVpnid;
  
  // Form data
  String _role = 'server';
  
  // Controllers
  final _descriptionController = TextEditingController();
  final _portController = TextEditingController();
  final _localController = TextEditingController();
  final _portShareController = TextEditingController();
  final _serverController = TextEditingController();
  final _serverIpv6Controller = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _renegSecController = TextEditingController();
  final _authGenTokenController = TextEditingController(); // Changed from bool to TextEditingController
  final _authTokenRenewalController = TextEditingController();
  final _authTokenSecretController = TextEditingController();
  final _httpProxyController = TextEditingController();
  final _verifyX509NameController = TextEditingController();
  final _tunMtuController = TextEditingController();
  final _fragmentController = TextEditingController();
  final _pushInactiveController = TextEditingController();
  final _routeMetricController = TextEditingController();
  final _certDepthController = TextEditingController();
  final _maxclientsController = TextEditingController();
  final _keepaliveIntervalController = TextEditingController();
  final _keepaliveTimeoutController = TextEditingController();
  // DNS Domain is now an array field, no longer needs a controller
  List<String> _dnsDomain = [];
  List<String> _pushExcludedRoutes = [];
  
  // State variables
  bool _enabled = true;
  bool _nopool = false;
  bool _useOcsp = false;
  bool _usernameAsCommonName = false;
  bool _mssFix = false;
  String _selectedStrictUserCn = '0';
  // Removed: bool _authGenToken = false; - now using _authGenTokenController
  bool _provisionExclusive = false;
  bool _registerDns = false;
  bool _ifconfigPoolPersist = false;

  final Map<String, bool> _sectionExpanded = {
    'general': true,
    'trust': true,
    'authentication': true,
    'routing': true,
    'miscellaneous': true,
  };

  // Track if all sections are expanded for collapse/expand all button
  bool get _allExpanded =>
      _sectionExpanded.values.every((expanded) => expanded);

  // Dropdown selections
  String? _selectedDevType;
  String? _selectedProto;
  String? _selectedTopology;
  String? _selectedCert;
  String? _selectedCa;
  String? _selectedCrl;
  String? _selectedRemoteCertTls;
  String? _selectedVerifyClientCert;
  String? _selectedAuth;
  String? _selectedAuthmode;
  String? _selectedLocalGroup;
  String? _selectedCarpDependOn;
  bool _compressMigrate = false;
  String? _selectedTlsKey;
  String? _selectedCertDepth;
  String? _selectedVerb;

  // Multi-select
  final List<String> _selectedDataCiphers = [];
  String? _selectedDataCiphersFallback;
  final List<String> _selectedVariousFlags = [];
  final List<String> _selectedVariousPushFlags = [];
  final List<String> _selectedRedirectGateway = [];

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
  final Map<String, OpenvpnDropdownOption> _caOptions = {};
  final Map<String, OpenvpnDropdownOption> _crlOptions = {};
  final Map<String, OpenvpnDropdownOption> _remoteCertTlsOptions = {};
  final Map<String, OpenvpnDropdownOption> _verifyClientCertOptions = {};
  final Map<String, OpenvpnDropdownOption> _authOptions = {};
  final Map<String, OpenvpnDropdownOption> _authmodeOptions = {};
  final Map<String, OpenvpnDropdownOption> _localGroupOptions = {};
  final Map<String, OpenvpnDropdownOption> _carpDependOnOptions = {};
  final Map<String, OpenvpnDropdownOption> _tlsKeyOptions = {};
  final Map<String, OpenvpnDropdownOption> _certDepthOptions = {};
  final Map<String, OpenvpnDropdownOption> _strictUserCnOptions = {};
  final Map<String, OpenvpnDropdownOption> _dataCiphersOptions = {};
  final Map<String, OpenvpnDropdownOption> _dataCiphersFallbackOptions = {};
  final Map<String, OpenvpnDropdownOption> _variousFlagsOptions = {};
  final Map<String, OpenvpnDropdownOption> _variousPushFlagsOptions = {};
  final Map<String, OpenvpnDropdownOption> _redirectGatewayOptions = {};
  final Map<String, OpenvpnDropdownOption> _verbOptions = {};

  @override
  void initState() {
    super.initState();
    _viewModel = OpenvpnInstanceFormViewModel(
      apiService: context.read(),
      vpnid: widget.vpnid,
    );
    _viewModel.addListener(_onViewModelChanged);
    // Load instance after the first frame to ensure context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadInstance();
      }
    });
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    _descriptionController.dispose();
    _portController.dispose();
    _localController.dispose();
    _portShareController.dispose();
    _serverController.dispose();
    _serverIpv6Controller.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _renegSecController.dispose();
    _authGenTokenController.dispose();
    _authTokenRenewalController.dispose();
    _authTokenSecretController.dispose();
    _httpProxyController.dispose();
    _verifyX509NameController.dispose();
    _tunMtuController.dispose();
    _fragmentController.dispose();
    _pushInactiveController.dispose();
    _routeMetricController.dispose();
    _certDepthController.dispose();
    _maxclientsController.dispose();
    _keepaliveIntervalController.dispose();
    _keepaliveTimeoutController.dispose();
    super.dispose();
  }

  void _onViewModelChanged() {
    if (mounted) setState(() {});
  }

  bool get _isEditMode => widget.vpnid != null;

  Future<void> _loadInstance() async {
    await _viewModel.loadInstance();

    if (mounted && _viewModel.loadedInstance != null) {
      setState(() {
        _loadInstanceData(_viewModel.loadedInstance!);
      });
    }
  }

  void _loadInstanceData(OpenvpnInstance instance) {
    _loadedVpnid = instance.vpnid;

    if (instance.devTypeOptions != null) {
      _devTypeOptions.clear();
      _devTypeOptions.addAll(instance.devTypeOptions!);
    }

    if (instance.protoOptions != null) {
      _protoOptions.clear();
      _protoOptions.addAll(instance.protoOptions!);
    }

    if (instance.topologyOptions != null) {
      _topologyOptions.clear();
      _topologyOptions.addAll(instance.topologyOptions!);
    }

    if (instance.certOptions != null) {
      _certOptions.clear();
      _certOptions.addAll(instance.certOptions!);
    }

    if (instance.caOptions != null) {
      _caOptions.clear();
      _caOptions.addAll(instance.caOptions!);
    }

    if (instance.crlOptions != null) {
      _crlOptions.clear();
      _crlOptions.addAll(instance.crlOptions!);
    }

    if (instance.tlsKeyOptions != null) {
      _tlsKeyOptions.clear();
      _tlsKeyOptions.addAll(instance.tlsKeyOptions!);
    }

    if (instance.authOptions != null) {
      _authOptions.clear();
      _authOptions.addAll(instance.authOptions!);
    }

    if (instance.authmodeOptions != null) {
      _authmodeOptions.clear();
      _authmodeOptions.addAll(instance.authmodeOptions!);
    }

    if (instance.localGroupOptions != null) {
      _localGroupOptions.clear();
      _localGroupOptions.addAll(instance.localGroupOptions!);
    }

    if (instance.carpDependOnOptions != null) {
      _carpDependOnOptions.clear();
      _carpDependOnOptions.addAll(instance.carpDependOnOptions!);
    }

    if (instance.certDepthOptions != null) {
      _certDepthOptions.clear();
      _certDepthOptions.addAll(instance.certDepthOptions!);
    }

    if (instance.strictusercnOptions != null) {
      _strictUserCnOptions.clear();
      _strictUserCnOptions.addAll(instance.strictusercnOptions!);
    }

    if (instance.dataCiphersOptions != null && instance.dataCiphersOptions!.isNotEmpty) {
      _dataCiphersOptions
        ..clear()
        ..addAll(instance.dataCiphersOptions!);
    }

    if (instance.dataCiphersFallbackOptions != null && instance.dataCiphersFallbackOptions!.isNotEmpty) {
      _dataCiphersFallbackOptions
        ..clear()
        ..addAll(instance.dataCiphersFallbackOptions!);
    }

    if (instance.variousFlagsOptions != null) {
      _variousFlagsOptions.clear();
      _variousFlagsOptions.addAll(instance.variousFlagsOptions!);
    }

    if (instance.variousPushFlagsOptions != null) {
      _variousPushFlagsOptions.clear();
      _variousPushFlagsOptions.addAll(instance.variousPushFlagsOptions!);
    }

    if (instance.redirectGatewayOptions != null) {
      _redirectGatewayOptions.clear();
      _redirectGatewayOptions.addAll(instance.redirectGatewayOptions!);
    }

    if (instance.remoteCertTlsOptions != null) {
      _remoteCertTlsOptions.clear();
      _remoteCertTlsOptions.addAll(instance.remoteCertTlsOptions!);
    }

    if (instance.verifyClientCertOptions != null) {
      _verifyClientCertOptions.clear();
      _verifyClientCertOptions.addAll(instance.verifyClientCertOptions!);
    }

    if (instance.verbOptions != null) {
      _verbOptions.clear();
      _verbOptions.addAll(instance.verbOptions!);
    }
    
    _role = instance.role;
    _descriptionController.text = instance.description;
    _enabled = instance.enabled;
    _portController.text = instance.port;
    _localController.text = instance.local ?? '';
    _portShareController.text = instance.portShare ?? '';

    _selectedDevType = instance.devType;
    _selectedProto = instance.proto;
    _selectedTopology = instance.topology;
    _selectedCert = instance.cert;
    _selectedCa = instance.ca;
    _selectedCrl = instance.crl;
    _selectedRemoteCertTls = instance.remoteCertTls;
    _selectedVerifyClientCert = instance.verifyClientCert;
    _selectedAuth = instance.auth;
    _selectedAuthmode = instance.authmode;
    _selectedLocalGroup = instance.localGroup;
    _selectedCarpDependOn = instance.carpDependOn;
    _compressMigrate = instance.compressMigrate == '1';
    _selectedTlsKey = instance.tlsKey;
    _selectedCertDepth = instance.certDepth;
    _selectedVerb = instance.verb;

    _selectedDataCiphers
      ..clear()
      ..addAll(_splitCommaSeparated(instance.dataCiphers));

    _selectedDataCiphersFallback = instance.dataCiphersFallback;

    _selectedVariousFlags
      ..clear()
      ..addAll(
        instance.variousFlags.entries
            .where((entry) => entry.value)
            .map((entry) => entry.key),
      );

    _selectedVariousPushFlags
      ..clear()
      ..addAll(
        instance.variousPushFlags.entries
            .where((entry) => entry.value)
            .map((entry) => entry.key),
      );

    _selectedRedirectGateway
      ..clear()
      ..addAll(
        instance.redirectGateway.isNotEmpty
            ? instance.redirectGateway.split(',').where((s) => s.trim().isNotEmpty).toList()
            : [],
      );

    
    if (instance.isClient) {
      if (instance.remote != null && instance.remote!.isNotEmpty) {
        _remoteAddresses = instance.remote!
            .split(RegExp(r'[\n,]'))
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
      } else {
        _remoteAddresses = [];
      }

      _usernameController.text = instance.username ?? '';
      _passwordController.text = instance.password ?? '';
      _httpProxyController.text = instance.httpProxy ?? '';
    } else {
      _serverController.text = instance.server ?? '';
      _serverIpv6Controller.text = instance.serverIpv6 ?? '';
      _nopool = instance.nopool;
      _useOcsp = instance.useOcsp;
      _usernameAsCommonName = instance.usernameAsCommonName;
      _selectedStrictUserCn = instance.strictusercn;
      _authGenTokenController.text = instance.authGenToken ?? '';
      _provisionExclusive = instance.provisionExclusive;
      _registerDns = instance.registerDns;
      _ifconfigPoolPersist = instance.ifconfigPoolPersist;
      _certDepthController.text = instance.certDepth ?? '';
      _dnsDomain = List.from(instance.dnsDomain);
      _dnsDomainSearch = List.from(instance.dnsDomainSearch);
      _dnsServers = List.from(instance.dnsServers);
      _ntpServers = List.from(instance.ntpServers);
    }
    
    _renegSecController.text = instance.renegSec ?? '';
    _localNetworks = List.from(instance.route);
    _remoteNetworks = List.from(instance.pushRoute);
    _pushExcludedRoutes = List.from(instance.pushExcludedRoutes);

    _maxclientsController.text = instance.maxclients ?? '';
    _keepaliveIntervalController.text = instance.keepaliveInterval ?? '';
    _keepaliveTimeoutController.text = instance.keepaliveTimeout ?? '';
    _verifyX509NameController.text = instance.verifyX509Name ?? '';
    _tunMtuController.text = instance.tunMtu ?? '';
    _fragmentController.text = instance.fragment ?? '';
    _mssFix = instance.mssfix == '1';

    if (instance.isServer) {
      _authTokenRenewalController.text = instance.authGenTokenRenewal ?? '';
      _authTokenSecretController.text = instance.authGenTokenSecret ?? '';
      _pushInactiveController.text = instance.pushInactive ?? '';
      _routeMetricController.text = instance.routeMetric ?? '';
    }
  }

  Future<void> _saveInstance() async {
    final l10n = AppLocalizations.of(context)!;

    if (!_formKey.currentState!.validate()) {
      SnackBarHelper.showError(context, l10n.fixFormErrors);
      return;
    }

    final instance = _buildInstanceFromForm();
    final success = await _viewModel.saveInstance(instance);

    if (mounted) {
      if (success) {
        SnackBarHelper.showSuccess(context, _isEditMode
            ? l10n.instanceUpdatedSuccessfully
            : l10n.instanceCreatedSuccessfully);
        Navigator.of(context).pop(true);
      } else {
        SnackBarHelper.showError(context, _viewModel.errorMessage ?? l10n.failedToSaveInstance(''), duration: const Duration(seconds: 4));
      }
    }
  }

  OpenvpnInstance _buildInstanceFromForm() {
    return OpenvpnInstance(
      vpnid: _loadedVpnid ?? '',
      enabled: _enabled,
      role: _role,
      description: _descriptionController.text.trim(),
      devType: _selectedDevType ?? 'tun',
      proto: _selectedProto ?? 'udp',
      port: _portController.text.trim(),
      local: _localController.text.trim().isEmpty ? null : _localController.text.trim(),
      portShare: _portShareController.text.trim().isEmpty ? null : _portShareController.text.trim(),
      topology: _selectedTopology ?? 'subnet',
      remote: _role == 'client' ? _remoteAddresses.join(',') : null,
      server: _role == 'server' ? _serverController.text.trim() : null,
      serverIpv6: _role == 'server' ? _serverIpv6Controller.text.trim() : null,
      nopool: _role == 'server' ? _nopool : false,
      bridgeGateway: null,
      bridgePool: null,
      route: _localNetworks,
      pushRoute: _remoteNetworks,
      pushExcludedRoutes: _pushExcludedRoutes,
      cert: _selectedCert,
      crl: _selectedCrl,
      ca: _selectedCa,
      certDepth: _selectedCertDepth ?? (_certDepthController.text.trim().isEmpty ? null : _certDepthController.text.trim()),
      remoteCertTls: _selectedRemoteCertTls,
      verifyClientCert: _selectedVerifyClientCert,
      useOcsp: _role == 'server' ? _useOcsp : false,
      tlsKey: _selectedTlsKey,
      auth: _selectedAuth,
      dataCiphers: _selectedDataCiphers.isNotEmpty ? _selectedDataCiphers.join(',') : null,
      dataCiphersFallback: _selectedDataCiphersFallback,
      authmode: _selectedAuthmode,
      localGroup: _selectedLocalGroup,
      usernameAsCommonName: _usernameAsCommonName,
      strictusercn: _role == 'server' ? _selectedStrictUserCn : '0',
      username: _role == 'client' ? _usernameController.text.trim() : null,
      password: _role == 'client' ? _passwordController.text.trim() : null,
      maxclients: _maxclientsController.text.trim().isEmpty ? null : _maxclientsController.text.trim(),
      keepaliveInterval: _keepaliveIntervalController.text.trim().isEmpty ? null : _keepaliveIntervalController.text.trim(),
      keepaliveTimeout: _keepaliveTimeoutController.text.trim().isEmpty ? null : _keepaliveTimeoutController.text.trim(),
      renegSec: _renegSecController.text.trim().isEmpty ? null : _renegSecController.text.trim(),
      authGenToken: _role == 'server' && _authGenTokenController.text.trim().isNotEmpty ? _authGenTokenController.text.trim() : null,
      authGenTokenRenewal: _authTokenRenewalController.text.trim().isEmpty ? null : _authTokenRenewalController.text.trim(),
      authGenTokenSecret: _authTokenSecretController.text.trim().isEmpty ? null : _authTokenSecretController.text.trim(),
      provisionExclusive: _role == 'server' ? _provisionExclusive : false,
      // Fix 4: Convert redirect_gateway List to comma-separated string
      redirectGateway: _role == 'server'
          ? (_selectedRedirectGateway.isEmpty ? '' : _selectedRedirectGateway.join(','))
          : '',
      routeMetric: _routeMetricController.text.trim().isEmpty ? null : _routeMetricController.text.trim(),
      registerDns: _role == 'server' ? _registerDns : false,
      dnsDomain: _dnsDomain,
      dnsDomainSearch: _dnsDomainSearch,
      dnsServers: _dnsServers,
      ntpServers: _ntpServers,
      tunMtu: _tunMtuController.text.trim().isEmpty ? null : _tunMtuController.text.trim(),
      fragment: _fragmentController.text.trim().isEmpty ? null : _fragmentController.text.trim(),
      mssfix: _mssFix ? '1' : '0',
      carpDependOn: _selectedCarpDependOn,
      // Fix 2: Convert various_flags List to Map with string keys for proper serialization
      variousFlags: _selectedVariousFlags.fold<Map<String, bool>>(
        {},
        (map, key) {
          map[key] = true;
          return map;
        },
      ),
      // Fix 3: Convert various_push_flags List to Map with string keys for proper serialization
      variousPushFlags: _selectedVariousPushFlags.fold<Map<String, bool>>(
        {},
        (map, key) {
          map[key] = true;
          return map;
        },
      ),
      pushInactive: _pushInactiveController.text.trim().isEmpty ? null : _pushInactiveController.text.trim(),
      compressMigrate: _compressMigrate ? '1' : '0',
      ifconfigPoolPersist: _role == 'server' ? _ifconfigPoolPersist : false,
      httpProxy: _role == 'client' ? _httpProxyController.text.trim() : null,
      verifyX509Name: _verifyX509NameController.text.trim().isEmpty ? null : _verifyX509NameController.text.trim(),
      verb: _selectedVerb,
    );
  }


  Future<void> _generateAuthToken() async {
    final l10n = AppLocalizations.of(context)!;

    final token = await _viewModel.generateAuthToken();

    if (!mounted) return;

    if (token != null) {
      setState(() {
        _authTokenSecretController.text = token;
      });
      SnackBarHelper.showSuccess(context, l10n.authTokenGeneratedSuccessfully);
    } else if (_viewModel.errorMessage != null) {
      SnackBarHelper.showError(context, _viewModel.errorMessage!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? l10n.edit : l10n.addInstance),
        actions: [
          IconButton(
            icon: Icon(_allExpanded ? Icons.unfold_less : Icons.unfold_more),
            onPressed: () {
              setState(() {
                final newState = !_allExpanded;
                _sectionExpanded.updateAll((key, value) => newState);
              });
            },
            tooltip: _allExpanded ? l10n.collapseAll : l10n.expandAll,
          ),
          IconButton(
            icon: const Icon(Icons.save),
              onPressed: _viewModel.isLoading ? null : _saveInstance,
            tooltip: l10n.save,
          ),
        ],
      ),
      body: LoadingOverlay(
        isLoading: _viewModel.isLoading,
        message: l10n.savingInstance,
        child: _viewModel.errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 48, color: AppColors.danger),
                        const SizedBox(height: 16),
                        Text(l10n.errorLoadingInstance),
                        const SizedBox(height: 8),
                        Text(_viewModel.errorMessage!),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadInstance,
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
                        _buildTrustSection(),
                        _buildAuthenticationSection(),
                        _buildRoutingSection(),
                        _buildMiscellaneousSection(),
                        Card(
                          child: SwitchListTile(
                            title: const Text('Show Advanced Settings'),
                            value: _showAdvanced,
                            onChanged: (value) => setState(() => _showAdvanced = value),
                          ),
                        ),
                        if (_showAdvanced) _buildAdvancedSection(),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _viewModel.isLoading ? null : _saveInstance,
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

  Widget _buildCollapsibleSection({
    required String keyName,
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    final isExpanded = _sectionExpanded[keyName] ?? true;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        key: ValueKey('${keyName}_$isExpanded'),
        initiallyExpanded: isExpanded,
        onExpansionChanged: (value) {
          setState(() => _sectionExpanded[keyName] = value);
        },
        leading: Icon(icon),
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        children: children,
      ),
    );
  }

  List<String> _splitCommaSeparated(String? value) {
    if (value == null || value.trim().isEmpty) {
      return [];
    }

    return value
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }

  Widget _buildGeneralSettings() {
    final l10n = AppLocalizations.of(context)!;
    return _buildCollapsibleSection(
      keyName: 'general',
      title: l10n.generalSettings,
      icon: Icons.settings,
      children: [
        OpenvpnRoleSelector(
          value: _role,
          onChanged: (value) {
            setState(() => _role = value);
          },
          helperText: l10n.defineRoleOfInstance,
        ),
        const SizedBox(height: 16),
        OpenvpnTextField(
          controller: _descriptionController,
          labelText: l10n.description,
          hintText: l10n.myOpenvpnInstance,
          prefixIcon: Icons.description,
          helperText: l10n.descriptionHelperText,
          validator: (value) => Validators.required(value, fieldName: l10n.description),
        ),
        const SizedBox(height: 16),
        OpenvpnToggleField(
          title: l10n.enabled,
          subtitle: l10n.instanceWillBeActiveWhenEnabled,
          value: _enabled,
          onChanged: (value) => setState(() => _enabled = value),
        ),
        const SizedBox(height: 16),
        OpenvpnDropdownField(
          labelText: l10n.protocol,
          prefixIcon: Icons.network_check,
          options: _protoOptions,
          value: _selectedProto,
          onChanged: (value) => setState(() => _selectedProto = value),
          helperText: l10n.useProtocolForCommunicating,
        ),
        const SizedBox(height: 16),
        OpenvpnTextField(
          controller: _portController,
          labelText: l10n.port,
          hintText: '1194',
          prefixIcon: Icons.settings_ethernet,
          helperText: 'Port number to use. Defaults to 1194 when in server role or when client mode specifies a bind address, or nobind when client does not have a specific bind address.',
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Port is required';
            }
            final port = int.tryParse(value.trim());
            if (port == null || port < 1 || port > 65535) {
              return 'Port must be between 1 and 65535';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        OpenvpnTextField(
          controller: _localController,
          labelText: 'Bind Address',
          hintText: 'Leave empty for all interfaces',
          prefixIcon: Icons.location_on,
          helperText: 'Optional IP address for bind. If specified, OpenVPN will bind to this address only. If unspecified, OpenVPN will bind to all interfaces.',
        ),
        const SizedBox(height: 16),
        if (_devTypeOptions.isNotEmpty)
          OpenvpnDropdownField(
            labelText: 'Type',
            prefixIcon: Icons.device_hub,
            options: _devTypeOptions,
            value: _selectedDevType,
            onChanged: (value) => setState(() => _selectedDevType = value),
            helperText: 'Choose the type of tunnel, OSI Layer 3 [tun] is the most common option to route IPv4 or IPv6 traffic, [tap] offers Ethernet 802.3 (OSI Layer 2) connectivity between hosts and is usually combined with a bridge. DCO is a faster Layer 3 implementation, but has some additional constraints.',
          ),
        if (_role == 'client') ...[
          const SizedBox(height: 16),
          OpenvpnArrayField(
            title: 'Remote',
            items: _remoteAddresses,
            onAdd: () => setState(() => _remoteAddresses.add('')),
            onRemove: (index) => setState(() => _remoteAddresses.removeAt(index)),
            onUpdate: (index, value) => setState(() => _remoteAddresses[index] = value),
            helperText: 'Remote host name or IP address. One remote address per line.',
            emptyMessage: 'No remote addresses configured',
          ),
        ],
        if (_role == 'server') ...[
          const SizedBox(height: 16),
          OpenvpnCidrField(
            controller: _serverController,
            labelText: 'Server (IPv4)',
            hintText: '10.8.0.0/24',
            prefixIcon: Icons.dns,
            helperText: 'This directive will set up an OpenVPN server which will allocate addresses to clients out of the given network/netmask. The server itself will take the .1 address of the given network for use as the server-side endpoint of the local TUN/TAP interface',
            version: CidrVersion.ipv4,
          ),
          const SizedBox(height: 16),
          OpenvpnCidrField(
            controller: _serverIpv6Controller,
            labelText: 'Server (IPv6)',
            hintText: 'fd00::/64',
            prefixIcon: Icons.dns,
            helperText: 'This directive will set up an OpenVPN server which will allocate addresses to clients out of the given network/netmask. The server itself will take the next base address (+1) of the given network for use as the server-side endpoint of the local TUN/TAP interface',
            version: CidrVersion.ipv6,
          ),
          const SizedBox(height: 16),
          OpenvpnToggleField(
            title: 'No Pool',
            subtitle: 'Do not set up a dynamic pool for the server directive. IP addresses will only be pushed to a client if specified in a CSO, or they can be statically set in the client configuration.',
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
              helperText: 'Configure virtual addressing topology when running in --dev tun mode. This directive has no meaning in --dev tap mode, which always uses a subnet topology.',
            ),
        ],
        if (_role == 'client') ...[
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
    return _buildCollapsibleSection(
      keyName: 'trust',
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
            helperText: 'Select a certificate to use for this service.',
          ),
        const SizedBox(height: 16),
        OpenvpnToggleField(
          title: 'Verify Remote Certificate',
          subtitle: 'Require that the peer certificate was signed with an explicit "key usage" and "extended key usage" based on RFC 3280 rules. This is a useful security option for both servers and clients. For clients, to ensure that the host they connect to is a designated server; and for servers, to prevent man-in-the-middle attacks where an authorized client attempts to connect to another client by impersonating the server.',
          value: _selectedRemoteCertTls == '1',
          onChanged: (value) => setState(() => _selectedRemoteCertTls = value ? '1' : '0'),
        ),
        if (_role == 'server') ...[
          const SizedBox(height: 16),
          if (_crlOptions.isNotEmpty)
            OpenvpnDropdownField(
              labelText: 'Certificate Revocation List',
              prefixIcon: Icons.block,
              options: _crlOptions,
              value: _selectedCrl,
              onChanged: (value) => setState(() => _selectedCrl = value),
              helperText: 'Select a certificate revocation list to use for this service.',
            ),
          const SizedBox(height: 16),
          if (_verifyClientCertOptions.isNotEmpty)
            OpenvpnDropdownField(
              labelText: 'Verify Client Certificate',
              prefixIcon: Icons.verified_user,
              options: _verifyClientCertOptions,
              value: _selectedVerifyClientCert,
              onChanged: (value) => setState(() => _selectedVerifyClientCert = value),
              helperText: 'Specify if the client is required to offer a certificate.',
            ),
          const SizedBox(height: 16),
          OpenvpnToggleField(
            title: 'Use OCSP',
            subtitle: 'When the CA used supplies an authorityInfoAccess OCSP URI extension, it will be used to validate the client certificate.',
            value: _useOcsp,
            onChanged: (value) => setState(() => _useOcsp = value),
          ),
          const SizedBox(height: 16),
          if (_certDepthOptions.isNotEmpty)
            OpenvpnDropdownField(
              labelText: 'Certificate Depth',
              prefixIcon: Icons.layers,
              options: _certDepthOptions,
              value: _selectedCertDepth,
              onChanged: (value) => setState(() => _selectedCertDepth = value),
              helperText: 'When a certificate-based client logs in, do not accept certificates below this depth. Useful for denying certificates made with intermediate CAs generated from the same CA as the server.',
            )
          else
            OpenvpnTextField(
              controller: _certDepthController,
              labelText: 'Certificate Depth',
              hintText: '1',
              prefixIcon: Icons.layers,
              helperText: 'When a certificate-based client logs in, do not accept certificates below this depth. Useful for denying certificates made with intermediate CAs generated from the same CA as the server.',
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
        ],
        const SizedBox(height: 16),
        if (_tlsKeyOptions.isNotEmpty)
          OpenvpnDropdownField(
            labelText: 'TLS Static Key',
            prefixIcon: Icons.vpn_key,
            options: _tlsKeyOptions,
            value: _selectedTlsKey,
            onChanged: (value) => setState(() => _selectedTlsKey = value),
            helperText: 'Add an additional layer of HMAC authentication on top of the TLS control channel to mitigate DoS attacks and attacks on the TLS stack. The prefixed mode determines if this measurement is only used for authentication (--tls-auth) or includes encryption (--tls-crypt).',
          ),
      ],
    );
  }

  Widget _buildAuthenticationSection() {
    return _buildCollapsibleSection(
      keyName: 'authentication',
      title: 'Authentication',
      icon: Icons.lock,
      children: [
        if (_authmodeOptions.isNotEmpty && _role == 'server')
          OpenvpnDropdownField(
            labelText: 'Authentication',
            prefixIcon: Icons.how_to_reg,
            options: _authmodeOptions,
            value: _selectedAuthmode,
            onChanged: (value) => setState(() => _selectedAuthmode = value),
            helperText: 'Select authentication methods to use, leave empty if no challenge response authentication is needed.',
          ),
        if (_authmodeOptions.isNotEmpty && _role == 'server') const SizedBox(height: 16),
        if (_role == 'server') ...[
          if (_localGroupOptions.isNotEmpty)
            OpenvpnDropdownField(
              labelText: 'Enforce Local Group',
              prefixIcon: Icons.group,
              options: _localGroupOptions,
              value: _selectedLocalGroup,
              onChanged: (value) => setState(() => _selectedLocalGroup = value),
              helperText: 'Restrict access to users in the selected local group. Please be aware that other authentication backends will refuse to authenticate when using this option.',
            ),
          if (_localGroupOptions.isNotEmpty) const SizedBox(height: 16),
          OpenvpnDropdownField(
            labelText: 'Strict User/CN Matching',
            prefixIcon: Icons.person_search,
            options: _strictUserCnOptions,
            value: _selectedStrictUserCn,
            onChanged: (value) => setState(() => _selectedStrictUserCn = value ?? '0'),
            helperText: 'When authenticating users, enforce a match between the Common Name of the client certificate and the username given at login.',
          ),
          const SizedBox(height: 16),
        ],
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
          OpenvpnTextField(
            controller: _renegSecController,
            labelText: 'Renegotiate Time',
            hintText: '3600',
            prefixIcon: Icons.timer,
            helperText: 'Renegotiate data channel key after n seconds (default=3600). When using a one time password, be advised that your connection will automatically drop because your password is not valid anymore. Set to 0 to disable, remember to change your client as well.',
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
        ],
        if (_role == 'server') ...[
          OpenvpnTextField(
            controller: _renegSecController,
            labelText: 'Renegotiate Time',
            hintText: '3600',
            prefixIcon: Icons.timer,
            helperText: 'Renegotiate data channel key after n seconds (default=3600). When using a one time password, be advised that your connection will automatically drop because your password is not valid anymore. Set to 0 to disable, remember to change your client as well.',
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          const SizedBox(height: 16),
          OpenvpnTextField(
            controller: _authGenTokenController,
            labelText: 'Auth Token Lifetime',
            hintText: '3600',
            prefixIcon: Icons.timelapse,
            helperText: 'After successful user/password authentication, the OpenVPN server will with this option generate a temporary authentication token and push that to the client. On the following renegotiations, the OpenVPN client will pass this token instead of the users password. On the server side the server will do the token authentication internally and it will NOT do any additional authentications against configured external user/password authentication mechanisms. When set to 0, the token will never expire, any other value specifies the lifetime in seconds.',
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
        ],
      ],
    );
  }

  Widget _buildRoutingSection() {
    return _buildCollapsibleSection(
      keyName: 'routing',
      title: 'Routing',
      icon: Icons.route,
      children: [
        OpenvpnArrayField(
          title: 'Local Network',
          items: _localNetworks,
          onAdd: () => setState(() => _localNetworks.add('')),
          onRemove: (index) => setState(() => _localNetworks.removeAt(index)),
          onUpdate: (index, value) => setState(() => _localNetworks[index] = value),
          helperText: 'These are the networks accessible on this host, these are pushed via route{-ipv6} clauses in OpenVPN to the client.',
          emptyMessage: 'No local networks configured',
        ),
        const SizedBox(height: 16),
        OpenvpnArrayField(
          title: 'Remote Network',
          items: _remoteNetworks,
          onAdd: () => setState(() => _remoteNetworks.add('')),
          onRemove: (index) => setState(() => _remoteNetworks.removeAt(index)),
          onUpdate: (index, value) => setState(() => _remoteNetworks[index] = value),
          helperText: 'Remote networks for the server, add route to routing table after connection is established',
          emptyMessage: 'No remote networks configured',
        ),
      ],
    );
  }

  Widget _buildMiscellaneousSection() {
    return _buildCollapsibleSection(
      keyName: 'miscellaneous',
      title: 'Miscellaneous',
      icon: Icons.more_horiz,
      children: [
        if (_variousFlagsOptions.isNotEmpty) ...[
          OpenvpnMultiSelectField(
            labelText: 'Options',
            helperText: 'Various less frequently used yes/no options which can be set for this instance.',
            prefixIcon: Icons.settings,
            options: _variousFlagsOptions,
            selectedValues: _selectedVariousFlags,
            onChanged: (values) => setState(() {
              _selectedVariousFlags
                ..clear()
                ..addAll(values);
            }),
          ),
          const SizedBox(height: 16),
        ],
        if (_role == 'server') ...[
          if (_variousPushFlagsOptions.isNotEmpty) ...[
            OpenvpnMultiSelectField(
              labelText: 'Push Options',
              helperText: 'Various less frequently used yes/no options which can be pushed to the client for this instance.',
              prefixIcon: Icons.push_pin,
              options: _variousPushFlagsOptions,
              selectedValues: _selectedVariousPushFlags,
              onChanged: (values) => setState(() {
                _selectedVariousPushFlags
                  ..clear()
                  ..addAll(values);
              }),
            ),
            const SizedBox(height: 16),
          ],
          if (_redirectGatewayOptions.isNotEmpty) ...[
            OpenvpnMultiSelectField(
              labelText: 'Redirect Gateway',
              helperText: 'Automatically execute routing commands to cause all outgoing IP traffic to be redirected over the VPN.',
              prefixIcon: Icons.alt_route,
              options: _redirectGatewayOptions,
              selectedValues: _selectedRedirectGateway,
              onChanged: (values) => setState(() {
                _selectedRedirectGateway
                  ..clear()
                  ..addAll(values);
              }),
            ),
            const SizedBox(height: 16),
          ],
          OpenvpnToggleField(
            title: 'Register DNS',
            subtitle: 'Run ipconfig /flushdns and ipconfig /registerdns on connection initiation. This is known to kick Windows into recognizing pushed DNS servers.',
            value: _registerDns,
            onChanged: (value) => setState(() => _registerDns = value),
          ),
          const SizedBox(height: 16),
          OpenvpnArrayField(
            title: 'DNS Domain List',
            items: _dnsDomain,
            onAdd: () => setState(() => _dnsDomain.add('')),
            onRemove: (index) => setState(() => _dnsDomain.removeAt(index)),
            onUpdate: (index, value) => setState(() => _dnsDomain[index] = value),
            helperText: 'Set Connection-specific DNS Suffixes.',
            emptyMessage: 'No DNS domains configured',
          ),
          const SizedBox(height: 16),
          OpenvpnArrayField(
            title: 'DNS Domain Search List',
            items: _dnsDomainSearch,
            onAdd: () => setState(() => _dnsDomainSearch.add('')),
            onRemove: (index) => setState(() => _dnsDomainSearch.removeAt(index)),
            onUpdate: (index, value) => setState(() => _dnsDomainSearch[index] = value),
            helperText: 'Add name to the domain search list. Repeat this option to add more entries. Up to 10 domains are supported',
            emptyMessage: 'No DNS search domains configured',
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
        ],
        if (_role == 'client') ...[
          OpenvpnTextField(
            controller: _httpProxyController,
            labelText: 'HTTP Proxy',
            hintText: 'proxy.example.com:8080',
            prefixIcon: Icons.http,
            helperText: 'HTTP proxy server (host:port)',
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
        if (_role == 'server') ...[
          OpenvpnTextField(
            controller: _portShareController,
            labelText: 'Port Share',
            hintText: '192.168.1.1:443',
            helperText: 'Enter IP:port (e.g., 192.168.1.1:443)',
            prefixIcon: Icons.share,
            keyboardType: TextInputType.text,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return null; // Optional field
              }
              
              // Check format: IP:port
              final regex = RegExp(r'^(\d{1,3}\.){3}\d{1,3}:\d{1,5}$');
              if (!regex.hasMatch(value.trim())) {
                return 'Invalid format. Use IP:port (e.g., 192.168.1.1:443)';
              }
              
              // Validate IP octets and port range
              final parts = value.trim().split(':');
              final ipParts = parts[0].split('.');
              for (var octet in ipParts) {
                final num = int.tryParse(octet);
                if (num == null || num < 0 || num > 255) {
                  return 'Invalid IP address';
                }
              }
              
              final port = int.tryParse(parts[1]);
              if (port == null || port < 1 || port > 65535) {
                return 'Port must be between 1 and 65535';
              }
              
              return null;
            },
          ),
          const SizedBox(height: 16),
        ],
        if (_verbOptions.isNotEmpty)
          OpenvpnDropdownField(
            labelText: 'Verbosity Level',
            prefixIcon: Icons.info,
            options: _verbOptions,
            value: _selectedVerb,
            onChanged: (value) => setState(() => _selectedVerb = value),
          ),
        const SizedBox(height: 16),
        if (_role == 'server') ...[
          OpenvpnTextField(
            controller: _maxclientsController,
            labelText: 'Concurrent Connections',
            hintText: '10',
            helperText: 'Maximum number of concurrent client connections',
            prefixIcon: Icons.people,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          const SizedBox(height: 16),
        ],
        OpenvpnTextField(
          controller: _keepaliveIntervalController,
          labelText: 'Keep Alive Interval',
          hintText: '10',
          helperText: 'Ping interval in seconds to keep connection alive',
          prefixIcon: Icons.timer,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        const SizedBox(height: 16),
        OpenvpnTextField(
          controller: _keepaliveTimeoutController,
          labelText: 'Keep Alive Timeout',
          hintText: '60',
          helperText: 'Timeout in seconds before considering connection dead',
          prefixIcon: Icons.timer_off,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        const SizedBox(height: 16),
        if (_caOptions.isNotEmpty)
          OpenvpnDropdownField(
            labelText: 'Certificate Authority',
            prefixIcon: Icons.account_balance,
            options: _caOptions,
            value: _selectedCa,
            onChanged: (value) => setState(() => _selectedCa = value),
          ),
        const SizedBox(height: 16),
        if (_authOptions.isNotEmpty)
          OpenvpnDropdownField(
            labelText: 'Auth',
            prefixIcon: Icons.how_to_reg,
            options: _authOptions,
            value: _selectedAuth,
            onChanged: (value) => setState(() => _selectedAuth = value),
          ),
        const SizedBox(height: 16),
        OpenvpnMultiSelectField(
          labelText: 'Data Ciphers',
          prefixIcon: Icons.lock,
          options: _dataCiphersOptions,
          selectedValues: _selectedDataCiphers,
          onChanged: (values) => setState(() {
            _selectedDataCiphers
              ..clear()
              ..addAll(values);
          }),
        ),
        const SizedBox(height: 16),
        OpenvpnDropdownField(
          labelText: 'Data Ciphers Fallback',
          helperText: 'Select fallback cipher for older clients',
          prefixIcon: Icons.security,
          options: _dataCiphersFallbackOptions,
          value: _selectedDataCiphersFallback,
          onChanged: (value) => setState(() => _selectedDataCiphersFallback = value),
        ),
        const SizedBox(height: 16),
        if (_role == 'server') ...[
          OpenvpnToggleField(
            title: 'Username as CN',
            subtitle: 'Use the authenticated username as the common name, rather than the common name from the client certificate.',
            value: _usernameAsCommonName,
            onChanged: (value) => setState(() => _usernameAsCommonName = value),
          ),
          const SizedBox(height: 16),
          OpenvpnTextField(
            controller: _authTokenRenewalController,
            labelText: 'Auth Token Renewal',
            hintText: '0',
            prefixIcon: Icons.refresh,
            helperText: 'Renew the auth-token every n seconds. When set to 0, the token will not be renewed.',
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _authTokenSecretController,
            decoration: InputDecoration(
              labelText: 'Auth Token Secret',
              hintText: 'Leave empty to auto-generate',
              helperText: 'Secret for auth-token generation. Leave empty to auto-generate.',
              prefixIcon: const Icon(Icons.key),
              suffixIcon: IconButton(
                icon: const Icon(Icons.auto_fix_high),
                tooltip: 'Generate key',
                onPressed: _viewModel.isLoading ? null : _generateAuthToken,
              ),
            ),
          ),
          const SizedBox(height: 16),
          OpenvpnToggleField(
            title: 'Require Client Provisioning',
            subtitle: 'Require that connecting clients specify a --auth-user-pass, which allows for deferred authentication.',
            value: _provisionExclusive,
            onChanged: (value) => setState(() => _provisionExclusive = value),
          ),
          const SizedBox(height: 16),
        ],
        OpenvpnArrayField(
          title: 'Excluded Routes',
          items: _pushExcludedRoutes,
          onAdd: () => setState(() => _pushExcludedRoutes.add('')),
          onRemove: (index) => setState(() => _pushExcludedRoutes.removeAt(index)),
          onUpdate: (index, value) => setState(() => _pushExcludedRoutes[index] = value),
          helperText: 'Routes to exclude from the VPN tunnel',
          emptyMessage: 'No excluded routes configured',
        ),
        const SizedBox(height: 16),
        if (_role == 'server') ...[
          OpenvpnTextField(
            controller: _pushInactiveController,
            labelText: 'Push Inactivity Timeout',
            hintText: '600',
            helperText: 'Causes OpenVPN to exit after n seconds of inactivity on the TUN/TAP device.',
            prefixIcon: Icons.timer_off,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          const SizedBox(height: 16),
          OpenvpnTextField(
            controller: _routeMetricController,
            labelText: 'Route-metric (Client)',
            hintText: '100',
            helperText: 'Specify a default metric for use with --route on the client side.',
            prefixIcon: Icons.speed,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          const SizedBox(height: 16),
        ],
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
        SwitchListTile(
          title: const Text('MSS Fix'),
          subtitle: const Text('Enable MSS fix for this connection'),
          value: _mssFix,
          onChanged: (value) {
            setState(() {
              _mssFix = value;
            });
          },
        ),
        const SizedBox(height: 16),
        if (_role == 'server')
          OpenvpnToggleField(
            title: 'Compression Migrate',
            subtitle: 'Enable compression migration for compatibility',
            value: _compressMigrate,
            onChanged: (value) => setState(() => _compressMigrate = value),
          ),
        if (_role == 'server')
          const SizedBox(height: 16),
        if (_role == 'server')
          OpenvpnToggleField(
            title: 'Persist Address Pool',
            subtitle: 'Persist client IP address assignments',
            value: _ifconfigPoolPersist,
            onChanged: (value) => setState(() => _ifconfigPoolPersist = value),
          ),
        if (_role == 'server')
          const SizedBox(height: 16),
        OpenvpnTextField(
          controller: _verifyX509NameController,
          labelText: 'Verify X.509 Name',
          hintText: 'server.example.com',
          prefixIcon: Icons.verified,
        ),
      ],
    );
  }
}


