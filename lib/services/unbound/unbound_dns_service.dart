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

import 'package:dio/dio.dart';
import '../../constants/api_endpoints.dart';
import '../../models/unbound_overview_status.dart';
import '../../models/unbound_query_item.dart';
import '../../models/unbound_rolling.dart';
import '../../models/unbound_settings.dart';
import '../../models/unbound_totals.dart';
import '../base/api_exception.dart';
import '../base/base_opnsense_service.dart';

/// Service for interacting with OPNsense Unbound DNS reporting and settings APIs.
class UnboundDnsService extends BaseOPNsenseService {
  /// Checks whether Unbound overview statistics are enabled.
  ///
  /// Calls `GET /api/unbound/overview/is_enabled`.
  Future<UnboundOverviewStatus> checkIsEnabled() async {
    ensureInitialized();
    try {
      final response = await dio.get(ApiEndpoints.unboundOverviewIsEnabled);
      if (response.data is Map<String, dynamic>) {
        return UnboundOverviewStatus.fromJson(response.data as Map<String, dynamic>);
      }
      return const UnboundOverviewStatus(isEnabled: false);
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Fetches aggregate totals and top-N passed/blocked domains.
  ///
  /// Calls `GET /api/unbound/overview/totals/{limit}`.
  Future<UnboundTotals> getTotals({int limit = 10}) async {
    ensureInitialized();
    try {
      final response = await dio.get(ApiEndpoints.unboundOverviewTotals(limit));
      if (response.data is Map<String, dynamic>) {
        return UnboundTotals.fromJson(response.data as Map<String, dynamic>);
      }
      throw const ApiException('Invalid totals response', null, ApiErrorType.serverError);
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Fetches time-series rolling queries for the specified duration (in hours: 24, 12, 1).
  ///
  /// Calls `GET /api/unbound/overview/rolling/{hours}`.
  Future<List<UnboundRollingPoint>> getRolling(int hours) async {
    ensureInitialized();
    try {
      final response = await dio.get(ApiEndpoints.unboundOverviewRolling(hours));
      final result = <UnboundRollingPoint>[];
      if (response.data is Map<String, dynamic>) {
        final map = response.data as Map<String, dynamic>;
        map.forEach((tsKey, pointData) {
          if (pointData is Map<String, dynamic>) {
            final ts = double.tryParse(tsKey) ?? 0.0;
            result.add(UnboundRollingPoint(
              timestamp: ts,
              total: (pointData['total'] as num?)?.toInt() ?? 0,
              passed: (pointData['passed'] as num?)?.toInt() ?? 0,
              blocked: (pointData['blocked'] as num?)?.toInt() ?? 0,
              dropped: (pointData['dropped'] as num?)?.toInt() ?? 0,
              resolved: (pointData['resolved'] as num?)?.toInt() ?? 0,
              local: (pointData['local'] as num?)?.toInt() ?? 0,
              cached: (pointData['cached'] as num?)?.toInt() ?? 0,
            ));
          }
        });
      }
      result.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      return result;
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Fetches client activity time-series for the specified duration (in hours: 24, 12, 1).
  ///
  /// Calls `GET /api/unbound/overview/rolling/{hours}/1`.
  Future<List<UnboundRollingClientPoint>> getClientActivity(int hours) async {
    ensureInitialized();
    try {
      final response = await dio.get(
        ApiEndpoints.unboundOverviewRolling(hours, clientActivity: true),
      );
      final result = <UnboundRollingClientPoint>[];
      if (response.data is Map<String, dynamic>) {
        final map = response.data as Map<String, dynamic>;
        map.forEach((tsKey, clientsData) {
          final ts = double.tryParse(tsKey) ?? 0.0;
          final clientList = <UnboundClientHit>[];
          if (clientsData is Map<String, dynamic>) {
            clientsData.forEach((ip, clientInfo) {
              if (clientInfo is Map<String, dynamic>) {
                clientList.add(UnboundClientHit(
                  ip: ip,
                  count: (clientInfo['count'] as num?)?.toInt() ?? 0,
                  hostname: clientInfo['hostname']?.toString() ?? '',
                ));
              }
            });
          }
          result.add(UnboundRollingClientPoint(
            timestamp: ts,
            clients: clientList,
          ));
        });
      }
      result.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      return result;
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Searches Unbound DNS query logs.
  ///
  /// Calls `POST /api/unbound/overview/search_queries/`.
  Future<UnboundQuerySearchResponse> searchQueries({
    int current = 1,
    int rowCount = 50,
    String? searchPhrase,
    String? client,
    int? timeStart,
    int? timeEnd,
  }) async {
    ensureInitialized();
    try {
      final payload = {
        'current': current,
        'rowCount': rowCount,
        'sort': {},
        if (client != null && client.isNotEmpty) 'client': client,
        ...?timeStart != null ? {'timeStart': timeStart} : null,
        ...?timeEnd != null ? {'timeEnd': timeEnd} : null,
        if (searchPhrase != null && searchPhrase.isNotEmpty)
          'searchPhrase': searchPhrase,
      };
      final response = await dio.post(
        ApiEndpoints.unboundOverviewSearchQueries,
        data: payload,
      );
      if (response.data is Map<String, dynamic>) {
        return UnboundQuerySearchResponse.fromJson(
          response.data as Map<String, dynamic>,
        );
      }
      return const UnboundQuerySearchResponse(
        total: 0,
        rowCount: 0,
        current: 1,
        rows: [],
      );
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Fetches current Unbound settings.
  ///
  /// Calls `GET /api/unbound/settings/get`.
  Future<UnboundSettings> getSettings() async {
    ensureInitialized();
    try {
      final response = await dio.get(ApiEndpoints.unboundSettingsGet);
      if (response.data is Map<String, dynamic>) {
        return UnboundSettings.fromJson(response.data as Map<String, dynamic>);
      }
      return const UnboundSettings();
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Updates Unbound general statistics setting.
  ///
  /// Calls `POST /api/unbound/settings/set` with payload `{"unbound":{"general":{"stats":"1"}}}`.
  Future<void> setStatsEnabled(bool enabled) async {
    ensureInitialized();
    try {
      final payload = {
        'unbound': {
          'general': {
            'stats': enabled ? '1' : '0',
          },
        },
      };
      final response = await dio.post(
        ApiEndpoints.unboundSettingsSet,
        data: payload,
      );
      if (response.data is Map && response.data['result'] != 'saved') {
        throw ApiException(
          'Failed to save Unbound settings: ${response.data}',
          null,
          ApiErrorType.serverError,
        );
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Reconfigures Unbound DNS general service.
  ///
  /// Calls `POST /api/unbound/service/reconfigure_general`.
  Future<void> reconfigureGeneral() async {
    ensureInitialized();
    try {
      final response = await dio.post(
        ApiEndpoints.unboundServiceReconfigureGeneral,
        data: {},
      );
      if (response.data is Map && response.data['status'] != 'ok') {
        throw ApiException(
          'Reconfigure general failed: ${response.data}',
          null,
          ApiErrorType.serverError,
        );
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Resets Unbound DNS statistics data.
  ///
  /// Calls `POST /api/unbound/overview/reset`.
  Future<void> resetDnsData() async {
    ensureInitialized();
    try {
      final response = await dio.post(
        ApiEndpoints.unboundOverviewReset,
        data: {},
      );
      final status = response.data is Map ? response.data['status']?.toString().trim() : '';
      if (status != null && !status.toUpperCase().startsWith('OK')) {
        throw ApiException(
          'Failed to reset DNS data: $status',
          null,
          ApiErrorType.serverError,
        );
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Checks Unbound service running status.
  ///
  /// Calls `POST /api/unbound/service/status`.
  Future<String> getServiceStatus() async {
    ensureInitialized();
    try {
      final response = await dio.post(
        ApiEndpoints.unboundServiceStatus,
        data: {},
      );
      if (response.data is Map && response.data['status'] != null) {
        return response.data['status'].toString();
      }
      return 'unknown';
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }
}
