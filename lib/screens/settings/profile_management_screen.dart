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
import '../../utils/validators.dart';
import '../../widgets/settings/profile_card.dart';
import '../../widgets/login/connection_endpoints_manager.dart';
import '../../l10n/app_localizations.dart';

/// Screen for managing OPNsense connection profiles
class ProfileManagementScreen extends StatefulWidget {
  const ProfileManagementScreen({super.key});

  @override
  State<ProfileManagementScreen> createState() => _ProfileManagementScreenState();
}

class _ProfileManagementScreenState extends State<ProfileManagementScreen> {
  final ProfileManagerService _profileManager = ProfileManagerService();
  final FileOperationsService _fileOperations = FileOperationsService();
  
  List<Profile> _profiles = [];
  String? _activeProfileId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfiles();
  }

  Future<void> _loadProfiles() async {
    setState(() {
      _isLoading = true;
    });

    final profiles = await _profileManager.loadProfiles();
    final activeId = await _profileManager.getActiveProfileId();

    if (mounted) {
      setState(() {
        _profiles = profiles;
        _activeProfileId = activeId;
        _isLoading = false;
      });
    }
  }

  Future<void> _activateProfile(Profile profile) async {
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
        await _loadProfiles();
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.activatedProfile(profile.name)),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result.errorMessage ?? 'Activation failed'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
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
                    title: const Text('Allow self-signed certificates'),
                    subtitle: const Text(
                      'WARNING: Disables TLS certificate validation for this profile. Only enable this if you trust the server and intentionally use a self-signed certificate.',
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
                    title: const Text('DHCP Server Type'),
                    subtitle: Text(dhcpServerType.displayName),
                    trailing: DropdownButton<DhcpServerType>(
                      value: dhcpServerType,
                      items: DhcpServerType.values.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type.displayName),
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
                      dhcpServerType.description,
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
                    validator: Validators.validateApiKey,
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
                    validator: Validators.validateApiSecret,
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please add at least one connection endpoint'),
                        backgroundColor: Colors.red,
                      ),
                    );
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
    final result = await _profileManager.saveProfile(
      id: id,
      name: name,
      connections: connections,
      apiKey: apiKey,
      apiSecret: apiSecret,
      useHttps: useHttps,
      allowSelfSignedCerts: allowSelfSignedCerts,
      dhcpServerType: dhcpServerType,
    );

    if (result.success) {
      await _loadProfiles();
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(id == null ? l10n.profileAdded : l10n.profileUpdated),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.errorMessage ?? 'Failed to save profile'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _exportSingleProfile(Profile profile) async {
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
              foregroundColor: Colors.orange,
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
    
    // User cancelled
    if (includeCredentials == null) return;
    
    final result = await _fileOperations.exportSingleProfile(
      profile: profile,
      includeCredentials: includeCredentials,
    );
    
    if (mounted) {
      if (result.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.exportSuccess}\nSaved to: ${result.filePath}'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 8),
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.errorMessage ?? 'Export failed'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  Future<void> _deleteProfile(Profile profile) async {
    final l10n = AppLocalizations.of(context)!;
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteProfile),
        content: Text(l10n.deleteProfileConfirmation(profile.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await _profileManager.deleteProfile(profile.id);
      
      if (success) {
        await _loadProfiles();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.profileDeleted),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Failed to delete profile'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Expanded(
          child: _profiles.isEmpty
              ? _buildEmptyState()
              : _buildProfilesList(),
        ),
        _buildAddProfileButton(),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.dns_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.noProfiles,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.addProfileToManageInstances,
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildProfilesList() {
    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.standardPadding),
      itemCount: _profiles.length,
      itemBuilder: (context, index) {
        final profile = _profiles[index];
        final isActive = profile.id == _activeProfileId;
        
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


