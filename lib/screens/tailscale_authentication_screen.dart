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
import '../services/demo_api_service.dart';
import '../utils/app_colors.dart';
import '../utils/snackbar_helper.dart';
import '../viewmodels/tailscale_auth_view_model.dart';
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
  late TailscaleAuthViewModel _viewModel;
  bool _isInitialized = false;

  // Form controllers and key live here because they are widget-layer concerns
  final _loginServerController = TextEditingController();
  final _preAuthKeyController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePreAuthKey = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final apiService = context.read<DemoApiService>();
      _viewModel = TailscaleAuthViewModel(apiService);
      _isInitialized = true;
      _viewModel.addListener(_syncControllersFromViewModel);
      _viewModel.loadData();
    }
  }

  @override
  void dispose() {
    _viewModel.removeListener(_syncControllersFromViewModel);
    _viewModel.dispose();
    _loginServerController.dispose();
    _preAuthKeyController.dispose();
    super.dispose();
  }

  /// Keep text controllers in sync when the ViewModel loads fresh data
  void _syncControllersFromViewModel() {
    if (!_viewModel.isLoading && _viewModel.errorMessage == null) {
      if (_loginServerController.text != _viewModel.loginServer) {
        _loginServerController.text = _viewModel.loginServer;
      }
      if (_preAuthKeyController.text != _viewModel.preAuthKey) {
        _preAuthKeyController.text = _viewModel.preAuthKey;
      }
    }
  }

  Future<void> _saveAuthenticationSettings() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final success = await _viewModel.saveSettings(
        _loginServerController.text.trim(),
        _preAuthKeyController.text.trim(),
      );
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        if (success) {
          SnackBarHelper.showSuccess(
              context, l10n.authSettingsSavedSuccessfully);
          _viewModel.loadData();
        } else {
          SnackBarHelper.showError(context, l10n.failedToSaveAuthSettings);
        }
      }
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showError(context, 'Error: ${e.toString()}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.tailscaleAuthentication),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _viewModel.loadData,
              ),
            ],
          ),
          drawer: AppDrawer(
            currentRoute: 'tailscale_authentication',
            systemInfo: _viewModel.systemInfo,
          ),
          body: RefreshIndicator(
            onRefresh: _viewModel.loadData,
            child: _buildBody(),
          ),
        );
      },
    );
  }

  Widget _buildBody() {
    if (_viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_viewModel.errorMessage != null) {
      final l10n = AppLocalizations.of(context)!;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              l10n.errorLoadingData,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(_viewModel.errorMessage!),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _viewModel.loadData,
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
                  helperText:
                      AppLocalizations.of(context)!.loginServerHelperText,
                ),
                validator: (value) {
                  final l10n = AppLocalizations.of(context)!;
                  if (value == null || value.trim().isEmpty) {
                    return l10n.loginServerRequired;
                  }
                  if (!value.startsWith('http://') &&
                      !value.startsWith('https://')) {
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
                  helperText:
                      AppLocalizations.of(context)!.preAuthKeyHelperText,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePreAuthKey
                          ? Icons.visibility
                          : Icons.visibility_off,
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
                  onPressed: _viewModel.isSaving
                      ? null
                      : _saveAuthenticationSettings,
                  icon: _viewModel.isSaving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save),
                  label: Text(_viewModel.isSaving
                      ? AppLocalizations.of(context)!.saving
                      : AppLocalizations.of(context)!.saveSettings),
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
