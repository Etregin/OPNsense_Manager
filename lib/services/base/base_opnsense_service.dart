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
import 'package:dio/dio.dart';
import '../../models/opnsense_config.dart';
import 'api_exception.dart';

/// Base service class providing common functionality for all OPNsense API services
abstract class BaseOPNsenseService {
  Dio? _dio;
  OPNsenseConfig? _config;

  /// Get the Dio instance
  Dio get dio {
    if (_dio == null) {
      throw const ApiException('Service not initialized', null, ApiErrorType.unknown);
    }
    return _dio!;
  }

  /// Get the configuration
  OPNsenseConfig get config {
    if (_config == null) {
      throw const ApiException('Service not initialized', null, ApiErrorType.unknown);
    }
    return _config!;
  }

  /// Check if service is initialized
  bool get isInitialized => _dio != null && _config != null;

  /// Initialize the service with Dio instance and configuration
  void init(Dio dio, OPNsenseConfig config) {
    _dio = dio;
    _config = config;
  }

  /// Ensure service is initialized before making API calls
  void ensureInitialized() {
    if (!isInitialized) {
      throw const ApiException('Service not initialized', null, ApiErrorType.unknown);
    }
  }

  /// Handle Dio errors and convert to ApiException
  ApiException handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return const ApiException('Connection timeout', null, ApiErrorType.timeout);
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 401) {
          return ApiException('Invalid credentials', statusCode, ApiErrorType.authFailure);
        } else if (statusCode == 403) {
          return ApiException('Insufficient permissions', statusCode, ApiErrorType.permissionDenied);
        } else if (statusCode == 404) {
          return ApiException('Resource not found', statusCode, ApiErrorType.notFound);
        } else {
          return ApiException('Server error', statusCode, ApiErrorType.serverError);
        }
      case DioExceptionType.cancel:
        return const ApiException('Request cancelled', null, ApiErrorType.cancelled);
      case DioExceptionType.badCertificate:
        return const ApiException(
          'Certificate validation failed. The server is using a self-signed certificate. '
          'Please enable "Allow Self-Signed Certificates" in connection settings.',
          null,
          ApiErrorType.certificateError,
        );
      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
        if (_isCertificateError(e)) {
          return const ApiException(
            'Certificate validation failed. The server is using a self-signed certificate. '
            'Please enable "Allow Self-Signed Certificates" in connection settings.',
            null,
            ApiErrorType.certificateError,
          );
        }
        if (e.error is SocketException) {
          return const ApiException('Network error: Unable to connect', null, ApiErrorType.networkError);
        }
        return ApiException('Connection error: ${e.message}', null, ApiErrorType.networkError);
    }
  }

  bool _isCertificateError(DioException e) =>
      e.message?.contains('CERTIFICATE_VERIFY_FAILED') == true ||
      e.message?.contains('certificate') == true ||
      e.error is HandshakeException;

  /// Extract selected value from OPNsense dropdown structure
  String extractSelectedValue(Object? field, {bool returnDisplayValue = false}) {
    if (field is String) {
      return field;
    }
    if (field is List) {
      // If it's a list, return the first element as string
      return field.isNotEmpty ? field.first.toString() : '';
    }
    if (field is Map<String, dynamic>) {
      // Find the selected option
      for (var entry in field.entries) {
        final value = entry.value;
        if (value is Map<String, dynamic> && value['selected'] == 1) {
          // Return the display value if requested and available, otherwise return the key
          if (returnDisplayValue && value.containsKey('value')) {
            return value['value'].toString();
          }
          return entry.key;
        }
      }
    }
    return '';
  }

  /// Parse storage string like "8.0G" or "40G" to bytes
  int parseStorageString(String value) {
    // Remove any whitespace
    value = value.trim();
    
    // Extract number and unit
    final match = RegExp(r'([\d.]+)([KMGT]?)').firstMatch(value);
    if (match == null) return 0;
    
    final number = double.tryParse(match.group(1) ?? '0') ?? 0;
    final unit = match.group(2) ?? '';
    
    // Convert to bytes
    switch (unit.toUpperCase()) {
      case 'T':
        return (number * 1024 * 1024 * 1024 * 1024).toInt();
      case 'G':
        return (number * 1024 * 1024 * 1024).toInt();
      case 'M':
        return (number * 1024 * 1024).toInt();
      case 'K':
        return (number * 1024).toInt();
      default:
        return number.toInt(); // Assume bytes if no unit
    }
  }

  /// Clear service state
  void clear() {
    _dio = null;
    _config = null;
  }
}


