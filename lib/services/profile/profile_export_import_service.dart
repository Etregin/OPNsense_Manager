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
import '../../models/profile.dart';
import 'profile_storage_service.dart';

/// Service for profile export and import operations
class ProfileExportImportService {
  final ProfileStorageService _storageService;

  /// Export format version constant
  static const String exportVersion = '1.0';

  ProfileExportImportService({required ProfileStorageService storageService})
      : _storageService = storageService;

  /// Export all profiles to JSON format
  Future<String> exportProfiles({bool includeCredentials = false}) async {
    final profiles = await _storageService.getAllProfiles();

    if (includeCredentials) {
      _logCredentialExport(profiles.length);
    }

    final exportData = {
      'version': exportVersion,
      'exportDate': DateTime.now().toIso8601String(),
      'includesCredentials': includeCredentials,
      'profiles': profiles
          .map((profile) => _sanitizeProfileForExport(profile, includeCredentials))
          .toList(),
    };

    if (includeCredentials) {
      exportData['SECURITY_WARNING'] =
          'This file contains sensitive API credentials (apiKey and apiSecret) in plain text. '
          'Store this file securely, do not share it, and delete it when no longer needed. '
          'Anyone with access to this file can control your OPNsense firewall.';
    }

    return jsonEncode(exportData);
  }

  /// Export a single profile to JSON format
  Future<String> exportProfile(String profileId,
      {bool includeCredentials = false}) async {
    final profile = await _storageService.getProfile(profileId);
    if (profile == null) {
      throw Exception('Profile not found');
    }

    if (includeCredentials) {
      _logSingleProfileExport(profile);
    }

    final exportData = {
      'version': exportVersion,
      'exportDate': DateTime.now().toIso8601String(),
      'includesCredentials': includeCredentials,
      'profiles': [_sanitizeProfileForExport(profile, includeCredentials)],
    };

    if (includeCredentials) {
      exportData['SECURITY_WARNING'] =
          'This file contains sensitive API credentials (apiKey and apiSecret) in plain text. '
          'Store this file securely, do not share it, and delete it when no longer needed. '
          'Anyone with access to this file can control your OPNsense firewall.';
    }

    return jsonEncode(exportData);
  }

  /// Import profiles from JSON format
  /// Returns a map with import results: success (int), failed (int), errors (List of String)
  Future<Map<String, dynamic>> importProfiles(String jsonString,
      {bool overwrite = false}) async {
    int successCount = 0;
    int failedCount = 0;
    List<String> errors = [];

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

      if (!importData.containsKey('version') ||
          !importData.containsKey('profiles')) {
        throw Exception('Invalid import file format');
      }

      final List<dynamic> profilesList = importData['profiles'];

      if (profilesList.isEmpty) {
        return {
          'success': 0,
          'failed': 0,
          'errors': ['No profiles found in import file'],
        };
      }

      // Validate credential completeness
      if (importData['includesCredentials'] == true) {
        for (var profileJson in profilesList) {
          if ((profileJson['apiKey']?.isEmpty ?? true) ||
              (profileJson['apiSecret']?.isEmpty ?? true)) {
            errors.add(
                'Profile ${profileJson['name']} has incomplete credentials');
            failedCount++;
            continue;
          }
        }
      }

      final existingProfiles = await _storageService.getAllProfiles();

      for (var profileJson in profilesList) {
        try {
          final profile = Profile.fromJson(profileJson);

          final existingProfile = existingProfiles.firstWhere(
            (p) => p.id == profile.id,
            orElse: () => Profile(
              id: '',
              name: '',
              connections: const [],
              apiKey: '',
              apiSecret: '',
              useHttps: true,
              createdAt: DateTime.now(),
            ),
          );

          if (existingProfile.id.isNotEmpty && !overwrite) {
            // Generate new ID for duplicate
            final newProfile = profile.copyWith(
              id: _generateProfileId(),
              name: '${profile.name} (Imported)',
              createdAt: DateTime.now(),
            );
            await _storageService.saveProfile(newProfile);
          } else {
            await _storageService.saveProfile(profile);
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

      final Set<String> profileNamesInFile = {};

      for (var profileJson in profilesList) {
        if (!profileJson.containsKey('id') ||
            !profileJson.containsKey('name') ||
            !profileJson.containsKey('host') ||
            !profileJson.containsKey('apiKey') ||
            !profileJson.containsKey('apiSecret')) {
          return 'Invalid profile data structure';
        }

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

  /// Sanitize profile data for export
  Map<String, dynamic> _sanitizeProfileForExport(
      Profile profile, bool includeCredentials) {
    final profileJson = profile.toJson();

    if (!includeCredentials) {
      profileJson['apiKey'] = '';
      profileJson['apiSecret'] = '';
    }

    return profileJson;
  }

  /// Log credential export for audit
  void _logCredentialExport(int profileCount) {
    final now = DateTime.now();
    final timezone = now.timeZoneName;
    final timestamp = now.toIso8601String();
    developer.log(
      'SECURITY: Exporting $profileCount profile(s) WITH credentials | '
      'Timestamp: $timestamp ($timezone) | '
      'Platform: ${Platform.operatingSystem}',
      name: 'ProfileExportImportService',
      level: 900,
    );
  }

  /// Log single profile export for audit
  void _logSingleProfileExport(Profile profile) {
    final now = DateTime.now();
    final timezone = now.timeZoneName;
    final timestamp = now.toIso8601String();
    developer.log(
      'SECURITY: Exporting profile "${profile.name}" (${profile.id}) WITH credentials | '
      'Timestamp: $timestamp ($timezone) | '
      'Platform: ${Platform.operatingSystem}',
      name: 'ProfileExportImportService',
      level: 900,
    );
  }

  /// Generate a unique profile ID
  String _generateProfileId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}


