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
import 'package:local_auth/local_auth.dart';
import '../models/system_info.dart';
import '../models/profile.dart';
import '../models/opnsense_config.dart';
import '../services/opnsense_api_service.dart';
import '../services/storage_service.dart';
import '../services/auth_service.dart';
import '../services/profile_service.dart';
import '../utils/constants.dart';
import '../utils/validators.dart';
import '../widgets/app_drawer.dart';

/// Enhanced Settings screen with tabs for General and Profiles
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  SystemInfo? _systemInfo;
  bool _isDarkMode = false;
  
  // Auth settings
  bool _pinEnabled = false;
  bool _biometricEnabled = false;
  bool _biometricAvailable = false;
  List<BiometricType> _availableBiometrics = [];
  int _lockTimeout = 5; // Default 5 minutes
  
  // Profile management
  List<Profile> _profiles = [];
  String? _activeProfileId;
  bool _isLoadingProfiles = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadSystemInfo();
    _loadThemeMode();
    _loadAuthSettings();
    _loadProfiles();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadSystemInfo() async {
    try {
      final apiService = context.read<OPNsenseApiService>();
      final systemInfo = await apiService.getSystemInfo();
      if (mounted) {
        setState(() {
          _systemInfo = systemInfo;
        });
      }
    } catch (e) {
      // Silently fail - system info is optional
    }
  }

  Future<void> _loadThemeMode() async {
    final isDark = await StorageService().loadBool('dark_mode') ?? false;
    if (mounted) {
      setState(() {
        _isDarkMode = isDark;
      });
    }
  }

  Future<void> _loadAuthSettings() async {
    final authService = AuthService();
    final pinEnabled = await authService.isPinEnabled();
    final biometricEnabled = await authService.isBiometricEnabled();
    final biometricAvailable = await authService.isBiometricAvailable();
    final availableBiometrics = await authService.getAvailableBiometrics();
    final lockTimeout = await authService.getLockTimeout();

    if (mounted) {
      setState(() {
        _pinEnabled = pinEnabled;
        _biometricEnabled = biometricEnabled;
        _biometricAvailable = biometricAvailable;
        _availableBiometrics = availableBiometrics;
        _lockTimeout = lockTimeout;
      });
    }
  }

  Future<void> _loadProfiles() async {
    setState(() {
      _isLoadingProfiles = true;
    });

    final profileService = ProfileService();
    final profiles = await profileService.getAllProfiles();
    final activeId = await profileService.getActiveProfileId();

    if (mounted) {
      setState(() {
        _profiles = profiles;
        _activeProfileId = activeId;
        _isLoadingProfiles = false;
      });
    }
  }

  void _toggleDarkMode(bool value) {
    setState(() {
      _isDarkMode = value;
    });
    final toggleTheme = context.read<Function(bool)>();
    toggleTheme(value);
  }

  Future<void> _togglePinLock(bool value) async {
    if (value) {
      // Show PIN setup dialog
      await _showPinSetupDialog();
    } else {
      // Disable PIN
      final authService = AuthService();
      await authService.disablePin();
      setState(() {
        _pinEnabled = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PIN lock disabled')),
        );
      }
    }
  }

  Future<void> _showPinSetupDialog() async {
    final pinController = TextEditingController();
    final confirmPinController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set PIN'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: pinController,
                decoration: const InputDecoration(
                  labelText: 'Enter PIN (4-6 digits)',
                  prefixIcon: Icon(Icons.lock),
                ),
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 6,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a PIN';
                  }
                  if (value.length < 4) {
                    return 'PIN must be at least 4 digits';
                  }
                  if (!RegExp(r'^\d+$').hasMatch(value)) {
                    return 'PIN must contain only numbers';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: confirmPinController,
                decoration: const InputDecoration(
                  labelText: 'Confirm PIN',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 6,
                validator: (value) {
                  if (value != pinController.text) {
                    return 'PINs do not match';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.of(context).pop(true);
              }
            },
            child: const Text('Set PIN'),
          ),
        ],
      ),
    );

    if (result == true && mounted) {
      final authService = AuthService();
      await authService.setPinCode(pinController.text);
      setState(() {
        _pinEnabled = true;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PIN lock enabled')),
        );
      }
    }
  }

  Future<void> _showChangePinDialog() async {
    final currentPinController = TextEditingController();
    final newPinController = TextEditingController();
    final confirmPinController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change PIN'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: currentPinController,
                decoration: const InputDecoration(
                  labelText: 'Current PIN',
                  prefixIcon: Icon(Icons.lock_open),
                ),
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 6,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your current PIN';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: newPinController,
                decoration: const InputDecoration(
                  labelText: 'New PIN (4-6 digits)',
                  prefixIcon: Icon(Icons.lock),
                ),
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 6,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a new PIN';
                  }
                  if (value.length < 4) {
                    return 'PIN must be at least 4 digits';
                  }
                  if (!RegExp(r'^\d+$').hasMatch(value)) {
                    return 'PIN must contain only numbers';
                  }
                  if (value == currentPinController.text) {
                    return 'New PIN must be different';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: confirmPinController,
                decoration: const InputDecoration(
                  labelText: 'Confirm New PIN',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 6,
                validator: (value) {
                  if (value != newPinController.text) {
                    return 'PINs do not match';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.of(context).pop(true);
              }
            },
            child: const Text('Change PIN'),
          ),
        ],
      ),
    );

    if (result == true && mounted) {
      final authService = AuthService();
      
      // Verify current PIN first
      final isCurrentValid = await authService.verifyPin(currentPinController.text);
      
      if (!isCurrentValid) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Current PIN is incorrect'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }
      
      // Set new PIN
      await authService.setPinCode(newPinController.text);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('PIN changed successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  Future<void> _toggleBiometric(bool value) async {
    final authService = AuthService();
    
    if (value) {
      // Test biometric authentication first
      final authenticated = await authService.authenticateWithBiometrics(
        localizedReason: 'Authenticate to enable biometric lock',
      );
      
      if (authenticated) {
        await authService.setBiometricEnabled(true);
        setState(() {
          _biometricEnabled = true;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Biometric lock enabled')),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Biometric authentication failed'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else {
      await authService.setBiometricEnabled(false);
      setState(() {
        _biometricEnabled = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Biometric lock disabled')),
        );
      }
    }
  }

  String _getBiometricName() {
    if (_availableBiometrics.contains(BiometricType.face)) {
      return 'Face ID';
    } else if (_availableBiometrics.contains(BiometricType.fingerprint)) {
      return 'Fingerprint';
    }
    return 'Biometric';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'General', icon: Icon(Icons.settings)),
            Tab(text: 'Profiles', icon: Icon(Icons.dns)),
          ],
        ),
      ),
      drawer: AppDrawer(
        currentRoute: 'settings',
        systemInfo: _systemInfo,
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildGeneralTab(),
          _buildProfilesTab(),
        ],
      ),
    );
  }

  Widget _buildGeneralTab() {
    return ListView(
      padding: const EdgeInsets.all(AppConstants.standardPadding),
      children: [
        _buildAppearanceCard(),
        const SizedBox(height: 16),
        _buildSecurityCard(),
      ],
    );
  }

  Widget _buildAppearanceCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.standardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Appearance',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Dark Mode'),
              subtitle: const Text('Use dark theme'),
              secondary: Icon(
                _isDarkMode ? Icons.dark_mode : Icons.light_mode,
                color: Theme.of(context).primaryColor,
              ),
              value: _isDarkMode,
              onChanged: _toggleDarkMode,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.standardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Security',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('PIN Lock'),
              subtitle: const Text('Require PIN to unlock app'),
              secondary: Icon(
                Icons.pin,
                color: Theme.of(context).primaryColor,
              ),
              value: _pinEnabled,
              onChanged: _togglePinLock,
            ),
            if (_pinEnabled) ...[
              const Divider(),
              ListTile(
                leading: Icon(
                  Icons.edit,
                  color: Theme.of(context).primaryColor,
                ),
                title: const Text('Change PIN'),
                subtitle: const Text('Update your PIN code'),
                trailing: const Icon(Icons.chevron_right),
                onTap: _showChangePinDialog,
              ),
            ],
            if (_biometricAvailable) ...[
              const Divider(),
              SwitchListTile(
                title: Text('${_getBiometricName()} Lock'),
                subtitle: Text('Use ${_getBiometricName()} to unlock app'),
                secondary: Icon(
                  Icons.fingerprint,
                  color: Theme.of(context).primaryColor,
                ),
                value: _biometricEnabled,
                onChanged: _toggleBiometric,
              ),
            ],
            if (_pinEnabled || _biometricEnabled) ...[
              const Divider(),
              ListTile(
                leading: Icon(
                  Icons.timer,
                  color: Theme.of(context).primaryColor,
                ),
                title: const Text('Lock Timeout'),
                subtitle: Text('Lock after $_lockTimeout ${_lockTimeout == 1 ? 'minute' : 'minutes'} of inactivity'),
                trailing: DropdownButton<int>(
                  value: _lockTimeout,
                  items: const [
                    DropdownMenuItem(value: 1, child: Text('1 min')),
                    DropdownMenuItem(value: 2, child: Text('2 min')),
                    DropdownMenuItem(value: 5, child: Text('5 min')),
                    DropdownMenuItem(value: 10, child: Text('10 min')),
                    DropdownMenuItem(value: 15, child: Text('15 min')),
                    DropdownMenuItem(value: 30, child: Text('30 min')),
                    DropdownMenuItem(value: 60, child: Text('1 hour')),
                  ],
                  onChanged: (value) async {
                    if (value != null) {
                      setState(() {
                        _lockTimeout = value;
                      });
                      final authService = AuthService();
                      await authService.setLockTimeout(value);
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Lock timeout set to $value ${value == 1 ? 'minute' : 'minutes'}'),
                          ),
                        );
                      }
                    }
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProfilesTab() {
    if (_isLoadingProfiles) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Expanded(
          child: _profiles.isEmpty
              ? _buildEmptyProfilesState()
              : _buildProfilesList(),
        ),
        _buildAddProfileButton(),
      ],
    );
  }

  Widget _buildEmptyProfilesState() {
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
            'No Profiles',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add a profile to manage OPNsense instances',
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
        
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: isActive 
                  ? Theme.of(context).primaryColor 
                  : Colors.grey[400],
              child: Icon(
                isActive ? Icons.check : Icons.dns,
                color: Colors.white,
              ),
            ),
            title: Text(
              profile.name,
              style: TextStyle(
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            subtitle: Text(
              '${profile.useHttps ? 'https' : 'http'}://${profile.host}:${profile.port}',
              style: const TextStyle(fontSize: 12),
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'activate':
                    _activateProfile(profile);
                    break;
                  case 'edit':
                    _showProfileDialog(profile: profile);
                    break;
                  case 'delete':
                    _deleteProfile(profile);
                    break;
                }
              },
              itemBuilder: (context) => [
                if (!isActive)
                  const PopupMenuItem(
                    value: 'activate',
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, size: 20),
                        SizedBox(width: 12),
                        Text('Activate'),
                      ],
                    ),
                  ),
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 20),
                      SizedBox(width: 12),
                      Text('Edit'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 20, color: Colors.red),
                      SizedBox(width: 12),
                      Text('Delete', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
            onTap: () => _activateProfile(profile),
          ),
        );
      },
    );
  }

  Widget _buildAddProfileButton() {
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
          label: const Text('Add Profile'),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
          ),
        ),
      ),
    );
  }

  Future<void> _activateProfile(Profile profile) async {
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Activating profile...'),
          ],
        ),
      ),
    );

    try {
      final profileService = ProfileService();
      await profileService.setActiveProfile(profile.id);
      
      if (!mounted) return;
      
      // Update API service with new profile
      final apiService = context.read<OPNsenseApiService>();
      apiService.init(profile.toOPNsenseConfig());
      
      // Test connection
      final isConnected = await apiService.testConnection();
      
      if (!mounted) return;
      Navigator.of(context).pop(); // Close loading dialog
      
      if (isConnected) {
        await _loadProfiles();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Activated profile: ${profile.name}'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Connection test failed'),
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
    final isEdit = profile != null;
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: profile?.name ?? '');
    final hostController = TextEditingController(text: profile?.host ?? '');
    final portController = TextEditingController(
      text: profile?.port.toString() ?? '443',
    );
    final apiKeyController = TextEditingController(text: profile?.apiKey ?? '');
    final apiSecretController = TextEditingController(
      text: profile?.apiSecret ?? '',
    );
    bool useHttps = profile?.useHttps ?? true;
    bool obscureSecret = true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(isEdit ? 'Edit Profile' : 'Add Profile'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Profile Name',
                      prefixIcon: Icon(Icons.label),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Profile name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: hostController,
                    decoration: const InputDecoration(
                      labelText: 'Host/IP Address',
                      prefixIcon: Icon(Icons.dns),
                    ),
                    validator: Validators.validateHost,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: portController,
                    decoration: const InputDecoration(
                      labelText: 'Port',
                      prefixIcon: Icon(Icons.settings_ethernet),
                    ),
                    keyboardType: TextInputType.number,
                    validator: Validators.validatePort,
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Use HTTPS'),
                    value: useHttps,
                    onChanged: (value) {
                      setDialogState(() {
                        useHttps = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: apiKeyController,
                    decoration: const InputDecoration(
                      labelText: 'API Key',
                      prefixIcon: Icon(Icons.vpn_key),
                    ),
                    validator: Validators.validateApiKey,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: apiSecretController,
                    decoration: InputDecoration(
                      labelText: 'API Secret',
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
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  Navigator.of(context).pop();
                  await _saveProfile(
                    id: profile?.id,
                    name: nameController.text.trim(),
                    host: hostController.text.trim(),
                    port: int.parse(portController.text.trim()),
                    apiKey: apiKeyController.text.trim(),
                    apiSecret: apiSecretController.text.trim(),
                    useHttps: useHttps,
                  );
                }
              },
              child: Text(isEdit ? 'Save' : 'Add'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveProfile({
    String? id,
    required String name,
    required String host,
    required int port,
    required String apiKey,
    required String apiSecret,
    required bool useHttps,
  }) async {
    final profileService = ProfileService();
    
    final profile = Profile(
      id: id ?? profileService.generateProfileId(),
      name: name,
      host: host,
      port: port,
      apiKey: apiKey,
      apiSecret: apiSecret,
      useHttps: useHttps,
      createdAt: DateTime.now(),
    );

    await profileService.saveProfile(profile);
    await _loadProfiles();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(id == null ? 'Profile added' : 'Profile updated'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _deleteProfile(Profile profile) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Profile'),
        content: Text('Are you sure you want to delete "${profile.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final profileService = ProfileService();
      await profileService.deleteProfile(profile.id);
      await _loadProfiles();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile deleted'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }
}

// Extension to convert Profile to OPNsenseConfig
extension ProfileExtension on Profile {
  OPNsenseConfig toOPNsenseConfig() {
    return OPNsenseConfig(
      host: host,
      port: port,
      apiKey: apiKey,
      apiSecret: apiSecret,
      useHttps: useHttps,
    );
  }
}

