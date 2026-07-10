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

/// Classifies the root cause of an [ApiException] so callers can branch on
/// error type rather than matching against human-readable message strings.
enum ApiErrorType {
  /// The request timed out before receiving a response.
  timeout,

  /// The server returned HTTP 401 — credentials are invalid or missing.
  authFailure,

  /// The server returned HTTP 403 — the authenticated user lacks permission.
  permissionDenied,

  /// The server returned HTTP 404 — the requested resource does not exist.
  notFound,

  /// The server returned an HTTP error other than 401/403/404.
  serverError,

  /// TLS/SSL certificate validation failed (e.g. self-signed cert rejected).
  certificateError,

  /// A low-level network error occurred (e.g. socket refused, unreachable host).
  networkError,

  /// The request was cancelled before completion.
  cancelled,

  /// An error occurred that does not fit any of the categories above.
  unknown,
}

/// Exception thrown by API operations.
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final ApiErrorType errorType;

  const ApiException(this.message, this.statusCode, this.errorType);

  @override
  String toString() {
    if (statusCode != null) {
      return 'ApiException: $message (Status: $statusCode)';
    }
    return 'ApiException: $message';
  }
}
