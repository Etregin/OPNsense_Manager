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

part 'tailscale_status.g.dart';

/// Represents the status and configuration of Tailscale VPN
@JsonSerializable()
class TailscaleStatus {
  // Authentication fields
  final bool authenticated;
  @JsonKey(name: 'login_state')
  final String? loginState;
  @JsonKey(name: 'auth_url')
  final String? authUrl;
  final String? tailnet;
  final String? user;
  @JsonKey(name: 'device_name')
  final String? deviceName;
  @JsonKey(name: 'login_server')
  final String? loginServer;
  @JsonKey(name: 'pre_auth_key')
  final String? preAuthKey;

  // Settings fields
  @JsonKey(name: 'accept_routes')
  final bool acceptRoutes;
  @JsonKey(name: 'advertise_routes')
  final String? advertiseRoutes;
  @JsonKey(name: 'exit_node')
  final String? exitNode;
  @JsonKey(name: 'use_exit_node')
  final bool useExitNode;
  @JsonKey(name: 'dns_enabled')
  final bool dnsEnabled;
  @JsonKey(name: 'magic_dns')
  final bool magicDns;
  @JsonKey(name: 'ssh_enabled')
  final bool sshEnabled;
  final List<String> tags;
  final String? hostname;

  // Status fields
  @JsonKey(name: 'service_running')
  final bool serviceRunning;
  @JsonKey(name: 'backend_state')
  final String backendState;
  final List<String> ips;
  @JsonKey(name: 'bytes_received')
  final int? bytesReceived;
  @JsonKey(name: 'bytes_sent')
  final int? bytesSent;
  @JsonKey(name: 'connected_since')
  final DateTime? connectedSince;
  final String? health;
  @JsonKey(name: 'peers_count')
  final int peersCount;
  final String? version;

  TailscaleStatus({
    required this.authenticated,
    this.loginState,
    this.authUrl,
    this.tailnet,
    this.user,
    this.deviceName,
    this.loginServer,
    this.preAuthKey,
    this.acceptRoutes = false,
    this.advertiseRoutes,
    this.exitNode,
    this.useExitNode = false,
    this.dnsEnabled = false,
    this.magicDns = false,
    this.sshEnabled = false,
    this.tags = const [],
    this.hostname,
    required this.serviceRunning,
    this.backendState = 'Stopped',
    this.ips = const [],
    this.bytesReceived,
    this.bytesSent,
    this.connectedSince,
    this.health,
    this.peersCount = 0,
    this.version,
  });

  /// Check if Tailscale is connected
  bool get isConnected => 
      serviceRunning && 
      authenticated && 
      backendState.toLowerCase() == 'running';

  /// Check if authentication is needed
  bool get needsAuth => !authenticated && authUrl != null;

  /// Get status display string
  String get statusDisplay {
    if (!serviceRunning) return 'Service Stopped';
    if (!authenticated) return 'Not Authenticated';
    if (backendState.toLowerCase() == 'running') return 'Connected';
    return backendState;
  }

  /// Get health status display
  String get healthDisplay {
    if (health == null || health!.isEmpty) return 'Healthy';
    return health!;
  }

  /// Check if health is good
  bool get isHealthy => health == null || health!.isEmpty;

  factory TailscaleStatus.fromJson(Map<String, dynamic> json) =>
      _$TailscaleStatusFromJson(json);

  Map<String, dynamic> toJson() => _$TailscaleStatusToJson(this);

  @override
  String toString() => 
      'TailscaleStatus(authenticated: $authenticated, serviceRunning: $serviceRunning, backendState: $backendState)';
}


