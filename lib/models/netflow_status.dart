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

part 'netflow_status.g.dart';

/// Response model for `GET /diagnostics/netflow/is_enabled`.
///
/// Both [netflow] and [local] must equal `1` for data collection to be active.
@JsonSerializable()
class NetflowStatus {
  /// `1` when the NetFlow daemon is enabled, `0` otherwise.
  final int netflow;

  /// `1` when local data collection is enabled, `0` otherwise.
  final int local;

  const NetflowStatus({
    required this.netflow,
    required this.local,
  });

  /// Returns `true` when both netflow and local collection are enabled.
  bool get isEnabled => netflow == 1 && local == 1;

  factory NetflowStatus.fromJson(Map<String, dynamic> json) =>
      _$NetflowStatusFromJson(json);

  Map<String, dynamic> toJson() => _$NetflowStatusToJson(this);
}
