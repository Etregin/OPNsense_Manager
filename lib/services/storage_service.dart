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


import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/opnsense_config.dart';
import '../utils/constants.dart';

/// Service for managing local and secure storage
class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  final _secureStorage = const FlutterSecureStorage();
  SharedPreferences? _prefs;

  /// Initialize shared preferences
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // ==================== Secure Storage (Credentials) ====================

  /// Save OPNsense configuration securely
  Future<void> saveConfig(OPNsenseConfig config) async {
    await _secureStorage.write(key: AppConstants.keyHost, value: config.host);
    await _secureStorage.write(
        key: AppConstants.keyPort, value: config.port.toString());
    await _secureStorage.write(
        key: AppConstants.keyApiKey, value: config.apiKey);
    await _secureStorage.write(
        key: AppConstants.keyApiSecret, value: config.apiSecret);
    await _secureStorage.write(
        key: AppConstants.keyUseHttps, value: config.useHttps.toString());
  }

  /// Load OPNsense configuration
  Future<OPNsenseConfig?> loadConfig() async {
    try {
      final host = await _secureStorage.read(key: AppConstants.keyHost);
      final portStr = await _secureStorage.read(key: AppConstants.keyPort);
      final apiKey = await _secureStorage.read(key: AppConstants.keyApiKey);
      final apiSecret =
          await _secureStorage.read(key: AppConstants.keyApiSecret);
      final useHttpsStr =
          await _secureStorage.read(key: AppConstants.keyUseHttps);

      if (host == null ||
          portStr == null ||
          apiKey == null ||
          apiSecret == null) {
        return null;
      }

      final port = int.tryParse(portStr) ?? AppConstants.defaultPort;
      final useHttps = useHttpsStr?.toLowerCase() == 'true';

      return OPNsenseConfig(
        host: host,
        port: port,
        apiKey: apiKey,
        apiSecret: apiSecret,
        useHttps: useHttps,
      );
    } catch (e) {
      return null;
    }
  }

  /// Check if configuration exists
  Future<bool> hasConfig() async {
    final host = await _secureStorage.read(key: AppConstants.keyHost);
    return host != null;
  }

  /// Clear all stored credentials
  Future<void> clearConfig() async {
    await _secureStorage.delete(key: AppConstants.keyHost);
    await _secureStorage.delete(key: AppConstants.keyPort);
    await _secureStorage.delete(key: AppConstants.keyApiKey);
    await _secureStorage.delete(key: AppConstants.keyApiSecret);
    await _secureStorage.delete(key: AppConstants.keyUseHttps);
  }

  // ==================== General Storage ====================

  /// Save a string value
  Future<void> saveString(String key, String value) async {
    await init();
    await _prefs!.setString(key, value);
  }

  /// Load a string value
  Future<String?> loadString(String key) async {
    await init();
    return _prefs!.getString(key);
  }

  /// Save a boolean value
  Future<void> saveBool(String key, bool value) async {
    await init();
    await _prefs!.setBool(key, value);
  }

  /// Load a boolean value
  Future<bool?> loadBool(String key) async {
    await init();
    return _prefs!.getBool(key);
  }

  /// Save an integer value
  Future<void> saveInt(String key, int value) async {
    await init();
    await _prefs!.setInt(key, value);
  }

  /// Load an integer value
  Future<int?> loadInt(String key) async {
    await init();
    return _prefs!.getInt(key);
  }

  /// Remove a value
  Future<void> remove(String key) async {
    await init();
    await _prefs!.remove(key);
  }

  /// Clear all local storage (except secure storage)
  Future<void> clearAll() async {
    await init();
    await _prefs!.clear();
  }
}

