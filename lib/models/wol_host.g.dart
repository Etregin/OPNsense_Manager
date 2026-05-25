// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wol_host.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WolHost _$WolHostFromJson(Map<String, dynamic> json) => WolHost(
  uuid: json['uuid'] as String,
  interface: json['interface'] as String,
  interfaceDisplay: json['%interface'] as String,
  mac: json['mac'] as String,
  descr: json['descr'] as String? ?? '',
);

Map<String, dynamic> _$WolHostToJson(WolHost instance) => <String, dynamic>{
  'uuid': instance.uuid,
  'interface': instance.interface,
  '%interface': instance.interfaceDisplay,
  'mac': instance.mac,
  'descr': instance.descr,
};

WolHostResponse _$WolHostResponseFromJson(Map<String, dynamic> json) =>
    WolHostResponse(
      rows: (json['rows'] as List<dynamic>)
          .map((e) => WolHost.fromJson(e as Map<String, dynamic>))
          .toList(),
      rowCount: (json['rowCount'] as num).toInt(),
      total: (json['total'] as num).toInt(),
      current: (json['current'] as num).toInt(),
    );

Map<String, dynamic> _$WolHostResponseToJson(WolHostResponse instance) =>
    <String, dynamic>{
      'rows': instance.rows,
      'rowCount': instance.rowCount,
      'total': instance.total,
      'current': instance.current,
    };

WolInterfaceOption _$WolInterfaceOptionFromJson(Map<String, dynamic> json) =>
    WolInterfaceOption(
      value: json['value'] as String,
      selected: (json['selected'] as num).toInt(),
    );

Map<String, dynamic> _$WolInterfaceOptionToJson(WolInterfaceOption instance) =>
    <String, dynamic>{'value': instance.value, 'selected': instance.selected};

WolHostRequest _$WolHostRequestFromJson(Map<String, dynamic> json) =>
    WolHostRequest(
      interface: json['interface'] as String,
      mac: json['mac'] as String,
      descr: json['descr'] as String? ?? '',
    );

Map<String, dynamic> _$WolHostRequestToJson(WolHostRequest instance) =>
    <String, dynamic>{
      'interface': instance.interface,
      'mac': instance.mac,
      'descr': instance.descr,
    };

WolHostOperationResponse _$WolHostOperationResponseFromJson(
  Map<String, dynamic> json,
) => WolHostOperationResponse(
  result: json['result'] as String,
  uuid: json['uuid'] as String?,
);

Map<String, dynamic> _$WolHostOperationResponseToJson(
  WolHostOperationResponse instance,
) => <String, dynamic>{'result': instance.result, 'uuid': instance.uuid};

WolWakeAllResult _$WolWakeAllResultFromJson(Map<String, dynamic> json) =>
    WolWakeAllResult(
      mac: json['mac'] as String,
      status: json['status'] as String,
    );

Map<String, dynamic> _$WolWakeAllResultToJson(WolWakeAllResult instance) =>
    <String, dynamic>{'mac': instance.mac, 'status': instance.status};

WolWakeAllResponse _$WolWakeAllResponseFromJson(Map<String, dynamic> json) =>
    WolWakeAllResponse(
      results: (json['results'] as List<dynamic>)
          .map((e) => WolWakeAllResult.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WolWakeAllResponseToJson(WolWakeAllResponse instance) =>
    <String, dynamic>{'results': instance.results};
