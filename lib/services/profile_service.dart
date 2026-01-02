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


import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/profile.dart';

/// Service for managing OPNsense connection profiles
class ProfileService {
  static final ProfileService _instance = ProfileService._internal();
  factory ProfileService() => _instance;
  ProfileService._internal();

  final _secureStorage = const FlutterSecureStorage();
  SharedPreferences? _prefs;

  static const String _keyProfiles = 'profiles';
  static const String _keyActiveProfileId = 'active_profile_id';

  /// Initialize shared preferences
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // ==================== Profile Management ====================

  /// Get all profiles
  Future<List<Profile>> getAllProfiles() async {
    await init();
    final profilesJson = _prefs!.getString(_keyProfiles);
    if (profilesJson == null) return [];

    try {
      final List<dynamic> profilesList = jsonDecode(profilesJson);
      return profilesList.map((json) => Profile.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  /// Save a profile
  Future<void> saveProfile(Profile profile) async {
    await init();
    final profiles = await getAllProfiles();
    
    // Check if profile already exists
    final existingIndex = profiles.indexWhere((p) => p.id == profile.id);
    if (existingIndex >= 0) {
      profiles[existingIndex] = profile;
    } else {
      profiles.add(profile);
    }

    // Save profiles list
    final profilesJson = jsonEncode(profiles.map((p) => p.toJson()).toList());
    await _prefs!.setString(_keyProfiles, profilesJson);

    // Save sensitive data (API keys) securely
    await _secureStorage.write(
      key: 'profile_${profile.id}_api_key',
      value: profile.apiKey,
    );
    await _secureStorage.write(
      key: 'profile_${profile.id}_api_secret',
      value: profile.apiSecret,
    );
  }

  /// Get a profile by ID
  Future<Profile?> getProfile(String id) async {
    final profiles = await getAllProfiles();
    try {
      return profiles.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Delete a profile
  Future<void> deleteProfile(String id) async {
    await init();
    final profiles = await getAllProfiles();
    profiles.removeWhere((p) => p.id == id);

    // Save updated profiles list
    final profilesJson = jsonEncode(profiles.map((p) => p.toJson()).toList());
    await _prefs!.setString(_keyProfiles, profilesJson);

    // Delete sensitive data
    await _secureStorage.delete(key: 'profile_${id}_api_key');
    await _secureStorage.delete(key: 'profile_${id}_api_secret');

    // If this was the active profile, clear it
    final activeId = await getActiveProfileId();
    if (activeId == id) {
      await clearActiveProfile();
    }
  }

  /// Update profile's last used timestamp
  Future<void> updateLastUsed(String id) async {
    final profile = await getProfile(id);
    if (profile == null) return;

    final updatedProfile = profile.copyWith(lastUsed: DateTime.now());
    await saveProfile(updatedProfile);
  }

  // ==================== Active Profile Management ====================

  /// Get active profile ID
  Future<String?> getActiveProfileId() async {
    await init();
    return _prefs!.getString(_keyActiveProfileId);
  }

  /// Set active profile
  Future<void> setActiveProfile(String id) async {
    await init();
    await _prefs!.setString(_keyActiveProfileId, id);
    await updateLastUsed(id);
  }

  /// Get active profile
  Future<Profile?> getActiveProfile() async {
    final activeId = await getActiveProfileId();
    if (activeId == null) return null;
    return await getProfile(activeId);
  }

  /// Clear active profile
  Future<void> clearActiveProfile() async {
    await init();
    await _prefs!.remove(_keyActiveProfileId);
  }

  // ==================== Profile Validation ====================

  /// Check if a profile name already exists
  Future<bool> profileNameExists(String name, {String? excludeId}) async {
    final profiles = await getAllProfiles();
    return profiles.any((p) => 
      p.name.toLowerCase() == name.toLowerCase() && 
      (excludeId == null || p.id != excludeId)
    );
  }

  /// Validate profile data
  String? validateProfile({
    required String name,
    required String host,
    required String port,
    required String apiKey,
    required String apiSecret,
    String? excludeId,
  }) {
    if (name.trim().isEmpty) {
      return 'Profile name is required';
    }
    if (host.trim().isEmpty) {
      return 'Host is required';
    }
    if (port.trim().isEmpty) {
      return 'Port is required';
    }
    final portNum = int.tryParse(port);
    if (portNum == null || portNum < 1 || portNum > 65535) {
      return 'Port must be between 1 and 65535';
    }
    if (apiKey.trim().isEmpty) {
      return 'API Key is required';
    }
    if (apiSecret.trim().isEmpty) {
      return 'API Secret is required';
    }
    return null;
  }

  // ==================== Migration from Old Storage ====================

  /// Migrate from old single-config storage to profile-based storage
  Future<void> migrateFromOldStorage() async {
    await init();
    
    // Check if migration is needed
    final profiles = await getAllProfiles();
    if (profiles.isNotEmpty) return; // Already migrated

    // Try to load old configuration
    final oldHost = await _secureStorage.read(key: 'host');
    if (oldHost == null) return; // No old config to migrate

    final oldPort = await _secureStorage.read(key: 'port');
    final oldApiKey = await _secureStorage.read(key: 'api_key');
    final oldApiSecret = await _secureStorage.read(key: 'api_secret');
    final oldUseHttps = await _secureStorage.read(key: 'use_https');

    if (oldApiKey != null && oldApiSecret != null) {
      // Create a default profile from old config
      final defaultProfile = Profile(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: 'Default',
        host: oldHost,
        port: int.tryParse(oldPort ?? '443') ?? 443,
        apiKey: oldApiKey,
        apiSecret: oldApiSecret,
        useHttps: oldUseHttps == 'true',
        createdAt: DateTime.now(),
        lastUsed: DateTime.now(),
      );

      await saveProfile(defaultProfile);
      await setActiveProfile(defaultProfile.id);

      // Clean up old storage
      await _secureStorage.delete(key: 'host');
      await _secureStorage.delete(key: 'port');
      await _secureStorage.delete(key: 'api_key');
      await _secureStorage.delete(key: 'api_secret');
      await _secureStorage.delete(key: 'use_https');
    }
  }

  // ==================== Utility Methods ====================

  /// Generate a unique profile ID
  String generateProfileId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  /// Get profile count
  Future<int> getProfileCount() async {
    final profiles = await getAllProfiles();
    return profiles.length;
  }

  /// Clear all profiles (use with caution)
  Future<void> clearAllProfiles() async {
    await init();
    final profiles = await getAllProfiles();
    
    // Delete all secure data
    for (final profile in profiles) {
      await _secureStorage.delete(key: 'profile_${profile.id}_api_key');
      await _secureStorage.delete(key: 'profile_${profile.id}_api_secret');
    }

    // Clear profiles list and active profile
    await _prefs!.remove(_keyProfiles);
    await clearActiveProfile();
  }
}

