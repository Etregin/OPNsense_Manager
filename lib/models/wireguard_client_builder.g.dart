// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wireguard_client_builder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WireGuardBuilderServer _$WireGuardBuilderServerFromJson(
  Map<String, dynamic> json,
) => WireGuardBuilderServer(
  value: json['value'] as String,
  selected: WireGuardBuilderServer._selectedFromJson(json['selected']),
);

Map<String, dynamic> _$WireGuardBuilderServerToJson(
  WireGuardBuilderServer instance,
) => <String, dynamic>{
  'value': instance.value,
  'selected': WireGuardBuilderServer._selectedToJson(instance.selected),
};

WireGuardClientBuilder _$WireGuardClientBuilderFromJson(
  Map<String, dynamic> json,
) => WireGuardClientBuilder(
  servers: (json['servers'] as Map<String, dynamic>).map(
    (k, e) =>
        MapEntry(k, WireGuardBuilderServer.fromJson(e as Map<String, dynamic>)),
  ),
  name: json['name'] as String? ?? '',
  endpoint: json['endpoint'] as String? ?? '',
  tunneladdress: json['tunneladdress'] == null
      ? ''
      : WireGuardClientBuilder._tunnelAddressFromJson(json['tunneladdress']),
  serveraddress: json['serveraddress'] as String? ?? '',
  serverport: json['serverport'] as String? ?? '51820',
  dns: json['dns'] as String? ?? '',
  keepalive: json['keepalive'] as String? ?? '',
);

Map<String, dynamic> _$WireGuardClientBuilderToJson(
  WireGuardClientBuilder instance,
) => <String, dynamic>{
  'servers': instance.servers,
  'name': instance.name,
  'endpoint': instance.endpoint,
  'tunneladdress': instance.tunneladdress,
  'serveraddress': instance.serveraddress,
  'serverport': instance.serverport,
  'dns': instance.dns,
  'keepalive': instance.keepalive,
};

WireGuardClientBuilderResponse _$WireGuardClientBuilderResponseFromJson(
  Map<String, dynamic> json,
) => WireGuardClientBuilderResponse(
  configBuilder: WireGuardClientBuilder.fromJson(
    json['configbuilder'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$WireGuardClientBuilderResponseToJson(
  WireGuardClientBuilderResponse instance,
) => <String, dynamic>{'configbuilder': instance.configBuilder};

WireGuardServerInfo _$WireGuardServerInfoFromJson(Map<String, dynamic> json) =>
    WireGuardServerInfo(
      pubkey: json['pubkey'] as String? ?? '',
      endpoint: json['endpoint'] as String? ?? '',
      port: json['port'] as String? ?? '',
      tunneladdress: json['tunneladdress'] as String? ?? '',
      peerDns: json['peer_dns'] as String? ?? '',
      mtu: json['mtu'] as String? ?? '',
      address: json['address'] as String? ?? '',
    );

Map<String, dynamic> _$WireGuardServerInfoToJson(
  WireGuardServerInfo instance,
) => <String, dynamic>{
  'pubkey': instance.pubkey,
  'endpoint': instance.endpoint,
  'port': instance.port,
  'tunneladdress': instance.tunneladdress,
  'peer_dns': instance.peerDns,
  'mtu': instance.mtu,
  'address': instance.address,
};

WireGuardClientBuilderRequest _$WireGuardClientBuilderRequestFromJson(
  Map<String, dynamic> json,
) => WireGuardClientBuilderRequest(
  name: json['name'] as String,
  pubkey: json['pubkey'] as String,
  privkey: json['privkey'] as String,
  tunneladdress: json['tunneladdress'] as String,
  serveraddress: json['serveraddress'] as String,
  serverport: json['serverport'] as String,
  serverpubkey: json['serverpubkey'] as String,
  servers: json['servers'] as String,
  psk: json['psk'] as String? ?? '',
  keepalive: json['keepalive'] as String? ?? '',
  endpoint: json['endpoint'] as String? ?? '',
  enabled: json['enabled'] as String? ?? '1',
);

Map<String, dynamic> _$WireGuardClientBuilderRequestToJson(
  WireGuardClientBuilderRequest instance,
) => <String, dynamic>{
  'name': instance.name,
  'pubkey': instance.pubkey,
  'privkey': instance.privkey,
  'tunneladdress': instance.tunneladdress,
  'serveraddress': instance.serveraddress,
  'serverport': instance.serverport,
  'serverpubkey': instance.serverpubkey,
  'servers': instance.servers,
  'psk': instance.psk,
  'keepalive': instance.keepalive,
  'endpoint': instance.endpoint,
  'enabled': instance.enabled,
};
