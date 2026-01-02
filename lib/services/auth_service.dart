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


import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service for handling app authentication (PIN and biometric)
class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final LocalAuthentication _localAuth = LocalAuthentication();
  final _secureStorage = const FlutterSecureStorage();
  SharedPreferences? _prefs;

  static const String _keyPinEnabled = 'pin_enabled';
  static const String _keyPinCode = 'pin_code';
  static const String _keyBiometricEnabled = 'biometric_enabled';
  static const String _keyLastAuthTime = 'last_auth_time';
  static const String _keyLockTimeout = 'lock_timeout_minutes';

  /// Initialize shared preferences
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // ==================== PIN Authentication ====================

  /// Check if PIN is enabled
  Future<bool> isPinEnabled() async {
    await init();
    return _prefs!.getBool(_keyPinEnabled) ?? false;
  }

  /// Set PIN code
  Future<void> setPinCode(String pin) async {
    await init();
    await _secureStorage.write(key: _keyPinCode, value: pin);
    await _prefs!.setBool(_keyPinEnabled, true);
  }

  /// Verify PIN code
  Future<bool> verifyPin(String pin) async {
    await init();
    final storedPin = await _secureStorage.read(key: _keyPinCode);
    return storedPin == pin;
  }

  /// Disable PIN
  Future<void> disablePin() async {
    await init();
    await _secureStorage.delete(key: _keyPinCode);
    await _prefs!.setBool(_keyPinEnabled, false);
  }

  /// Check if PIN exists
  Future<bool> hasPinCode() async {
    final pin = await _secureStorage.read(key: _keyPinCode);
    return pin != null && pin.isNotEmpty;
  }

  // ==================== Biometric Authentication ====================

  /// Check if biometric is enabled
  Future<bool> isBiometricEnabled() async {
    await init();
    return _prefs!.getBool(_keyBiometricEnabled) ?? false;
  }

  /// Enable/disable biometric authentication
  Future<void> setBiometricEnabled(bool enabled) async {
    await init();
    await _prefs!.setBool(_keyBiometricEnabled, enabled);
  }

  /// Check if device supports biometric authentication
  Future<bool> canCheckBiometrics() async {
    try {
      return await _localAuth.canCheckBiometrics;
    } on PlatformException {
      return false;
    }
  }

  /// Check if biometric is available on device
  Future<bool> isBiometricAvailable() async {
    try {
      final canCheck = await _localAuth.canCheckBiometrics;
      if (!canCheck) return false;

      final availableBiometrics = await _localAuth.getAvailableBiometrics();
      return availableBiometrics.isNotEmpty;
    } on PlatformException {
      return false;
    }
  }

  /// Get available biometric types
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } on PlatformException {
      return [];
    }
  }

  /// Authenticate with biometrics
  Future<bool> authenticateWithBiometrics({
    String localizedReason = 'Please authenticate to access the app',
  }) async {
    try {
      final canCheck = await canCheckBiometrics();
      if (!canCheck) return false;

      return await _localAuth.authenticate(
        localizedReason: localizedReason,
      );
    } on PlatformException {
      return false;
    }
  }

  // ==================== Session Management ====================

  /// Record successful authentication
  Future<void> recordAuthentication() async {
    await init();
    await _prefs!.setInt(_keyLastAuthTime, DateTime.now().millisecondsSinceEpoch);
  }

  /// Get last authentication time
  Future<DateTime?> getLastAuthTime() async {
    await init();
    final timestamp = _prefs!.getInt(_keyLastAuthTime);
    if (timestamp == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  /// Get lock timeout in minutes
  Future<int> getLockTimeout() async {
    await init();
    return _prefs!.getInt(_keyLockTimeout) ?? 5; // Default 5 minutes
  }

  /// Set lock timeout in minutes
  Future<void> setLockTimeout(int minutes) async {
    await init();
    await _prefs!.setInt(_keyLockTimeout, minutes);
  }

  /// Check if authentication is required (e.g., after app restart or timeout)
  Future<bool> isAuthenticationRequired() async {
    final pinEnabled = await isPinEnabled();
    final biometricEnabled = await isBiometricEnabled();
    
    if (!pinEnabled && !biometricEnabled) return false;

    final lastAuth = await getLastAuthTime();
    if (lastAuth == null) return true;

    // Require re-authentication after configured timeout
    final timeoutMinutes = await getLockTimeout();
    final now = DateTime.now();
    final difference = now.difference(lastAuth);
    return difference.inMinutes >= timeoutMinutes;
  }

  /// Clear authentication session
  Future<void> clearSession() async {
    await init();
    await _prefs!.remove(_keyLastAuthTime);
  }

  // ==================== Complete Authentication Flow ====================

  /// Perform authentication (biometric first, then PIN fallback)
  Future<bool> authenticate({
    String localizedReason = 'Please authenticate to access the app',
    bool allowPinFallback = true,
  }) async {
    final biometricEnabled = await isBiometricEnabled();
    final pinEnabled = await isPinEnabled();

    // Try biometric first if enabled
    if (biometricEnabled) {
      final biometricAvailable = await isBiometricAvailable();
      if (biometricAvailable) {
        final authenticated = await authenticateWithBiometrics(
          localizedReason: localizedReason,
        );
        if (authenticated) {
          await recordAuthentication();
          return true;
        }
      }
    }

    // Fall back to PIN if enabled and allowed
    if (pinEnabled && allowPinFallback) {
      // PIN verification will be handled by UI
      return false; // Return false to indicate PIN UI should be shown
    }

    return !pinEnabled && !biometricEnabled; // Allow access if no auth is set
  }

  /// Get biometric type name for display
  String getBiometricTypeName(BiometricType type) {
    switch (type) {
      case BiometricType.face:
        return 'Face ID';
      case BiometricType.fingerprint:
        return 'Fingerprint';
      case BiometricType.iris:
        return 'Iris';
      case BiometricType.strong:
        return 'Strong Biometric';
      case BiometricType.weak:
        return 'Weak Biometric';
    }
  }
}

