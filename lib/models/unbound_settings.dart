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

part 'unbound_settings.g.dart';

@JsonSerializable()
class UnboundGeneralSettings {
  @JsonKey(fromJson: _parseBool)
  final bool enabled;
  @JsonKey(fromJson: _parseBool)
  final bool stats;
  final String? port;

  const UnboundGeneralSettings({
    this.enabled = true,
    this.stats = false,
    this.port,
  });

  static bool _parseBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is num) return value == 1;
    final str = value.toString().trim();
    return str == '1' || str.toLowerCase() == 'true';
  }

  factory UnboundGeneralSettings.fromJson(Map<String, dynamic> json) =>
      _$UnboundGeneralSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$UnboundGeneralSettingsToJson(this);
}

class UnboundSettings {
  final UnboundGeneralSettings? general;

  const UnboundSettings({
    this.general,
  });

  factory UnboundSettings.fromJson(Map<String, dynamic> json) {
    final unboundMap = json['unbound'] is Map<String, dynamic>
        ? json['unbound'] as Map<String, dynamic>
        : json;
    final generalMap = unboundMap['general'] is Map<String, dynamic>
        ? unboundMap['general'] as Map<String, dynamic>
        : null;

    return UnboundSettings(
      general: generalMap != null ? UnboundGeneralSettings.fromJson(generalMap) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'unbound': {
      if (general != null) 'general': general!.toJson(),
    },
  };
}
