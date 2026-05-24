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

part 'vpn_connection.g.dart';

/// Represents a VPN connection in OPNsense
@JsonSerializable()
class VPNConnection {
  final String id;
  final String name;
  final String type; // 'openvpn', 'wireguard', 'tailscale'
  final String status; // 'up', 'down', 'connecting', 'error'
  final String? description;
  final String? remoteAddress;
  final String? localAddress;
  final String? virtualAddress;
  final int? bytesReceived;
  final int? bytesSent;
  final DateTime? connectedSince;
  final String? protocol;
  final int? port;
  final bool enabled;

  VPNConnection({
    required this.id,
    required this.name,
    required this.type,
    required this.status,
    this.description,
    this.remoteAddress,
    this.localAddress,
    this.virtualAddress,
    this.bytesReceived,
    this.bytesSent,
    this.connectedSince,
    this.protocol,
    this.port,
    this.enabled = true,
  });

  factory VPNConnection.fromJson(Map<String, dynamic> json) =>
      _$VPNConnectionFromJson(json);

  Map<String, dynamic> toJson() => _$VPNConnectionToJson(this);

  bool get isConnected => status.toLowerCase() == 'up' || status.toLowerCase() == 'connected';
  bool get isConnecting => status.toLowerCase() == 'connecting';
  bool get hasError => status.toLowerCase() == 'error' || status.toLowerCase() == 'down';

  String get statusDisplay {
    switch (status.toLowerCase()) {
      case 'up':
      case 'connected':
        return 'Connected';
      case 'down':
        return 'Disconnected';
      case 'connecting':
        return 'Connecting...';
      case 'error':
        return 'Error';
      default:
        return status;
    }
  }

  String get typeDisplay {
    switch (type.toLowerCase()) {
      case 'openvpn':
        return 'OpenVPN';
      case 'wireguard':
        return 'WireGuard';
      case 'tailscale':
        return 'Tailscale';
      default:
        return type;
    }
  }
}

/// Request model for VPN connection operations
@JsonSerializable()
class VPNConnectionRequest {
  final String? name;
  final String? description;
  final bool? enabled;
  final Map<String, dynamic>? config;

  VPNConnectionRequest({
    this.name,
    this.description,
    this.enabled,
    this.config,
  });

  factory VPNConnectionRequest.fromJson(Map<String, dynamic> json) =>
      _$VPNConnectionRequestFromJson(json);

  Map<String, dynamic> toJson() => _$VPNConnectionRequestToJson(this);
}
