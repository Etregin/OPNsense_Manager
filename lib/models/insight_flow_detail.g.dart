// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insight_flow_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InsightFlowDetail _$InsightFlowDetailFromJson(Map<String, dynamic> json) =>
    InsightFlowDetail(
      servicePort: json['service_port'] as String,
      protocol: json['protocol'] as String,
      interface: json['if'] as String,
      srcAddr: json['src_addr'] as String,
      dstAddr: json['dst_addr'] as String,
      total: (json['total'] as num).toInt(),
      lastSeen: json['last_seen'],
      lastSeenStr: json['last_seen_str'] as String?,
      label: json['label'] as String,
    );

Map<String, dynamic> _$InsightFlowDetailToJson(InsightFlowDetail instance) =>
    <String, dynamic>{
      'service_port': instance.servicePort,
      'protocol': instance.protocol,
      'if': instance.interface,
      'src_addr': instance.srcAddr,
      'dst_addr': instance.dstAddr,
      'total': instance.total,
      'last_seen': instance.lastSeen,
      'last_seen_str': instance.lastSeenStr,
      'label': instance.label,
    };
