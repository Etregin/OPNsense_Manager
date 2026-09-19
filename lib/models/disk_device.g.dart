// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'disk_device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiskDevice _$DiskDeviceFromJson(Map<String, dynamic> json) => DiskDevice(
  device: json['device'] as String,
  type: json['type'] as String,
  blocks: json['blocks'] as String,
  used: json['used'] as String,
  available: json['available'] as String,
  usedPct: (json['used_pct'] as num).toInt(),
  mountpoint: json['mountpoint'] as String,
);

Map<String, dynamic> _$DiskDeviceToJson(DiskDevice instance) =>
    <String, dynamic>{
      'device': instance.device,
      'type': instance.type,
      'blocks': instance.blocks,
      'used': instance.used,
      'available': instance.available,
      'used_pct': instance.usedPct,
      'mountpoint': instance.mountpoint,
    };
