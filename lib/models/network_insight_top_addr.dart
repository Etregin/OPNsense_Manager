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

part 'network_insight_top_addr.g.dart';

/// One entry from the `FlowSourceAddrTotals` top-N breakdown.
///
/// The entry with an empty [srcAddr] represents the "Other" aggregate of all
/// traffic not included in the top N.
@JsonSerializable()
class NetworkInsightTopAddr {
  @JsonKey(name: 'src_addr')
  final String srcAddr;

  final double total;

  @JsonKey(name: 'last_seen')
  final dynamic lastSeen;

  const NetworkInsightTopAddr({
    required this.srcAddr,
    required this.total,
    this.lastSeen,
  });

  /// `true` when this entry is the catch-all "Other" aggregate row.
  bool get isOther => srcAddr.isEmpty;

  factory NetworkInsightTopAddr.fromJson(Map<String, dynamic> json) =>
      _$NetworkInsightTopAddrFromJson(json);

  Map<String, dynamic> toJson() => _$NetworkInsightTopAddrToJson(this);
}
