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

/// Model representing an OpenVPN route
class OpenvpnRoute {
  final String? id;
  final String? network;
  final String? gateway;
  final String? description;

  OpenvpnRoute({
    this.id,
    this.network,
    this.gateway,
    this.description,
  });

  factory OpenvpnRoute.fromJson(Map<String, dynamic> json) {
    return OpenvpnRoute(
      id: json['id'] as String?,
      network: json['network'] as String?,
      gateway: json['gateway'] as String?,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'network': network,
      'gateway': gateway,
      'description': description,
    };
  }
}

// Made with Bob
