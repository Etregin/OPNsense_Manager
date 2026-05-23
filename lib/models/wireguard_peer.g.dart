// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wireguard_peer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WireGuardPeer _$WireGuardPeerFromJson(Map<String, dynamic> json) =>
    WireGuardPeer(
      uuid: json['uuid'] as String,
      enabled: json['enabled'] as String,
      name: json['name'] as String,
      pubkey: json['pubkey'] as String?,
      privkey: json['privkey'] as String?,
      tunneladdress: json['tunneladdress'] as String?,
      serveraddress: json['serveraddress'] as String?,
      serverport: json['serverport'] as String?,
      serverpubkey: json['serverpubkey'] as String?,
      endpoint: json['endpoint'] as String?,
      servers: json['servers'] as String?,
      keepalive: json['keepalive'] as String?,
      psk: json['psk'] as String?,
      serverName: json['%servers'] as String?,
    );

Map<String, dynamic> _$WireGuardPeerToJson(WireGuardPeer instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'enabled': instance.enabled,
      'name': instance.name,
      'pubkey': instance.pubkey,
      'privkey': instance.privkey,
      'tunneladdress': instance.tunneladdress,
      'serveraddress': instance.serveraddress,
      'serverport': instance.serverport,
      'serverpubkey': instance.serverpubkey,
      'endpoint': instance.endpoint,
      'servers': instance.servers,
      'keepalive': instance.keepalive,
      'psk': instance.psk,
      '%servers': instance.serverName,
    };

WireGuardPeerRequest _$WireGuardPeerRequestFromJson(
  Map<String, dynamic> json,
) => WireGuardPeerRequest(
  name: json['name'] as String,
  pubkey: json['pubkey'] as String,
  privkey: json['privkey'] as String,
  tunneladdress: json['tunneladdress'] as String,
  serveraddress: json['serveraddress'] as String,
  serverport: json['serverport'] as String,
  serverpubkey: json['serverpubkey'] as String,
  enabled: json['enabled'] as String? ?? '1',
  endpoint: json['endpoint'] as String?,
  servers: json['servers'] as String?,
  keepalive: json['keepalive'] as String?,
  psk: json['psk'] as String?,
);

Map<String, dynamic> _$WireGuardPeerRequestToJson(
  WireGuardPeerRequest instance,
) => <String, dynamic>{
  'name': instance.name,
  'pubkey': instance.pubkey,
  'privkey': instance.privkey,
  'tunneladdress': instance.tunneladdress,
  'serveraddress': instance.serveraddress,
  'serverport': instance.serverport,
  'serverpubkey': instance.serverpubkey,
  'enabled': instance.enabled,
  'endpoint': instance.endpoint,
  'servers': instance.servers,
  'keepalive': instance.keepalive,
  'psk': instance.psk,
};
