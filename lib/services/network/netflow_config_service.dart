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
import '../../models/netflow_cache_stat.dart';
import '../../models/netflow_config.dart';
import '../base/base_opnsense_service.dart';
import '../base/api_exception.dart';

/// Service for the `/api/diagnostics/netflow/*` configuration endpoints.
///
/// Responsibilities:
/// - Fetching and saving NetFlow capture configuration.
/// - Triggering a reconfigure after save.
/// - Resetting all NetFlow data.
/// - Fetching per-interface cache statistics.
class NetflowConfigService extends BaseOPNsenseService {
  // ── Read ──────────────────────────────────────────────────────────────────

  /// Fetches the current NetFlow configuration.
  Future<NetflowConfig> getConfig() async {
    ensureInitialized();
    try {
      final response = await dio.get(ApiEndpoints.netflowGetConfig);
      return NetflowConfig.fromJson(
          response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Fetches per-interface cache statistics.
  Future<List<NetflowCacheStat>> getCacheStats() async {
    ensureInitialized();
    try {
      final response = await dio.get(ApiEndpoints.netflowCacheStats);
      // When NetFlow is disabled the API returns an empty JSON array ([])
      // instead of an object, so guard before casting.
      if (response.data is! Map<String, dynamic>) return [];
      final data = response.data as Map<String, dynamic>;
      return NetflowCacheStat.fromResponse(data);
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  // ── Write ─────────────────────────────────────────────────────────────────

  /// Saves the given [config] to OPNsense.
  ///
  /// Throws [ApiException] if the API returns a non-"saved" result.
  Future<void> saveConfig(NetflowConfig config) async {
    ensureInitialized();
    try {
      final response = await dio.post(
        ApiEndpoints.netflowSetConfig,
        data: config.toSetConfigPayload(),
      );
      final result = response.data['result'] as String? ?? '';
      if (result != 'saved') {
        throw ApiException(
          'Unexpected setconfig result: $result',
          null,
          ApiErrorType.serverError,
        );
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Applies the saved configuration (triggers daemon reconfigure).
  ///
  /// Throws [ApiException] if the API returns a non-"ok" status.
  Future<void> reconfigure() async {
    ensureInitialized();
    try {
      final response = await dio.post(ApiEndpoints.netflowReconfigure);
      final status = response.data['status'] as String? ?? '';
      if (!status.toLowerCase().startsWith('ok')) {
        throw ApiException(
          'Reconfigure failed: $status',
          null,
          ApiErrorType.serverError,
        );
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Resets all NetFlow data (erases Insight graph data).
  ///
  /// Throws [ApiException] if the API returns a non-"OK" status.
  Future<void> resetData() async {
    ensureInitialized();
    try {
      final response = await dio.post(ApiEndpoints.netflowReset);
      final status =
          (response.data['status'] as String? ?? '').trim().toUpperCase();
      if (status != 'OK') {
        throw ApiException(
          'Reset failed: $status',
          null,
          ApiErrorType.serverError,
        );
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }
}
