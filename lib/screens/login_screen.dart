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
import 'package:uuid/uuid.dart';
import '../models/opnsense_config.dart';
import '../models/profile.dart';
import '../services/profile_service.dart';
import '../services/opnsense_api_service.dart';
import '../utils/constants.dart';
import '../utils/validators.dart';
import '../l10n/app_localizations.dart';

/// Login screen for OPNsense connection configuration
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

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
  bool _isLoading = false;
  bool _obscureSecret = true;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _hostController.dispose();
    _portController.dispose();
    _apiKeyController.dispose();
    _apiSecretController.dispose();
    super.dispose();
  }

  Future<void> _testAndSaveConnection() async {
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
      );

      // Initialize API service
      final apiService = context.read<OPNsenseApiService>();
      apiService.init(config);


      // Test connection
      final isConnected = await apiService.testConnection();

      if (!mounted) return;

      if (isConnected) {
        
        // Create and save profile
        final profileService = context.read<ProfileService>();
        final profile = Profile(
          id: const Uuid().v4(),
          name: _nameController.text.trim().isEmpty
              ? '${config.host}:${config.port}'
              : _nameController.text.trim(),
          host: config.host,
          port: config.port,
          apiKey: config.apiKey,
          apiSecret: config.apiSecret,
          useHttps: config.useHttps,
          createdAt: DateTime.now(),
          lastUsed: DateTime.now(),
        );
        
        await profileService.saveProfile(profile);
        await profileService.setActiveProfile(profile.id);

        // Return success to profile selection screen
        if (mounted) {
          Navigator.of(context).pop(true);
        }
      } else {
        if (!mounted) return;
        final l10n = AppLocalizations.of(context)!;
        setState(() {
          _errorMessage = l10n.connectionFailed;
          _isLoading = false;
        });
      }
    } on ApiException catch (e) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      setState(() {
        _errorMessage = l10n.apiError(e.message);
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      setState(() {
        _errorMessage = l10n.errorPrefix(e.toString());
        _isLoading = false;
      });
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
                    AppConstants.appName,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Subtitle
                  Text(
                    l10n.connectToYourOPNsenseFirewall,
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
                  
                  // Connect Button
                  ElevatedButton(
                    onPressed: _isLoading ? null : _testAndSaveConnection,
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
                            l10n.connect,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
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

