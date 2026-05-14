// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tailscale_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TailscaleExitNode _$TailscaleExitNodeFromJson(Map<String, dynamic> json) =>
    TailscaleExitNode(
      value: json['value'] as String?,
      selected: TailscaleExitNode._selectedFromJson(json['selected']),
    );

Map<String, dynamic> _$TailscaleExitNodeToJson(TailscaleExitNode instance) =>
    <String, dynamic>{
      'value': instance.value,
      'selected': TailscaleExitNode._selectedToJson(instance.selected),
    };

TailscaleSubnet _$TailscaleSubnetFromJson(Map<String, dynamic> json) =>
    TailscaleSubnet(
      uuid: json['uuid'] as String?,
      subnet: json['subnet'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$TailscaleSubnetToJson(TailscaleSubnet instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'subnet': instance.subnet,
      'description': instance.description,
    };

TailscaleSubnetSearchResponse _$TailscaleSubnetSearchResponseFromJson(
  Map<String, dynamic> json,
) => TailscaleSubnetSearchResponse(
  rows: (json['rows'] as List<dynamic>)
      .map((e) => TailscaleSubnet.fromJson(e as Map<String, dynamic>))
      .toList(),
  rowCount: (json['rowCount'] as num).toInt(),
  total: (json['total'] as num).toInt(),
  current: (json['current'] as num).toInt(),
);

Map<String, dynamic> _$TailscaleSubnetSearchResponseToJson(
  TailscaleSubnetSearchResponse instance,
) => <String, dynamic>{
  'rows': instance.rows,
  'rowCount': instance.rowCount,
  'total': instance.total,
  'current': instance.current,
};

TailscaleSettings _$TailscaleSettingsFromJson(Map<String, dynamic> json) =>
    TailscaleSettings(
      enabled: TailscaleSettings._boolFromString(json['enabled']),
      loginTimeout: json['loginTimeout'] as String?,
      listenPort: json['listenPort'] as String?,
      acceptDNS: TailscaleSettings._boolFromString(json['acceptDNS']),
      advertiseExitNode: TailscaleSettings._boolFromString(
        json['advertiseExitNode'],
      ),
      useExitNode: TailscaleSettings._exitNodeFromJson(json['useExitNode']),
      acceptSubnetRoutes: TailscaleSettings._boolFromString(
        json['acceptSubnetRoutes'],
      ),
      enableSSH: TailscaleSettings._boolFromString(json['enableSSH']),
      disableSNAT: TailscaleSettings._boolFromString(json['disableSNAT']),
      subnets: TailscaleSettings._subnetsFromJson(json['subnets']),
    );

Map<String, dynamic> _$TailscaleSettingsToJson(TailscaleSettings instance) =>
    <String, dynamic>{
      'enabled': TailscaleSettings._boolToString(instance.enabled),
      'loginTimeout': instance.loginTimeout,
      'listenPort': instance.listenPort,
      'acceptDNS': TailscaleSettings._boolToString(instance.acceptDNS),
      'advertiseExitNode': TailscaleSettings._boolToString(
        instance.advertiseExitNode,
      ),
      'useExitNode': ?TailscaleSettings._exitNodeToJson(instance.useExitNode),
      'acceptSubnetRoutes': TailscaleSettings._boolToString(
        instance.acceptSubnetRoutes,
      ),
      'enableSSH': TailscaleSettings._boolToString(instance.enableSSH),
      'disableSNAT': TailscaleSettings._boolToString(instance.disableSNAT),
      'subnets': TailscaleSettings._subnetsToJson(instance.subnets),
    };

TailscaleSettingsResponse _$TailscaleSettingsResponseFromJson(
  Map<String, dynamic> json,
) => TailscaleSettingsResponse(
  settings: TailscaleSettings.fromJson(
    json['settings'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$TailscaleSettingsResponseToJson(
  TailscaleSettingsResponse instance,
) => <String, dynamic>{'settings': instance.settings};

TailscaleSubnetResponse _$TailscaleSubnetResponseFromJson(
  Map<String, dynamic> json,
) => TailscaleSubnetResponse(
  subnet: TailscaleSubnet.fromJson(json['subnet4'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TailscaleSubnetResponseToJson(
  TailscaleSubnetResponse instance,
) => <String, dynamic>{'subnet4': instance.subnet};
