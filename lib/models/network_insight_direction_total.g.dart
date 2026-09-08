// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_insight_direction_total.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NetworkInsightDirectionTotal _$NetworkInsightDirectionTotalFromJson(
  Map<String, dynamic> json,
) => NetworkInsightDirectionTotal(
  direction: json['direction'] as String,
  total: (json['total'] as num).toDouble(),
  lastSeen: json['last_seen'],
);

Map<String, dynamic> _$NetworkInsightDirectionTotalToJson(
  NetworkInsightDirectionTotal instance,
) => <String, dynamic>{
  'direction': instance.direction,
  'total': instance.total,
  'last_seen': instance.lastSeen,
};
