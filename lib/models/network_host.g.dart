// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_host.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NetworkHost _$NetworkHostFromJson(Map<String, dynamic> json) => NetworkHost(
  address: json['address'] as String,
  hostname: json['hostname'] as String,
  manufacturer: json['manufacturer'] as String?,
  rateIn: (json['rateIn'] as num).toInt(),
  rateOut: (json['rateOut'] as num).toInt(),
  macAddress: json['macAddress'] as String?,
  leaseExpiry: json['leaseExpiry'] == null
      ? null
      : DateTime.parse(json['leaseExpiry'] as String),
);

Map<String, dynamic> _$NetworkHostToJson(NetworkHost instance) =>
    <String, dynamic>{
      'address': instance.address,
      'hostname': instance.hostname,
      'manufacturer': instance.manufacturer,
      'rateIn': instance.rateIn,
      'rateOut': instance.rateOut,
      'macAddress': instance.macAddress,
      'leaseExpiry': instance.leaseExpiry?.toIso8601String(),
    };
