// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vpn_connection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VPNConnection _$VPNConnectionFromJson(Map<String, dynamic> json) =>
    VPNConnection(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      status: json['status'] as String,
      description: json['description'] as String?,
      remoteAddress: json['remoteAddress'] as String?,
      localAddress: json['localAddress'] as String?,
      virtualAddress: json['virtualAddress'] as String?,
      bytesReceived: (json['bytesReceived'] as num?)?.toInt(),
      bytesSent: (json['bytesSent'] as num?)?.toInt(),
      connectedSince: json['connectedSince'] == null
          ? null
          : DateTime.parse(json['connectedSince'] as String),
      protocol: json['protocol'] as String?,
      port: (json['port'] as num?)?.toInt(),
      enabled: json['enabled'] as bool? ?? true,
    );

Map<String, dynamic> _$VPNConnectionToJson(VPNConnection instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'status': instance.status,
      'description': instance.description,
      'remoteAddress': instance.remoteAddress,
      'localAddress': instance.localAddress,
      'virtualAddress': instance.virtualAddress,
      'bytesReceived': instance.bytesReceived,
      'bytesSent': instance.bytesSent,
      'connectedSince': instance.connectedSince?.toIso8601String(),
      'protocol': instance.protocol,
      'port': instance.port,
      'enabled': instance.enabled,
    };

VPNConnectionRequest _$VPNConnectionRequestFromJson(
  Map<String, dynamic> json,
) => VPNConnectionRequest(
  name: json['name'] as String?,
  description: json['description'] as String?,
  enabled: json['enabled'] as bool?,
  config: json['config'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$VPNConnectionRequestToJson(
  VPNConnectionRequest instance,
) => <String, dynamic>{
  'name': instance.name,
  'description': instance.description,
  'enabled': instance.enabled,
  'config': instance.config,
};
