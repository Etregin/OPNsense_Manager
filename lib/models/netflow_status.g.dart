// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'netflow_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NetflowStatus _$NetflowStatusFromJson(Map<String, dynamic> json) =>
    NetflowStatus(
      netflow: (json['netflow'] as num).toInt(),
      local: (json['local'] as num).toInt(),
    );

Map<String, dynamic> _$NetflowStatusToJson(NetflowStatus instance) =>
    <String, dynamic>{'netflow': instance.netflow, 'local': instance.local};
