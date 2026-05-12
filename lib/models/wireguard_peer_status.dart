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

part 'wireguard_peer_status.g.dart';

/// Represents runtime status of a connected WireGuard peer
@JsonSerializable()
class WireGuardPeerStatus {
  /// Peer's public key (base64 encoded)
  @JsonKey(name: 'public_key')
  final String publicKey;
  
  /// Current peer endpoint (IP:port, optional)
  final String? endpoint;
  
  /// Allowed IP ranges for this peer (comma-separated)
  @JsonKey(name: 'allowed_ips')
  final String allowedIps;
  
  /// Latest handshake timestamp in Unix epoch seconds (optional)
  @JsonKey(name: 'latest_handshake')
  final String? latestHandshake;
  
  /// Bytes received from this peer
  @JsonKey(name: 'transfer_rx')
  final String bytesReceived;
  
  /// Bytes sent to this peer
  @JsonKey(name: 'transfer_tx')
  final String bytesSent;

  WireGuardPeerStatus({
    required this.publicKey,
    this.endpoint,
    required this.allowedIps,
    this.latestHandshake,
    required this.bytesReceived,
    required this.bytesSent,
  });

  /// Get allowed IPs as a list
  List<String> get allowedIpsList {
    if (allowedIps.isEmpty) return [];
    return allowedIps.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
  }
  
  /// Get latest handshake timestamp as DateTime
  DateTime? get latestHandshakeDateTime {
    if (latestHandshake == null) return null;
    final timestamp = int.tryParse(latestHandshake!);
    if (timestamp == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  }
  
  /// Get bytes received as integer
  int get bytesReceivedValue => int.tryParse(bytesReceived) ?? 0;
  
  /// Get bytes sent as integer
  int get bytesSentValue => int.tryParse(bytesSent) ?? 0;
  
  /// Check if peer has recent handshake (within last 3 minutes)
  bool get hasRecentHandshake {
    final handshake = latestHandshakeDateTime;
    if (handshake == null) return false;
    final now = DateTime.now();
    return now.difference(handshake).inMinutes < 3;
  }

  factory WireGuardPeerStatus.fromJson(Map<String, dynamic> json) =>
      _$WireGuardPeerStatusFromJson(json);

  Map<String, dynamic> toJson() => _$WireGuardPeerStatusToJson(this);

  @override
  String toString() => 'WireGuardPeerStatus(publicKey: ${publicKey.substring(0, 8)}..., endpoint: $endpoint)';
}


