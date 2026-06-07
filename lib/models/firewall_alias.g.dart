// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firewall_alias.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FirewallAlias _$FirewallAliasFromJson(Map<String, dynamic> json) =>
    FirewallAlias(
      uuid: json['uuid'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      content: json['content'] as String,
      description: json['description'] as String? ?? '',
      enabled: json['enabled'] as String? ?? '1',
      counters: json['counters'] as String? ?? '0',
      proto: json['proto'] as String? ?? '',
      interface: json['interface'] as String? ?? '',
      categories: json['categories'] as String? ?? '',
      currentItems: json['current_items'] as String? ?? '0',
    );

Map<String, dynamic> _$FirewallAliasToJson(FirewallAlias instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'name': instance.name,
      'type': instance.type,
      'content': instance.content,
      'description': instance.description,
      'enabled': instance.enabled,
      'counters': instance.counters,
      'proto': instance.proto,
      'interface': instance.interface,
      'categories': instance.categories,
      'current_items': instance.currentItems,
    };

FirewallAliasRequest _$FirewallAliasRequestFromJson(
  Map<String, dynamic> json,
) => FirewallAliasRequest(
  name: json['name'] as String,
  type: json['type'] as String,
  content: json['content'] as String,
  description: json['description'] as String? ?? '',
  enabled: json['enabled'] as String? ?? '1',
  counters: json['counters'] as String? ?? '0',
  proto: json['proto'] as String? ?? '',
  interface: json['interface'] as String? ?? '',
  categories: json['categories'] as String? ?? '',
);

Map<String, dynamic> _$FirewallAliasRequestToJson(
  FirewallAliasRequest instance,
) => <String, dynamic>{
  'name': instance.name,
  'type': instance.type,
  'content': instance.content,
  'description': instance.description,
  'enabled': instance.enabled,
  'counters': instance.counters,
  'proto': instance.proto,
  'interface': instance.interface,
  'categories': instance.categories,
};

AliasUtilItem _$AliasUtilItemFromJson(Map<String, dynamic> json) =>
    AliasUtilItem(address: json['address'] as String);

Map<String, dynamic> _$AliasUtilItemToJson(AliasUtilItem instance) =>
    <String, dynamic>{'address': instance.address};

AliasTableEntry _$AliasTableEntryFromJson(Map<String, dynamic> json) =>
    AliasTableEntry(
      ip: json['ip'] as String,
      hostname: json['hostname'] as String? ?? '',
    );

Map<String, dynamic> _$AliasTableEntryToJson(AliasTableEntry instance) =>
    <String, dynamic>{'ip': instance.ip, 'hostname': instance.hostname};

AliasCategory _$AliasCategoryFromJson(Map<String, dynamic> json) =>
    AliasCategory(
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
    );

Map<String, dynamic> _$AliasCategoryToJson(AliasCategory instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
    };

AliasCountry _$AliasCountryFromJson(Map<String, dynamic> json) =>
    AliasCountry(code: json['code'] as String, name: json['name'] as String);

Map<String, dynamic> _$AliasCountryToJson(AliasCountry instance) =>
    <String, dynamic>{'code': instance.code, 'name': instance.name};
