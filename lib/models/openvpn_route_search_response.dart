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

import 'openvpn_route.dart';

/// Response model for OpenVPN route search API
class OpenvpnRouteSearchResponse {
  final int total;
  final int rowCount;
  final int current;
  final List<OpenvpnRoute> rows;

  OpenvpnRouteSearchResponse({
    required this.total,
    required this.rowCount,
    required this.current,
    required this.rows,
  });

  factory OpenvpnRouteSearchResponse.fromJson(Map<String, dynamic> json) {
    return OpenvpnRouteSearchResponse(
      total: json['total'] as int,
      rowCount: json['rowCount'] as int,
      current: json['current'] as int,
      rows: (json['rows'] as List<dynamic>)
          .map((item) => OpenvpnRoute.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'rowCount': rowCount,
      'current': current,
      'rows': rows.map((route) => route.toJson()).toList(),
    };
  }
}

// Made with Bob
