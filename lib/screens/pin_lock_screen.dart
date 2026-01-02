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
import '../services/auth_service.dart';
import '../utils/constants.dart';

/// PIN lock screen for app authentication
class PinLockScreen extends StatefulWidget {
  final Function(BuildContext) onAuthenticated;
  final bool canUseBiometric;

  const PinLockScreen({
    super.key,
    required this.onAuthenticated,
    this.canUseBiometric = true,
  });

  @override
  State<PinLockScreen> createState() => _PinLockScreenState();
}

class _PinLockScreenState extends State<PinLockScreen> {
  final _pinController = TextEditingController();
  final _authService = AuthService();
  bool _isAuthenticating = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    if (widget.canUseBiometric) {
      _tryBiometricAuth();
    }
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _tryBiometricAuth() async {
    final biometricEnabled = await _authService.isBiometricEnabled();
    if (!biometricEnabled) return;

    final authenticated = await _authService.authenticateWithBiometrics(
      localizedReason: 'Authenticate to unlock OPNsense Manager',
    );

    if (authenticated) {
      if (mounted) {
        await _authService.recordAuthentication();
        if (mounted) {
          widget.onAuthenticated(context);
        }
      }
    }
  }

  Future<void> _verifyPin() async {
    if (_pinController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter your PIN';
      });
      return;
    }

    setState(() {
      _isAuthenticating = true;
      _errorMessage = '';
    });

    final isValid = await _authService.verifyPin(_pinController.text);

    if (isValid) {
      if (mounted) {
        await _authService.recordAuthentication();
        if (mounted) {
          widget.onAuthenticated(context);
        }
      }
    } else {
      setState(() {
        _isAuthenticating = false;
        _errorMessage = 'Incorrect PIN';
        _pinController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? Theme.of(context).scaffoldBackgroundColor : Theme.of(context).primaryColor;
    final textColor = isDark ? Theme.of(context).textTheme.bodyLarge?.color ?? Colors.white : Colors.white;
    final iconBackgroundColor = isDark ? Theme.of(context).cardColor : Colors.white;
    final iconColor = Theme.of(context).primaryColor;
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [
                    backgroundColor,
                    backgroundColor,
                  ]
                : [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor.withValues(alpha: 0.7),
                  ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.standardPadding * 2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App Icon
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: iconBackgroundColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.lock,
                      size: 64,
                      color: iconColor,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Title
                  Text(
                    'Enter PIN',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Unlock OPNsense Manager',
                    style: TextStyle(
                      fontSize: 16,
                      color: textColor.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 48),

                  // PIN Input
                  Container(
                    constraints: const BoxConstraints(maxWidth: 300),
                    child: TextField(
                      controller: _pinController,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        letterSpacing: 16,
                        color: textColor,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: isDark
                            ? Theme.of(context).cardColor
                            : Colors.white.withValues(alpha: 0.2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        hintText: '••••••',
                        hintStyle: TextStyle(
                          color: textColor.withValues(alpha: 0.5),
                          letterSpacing: 16,
                        ),
                        counterText: '',
                        errorText: _errorMessage.isEmpty ? null : _errorMessage,
                        errorStyle: TextStyle(
                          color: isDark ? Colors.redAccent : Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onSubmitted: (_) => _verifyPin(),
                      enabled: !_isAuthenticating,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Verify Button
                  SizedBox(
                    width: 200,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isAuthenticating ? null : _verifyPin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark ? Theme.of(context).primaryColor : Colors.white,
                        foregroundColor: isDark ? Colors.white : Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        elevation: 8,
                      ),
                      child: _isAuthenticating
                          ? SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: isDark ? Colors.white : Theme.of(context).primaryColor,
                              ),
                            )
                          : const Text(
                              'Unlock',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),

                  // Biometric Button
                  if (widget.canUseBiometric) ...[
                    const SizedBox(height: 24),
                    TextButton.icon(
                      onPressed: _tryBiometricAuth,
                      icon: Icon(
                        Icons.fingerprint,
                        color: textColor,
                        size: 32,
                      ),
                      label: Text(
                        'Use Biometric',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

