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

part 'unbound_query_item.g.dart';

@JsonSerializable()
class UnboundQueryItem {
  final String? uuid;
  final int? time;
  final String? client;
  final String? family;
  final String? type;
  final String? domain;
  final String? action;
  final String? source;
  final String? blocklist;
  final String? rcode;
  @JsonKey(name: 'resolve_time_ms')
  final int? resolveTimeMs;
  @JsonKey(name: 'dnssec_status')
  final String? dnssecStatus;
  final int? ttl;
  final String? policy;
  final int? status;

  const UnboundQueryItem({
    this.uuid,
    this.time,
    this.client,
    this.family,
    this.type,
    this.domain,
    this.action,
    this.source,
    this.blocklist,
    this.rcode,
    this.resolveTimeMs,
    this.dnssecStatus,
    this.ttl,
    this.policy,
    this.status,
  });

  factory UnboundQueryItem.fromJson(Map<String, dynamic> json) =>
      _$UnboundQueryItemFromJson(json);

  Map<String, dynamic> toJson() => _$UnboundQueryItemToJson(this);
}

@JsonSerializable()
class UnboundQuerySearchResponse {
  final int total;
  final int rowCount;
  final int current;
  final List<UnboundQueryItem> rows;

  const UnboundQuerySearchResponse({
    required this.total,
    required this.rowCount,
    required this.current,
    required this.rows,
  });

  factory UnboundQuerySearchResponse.fromJson(Map<String, dynamic> json) =>
      _$UnboundQuerySearchResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UnboundQuerySearchResponseToJson(this);
}
