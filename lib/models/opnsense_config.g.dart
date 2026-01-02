// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'opnsense_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OPNsenseConfig _$OPNsenseConfigFromJson(Map<String, dynamic> json) =>
    OPNsenseConfig(
      host: json['host'] as String,
      port: (json['port'] as num).toInt(),
      apiKey: json['apiKey'] as String,
      apiSecret: json['apiSecret'] as String,
      useHttps: json['useHttps'] as bool? ?? true,
    );

Map<String, dynamic> _$OPNsenseConfigToJson(OPNsenseConfig instance) =>
    <String, dynamic>{
      'host': instance.host,
      'port': instance.port,
      'apiKey': instance.apiKey,
      'apiSecret': instance.apiSecret,
      'useHttps': instance.useHttps,
    };
