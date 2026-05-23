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

import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import '../../models/connection_endpoint.dart';
import '../../models/opnsense_config.dart';

/// Service for managing connection selection and failover logic
/// 
/// This service handles testing multiple connection endpoints, selecting the best
/// available connection, and automatically failing over to backup connections when
/// the primary connection fails.
class ConnectionManagerService {
  ConnectionTestResult? _lastTestResult;
  /// Timeout duration for connection tests
  static const Duration _connectionTimeout = Duration(seconds: 5);
  
  /// Maximum time to wait before considering a connection stale
  static const Duration _staleConnectionThreshold = Duration(hours: 1);
  
  /// Minimum time between retry attempts for a failed connection
  static const Duration _retryThreshold = Duration(minutes: 5);

  /// Find the best working connection from a list of endpoints
  /// 
  /// Tests each connection endpoint in priority order and returns the first
  /// working connection. Updates the connection's lastSuccessfulConnection
  /// timestamp and marks it as active.
  /// 
  /// Returns null if no working connection is found.
  /// 
  /// Example:
  /// ```dart
  /// final service = ConnectionManagerService();
  /// final bestConnection = await service.findBestConnection(
  ///   profile.connections,
  ///   profile.toOPNsenseConfig(),
  /// );
  /// ```
  Future<ConnectionEndpoint?> findBestConnection(
    List<ConnectionEndpoint> connections,
    OPNsenseConfig config,
  ) async {
    if (connections.isEmpty) {
      return null;
    }

    // Sort connections by priority
    final sortedConnections = sortConnectionsByPriority(connections);

    // Test each connection in order
    for (final connection in sortedConnections) {
      final isWorking = await testConnection(connection, config);
      
      if (isWorking) {
        // Update the connection with success timestamp and active status
        return connection.copyWith(
          isActive: true,
          lastSuccessfulConnection: DateTime.now(),
        );
      }
    }

    // No working connection found
    return null;
  }

  /// Test if a specific endpoint is reachable
  /// 
  /// Makes a simple API call to /api/core/system/status to verify the
  /// connection is working. Handles timeouts, SSL errors, and other
  /// network issues gracefully.
  /// 
  /// Returns true if the connection is successful, false otherwise.
  /// 
  /// Example:
  /// ```dart
  /// final service = ConnectionManagerService();
  /// final isWorking = await service.testConnection(
  ///   endpoint,
  ///   config,
  /// );
  /// ```
  Future<bool> testConnection(
    ConnectionEndpoint endpoint,
    OPNsenseConfig config,
  ) async {
    final result = await testConnectionDetailed(endpoint, config);
    return result.isSuccess;
  }

  Future<ConnectionTestResult> testConnectionDetailed(
    ConnectionEndpoint endpoint,
    OPNsenseConfig config,
  ) async {
    Dio? dio;
    final baseUrl = buildBaseUrl(endpoint, config.useHttps);
    final requestPath = '/core/system/status';
    final requestUrl = '$baseUrl$requestPath';
    final headers = <String, String>{
      'Authorization': config.authHeader,
    };

    _logConnectionAttemptStart(
      endpoint: endpoint,
      config: config,
      requestUrl: requestUrl,
      headers: headers,
    );

    try {
      dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: _connectionTimeout,
          receiveTimeout: _connectionTimeout,
          sendTimeout: _connectionTimeout,
          headers: headers,
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (config.allowSelfSignedCerts) {
        (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
          final client = HttpClient();
          client.badCertificateCallback =
              (X509Certificate cert, String host, int port) =>
                  host == endpoint.host && port == endpoint.port;
          return client;
        };
      }

      final response = await dio.get(requestPath);

      final statusCode = response.statusCode;
      final isReachable = statusCode == 200 ||
          statusCode == 400 ||
          statusCode == 401 ||
          statusCode == 403;

      final result = ConnectionTestResult(
        isSuccess: isReachable,
        errorType: isReachable ? 'none' : 'http_error',
        errorMessage: isReachable
            ? null
            : 'Unexpected HTTP status code: ${statusCode ?? 'unknown'}',
        statusCode: statusCode,
        host: endpoint.host,
        port: endpoint.port,
        useHttps: config.useHttps,
        allowSelfSignedCerts: config.allowSelfSignedCerts,
        requestUrl: requestUrl,
        method: 'GET',
        timeout: _connectionTimeout,
        responseBodyPreview: _buildResponsePreview(response.data),
      );

      _lastTestResult = result;

      if (isReachable) {
        debugPrint(
          'Connection test SUCCEEDED: ${endpoint.displayName} '
          '(${endpoint.host}:${endpoint.port}) '
          '[status=${statusCode ?? 'unknown'}]',
        );
      } else {
        _logConnectionFailure(result);
      }

      return result;
    } on DioException catch (e, stackTrace) {
      final result = _buildDioFailureResult(
        endpoint: endpoint,
        config: config,
        requestUrl: requestUrl,
        exception: e,
        stackTrace: stackTrace,
      );
      _lastTestResult = result;
      _logConnectionFailure(result);
      return result;
    } on SocketException catch (e, stackTrace) {
      final result = ConnectionTestResult(
        isSuccess: false,
        errorType: 'socket_error',
        errorMessage: e.message,
        rawError: e.toString(),
        stackTrace: stackTrace.toString(),
        host: endpoint.host,
        port: endpoint.port,
        useHttps: config.useHttps,
        allowSelfSignedCerts: config.allowSelfSignedCerts,
        requestUrl: requestUrl,
        method: 'GET',
        timeout: _connectionTimeout,
      );
      _lastTestResult = result;
      _logConnectionFailure(result);
      return result;
    } on TimeoutException catch (e, stackTrace) {
      final result = ConnectionTestResult(
        isSuccess: false,
        errorType: 'timeout',
        errorMessage: e.message ?? 'Connection timeout',
        rawError: e.toString(),
        stackTrace: stackTrace.toString(),
        host: endpoint.host,
        port: endpoint.port,
        useHttps: config.useHttps,
        allowSelfSignedCerts: config.allowSelfSignedCerts,
        requestUrl: requestUrl,
        method: 'GET',
        timeout: _connectionTimeout,
      );
      _lastTestResult = result;
      _logConnectionFailure(result);
      return result;
    } on HandshakeException catch (e, stackTrace) {
      final result = ConnectionTestResult(
        isSuccess: false,
        errorType: 'ssl_handshake_error',
        errorMessage: e.message,
        rawError: e.toString(),
        stackTrace: stackTrace.toString(),
        host: endpoint.host,
        port: endpoint.port,
        useHttps: config.useHttps,
        allowSelfSignedCerts: config.allowSelfSignedCerts,
        requestUrl: requestUrl,
        method: 'GET',
        timeout: _connectionTimeout,
      );
      _lastTestResult = result;
      _logConnectionFailure(result);
      return result;
    } on HttpException catch (e, stackTrace) {
      final result = ConnectionTestResult(
        isSuccess: false,
        errorType: 'http_exception',
        errorMessage: e.message,
        rawError: e.toString(),
        stackTrace: stackTrace.toString(),
        host: endpoint.host,
        port: endpoint.port,
        useHttps: config.useHttps,
        allowSelfSignedCerts: config.allowSelfSignedCerts,
        requestUrl: requestUrl,
        method: 'GET',
        timeout: _connectionTimeout,
      );
      _lastTestResult = result;
      _logConnectionFailure(result);
      return result;
    } catch (e, stackTrace) {
      final result = ConnectionTestResult(
        isSuccess: false,
        errorType: 'unexpected_error',
        errorMessage: e.toString(),
        rawError: e.toString(),
        stackTrace: stackTrace.toString(),
        host: endpoint.host,
        port: endpoint.port,
        useHttps: config.useHttps,
        allowSelfSignedCerts: config.allowSelfSignedCerts,
        requestUrl: requestUrl,
        method: 'GET',
        timeout: _connectionTimeout,
      );
      _lastTestResult = result;
      _logConnectionFailure(result);
      return result;
    } finally {
      dio?.close();
    }
  }

  ConnectionTestResult? getLastTestResult() {
    return _lastTestResult;
  }

  ConnectionTestResult _buildDioFailureResult({
    required ConnectionEndpoint endpoint,
    required OPNsenseConfig config,
    required String requestUrl,
    required DioException exception,
    required StackTrace stackTrace,
  }) {
    final statusCode = exception.response?.statusCode;
    final responsePreview = _buildResponsePreview(exception.response?.data);
    final error = exception.error;
    final errorType = _mapDioErrorType(exception);
    final errorMessage = _buildDioErrorMessage(exception);

    return ConnectionTestResult(
      isSuccess: false,
      errorType: errorType,
      errorMessage: errorMessage,
      rawError: exception.toString(),
      stackTrace: stackTrace.toString(),
      statusCode: statusCode,
      host: endpoint.host,
      port: endpoint.port,
      useHttps: config.useHttps,
      allowSelfSignedCerts: config.allowSelfSignedCerts,
      requestUrl: requestUrl,
      method: 'GET',
      timeout: _connectionTimeout,
      responseBodyPreview: responsePreview,
      innerError: error?.toString(),
    );
  }

  String _mapDioErrorType(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'timeout';
      case DioExceptionType.badCertificate:
        return 'ssl_certificate_error';
      case DioExceptionType.connectionError:
        if (exception.error is HandshakeException) {
          return 'ssl_handshake_error';
        }
        if (exception.error is SocketException) {
          return 'socket_error';
        }
        return 'network_error';
      case DioExceptionType.badResponse:
        return 'http_error';
      case DioExceptionType.cancel:
        return 'request_cancelled';
      case DioExceptionType.unknown:
        if (exception.error is HandshakeException) {
          return 'ssl_handshake_error';
        }
        if (exception.error is SocketException) {
          return 'socket_error';
        }
        if (exception.error is TimeoutException) {
          return 'timeout';
        }
        return 'unknown_network_error';
    }
  }

  String _buildDioErrorMessage(DioException exception) {
    final statusCode = exception.response?.statusCode;
    final innerError = exception.error;

    if (statusCode != null) {
      return 'HTTP $statusCode: ${exception.message ?? 'Request failed'}';
    }

    if (innerError is SocketException) {
      return innerError.message;
    }

    if (innerError is HandshakeException) {
      return innerError.message;
    }

    if (innerError is TimeoutException) {
      return innerError.message ?? 'Connection timeout';
    }

    return exception.message ?? exception.toString();
  }

  String? _buildResponsePreview(dynamic responseData) {
    if (responseData == null) {
      return null;
    }

    final preview = responseData.toString();
    if (preview.length <= 300) {
      return preview;
    }
    return '${preview.substring(0, 300)}...';
  }

  void _logConnectionAttemptStart({
    required ConnectionEndpoint endpoint,
    required OPNsenseConfig config,
    required String requestUrl,
    required Map<String, String> headers,
  }) {
    final sanitizedHeaders = Map<String, String>.from(headers);
    if (sanitizedHeaders.containsKey('Authorization')) {
      sanitizedHeaders['Authorization'] = '***redacted***';
    }

    debugPrint(
      'Connection test START: ${endpoint.displayName} '
      '(${endpoint.host}:${endpoint.port})',
    );
    debugPrint('  URL: $requestUrl');
    debugPrint('  Method: GET');
    debugPrint('  Timeout: ${_connectionTimeout.inSeconds}s');
    debugPrint('  HTTPS: ${config.useHttps}');
    debugPrint('  Allow Self-Signed: ${config.allowSelfSignedCerts}');
    debugPrint('  Headers: $sanitizedHeaders');
  }

  void _logConnectionFailure(ConnectionTestResult result) {
    debugPrint(
      'Connection test FAILED: ${result.errorType}'
      '${result.errorMessage != null ? ': ${result.errorMessage}' : ''}',
    );
    debugPrint('  Host: ${result.host}');
    debugPrint('  Port: ${result.port}');
    debugPrint('  HTTPS: ${result.useHttps}');
    debugPrint('  Allow Self-Signed: ${result.allowSelfSignedCerts}');
    debugPrint('  URL: ${result.requestUrl}');
    debugPrint('  Method: ${result.method}');
    debugPrint('  Timeout: ${result.timeout.inSeconds}s');
    if (result.statusCode != null) {
      debugPrint('  HTTP Status: ${result.statusCode}');
    }
    if (result.innerError != null) {
      debugPrint('  Inner Error: ${result.innerError}');
    }
    if (result.responseBodyPreview != null) {
      debugPrint('  Response Preview: ${result.responseBodyPreview}');
    }
    if (result.rawError != null) {
      debugPrint('  Raw Error: ${result.rawError}');
    }
    if (result.stackTrace != null) {
      debugPrint('  Stack Trace: ${result.stackTrace}');
    }
  }

  /// Attempt failover to a backup connection
  /// 
  /// Called when the active connection fails. Tries each remaining connection
  /// in priority order, skipping the failed connection. Returns the first
  /// working connection or null if all connections fail.
  /// 
  /// Updates the active status of connections accordingly.
  /// 
  /// Example:
  /// ```dart
  /// final service = ConnectionManagerService();
  /// final backupConnection = await service.attemptFailover(
  ///   profile.connections,
  ///   profile.toOPNsenseConfig(),
  ///   failedConnection,
  /// );
  /// ```
  Future<ConnectionEndpoint?> attemptFailover(
    List<ConnectionEndpoint> connections,
    OPNsenseConfig config,
    ConnectionEndpoint failedConnection,
  ) async {
    if (connections.isEmpty) {
      return null;
    }

    // Filter out the failed connection
    final remainingConnections = connections
        .where((conn) =>
            !(conn.host == failedConnection.host &&
              conn.port == failedConnection.port))
        .toList();

    if (remainingConnections.isEmpty) {
      return null;
    }

    // Sort remaining connections by priority
    final sortedConnections = sortConnectionsByPriority(remainingConnections);

    // Test each connection in order
    for (final connection in sortedConnections) {
      // Skip if this connection shouldn't be retried yet
      if (!shouldRetryConnection(connection)) {
        continue;
      }

      final isWorking = await testConnection(connection, config);
      
      if (isWorking) {
        // Update the connection with success timestamp and active status
        return connection.copyWith(
          isActive: true,
          lastSuccessfulConnection: DateTime.now(),
        );
      }
    }

    // No working backup connection found
    return null;
  }

  /// Sort connections by priority
  /// 
  /// Priority order:
  /// 1. Currently active connection (if any)
  /// 2. Connections with recent successful connections (within 1 hour)
  /// 3. Remaining connections
  /// 
  /// Within each group, connections are sorted by most recent successful
  /// connection time.
  /// 
  /// Example:
  /// ```dart
  /// final service = ConnectionManagerService();
  /// final sorted = service.sortConnectionsByPriority(connections);
  /// ```
  List<ConnectionEndpoint> sortConnectionsByPriority(
    List<ConnectionEndpoint> connections,
  ) {
    if (connections.isEmpty) {
      return [];
    }

    final now = DateTime.now();
    final result = <ConnectionEndpoint>[];

    // Group 1: Active connection
    final activeConnection = connections.where((c) => c.isActive).toList();
    result.addAll(activeConnection);

    // Group 2: Recently successful connections (not active)
    final recentConnections = connections
        .where((c) =>
            !c.isActive &&
            c.lastSuccessfulConnection != null &&
            now.difference(c.lastSuccessfulConnection!) <
                _staleConnectionThreshold)
        .toList();
    
    // Sort by most recent first
    recentConnections.sort((a, b) {
      if (a.lastSuccessfulConnection == null) return 1;
      if (b.lastSuccessfulConnection == null) return -1;
      return b.lastSuccessfulConnection!
          .compareTo(a.lastSuccessfulConnection!);
    });
    result.addAll(recentConnections);

    // Group 3: Remaining connections
    final remainingConnections = connections
        .where((c) =>
            !c.isActive &&
            (c.lastSuccessfulConnection == null ||
                now.difference(c.lastSuccessfulConnection!) >=
                    _staleConnectionThreshold))
        .toList();
    
    // Sort by most recent first (nulls last)
    remainingConnections.sort((a, b) {
      if (a.lastSuccessfulConnection == null &&
          b.lastSuccessfulConnection == null) {
        return 0;
      }
      if (a.lastSuccessfulConnection == null) return 1;
      if (b.lastSuccessfulConnection == null) return -1;
      return b.lastSuccessfulConnection!
          .compareTo(a.lastSuccessfulConnection!);
    });
    result.addAll(remainingConnections);

    return result;
  }

  /// Build base URL from endpoint and protocol
  /// 
  /// Constructs the full base URL for API calls using the endpoint's
  /// host and port, and the specified protocol.
  /// 
  /// Example:
  /// ```dart
  /// final service = ConnectionManagerService();
  /// final url = service.buildBaseUrl(endpoint, true);
  /// // Returns: "https://192.168.1.1:443/api"
  /// ```
  String buildBaseUrl(ConnectionEndpoint endpoint, bool useHttps) {
    final protocol = useHttps ? 'https' : 'http';
    return '$protocol://${endpoint.host}:${endpoint.port}/api';
  }

  /// Get the connection timeout duration
  /// 
  /// Returns the timeout duration used for connection tests.
  /// 
  /// Example:
  /// ```dart
  /// final service = ConnectionManagerService();
  /// final timeout = service.getConnectionTimeout();
  /// ```
  Duration getConnectionTimeout() {
    return _connectionTimeout;
  }

  /// Determine if a connection should be retried
  /// 
  /// Checks if enough time has passed since the last connection attempt
  /// to warrant a retry. This prevents hammering failed connections.
  /// 
  /// Returns true if the connection should be retried, false otherwise.
  /// 
  /// Example:
  /// ```dart
  /// final service = ConnectionManagerService();
  /// if (service.shouldRetryConnection(endpoint)) {
  ///   // Attempt connection
  /// }
  /// ```
  bool shouldRetryConnection(ConnectionEndpoint endpoint) {
    // Always retry if we've never connected successfully
    if (endpoint.lastSuccessfulConnection == null) {
      return true;
    }

    // Check if enough time has passed since last successful connection
    final now = DateTime.now();
    final timeSinceLastSuccess =
        now.difference(endpoint.lastSuccessfulConnection!);
    
    // If the connection was successful recently, it's worth retrying
    if (timeSinceLastSuccess < _staleConnectionThreshold) {
      return true;
    }

    // For stale connections, apply a longer retry threshold
    // This prevents repeatedly trying connections that have been down for a while
    return timeSinceLastSuccess >= _retryThreshold;
  }

  /// Test all connections in parallel for faster results
  /// 
  /// This is an optimization that tests multiple connections simultaneously
  /// rather than sequentially. Returns a map of endpoints to their test results.
  /// 
  /// Example:
  /// ```dart
  /// final service = ConnectionManagerService();
  /// final results = await service.testConnectionsParallel(
  ///   connections,
  ///   config,
  /// );
  /// ```
  Future<Map<ConnectionEndpoint, bool>> testConnectionsParallel(
    List<ConnectionEndpoint> connections,
    OPNsenseConfig config,
  ) async {
    if (connections.isEmpty) {
      return {};
    }

    // Create a list of futures for parallel testing
    final futures = connections.map((connection) async {
      final isWorking = await testConnection(connection, config);
      return MapEntry(connection, isWorking);
    }).toList();

    // Wait for all tests to complete
    final results = await Future.wait(futures);

    // Convert list of entries to map
    return Map.fromEntries(results);
  }

  /// Get connection health status
  /// 
  /// Returns a human-readable status for a connection based on its
  /// last successful connection time.
  /// 
  /// Possible values:
  /// - "Active": Currently active connection
  /// - "Healthy": Recent successful connection (< 1 hour)
  /// - "Stale": Old successful connection (> 1 hour)
  /// - "Unknown": Never connected successfully
  /// 
  /// Example:
  /// ```dart
  /// final service = ConnectionManagerService();
  /// final status = service.getConnectionHealthStatus(endpoint);
  /// ```
  String getConnectionHealthStatus(ConnectionEndpoint endpoint) {
    if (endpoint.isActive) {
      return 'Active';
    }

    if (endpoint.lastSuccessfulConnection == null) {
      return 'Unknown';
    }

    final now = DateTime.now();
    final timeSinceLastSuccess =
        now.difference(endpoint.lastSuccessfulConnection!);

    if (timeSinceLastSuccess < _staleConnectionThreshold) {
      return 'Healthy';
    }

    return 'Stale';
  }
}

class ConnectionTestResult {
  final bool isSuccess;
  final String errorType;
  final String? errorMessage;
  final String? rawError;
  final String? stackTrace;
  final int? statusCode;
  final String host;
  final int port;
  final bool useHttps;
  final bool allowSelfSignedCerts;
  final String requestUrl;
  final String method;
  final Duration timeout;
  final String? responseBodyPreview;
  final String? innerError;

  const ConnectionTestResult({
    required this.isSuccess,
    required this.errorType,
    this.errorMessage,
    this.rawError,
    this.stackTrace,
    this.statusCode,
    required this.host,
    required this.port,
    required this.useHttps,
    required this.allowSelfSignedCerts,
    required this.requestUrl,
    required this.method,
    required this.timeout,
    this.responseBodyPreview,
    this.innerError,
  });

  String get summary {
    if (isSuccess) {
      return 'success';
    }

    final statusPart = statusCode != null ? ' [HTTP $statusCode]' : '';
    final messagePart = errorMessage?.isNotEmpty == true ? ': $errorMessage' : '';
    return '$errorType$statusPart$messagePart';
  }

  Map<String, dynamic> toLogMap() {
    return {
      'isSuccess': isSuccess,
      'errorType': errorType,
      'errorMessage': errorMessage,
      'rawError': rawError,
      'stackTrace': stackTrace,
      'statusCode': statusCode,
      'host': host,
      'port': port,
      'useHttps': useHttps,
      'allowSelfSignedCerts': allowSelfSignedCerts,
      'requestUrl': requestUrl,
      'method': method,
      'timeoutSeconds': timeout.inSeconds,
      'responseBodyPreview': responseBodyPreview,
      'innerError': innerError,
    };
  }
}

