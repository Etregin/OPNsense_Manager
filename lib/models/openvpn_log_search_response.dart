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

import 'openvpn_log_entry.dart';

/// Response model for OpenVPN log search API.
class OpenvpnLogSearchResponse {
  final String filters;
  final int totalRows;
  final String? origin;
  final int rowCount;
  final int total;
  final int current;
  final List<OpenvpnLogEntry> rows;

  const OpenvpnLogSearchResponse({
    required this.filters,
    required this.totalRows,
    this.origin,
    required this.rowCount,
    required this.total,
    required this.current,
    required this.rows,
  });

  factory OpenvpnLogSearchResponse.fromJson(Map<String, dynamic> json) {
    return OpenvpnLogSearchResponse(
      filters: json['filters'] as String? ?? '',
      totalRows: json['total_rows'] as int? ?? 0,
      origin: json['origin'] as String?,
      rowCount: json['rowCount'] as int? ?? 0,
      total: json['total'] as int? ?? 0,
      current: json['current'] as int? ?? 1,
      rows: (json['rows'] as List<dynamic>? ?? [])
          .map((item) => OpenvpnLogEntry.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'filters': filters,
      'total_rows': totalRows,
      'origin': origin,
      'rowCount': rowCount,
      'total': total,
      'current': current,
      'rows': rows.map((entry) => entry.toJson()).toList(),
    };
  }
}

// Made with Bob