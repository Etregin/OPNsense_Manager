// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unbound_query_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UnboundQueryItem _$UnboundQueryItemFromJson(Map<String, dynamic> json) =>
    UnboundQueryItem(
      uuid: json['uuid'] as String?,
      time: (json['time'] as num?)?.toInt(),
      client: json['client'] as String?,
      family: json['family'] as String?,
      type: json['type'] as String?,
      domain: json['domain'] as String?,
      action: json['action'] as String?,
      source: json['source'] as String?,
      blocklist: json['blocklist'] as String?,
      rcode: json['rcode'] as String?,
      resolveTimeMs: (json['resolve_time_ms'] as num?)?.toInt(),
      dnssecStatus: json['dnssec_status'] as String?,
      ttl: (json['ttl'] as num?)?.toInt(),
      policy: json['policy'] as String?,
      status: (json['status'] as num?)?.toInt(),
    );

Map<String, dynamic> _$UnboundQueryItemToJson(UnboundQueryItem instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'time': instance.time,
      'client': instance.client,
      'family': instance.family,
      'type': instance.type,
      'domain': instance.domain,
      'action': instance.action,
      'source': instance.source,
      'blocklist': instance.blocklist,
      'rcode': instance.rcode,
      'resolve_time_ms': instance.resolveTimeMs,
      'dnssec_status': instance.dnssecStatus,
      'ttl': instance.ttl,
      'policy': instance.policy,
      'status': instance.status,
    };

UnboundQuerySearchResponse _$UnboundQuerySearchResponseFromJson(
  Map<String, dynamic> json,
) => UnboundQuerySearchResponse(
  total: (json['total'] as num).toInt(),
  rowCount: (json['rowCount'] as num).toInt(),
  current: (json['current'] as num).toInt(),
  rows: (json['rows'] as List<dynamic>)
      .map((e) => UnboundQueryItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$UnboundQuerySearchResponseToJson(
  UnboundQuerySearchResponse instance,
) => <String, dynamic>{
  'total': instance.total,
  'rowCount': instance.rowCount,
  'current': instance.current,
  'rows': instance.rows,
};
