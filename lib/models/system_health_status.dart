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

/// Response model for `GET /api/diagnostics/systemhealth/get`.
///
/// Example: `{"systemhealth": {"enabled": "1"}}`.
/// The enabled flag may be a string `"1"`/`"0"`, an integer `1`/`0`,
/// or a boolean — parsed tolerantly following [UnboundOverviewStatus].
class SystemHealthStatus {
  final bool isEnabled;

  const SystemHealthStatus({required this.isEnabled});

  factory SystemHealthStatus.fromJson(Map<String, dynamic> json) {
    final outer = json['systemhealth'];
    if (outer is Map<String, dynamic>) {
      return SystemHealthStatus(isEnabled: _parseEnabled(outer['enabled']));
    }
    return const SystemHealthStatus(isEnabled: false);
  }

  static bool _parseEnabled(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is num) return value == 1;
    final str = value.toString().trim();
    return str == '1' || str.toLowerCase() == 'true';
  }

  Map<String, dynamic> toJson() => {
    'systemhealth': {'enabled': isEnabled ? '1' : '0'},
  };
}
