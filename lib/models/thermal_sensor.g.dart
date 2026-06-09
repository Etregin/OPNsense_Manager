// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thermal_sensor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ThermalSensor _$ThermalSensorFromJson(Map<String, dynamic> json) =>
    ThermalSensor(
      device: json['device'] as String,
      deviceSeq: (json['device_seq'] as num).toInt(),
      temperature: json['temperature'] as String,
      typeTranslated: json['type_translated'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$ThermalSensorToJson(ThermalSensor instance) =>
    <String, dynamic>{
      'device': instance.device,
      'device_seq': instance.deviceSeq,
      'temperature': instance.temperature,
      'type_translated': instance.typeTranslated,
      'type': instance.type,
    };
