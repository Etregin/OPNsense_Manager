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

/// Service for handling platform-specific file operation errors
class PlatformErrorHandler {
  // Platform-specific error codes for file operations
  // Unix/Linux/macOS error codes
  static const int _errNoSpaceUnix = 28;      // ENOSPC - No space left on device
  static const int _errAccessDeniedUnix = 13; // EACCES - Permission denied
  static const int _errReadOnlyUnix = 30;     // EROFS - Read-only file system
  
  // Windows error codes
  static const int _errAccessDeniedWindows = 5; // ERROR_ACCESS_DENIED

  /// Converts a FileSystemException to a user-friendly error message
  /// 
  /// Handles platform-specific error codes and provides appropriate messages
  /// for common file operation failures.
  static String getFileSystemErrorMessage(FileSystemException e) {
    final osError = e.osError;
    
    if (osError == null) {
      return 'File operation failed: ${e.message}';
    }
    
    final errorCode = osError.errorCode;
    
    // Check for platform-specific error codes
    if (errorCode == _errNoSpaceUnix) {
      return 'Operation failed: Insufficient disk space';
    } else if ((Platform.isWindows && errorCode == _errAccessDeniedWindows) ||
               (!Platform.isWindows && errorCode == _errAccessDeniedUnix)) {
      return 'Operation failed: Permission denied. Please choose a different location';
    } else if (errorCode == _errReadOnlyUnix && !Platform.isWindows) {
      return 'Operation failed: Cannot write to read-only location';
    } else {
      return 'File operation failed: ${e.message}';
    }
  }

  /// Checks if an error is a permission-related error
  static bool isPermissionError(FileSystemException e) {
    final osError = e.osError;
    if (osError == null) return false;
    
    final errorCode = osError.errorCode;
    return (Platform.isWindows && errorCode == _errAccessDeniedWindows) ||
           (!Platform.isWindows && errorCode == _errAccessDeniedUnix);
  }

  /// Checks if an error is a disk space error
  static bool isDiskSpaceError(FileSystemException e) {
    final osError = e.osError;
    if (osError == null) return false;
    
    return osError.errorCode == _errNoSpaceUnix;
  }

  /// Checks if an error is a read-only filesystem error
  static bool isReadOnlyError(FileSystemException e) {
    final osError = e.osError;
    if (osError == null) return false;
    
    return !Platform.isWindows && osError.errorCode == _errReadOnlyUnix;
  }
}


