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
      pubkey: json['pubkey'] as String,
      psk: json['psk'] as String? ?? '',
      tunneladdress: json['tunneladdress'] as String,
      endpoint: json['endpoint'] as String? ?? '',
      keepalive: json['keepalive'] as String? ?? '',
    );

Map<String, dynamic> _$WireGuardPeerToJson(WireGuardPeer instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'enabled': instance.enabled,
      'name': instance.name,
      'pubkey': instance.pubkey,
      'psk': instance.psk,
      'tunneladdress': instance.tunneladdress,
      'endpoint': instance.endpoint,
      'keepalive': instance.keepalive,
    };

WireGuardPeerRequest _$WireGuardPeerRequestFromJson(
  Map<String, dynamic> json,
) => WireGuardPeerRequest(
  name: json['name'] as String,
  pubkey: json['pubkey'] as String,
  tunneladdress: json['tunneladdress'] as String,
  enabled: json['enabled'] as String? ?? '1',
  psk: json['psk'] as String? ?? '',
  endpoint: json['endpoint'] as String? ?? '',
  keepalive: json['keepalive'] as String? ?? '',
);

Map<String, dynamic> _$WireGuardPeerRequestToJson(
  WireGuardPeerRequest instance,
) => <String, dynamic>{
  'name': instance.name,
  'pubkey': instance.pubkey,
  'tunneladdress': instance.tunneladdress,
  'enabled': instance.enabled,
  'psk': instance.psk,
  'endpoint': instance.endpoint,
  'keepalive': instance.keepalive,
};
