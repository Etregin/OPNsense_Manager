// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thermal_sensor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ThermalSensor _$ThermalSensorFromJson(Map<String, dynamic> json) =>
    ThermalSensor(
      device: json['device'] as String,
      deviceSeq: (json['deviceSeq'] as num).toInt(),
      temperature: json['temperature'] as String,
      typeTranslated: json['typeTranslated'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$ThermalSensorToJson(ThermalSensor instance) =>
    <String, dynamic>{
      'device': instance.device,
      'deviceSeq': instance.deviceSeq,
      'temperature': instance.temperature,
      'typeTranslated': instance.typeTranslated,
      'type': instance.type,
    };
