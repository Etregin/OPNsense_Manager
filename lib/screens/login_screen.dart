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
import '../models/dhcp_server_type.dart';
import '../services/profile_service.dart';
import '../services/demo_api_service.dart';
import '../services/opnsense_api_service.dart';
import '../services/settings/profile_import_service.dart';
import '../viewmodels/login_view_model.dart';
import '../widgets/common/error_display.dart';
import '../widgets/login/connection_fields_section.dart';
import '../widgets/login/credentials_fields_section.dart';
import '../widgets/login/dhcp_server_selector.dart';
import '../widgets/login/login_form_actions.dart';
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
  final _hostController = TextEditingController();
  final _portController = TextEditingController(text: '443');
  final _apiKeyController = TextEditingController();
  final _apiSecretController = TextEditingController();

  late LoginViewModel _viewModel;
  late ProfileImportService _importService;

  bool _useHttps = true;
  bool _allowSelfSignedCerts = false;
  bool _obscureSecret = true;
  DhcpServerType _dhcpServerType = DhcpServerType.dnsmasq;

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
      _hostController.text = widget.profile!.host;
      _portController.text = widget.profile!.port.toString();
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
    _hostController.dispose();
    _portController.dispose();
    _apiKeyController.dispose();
    _apiSecretController.dispose();
    super.dispose();
  }

  Future<void> _handleSaveAndConnect({required bool connectAfterSave}) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final success = await _viewModel.testAndSaveConnection(
      name: _nameController.text.trim().isEmpty
          ? '${_hostController.text.trim()}:${_portController.text.trim()}'
          : _nameController.text.trim(),
      host: _hostController.text.trim(),
      port: int.parse(_portController.text.trim()),
      apiKey: _apiKeyController.text.trim(),
      apiSecret: _apiSecretController.text.trim(),
      useHttps: _useHttps,
      allowSelfSignedCerts: _allowSelfSignedCerts,
      dhcpServerType: _dhcpServerType,
    );

    if (!mounted) return;

    if (success) {
      if (connectAfterSave) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
        );
      } else {
        Navigator.of(context).pop(true);
      }
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
            title: Text(l10n.importProfilesTitle),
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

      String message;
      Color backgroundColor;

      if (failedCount == 0) {
        message = l10n.successfullyImportedProfiles(successCount);
        backgroundColor = Colors.green;
      } else if (successCount == 0) {
        message = l10n.importFailedWithErrors(errors.join(', '));
        backgroundColor = Colors.red;
      } else {
        message = l10n.importedWithFailures(successCount, failedCount);
        backgroundColor = Colors.orange;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: backgroundColor,
          duration: const Duration(seconds: 5),
        ),
      );

      if (successCount > 0) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Import failed: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
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
                    color: Theme.of(context).primaryColor,
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
                        : l10n.connectToYourOPNsenseFirewall,
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

                  // Connection Fields
                  ConnectionFieldsSection(
                    hostController: _hostController,
                    portController: _portController,
                    useHttps: _useHttps,
                    allowSelfSignedCerts: _allowSelfSignedCerts,
                    isLoading: _viewModel.isLoading,
                    onHttpsChanged: (value) => setState(() => _useHttps = value),
                    onSelfSignedChanged: (value) =>
                        setState(() => _allowSelfSignedCerts = value),
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
                    onSave: () => _handleSaveAndConnect(connectAfterSave: false),
                    onConnect: () => _handleSaveAndConnect(connectAfterSave: true),
                    onImport: _viewModel.isEditing ? null : _handleImportProfiles,
                  ),
                  const SizedBox(height: 24),

                  // Help Text
                  Text(
                    l10n.needHelpCheckDocumentation,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
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

// Made with Bob
