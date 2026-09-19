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

part 'disk_device.g.dart';

/// Represents a single mounted filesystem entry returned by
/// `GET /api/diagnostics/system/system_disk`.
///
/// Example API entry:
/// ```json
/// {
///   "device": "zroot/ROOT/default",
///   "type": "zfs",
///   "blocks": "27G",
///   "used": "1.8G",
///   "available": "25G",
///   "used_pct": 7,
///   "mountpoint": "/"
/// }
/// ```
@JsonSerializable()
class DiskDevice {
  /// Device name, e.g. `zroot/ROOT/default` or `/dev/gpt/efiboot0`.
  final String device;

  /// Filesystem type, e.g. `zfs` or `msdosfs`.
  final String type;

  /// Total size as a human-readable string, e.g. `"27G"`.
  final String blocks;

  /// Used space as a human-readable string, e.g. `"1.8G"`.
  final String used;

  /// Available space as a human-readable string, e.g. `"25G"`.
  final String available;

  /// Used percentage as an integer, e.g. `7`.
  @JsonKey(name: 'used_pct')
  final int usedPct;

  /// Mount point path, e.g. `"/"` or `"/var/log"`.
  final String mountpoint;

  const DiskDevice({
    required this.device,
    required this.type,
    required this.blocks,
    required this.used,
    required this.available,
    required this.usedPct,
    required this.mountpoint,
  });

  factory DiskDevice.fromJson(Map<String, dynamic> json) =>
      _$DiskDeviceFromJson(json);

  Map<String, dynamic> toJson() => _$DiskDeviceToJson(this);
}
