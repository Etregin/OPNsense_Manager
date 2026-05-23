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

import 'wireguard_peer.dart';

/// Response model for WireGuard peer GET endpoint
/// Handles the complex nested structure from /api/wireguard/client/get_client/{uuid}
class WireGuardPeerResponse {
  final String enabled;
  final String name;
  final String pubkey;
  final String psk;
  final Map<String, Map<String, dynamic>> tunneladdress;
  final String serveraddress;
  final String serverport;
  final String endpoint;
  final String keepalive;
  final Map<String, Map<String, dynamic>> servers;

  WireGuardPeerResponse({
    required this.enabled,
    required this.name,
    required this.pubkey,
    required this.psk,
    required this.tunneladdress,
    required this.serveraddress,
    required this.serverport,
    required this.endpoint,
    required this.keepalive,
    required this.servers,
  });

  /// Parse from API response JSON
  factory WireGuardPeerResponse.fromJson(Map<String, dynamic> json) {
    return WireGuardPeerResponse(
      enabled: json['enabled'] as String? ?? '0',
      name: json['name'] as String? ?? '',
      pubkey: json['pubkey'] as String? ?? '',
      psk: json['psk'] as String? ?? '',
      tunneladdress: _parseNestedMap(json['tunneladdress']),
      serveraddress: json['serveraddress'] as String? ?? '',
      serverport: json['serverport'] as String? ?? '',
      endpoint: json['endpoint'] as String? ?? '',
      keepalive: json['keepalive'] as String? ?? '',
      servers: _parseNestedMap(json['servers']),
    );
  }

  /// Helper to parse nested map structure
  static Map<String, Map<String, dynamic>> _parseNestedMap(dynamic value) {
    if (value == null) return {};
    if (value is! Map) return {};
    
    final result = <String, Map<String, dynamic>>{};
    (value as Map<String, dynamic>).forEach((key, val) {
      if (val is Map<String, dynamic>) {
        result[key] = val;
      }
    });
    return result;
  }

  /// Extract selected tunnel addresses (where selected=1)
  List<String> getSelectedTunnelAddresses() {
    final selected = <String>[];
    tunneladdress.forEach((address, data) {
      if (data['selected'] == 1 || data['selected'] == '1') {
        selected.add(address);
      }
    });
    return selected;
  }

  /// Extract selected server UUIDs (where selected=1)
  List<String> getSelectedServerUuids() {
    final selected = <String>[];
    servers.forEach((uuid, data) {
      if (data['selected'] == 1 || data['selected'] == '1') {
        selected.add(uuid);
      }
    });
    return selected;
  }

  /// Get server names for selected servers
  Map<String, String> getServerNames() {
    final names = <String, String>{};
    servers.forEach((uuid, data) {
      if (data.containsKey('value')) {
        names[uuid] = data['value'] as String;
      }
    });
    return names;
  }

  /// Convert to simple WireGuardPeer model for editing
  WireGuardPeer toPeer(String uuid) {
    return WireGuardPeer(
      uuid: uuid,
      enabled: enabled,
      name: name,
      pubkey: pubkey,
      psk: psk.isEmpty ? null : psk,
      tunneladdress: getSelectedTunnelAddresses().join(','),
      serveraddress: serveraddress,
      serverport: serverport,
      endpoint: endpoint.isEmpty ? null : endpoint,
      keepalive: keepalive.isEmpty ? null : keepalive,
      servers: getSelectedServerUuids().join(','),
    );
  }

  /// Convert to WireGuardPeerRequest for API submission
  WireGuardPeerRequest toRequest() {
    return WireGuardPeerRequest(
      name: name,
      pubkey: pubkey,
      privkey: '', // Private key not returned by API
      tunneladdress: getSelectedTunnelAddresses().join(','),
      serveraddress: serveraddress,
      serverport: serverport,
      serverpubkey: '', // Server public key not in this response
      enabled: enabled,
      endpoint: endpoint.isEmpty ? null : endpoint,
      servers: getSelectedServerUuids().join(','),
      keepalive: keepalive.isEmpty ? null : keepalive,
      psk: psk.isEmpty ? null : psk,
    );
  }
}

// Made with Bob
