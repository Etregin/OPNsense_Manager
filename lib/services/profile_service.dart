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

import '../models/profile.dart';
import '../models/connection_endpoint.dart';
import 'profile/profile_storage_service.dart';
import 'profile/profile_export_import_service.dart';
import 'profile/profile_validation_service.dart';
import 'profile/profile_migration_service.dart';

/// Service for managing OPNsense connection profiles
/// Acts as a facade for specialized profile services
class ProfileService {
  static final ProfileService _instance = ProfileService._internal();
  factory ProfileService() => _instance;
  ProfileService._internal();

  /// Export format version constant
  static const String exportVersion = '1.0';

  late final ProfileStorageService _storageService;
  late final ProfileExportImportService _exportImportService;
  late final ProfileValidationService _validationService;
  late final ProfileMigrationService _migrationService;

  bool _initialized = false;

  /// Initialize all services
  Future<void> init() async {
    if (_initialized) return;

    _storageService = ProfileStorageService();
    await _storageService.init();

    _exportImportService = ProfileExportImportService(
      storageService: _storageService,
    );

    _validationService = ProfileValidationService(
      storageService: _storageService,
    );

    _migrationService = ProfileMigrationService(
      storageService: _storageService,
    );

    _initialized = true;
  }

  // ==================== Profile Management ====================

  /// Get all profiles
  Future<List<Profile>> getAllProfiles() async {
    await init();
    return await _storageService.getAllProfiles();
  }

  /// Save a profile
  Future<void> saveProfile(Profile profile) async {
    await init();
    await _storageService.saveProfile(profile);
  }

  /// Get a profile by ID
  Future<Profile?> getProfile(String id) async {
    await init();
    return await _storageService.getProfile(id);
  }

  /// Delete a profile
  Future<void> deleteProfile(String id) async {
    await init();
    await _storageService.deleteProfile(id);

    // If this was the active profile, clear it
    final activeId = await getActiveProfileId();
    if (activeId == id) {
      await clearActiveProfile();
    }
  }

  /// Update profile's last used timestamp
  Future<void> updateLastUsed(String id) async {
    await init();
    final profile = await getProfile(id);
    if (profile == null) return;

    final updatedProfile = profile.copyWith(lastUsed: DateTime.now());
    await saveProfile(updatedProfile);
  }

  // ==================== Active Profile Management ====================

  /// Get active profile ID
  Future<String?> getActiveProfileId() async {
    await init();
    return await _storageService.getActiveProfileId();
  }

  /// Set active profile
  Future<void> setActiveProfile(String id) async {
    await init();
    await _storageService.setActiveProfileId(id);
    await updateLastUsed(id);
  }

  /// Get active profile
  Future<Profile?> getActiveProfile() async {
    await init();
    final activeId = await getActiveProfileId();
    if (activeId == null) return null;
    return await getProfile(activeId);
  }

  /// Clear active profile
  Future<void> clearActiveProfile() async {
    await init();
    await _storageService.clearActiveProfile();
  }

  // ==================== Profile Validation ====================

  /// Check if a profile name already exists
  Future<bool> profileNameExists(String name, {String? excludeId}) async {
    await init();
    return await _validationService.profileNameExists(name,
        excludeId: excludeId);
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
    return _validationService.validateProfile(
      name: name,
      host: host,
      port: port,
      apiKey: apiKey,
      apiSecret: apiSecret,
      excludeId: excludeId,
    );
  }

  // ==================== Demo Profile ====================

  /// Create a demo profile
  Future<Profile> createDemoProfile() async {
    await init();
    const demoId = 'demo-profile';

    // Check if demo profile already exists
    final existingDemo = await getProfile(demoId);
    if (existingDemo != null) {
      return existingDemo;
    }

    final demoProfile = Profile(
      id: demoId,
      name: 'Demo Mode',
      connections: const [
        ConnectionEndpoint(
          host: 'demo.opnsense.local',
          port: 443,
          isActive: true,
        ),
      ],
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
    await _migrationService.migrateFromOldStorage();
  }

  // ==================== Utility Methods ====================

  /// Generate a unique profile ID
  String generateProfileId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  /// Get profile count
  Future<int> getProfileCount() async {
    await init();
    final profiles = await getAllProfiles();
    return profiles.length;
  }

  /// Clear all profiles (use with caution)
  Future<void> clearAllProfiles() async {
    await init();
    await _storageService.clearAllProfiles();
  }

  // ==================== Export/Import Methods ====================

  /// Export all profiles to JSON format
  Future<String> exportProfiles({bool includeCredentials = false}) async {
    await init();
    return await _exportImportService.exportProfiles(
      includeCredentials: includeCredentials,
    );
  }

  /// Export a single profile to JSON format
  Future<String> exportProfile(String profileId,
      {bool includeCredentials = false}) async {
    await init();
    return await _exportImportService.exportProfile(
      profileId,
      includeCredentials: includeCredentials,
    );
  }

  /// Import profiles from JSON format
  /// Returns a map with import results: success (int), failed (int), errors (List of String)
  Future<Map<String, dynamic>> importProfiles(String jsonString,
      {bool overwrite = false}) async {
    await init();
    return await _exportImportService.importProfiles(
      jsonString,
      overwrite: overwrite,
    );
  }

  /// Validate import file format
  /// Returns null if valid, error message if invalid
  String? validateImportFile(String jsonString) {
    return _exportImportService.validateImportFile(jsonString);
  }
}


