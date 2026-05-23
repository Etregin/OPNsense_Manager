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
import '../../models/profile.dart';
import '../../models/connection_endpoint.dart';
import 'profile_storage_service.dart';

/// Service for migrating from old storage format to profile-based storage
class ProfileMigrationService {
  final ProfileStorageService _storageService;
  final FlutterSecureStorage _secureStorage;

  ProfileMigrationService({
    required ProfileStorageService storageService,
    FlutterSecureStorage? secureStorage,
  })  : _storageService = storageService,
        _secureStorage = secureStorage ?? const FlutterSecureStorage();

  /// Migrate from old single-config storage to profile-based storage
  Future<void> migrateFromOldStorage() async {
    // Check if migration is needed
    final profiles = await _storageService.getAllProfiles();
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
        connections: [
          ConnectionEndpoint(
            host: oldHost,
            port: int.tryParse(oldPort ?? '443') ?? 443,
            isActive: true,
          ),
        ],
        apiKey: oldApiKey,
        apiSecret: oldApiSecret,
        useHttps: oldUseHttps == 'true',
        createdAt: DateTime.now(),
        lastUsed: DateTime.now(),
      );

      await _storageService.saveProfile(defaultProfile);
      await _storageService.setActiveProfileId(defaultProfile.id);

      // Clean up old storage
      await _secureStorage.delete(key: 'host');
      await _secureStorage.delete(key: 'port');
      await _secureStorage.delete(key: 'api_key');
      await _secureStorage.delete(key: 'api_secret');
      await _secureStorage.delete(key: 'use_https');
    }
  }
}


