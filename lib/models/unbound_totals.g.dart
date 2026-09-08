// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unbound_totals.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UnboundTotalCategory _$UnboundTotalCategoryFromJson(
  Map<String, dynamic> json,
) => UnboundTotalCategory(
  total: json['total'] == null ? 0 : UnboundTotalCategory._parseInt(json['total']),
  pcnt: json['pcnt'] == null ? 0.0 : UnboundTotalCategory._parseDouble(json['pcnt']),
);

Map<String, dynamic> _$UnboundTotalCategoryToJson(
  UnboundTotalCategory instance,
) => <String, dynamic>{'total': instance.total, 'pcnt': instance.pcnt};

UnboundDomainStat _$UnboundDomainStatFromJson(Map<String, dynamic> json) =>
    UnboundDomainStat(
      domain: json['domain'] as String? ?? '',
      total: json['total'] == null ? 0 : UnboundTotalCategory._parseInt(json['total']),
      pcnt: json['pcnt'] == null ? 0.0 : UnboundTotalCategory._parseDouble(json['pcnt']),
    );

Map<String, dynamic> _$UnboundDomainStatToJson(UnboundDomainStat instance) =>
    <String, dynamic>{
      'domain': instance.domain,
      'total': instance.total,
      'pcnt': instance.pcnt,
    };

UnboundTotals _$UnboundTotalsFromJson(
  Map<String, dynamic> json,
) => UnboundTotals(
  total: json['total'] == null ? 0 : UnboundTotalCategory._parseInt(json['total']),
  blocklistSize: json['blocklist_size'] == null ? 0 : UnboundTotalCategory._parseInt(json['blocklist_size']),
  passed: json['passed'] == null ? 0 : UnboundTotalCategory._parseInt(json['passed']),
  resolved: json['resolved'] == null
      ? null
      : UnboundTotalCategory.fromJson(json['resolved'] as Map<String, dynamic>),
  blocked: json['blocked'] == null
      ? null
      : UnboundTotalCategory.fromJson(json['blocked'] as Map<String, dynamic>),
  local: json['local'] == null
      ? null
      : UnboundTotalCategory.fromJson(json['local'] as Map<String, dynamic>),
  startTime: (json['start_time'] as num?)?.toInt(),
  top: json['top'] == null
      ? const []
      : UnboundTotals._parseDomainStats(json['top']),
  topBlocked: json['top_blocked'] == null
      ? const []
      : UnboundTotals._parseDomainStats(json['top_blocked']),
);

Map<String, dynamic> _$UnboundTotalsToJson(UnboundTotals instance) =>
    <String, dynamic>{
      'total': instance.total,
      'blocklist_size': instance.blocklistSize,
      'passed': instance.passed,
      'resolved': instance.resolved,
      'blocked': instance.blocked,
      'local': instance.local,
      'start_time': instance.startTime,
      'top': instance.top,
      'top_blocked': instance.topBlocked,
    };
