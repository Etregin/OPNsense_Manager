// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_insight_top_port.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NetworkInsightTopPort _$NetworkInsightTopPortFromJson(
  Map<String, dynamic> json,
) => NetworkInsightTopPort(
  dstPort: json['dst_port'] as String,
  protocol: json['protocol'] as String,
  total: (json['total'] as num).toDouble(),
  lastSeen: json['last_seen'],
  lastSeenStr: json['last_seen_str'] as String?,
  label: json['label'] as String,
);

Map<String, dynamic> _$NetworkInsightTopPortToJson(
  NetworkInsightTopPort instance,
) => <String, dynamic>{
  'dst_port': instance.dstPort,
  'protocol': instance.protocol,
  'total': instance.total,
  'last_seen': instance.lastSeen,
  'last_seen_str': instance.lastSeenStr,
  'label': instance.label,
};
