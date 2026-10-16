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

/// Model representing an active OpenVPN route entry.
///
/// Maps the `search_routes` API response fields:
/// `virtual_address`, `common_name`, `real_address`, `last_ref`,
/// `type`, `id`, `description`.
class OpenvpnRoute {
  final String? id;
  final String? virtualAddress;
  final String? commonName;
  final String? realAddress;
  final String? lastRef;
  final String? type;
  final String? description;

  OpenvpnRoute({
    this.id,
    this.virtualAddress,
    this.commonName,
    this.realAddress,
    this.lastRef,
    this.type,
    this.description,
  });

  factory OpenvpnRoute.fromJson(Map<String, dynamic> json) {
    return OpenvpnRoute(
      id: json['id'] as String?,
      virtualAddress: json['virtual_address'] as String?,
      commonName: json['common_name'] as String?,
      realAddress: json['real_address'] as String?,
      lastRef: json['last_ref'] as String?,
      type: json['type'] as String?,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'virtual_address': virtualAddress,
      'common_name': commonName,
      'real_address': realAddress,
      'last_ref': lastRef,
      'type': type,
      'description': description,
    };
  }
}
