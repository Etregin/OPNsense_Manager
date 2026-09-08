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

import 'package:json_annotation/json_annotation.dart';

part 'network_insight_direction_total.g.dart';

/// One entry from a `FlowInterfaceTotals` direction breakdown.
///
/// Used for both octets (bytes) and packets summaries.
@JsonSerializable()
class NetworkInsightDirectionTotal {
  /// Traffic direction: `"in"` or `"out"`.
  final String direction;

  /// Total octets or packets for this direction over the queried period.
  final double total;

  @JsonKey(name: 'last_seen')
  final dynamic lastSeen;

  const NetworkInsightDirectionTotal({
    required this.direction,
    required this.total,
    this.lastSeen,
  });

  factory NetworkInsightDirectionTotal.fromJson(Map<String, dynamic> json) =>
      _$NetworkInsightDirectionTotalFromJson(json);

  Map<String, dynamic> toJson() => _$NetworkInsightDirectionTotalToJson(this);
}
