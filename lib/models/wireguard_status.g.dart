// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wireguard_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WireGuardStatus _$WireGuardStatusFromJson(Map<String, dynamic> json) =>
    WireGuardStatus(
      uuid: json['uuid'] as String,
      type: json['type'] as String,
      name: json['name'] as String,
      enabled: json['enabled'] as String,
      running: json['running'] as String,
      bytesReceived: json['bytes_received'] as String?,
      bytesSent: json['bytes_sent'] as String?,
      connectedSince: json['connected_since'] as String?,
      lastHandshake: json['last_handshake'] as String?,
      peers:
          (json['peers'] as List<dynamic>?)
              ?.map(
                (e) => WireGuardPeerStatus.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );

Map<String, dynamic> _$WireGuardStatusToJson(WireGuardStatus instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'type': instance.type,
      'name': instance.name,
      'enabled': instance.enabled,
      'running': instance.running,
      'bytes_received': instance.bytesReceived,
      'bytes_sent': instance.bytesSent,
      'connected_since': instance.connectedSince,
      'last_handshake': instance.lastHandshake,
      'peers': instance.peers,
    };
