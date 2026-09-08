// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_insight_top_addr.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NetworkInsightTopAddr _$NetworkInsightTopAddrFromJson(
  Map<String, dynamic> json,
) => NetworkInsightTopAddr(
  srcAddr: json['src_addr'] as String,
  total: (json['total'] as num).toDouble(),
  lastSeen: json['last_seen'],
);

Map<String, dynamic> _$NetworkInsightTopAddrToJson(
  NetworkInsightTopAddr instance,
) => <String, dynamic>{
  'src_addr': instance.srcAddr,
  'total': instance.total,
  'last_seen': instance.lastSeen,
};
