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


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:file_picker/file_picker.dart';
import '../models/opnsense_config.dart';
import '../models/profile.dart';
import '../models/dhcp_server_type.dart';
import '../services/profile_service.dart';
import '../services/demo_api_service.dart';
import '../services/opnsense_api_service.dart';
import '../utils/constants.dart';
import '../utils/validators.dart';
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
  
  bool _useHttps = true;
  bool _allowSelfSignedCerts = false;
  bool _isLoading = false;
  bool _obscureSecret = true;
  String? _errorMessage;
  DhcpServerType _dhcpServerType = DhcpServerType.dnsmasq;

  @override
  void initState() {
    super.initState();
    // Pre-populate form if editing existing profile
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

  @override
  void dispose() {
    _nameController.dispose();
    _hostController.dispose();
    _portController.dispose();
    _apiKeyController.dispose();
    _apiSecretController.dispose();
    super.dispose();
  }

  Future<void> _testAndSaveConnection({required bool connectAfterSave}) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final config = OPNsenseConfig(
        host: _hostController.text.trim(),
        port: int.parse(_portController.text.trim()),
        apiKey: _apiKeyController.text.trim(),
        apiSecret: _apiSecretController.text.trim(),
        useHttps: _useHttps,
        allowSelfSignedCerts: _allowSelfSignedCerts,
      );

      // Initialize API service
      final demoApiService = context.read<DemoApiService>();
      final realApiService = context.read<OPNsenseApiService>();
      
      // Disable demo mode and initialize real API service
      demoApiService.setDemoMode(false);
      realApiService.init(config);

      // Test connection
      final isConnected = await demoApiService.testConnection();

      if (!mounted) return;

      if (isConnected) {
        
        // Create or update profile
        final profileService = context.read<ProfileService>();
        final profile = widget.profile != null
            ? widget.profile!.copyWith(
                name: _nameController.text.trim().isEmpty
                    ? '${config.host}:${config.port}'
                    : _nameController.text.trim(),
                host: config.host,
                port: config.port,
                apiKey: config.apiKey,
                apiSecret: config.apiSecret,
                useHttps: config.useHttps,
                allowSelfSignedCerts: config.allowSelfSignedCerts,
                dhcpServerType: _dhcpServerType,
                lastUsed: DateTime.now(),
              )
            : Profile(
                id: const Uuid().v4(),
                name: _nameController.text.trim().isEmpty
                    ? '${config.host}:${config.port}'
                    : _nameController.text.trim(),
                host: config.host,
                port: config.port,
                apiKey: config.apiKey,
                apiSecret: config.apiSecret,
                useHttps: config.useHttps,
                allowSelfSignedCerts: config.allowSelfSignedCerts,
                dhcpServerType: _dhcpServerType,
                createdAt: DateTime.now(),
                lastUsed: DateTime.now(),
              );
        
        await profileService.saveProfile(profile);
        await profileService.setActiveProfile(profile.id);

        if (mounted) {
          if (connectAfterSave) {
            // Navigate to dashboard
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const DashboardScreen()),
            );
          } else {
            // Return to profile selection screen
            Navigator.of(context).pop(true);
          }
        }
      } else {
        if (!mounted) return;
        final l10n = AppLocalizations.of(context)!;
        setState(() {
          _errorMessage = l10n.connectionFailed;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      setState(() {
        _errorMessage = l10n.apiError(e.toString());
        _isLoading = false;
      });
    }
  }

  Future<void> _importProfiles() async {
    try {
      final l10n = AppLocalizations.of(context)!;
      final profileService = context.read<ProfileService>();
      
      // Pick a file
      final pickerResult = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        allowMultiple: false,
      );
      
      if (pickerResult == null || pickerResult.files.isEmpty) {
        return; // User cancelled
      }
      
      // Check if path is null before accessing it
      if (pickerResult.files.first.path == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.unableToAccessFilePath),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }
      
      final file = File(pickerResult.files.first.path!);
      final jsonString = await file.readAsString();
      
      // Validate file format
      final validationError = profileService.validateImportFile(jsonString);
      
      if (validationError != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.invalidFileFormat(validationError)),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }
      
      // Show import options dialog
      if (!mounted) return;
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
      
      if (overwrite == null) return; // User cancelled
      
      // Import profiles
      final result = await profileService.importProfiles(
        jsonString,
        overwrite: overwrite,
      );
      
      // Show result
      if (mounted) {
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
        
        // If import was successful, navigate back to profile selection
        if (successCount > 0) {
          Navigator.of(context).pop(true);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Import failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
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
                    widget.profile != null ? l10n.editProfile : AppConstants.appName,
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
                    enabled: !_isLoading,
                  ),
                  const SizedBox(height: 16),
                  
                  // Host Field
                  TextFormField(
                    controller: _hostController,
                    decoration: InputDecoration(
                      labelText: l10n.hostIpAddress,
                      hintText: l10n.hostPlaceholder,
                      prefixIcon: const Icon(Icons.dns),
                    ),
                    keyboardType: TextInputType.url,
                    validator: Validators.validateHost,
                    enabled: !_isLoading,
                  ),
                  const SizedBox(height: 16),
                  
                  // Port Field
                  TextFormField(
                    controller: _portController,
                    decoration: InputDecoration(
                      labelText: l10n.port,
                      hintText: l10n.portPlaceholder,
                      prefixIcon: const Icon(Icons.settings_ethernet),
                    ),
                    keyboardType: TextInputType.number,
                    validator: Validators.validatePort,
                    enabled: !_isLoading,
                  ),
                  const SizedBox(height: 16),
                  
                  // HTTPS Toggle
                  SwitchListTile(
                    title: Text(l10n.useHttps),
                    subtitle: Text(l10n.recommendedForSecureConnections),
                    value: _useHttps,
                    onChanged: _isLoading ? null : (value) {
                      setState(() {
                        _useHttps = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  SwitchListTile(
                    title: Text(l10n.allowSelfSigned),
                    subtitle: Text(
                      'WARNING: Disables TLS certificate validation for this profile. Only enable this if you trust the server and intentionally use a self-signed certificate.',
                    ),
                    value: _allowSelfSignedCerts,
                    onChanged: !_useHttps || _isLoading
                        ? null
                        : (value) {
                            setState(() {
                              _allowSelfSignedCerts = value;
                            });
                          },
                  ),
                  const SizedBox(height: 16),

                  // DHCP Server Type
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.dns),
                    title: const Text('DHCP Server Type'),
                    subtitle: Text(_dhcpServerType.displayName),
                    trailing: DropdownButton<DhcpServerType>(
                      value: _dhcpServerType,
                      items: DhcpServerType.values.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type.displayName),
                        );
                      }).toList(),
                      onChanged: _isLoading ? null : (value) {
                        if (value != null) {
                          setState(() {
                            _dhcpServerType = value;
                          });
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      _dhcpServerType.description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                  ),
                  const SizedBox(height: 16),
                   
                  // API Key Field
                  TextFormField(
                    controller: _apiKeyController,
                    decoration: InputDecoration(
                      labelText: l10n.apiKey,
                      hintText: l10n.enterYourApiKey,
                      prefixIcon: const Icon(Icons.vpn_key),
                    ),
                    validator: Validators.validateApiKey,
                    enabled: !_isLoading,
                  ),
                  const SizedBox(height: 16),
                  
                  // API Secret Field
                  TextFormField(
                    controller: _apiSecretController,
                    decoration: InputDecoration(
                      labelText: l10n.apiSecret,
                      hintText: l10n.enterYourApiSecret,
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureSecret ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureSecret = !_obscureSecret;
                          });
                        },
                      ),
                    ),
                    obscureText: _obscureSecret,
                    validator: Validators.validateApiSecret,
                    enabled: !_isLoading,
                  ),
                  const SizedBox(height: 24),
                  
                  // Error Message
                  if (_errorMessage != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red[300]!),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red[700]),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: TextStyle(color: Colors.red[700]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  
                  // Save Button (only show when editing)
                  if (widget.profile != null) ...[
                    OutlinedButton(
                      onPressed: _isLoading ? null : () => _testAndSaveConnection(connectAfterSave: false),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(
                              l10n.save,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  
                  // Connect Button
                  ElevatedButton(
                    onPressed: _isLoading ? null : () => _testAndSaveConnection(connectAfterSave: true),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            widget.profile != null ? 'Save & Connect' : l10n.connect,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                 ),
                 const SizedBox(height: 16),
                 
                 // Import Profiles button (only show when not editing)
                 if (widget.profile == null)
                   OutlinedButton.icon(
                     onPressed: _isLoading ? null : _importProfiles,
                     icon: const Icon(Icons.upload_file),
                     label: Text(l10n.importProfiles),
                     style: OutlinedButton.styleFrom(
                       padding: const EdgeInsets.symmetric(vertical: 16),
                       side: BorderSide(
                         color: Theme.of(context).primaryColor.withValues(alpha: 0.5),
                         width: 1,
                       ),
                     ),
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

