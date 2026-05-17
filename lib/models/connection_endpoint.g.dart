// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connection_endpoint.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConnectionEndpoint _$ConnectionEndpointFromJson(Map<String, dynamic> json) =>
    ConnectionEndpoint(
      host: json['host'] as String,
      port: (json['port'] as num).toInt(),
      label: json['label'] as String?,
      isActive: json['isActive'] as bool? ?? false,
      lastSuccessfulConnection: json['lastSuccessfulConnection'] == null
          ? null
          : DateTime.parse(json['lastSuccessfulConnection'] as String),
    );

Map<String, dynamic> _$ConnectionEndpointToJson(ConnectionEndpoint instance) =>
    <String, dynamic>{
      'host': instance.host,
      'port': instance.port,
      'label': instance.label,
      'isActive': instance.isActive,
      'lastSuccessfulConnection': instance.lastSuccessfulConnection
          ?.toIso8601String(),
    };
