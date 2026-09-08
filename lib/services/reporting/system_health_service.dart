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
import '../../models/system_health_graph.dart';
import '../../models/system_health_rrd_list.dart';
import '../../models/system_health_status.dart';
import '../base/base_opnsense_service.dart';

/// Service for the OPNsense system-health (RRD) reporting API.
///
/// Endpoint base: `GET /api/diagnostics/systemhealth/`.
class SystemHealthService extends BaseOPNsenseService {
  /// Saves the enabled/disabled state of system-health reporting.
  ///
  /// Calls `POST /diagnostics/systemhealth/set`.
  Future<void> setEnabled(bool enabled) async {
    ensureInitialized();
    try {
      await dio.post(ApiEndpoints.systemHealthSet, data: {
        'systemhealth': {'enabled': enabled ? '1' : '0'},
      });
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Deletes one RRD file by its filename (e.g. `ipsec-packets.rrd`).
  ///
  /// Calls `POST /diagnostics/systemhealth/del_rrd/{filename}`.
  Future<void> deleteRrdFile(String filename) async {
    ensureInitialized();
    try {
      await dio.post(
        ApiEndpoints.systemHealthDelRrdFile(filename),
        data: {},
      );
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Deletes all RRD data (reset).
  ///
  /// Calls `POST /diagnostics/systemhealth/del_rrd`.
  Future<void> deleteAllRrd() async {
    ensureInitialized();
    try {
      await dio.post(ApiEndpoints.systemHealthDelRrd);
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Fetches whether system-health reporting is enabled.
  ///
  /// Calls `GET /diagnostics/systemhealth/get`.
  Future<SystemHealthStatus> getStatus() async {
    ensureInitialized();
    try {
      final response = await dio.get(ApiEndpoints.systemHealthGet);
      if (response.data is Map<String, dynamic>) {
        return SystemHealthStatus.fromJson(
          response.data as Map<String, dynamic>,
        );
      }
      return const SystemHealthStatus(isEnabled: false);
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Fetches RRD metadata: categories, subjects, backing files, and interface
  /// descriptions.
  ///
  /// Calls `GET /diagnostics/systemhealth/get_rrd_list`.
  Future<SystemHealthRrdList> getRrdList() async {
    ensureInitialized();
    try {
      final response = await dio.get(ApiEndpoints.systemHealthGetRrdList);
      if (response.data is Map<String, dynamic>) {
        return SystemHealthRrdList.fromJsonSafe(
          response.data as Map<String, dynamic>,
        );
      }
      return const SystemHealthRrdList(data: {}, files: [], interfaces: {});
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Fetches multi-series RRD graph data for the given [key] and [period].
  ///
  /// [key] is the RRD file key derived from category and subject:
  ///   - packets/traffic: `"{subject}-{category}"` (e.g. `"lan-packets"`)
  ///   - system:          `"system-{subject}"`     (e.g. `"system-memory"`)
  ///   - services:        `"{subject}"`            (e.g. `"ntpd"`)
  ///
  /// [period] is `0` for the default 24-hour view.
  ///
  /// Calls `GET /diagnostics/systemhealth/get_system_health/{key}/{period}`.
  Future<SystemHealthGraphResponse> getGraph(
    String key, {
    int period = 0,
  }) async {
    ensureInitialized();
    try {
      final response = await dio.get(
        ApiEndpoints.systemHealthGetGraph(key, period: period),
      );
      if (response.data is! Map<String, dynamic>) {
        return const SystemHealthGraphResponse(
          step: 0,
          lastupdate: 0,
          set: SystemHealthDataSet(count: 0, data: []),
        );
      }
      return SystemHealthGraphResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }
}
