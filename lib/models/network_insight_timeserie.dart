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

part 'network_insight_timeserie.g.dart';

/// One data series from the Network Insight timeserie endpoint.
///
/// The [key] is formatted as `{interfaceId},{direction}` (e.g. `pppoe1,in`).
/// [values] contains `[timestampMs, bps]` pairs.
@JsonSerializable()
class NetworkInsightSeries {
  /// Composite key: `{interfaceId},{direction}`.
  final String key;

  /// Traffic direction: `"in"` or `"out"`.
  final String direction;

  /// Human-readable interface label (e.g. `"wan"`, `"Loopback"`).
  /// Present on some entries; may be null.
  final String? interface;

  /// Time-value pairs: each element is `[timestampMillis, bitsPerSecond]`.
  final List<List<double>> values;

  const NetworkInsightSeries({
    required this.key,
    required this.direction,
    this.interface,
    required this.values,
  });

  /// Extracts the interface identifier portion of [key] (the part before the comma).
  String get interfaceId => key.split(',').first;

  factory NetworkInsightSeries.fromJson(Map<String, dynamic> json) =>
      _$NetworkInsightSeriesFromJson(json);

  Map<String, dynamic> toJson() => _$NetworkInsightSeriesToJson(this);
}
