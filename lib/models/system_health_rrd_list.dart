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

part 'system_health_rrd_list.g.dart';

/// Response model for `GET /api/diagnostics/systemhealth/get_rrd_list`.
///
/// [data] preserves the API-returned category order; each value is the
/// ordered list of subjects for that category.
///
/// [files] lists RRD backing files as `{key, filename}` pairs.
///
/// [interfaces] maps interface identifiers to their descriptions.
@JsonSerializable(explicitToJson: true)
class SystemHealthRrdList {
  /// Category → ordered subject list. Example:
  /// `{"packets": ["ipsec", "lan", "wan"], "system": ["memory", "processor"]}`.
  /// Insertion order is preserved by Dart's LinkedHashMap.
  final Map<String, List<String>> data;

  /// RRD file metadata entries.
  final List<SystemHealthRrdFile> files;

  /// Interface metadata keyed by interface identifier (e.g. `"wan"`, `"opt1"`).
  final Map<String, SystemHealthInterface> interfaces;

  const SystemHealthRrdList({
    required this.data,
    required this.files,
    required this.interfaces,
  });

  /// Ordered list of categories as they appear in [data].
  List<String> get categories => data.keys.toList();

  /// Returns subjects for [category], or an empty list if unknown.
  List<String> subjectsFor(String category) => data[category] ?? const [];

  factory SystemHealthRrdList.fromJson(Map<String, dynamic> json) =>
      _$SystemHealthRrdListFromJson(json);

  /// Safe variant of [fromJson] that tolerates the empty-data response.
  ///
  /// When OPNsense has no RRD data (e.g. after a full reset via the GUI) the
  /// `get_rrd_list` API returns `"data": []` (a JSON array) instead of
  /// `"data": {}`.  The generated `_$SystemHealthRrdListFromJson` performs a
  /// hard cast `json['data'] as Map<String, dynamic>` which would throw at
  /// runtime.  This factory normalises `data` to `{}` whenever it is not
  /// already a map, so the generated code always receives a valid type.
  factory SystemHealthRrdList.fromJsonSafe(Map<String, dynamic> json) {
    final raw = json['data'];
    if (raw is! Map) {
      json = Map<String, dynamic>.from(json)..['data'] = <String, dynamic>{};
    }
    return _$SystemHealthRrdListFromJson(json);
  }

  Map<String, dynamic> toJson() => _$SystemHealthRrdListToJson(this);
}

/// A single RRD backing-file entry from the `files` array.
///
/// Example: `{"key": "ipsec-packets", "filename": "ipsec-packets.rrd"}`.
@JsonSerializable()
class SystemHealthRrdFile {
  final String key;
  final String filename;

  const SystemHealthRrdFile({required this.key, required this.filename});

  factory SystemHealthRrdFile.fromJson(Map<String, dynamic> json) =>
      _$SystemHealthRrdFileFromJson(json);

  Map<String, dynamic> toJson() => _$SystemHealthRrdFileToJson(this);
}

/// Interface description entry from the `interfaces` map.
///
/// Example value: `{"descr": "WAN2_MIFI"}`.
@JsonSerializable()
class SystemHealthInterface {
  /// Human-readable description for the interface (e.g. `"WAN2_MIFI"`).
  final String descr;

  const SystemHealthInterface({required this.descr});

  factory SystemHealthInterface.fromJson(Map<String, dynamic> json) =>
      _$SystemHealthInterfaceFromJson(json);

  Map<String, dynamic> toJson() => _$SystemHealthInterfaceToJson(this);
}
