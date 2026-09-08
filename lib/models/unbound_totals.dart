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

part 'unbound_totals.g.dart';

@JsonSerializable()
class UnboundTotalCategory {
  final int total;
  @JsonKey(fromJson: _parseDouble)
  final double pcnt;

  const UnboundTotalCategory({
    required this.total,
    required this.pcnt,
  });

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }

  factory UnboundTotalCategory.fromJson(Map<String, dynamic> json) =>
      _$UnboundTotalCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$UnboundTotalCategoryToJson(this);
}

@JsonSerializable()
class UnboundDomainStat {
  final String domain;
  final int total;
  @JsonKey(fromJson: _parseDouble)
  final double pcnt;

  const UnboundDomainStat({
    required this.domain,
    required this.total,
    required this.pcnt,
  });

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }

  factory UnboundDomainStat.fromJson(Map<String, dynamic> json) =>
      _$UnboundDomainStatFromJson(json);

  Map<String, dynamic> toJson() => _$UnboundDomainStatToJson(this);
}

@JsonSerializable()
class UnboundTotals {
  final int total;
  @JsonKey(name: 'blocklist_size')
  final int blocklistSize;
  final int passed;
  final UnboundTotalCategory? resolved;
  final UnboundTotalCategory? blocked;
  final UnboundTotalCategory? local;
  @JsonKey(name: 'start_time')
  final int? startTime;
  @JsonKey(fromJson: _parseDomainStats)
  final List<UnboundDomainStat> top;
  @JsonKey(name: 'top_blocked', fromJson: _parseDomainStats)
  final List<UnboundDomainStat> topBlocked;

  const UnboundTotals({
    required this.total,
    required this.blocklistSize,
    required this.passed,
    this.resolved,
    this.blocked,
    this.local,
    this.startTime,
    this.top = const [],
    this.topBlocked = const [],
  });

  static List<UnboundDomainStat> _parseDomainStats(dynamic value) {
    if (value == null) return [];
    if (value is Map<String, dynamic>) {
      final list = <UnboundDomainStat>[];
      value.forEach((domain, data) {
        if (data is Map<String, dynamic>) {
          list.add(UnboundDomainStat(
            domain: domain,
            total: (data['total'] as num?)?.toInt() ?? 0,
            pcnt: UnboundTotalCategory._parseDouble(data['pcnt']),
          ));
        }
      });
      return list;
    }
    if (value is List) {
      final list = <UnboundDomainStat>[];
      for (final item in value) {
        if (item is Map<String, dynamic>) {
          list.add(UnboundDomainStat.fromJson(item));
        }
      }
      return list;
    }
    return [];
  }

  factory UnboundTotals.fromJson(Map<String, dynamic> json) =>
      _$UnboundTotalsFromJson(json);

  Map<String, dynamic> toJson() => _$UnboundTotalsToJson(this);
}
