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

part 'unbound_overview_status.g.dart';

/// Response model for `GET /api/unbound/overview/is_enabled`.
///
/// Example: `{"enabled": "1"}` or `{"enabled": "0"}` or `{"enabled": 1}`.
@JsonSerializable()
class UnboundOverviewStatus {
  @JsonKey(name: 'enabled', fromJson: _parseEnabled)
  final bool isEnabled;

  const UnboundOverviewStatus({
    required this.isEnabled,
  });

  static bool _parseEnabled(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is num) return value == 1;
    final str = value.toString().trim();
    return str == '1' || str.toLowerCase() == 'true';
  }

  factory UnboundOverviewStatus.fromJson(Map<String, dynamic> json) =>
      _$UnboundOverviewStatusFromJson(json);

  Map<String, dynamic> toJson() => _$UnboundOverviewStatusToJson(this);
}
