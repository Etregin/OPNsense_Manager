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

import 'openvpn_session.dart';

/// Response model for OpenVPN session search API
class OpenvpnSessionSearchResponse {
  final int total;
  final int rowCount;
  final int current;
  final List<OpenvpnSession> rows;

  OpenvpnSessionSearchResponse({
    required this.total,
    required this.rowCount,
    required this.current,
    required this.rows,
  });

  factory OpenvpnSessionSearchResponse.fromJson(Map<String, dynamic> json) {
    return OpenvpnSessionSearchResponse(
      total: json['total'] as int,
      rowCount: json['rowCount'] as int,
      current: json['current'] as int,
      rows: (json['rows'] as List<dynamic>)
          .map((item) => OpenvpnSession.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'rowCount': rowCount,
      'current': current,
      'rows': rows.map((session) => session.toJson()).toList(),
    };
  }
}

// Made with Bob
