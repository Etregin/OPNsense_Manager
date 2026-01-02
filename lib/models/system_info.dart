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

part 'system_info.g.dart';

/// System information model
@JsonSerializable()
class SystemInfo {
  final String hostname;
  final String version;
  final String platform;
  final int uptime; // in seconds
  final double cpuUsage; // percentage
  final int memoryUsed; // in bytes
  final int memoryTotal; // in bytes
  final int diskUsed; // in bytes
  final int diskTotal; // in bytes
  
  // Additional firmware/system details
  final String type; // e.g., "opnsense"
  final String architecture; // e.g., "amd64"
  final String commit; // e.g., "c2f076f30"
  final String mirror; // e.g., "https://pkg.opnsense.org/..."
  final String repositories; // e.g., "OPNsense (Priority: 11)"
  final String? updatedOn; // Last update timestamp

  SystemInfo({
    required this.hostname,
    required this.version,
    required this.platform,
    required this.uptime,
    required this.cpuUsage,
    required this.memoryUsed,
    required this.memoryTotal,
    this.diskUsed = 0,
    this.diskTotal = 0,
    this.type = 'opnsense',
    this.architecture = 'amd64',
    this.commit = '',
    this.mirror = '',
    this.repositories = '',
    this.updatedOn,
  });

  /// Get memory usage percentage
  double get memoryUsagePercentage {
    if (memoryTotal == 0) return 0;
    return (memoryUsed / memoryTotal) * 100;
  }

  /// Get memory used in GB
  double get memoryUsedGB {
    return memoryUsed / (1024 * 1024 * 1024);
  }

  /// Get memory total in GB
  double get memoryTotalGB {
    return memoryTotal / (1024 * 1024 * 1024);
  }

  /// Get disk usage percentage
  double get diskUsagePercentage {
    if (diskTotal == 0) return 0;
    return (diskUsed / diskTotal) * 100;
  }

  /// Get disk used in GB
  double get diskUsedGB {
    return diskUsed / (1024 * 1024 * 1024);
  }

  /// Get disk total in GB
  double get diskTotalGB {
    return diskTotal / (1024 * 1024 * 1024);
  }

  /// Create from JSON
  factory SystemInfo.fromJson(Map<String, dynamic> json) =>
      _$SystemInfoFromJson(json);

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$SystemInfoToJson(this);

  /// Create a copy with updated fields
  SystemInfo copyWith({
    String? hostname,
    String? version,
    String? platform,
    int? uptime,
    double? cpuUsage,
    int? memoryUsed,
    int? memoryTotal,
    int? diskUsed,
    int? diskTotal,
    String? type,
    String? architecture,
    String? commit,
    String? mirror,
    String? repositories,
    String? updatedOn,
  }) {
    return SystemInfo(
      hostname: hostname ?? this.hostname,
      version: version ?? this.version,
      platform: platform ?? this.platform,
      uptime: uptime ?? this.uptime,
      cpuUsage: cpuUsage ?? this.cpuUsage,
      memoryUsed: memoryUsed ?? this.memoryUsed,
      memoryTotal: memoryTotal ?? this.memoryTotal,
      diskUsed: diskUsed ?? this.diskUsed,
      diskTotal: diskTotal ?? this.diskTotal,
      type: type ?? this.type,
      architecture: architecture ?? this.architecture,
      commit: commit ?? this.commit,
      mirror: mirror ?? this.mirror,
      repositories: repositories ?? this.repositories,
      updatedOn: updatedOn ?? this.updatedOn,
    );
  }

  @override
  String toString() {
    return 'SystemInfo(hostname: $hostname, version: $version, uptime: $uptime)';
  }
}

