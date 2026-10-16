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

/// Model representing an OpenVPN session.
///
/// A row either describes a connected client (client fields populated and
/// [id] formatted as `{serverUuid}_{realAddress}`) or the bare VPN daemon
/// (client fields empty and [id] equal to the server UUID).
class OpenvpnSession {
  final String id;
  final String? serviceId;
  final String type;
  final String description;
  final String? socket;
  final String? status;
  final String? commonName;
  final String? username;
  final String? realAddress;
  final String? virtualAddress;
  final String? virtualIpv6Address;
  final int? bytesReceived;
  final int? bytesSent;
  final String? connectedSince;
  final String? clientId;
  final String? peerId;
  final String? dataChannelCipher;
  final bool isClient;

  OpenvpnSession({
    required this.id,
    this.serviceId,
    required this.type,
    required this.description,
    this.socket,
    this.status,
    this.commonName,
    this.username,
    this.realAddress,
    this.virtualAddress,
    this.virtualIpv6Address,
    this.bytesReceived,
    this.bytesSent,
    this.connectedSince,
    this.clientId,
    this.peerId,
    this.dataChannelCipher,
    this.isClient = false,
  });

  factory OpenvpnSession.fromJson(Map<String, dynamic> json) {
    return OpenvpnSession(
      id: json['id'] as String,
      serviceId: json['service_id'] as String?,
      type: json['type'] as String,
      description: json['description'] as String,
      socket: json['socket'] as String?,
      status: json['status'] as String?,
      commonName: json['common_name'] as String?,
      username: json['username'] as String?,
      realAddress: json['real_address'] as String?,
      virtualAddress: json['virtual_address'] as String?,
      virtualIpv6Address: json['virtual_ipv6_address'] as String?,
      bytesReceived: _parseInt(json['bytes_received']),
      bytesSent: _parseInt(json['bytes_sent']),
      connectedSince: json['connected_since'] as String?,
      clientId: json['client_id']?.toString(),
      peerId: json['peer_id']?.toString(),
      dataChannelCipher: json['data_channel_cipher'] as String?,
      isClient: json['is_client'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'service_id': serviceId,
      'type': type,
      'description': description,
      'socket': socket,
      'status': status,
      'common_name': commonName,
      'username': username,
      'real_address': realAddress,
      'virtual_address': virtualAddress,
      'virtual_ipv6_address': virtualIpv6Address,
      'bytes_received': bytesReceived?.toString(),
      'bytes_sent': bytesSent?.toString(),
      'connected_since': connectedSince,
      'client_id': clientId,
      'peer_id': peerId,
      'data_channel_cipher': dataChannelCipher,
      'is_client': isClient,
    };
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }

  /// UUID of the owning VPN instance (the part of [id] before the first `_`)
  String get serverId => id.split('_').first;

  /// Whether this row describes a connected client rather than the bare daemon
  bool get hasClientInfo => commonName != null && commonName!.isNotEmpty;

  /// Identifier OPNsense expects as `session_id` when killing the session
  String? get killSessionId =>
      (username != null && username!.isNotEmpty) ? username : commonName;

  /// Check if the session is running (status is "ok")
  bool get isRunning => status == 'ok';

  /// Check if the session can be started
  bool get canStart => !isRunning;

  /// Check if the session can be stopped or restarted
  bool get canStopOrRestart => isRunning;
}


