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

import 'profile_storage_service.dart';

/// Service for profile validation operations
class ProfileValidationService {
  final ProfileStorageService _storageService;

  ProfileValidationService({required ProfileStorageService storageService})
      : _storageService = storageService;

  /// Check if a profile name already exists
  Future<bool> profileNameExists(String name, {String? excludeId}) async {
    final profiles = await _storageService.getAllProfiles();
    return profiles.any((p) =>
        p.name.toLowerCase() == name.toLowerCase() &&
        (excludeId == null || p.id != excludeId));
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
}


