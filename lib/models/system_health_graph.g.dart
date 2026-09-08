// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_health_graph.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SystemHealthGraphResponse _$SystemHealthGraphResponseFromJson(
  Map<String, dynamic> json,
) => SystemHealthGraphResponse(
  step: (json['step'] as num).toInt(),
  lastupdate: (json['lastupdate'] as num).toInt(),
  title: json['title'] as String? ?? '',
  yAxisLabel: json['y-axis_label'] as String? ?? '',
  set: SystemHealthDataSet.fromJson(json['set'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SystemHealthGraphResponseToJson(
  SystemHealthGraphResponse instance,
) => <String, dynamic>{
  'step': instance.step,
  'lastupdate': instance.lastupdate,
  'title': instance.title,
  'y-axis_label': instance.yAxisLabel,
  'set': instance.set.toJson(),
};

SystemHealthDataSet _$SystemHealthDataSetFromJson(Map<String, dynamic> json) =>
    SystemHealthDataSet(
      count: (json['count'] as num).toInt(),
      data: (json['data'] as List<dynamic>)
          .map((e) => SystemHealthSeries.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SystemHealthDataSetToJson(
  SystemHealthDataSet instance,
) => <String, dynamic>{
  'count': instance.count,
  'data': instance.data.map((e) => e.toJson()).toList(),
};

SystemHealthSeries _$SystemHealthSeriesFromJson(Map<String, dynamic> json) =>
    SystemHealthSeries(
      key: json['key'] as String,
      values: _parsePoints(json['values']),
    );

Map<String, dynamic> _$SystemHealthSeriesToJson(SystemHealthSeries instance) =>
    <String, dynamic>{
      'key': instance.key,
      'values': _serializePoints(instance.values),
    };
