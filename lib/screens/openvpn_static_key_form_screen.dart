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
import '../models/openvpn_static_key.dart';
import '../services/opnsense_api_service.dart';
import '../widgets/common/loading_overlay.dart';
import '../utils/common_validators.dart';

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
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _descriptionController = TextEditingController();
  final _keyController = TextEditingController();

  // State
  bool _isLoading = false;
  bool _isSaving = false;
  bool _isGenerating = false;
  String? _errorMessage;
  String _selectedMode = 'auth';
  bool _keyVisible = false;

  @override
  void initState() {
    super.initState();

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
    _descriptionController.dispose();
    _keyController.dispose();
    super.dispose();
  }

  bool get _isEditMode => widget.keyid != null;

  Future<void> _loadStaticKey() async {
    final keyid = widget.keyid;
    
    if (keyid == null || keyid.isEmpty) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final apiService = context.read<OPNsenseApiService>();
      final staticKey = await apiService.getOpenvpnStaticKey(keyid);

      if (mounted) {
        setState(() {
          _descriptionController.text = staticKey.description;
          _keyController.text = staticKey.key;
          _selectedMode = _mapApiModeToUiMode(staticKey.mode);
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
    setState(() {
      _isGenerating = true;
      _errorMessage = null;
    });

    try {
      final apiService = context.read<OPNsenseApiService>();
      
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

      final key = await apiService.generateOpenvpnStaticKey(apiMode);

      if (mounted) {
        setState(() {
          _keyController.text = key;
          _isGenerating = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Key generated successfully'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isGenerating = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to generate key: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  Future<void> _saveStaticKey() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      final apiService = context.read<OPNsenseApiService>();

      final staticKey = OpenvpnStaticKey(
        keyid: widget.keyid,
        description: _descriptionController.text.trim(),
        key: _keyController.text.trim(),
        mode: _selectedMode,
      );

      if (_isEditMode) {
        await apiService.updateOpenvpnStaticKey(widget.keyid!, staticKey);
      } else {
        await apiService.addOpenvpnStaticKey(staticKey);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isEditMode
                  ? 'Static key updated successfully'
                  : 'Static key created successfully',
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isSaving = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save static key: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditMode ? 'Edit Static Key' : 'Add Static Key',
        ),
      ),
      body: LoadingOverlay(
        isLoading: _isLoading,
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Error message
              if (_errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),

              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'My Static Key',
                  prefixIcon: Icon(Icons.description),
                  helperText: 'A descriptive name for this static key',
                ),
                validator: (value) =>
                    CommonValidators.required(value, fieldName: 'Description'),
                enabled: !_isSaving,
              ),
              const SizedBox(height: 16),

              // Mode dropdown
              DropdownButtonFormField<String>(
                initialValue: _selectedMode,
                decoration: const InputDecoration(
                  labelText: 'Mode',
                  prefixIcon: Icon(Icons.security),
                  helperText: 'Select the key mode for authentication or encryption',
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'auth',
                    child: Text('Auth (TLS Authentication)'),
                  ),
                  DropdownMenuItem(
                    value: 'crypt',
                    child: Text('Crypt (TLS Encryption)'),
                  ),
                  DropdownMenuItem(
                    value: 'crypt-v2',
                    child: Text('Crypt V2 (TLS Encryption V2)'),
                  ),
                ],
                onChanged: _isSaving
                    ? null
                    : (value) {
                        if (value != null) {
                          setState(() {
                            _selectedMode = value;
                          });
                        }
                      },
                validator: (value) =>
                    CommonValidators.required(value, fieldName: 'Mode'),
              ),
              const SizedBox(height: 24),

              // Generate Key Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isSaving || _isGenerating ? null : _generateKey,
                  icon: _isGenerating
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
                    _isGenerating ? 'Generating...' : 'Generate Key',
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
                  labelText: 'Key',
                  hintText: 'Generate or paste your key here',
                  prefixIcon: const Icon(Icons.vpn_key),
                  helperText: 'The static key content (PEM format)',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _keyVisible ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _keyVisible = !_keyVisible;
                      });
                    },
                    tooltip: _keyVisible ? 'Hide key' : 'Show key',
                  ),
                ),
                validator: (value) =>
                    CommonValidators.required(value, fieldName: 'Key'),
                enabled: !_isSaving,
              ),
              const SizedBox(height: 24),

              // Help Card
              Card(
                color: Colors.blue[50],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.blue[700]),
                          const SizedBox(width: 8),
                          Text(
                            'Static Key Information',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[700],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '• Auth: Adds HMAC authentication to control channel\n'
                        '• Crypt: Encrypts and authenticates all control channel packets\n'
                        '• Crypt V2: Enhanced encryption with improved security\n\n'
                        'You can generate a new key or paste an existing one.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue[900],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Save Button
              ElevatedButton(
                onPressed: _isSaving || _isGenerating ? null : _saveStaticKey,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: _isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        _isEditMode ? 'Update Static Key' : 'Create Static Key',
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

// Made with Bob
