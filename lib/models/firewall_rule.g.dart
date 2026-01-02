// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firewall_rule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FirewallRule _$FirewallRuleFromJson(Map<String, dynamic> json) => FirewallRule(
  uuid: json['uuid'] as String,
  type: json['type'] as String,
  interfaceName: json['interface'] as String,
  protocol: json['protocol'] as String,
  source: json['source'] as String,
  destination: json['destination'] as String,
  sourcePort: json['source_port'] as String? ?? '',
  destinationPort: json['destination_port'] as String,
  description: json['descr'] as String,
  enabled: json['enabled'] as String,
  sequence: (json['sequence'] as num).toInt(),
  origin: json['origin'] as String? ?? '',
);

Map<String, dynamic> _$FirewallRuleToJson(FirewallRule instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'type': instance.type,
      'interface': instance.interfaceName,
      'protocol': instance.protocol,
      'source': instance.source,
      'destination': instance.destination,
      'source_port': instance.sourcePort,
      'destination_port': instance.destinationPort,
      'descr': instance.description,
      'enabled': instance.enabled,
      'sequence': instance.sequence,
      'origin': instance.origin,
    };

FirewallRuleRequest _$FirewallRuleRequestFromJson(Map<String, dynamic> json) =>
    FirewallRuleRequest(
      type: json['action'] as String,
      interfaceName: json['interface'] as String,
      protocol: json['protocol'] as String,
      source: json['source_net'] as String,
      destination: json['destination_net'] as String,
      destinationPort: json['destination_port'] as String,
      description: json['description'] as String,
      enabled: json['enabled'] as String? ?? "1",
      sourceNot: json['source_not'] as String? ?? '0',
      destinationNot: json['destination_not'] as String? ?? '0',
      ipProtocol: json['ipprotocol'] as String? ?? 'inet',
      direction: json['direction'] as String? ?? 'in',
      quick: json['quick'] as String? ?? '1',
      sourcePort: json['source_port'] as String? ?? '',
      log: json['log'] as String? ?? '0',
    );

Map<String, dynamic> _$FirewallRuleRequestToJson(
  FirewallRuleRequest instance,
) => <String, dynamic>{
  'action': instance.type,
  'interface': instance.interfaceName,
  'protocol': instance.protocol,
  'source_net': instance.source,
  'source_not': instance.sourceNot,
  'destination_net': instance.destination,
  'destination_not': instance.destinationNot,
  'destination_port': instance.destinationPort,
  'description': instance.description,
  'enabled': instance.enabled,
  'source_port': instance.sourcePort,
  'log': instance.log,
  'ipprotocol': instance.ipProtocol,
  'direction': instance.direction,
  'quick': instance.quick,
};
