// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tailscale_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TailscaleStatus _$TailscaleStatusFromJson(Map<String, dynamic> json) =>
    TailscaleStatus(
      authenticated: json['authenticated'] as bool,
      loginState: json['login_state'] as String?,
      authUrl: json['auth_url'] as String?,
      tailnet: json['tailnet'] as String?,
      user: json['user'] as String?,
      deviceName: json['device_name'] as String?,
      loginServer: json['login_server'] as String?,
      preAuthKey: json['pre_auth_key'] as String?,
      acceptRoutes: json['accept_routes'] as bool? ?? false,
      advertiseRoutes: json['advertise_routes'] as String?,
      exitNode: json['exit_node'] as String?,
      useExitNode: json['use_exit_node'] as bool? ?? false,
      dnsEnabled: json['dns_enabled'] as bool? ?? false,
      magicDns: json['magic_dns'] as bool? ?? false,
      sshEnabled: json['ssh_enabled'] as bool? ?? false,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
      hostname: json['hostname'] as String?,
      serviceRunning: json['service_running'] as bool,
      backendState: json['backend_state'] as String? ?? 'Stopped',
      ips:
          (json['ips'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
      bytesReceived: (json['bytes_received'] as num?)?.toInt(),
      bytesSent: (json['bytes_sent'] as num?)?.toInt(),
      connectedSince: json['connected_since'] == null
          ? null
          : DateTime.parse(json['connected_since'] as String),
      health: json['health'] as String?,
      peersCount: (json['peers_count'] as num?)?.toInt() ?? 0,
      version: json['version'] as String?,
    );

Map<String, dynamic> _$TailscaleStatusToJson(TailscaleStatus instance) =>
    <String, dynamic>{
      'authenticated': instance.authenticated,
      'login_state': instance.loginState,
      'auth_url': instance.authUrl,
      'tailnet': instance.tailnet,
      'user': instance.user,
      'device_name': instance.deviceName,
      'login_server': instance.loginServer,
      'pre_auth_key': instance.preAuthKey,
      'accept_routes': instance.acceptRoutes,
      'advertise_routes': instance.advertiseRoutes,
      'exit_node': instance.exitNode,
      'use_exit_node': instance.useExitNode,
      'dns_enabled': instance.dnsEnabled,
      'magic_dns': instance.magicDns,
      'ssh_enabled': instance.sshEnabled,
      'tags': instance.tags,
      'hostname': instance.hostname,
      'service_running': instance.serviceRunning,
      'backend_state': instance.backendState,
      'ips': instance.ips,
      'bytes_received': instance.bytesReceived,
      'bytes_sent': instance.bytesSent,
      'connected_since': instance.connectedSince?.toIso8601String(),
      'health': instance.health,
      'peers_count': instance.peersCount,
      'version': instance.version,
    };
