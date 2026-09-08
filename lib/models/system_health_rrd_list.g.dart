// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_health_rrd_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SystemHealthRrdList _$SystemHealthRrdListFromJson(Map<String, dynamic> json) =>
    SystemHealthRrdList(
      data: (json['data'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, (e as List<dynamic>).map((e) => e as String).toList()),
      ),
      files: (json['files'] as List<dynamic>)
          .map((e) => SystemHealthRrdFile.fromJson(e as Map<String, dynamic>))
          .toList(),
      interfaces: (json['interfaces'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
          k,
          SystemHealthInterface.fromJson(e as Map<String, dynamic>),
        ),
      ),
    );

Map<String, dynamic> _$SystemHealthRrdListToJson(
  SystemHealthRrdList instance,
) => <String, dynamic>{
  'data': instance.data,
  'files': instance.files.map((e) => e.toJson()).toList(),
  'interfaces': instance.interfaces.map((k, e) => MapEntry(k, e.toJson())),
};

SystemHealthRrdFile _$SystemHealthRrdFileFromJson(Map<String, dynamic> json) =>
    SystemHealthRrdFile(
      key: json['key'] as String,
      filename: json['filename'] as String,
    );

Map<String, dynamic> _$SystemHealthRrdFileToJson(
  SystemHealthRrdFile instance,
) => <String, dynamic>{'key': instance.key, 'filename': instance.filename};

SystemHealthInterface _$SystemHealthInterfaceFromJson(
  Map<String, dynamic> json,
) => SystemHealthInterface(descr: json['descr'] as String);

Map<String, dynamic> _$SystemHealthInterfaceToJson(
  SystemHealthInterface instance,
) => <String, dynamic>{'descr': instance.descr};
