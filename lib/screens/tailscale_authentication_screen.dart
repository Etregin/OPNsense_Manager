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
import '../models/system_info.dart';
import '../services/demo_api_service.dart';
import '../widgets/app_drawer.dart';

/// Screen for managing Tailscale authentication
class TailscaleAuthenticationScreen extends StatefulWidget {
  const TailscaleAuthenticationScreen({super.key});

  @override
  State<TailscaleAuthenticationScreen> createState() =>
      _TailscaleAuthenticationScreenState();
}

class _TailscaleAuthenticationScreenState
    extends State<TailscaleAuthenticationScreen> {
  SystemInfo? _systemInfo;
  bool _isLoading = true;
  String? _errorMessage;
  
  // Form controllers for authentication settings
  final _loginServerController = TextEditingController();
  final _preAuthKeyController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;
  bool _obscurePreAuthKey = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _loginServerController.dispose();
    _preAuthKeyController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final demoApiService = context.read<DemoApiService>();
      final results = await Future.wait([
        demoApiService.getSystemInfo(),
        demoApiService.getTailscaleAuthentication(),
      ]);

      if (mounted) {
        final authSettings = results[1] as Map<String, String?>;
        
        setState(() {
          _systemInfo = results[0] as SystemInfo;
          
          // Load authentication settings into form controllers
          _loginServerController.text = authSettings['loginServer'] ?? 'https://login.tailscale.com';
          _preAuthKeyController.text = authSettings['preAuthKey'] ?? '';
          
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

  Future<void> _saveAuthenticationSettings() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final demoApiService = context.read<DemoApiService>();
      final success = await demoApiService.setTailscaleAuthentication(
        _loginServerController.text.trim(),
        _preAuthKeyController.text.trim(),
      );

      if (mounted) {
        setState(() {
          _isSaving = false;
        });

        final l10n = AppLocalizations.of(context)!;
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.authSettingsSavedSuccessfully),
              backgroundColor: Colors.green,
            ),
          );
          // Reload data to reflect any changes
          _loadData();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.failedToSaveAuthSettings),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.tailscaleAuthentication),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      drawer: AppDrawer(
        currentRoute: 'tailscale_authentication',
        systemInfo: _systemInfo,
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      final l10n = AppLocalizations.of(context)!;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              l10n.errorLoadingData,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(_errorMessage!),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loadData,
              icon: const Icon(Icons.refresh),
              label: Text(l10n.retry),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildAuthenticationSettingsCard(),
      ],
    );
  }

  Widget _buildAuthenticationSettingsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.vpn_key, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    AppLocalizations.of(context)!.authenticationSettings,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
              const Divider(height: 24),
              TextFormField(
                controller: _loginServerController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.loginServer,
                  hintText: 'https://login.tailscale.com',
                  border: const OutlineInputBorder(),
                  helperText: AppLocalizations.of(context)!.loginServerHelperText,
                ),
                validator: (value) {
                  final l10n = AppLocalizations.of(context)!;
                  if (value == null || value.trim().isEmpty) {
                    return l10n.loginServerRequired;
                  }
                  if (!value.startsWith('http://') && !value.startsWith('https://')) {
                    return l10n.mustBeValidUrl;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _preAuthKeyController,
                obscureText: _obscurePreAuthKey,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.preAuthKey,
                  hintText: 'tskey-auth-...',
                  border: const OutlineInputBorder(),
                  helperText: AppLocalizations.of(context)!.preAuthKeyHelperText,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePreAuthKey ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePreAuthKey = !_obscurePreAuthKey;
                      });
                    },
                  ),
                ),
                maxLines: 1,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isSaving ? null : _saveAuthenticationSettings,
                  icon: _isSaving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save),
                  label: Text(_isSaving ? AppLocalizations.of(context)!.saving : AppLocalizations.of(context)!.saveSettings),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
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


