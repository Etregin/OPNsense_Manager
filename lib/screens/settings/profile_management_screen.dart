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
import '../../models/profile.dart';
import '../../models/connection_endpoint.dart';
import '../../models/dhcp_server_type.dart';
import '../../services/demo_api_service.dart';
import '../../services/opnsense_api_service.dart';
import '../../services/settings/profile_manager_service.dart';
import '../../services/settings/file_operations_service.dart';
import '../../utils/constants.dart';
import '../../utils/snackbar_helper.dart';
import '../../utils/validators.dart';
import '../../viewmodels/profile_management_view_model.dart';
import '../../widgets/common/confirmation_dialog.dart';
import '../../widgets/settings/profile_card.dart';
import '../../widgets/login/connection_endpoints_manager.dart';
import '../../l10n/app_localizations.dart';

/// Screen for managing OPNsense connection profiles
class ProfileManagementScreen extends StatefulWidget {
  const ProfileManagementScreen({super.key});

  @override
  State<ProfileManagementScreen> createState() =>
      _ProfileManagementScreenState();
}

class _ProfileManagementScreenState extends State<ProfileManagementScreen> {
  final ProfileManagerService _profileManager = ProfileManagerService();
  final FileOperationsService _fileOperations = FileOperationsService();
  late ProfileManagementViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ProfileManagementViewModel(_profileManager);
    _viewModel.loadItems();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _loadProfiles() => _viewModel.loadItems();

  Future<void> _activateProfile(Profile profile) async {
    if (!mounted) return;
    
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(AppLocalizations.of(context)!.activatingProfile),
          ],
        ),
      ),
    );

    try {
      final demoApiService = context.read<DemoApiService>();
      final realApiService = context.read<OPNsenseApiService>();
      
      final result = await _profileManager.activateProfile(
        context: context,
        profile: profile,
        demoApiService: demoApiService,
        opnsenseApiService: realApiService,
      );
      
      if (!mounted) return;
      Navigator.of(context).pop(); // Close loading dialog
      
      if (result.success) {
        if (mounted) {
          await _loadProfiles();
        }
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          SnackBarHelper.showSuccess(context, l10n.activatedProfile(profile.name));
        }
      } else {
        if (mounted) {
          SnackBarHelper.showError(context, result.errorMessage ?? AppLocalizations.of(context)!.activationFailed);
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // Close loading dialog
        SnackBarHelper.showError(context, 'Error: $e');
      }
    }
  }

  void _showProfileDialog({Profile? profile}) {
    final l10n = AppLocalizations.of(context)!;
    final isEdit = profile != null;
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: profile?.name ?? '');
    final apiKeyController = TextEditingController(text: profile?.apiKey ?? '');
    final apiSecretController = TextEditingController(
      text: profile?.apiSecret ?? '',
    );
    List<ConnectionEndpoint> connections = profile?.connections ?? [
      const ConnectionEndpoint(host: '', port: 443, isActive: true),
    ];
    bool useHttps = profile?.useHttps ?? true;
    bool allowSelfSignedCerts = profile?.allowSelfSignedCerts ?? false;
    bool obscureSecret = true;
    DhcpServerType dhcpServerType = profile?.dhcpServerType ?? DhcpServerType.dnsmasq;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(isEdit ? l10n.editProfile : l10n.addProfile),
          content: SizedBox(
            width: 600,
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: l10n.profileNameLabel,
                      prefixIcon: const Icon(Icons.label),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.profileNameRequired;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  ConnectionEndpointsManager(
                    connections: connections,
                    onConnectionsChanged: (newConnections) {
                      setDialogState(() {
                        connections = newConnections;
                      });
                    },
                    enabled: true,
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: Text(l10n.useHttpsLabel),
                    value: useHttps,
                    onChanged: (value) {
                      setDialogState(() {
                        useHttps = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: Text(l10n.allowSelfSignedCertificates),
                    subtitle: Text(
                      l10n.selfSignedCertificatesWarning,
                    ),
                    value: allowSelfSignedCerts,
                    onChanged: useHttps
                        ? (value) {
                            setDialogState(() {
                              allowSelfSignedCerts = value;
                            });
                          }
                        : null,
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(Icons.dns),
                    title: Text(l10n.dhcpServerType),
                    subtitle: Text(dhcpServerType.getDisplayName(context)),
                    trailing: DropdownButton<DhcpServerType>(
                      value: dhcpServerType,
                      items: DhcpServerType.values.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type.getDisplayName(context)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            dhcpServerType = value;
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      dhcpServerType.getDescription(context),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: apiKeyController,
                    decoration: InputDecoration(
                      labelText: l10n.apiKeyLabel,
                      prefixIcon: const Icon(Icons.vpn_key),
                    ),
                    validator: (v) => Validators.validateApiKey(v, context),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: apiSecretController,
                    decoration: InputDecoration(
                      labelText: l10n.apiSecretLabel,
                      prefixIcon: const Icon(Icons.password),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscureSecret
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setDialogState(() {
                            obscureSecret = !obscureSecret;
                          });
                        },
                      ),
                    ),
                    obscureText: obscureSecret,
                    validator: (v) => Validators.validateApiSecret(v, context),
                  ),
                ],
              ),
            ),
          ),
        ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  // Validate connections
                  if (connections.isEmpty || connections.every((c) => c.host.trim().isEmpty)) {
                    SnackBarHelper.showError(context, l10n.pleaseAddConnectionEndpoint);
                    return;
                  }
                  
                  Navigator.of(context).pop();
                  await _saveProfile(
                    id: profile?.id,
                    name: nameController.text.trim(),
                    connections: connections,
                    apiKey: apiKeyController.text.trim(),
                    apiSecret: apiSecretController.text.trim(),
                    useHttps: useHttps,
                    allowSelfSignedCerts: allowSelfSignedCerts,
                    dhcpServerType: dhcpServerType,
                  );
                }
              },
              child: Text(isEdit ? l10n.save : l10n.add),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveProfile({
    String? id,
    required String name,
    required List<ConnectionEndpoint> connections,
    required String apiKey,
    required String apiSecret,
    required bool useHttps,
    required bool allowSelfSignedCerts,
    required DhcpServerType dhcpServerType,
  }) async {
    if (!mounted) return;
    
    // Get the API services from context
    final demoApiService = context.read<DemoApiService>();
    final opnsenseApiService = context.read<OPNsenseApiService>();
    
    final result = await _profileManager.saveProfile(
      id: id,
      name: name,
      connections: connections,
      apiKey: apiKey,
      apiSecret: apiSecret,
      useHttps: useHttps,
      allowSelfSignedCerts: allowSelfSignedCerts,
      dhcpServerType: dhcpServerType,
      context: context,
      demoApiService: demoApiService,
      opnsenseApiService: opnsenseApiService,
    );

    if (!mounted) return;
    
    if (result.success) {
      await _loadProfiles();
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        SnackBarHelper.showSuccess(context, id == null ? l10n.profileAdded : l10n.profileUpdated);
      }
    } else {
      if (mounted) {
        SnackBarHelper.showError(context, result.errorMessage ?? AppLocalizations.of(context)!.failedToSaveProfile);
      }
    }
  }

  Future<void> _exportSingleProfile(Profile profile) async {
    if (!mounted) return;
    
    final l10n = AppLocalizations.of(context)!;
    
    // Show confirmation dialog for including credentials
    final includeCredentials = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.exportProfilesTitle),
        content: Text(l10n.exportProfilesContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.withoutCredentials),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.warning,
            ),
            child: Text(l10n.includeCredentials),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(null),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
    
    if (!mounted) return;
    
    // User cancelled
    if (includeCredentials == null) return;
    
    final result = await _fileOperations.exportSingleProfile(
      profile: profile,
      includeCredentials: includeCredentials,
    );
    
    if (mounted) {
      if (result.success) {
        SnackBarHelper.showSuccess(context, '${l10n.exportSuccess}\nSaved to: ${result.filePath}', duration: const Duration(seconds: 8));
      } else {
        SnackBarHelper.showError(context, result.errorMessage ?? l10n.exportFailed, duration: const Duration(seconds: 5));
      }
    }
  }

  Future<void> _deleteProfile(Profile profile) async {
    if (!mounted) return;
    
    final l10n = AppLocalizations.of(context)!;
    
    final confirmed = await ConfirmationDialog.show(
      context: context,
      title: l10n.deleteProfile,
      message: l10n.deleteProfileConfirmation(profile.name),
      confirmText: l10n.delete,
      cancelText: l10n.cancel,
      isDestructive: true,
    );

    if (!mounted) return;
    
    if (confirmed == true) {
      final success = await _profileManager.deleteProfile(profile.id);
      
      if (!mounted) return;
      
      if (success) {
        await _loadProfiles();
        if (mounted) {
          SnackBarHelper.showSuccess(context, l10n.profileDeleted);
        }
      } else {
        if (mounted) {
          SnackBarHelper.showError(context, l10n.failedToDeleteProfile);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        if (_viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            Expanded(
              child: _viewModel.items.isEmpty
                  ? _buildEmptyState()
                  : _buildProfilesList(),
            ),
            _buildAddProfileButton(),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.dns_outlined,
            size: 64,
            color: AppColors.iconMuted,
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.noProfiles,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.addProfileToManageInstances,
            style: const TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildProfilesList() {
    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.standardPadding),
      itemCount: _viewModel.items.length,
      itemBuilder: (context, index) {
        final profile = _viewModel.items[index];
        final isActive = profile.id == _viewModel.activeProfileId;
        
        return ProfileCard(
          profile: profile,
          isActive: isActive,
          onTap: () => _activateProfile(profile),
          onActivate: () => _activateProfile(profile),
          onEdit: () => _showProfileDialog(profile: profile),
          onExport: () => _exportSingleProfile(profile),
          onDelete: () => _deleteProfile(profile),
        );
      },
    );
  }

  Widget _buildAddProfileButton() {
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      padding: const EdgeInsets.all(AppConstants.standardPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: ElevatedButton.icon(
          onPressed: () => _showProfileDialog(),
          icon: const Icon(Icons.add),
          label: Text(l10n.addProfile),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
          ),
        ),
      ),
    );
  }
}


