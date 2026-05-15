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
import 'dart:developer' as developer;
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import '../profile_service.dart';
import '../../models/profile.dart';
import '../../utils/formatters.dart';
import 'platform_error_handler.dart';

/// Result of a file export operation
class ExportResult {
  final bool success;
  final String? filePath;
  final String? errorMessage;

  ExportResult({
    required this.success,
    this.filePath,
    this.errorMessage,
  });
}

/// Result of a file import operation
class ImportResult {
  final bool success;
  final int successCount;
  final int failedCount;
  final List<String> errors;

  ImportResult({
    required this.success,
    required this.successCount,
    required this.failedCount,
    required this.errors,
  });
}

/// Service for handling profile import/export file operations
class FileOperationsService {
  final ProfileService _profileService;

  FileOperationsService({ProfileService? profileService})
      : _profileService = profileService ?? ProfileService();

  /// Exports all profiles to a JSON file
  /// 
  /// [includeCredentials] - Whether to include API credentials in the export
  /// Returns an [ExportResult] with the operation status
  Future<ExportResult> exportProfiles({
    required bool includeCredentials,
  }) async {
    try {
      final jsonString = await _profileService.exportProfiles(
        includeCredentials: includeCredentials,
      );
      
      // Create filename with timestamp
      final timestamp = Formatters.formatTimestampForFilename(DateTime.now());
      final suggestedName = 'opnsense_profiles_$timestamp.json';
      
      // Let user choose directory to save the file
      final directoryPath = await FilePicker.getDirectoryPath(
        dialogTitle: 'Choose Export Location',
      );
      
      if (directoryPath == null) {
        // User cancelled the directory picker
        return ExportResult(success: false);
      }
      
      // Create full file path
      final filePath = path.join(directoryPath, suggestedName);
      
      // Write file to chosen location
      final file = File(filePath);
      try {
        await file.writeAsString(jsonString, flush: true);
        
        // Notify the system about the new file for proper indexing
        await _triggerMediaStoreScan(filePath);
        
        return ExportResult(success: true, filePath: filePath);
      } on FileSystemException catch (e) {
        final errorMessage = PlatformErrorHandler.getFileSystemErrorMessage(e);
        return ExportResult(success: false, errorMessage: errorMessage);
      }
    } catch (e) {
      return ExportResult(
        success: false,
        errorMessage: 'Export failed: ${e.toString()}',
      );
    }
  }

  /// Exports a single profile to a JSON file
  ///
  /// [profile] - The profile to export
  /// [includeCredentials] - Whether to include API credentials in the export
  /// Returns an [ExportResult] with the operation status
  Future<ExportResult> exportSingleProfile({
    required Profile profile,
    required bool includeCredentials,
  }) async {
    try {
      final jsonString = await _profileService.exportProfile(
        profile.id,
        includeCredentials: includeCredentials,
      );
      
      // Create filename with profile name and timestamp
      final timestamp = Formatters.formatTimestampForFilename(DateTime.now());
      final safeName = profile.name.replaceAll(RegExp(r'[^\w\s-]'), '_');
      final suggestedName = 'opnsense_profile_${safeName}_$timestamp.json';
      
      // Let user choose directory to save the file
      final directoryPath = await FilePicker.getDirectoryPath(
        dialogTitle: 'Choose Export Location',
      );
      
      if (directoryPath == null) {
        // User cancelled the directory picker
        return ExportResult(success: false);
      }
      
      // Create full file path
      final filePath = path.join(directoryPath, suggestedName);
      
      // Write file to chosen location
      final file = File(filePath);
      try {
        await file.writeAsString(jsonString, flush: true);
        
        // Notify the system about the new file for proper indexing
        await _triggerMediaStoreScan(filePath);
        
        return ExportResult(success: true, filePath: filePath);
      } on FileSystemException catch (e) {
        final errorMessage = PlatformErrorHandler.getFileSystemErrorMessage(e);
        return ExportResult(success: false, errorMessage: errorMessage);
      }
    } catch (e) {
      return ExportResult(
        success: false,
        errorMessage: 'Export failed: ${e.toString()}',
      );
    }
  }

  /// Imports profiles from a JSON file
  /// 
  /// [overwrite] - Whether to overwrite existing profiles with the same name
  /// Returns an [ImportResult] with the operation status
  Future<ImportResult> importProfiles({required bool overwrite}) async {
    try {
      // Pick a file
      final pickerResult = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        allowMultiple: false,
      );
      
      if (pickerResult == null || pickerResult.files.isEmpty) {
        return ImportResult(
          success: false,
          successCount: 0,
          failedCount: 0,
          errors: ['User cancelled file selection'],
        );
      }
      
      // Check if path is null before accessing it
      if (pickerResult.files.first.path == null) {
        return ImportResult(
          success: false,
          successCount: 0,
          failedCount: 0,
          errors: ['Unable to access file path'],
        );
      }
      
      final file = File(pickerResult.files.first.path!);
      final jsonString = await file.readAsString();
      
      // Validate file format
      final validationError = _profileService.validateImportFile(jsonString);
      
      if (validationError != null) {
        return ImportResult(
          success: false,
          successCount: 0,
          failedCount: 0,
          errors: ['Invalid file format: $validationError'],
        );
      }
      
      // Import profiles
      final result = await _profileService.importProfiles(
        jsonString,
        overwrite: overwrite,
      );
      
      final successCount = result['success'] as int;
      final failedCount = result['failed'] as int;
      final errors = result['errors'] as List<String>;
      
      return ImportResult(
        success: failedCount == 0,
        successCount: successCount,
        failedCount: failedCount,
        errors: errors,
      );
    } catch (e) {
      return ImportResult(
        success: false,
        successCount: 0,
        failedCount: 0,
        errors: ['Import failed: ${e.toString()}'],
      );
    }
  }

  /// Triggers MediaStore scan on Android to make the file visible in file managers
  Future<void> _triggerMediaStoreScan(String filePath) async {
    if (Platform.isAndroid) {
      try {
        final ProcessResult result = await Process.run(
          'am',
          [
            'broadcast',
            '-a',
            'android.intent.action.MEDIA_SCANNER_SCAN_FILE',
            '-d',
            'file://$filePath',
          ],
        );
        
        // Log the result for debugging
        if (result.exitCode != 0) {
          developer.log(
            'MediaStore scan failed: ${result.stderr}',
            name: 'FileOperationsService',
          );
        }
      } catch (e) {
        developer.log(
          'Failed to trigger MediaStore scan: $e',
          name: 'FileOperationsService',
        );
      }
    }
  }
}


