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

part 'system_health_graph.g.dart';

/// Response model for
/// `GET /api/diagnostics/systemhealth/get_system_health/{key}/{period}`.
///
/// Example:
/// ```json
/// {
///   "step": 60,
///   "lastupdate": 1788859381,
///   "set": { "count": 8, "data": [ ... ] }
/// }
/// ```
@JsonSerializable(explicitToJson: true)
class SystemHealthGraphResponse {
  /// RRD step interval in seconds (e.g. `60`).
  final int step;

  /// Unix timestamp (seconds) of the most recent RRD update.
  final int lastupdate;

  /// Graph title supplied by OPNsense.
  final String title;

  /// Label supplied by OPNsense for the vertical axis.
  @JsonKey(name: 'y-axis_label')
  final String yAxisLabel;

  /// The data set containing all series.
  final SystemHealthDataSet set;

  const SystemHealthGraphResponse({
    required this.step,
    required this.lastupdate,
    this.title = '',
    this.yAxisLabel = '',
    required this.set,
  });

  factory SystemHealthGraphResponse.fromJson(Map<String, dynamic> json) =>
      _$SystemHealthGraphResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SystemHealthGraphResponseToJson(this);
}

/// Container for the series array returned under the `set` key.
@JsonSerializable(explicitToJson: true)
class SystemHealthDataSet {
  /// Number of series in [data].
  final int count;

  /// Ordered list of named data series.
  final List<SystemHealthSeries> data;

  const SystemHealthDataSet({required this.count, required this.data});

  factory SystemHealthDataSet.fromJson(Map<String, dynamic> json) =>
      _$SystemHealthDataSetFromJson(json);

  Map<String, dynamic> toJson() => _$SystemHealthDataSetToJson(this);
}

/// A single named data series within a graph response.
///
/// [key] is the series name (e.g. `"inpass"`, `"outpass"`).
/// [values] is the ordered list of timestamp/value points.
@JsonSerializable()
class SystemHealthSeries {
  /// Series name as returned by the API (e.g. `"inpass"`, `"memory"`).
  final String key;

  /// Ordered time/value points. Parsed from the raw `[[ms, value], ...]`
  /// JSON arrays via [_parsePoints].
  @JsonKey(fromJson: _parsePoints, toJson: _serializePoints)
  final List<SystemHealthPoint> values;

  const SystemHealthSeries({required this.key, required this.values});

  factory SystemHealthSeries.fromJson(Map<String, dynamic> json) =>
      _$SystemHealthSeriesFromJson(json);

  Map<String, dynamic> toJson() => _$SystemHealthSeriesToJson(this);
}

/// One time/value observation in a [SystemHealthSeries].
///
/// [timestampMs] is a Unix epoch in milliseconds (as provided by the API).
/// [value] may be null when the RRD database has no reading for that slot.
class SystemHealthPoint {
  /// Milliseconds since Unix epoch.
  final int timestampMs;

  /// Observed value; null indicates a missing/NaN RRD slot.
  final double? value;

  const SystemHealthPoint({required this.timestampMs, this.value});

  /// Convenience getter: timestamp as a [DateTime] in UTC.
  DateTime get timestamp =>
      DateTime.fromMillisecondsSinceEpoch(timestampMs, isUtc: true);
}

// ---------------------------------------------------------------------------
// Private converters for SystemHealthSeries.values
// ---------------------------------------------------------------------------

List<SystemHealthPoint> _parsePoints(dynamic raw) {
  if (raw is! List) return const [];
  return raw.map((entry) {
    if (entry is! List || entry.isEmpty) {
      return const SystemHealthPoint(timestampMs: 0);
    }
    final tsRaw = entry[0];
    final ts = tsRaw is num ? tsRaw.toInt() : 0;

    if (entry.length < 2) return SystemHealthPoint(timestampMs: ts);

    final vRaw = entry[1];
    final double? v;
    if (vRaw == null) {
      v = null;
    } else if (vRaw is num) {
      v = vRaw.toDouble();
    } else {
      v = double.tryParse(vRaw.toString());
    }
    return SystemHealthPoint(timestampMs: ts, value: v);
  }).toList();
}

List<List<dynamic>> _serializePoints(List<SystemHealthPoint> points) =>
    points.map((p) => <dynamic>[p.timestampMs, p.value]).toList();
