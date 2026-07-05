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
import '../l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../models/openvpn_static_key.dart';
import '../utils/constants.dart';
import '../utils/snackbar_helper.dart';
import '../viewmodels/openvpn_static_key_form_view_model.dart';
import '../widgets/common/loading_overlay.dart';
import '../utils/validators.dart';

/// Form screen for creating/editing OpenVPN static keys
class OpenvpnStaticKeyFormScreen extends StatefulWidget {
  final String? keyid;

  const OpenvpnStaticKeyFormScreen({super.key, this.keyid});

  @override
  State<OpenvpnStaticKeyFormScreen> createState() =>
      _OpenvpnStaticKeyFormScreenState();
}

class _OpenvpnStaticKeyFormScreenState
    extends State<OpenvpnStaticKeyFormScreen> {
  late OpenvpnStaticKeyFormViewModel _viewModel;
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _descriptionController = TextEditingController();
  final _keyController = TextEditingController();

  // State
  String _selectedMode = 'auth';
  bool _keyVisible = false;

  @override
  void initState() {
    super.initState();
    _viewModel = OpenvpnStaticKeyFormViewModel(
      apiService: context.read(),
      keyid: widget.keyid,
    );
    _viewModel.addListener(_onViewModelChanged);

    if (_isEditMode) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _loadStaticKey();
        }
      });
    }
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    _descriptionController.dispose();
    _keyController.dispose();
    super.dispose();
  }

  void _onViewModelChanged() {
    if (mounted) setState(() {});
  }

  bool get _isEditMode => widget.keyid != null;

  Future<void> _loadStaticKey() async {
    await _viewModel.loadStaticKey();

    if (mounted && _viewModel.loadedKey != null) {
      final staticKey = _viewModel.loadedKey!;
      setState(() {
        _descriptionController.text = staticKey.description;
        _keyController.text = staticKey.key;
        _selectedMode = _mapApiModeToUiMode(staticKey.mode);
      });
    }
  }

  String _mapApiModeToUiMode(String? mode) {
    switch (mode) {
      case 'tls-auth':
      case 'auth':
        return 'auth';
      case 'tls-crypt':
      case 'crypt':
        return 'crypt';
      case 'tls-crypt-v2-server':
      case 'crypt-v2':
        return 'crypt-v2';
      default:
        return 'auth';
    }
  }

  Future<void> _generateKey() async {
    final l10n = AppLocalizations.of(context)!;

    // Map UI mode to API mode
    String apiMode;
    switch (_selectedMode) {
      case 'auth':
        apiMode = 'tls-auth';
        break;
      case 'crypt':
        apiMode = 'tls-crypt';
        break;
      case 'crypt-v2':
        apiMode = 'tls-crypt-v2-server';
        break;
      default:
        apiMode = 'tls-auth';
    }

    final key = await _viewModel.generateKey(apiMode);

    if (!mounted) return;

    if (key != null) {
      setState(() {
        _keyController.text = key;
      });
      SnackBarHelper.showSuccess(context, l10n.keyGeneratedSuccessfully);
    } else if (_viewModel.errorMessage != null) {
      SnackBarHelper.showError(context, _viewModel.errorMessage!, duration: const Duration(seconds: 4));
    }
  }

  Future<void> _saveStaticKey() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;

    final staticKey = OpenvpnStaticKey(
      keyid: widget.keyid,
      description: _descriptionController.text.trim(),
      key: _keyController.text.trim(),
      mode: _selectedMode,
    );

    final success = await _viewModel.saveStaticKey(staticKey);

    if (mounted) {
      if (success) {
        SnackBarHelper.showSuccess(context, _isEditMode
            ? l10n.staticKeyUpdatedSuccessfully
            : l10n.staticKeyCreatedSuccessfully);
        Navigator.of(context).pop(true);
      } else {
        SnackBarHelper.showError(context, _viewModel.errorMessage ?? l10n.failedToSaveStaticKey(''), duration: const Duration(seconds: 4));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditMode ? l10n.editStaticKey : l10n.addStaticKey,
        ),
      ),
      body: LoadingOverlay(
        isLoading: _viewModel.isLoading,
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Error message
              if (_viewModel.errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.error),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: AppColors.error),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _viewModel.errorMessage!,
                          style: const TextStyle(color: AppColors.error),
                        ),
                      ),
                    ],
                  ),
                ),

              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: l10n.description,
                  hintText: l10n.myStaticKey,
                  prefixIcon: const Icon(Icons.description),
                  helperText: l10n.staticKeyDescriptionHelper,
                ),
                validator: (value) =>
                    Validators.required(value, fieldName: 'Description'),
                enabled: !_viewModel.isLoading,
              ),
              const SizedBox(height: 16),

              // Mode dropdown
              DropdownButtonFormField<String>(
                initialValue: _selectedMode,
                decoration: InputDecoration(
                  labelText: l10n.mode,
                  prefixIcon: const Icon(Icons.security),
                  helperText: l10n.selectKeyModeHelper,
                ),
                items: [
                  DropdownMenuItem(
                    value: 'auth',
                    child: Text(l10n.authTlsAuthentication),
                  ),
                  DropdownMenuItem(
                    value: 'crypt',
                    child: Text(l10n.cryptTlsEncryption),
                  ),
                  DropdownMenuItem(
                    value: 'crypt-v2',
                    child: Text(l10n.cryptV2TlsEncryption),
                  ),
                ],
                onChanged: _viewModel.isLoading
                    ? null
                    : (value) {
                        if (value != null) {
                          setState(() {
                            _selectedMode = value;
                          });
                        }
                      },
                validator: (value) =>
                    Validators.required(value, fieldName: 'Mode'),
              ),
              const SizedBox(height: 24),

              // Generate Key Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _viewModel.isLoading || _viewModel.isGenerating ? null : _generateKey,
                  icon: _viewModel.isGenerating
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.refresh),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  label: Text(
                    _viewModel.isGenerating ? l10n.generating : l10n.generateKey,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Key field
              TextFormField(
                controller: _keyController,
                obscureText: !_keyVisible,
                maxLines: _keyVisible ? 10 : 1,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.key,
                  hintText: AppLocalizations.of(context)!.generateOrPasteKeyHere,
                  prefixIcon: const Icon(Icons.vpn_key),
                  helperText: AppLocalizations.of(context)!.staticKeyContentPemFormat,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _keyVisible ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _keyVisible = !_keyVisible;
                      });
                    },
                    tooltip: _keyVisible ? l10n.hideKey : l10n.showKey,
                  ),
                ),
                validator: (value) =>
                    Validators.required(value, fieldName: 'Key'),
                enabled: !_viewModel.isLoading,
              ),
              const SizedBox(height: 24),

              // Help Card
              Card(
                color: AppColors.infoBackground,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.info_outline, color: AppColors.infoText),
                          const SizedBox(width: 8),
                          Text(
                            l10n.staticKeyInformation,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.infoText,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.staticKeyHelpText,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.infoText,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Save Button
              ElevatedButton(
                onPressed: _viewModel.isLoading || _viewModel.isGenerating ? null : _saveStaticKey,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: AppColors.onPrimary,
                ),
                child: Text(
                  _isEditMode ? l10n.updateStaticKey : l10n.createStaticKey,
                  style: const TextStyle(
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
