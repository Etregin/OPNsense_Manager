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
import 'package:local_auth/local_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import '../models/system_info.dart';
import '../models/profile.dart';
import '../models/opnsense_config.dart';
import '../services/demo_api_service.dart';
import '../services/opnsense_api_service.dart';
import '../services/storage_service.dart';
import '../services/auth_service.dart';
import '../services/profile_service.dart';
import '../utils/constants.dart';
import '../utils/formatters.dart';
import '../utils/validators.dart';
import '../widgets/app_drawer.dart';
import '../l10n/app_localizations.dart';

/// Enhanced Settings screen with tabs for General and Profiles
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with SingleTickerProviderStateMixin {
  // Platform-specific error codes for file operations
  // Unix/Linux/macOS error codes
  static const int _errNoSpaceUnix = 28;      // ENOSPC - No space left on device
  static const int _errAccessDeniedUnix = 13; // EACCES - Permission denied
  static const int _errReadOnlyUnix = 30;     // EROFS - Read-only file system
  
  // Windows error codes
  static const int _errAccessDeniedWindows = 5; // ERROR_ACCESS_DENIED
  
  late TabController _tabController;
  SystemInfo? _systemInfo;
  String _themeMode = 'system'; // 'system', 'light', or 'dark'
  String? _locale; // null means system default
  
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
    _loadLocale();
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
      final demoApiService = context.read<DemoApiService>();
      final systemInfo = await demoApiService.getSystemInfo();
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
    final themeMode = await StorageService().loadString('theme_mode') ?? 'system';
    if (mounted) {
      setState(() {
        _themeMode = themeMode;
      });
    }
  }

  Future<void> _loadLocale() async {
    final locale = await StorageService().loadString('locale');
    if (mounted) {
      setState(() {
        _locale = locale;
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

  void _updateThemeMode(String? value) {
    if (value == null) return;
    setState(() {
      _themeMode = value;
    });
    final updateTheme = context.read<Function(String)>();
    updateTheme(value);
  }

  void _updateLocale(String? value) {
    setState(() {
      _locale = value;
    });
    final updateLocale = context.read<Function(String?)>();
    updateLocale(value);
  }

  Future<void> _togglePinLock(bool value) async {
    if (value) {
      // Show PIN setup dialog
      await _showPinSetupDialog();
    } else {
      // Disable PIN
      final authService = AuthService();
      await authService.disablePin();
      
      // Also disable biometric if it was enabled
      if (_biometricEnabled) {
        await authService.setBiometricEnabled(false);
      }
      
      setState(() {
        _pinEnabled = false;
        _biometricEnabled = false;
      });
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.pinLockDisabled)),
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
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(l10n.setPin),
          content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: pinController,
                decoration: InputDecoration(
                  labelText: l10n.enterPinLabel,
                  prefixIcon: const Icon(Icons.lock),
                ),
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 6,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.fieldRequired;
                  }
                  if (value.length < 4) {
                    return l10n.pinTooShort;
                  }
                  if (!RegExp(r'^\d+$').hasMatch(value)) {
                    return l10n.invalidPIN;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: confirmPinController,
                decoration: InputDecoration(
                  labelText: l10n.confirmPin,
                  prefixIcon: const Icon(Icons.lock_outline),
                ),
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 6,
                validator: (value) {
                  if (value != pinController.text) {
                    return l10n.pinMismatch;
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
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.of(context).pop(true);
                }
              },
              child: Text(l10n.setPin),
            ),
          ],
        );
      },
    );

    if (result == true && mounted) {
      final authService = AuthService();
      await authService.setPinCode(pinController.text);
      setState(() {
        _pinEnabled = true;
      });
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.pinLockEnabled)),
        );
      }
    }
  }

  Future<void> _showChangePinDialog() async {
    final currentPinController = TextEditingController();
    final newPinController = TextEditingController();
    final confirmPinController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final l10n = AppLocalizations.of(context)!;

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.changePinTitle),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: currentPinController,
                decoration: InputDecoration(
                  labelText: l10n.currentPin,
                  prefixIcon: const Icon(Icons.lock_open),
                ),
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 6,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.pleaseEnterCurrentPin;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: newPinController,
                decoration: InputDecoration(
                  labelText: l10n.newPin,
                  prefixIcon: const Icon(Icons.lock),
                ),
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 6,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.pleaseEnterNewPin;
                  }
                  if (value.length < 4) {
                    return l10n.pinTooShort;
                  }
                  if (!RegExp(r'^\d+$').hasMatch(value)) {
                    return l10n.pinMustContainOnlyNumbers;
                  }
                  if (value == currentPinController.text) {
                    return l10n.newPinMustBeDifferent;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: confirmPinController,
                decoration: InputDecoration(
                  labelText: l10n.confirmNewPin,
                  prefixIcon: const Icon(Icons.lock_outline),
                ),
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 6,
                validator: (value) {
                  if (value != newPinController.text) {
                    return l10n.pinMismatch;
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.of(dialogContext).pop(true);
              }
            },
            child: Text(l10n.changePinTitle),
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
            SnackBar(
              content: Text(l10n.currentPinIncorrect),
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
          SnackBar(
            content: Text(l10n.pinChangedSuccessfully),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  Future<void> _toggleBiometric(bool value) async {
    final authService = AuthService();
    
    // Check if PIN is enabled first
    if (!_pinEnabled) {
      if (mounted) {
        final l10n2 = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n2.enablePinLockFirst),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }
    
    if (value) {
      // Double-check biometric availability
      final isAvailable = await authService.isBiometricAvailable();
      if (!isAvailable) {
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.biometricNotAvailable),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

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
          final l10n = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.biometricLockEnabled),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.biometricAuthFailed),
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
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.biometricLockDisabled)),
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
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: l10n.general, icon: const Icon(Icons.settings)),
            Tab(text: l10n.profiles, icon: const Icon(Icons.dns)),
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
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.standardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.appearance,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Icon(
                _themeMode == 'dark'
                    ? Icons.dark_mode
                    : _themeMode == 'light'
                        ? Icons.light_mode
                        : Icons.brightness_auto,
                color: Theme.of(context).primaryColor,
              ),
              title: Text(l10n.theme),
              subtitle: Text(
                _themeMode == 'system'
                    ? l10n.systemDefault
                    : _themeMode == 'light'
                        ? l10n.lightMode
                        : l10n.darkMode,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: SizedBox(
                width: 140,
                child: DropdownButton<String>(
                  value: _themeMode,
                  underline: const SizedBox(),
                  isExpanded: true,
                  items: [
                    DropdownMenuItem(
                      value: 'system',
                      child: Text(
                        l10n.systemDefault,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'light',
                      child: Text(
                        l10n.lightMode,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'dark',
                      child: Text(
                        l10n.darkMode,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                  onChanged: _updateThemeMode,
                ),
              ),
            ),
            const Divider(),
            ListTile(
              leading: Icon(
                Icons.language,
                color: Theme.of(context).primaryColor,
              ),
              title: Text(l10n.language),
              subtitle: Text(
                _locale == null
                    ? l10n.systemDefault
                    : (AppConstants.supportedLanguages[_locale] ?? _locale!),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: SizedBox(
                width: 140,
                child: DropdownButton<String?>(
                  value: _locale,
                  underline: const SizedBox(),
                  isExpanded: true,
                  items: [
                    DropdownMenuItem(
                      value: null,
                      child: Text(
                        l10n.systemDefault,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    ...AppConstants.supportedLanguages.entries.map(
                      (entry) => DropdownMenuItem(
                        value: entry.key,
                        child: Text(
                          entry.value,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                  onChanged: _updateLocale,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityCard() {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.standardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.security,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: Text(l10n.pinLockTitle),
              subtitle: Text(l10n.requirePinToUnlock),
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
                title: Text(l10n.changePinTitle),
                subtitle: Text(l10n.updatePinCode),
                trailing: const Icon(Icons.chevron_right),
                onTap: _showChangePinDialog,
              ),
            ],
            if (_biometricAvailable) ...[
              const Divider(),
              SwitchListTile(
                title: Text(l10n.biometricLockTitle(_getBiometricName())),
                subtitle: Text(_pinEnabled
                    ? l10n.useBiometricToUnlock(_getBiometricName())
                    : l10n.enablePinLockFirstBiometric),
                secondary: Icon(
                  Icons.fingerprint,
                  color: Theme.of(context).primaryColor,
                ),
                value: _biometricEnabled,
                onChanged: _pinEnabled ? _toggleBiometric : null,
              ),
            ],
            if (_pinEnabled || _biometricEnabled) ...[
              const Divider(),
              ListTile(
                leading: Icon(
                  Icons.timer,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text(l10n.lockTimeoutLabel),
                subtitle: Text(l10n.lockAfterMinutes(_lockTimeout)),
                trailing: DropdownButton<int>(
                  value: _lockTimeout,
                  items: [
                    DropdownMenuItem(value: 1, child: Text(l10n.oneMin)),
                    DropdownMenuItem(value: 2, child: Text(l10n.twoMin)),
                    DropdownMenuItem(value: 5, child: Text(l10n.fiveMin)),
                    DropdownMenuItem(value: 10, child: Text(l10n.tenMin)),
                    DropdownMenuItem(value: 15, child: Text(l10n.fifteenMin)),
                    DropdownMenuItem(value: 30, child: Text(l10n.thirtyMin)),
                    DropdownMenuItem(value: 60, child: Text(l10n.oneHour)),
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
                            content: Text(l10n.lockTimeoutSet(value)),
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
                  PopupMenuItem(
                    value: 'activate',
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, size: 20),
                        const SizedBox(width: 12),
                        Text(AppLocalizations.of(context)!.activate),
                      ],
                    ),
                  ),
                PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      const Icon(Icons.edit, size: 20),
                      const SizedBox(width: 12),
                      Text(AppLocalizations.of(context)!.edit),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      const Icon(Icons.delete, size: 20, color: Colors.red),
                      const SizedBox(width: 12),
                      Text(AppLocalizations.of(context)!.delete, style: const TextStyle(color: Colors.red)),
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Import/Export buttons row
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _importProfiles,
                    icon: const Icon(Icons.upload_file, size: 20),
                    label: Text(AppLocalizations.of(context)!.import),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 44),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _profiles.isEmpty ? null : _exportProfiles,
                    icon: const Icon(Icons.download, size: 20),
                    label: Text(AppLocalizations.of(context)!.export),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 44),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Add Profile button
            ElevatedButton.icon(
              onPressed: () => _showProfileDialog(),
              icon: const Icon(Icons.add),
              label: Text(AppLocalizations.of(context)!.addProfile),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ],
        ),
      ),
    );
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
      final profileService = ProfileService();
      await profileService.setActiveProfile(profile.id);
      
      if (!mounted) return;
      
      // Update API service with new profile
      final demoApiService = context.read<DemoApiService>();
      final realApiService = context.read<OPNsenseApiService>();
      
      // Check if this is a demo profile
      if (profile.isDemo) {
        demoApiService.setDemoMode(true);
      } else {
        demoApiService.setDemoMode(false);
        realApiService.init(profile.toOPNsenseConfig());
      }
      
      // Test connection
      final isConnected = await demoApiService.testConnection();
      
      if (!mounted) return;
      Navigator.of(context).pop(); // Close loading dialog
      
      if (isConnected) {
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
          final l10n = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.connectionTestFailed),
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
          title: Text(isEdit ? l10n.editProfile : l10n.addProfile),
          content: SingleChildScrollView(
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
                  TextFormField(
                    controller: hostController,
                    decoration: InputDecoration(
                      labelText: l10n.hostIpAddressLabel,
                      prefixIcon: const Icon(Icons.dns),
                    ),
                    validator: Validators.validateHost,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: portController,
                    decoration: InputDecoration(
                      labelText: l10n.portLabel,
                      prefixIcon: const Icon(Icons.settings_ethernet),
                    ),
                    keyboardType: TextInputType.number,
                    validator: Validators.validatePort,
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
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.cancel),
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
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(id == null ? l10n.profileAdded : l10n.profileUpdated),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  // ==================== Export/Import Methods ====================

  /// Export all profiles to a JSON file
  Future<void> _exportProfiles() async {
    try {
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
      
      final profileService = ProfileService();
      final jsonString = await profileService.exportProfiles(
        includeCredentials: includeCredentials,
      );
      
      // Create filename with timestamp
      final timestamp = Formatters.formatTimestampForFilename(DateTime.now());
      final suggestedName = 'opnsense_profiles_$timestamp.json';
      
      // Let user choose directory to save the file
      final directoryPath = await FilePicker.platform.getDirectoryPath(
        dialogTitle: 'Choose Export Location',
      );
      
      if (directoryPath == null) {
        // User cancelled the directory picker
        return;
      }
      
      // Create full file path
      final filePath = path.join(directoryPath, suggestedName);
      
      // Write file to chosen location
      final file = File(filePath);
      try {
        await file.writeAsString(jsonString, flush: true);
      } on FileSystemException catch (e) {
        // Handle specific file system errors using osError type
        String errorMessage;
        final osError = e.osError;
        
        // Check for specific error types using osError errorCode
        // ENOSPC (No space left on device) - typically 28 on Unix-like systems
        // EACCES (Permission denied) - typically 13 on Unix-like systems
        // EROFS (Read-only file system) - typically 30 on Unix-like systems
        if (osError != null) {
          final errorCode = osError.errorCode;
          // Check for platform-specific error codes
          if (errorCode == _errNoSpaceUnix) {
            errorMessage = 'Export failed: Insufficient disk space';
          } else if ((Platform.isWindows && errorCode == _errAccessDeniedWindows) ||
                     (!Platform.isWindows && errorCode == _errAccessDeniedUnix)) {
            errorMessage = 'Export failed: Permission denied. Please choose a different location';
          } else if (errorCode == _errReadOnlyUnix && !Platform.isWindows) {
            errorMessage = 'Export failed: Cannot write to read-only location';
          } else {
            errorMessage = 'Export failed: ${e.message}';
          }
        } else {
          errorMessage = 'Export failed: ${e.message}';
        }
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 5),
            ),
          );
        }
        return;
      }
      
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.exportSuccess),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
      }
    } catch (e) {
      _showErrorSnackBar('Export failed: ${e.toString()}');
    }
  }

  /// Show error SnackBar with consistent styling
  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Import profiles from a JSON file
  Future<void> _importProfiles() async {
    try {
      // Pick a file
      final pickerResult = await FilePicker.platform.pickFiles(
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
          final l10n = AppLocalizations.of(context)!;
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
      final profileService = ProfileService();
      final validationError = profileService.validateImportFile(jsonString);
      
      if (validationError != null) {
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
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
          final l10n = AppLocalizations.of(context)!;
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
      
      // Reload profiles
      await _loadProfiles();
      
      // Show result
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
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
      }
    } catch (e) {
      _showErrorSnackBar('Import failed: ${e.toString()}');
    }
  }

  Future<void> _deleteProfile(Profile profile) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteProfileTitle),
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
      final profileService = ProfileService();
      await profileService.deleteProfile(profile.id);
      await _loadProfiles();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.profileDeleted),
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

