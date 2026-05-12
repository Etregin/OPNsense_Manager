// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wireguard_key_pair.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WireGuardKeyPair _$WireGuardKeyPairFromJson(Map<String, dynamic> json) =>
    WireGuardKeyPair(
      publicKey: json['pubkey'] as String,
      privateKey: json['privkey'] as String,
    );

Map<String, dynamic> _$WireGuardKeyPairToJson(WireGuardKeyPair instance) =>
    <String, dynamic>{
      'pubkey': instance.publicKey,
      'privkey': instance.privateKey,
    };
