// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wireguard_peer_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WireGuardPeerStatus _$WireGuardPeerStatusFromJson(Map<String, dynamic> json) =>
    WireGuardPeerStatus(
      publicKey: json['public_key'] as String,
      endpoint: json['endpoint'] as String?,
      allowedIps: json['allowed_ips'] as String,
      latestHandshake: json['latest_handshake'] as String?,
      bytesReceived: json['transfer_rx'] as String,
      bytesSent: json['transfer_tx'] as String,
    );

Map<String, dynamic> _$WireGuardPeerStatusToJson(
  WireGuardPeerStatus instance,
) => <String, dynamic>{
  'public_key': instance.publicKey,
  'endpoint': instance.endpoint,
  'allowed_ips': instance.allowedIps,
  'latest_handshake': instance.latestHandshake,
  'transfer_rx': instance.bytesReceived,
  'transfer_tx': instance.bytesSent,
};
