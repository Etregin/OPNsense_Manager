// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wireguard_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WireGuardStatusItem _$WireGuardStatusItemFromJson(Map<String, dynamic> json) =>
    WireGuardStatusItem(
      interfaceName: json['if'] as String,
      type: json['type'] as String,
      publicKey: json['public-key'] as String,
      listenPort: json['listen-port'] as String,
      fwmark: json['fwmark'] as String,
      endpoint: json['endpoint'] as String,
      status: json['status'] as String,
      name: json['name'] as String?,
      latestHandshakeAge: json['latest-handshake-age'] as String?,
      latestHandshakeEpoch: (json['latest-handshake-epoch'] as num?)?.toInt(),
      peerStatus: json['peer-status'] as String,
      ifname: json['ifname'] as String,
    );

Map<String, dynamic> _$WireGuardStatusItemToJson(
  WireGuardStatusItem instance,
) => <String, dynamic>{
  'if': instance.interfaceName,
  'type': instance.type,
  'public-key': instance.publicKey,
  'listen-port': instance.listenPort,
  'fwmark': instance.fwmark,
  'endpoint': instance.endpoint,
  'status': instance.status,
  'name': instance.name,
  'latest-handshake-age': instance.latestHandshakeAge,
  'latest-handshake-epoch': instance.latestHandshakeEpoch,
  'peer-status': instance.peerStatus,
  'ifname': instance.ifname,
};

WireGuardStatusResponse _$WireGuardStatusResponseFromJson(
  Map<String, dynamic> json,
) => WireGuardStatusResponse(
  total: (json['total'] as num).toInt(),
  rowCount: (json['rowCount'] as num).toInt(),
  current: (json['current'] as num).toInt(),
  rows: (json['rows'] as List<dynamic>)
      .map((e) => WireGuardStatusItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$WireGuardStatusResponseToJson(
  WireGuardStatusResponse instance,
) => <String, dynamic>{
  'total': instance.total,
  'rowCount': instance.rowCount,
  'current': instance.current,
  'rows': instance.rows,
};

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
