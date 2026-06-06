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
import '../profile_service.dart';
import '../demo_api_service.dart';
import '../opnsense_api_service.dart';
import '../../models/profile.dart';
import '../../models/connection_endpoint.dart';
import '../../models/opnsense_config.dart';
import '../../models/dhcp_server_type.dart';

/// Result of a profile activation operation
class ActivationResult {
  final bool success;
  final String? errorMessage;

  ActivationResult({
    required this.success,
    this.errorMessage,
  });
}

/// Result of a profile save operation
class SaveResult {
  final bool success;
  final String? errorMessage;
  final Profile? profile;

  SaveResult({
    required this.success,
    this.errorMessage,
    this.profile,
  });
}

/// Service for managing profile operations (CRUD, activation, validation)
class ProfileManagerService {
  final ProfileService _profileService;

  ProfileManagerService({ProfileService? profileService})
      : _profileService = profileService ?? ProfileService();

  /// Load all profiles
  Future<List<Profile>> loadProfiles() async {
    return await _profileService.getAllProfiles();
  }

  /// Get the active profile ID
  Future<String?> getActiveProfileId() async {
    return await _profileService.getActiveProfileId();
  }

  /// Activate a profile
  /// 
  /// This method handles the complete activation flow including:
  /// - Setting the profile as active
  /// - Updating API service providers
  /// - Testing the connection
  Future<ActivationResult> activateProfile({
    required BuildContext context,
    required Profile profile,
    required DemoApiService demoApiService,
    required OPNsenseApiService opnsenseApiService,
  }) async {
    try {
      // Set as active profile
      await _profileService.setActiveProfile(profile.id);

      // Update API service based on profile type
      if (profile.isDemo) {
        // Switch to demo mode
        demoApiService.setDemoMode(true);
      } else {
        // Switch to real API mode
        demoApiService.setDemoMode(false);
        
        // Update OPNsense API configuration
        final config = profile.toOPNsenseConfig();
        opnsenseApiService.init(config);

        // Test connection
        try {
          await opnsenseApiService.getSystemInfo();
        } catch (e) {
          return ActivationResult(
            success: false,
            errorMessage: 'Failed to connect to OPNsense: ${e.toString()}',
          );
        }
      }

      return ActivationResult(success: true);
    } catch (e) {
      return ActivationResult(
        success: false,
        errorMessage: 'Failed to activate profile: ${e.toString()}',
      );
    }
  }

  /// Save a profile (create or update)
  ///
  /// Validates the profile data and saves it to storage.
  /// If the saved profile is the active one, re-initializes API services.
  Future<SaveResult> saveProfile({
    String? id,
    required String name,
    required List<ConnectionEndpoint> connections,
    required String apiKey,
    required String apiSecret,
    required bool useHttps,
    required bool allowSelfSignedCerts,
    required DhcpServerType dhcpServerType,
    BuildContext? context,
    DemoApiService? demoApiService,
    OPNsenseApiService? opnsenseApiService,
  }) async {
    try {
      // Get active connection for validation
      final activeConnection = connections.firstWhere(
        (c) => c.isActive,
        orElse: () => connections.first,
      );

      // Validate profile data
      final validationError = _profileService.validateProfile(
        name: name,
        host: activeConnection.host,
        port: activeConnection.port.toString(),
        apiKey: apiKey,
        apiSecret: apiSecret,
        excludeId: id,
      );

      if (validationError != null) {
        return SaveResult(
          success: false,
          errorMessage: validationError,
        );
      }

      // Check for duplicate names
      final nameExists = await _profileService.profileNameExists(
        name,
        excludeId: id,
      );

      if (nameExists) {
        return SaveResult(
          success: false,
          errorMessage: 'A profile with this name already exists',
        );
      }

      // Create or update profile
      final profile = Profile(
        id: id ?? _profileService.generateProfileId(),
        name: name,
        connections: connections,
        apiKey: apiKey,
        apiSecret: apiSecret,
        useHttps: useHttps,
        allowSelfSignedCerts: allowSelfSignedCerts,
        dhcpServerType: dhcpServerType,
        createdAt: id == null ? DateTime.now() : DateTime.now(),
        lastUsed: DateTime.now(),
      );

      await _profileService.saveProfile(profile);

      // Check if this is the active profile and re-initialize if needed
      final activeProfileId = await _profileService.getActiveProfileId();
      if (profile.id == activeProfileId &&
          context != null &&
          demoApiService != null &&
          opnsenseApiService != null) {
        // Check if the widget is still mounted before using context
        if (!context.mounted) {
          return SaveResult(
            success: true,
            profile: profile,
          );
        }
        
        // Re-initialize by activating the updated profile
        final activationResult = await activateProfile(
          context: context,
          profile: profile,
          demoApiService: demoApiService,
          opnsenseApiService: opnsenseApiService,
        );
        
        // If activation fails, return the error
        if (!activationResult.success) {
          return SaveResult(
            success: false,
            errorMessage: 'Profile saved but failed to re-initialize: ${activationResult.errorMessage}',
          );
        }
      }

      return SaveResult(
        success: true,
        profile: profile,
      );
    } catch (e) {
      return SaveResult(
        success: false,
        errorMessage: 'Failed to save profile: ${e.toString()}',
      );
    }
  }

  /// Delete a profile
  /// 
  /// Returns true if successful, false otherwise
  Future<bool> deleteProfile(String profileId) async {
    try {
      await _profileService.deleteProfile(profileId);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get a profile by ID
  Future<Profile?> getProfile(String id) async {
    return await _profileService.getProfile(id);
  }

  /// Check if a profile name exists
  Future<bool> profileNameExists(String name, {String? excludeId}) async {
    return await _profileService.profileNameExists(name, excludeId: excludeId);
  }
}

/// Extension to convert Profile to OPNsenseConfig
extension ProfileExtension on Profile {
  OPNsenseConfig toOPNsenseConfig() {
    return OPNsenseConfig(
      host: host,
      port: port,
      apiKey: apiKey,
      apiSecret: apiSecret,
      useHttps: useHttps,
      allowSelfSignedCerts: allowSelfSignedCerts,
      dhcpServerType: dhcpServerType,
    );
  }
}


