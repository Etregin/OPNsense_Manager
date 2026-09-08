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

/// One entry from `GET /api/diagnostics/netflow/cache_stats`.
///
/// The API returns a map keyed by cache name; each value contains packet and
/// address counters.
class NetflowCacheStat {
  /// Cache entry name (e.g. `"netflow_vtnet1"`).
  final String name;

  /// Interface this cache tracks (e.g. `"vtnet1"`).
  final String interface;

  /// Total packets observed.
  final int packets;

  /// Number of distinct source IP addresses seen.
  final int srcIpAddresses;

  /// Number of distinct destination IP addresses seen.
  final int dstIpAddresses;

  const NetflowCacheStat({
    required this.name,
    required this.interface,
    required this.packets,
    required this.srcIpAddresses,
    required this.dstIpAddresses,
  });

  /// Parses a single cache-stat map entry.
  ///
  /// [name] is the map key; [json] is the value object.
  factory NetflowCacheStat.fromEntry(String name, Map<String, dynamic> json) {
    return NetflowCacheStat(
      name: name,
      interface: (json['if'] as String?) ?? '',
      packets: (json['Pkts'] as num?)?.toInt() ?? 0,
      srcIpAddresses: (json['SrcIPaddresses'] as num?)?.toInt() ?? 0,
      dstIpAddresses: (json['DstIPaddresses'] as num?)?.toInt() ?? 0,
    );
  }

  /// Parses the full cache-stats response map into a list of entries.
  static List<NetflowCacheStat> fromResponse(Map<String, dynamic> json) {
    return json.entries
        .map((e) => NetflowCacheStat.fromEntry(
              e.key,
              e.value as Map<String, dynamic>,
            ))
        .toList();
  }
}
