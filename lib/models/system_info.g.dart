// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SystemInfo _$SystemInfoFromJson(Map<String, dynamic> json) => SystemInfo(
  hostname: json['hostname'] as String,
  version: json['version'] as String,
  platform: json['platform'] as String,
  uptime: (json['uptime'] as num).toInt(),
  cpuUsage: (json['cpuUsage'] as num).toDouble(),
  memoryUsed: (json['memoryUsed'] as num).toInt(),
  memoryTotal: (json['memoryTotal'] as num).toInt(),
  diskUsed: (json['diskUsed'] as num?)?.toInt() ?? 0,
  diskTotal: (json['diskTotal'] as num?)?.toInt() ?? 0,
  type: json['type'] as String? ?? 'opnsense',
  architecture: json['architecture'] as String? ?? 'amd64',
  commit: json['commit'] as String? ?? '',
  mirror: json['mirror'] as String? ?? '',
  repositories: json['repositories'] as String? ?? '',
  updatedOn: json['updatedOn'] as String?,
);

Map<String, dynamic> _$SystemInfoToJson(SystemInfo instance) =>
    <String, dynamic>{
      'hostname': instance.hostname,
      'version': instance.version,
      'platform': instance.platform,
      'uptime': instance.uptime,
      'cpuUsage': instance.cpuUsage,
      'memoryUsed': instance.memoryUsed,
      'memoryTotal': instance.memoryTotal,
      'diskUsed': instance.diskUsed,
      'diskTotal': instance.diskTotal,
      'type': instance.type,
      'architecture': instance.architecture,
      'commit': instance.commit,
      'mirror': instance.mirror,
      'repositories': instance.repositories,
      'updatedOn': instance.updatedOn,
    };
