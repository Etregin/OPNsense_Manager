// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wireguard_client.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WireGuardClient _$WireGuardClientFromJson(Map<String, dynamic> json) =>
    WireGuardClient(
      uuid: json['uuid'] as String,
      enabled: json['enabled'] as String,
      name: json['name'] as String,
      pubkey: json['pubkey'] as String,
      privkey: json['privkey'] as String,
      tunneladdress: json['tunneladdress'] as String,
      serveraddress: json['serveraddress'] as String,
      serverport: json['serverport'] as String,
      serverpubkey: json['serverpubkey'] as String,
      keepalive: json['keepalive'] as String? ?? '',
      psk: json['psk'] as String? ?? '',
    );

Map<String, dynamic> _$WireGuardClientToJson(WireGuardClient instance) =>
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
      'keepalive': instance.keepalive,
      'psk': instance.psk,
    };

WireGuardClientRequest _$WireGuardClientRequestFromJson(
  Map<String, dynamic> json,
) => WireGuardClientRequest(
  name: json['name'] as String,
  pubkey: json['pubkey'] as String,
  privkey: json['privkey'] as String,
  tunneladdress: json['tunneladdress'] as String,
  serveraddress: json['serveraddress'] as String,
  serverport: json['serverport'] as String,
  serverpubkey: json['serverpubkey'] as String,
  enabled: json['enabled'] as String? ?? '1',
  keepalive: json['keepalive'] as String? ?? '',
  psk: json['psk'] as String? ?? '',
);

Map<String, dynamic> _$WireGuardClientRequestToJson(
  WireGuardClientRequest instance,
) => <String, dynamic>{
  'name': instance.name,
  'pubkey': instance.pubkey,
  'privkey': instance.privkey,
  'tunneladdress': instance.tunneladdress,
  'serveraddress': instance.serveraddress,
  'serverport': instance.serverport,
  'serverpubkey': instance.serverpubkey,
  'enabled': instance.enabled,
  'keepalive': instance.keepalive,
  'psk': instance.psk,
};
