// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wireguard_server.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WireGuardServer _$WireGuardServerFromJson(Map<String, dynamic> json) =>
    WireGuardServer(
      uuid: json['uuid'] as String,
      enabled: json['enabled'] as String,
      name: json['name'] as String,
      pubkey: json['pubkey'] as String,
      privkey: json['privkey'] as String,
      port: json['port'] as String,
      tunneladdress: json['tunneladdress'] as String,
      peers: json['peers'] as String? ?? '',
      disableroutes: json['disableroutes'] as String? ?? '0',
      gateway: json['gateway'] as String? ?? '',
      mtu: json['mtu'] as String? ?? '',
      dns: json['dns'] as String? ?? '',
      carpDependOn: json['carp_depend_on'] as String? ?? '',
      debug: json['debug'] as String? ?? '0',
    );

Map<String, dynamic> _$WireGuardServerToJson(WireGuardServer instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'enabled': instance.enabled,
      'name': instance.name,
      'pubkey': instance.pubkey,
      'privkey': instance.privkey,
      'port': instance.port,
      'tunneladdress': instance.tunneladdress,
      'peers': instance.peers,
      'disableroutes': instance.disableroutes,
      'gateway': instance.gateway,
      'mtu': instance.mtu,
      'dns': instance.dns,
      'carp_depend_on': instance.carpDependOn,
      'debug': instance.debug,
    };

WireGuardServerRequest _$WireGuardServerRequestFromJson(
  Map<String, dynamic> json,
) => WireGuardServerRequest(
  name: json['name'] as String,
  pubkey: json['pubkey'] as String,
  privkey: json['privkey'] as String,
  port: json['port'] as String,
  tunneladdress: json['tunneladdress'] as String,
  enabled: json['enabled'] as String? ?? '1',
  peers: json['peers'] as String? ?? '',
  disableroutes: json['disableroutes'] as String? ?? '0',
  gateway: json['gateway'] as String? ?? '',
  mtu: json['mtu'] as String? ?? '',
  dns: json['dns'] as String? ?? '',
  carpDependOn: json['carp_depend_on'] as String? ?? '',
  debug: json['debug'] as String? ?? '0',
);

Map<String, dynamic> _$WireGuardServerRequestToJson(
  WireGuardServerRequest instance,
) => <String, dynamic>{
  'name': instance.name,
  'pubkey': instance.pubkey,
  'privkey': instance.privkey,
  'port': instance.port,
  'tunneladdress': instance.tunneladdress,
  'enabled': instance.enabled,
  'peers': instance.peers,
  'disableroutes': instance.disableroutes,
  'gateway': instance.gateway,
  'mtu': instance.mtu,
  'dns': instance.dns,
  'carp_depend_on': instance.carpDependOn,
  'debug': instance.debug,
};
