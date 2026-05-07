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
import 'dart:developer' as developer;
import 'dart:io' show Platform;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/profile.dart';

/// Service for managing OPNsense connection profiles
class ProfileService {
  static final ProfileService _instance = ProfileService._internal();
  factory ProfileService() => _instance;
  ProfileService._internal();

  /// Export format version constant
  static const String exportVersion = '1.0';

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
          await _writeProfileCredentials(
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
        await _persistProfilesMetadata(profiles);
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

    // Check if profile already exists
    final existingIndex = profiles.indexWhere((p) => p.id == profile.id);
    if (existingIndex >= 0) {
      profiles[existingIndex] = profile;
    } else {
      profiles.add(profile);
    }

    await _persistProfilesMetadata(profiles);
    await _writeProfileCredentials(
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

    // Save updated profiles list
    await _persistProfilesMetadata(profiles);

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

  // ==================== Demo Profile ====================

  /// Create a demo profile
  Future<Profile> createDemoProfile() async {
    const demoId = 'demo-profile';
    
    // Check if demo profile already exists
    final existingDemo = await getProfile(demoId);
    if (existingDemo != null) {
      return existingDemo;
    }

    final demoProfile = Profile(
      id: demoId,
      name: 'Demo Mode',
      host: 'demo.opnsense.local',
      port: 443,
      apiKey: 'demo-key',
      apiSecret: 'demo-secret',
      useHttps: true,
      isDemo: true,
      createdAt: DateTime.now(),
      lastUsed: DateTime.now(),
    );

    await saveProfile(demoProfile);
    return demoProfile;
  }

  /// Check if a profile is a demo profile
  bool isDemoProfile(Profile profile) {
    return profile.isDemo;
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

  // ==================== Export/Import Methods ====================

  /// Export all profiles to JSON format
  ///
  /// [includeCredentials] - If true, API keys and secrets will be included in export.
  /// WARNING: Exported files with credentials contain sensitive data in plain text.
  /// Store such files securely and avoid sharing them.
  /// Returns a JSON string containing all profiles
  Future<String> exportProfiles({bool includeCredentials = false}) async {
    final profiles = await getAllProfiles();
    
    // Log credential export for audit purposes
    if (includeCredentials) {
      final now = DateTime.now();
      final timezone = now.timeZoneName;
      final timestamp = now.toIso8601String();
      developer.log(
        'SECURITY: Exporting ${profiles.length} profile(s) WITH credentials | '
        'Timestamp: $timestamp ($timezone) | '
        'Platform: ${Platform.operatingSystem}',
        name: 'ProfileService',
        level: 900, // WARNING level
      );
    }
    
    // Create export data structure
    final exportData = {
      'version': exportVersion,
      'exportDate': DateTime.now().toIso8601String(),
      'includesCredentials': includeCredentials,
      'profiles': profiles.map((profile) => _sanitizeProfileForExport(profile, includeCredentials)).toList(),
    };
    
    // Add prominent security warning when credentials are included
    if (includeCredentials) {
      exportData['SECURITY_WARNING'] = 'This file contains sensitive API credentials (apiKey and apiSecret) in plain text. '
          'Store this file securely, do not share it, and delete it when no longer needed. '
          'Anyone with access to this file can control your OPNsense firewall.';
    }
    
    return jsonEncode(exportData);
  }

  /// Export a single profile to JSON format
  ///
  /// WARNING: By default, exported files contain sensitive API credentials in plain text.
  /// Store exported files securely and avoid sharing them.
  ///
  /// [includeCredentials] - If false, API keys and secrets will be excluded from export
  /// Returns a JSON string containing the profile
  Future<String> exportProfile(String profileId, {bool includeCredentials = true}) async {
    final profile = await getProfile(profileId);
    if (profile == null) {
      throw Exception('Profile not found');
    }
    
    // Log credential export for audit purposes
    if (includeCredentials) {
      final now = DateTime.now();
      final timezone = now.timeZoneName;
      final timestamp = now.toIso8601String();
      developer.log(
        'SECURITY: Exporting profile "${profile.name}" (${profile.id}) WITH credentials | '
        'Timestamp: $timestamp ($timezone) | '
        'Platform: ${Platform.operatingSystem}',
        name: 'ProfileService',
        level: 900, // WARNING level
      );
    }
    
    // Create export data structure
    final exportData = {
      'version': exportVersion,
      'exportDate': DateTime.now().toIso8601String(),
      'includesCredentials': includeCredentials,
      'profiles': [_sanitizeProfileForExport(profile, includeCredentials)],
    };
    
    // Add prominent security warning when credentials are included
    if (includeCredentials) {
      exportData['SECURITY_WARNING'] = 'This file contains sensitive API credentials (apiKey and apiSecret) in plain text. '
          'Store this file securely, do not share it, and delete it when no longer needed. '
          'Anyone with access to this file can control your OPNsense firewall.';
    }
    
    return jsonEncode(exportData);
  }

  /// Sanitize profile data for export based on credential inclusion preference
  Map<String, dynamic> _sanitizeProfileForExport(Profile profile, bool includeCredentials) {
    final profileJson = profile.toJson();
    
    if (!includeCredentials) {
      // Remove sensitive credentials from export
      profileJson['apiKey'] = '';
      profileJson['apiSecret'] = '';
    }
    
    return profileJson;
  }

  /// Import profiles from JSON format
  /// Returns a map with import results: {success: count, failed: count, errors: []}
  Future<Map<String, dynamic>> importProfiles(String jsonString, {bool overwrite = false}) async {
    int successCount = 0;
    int failedCount = 0;
    List<String> errors = [];
    
    // Validate import file before attempting to parse
    final validationError = validateImportFile(jsonString);
    if (validationError != null) {
      return {
        'success': 0,
        'failed': 0,
        'errors': [validationError],
      };
    }
    
    try {
      final Map<String, dynamic> importData = jsonDecode(jsonString);
      
      // Validate import data structure
      if (!importData.containsKey('version') || !importData.containsKey('profiles')) {
        throw Exception('Invalid import file format');
      }
      
      final List<dynamic> profilesList = importData['profiles'];
      
      // Check for empty profiles list
      if (profilesList.isEmpty) {
        return {
          'success': 0,
          'failed': 0,
          'errors': ['No profiles found in import file'],
        };
      }
      
      // Validate credential completeness when credentials are included
      if (importData['includesCredentials'] == true) {
        for (var profileJson in profilesList) {
          if ((profileJson['apiKey']?.isEmpty ?? true) ||
              (profileJson['apiSecret']?.isEmpty ?? true)) {
            errors.add('Profile ${profileJson['name']} has incomplete credentials');
            failedCount++;
            continue;
          }
        }
      }
      
      final existingProfiles = await getAllProfiles();
      
      for (var profileJson in profilesList) {
        try {
          final profile = Profile.fromJson(profileJson);
          
          // Check if profile already exists
          final existingProfile = existingProfiles.firstWhere(
            (p) => p.id == profile.id,
            orElse: () => Profile(
              id: '',
              name: '',
              host: '',
              port: 0,
              apiKey: '',
              apiSecret: '',
              useHttps: true,
              createdAt: DateTime.now(),
            ),
          );
          
          if (existingProfile.id.isNotEmpty && !overwrite) {
            // Profile exists and overwrite is false, generate new ID
            final newProfile = profile.copyWith(
              id: generateProfileId(),
              name: '${profile.name} (Imported)',
              createdAt: DateTime.now(),
            );
            await saveProfile(newProfile);
          } else {
            // Save profile (either new or overwriting existing)
            await saveProfile(profile);
          }
          
          successCount++;
        } catch (e) {
          failedCount++;
          errors.add('Failed to import profile: ${e.toString()}');
        }
      }
      
      return {
        'success': successCount,
        'failed': failedCount,
        'errors': errors,
      };
    } catch (e) {
      return {
        'success': 0,
        'failed': 0,
        'errors': ['Failed to parse import file: ${e.toString()}'],
      };
    }
  }

  /// Validate import file format
  /// Returns null if valid, error message if invalid
  String? validateImportFile(String jsonString) {
    try {
      final Map<String, dynamic> importData = jsonDecode(jsonString);
      
      if (!importData.containsKey('version')) {
        return 'Missing version field';
      }
      
      if (!importData.containsKey('profiles')) {
        return 'Missing profiles field';
      }
      
      final List<dynamic> profilesList = importData['profiles'];
      if (profilesList.isEmpty) {
        return 'No profiles found in import file';
      }
      
      // Track profile names to check for duplicates within the import file
      final Set<String> profileNamesInFile = {};
      
      // Validate each profile has required fields
      for (var profileJson in profilesList) {
        if (!profileJson.containsKey('id') ||
            !profileJson.containsKey('name') ||
            !profileJson.containsKey('host') ||
            !profileJson.containsKey('apiKey') ||
            !profileJson.containsKey('apiSecret')) {
          return 'Invalid profile data structure';
        }
        
        // Check for duplicate names within the import file
        final String profileName = profileJson['name'];
        if (profileNamesInFile.contains(profileName)) {
          return 'Duplicate profile name found in import file: "$profileName"';
        }
        profileNamesInFile.add(profileName);
      }
      
      return null;
    } catch (e) {
      return 'Invalid JSON format: ${e.toString()}';
    }
  }

  Future<void> _persistProfilesMetadata(List<Profile> profiles) async {
    final profilesJson = jsonEncode(
      profiles.map((p) => p.toStorageJson()).toList(),
    );
    await _prefs!.setString(_keyProfiles, profilesJson);
  }

  Future<void> _writeProfileCredentials(
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

