// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Profile _$ProfileFromJson(Map<String, dynamic> json) => Profile(
  id: json['id'] as String,
  name: json['name'] as String,
  host: json['host'] as String,
  port: (json['port'] as num).toInt(),
  apiKey: json['apiKey'] as String,
  apiSecret: json['apiSecret'] as String,
  useHttps: json['useHttps'] as bool,
  createdAt: DateTime.parse(json['createdAt'] as String),
  lastUsed: json['lastUsed'] == null
      ? null
      : DateTime.parse(json['lastUsed'] as String),
);

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'host': instance.host,
  'port': instance.port,
  'apiKey': instance.apiKey,
  'apiSecret': instance.apiSecret,
  'useHttps': instance.useHttps,
  'createdAt': instance.createdAt.toIso8601String(),
  'lastUsed': instance.lastUsed?.toIso8601String(),
};
