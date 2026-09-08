// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unbound_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UnboundGeneralSettings _$UnboundGeneralSettingsFromJson(
  Map<String, dynamic> json,
) => UnboundGeneralSettings(
  enabled: json['enabled'] == null
      ? true
      : UnboundGeneralSettings._parseBool(json['enabled']),
  stats: json['stats'] == null
      ? false
      : UnboundGeneralSettings._parseBool(json['stats']),
  port: json['port'] as String?,
);

Map<String, dynamic> _$UnboundGeneralSettingsToJson(
  UnboundGeneralSettings instance,
) => <String, dynamic>{
  'enabled': instance.enabled,
  'stats': instance.stats,
  'port': instance.port,
};
