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
import 'wireguard_peer_status.dart';

part 'wireguard_status.g.dart';

/// Represents runtime status of a WireGuard instance
@JsonSerializable()
class WireGuardStatus {
  /// Instance UUID
  final String uuid;
  
  /// Instance type: 'server' or 'client'
  final String type;
  
  /// Instance name
  final String name;
  
  /// Configuration enabled status ("1" = enabled, "0" = disabled)
  final String enabled;
  
  /// Currently running status ("1" = running, "0" = stopped)
  final String running;
  
  /// Total bytes received (optional)
  @JsonKey(name: 'bytes_received')
  final String? bytesReceived;
  
  /// Total bytes sent (optional)
  @JsonKey(name: 'bytes_sent')
  final String? bytesSent;
  
  /// Connection timestamp in Unix epoch seconds (optional)
  @JsonKey(name: 'connected_since')
  final String? connectedSince;
  
  /// Last successful handshake timestamp in Unix epoch seconds (optional)
  @JsonKey(name: 'last_handshake')
  final String? lastHandshake;
  
  /// Connected peers status (for servers, optional)
  @JsonKey(defaultValue: [])
  final List<WireGuardPeerStatus> peers;

  WireGuardStatus({
    required this.uuid,
    required this.type,
    required this.name,
    required this.enabled,
    required this.running,
    this.bytesReceived,
    this.bytesSent,
    this.connectedSince,
    this.lastHandshake,
    this.peers = const [],
  });

  /// Check if instance is enabled
  bool get isEnabled => enabled == "1";
  
  /// Check if instance is currently running
  bool get isRunning => running == "1";
  
  /// Check if instance is a server
  bool get isServer => type.toLowerCase() == 'server';
  
  /// Check if instance is a client
  bool get isClient => type.toLowerCase() == 'client';
  
  /// Get bytes received as integer
  int? get bytesReceivedValue {
    if (bytesReceived == null) return null;
    return int.tryParse(bytesReceived!);
  }
  
  /// Get bytes sent as integer
  int? get bytesSentValue {
    if (bytesSent == null) return null;
    return int.tryParse(bytesSent!);
  }
  
  /// Get connection timestamp as DateTime
  DateTime? get connectedSinceDateTime {
    if (connectedSince == null) return null;
    final timestamp = int.tryParse(connectedSince!);
    if (timestamp == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  }
  
  /// Get last handshake timestamp as DateTime
  DateTime? get lastHandshakeDateTime {
    if (lastHandshake == null) return null;
    final timestamp = int.tryParse(lastHandshake!);
    if (timestamp == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  }
  
  /// Get number of connected peers (for servers)
  int get connectedPeerCount => peers.length;

  factory WireGuardStatus.fromJson(Map<String, dynamic> json) =>
      _$WireGuardStatusFromJson(json);

  Map<String, dynamic> toJson() => _$WireGuardStatusToJson(this);

  @override
  String toString() => 'WireGuardStatus(uuid: $uuid, name: $name, type: $type, running: $isRunning)';
}


