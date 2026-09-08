// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unbound_rolling.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UnboundRollingPoint _$UnboundRollingPointFromJson(Map<String, dynamic> json) =>
    UnboundRollingPoint(
      timestamp: (json['timestamp'] as num).toDouble(),
      total: (json['total'] as num).toInt(),
      passed: (json['passed'] as num).toInt(),
      blocked: (json['blocked'] as num).toInt(),
      dropped: (json['dropped'] as num).toInt(),
      resolved: (json['resolved'] as num).toInt(),
      local: (json['local'] as num).toInt(),
      cached: (json['cached'] as num).toInt(),
    );

Map<String, dynamic> _$UnboundRollingPointToJson(
  UnboundRollingPoint instance,
) => <String, dynamic>{
  'timestamp': instance.timestamp,
  'total': instance.total,
  'passed': instance.passed,
  'blocked': instance.blocked,
  'dropped': instance.dropped,
  'resolved': instance.resolved,
  'local': instance.local,
  'cached': instance.cached,
};

UnboundClientHit _$UnboundClientHitFromJson(Map<String, dynamic> json) =>
    UnboundClientHit(
      ip: json['ip'] as String,
      count: (json['count'] as num).toInt(),
      hostname: json['hostname'] as String,
    );

Map<String, dynamic> _$UnboundClientHitToJson(UnboundClientHit instance) =>
    <String, dynamic>{
      'ip': instance.ip,
      'count': instance.count,
      'hostname': instance.hostname,
    };

UnboundRollingClientPoint _$UnboundRollingClientPointFromJson(
  Map<String, dynamic> json,
) => UnboundRollingClientPoint(
  timestamp: (json['timestamp'] as num).toDouble(),
  clients: (json['clients'] as List<dynamic>)
      .map((e) => UnboundClientHit.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$UnboundRollingClientPointToJson(
  UnboundRollingClientPoint instance,
) => <String, dynamic>{
  'timestamp': instance.timestamp,
  'clients': instance.clients,
};
