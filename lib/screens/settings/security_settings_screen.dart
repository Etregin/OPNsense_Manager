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
import 'package:local_auth/local_auth.dart';
import '../../services/auth_service.dart';
import '../../utils/constants.dart';
import '../../utils/snackbar_helper.dart';
import '../../widgets/settings/settings_section.dart';
import '../../l10n/app_localizations.dart';

/// Screen for security settings (PIN, biometric authentication)
class SecuritySettingsScreen extends StatefulWidget {
  const SecuritySettingsScreen({super.key});

  @override
  State<SecuritySettingsScreen> createState() => _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends State<SecuritySettingsScreen> {
  bool _pinEnabled = false;
  bool _biometricEnabled = false;
  bool _biometricAvailable = false;
  List<BiometricType> _availableBiometrics = [];
  int _lockTimeout = 5; // Default 5 minutes

  @override
  void initState() {
    super.initState();
    _loadAuthSettings();
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
        SnackBarHelper.showInfo(context, l10n.pinLockDisabled);
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
                    return l10n.invalidPin;
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
        SnackBarHelper.showInfo(context, l10n.pinLockEnabled);
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
        title: Text(l10n.changePin),
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
            child: Text(l10n.changePin),
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
          SnackBarHelper.showError(context, l10n.currentPinIncorrect);
        }
        return;
      }
      
      // Set new PIN
      await authService.setPinCode(newPinController.text);
      
      if (mounted) {
        SnackBarHelper.showSuccess(context, l10n.pinChangedSuccessfully);
      }
    }
  }

  Future<void> _toggleBiometric(bool value) async {
    final authService = AuthService();
    
    // Check if PIN is enabled first
    if (!_pinEnabled) {
      if (mounted) {
        final l10n2 = AppLocalizations.of(context)!;
        SnackBarHelper.showWarning(context, l10n2.enablePinLockFirst);
      }
      return;
    }
    
    if (value) {
      // Double-check biometric availability
      final isAvailable = await authService.isBiometricAvailable();
      if (!isAvailable) {
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          SnackBarHelper.showError(context, l10n.biometricNotAvailable);
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
          SnackBarHelper.showSuccess(context, l10n.biometricLockEnabled);
        }
      } else {
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          SnackBarHelper.showError(context, l10n.biometricAuthFailed);
        }
      }
    } else {
      await authService.setBiometricEnabled(false);
      setState(() {
        _biometricEnabled = false;
      });
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        SnackBarHelper.showInfo(context, l10n.biometricLockDisabled);
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
    
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppConstants.standardPadding),
      children: [
        SettingsSection(
          title: l10n.security,
          icon: Icons.security,
          children: [
            SwitchListTile(
              title: Text(l10n.pinLock),
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
                title: Text(l10n.changePin),
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
                      final messenger = ScaffoldMessenger.of(context);
                      final message = l10n.lockTimeoutSet(value);
                      final authService = AuthService();
                      await authService.setLockTimeout(value);
                      if (mounted) {
                        messenger.showSnackBar(SnackBar(content: Text(message)));
                      }
                    }
                  },
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}


