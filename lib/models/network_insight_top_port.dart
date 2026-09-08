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

part 'network_insight_top_port.g.dart';

/// One entry from the `FlowDstPortTotals` top-N breakdown.
///
/// The entry with an empty [dstPort] represents the "Other" aggregate of all
/// traffic not included in the top N.
@JsonSerializable()
class NetworkInsightTopPort {
  @JsonKey(name: 'dst_port')
  final String dstPort;

  final String protocol;

  final double total;

  @JsonKey(name: 'last_seen')
  final dynamic lastSeen;

  @JsonKey(name: 'last_seen_str')
  final String? lastSeenStr;

  /// Human-readable label combining port name and protocol, e.g. `"https (tcp)"`.
  final String label;

  const NetworkInsightTopPort({
    required this.dstPort,
    required this.protocol,
    required this.total,
    this.lastSeen,
    this.lastSeenStr,
    required this.label,
  });

  /// `true` when this entry is the catch-all "Other" aggregate row.
  bool get isOther => dstPort.isEmpty && protocol.isEmpty;

  factory NetworkInsightTopPort.fromJson(Map<String, dynamic> json) =>
      _$NetworkInsightTopPortFromJson(json);

  Map<String, dynamic> toJson() => _$NetworkInsightTopPortToJson(this);
}
