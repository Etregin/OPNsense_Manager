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

/// Represents a single WireGuard status item from the API response
@JsonSerializable()
class WireGuardStatusItem {
  /// Interface name (e.g., "wg0")
  @JsonKey(name: 'if')
  final String? interfaceName;
  
  /// Type: "interface" or "peer"
  final String? type;
  
  /// Public key (may be "(none)" for interfaces without keys)
  @JsonKey(name: 'public-key')
  final String? publicKey;
  
  /// Listen port for the interface (only present on "interface" rows, not peers)
  @JsonKey(name: 'listen-port')
  final String? listenPort;
  
  /// Firewall mark setting (only present on "interface" rows, not peers)
  final String? fwmark;
  
  /// Endpoint (same as listen-port for interfaces)
  final String? endpoint;
  
  /// Status: "up" or "down" (only present on "interface" rows, not peers)
  final String? status;
  
  /// Name/description (may be empty)
  final String? name;
  
  /// Latest handshake age in seconds (numeric value or null)
  @JsonKey(name: 'latest-handshake-age')
  final int? latestHandshakeAge;
  
  /// Latest handshake epoch as formatted date string (e.g., "2026-06-06 12:53:56")
  @JsonKey(name: 'latest-handshake-epoch')
  final String? latestHandshakeEpoch;
  
  /// Peer status: "online" or "offline"
  @JsonKey(name: 'peer-status')
  final String? peerStatus;
  
  /// Interface friendly name
  final String? ifname;

  WireGuardStatusItem({
    this.interfaceName,
    this.type,
    this.publicKey,
    this.listenPort,
    this.fwmark,
    this.endpoint,
    this.status,
    this.name,
    this.latestHandshakeAge,
    this.latestHandshakeEpoch,
    this.peerStatus,
    this.ifname,
  });

  /// Check if the interface/peer is up
  bool get isUp => status?.toLowerCase() == 'up';
  
  /// Check if this is an interface (not a peer)
  bool get isInterface => type?.toLowerCase() == 'interface';
  
  /// Check if this is a peer
  bool get isPeer => type?.toLowerCase() == 'peer';
  
  /// Check if peer is online
  bool get isOnline => peerStatus?.toLowerCase() == 'online';
  
  /// Get listen port as integer
  int get listenPortNumber => int.tryParse(listenPort ?? '') ?? 0;
  
  /// Get latest handshake as DateTime (null if not available)
  DateTime? get latestHandshakeDateTime {
    if (latestHandshakeEpoch == null) return null;
    try {
      // Parse the date string format: "2026-06-06 12:53:56"
      return DateTime.parse(latestHandshakeEpoch!.replaceFirst(' ', 'T'));
    } catch (e) {
      return null;
    }
  }
  
  /// Check if public key is set (not "(none)")
  bool get hasPublicKey => publicKey != null && publicKey != '(none)' && publicKey!.isNotEmpty;

  factory WireGuardStatusItem.fromJson(Map<String, dynamic> json) =>
      _$WireGuardStatusItemFromJson(json);

  Map<String, dynamic> toJson() => _$WireGuardStatusItemToJson(this);

  @override
  String toString() =>
      'WireGuardStatusItem(if: $interfaceName, type: $type, status: $status, ifname: $ifname)';
}

/// Represents the API response from /api/wireguard/service/show
@JsonSerializable()
class WireGuardStatusResponse {
  /// Total number of items
  final int total;
  
  /// Number of rows per page
  final int rowCount;
  
  /// Current page number
  final int current;
  
  /// List of status items
  final List<WireGuardStatusItem> rows;

  WireGuardStatusResponse({
    required this.total,
    required this.rowCount,
    required this.current,
    required this.rows,
  });

  /// Check if there are any items
  bool get hasItems => rows.isNotEmpty;
  
  /// Get all interface items
  List<WireGuardStatusItem> get interfaces =>
      rows.where((item) => item.isInterface).toList();
  
  /// Get all peer items
  List<WireGuardStatusItem> get peers =>
      rows.where((item) => item.isPeer).toList();
  
  /// Get all online items
  List<WireGuardStatusItem> get onlineItems =>
      rows.where((item) => item.isOnline).toList();
  
  /// Get all up interfaces
  List<WireGuardStatusItem> get upInterfaces =>
      rows.where((item) => item.isInterface && item.isUp).toList();

  factory WireGuardStatusResponse.fromJson(Map<String, dynamic> json) =>
      _$WireGuardStatusResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WireGuardStatusResponseToJson(this);

  @override
  String toString() =>
      'WireGuardStatusResponse(total: $total, rows: ${rows.length})';
}

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
  bool get isEnabled => enabled == '1';
  
  /// Check if instance is currently running
  bool get isRunning => running == '1';
  
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


