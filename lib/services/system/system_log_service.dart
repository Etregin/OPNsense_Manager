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
import '../base/base_opnsense_service.dart';
import '../base/api_exception.dart';
import '../../constants/api_endpoints.dart';
import '../../models/openvpn_log_search_response.dart';

/// Service for fetching the five system log file sources available under
/// System > Log Files in the OPNsense GUI.
///
/// All five endpoints share an identical request/response contract and return
/// [OpenvpnLogSearchResponse] — the same typed model used by the OpenVPN log.
class SystemLogService extends BaseOPNsenseService {
  Future<OpenvpnLogSearchResponse> _searchLog(
    String endpoint, {
    int current = 1,
    int rowCount = 50,
    Map<String, dynamic>? sort,
    List<String>? severity,
    double? validFrom,
  }) async {
    ensureInitialized();
    try {
      final data = <String, dynamic>{
        'current': current,
        'rowCount': rowCount,
        'sort': sort ?? <String, dynamic>{},
      };

      if (severity != null && severity.isNotEmpty) {
        data['severity'] = severity;
      }

      if (validFrom != null) {
        data['validFrom'] = validFrom;
      }

      final response = await dio.post(endpoint, data: data);

      if (response.statusCode == 200) {
        return OpenvpnLogSearchResponse.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw ApiException(
          'Failed to fetch logs from $endpoint',
          response.statusCode,
          ApiErrorType.unknown,
        );
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Search Audit logs — POST /diagnostics/log/core/audit
  Future<OpenvpnLogSearchResponse> searchAuditLogs({
    int current = 1,
    int rowCount = 50,
    Map<String, dynamic>? sort,
    List<String>? severity,
    double? validFrom,
  }) => _searchLog(
        ApiEndpoints.diagnosticsLogAudit,
        current: current,
        rowCount: rowCount,
        sort: sort,
        severity: severity,
        validFrom: validFrom,
      );

  /// Search Backend (configd) logs — POST /diagnostics/log/core/configd
  Future<OpenvpnLogSearchResponse> searchBackendLogs({
    int current = 1,
    int rowCount = 50,
    Map<String, dynamic>? sort,
    List<String>? severity,
    double? validFrom,
  }) => _searchLog(
        ApiEndpoints.diagnosticsLogBackend,
        current: current,
        rowCount: rowCount,
        sort: sort,
        severity: severity,
        validFrom: validFrom,
      );

  /// Search Boot logs — POST /diagnostics/log/core/boot
  Future<OpenvpnLogSearchResponse> searchBootLogs({
    int current = 1,
    int rowCount = 50,
    Map<String, dynamic>? sort,
    List<String>? severity,
    double? validFrom,
  }) => _searchLog(
        ApiEndpoints.diagnosticsLogBoot,
        current: current,
        rowCount: rowCount,
        sort: sort,
        severity: severity,
        validFrom: validFrom,
      );

  /// Search General (system) logs — POST /diagnostics/log/core/system
  Future<OpenvpnLogSearchResponse> searchGeneralLogs({
    int current = 1,
    int rowCount = 50,
    Map<String, dynamic>? sort,
    List<String>? severity,
    double? validFrom,
  }) => _searchLog(
        ApiEndpoints.diagnosticsLogGeneral,
        current: current,
        rowCount: rowCount,
        sort: sort,
        severity: severity,
        validFrom: validFrom,
      );

  /// Search Web GUI (lighttpd) logs — POST /diagnostics/log/core/lighttpd
  Future<OpenvpnLogSearchResponse> searchWebGuiLogs({
    int current = 1,
    int rowCount = 50,
    Map<String, dynamic>? sort,
    List<String>? severity,
    double? validFrom,
  }) => _searchLog(
        ApiEndpoints.diagnosticsLogWebGui,
        current: current,
        rowCount: rowCount,
        sort: sort,
        severity: severity,
        validFrom: validFrom,
      );
}
