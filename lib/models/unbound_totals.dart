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
  @JsonKey(fromJson: _parseInt)
  final int total;
  @JsonKey(fromJson: _parseDouble)
  final double pcnt;

  const UnboundTotalCategory({
    this.total = 0,
    this.pcnt = 0.0,
  });

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }

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
  @JsonKey(defaultValue: '')
  final String domain;
  @JsonKey(fromJson: UnboundTotalCategory._parseInt)
  final int total;
  @JsonKey(fromJson: UnboundTotalCategory._parseDouble)
  final double pcnt;

  const UnboundDomainStat({
    this.domain = '',
    this.total = 0,
    this.pcnt = 0.0,
  });

  factory UnboundDomainStat.fromJson(Map<String, dynamic> json) =>
      _$UnboundDomainStatFromJson(json);

  Map<String, dynamic> toJson() => _$UnboundDomainStatToJson(this);
}

@JsonSerializable()
class UnboundTotals {
  @JsonKey(fromJson: UnboundTotalCategory._parseInt)
  final int total;
  @JsonKey(name: 'blocklist_size', fromJson: UnboundTotalCategory._parseInt)
  final int blocklistSize;
  @JsonKey(fromJson: UnboundTotalCategory._parseInt)
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
    this.total = 0,
    this.blocklistSize = 0,
    this.passed = 0,
    this.resolved,
    this.blocked,
    this.local,
    this.startTime,
    this.top = const [],
    this.topBlocked = const [],
  });

  static List<UnboundDomainStat> _parseDomainStats(dynamic value) {
    if (value == null) return [];
    if (value is Map) {
      final list = <UnboundDomainStat>[];
      value.forEach((domain, data) {
        if (data is Map) {
          list.add(UnboundDomainStat(
            domain: domain.toString(),
            total: UnboundTotalCategory._parseInt(data['total']),
            pcnt: UnboundTotalCategory._parseDouble(data['pcnt']),
          ));
        }
      });
      return list;
    }
    if (value is List) {
      final list = <UnboundDomainStat>[];
      for (final item in value) {
        if (item is Map) {
          final map = item is Map<String, dynamic>
              ? item
              : item.map((k, v) => MapEntry(k.toString(), v));
          list.add(UnboundDomainStat.fromJson(map));
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
