// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_insight_timeserie.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NetworkInsightSeries _$NetworkInsightSeriesFromJson(
  Map<String, dynamic> json,
) => NetworkInsightSeries(
  key: json['key'] as String,
  direction: json['direction'] as String,
  interface: json['interface'] as String?,
  values: (json['values'] as List<dynamic>)
      .map(
        (e) => (e as List<dynamic>).map((e) => (e as num).toDouble()).toList(),
      )
      .toList(),
);

Map<String, dynamic> _$NetworkInsightSeriesToJson(
  NetworkInsightSeries instance,
) => <String, dynamic>{
  'key': instance.key,
  'direction': instance.direction,
  'interface': instance.interface,
  'values': instance.values,
};
