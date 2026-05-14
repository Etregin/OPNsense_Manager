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

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/tailscale_settings.dart';
import '../models/system_info.dart';
import '../services/demo_api_service.dart';
import '../services/opnsense_api_service.dart';
import '../widgets/app_drawer.dart';
import 'tailscale_subnets_screen.dart';

/// Screen for managing Tailscale settings
class TailscaleSettingsScreen extends StatefulWidget {
  const TailscaleSettingsScreen({super.key});

  @override
  State<TailscaleSettingsScreen> createState() =>
      _TailscaleSettingsScreenState();
}

class _TailscaleSettingsScreenState extends State<TailscaleSettingsScreen> {
  TailscaleSettings? _settings;
  SystemInfo? _systemInfo;
  bool _isLoading = true;
  String? _errorMessage;
  Timer? _refreshTimer;
  bool _showServiceControls = false;

  // Form controllers
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _loginTimeoutController;
  late TextEditingController _listenPortController;
  late bool _enabled;
  late bool _acceptDNS;
  late bool _advertiseExitNode;
  late bool _acceptSubnetRoutes;
  late bool _enableSSH;
  late bool _disableSNAT;
  String? _selectedExitNode;

  // Batch-save state management
  bool _hasUnsavedChanges = false;
  TailscaleSettings? _originalSettings;
  TailscaleSettings? _modifiedSettings;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loginTimeoutController = TextEditingController();
    _listenPortController = TextEditingController();
    _loadData();
    _startAutoRefresh();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _loginTimeoutController.dispose();
    _listenPortController.dispose();
    super.dispose();
  }

  void _startAutoRefresh() {
    _refreshTimer = Timer.periodic(
      const Duration(seconds: 30),
      (timer) {
        if (mounted && !_hasUnsavedChanges) {
          _loadData();
        }
      },
    );
  }

  Future<void> _loadData() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final demoApiService = context.read<DemoApiService>();

      final settingsResponse = await demoApiService.getTailscaleSettings();
      final systemInfo = await demoApiService.getSystemInfo();

      if (mounted) {
        setState(() {
          _settings = settingsResponse.settings;
          _originalSettings = settingsResponse.settings;
          _modifiedSettings = settingsResponse.settings;
          _systemInfo = systemInfo;
          _isLoading = false;
        });

        _initializeFormFields();
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

  void _initializeFormFields() {
    if (_settings == null) {
      return;
    }

    _loginTimeoutController.text = _settings!.loginTimeout ?? '';
    _listenPortController.text = _settings!.listenPort ?? '';
    
    _enabled = _settings!.enabled ?? false;
    _acceptDNS = _settings!.acceptDNS ?? false;
    _advertiseExitNode = _settings!.advertiseExitNode ?? false;
    _acceptSubnetRoutes = _settings!.acceptSubnetRoutes ?? false;
    _enableSSH = _settings!.enableSSH ?? false;
    _disableSNAT = _settings!.disableSNAT ?? false;

    // Find selected exit node
    _selectedExitNode = null;
    if (_settings!.useExitNode != null) {
      for (var entry in _settings!.useExitNode!.entries) {
        if (entry.value.selected) {
          _selectedExitNode = entry.key;
          break;
        }
      }
    }
  }

  Future<void> _controlService(String action) async {
    final actionTitle = action == 'start'
        ? 'Start'
        : action == 'stop'
            ? 'Stop'
            : 'Restart';

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$actionTitle Tailscale Service'),
        content: Text(
            'Are you sure you want to $action the Tailscale service?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: action == 'stop' ? Colors.red : null,
            ),
            child: Text(actionTitle),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) {
      return;
    }

    // Show progress
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${actionTitle}ing Tailscale service...'),
          duration: const Duration(seconds: 2),
        ),
      );
    }

    try {
      final demoApiService = context.read<DemoApiService>();
      final success = await demoApiService.controlTailscaleService(action);

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Tailscale service ${action}ed successfully'),
              backgroundColor: Colors.green,
            ),
          );
          _loadData();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to $action Tailscale service'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _toggleServiceControls() {
    setState(() {
      _showServiceControls = !_showServiceControls;
    });
  }

  // Track changes to settings fields
  void _onFieldChanged() {
    if (_originalSettings == null) return;

    setState(() {
      _modifiedSettings = TailscaleSettings(
        enabled: _enabled,
        acceptDNS: _acceptDNS,
        advertiseExitNode: _advertiseExitNode,
        acceptSubnetRoutes: _acceptSubnetRoutes,
        enableSSH: _enableSSH,
        disableSNAT: _disableSNAT,
        loginTimeout: _loginTimeoutController.text.trim().isEmpty
            ? null
            : _loginTimeoutController.text.trim(),
        listenPort: _listenPortController.text.trim().isEmpty
            ? null
            : _listenPortController.text.trim(),
        useExitNode: _originalSettings!.useExitNode,
        subnets: _originalSettings!.subnets, // Keep original subnets unchanged
      );
      _hasUnsavedChanges = true;
    });
  }

  // Apply all changes at once
  Future<void> _applyAllChanges() async {
    if (!_hasUnsavedChanges || _modifiedSettings == null) return;

    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      setState(() => _isSaving = true);

      // Get the appropriate API service (demo or real)
      final demoApiService = context.read<DemoApiService>();
      final bool isDemoMode = demoApiService.isDemoMode;
      final opnsenseApiService = isDemoMode ? null : context.read<OPNsenseApiService>();
      
      // Save main settings
      final result = isDemoMode
          ? await demoApiService.setTailscaleSettings(_modifiedSettings!)
          : await opnsenseApiService!.setTailscaleSettings(_modifiedSettings!);

      if (result['result'] == 'saved') {
        // Reload fresh data from API
        await _loadData();
        
        setState(() {
          _originalSettings = _settings;
          _modifiedSettings = _settings;
          _hasUnsavedChanges = false;
        });
        
        // Re-initialize form fields with the new data
        _initializeFormFields();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('All settings saved successfully'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        // Handle validation errors
        final validationErrors = result['validations'] as Map<String, dynamic>?;
        if (validationErrors != null) {
          final errorMessages = <String>[];
          validationErrors.forEach((field, errors) {
            if (errors is List) {
              errorMessages.addAll(errors.map((e) => '$field: $e'));
            }
          });
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Validation errors:\n${errorMessages.join('\n')}'),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 5),
              ),
            );
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to save settings: ${result['result']}'),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 4),
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving settings: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  // Discard unsaved changes
  void _discardChanges() {
    setState(() {
      _modifiedSettings = _originalSettings;
      _hasUnsavedChanges = false;
      _initializeFormFields();
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Changes discarded'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  String? _validateLoginTimeout(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final timeout = int.tryParse(value);
    if (timeout == null || timeout < 0) {
      return 'Please enter a valid timeout in minutes';
    }
    return null;
  }

  String? _validateListenPort(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final port = int.tryParse(value);
    if (port == null || port < 1 || port > 65535) {
      return 'Please enter a valid port (1-65535)';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (_modifiedSettings == null && !_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Tailscale Settings')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    
    return PopScope(
      canPop: !_hasUnsavedChanges,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) return;
        
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Unsaved Changes'),
            content: const Text('You have unsaved changes. Do you want to discard them?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text('Discard'),
              ),
            ],
          ),
        );
        
        if (shouldPop == true && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tailscale Settings'),
          actions: [
            if (_settings != null)
              IconButton(
                icon: Icon(_showServiceControls ? Icons.close : Icons.settings),
                onPressed: _toggleServiceControls,
                tooltip: _showServiceControls ? 'Hide Controls' : 'Service Controls',
              ),
          ],
        ),
        drawer: AppDrawer(
          currentRoute: '/tailscale-settings',
          systemInfo: _systemInfo,
          onBeforeNavigate: () async {
            if (_hasUnsavedChanges) {
              final shouldNavigate = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Unsaved Changes'),
                  content: const Text(
                    'You have unsaved changes. Do you want to discard them and continue?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                      child: const Text('Discard'),
                    ),
                  ],
                ),
              );
              return shouldNavigate ?? false;
            }
            return true;
          },
        ),
        body: _buildBody(),
        floatingActionButton: _hasUnsavedChanges
            ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton.extended(
                    onPressed: _isSaving ? null : _discardChanges,
                    backgroundColor: Colors.grey,
                    heroTag: 'discard',
                    icon: const Icon(Icons.close),
                    label: const Text('Discard'),
                  ),
                  const SizedBox(width: 16),
                  FloatingActionButton.extended(
                    onPressed: _isSaving ? null : _applyAllChanges,
                    heroTag: 'apply',
                    icon: _isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.check),
                    label: Text(_isSaving ? 'Saving...' : 'Apply'),
                  ),
                ],
              )
            : null,
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error: $_errorMessage'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadData,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_settings == null) {
      return const Center(child: Text('No settings available'));
    }

    return Form(
      key: _formKey,
      child: RefreshIndicator(
        onRefresh: _loadData,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (_showServiceControls) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Service Controls',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _controlService('start'),
                              icon: const Icon(Icons.play_arrow),
                              label: const Text('Start'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _controlService('stop'),
                              icon: const Icon(Icons.stop),
                              label: const Text('Stop'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _controlService('restart'),
                              icon: const Icon(Icons.refresh),
                              label: const Text('Restart'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            _buildGeneralSettingsCard(),
            const SizedBox(height: 16),
            _buildRoutingCard(),
            const SizedBox(height: 16),
            _buildDnsCard(),
            const SizedBox(height: 16),
            _buildOtherCard(),
            const SizedBox(height: 80), // Space for FAB
          ],
        ),
      ),
    );
  }

  Widget _buildGeneralSettingsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'General Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Enable Tailscale'),
              subtitle: const Text('Enable or disable the Tailscale service'),
              value: _enabled,
              onChanged: (value) {
                setState(() {
                  _enabled = value;
                });
                _onFieldChanged();
              },
            ),
            const Divider(),
            TextFormField(
              controller: _loginTimeoutController,
              decoration: const InputDecoration(
                labelText: 'Login Timeout (minutes)',
                hintText: 'e.g., 60',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: _validateLoginTimeout,
              onChanged: (value) => _onFieldChanged(),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _listenPortController,
              decoration: const InputDecoration(
                labelText: 'Listen Port',
                hintText: 'e.g., 41641',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: _validateListenPort,
              onChanged: (value) => _onFieldChanged(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoutingCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Routing',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Advertise Exit Node'),
              subtitle: const Text('Allow other devices to route through this node'),
              value: _advertiseExitNode,
              onChanged: (value) {
                setState(() {
                  _advertiseExitNode = value;
                });
                _onFieldChanged();
              },
            ),
            const Divider(),
            const SizedBox(height: 16),
            Text('Use Exit Node', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _selectedExitNode,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                hintText: 'Select exit node',
              ),
              items: [
                // Always include "None" option
                const DropdownMenuItem<String>(
                  value: '',
                  child: Text('None'),
                ),
                // Add other exit nodes if available
                if (_modifiedSettings?.useExitNode != null)
                  ..._modifiedSettings!.useExitNode!.entries
                      .where((entry) => entry.key.isNotEmpty) // Skip empty key (None)
                      .map((entry) {
                    return DropdownMenuItem<String>(
                      value: entry.key,
                      child: Text(entry.value.value ?? entry.key),
                    );
                  }),
              ],
              onChanged: (value) {
                _onFieldChanged();
                setState(() {
                  _selectedExitNode = value ?? '';
                });
              },
            ),
            const SizedBox(height: 16),
            const Divider(),
            SwitchListTile(
              title: const Text('Accept Subnet Routes'),
              subtitle: const Text('Accept routes advertised by other nodes'),
              value: _acceptSubnetRoutes,
              onChanged: (value) {
                setState(() {
                  _acceptSubnetRoutes = value;
                });
                _onFieldChanged();
              },
            ),
            const Divider(),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.lan),
              title: const Text('Manage Subnets'),
              subtitle: const Text('Configure advertised subnets'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                // Check for unsaved changes
                if (_hasUnsavedChanges) {
                  if (!mounted) return;
                  final shouldNavigate = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Unsaved Changes'),
                      content: const Text(
                        'You have unsaved changes. Do you want to discard them and continue?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          style: TextButton.styleFrom(foregroundColor: Colors.red),
                          child: const Text('Discard'),
                        ),
                      ],
                    ),
                  );

                  if (shouldNavigate != true) return;
                }

                // Navigate to subnet management
                if (!mounted) return;
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TailscaleSubnetsScreen(),
                  ),
                );
                
                // Reload data when returning (only if no unsaved changes)
                if (mounted && !_hasUnsavedChanges) {
                  _loadData();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDnsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'DNS',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Accept DNS'),
              subtitle: const Text('Use DNS servers provided by Tailscale'),
              value: _acceptDNS,
              onChanged: (value) {
                setState(() {
                  _acceptDNS = value;
                });
                _onFieldChanged();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtherCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Other Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Enable SSH'),
              subtitle: const Text('Allow SSH access through Tailscale'),
              value: _enableSSH,
              onChanged: (value) {
                setState(() {
                  _enableSSH = value;
                });
                _onFieldChanged();
              },
            ),
            const Divider(),
            SwitchListTile(
              title: const Text('Disable SNAT'),
              subtitle: const Text('Disable source NAT for subnet routes'),
              value: _disableSNAT,
              onChanged: (value) {
                setState(() {
                  _disableSNAT = value;
                });
                _onFieldChanged();
              },
            ),
          ],
        ),
      ),
    );
  }
}


