// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'neighbor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Neighbor _$NeighborFromJson(Map<String, dynamic> json) => Neighbor(
  source: json['source'] as String,
  interfaceName: json['interface_name'] as String,
  etherAddress: json['ether_address'] as String,
  ipAddress: json['ip_address'] as String,
  organizationName: json['organization_name'] as String?,
  firstSeen: json['first_seen'] as String,
  lastSeen: json['last_seen'] as String,
);

Map<String, dynamic> _$NeighborToJson(Neighbor instance) => <String, dynamic>{
  'source': instance.source,
  'interface_name': instance.interfaceName,
  'ether_address': instance.etherAddress,
  'ip_address': instance.ipAddress,
  'organization_name': instance.organizationName,
  'first_seen': instance.firstSeen,
  'last_seen': instance.lastSeen,
};

NeighborDiscoveryResponse _$NeighborDiscoveryResponseFromJson(
  Map<String, dynamic> json,
) => NeighborDiscoveryResponse(
  total: (json['total'] as num).toInt(),
  rowCount: (json['rowCount'] as num).toInt(),
  current: (json['current'] as num).toInt(),
  rows: (json['rows'] as List<dynamic>)
      .map((e) => Neighbor.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$NeighborDiscoveryResponseToJson(
  NeighborDiscoveryResponse instance,
) => <String, dynamic>{
  'total': instance.total,
  'rowCount': instance.rowCount,
  'current': instance.current,
  'rows': instance.rows,
};

NeighborDiscoveryStatus _$NeighborDiscoveryStatusFromJson(
  Map<String, dynamic> json,
) => NeighborDiscoveryStatus(status: json['status'] as String);

Map<String, dynamic> _$NeighborDiscoveryStatusToJson(
  NeighborDiscoveryStatus instance,
) => <String, dynamic>{'status': instance.status};
