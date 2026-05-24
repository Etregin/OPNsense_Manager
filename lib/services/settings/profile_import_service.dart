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

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import '../profile_service.dart';

/// Service for importing profiles from JSON files
class ProfileImportService {
  final ProfileService _profileService;

  ProfileImportService({required this._profileService});

  /// Import profiles from a JSON file
  /// Returns a map with import results: success (int), failed (int), errors (List of String)
  Future<Map<String, dynamic>> importProfiles({required bool overwrite}) async {
    // Pick a file
    final pickerResult = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (pickerResult == null) {
      throw Exception('No file selected');
    }

    // Check if path is null before accessing it
    if (pickerResult.path == null) {
      throw Exception('Unable to access file path');
    }

    final file = File(pickerResult.path!);
    final jsonString = await file.readAsString();

    // Validate file format
    final validationError = _profileService.validateImportFile(jsonString);

    if (validationError != null) {
      throw Exception('Invalid file format: $validationError');
    }

    // Import profiles using ProfileService
    return await _profileService.importProfiles(
      jsonString,
      overwrite: overwrite,
    );
  }

  /// Validate import file format
  String? validateImportFile(String jsonString) {
    return _profileService.validateImportFile(jsonString);
  }
}


