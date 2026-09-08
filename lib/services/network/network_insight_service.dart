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
import '../../models/insight_flow_detail.dart';
import '../../models/netflow_status.dart';
import '../../models/network_insight_direction_total.dart';
import '../../models/network_insight_timeserie.dart';
import '../../models/network_insight_top_addr.dart';
import '../../models/network_insight_top_port.dart';
import '../base/base_opnsense_service.dart';

/// Service for the OPNsense Network Insight / NetFlow diagnostics APIs.
///
/// All methods require the service to be initialised via [init] before use.
class NetworkInsightService extends BaseOPNsenseService {
  // ── NetFlow status ──────────────────────────────────────────────────────────

  /// Returns whether NetFlow and local data collection are enabled.
  Future<NetflowStatus> checkNetflowEnabled() async {
    ensureInitialized();
    try {
      final response = await dio.get(ApiEndpoints.netflowIsEnabled);
      return NetflowStatus.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  // ── Interfaces ──────────────────────────────────────────────────────────────

  /// Returns a map of interface identifier → human-readable label.
  ///
  /// Example: `{'pppoe1': 'wan', 'vtnet1': 'lan', 'lo0': 'Loopback'}`.
  Future<Map<String, String>> getInterfaces() async {
    ensureInitialized();
    try {
      final response = await dio.get(ApiEndpoints.networkInsightGetInterfaces);
      final data = response.data as Map<String, dynamic>;
      return data.map((k, v) => MapEntry(k, v.toString()));
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  // ── Time-series ─────────────────────────────────────────────────────────────

  /// Returns interface-level bandwidth time-series data (bits/sec).
  ///
  /// Each returned [NetworkInsightSeries] covers one interface+direction pair.
  Future<List<NetworkInsightSeries>> getTimeseries({
    required int startTs,
    required int endTs,
    required int resolution,
  }) async {
    ensureInitialized();
    try {
      final path = ApiEndpoints.networkInsightTimeserie(
        aggregator: 'FlowInterfaceTotals',
        measure: 'bps',
        startTs: startTs,
        endTs: endTs,
        resolution: resolution,
        dimensions: 'if,direction',
      );
      final response = await dio.get(path);
      final list = response.data as List<dynamic>;
      return list
          .map((e) => NetworkInsightSeries.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  // ── Top-N breakdowns ────────────────────────────────────────────────────────

  /// Returns the top destination ports (by octets) for the given [interface].
  ///
  /// The last entry in the result (where [NetworkInsightTopPort.isOther] is
  /// true) represents the aggregate "Other" traffic not in the top N.
  Future<List<NetworkInsightTopPort>> getTopPorts({
    required String interface,
    required int startTs,
    required int endTs,
  }) async {
    ensureInitialized();
    try {
      final path = ApiEndpoints.networkInsightTop(
        aggregator: 'FlowDstPortTotals',
        startTs: startTs,
        endTs: endTs,
        dimensions: 'dst_port,protocol',
        measure: 'octets',
        limit: 25,
      );
      final response = await dio.get(
        path,
        queryParameters: {
          'filter_field': 'if',
          'filter_value': interface,
        },
      );
      final list = response.data as List<dynamic>;
      return list
          .map((e) => NetworkInsightTopPort.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Returns the top source addresses (by octets) for the given [interface].
  ///
  /// The last entry in the result (where [NetworkInsightTopAddr.isOther] is
  /// true) represents the aggregate "Other" traffic not in the top N.
  Future<List<NetworkInsightTopAddr>> getTopAddresses({
    required String interface,
    required int startTs,
    required int endTs,
  }) async {
    ensureInitialized();
    try {
      final path = ApiEndpoints.networkInsightTop(
        aggregator: 'FlowSourceAddrTotals',
        startTs: startTs,
        endTs: endTs,
        dimensions: 'src_addr',
        measure: 'octets',
        limit: 25,
      );
      final response = await dio.get(
        path,
        queryParameters: {
          'filter_field': 'if',
          'filter_value': interface,
        },
      );
      final list = response.data as List<dynamic>;
      return list
          .map((e) =>
              NetworkInsightTopAddr.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  // ── DNS reverse lookup ──────────────────────────────────────────────────────

  /// Resolves a list of IP addresses to hostnames via OPNsense DNS.
  ///
  /// Returns a map of `ip → hostname`. Addresses that cannot be resolved
  /// are echoed back as-is (the API does this automatically).
  Future<Map<String, String>> reverseLookup(List<String> addresses) async {
    ensureInitialized();
    try {
      final response = await dio.get(
        ApiEndpoints.diagnosticsDnsReverseLookup,
        queryParameters: {
          'address[]': addresses,
        },
      );
      final data = response.data as Map<String, dynamic>;
      return data.map((k, v) => MapEntry(k, v.toString()));
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  // ── Flow details ────────────────────────────────────────────────────────────

  /// Returns per-flow details using the `FlowSourceAddrDetails` aggregator.
  ///
  /// The [interface] is always applied as a server-side filter.
  /// Optional [extraFilterField] / [extraFilterValue] add a second comma-joined
  /// server-side filter (e.g. `service_port` / `41127` for a port drilldown,
  /// or `src_addr` / `162.196.24.123` for an address drilldown).
  /// Optional [dstPort], [dstAddr], and [srcAddr] are applied client-side for
  /// the manual form filters.
  Future<List<InsightFlowDetail>> getFlowDetails({
    required int startTs,
    required int endTs,
    required String interface,
    String? extraFilterField,
    String? extraFilterValue,
    String? dstPort,
    String? dstAddr,
    String? srcAddr,
  }) async {
    ensureInitialized();
    try {
      final path = ApiEndpoints.networkInsightTop(
        aggregator: 'FlowSourceAddrDetails',
        startTs: startTs,
        endTs: endTs,
        dimensions: 'service_port,protocol,if,src_addr,dst_addr',
        measure: 'octets',
        limit: 100,
      );

      // Build filter_field / filter_value query params.
      // The API accepts comma-separated values for multiple filters.
      Map<String, String>? queryParams;
      if (interface.isNotEmpty) {
        if (extraFilterField != null && extraFilterField.isNotEmpty &&
            extraFilterValue != null && extraFilterValue.isNotEmpty) {
          queryParams = {
            'filter_field': 'if,$extraFilterField',
            'filter_value': '$interface,$extraFilterValue',
          };
        } else {
          queryParams = {
            'filter_field': 'if',
            'filter_value': interface,
          };
        }
      }

      final response = await dio.get(path, queryParameters: queryParams);
      final list = response.data as List<dynamic>;
      var rows = list
          .map((e) => InsightFlowDetail.fromJson(e as Map<String, dynamic>))
          .toList();

      // Apply client-side filters from the manual form — always keep the
      // "Other" sentinel row so callers can compute percentages.
      if (dstPort != null && dstPort.isNotEmpty) {
        rows = rows
            .where((r) => r.isOther || r.servicePort.contains(dstPort))
            .toList();
      }
      if (dstAddr != null && dstAddr.isNotEmpty) {
        rows = rows
            .where((r) => r.isOther || r.dstAddr.contains(dstAddr))
            .toList();
      }
      if (srcAddr != null && srcAddr.isNotEmpty) {
        rows = rows
            .where((r) => r.isOther || r.srcAddr.contains(srcAddr))
            .toList();
      }

      return rows;
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  // ── Direction totals ─────────────────────────────────────────────────────────

  /// Returns in/out totals for the given [interface].
  ///
  /// [measure] should be either `'octets'` (bytes) or `'packets'`.
  Future<List<NetworkInsightDirectionTotal>> getDirectionTotals({
    required String interface,
    required int startTs,
    required int endTs,
    required String measure,
  }) async {
    ensureInitialized();
    try {
      final path = ApiEndpoints.networkInsightTop(
        aggregator: 'FlowInterfaceTotals',
        startTs: startTs,
        endTs: endTs,
        dimensions: 'direction',
        measure: measure,
        limit: 25,
      );
      final response = await dio.get(
        path,
        queryParameters: {
          'filter_field': 'if',
          'filter_value': interface,
        },
      );
      final list = response.data as List<dynamic>;
      return list
          .map((e) => NetworkInsightDirectionTotal.fromJson(
                e as Map<String, dynamic>,
              ))
          .toList();
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  // ── CSV Export ─────────────────────────────────────────────────────────────

  /// Exports NetFlow data as a CSV string for the given parameters.
  ///
  /// [collection] is one of `FlowSourceAddrDetails`, `FlowSourceAddrTotals`,
  /// `FlowDstPortTotals`, `FlowInterfaceTotals`.
  /// [fromTs] and [toTs] are epoch timestamps in seconds.
  /// [resolution] is the bucket resolution in seconds (typically 86400).
  Future<String> exportNetflowData({
    required String collection,
    required int fromTs,
    required int toTs,
    required int resolution,
  }) async {
    ensureInitialized();
    try {
      final path = ApiEndpoints.networkInsightExport(
        collection: collection,
        fromTs: fromTs,
        toTs: toTs,
        resolution: resolution,
      );
      final response = await dio.get<String>(
        path,
        options: Options(responseType: ResponseType.plain),
      );
      return response.data ?? '';
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }
}
