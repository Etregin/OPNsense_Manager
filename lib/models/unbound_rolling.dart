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

part 'unbound_rolling.g.dart';

@JsonSerializable()
class UnboundRollingPoint {
  final double timestamp;
  final int total;
  final int passed;
  final int blocked;
  final int dropped;
  final int resolved;
  final int local;
  final int cached;

  const UnboundRollingPoint({
    required this.timestamp,
    required this.total,
    required this.passed,
    required this.blocked,
    required this.dropped,
    required this.resolved,
    required this.local,
    required this.cached,
  });

  factory UnboundRollingPoint.fromJson(Map<String, dynamic> json) =>
      _$UnboundRollingPointFromJson(json);

  Map<String, dynamic> toJson() => _$UnboundRollingPointToJson(this);
}

@JsonSerializable()
class UnboundClientHit {
  final String ip;
  final int count;
  final String hostname;

  const UnboundClientHit({
    required this.ip,
    required this.count,
    required this.hostname,
  });

  factory UnboundClientHit.fromJson(Map<String, dynamic> json) =>
      _$UnboundClientHitFromJson(json);

  Map<String, dynamic> toJson() => _$UnboundClientHitToJson(this);
}

@JsonSerializable()
class UnboundRollingClientPoint {
  final double timestamp;
  final List<UnboundClientHit> clients;

  const UnboundRollingClientPoint({
    required this.timestamp,
    required this.clients,
  });

  factory UnboundRollingClientPoint.fromJson(Map<String, dynamic> json) =>
      _$UnboundRollingClientPointFromJson(json);

  Map<String, dynamic> toJson() => _$UnboundRollingClientPointToJson(this);
}
