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

part 'insight_flow_detail.g.dart';

/// One entry from the `FlowSourceAddrDetails` top-N breakdown.
///
/// The entry with an empty [servicePort] and [protocol] represents the
/// aggregate "Other" traffic not included in the top N.
@JsonSerializable()
class InsightFlowDetail {
  @JsonKey(name: 'service_port')
  final String servicePort;

  final String protocol;

  @JsonKey(name: 'if')
  final String interface;

  @JsonKey(name: 'src_addr')
  final String srcAddr;

  @JsonKey(name: 'dst_addr')
  final String dstAddr;

  final int total;

  /// Unix timestamp of the last seen packet, or an empty string for the
  /// "Other" aggregate row.
  @JsonKey(name: 'last_seen')
  final dynamic lastSeen;

  /// Human-readable last-seen datetime string, e.g. `"2026-09-07 13:30:19"`.
  @JsonKey(name: 'last_seen_str')
  final String? lastSeenStr;

  /// Human-readable label combining service name and protocol,
  /// e.g. `"https (tcp)"` or `"41127 (tcp)"`.
  final String label;

  const InsightFlowDetail({
    required this.servicePort,
    required this.protocol,
    required this.interface,
    required this.srcAddr,
    required this.dstAddr,
    required this.total,
    this.lastSeen,
    this.lastSeenStr,
    required this.label,
  });

  /// `true` when this entry is the catch-all "Other" aggregate row.
  bool get isOther => servicePort.isEmpty && protocol.isEmpty;

  factory InsightFlowDetail.fromJson(Map<String, dynamic> json) =>
      _$InsightFlowDetailFromJson(json);

  Map<String, dynamic> toJson() => _$InsightFlowDetailToJson(this);
}
