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
import '../../models/profile.dart';

/// Service for profile storage operations (CRUD)
class ProfileStorageService {
  final FlutterSecureStorage _secureStorage;
  SharedPreferences? _prefs;

  static const String _keyProfiles = 'profiles';
  static const String _keyActiveProfileId = 'active_profile_id';

  ProfileStorageService({
    FlutterSecureStorage? secureStorage,
  }) : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  /// Initialize shared preferences
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Get all profiles
  Future<List<Profile>> getAllProfiles() async {
    await init();
    final profilesJson = _prefs!.getString(_keyProfiles);
    if (profilesJson == null) return [];

    try {
      final List<dynamic> profilesList = jsonDecode(profilesJson);
      bool didSanitizeLegacyData = false;
      final profiles = <Profile>[];

      for (final item in profilesList) {
        final profileJson = Map<String, dynamic>.from(item as Map);
        final legacyApiKey = profileJson.remove('apiKey');
        final legacyApiSecret = profileJson.remove('apiSecret');
        final profileId = profileJson['id'] as String?;

        if (legacyApiKey != null || legacyApiSecret != null) {
          didSanitizeLegacyData = true;
        }

        if (profileId == null || profileId.isEmpty) {
          continue;
        }

        final storedApiKey = await _secureStorage.read(
          key: 'profile_${profileId}_api_key',
        );
        final storedApiSecret = await _secureStorage.read(
          key: 'profile_${profileId}_api_secret',
        );

        final apiKey = storedApiKey ?? (legacyApiKey as String?) ?? '';
        final apiSecret = storedApiSecret ?? (legacyApiSecret as String?) ?? '';

        if ((storedApiKey == null && legacyApiKey != null) ||
            (storedApiSecret == null && legacyApiSecret != null)) {
          await writeProfileCredentials(
            profileId,
            apiKey: apiKey,
            apiSecret: apiSecret,
          );
        }

        profiles.add(
          Profile.fromStorageJson(
            profileJson,
            apiKey: apiKey,
            apiSecret: apiSecret,
          ),
        );
      }

      if (didSanitizeLegacyData) {
        await persistProfilesMetadata(profiles);
      }

      return profiles;
    } catch (e) {
      return [];
    }
  }

  /// Save a profile
  Future<void> saveProfile(Profile profile) async {
    await init();
    final profiles = await getAllProfiles();

    final existingIndex = profiles.indexWhere((p) => p.id == profile.id);
    if (existingIndex >= 0) {
      profiles[existingIndex] = profile;
    } else {
      profiles.add(profile);
    }

    await persistProfilesMetadata(profiles);
    await writeProfileCredentials(
      profile.id,
      apiKey: profile.apiKey,
      apiSecret: profile.apiSecret,
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

    await persistProfilesMetadata(profiles);
    await _secureStorage.delete(key: 'profile_${id}_api_key');
    await _secureStorage.delete(key: 'profile_${id}_api_secret');
  }

  /// Get active profile ID
  Future<String?> getActiveProfileId() async {
    await init();
    return _prefs!.getString(_keyActiveProfileId);
  }

  /// Set active profile ID
  Future<void> setActiveProfileId(String id) async {
    await init();
    await _prefs!.setString(_keyActiveProfileId, id);
  }

  /// Clear active profile
  Future<void> clearActiveProfile() async {
    await init();
    await _prefs!.remove(_keyActiveProfileId);
  }

  /// Clear all profiles
  Future<void> clearAllProfiles() async {
    await init();
    final profiles = await getAllProfiles();

    for (final profile in profiles) {
      await _secureStorage.delete(key: 'profile_${profile.id}_api_key');
      await _secureStorage.delete(key: 'profile_${profile.id}_api_secret');
    }

    await _prefs!.remove(_keyProfiles);
    await clearActiveProfile();
  }

  /// Persist profiles metadata (without credentials)
  Future<void> persistProfilesMetadata(List<Profile> profiles) async {
    final profilesJson = jsonEncode(
      profiles.map((p) => p.toStorageJson()).toList(),
    );
    await _prefs!.setString(_keyProfiles, profilesJson);
  }

  /// Write profile credentials to secure storage
  Future<void> writeProfileCredentials(
    String profileId, {
    required String apiKey,
    required String apiSecret,
  }) async {
    await _secureStorage.write(
      key: 'profile_${profileId}_api_key',
      value: apiKey,
    );
    await _secureStorage.write(
      key: 'profile_${profileId}_api_secret',
      value: apiSecret,
    );
  }
}

// Made with Bob
