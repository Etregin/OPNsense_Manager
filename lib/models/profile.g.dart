// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Profile _$ProfileFromJson(Map<String, dynamic> json) => Profile(
  id: json['id'] as String,
  name: json['name'] as String,
  connections: (json['connections'] as List<dynamic>)
      .map((e) => ConnectionEndpoint.fromJson(e as Map<String, dynamic>))
      .toList(),
  apiKey: json['apiKey'] as String,
  apiSecret: json['apiSecret'] as String,
  useHttps: json['useHttps'] as bool,
  allowSelfSignedCerts: json['allowSelfSignedCerts'] as bool? ?? false,
  isDemo: json['isDemo'] as bool? ?? false,
  createdAt: DateTime.parse(json['createdAt'] as String),
  lastUsed: json['lastUsed'] == null
      ? null
      : DateTime.parse(json['lastUsed'] as String),
  dhcpServerType:
      $enumDecodeNullable(_$DhcpServerTypeEnumMap, json['dhcpServerType']) ??
      DhcpServerType.dnsmasq,
);

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'connections': instance.connections.map((e) => e.toJson()).toList(),
  'apiKey': instance.apiKey,
  'apiSecret': instance.apiSecret,
  'useHttps': instance.useHttps,
  'allowSelfSignedCerts': instance.allowSelfSignedCerts,
  'isDemo': instance.isDemo,
  'createdAt': instance.createdAt.toIso8601String(),
  'lastUsed': instance.lastUsed?.toIso8601String(),
  'dhcpServerType': _$DhcpServerTypeEnumMap[instance.dhcpServerType]!,
};

const _$DhcpServerTypeEnumMap = {
  DhcpServerType.dnsmasq: 'dnsmasq',
  DhcpServerType.isc: 'isc',
  DhcpServerType.kea: 'kea',
};
