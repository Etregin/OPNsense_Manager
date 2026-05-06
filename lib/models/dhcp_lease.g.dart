// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dhcp_lease.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DhcpLease _$DhcpLeaseFromJson(Map<String, dynamic> json) => DhcpLease(
  address: json['address'] as String,
  hostname: json['hostname'] as String,
  macAddress: json['hwaddr'] as String,
  manufacturer: json['mac_info'] as String?,
  starts: (json['starts'] as num?)?.toInt(),
  ends: (json['ends'] as num?)?.toInt(),
  expire: (json['expire'] as num?)?.toInt(),
  state: json['state'] as String?,
  clientLastTransactionTime: (json['cltt'] as num?)?.toInt(),
  interface: json['if'] as String?,
  type: json['type'] as String?,
);

Map<String, dynamic> _$DhcpLeaseToJson(DhcpLease instance) => <String, dynamic>{
  'address': instance.address,
  'hostname': instance.hostname,
  'hwaddr': instance.macAddress,
  'mac_info': instance.manufacturer,
  'starts': instance.starts,
  'ends': instance.ends,
  'expire': instance.expire,
  'state': instance.state,
  'cltt': instance.clientLastTransactionTime,
  'if': instance.interface,
  'type': instance.type,
};
