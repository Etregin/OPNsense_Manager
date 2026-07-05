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
import '../models/profile.dart';
import '../models/connection_endpoint.dart';
import '../models/dhcp_server_type.dart';
import '../services/profile_service.dart';
import '../services/demo_api_service.dart';
import '../services/opnsense_api_service.dart';
import '../services/settings/profile_import_service.dart';
import '../utils/snackbar_helper.dart';
import '../viewmodels/login_view_model.dart';
import '../widgets/common/error_display.dart';
import '../widgets/login/connection_endpoints_manager.dart';
import '../widgets/login/credentials_fields_section.dart';
import '../widgets/login/dhcp_server_selector.dart';
import '../widgets/login/login_form_actions.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../l10n/app_localizations.dart';
import 'dashboard_screen.dart';

/// Login screen for OPNsense connection configuration
class LoginScreen extends StatefulWidget {
  final Profile? profile; // Optional profile for editing

  const LoginScreen({super.key, this.profile});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _apiKeyController = TextEditingController();
  final _apiSecretController = TextEditingController();

  late LoginViewModel _viewModel;
  late ProfileImportService _importService;

  List<ConnectionEndpoint> _connections = [
    const ConnectionEndpoint(host: '', port: 443, isActive: true),
  ];
  bool _useHttps = true;
  bool _allowSelfSignedCerts = false;
  bool _obscureSecret = true;
  DhcpServerType _dhcpServerType = DhcpServerType.dnsmasq;
  String? _loadingButton; // Track which button is loading

  @override
  void initState() {
    super.initState();
    _initializeServices();
    _populateFormIfEditing();
  }

  void _initializeServices() {
    final profileService = context.read<ProfileService>();
    final demoApiService = context.read<DemoApiService>();
    final opnsenseApiService = context.read<OPNsenseApiService>();

    _viewModel = LoginViewModel(
      profileService: profileService,
      demoApiService: demoApiService,
      opnsenseApiService: opnsenseApiService,
      existingProfile: widget.profile,
    );

    _importService = ProfileImportService(profileService: profileService);

    _viewModel.addListener(_onViewModelChanged);
  }

  void _populateFormIfEditing() {
    if (widget.profile != null) {
      _nameController.text = widget.profile!.name;
      _connections = List.from(widget.profile!.connections);
      _apiKeyController.text = widget.profile!.apiKey;
      _apiSecretController.text = widget.profile!.apiSecret;
      _useHttps = widget.profile!.useHttps;
      _allowSelfSignedCerts = widget.profile!.allowSelfSignedCerts;
      _dhcpServerType = widget.profile!.dhcpServerType;
    }
  }

  void _onViewModelChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    _nameController.dispose();
    _apiKeyController.dispose();
    _apiSecretController.dispose();
    super.dispose();
  }

  bool _validateForm() {
    if (!_formKey.currentState!.validate()) {
      return false;
    }
    if (_connections.isEmpty || _connections.every((c) => c.host.trim().isEmpty)) {
      final l10n = AppLocalizations.of(context)!;
      SnackBarHelper.showError(context, l10n.addConnectionEndpoint);
      return false;
    }
    return true;
  }

  Future<void> _handleTestProfile() async {
    if (!_validateForm()) return;

    setState(() => _loadingButton = 'test');

    final result = await _viewModel.testAllConnections(
      connections: _connections,
      apiKey: _apiKeyController.text.trim(),
      apiSecret: _apiSecretController.text.trim(),
      useHttps: _useHttps,
      allowSelfSignedCerts: _allowSelfSignedCerts,
    );

    setState(() => _loadingButton = null);

    if (!mounted) return;

    // Show test results dialog
    _showTestResultsDialog(result);
  }

  void _showTestResultsDialog(Map<String, dynamic> result) {
    final l10n = AppLocalizations.of(context)!;
    final results = result['results'] as List<Map<String, dynamic>>;
    final successCount = result['successCount'] as int;
    final totalCount = result['totalCount'] as int;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.connectionTestResults),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary
              Text(
                successCount == totalCount
                    ? l10n.allConnectionsSuccessful
                    : l10n.someConnectionsFailed,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: successCount == totalCount ? AppColors.success : AppColors.warning,
                ),
              ),
              const SizedBox(height: 16),
              // Individual results
              ...results.map((r) {
                final success = r['success'] as bool;
                final endpoint = r['endpoint'] as String;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(
                        success ? Icons.check_circle : Icons.error,
                        color: success ? AppColors.success : AppColors.error,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          endpoint,
                          style: TextStyle(
                            color: success ? AppColors.success : AppColors.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
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

  Future<void> _handleSaveProfile() async {
    if (!_validateForm()) return;

    // Get the active connection for the default name
    final activeConnection = _connections.firstWhere(
      (c) => c.isActive,
      orElse: () => _connections.first,
    );

    setState(() => _loadingButton = 'save');

    final success = await _viewModel.saveProfile(
      name: _nameController.text.trim().isEmpty
          ? '${activeConnection.host}:${activeConnection.port}'
          : _nameController.text.trim(),
      connections: _connections,
      apiKey: _apiKeyController.text.trim(),
      apiSecret: _apiSecretController.text.trim(),
      useHttps: _useHttps,
      allowSelfSignedCerts: _allowSelfSignedCerts,
      dhcpServerType: _dhcpServerType,
    );

    setState(() => _loadingButton = null);

    if (!mounted) return;

    if (success) {
      final l10n = AppLocalizations.of(context)!;
      SnackBarHelper.showSuccess(context, l10n.profileSaved);
      Navigator.of(context).pop(true);
    }
  }

  Future<void> _handleSaveAndConnect() async {
    if (!_validateForm()) return;

    // Get the active connection for the default name
    final activeConnection = _connections.firstWhere(
      (c) => c.isActive,
      orElse: () => _connections.first,
    );

    setState(() => _loadingButton = 'connect');

    final success = await _viewModel.testAndSaveConnection(
      name: _nameController.text.trim().isEmpty
          ? '${activeConnection.host}:${activeConnection.port}'
          : _nameController.text.trim(),
      connections: _connections,
      apiKey: _apiKeyController.text.trim(),
      apiSecret: _apiSecretController.text.trim(),
      useHttps: _useHttps,
      allowSelfSignedCerts: _allowSelfSignedCerts,
      dhcpServerType: _dhcpServerType,
    );

    setState(() => _loadingButton = null);

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    }
  }

  Future<void> _handleImportProfiles() async {
    try {
      final l10n = AppLocalizations.of(context)!;

      // Show import options dialog
      final overwrite = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(l10n.importProfiles),
            content: Text(l10n.importProfilesDialog),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(null),
                child: Text(l10n.cancel),
              ),
              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(l10n.keepBoth),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(l10n.overwrite),
              ),
            ],
          );
        },
      );

      if (overwrite == null) return;

      final result = await _importService.importProfiles(overwrite: overwrite);

      if (!mounted) return;

      final successCount = result['success'] as int;
      final failedCount = result['failed'] as int;
      final errors = result['errors'] as List<String>;

      final String message;
      if (failedCount == 0) {
        message = l10n.successfullyImportedProfiles(successCount);
        SnackBarHelper.showSuccess(context, message, duration: const Duration(seconds: 5));
      } else if (successCount == 0) {
        message = l10n.importFailed(errors.join(', '));
        SnackBarHelper.showError(context, message, duration: const Duration(seconds: 5));
      } else {
        message = l10n.importedWithFailures(successCount, failedCount);
        SnackBarHelper.showWarning(context, message, duration: const Duration(seconds: 5));
      }

      if (successCount > 0) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      SnackBarHelper.showError(context, l10n.importFailed(e.toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.standardPadding * 2),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // App Icon
                  Icon(
                    Icons.security,
                    size: 80,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),

                  // Title
                  Text(
                    widget.profile != null
                        ? l10n.editProfile
                        : AppConstants.appName,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),

                  // Subtitle
                  Text(
                    widget.profile != null
                        ? 'Update your connection settings'
                        : l10n.connectToYourOpnsenseFirewall,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                  ),
                  const SizedBox(height: 48),

                  // Profile Name Field (Optional)
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: l10n.profileNameOptional,
                      hintText: l10n.myOPNsenseRouter,
                      prefixIcon: const Icon(Icons.label),
                    ),
                    enabled: !_viewModel.isLoading,
                  ),
                  const SizedBox(height: 16),

                  // Connection Endpoints Manager
                  ConnectionEndpointsManager(
                    connections: _connections,
                    onConnectionsChanged: (connections) {
                      setState(() => _connections = connections);
                    },
                    enabled: !_viewModel.isLoading,
                  ),
                  const SizedBox(height: 16),

                  // HTTPS and Self-Signed Certs Options
                  SwitchListTile(
                    title: const Text('Use HTTPS'),
                    subtitle: const Text('Use secure HTTPS connection'),
                    value: _useHttps,
                    onChanged: _viewModel.isLoading
                        ? null
                        : (value) => setState(() => _useHttps = value),
                  ),
                  SwitchListTile(
                    title: const Text('Allow Self-Signed Certificates'),
                    subtitle: const Text('Accept self-signed SSL certificates'),
                    value: _allowSelfSignedCerts,
                    onChanged: _viewModel.isLoading
                        ? null
                        : (value) => setState(() => _allowSelfSignedCerts = value),
                  ),
                  const SizedBox(height: 16),

                  // DHCP Server Type
                  DhcpServerSelector(
                    selectedType: _dhcpServerType,
                    isLoading: _viewModel.isLoading,
                    onChanged: (value) => setState(() => _dhcpServerType = value),
                  ),
                  const SizedBox(height: 16),

                  // Credentials Fields
                  CredentialsFieldsSection(
                    apiKeyController: _apiKeyController,
                    apiSecretController: _apiSecretController,
                    obscureSecret: _obscureSecret,
                    isLoading: _viewModel.isLoading,
                    onToggleSecretVisibility: () =>
                        setState(() => _obscureSecret = !_obscureSecret),
                  ),
                  const SizedBox(height: 24),

                  // Status message (progress updates — shown as neutral info, not an error)
                  if (_viewModel.statusMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.infoBackground,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.infoText.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _viewModel.statusMessage!,
                                style: const TextStyle(color: AppColors.infoText),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Error Display
                  if (_viewModel.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: ErrorDisplay(message: _viewModel.errorMessage!),
                    ),

                  // Action Buttons
                  LoginFormActions(
                    isEditing: _viewModel.isEditing,
                    isLoading: _viewModel.isLoading,
                    loadingButton: _loadingButton,
                    onTest: _handleTestProfile,
                    onSave: _handleSaveProfile,
                    onConnect: _handleSaveAndConnect,
                    onImport: _viewModel.isEditing ? null : _handleImportProfiles,
                  ),
                  const SizedBox(height: 24),

                  // Help Text
                  Text(
                    l10n.needHelpCheckDocumentation,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


