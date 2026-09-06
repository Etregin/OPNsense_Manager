/*
 * OPNsense Manager - Flutter application for managing OPNsense firewalls
 * Copyright (C) 2026 OPNsense Manager
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */


import 'package:json_annotation/json_annotation.dart';

part 'firewall_rule.g.dart';

/// Firewall rule model
@JsonSerializable()
class FirewallRule {
  final String uuid;
  final String type; // pass, block, reject
  @JsonKey(name: 'interface')
  final String interfaceName;
  final String protocol; // tcp, udp, icmp, any
  @JsonKey(name: 'icmptype', defaultValue: '')
  final String icmpType;
  @JsonKey(name: 'icmp6type', defaultValue: '')
  final String icmp6Type;
  final String source;
  final String destination;
  @JsonKey(name: 'source_port')
  final String sourcePort;
  @JsonKey(name: 'destination_port')
  final String destinationPort;
  @JsonKey(name: 'descr')
  final String description;
  final String enabled; // "1" or "0"
  final int sequence;
  @JsonKey(name: 'origin', defaultValue: '')
  final String origin; // Used to identify system-generated rules

  // Direction / IP version / quick / log
  @JsonKey(name: 'direction', defaultValue: 'in')
  final String direction;
  @JsonKey(name: 'ipprotocol', defaultValue: 'inet')
  final String ipProtocol;
  @JsonKey(name: 'quick', defaultValue: '1')
  final String quick;
  @JsonKey(name: 'source_not', defaultValue: '0')
  final String sourceNot;
  @JsonKey(name: 'destination_not', defaultValue: '0')
  final String destinationNot;
  @JsonKey(name: 'log', defaultValue: '0')
  final String log;
  @JsonKey(name: 'statetype', defaultValue: 'keep')
  final String stateType;

  // Organisation
  @JsonKey(name: 'categories', defaultValue: [])
  final List<String> categories;
  @JsonKey(name: 'interfacenot', defaultValue: '0')
  final String interfaceNot;
  @JsonKey(name: 'nosync', defaultValue: '0')
  final String noSync;
  @JsonKey(name: 'sort_order', defaultValue: '')
  final String sortOrder;

  // Filter (advanced)
  @JsonKey(name: 'allowopts', defaultValue: '0')
  final String allowOpts;
  @JsonKey(name: 'tcpflags1', defaultValue: [])
  final List<String> tcpFlags1;
  @JsonKey(name: 'tcpflags2', defaultValue: [])
  final List<String> tcpFlags2;
  @JsonKey(name: 'tcpflags_any', defaultValue: '0')
  final String tcpFlagsAny;
  @JsonKey(name: 'sched', defaultValue: '')
  final String schedule;
  @JsonKey(name: 'divert-to', defaultValue: '')
  final String divertTo;

  // Source Routing
  @JsonKey(name: 'gateway', defaultValue: '')
  final String gateway;
  @JsonKey(name: 'replyto', defaultValue: '')
  final String replyTo;
  @JsonKey(name: 'disablereplyto', defaultValue: '0')
  final String disableReplyTo;

  // Stateful Firewall
  @JsonKey(name: 'state-policy', defaultValue: '')
  final String statePolicy;
  @JsonKey(name: 'nopfsync', defaultValue: '0')
  final String noPfsync;
  @JsonKey(name: 'statetimeout', defaultValue: '')
  final String statTimeout;
  @JsonKey(name: 'udp-first', defaultValue: '')
  final String udpFirst;
  @JsonKey(name: 'udp-single', defaultValue: '')
  final String udpSingle;
  @JsonKey(name: 'udp-multiple', defaultValue: '')
  final String udpMultiple;
  @JsonKey(name: 'adaptivestart', defaultValue: '')
  final String adaptiveStart;
  @JsonKey(name: 'adaptiveend', defaultValue: '')
  final String adaptiveEnd;
  @JsonKey(name: 'max', defaultValue: '')
  final String max;
  @JsonKey(name: 'max-src-nodes', defaultValue: '')
  final String maxSrcNodes;
  @JsonKey(name: 'max-src-states', defaultValue: '')
  final String maxSrcStates;
  @JsonKey(name: 'max-src-conn', defaultValue: '')
  final String maxSrcConn;
  @JsonKey(name: 'max-src-conn-rate', defaultValue: '')
  final String maxSrcConnRate;
  @JsonKey(name: 'max-src-conn-rates', defaultValue: '')
  final String maxSrcConnRates;
  @JsonKey(name: 'overload', defaultValue: '')
  final String overload;

  // Traffic Shaping
  @JsonKey(name: 'shaper1', defaultValue: '')
  final String shaper1;
  @JsonKey(name: 'shaper2', defaultValue: '')
  final String shaper2;

  // Priority
  @JsonKey(name: 'prio', defaultValue: '')
  final String prio;
  @JsonKey(name: 'set-prio', defaultValue: '')
  final String setPrio;
  @JsonKey(name: 'set-prio-low', defaultValue: '')
  final String setPrioLow;
  @JsonKey(name: 'tos', defaultValue: '')
  final String tos;

  // Internal Tagging
  @JsonKey(name: 'tag', defaultValue: '')
  final String tag;
  @JsonKey(name: 'tagged', defaultValue: '')
  final String tagged;

  FirewallRule({
    required this.uuid,
    required this.type,
    required this.interfaceName,
    required this.protocol,
    this.icmpType = '',
    this.icmp6Type = '',
    required this.source,
    required this.destination,
    this.sourcePort = '',
    required this.destinationPort,
    required this.description,
    required this.enabled,
    required this.sequence,
    this.origin = '',
    this.direction = 'in',
    this.ipProtocol = 'inet',
    this.quick = '1',
    this.sourceNot = '0',
    this.destinationNot = '0',
    this.log = '0',
    this.stateType = 'keep',
    this.categories = const [],
    this.interfaceNot = '0',
    this.noSync = '0',
    this.sortOrder = '',
    this.allowOpts = '0',
    this.tcpFlags1 = const [],
    this.tcpFlags2 = const [],
    this.tcpFlagsAny = '0',
    this.schedule = '',
    this.divertTo = '',
    this.gateway = '',
    this.replyTo = '',
    this.disableReplyTo = '0',
    this.statePolicy = '',
    this.noPfsync = '0',
    this.statTimeout = '',
    this.udpFirst = '',
    this.udpSingle = '',
    this.udpMultiple = '',
    this.adaptiveStart = '',
    this.adaptiveEnd = '',
    this.max = '',
    this.maxSrcNodes = '',
    this.maxSrcStates = '',
    this.maxSrcConn = '',
    this.maxSrcConnRate = '',
    this.maxSrcConnRates = '',
    this.overload = '',
    this.shaper1 = '',
    this.shaper2 = '',
    this.prio = '',
    this.setPrio = '',
    this.setPrioLow = '',
    this.tos = '',
    this.tag = '',
    this.tagged = '',
  });

  /// Check if rule is enabled
  bool get isEnabled => enabled == '1';

  /// Check if rule is system-generated (cannot be edited/deleted)
  bool get isSystemGenerated => origin.isNotEmpty;

  /// Get rule type display name
  String get typeDisplayName {
    switch (type.toLowerCase()) {
      case 'pass':
        return 'Pass';
      case 'block':
        return 'Block';
      case 'reject':
        return 'Reject';
      default:
        return type;
    }
  }

  /// Get protocol display name
  String get protocolDisplayName {
    return protocol.toUpperCase();
  }

  /// Create from JSON
  factory FirewallRule.fromJson(Map<String, dynamic> json) =>
      _$FirewallRuleFromJson(json);

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$FirewallRuleToJson(this);

  /// Create a copy with updated fields
  FirewallRule copyWith({
    String? uuid,
    String? type,
    String? interfaceName,
    String? protocol,
    String? source,
    String? destination,
    String? sourcePort,
    String? destinationPort,
    String? description,
    String? enabled,
    int? sequence,
    String? origin,
    String? direction,
    String? ipProtocol,
    String? quick,
    String? sourceNot,
    String? destinationNot,
    String? log,
    String? stateType,
    List<String>? categories,
    String? interfaceNot,
    String? noSync,
    String? sortOrder,
    String? allowOpts,
    List<String>? tcpFlags1,
    List<String>? tcpFlags2,
    String? tcpFlagsAny,
    String? schedule,
    String? divertTo,
    String? gateway,
    String? replyTo,
    String? disableReplyTo,
    String? statePolicy,
    String? noPfsync,
    String? statTimeout,
    String? udpFirst,
    String? udpSingle,
    String? udpMultiple,
    String? adaptiveStart,
    String? adaptiveEnd,
    String? max,
    String? maxSrcNodes,
    String? maxSrcStates,
    String? maxSrcConn,
    String? maxSrcConnRate,
    String? maxSrcConnRates,
    String? overload,
    String? shaper1,
    String? shaper2,
    String? prio,
    String? setPrio,
    String? setPrioLow,
    String? tos,
    String? tag,
    String? tagged,
  }) {
    return FirewallRule(
      uuid: uuid ?? this.uuid,
      type: type ?? this.type,
      interfaceName: interfaceName ?? this.interfaceName,
      protocol: protocol ?? this.protocol,
      source: source ?? this.source,
      destination: destination ?? this.destination,
      sourcePort: sourcePort ?? this.sourcePort,
      destinationPort: destinationPort ?? this.destinationPort,
      description: description ?? this.description,
      enabled: enabled ?? this.enabled,
      sequence: sequence ?? this.sequence,
      origin: origin ?? this.origin,
      direction: direction ?? this.direction,
      ipProtocol: ipProtocol ?? this.ipProtocol,
      quick: quick ?? this.quick,
      sourceNot: sourceNot ?? this.sourceNot,
      destinationNot: destinationNot ?? this.destinationNot,
      log: log ?? this.log,
      stateType: stateType ?? this.stateType,
      categories: categories ?? this.categories,
      interfaceNot: interfaceNot ?? this.interfaceNot,
      noSync: noSync ?? this.noSync,
      sortOrder: sortOrder ?? this.sortOrder,
      allowOpts: allowOpts ?? this.allowOpts,
      tcpFlags1: tcpFlags1 ?? this.tcpFlags1,
      tcpFlags2: tcpFlags2 ?? this.tcpFlags2,
      tcpFlagsAny: tcpFlagsAny ?? this.tcpFlagsAny,
      schedule: schedule ?? this.schedule,
      divertTo: divertTo ?? this.divertTo,
      gateway: gateway ?? this.gateway,
      replyTo: replyTo ?? this.replyTo,
      disableReplyTo: disableReplyTo ?? this.disableReplyTo,
      statePolicy: statePolicy ?? this.statePolicy,
      noPfsync: noPfsync ?? this.noPfsync,
      statTimeout: statTimeout ?? this.statTimeout,
      udpFirst: udpFirst ?? this.udpFirst,
      udpSingle: udpSingle ?? this.udpSingle,
      udpMultiple: udpMultiple ?? this.udpMultiple,
      adaptiveStart: adaptiveStart ?? this.adaptiveStart,
      adaptiveEnd: adaptiveEnd ?? this.adaptiveEnd,
      max: max ?? this.max,
      maxSrcNodes: maxSrcNodes ?? this.maxSrcNodes,
      maxSrcStates: maxSrcStates ?? this.maxSrcStates,
      maxSrcConn: maxSrcConn ?? this.maxSrcConn,
      maxSrcConnRate: maxSrcConnRate ?? this.maxSrcConnRate,
      maxSrcConnRates: maxSrcConnRates ?? this.maxSrcConnRates,
      overload: overload ?? this.overload,
      shaper1: shaper1 ?? this.shaper1,
      shaper2: shaper2 ?? this.shaper2,
      prio: prio ?? this.prio,
      setPrio: setPrio ?? this.setPrio,
      setPrioLow: setPrioLow ?? this.setPrioLow,
      tos: tos ?? this.tos,
      tag: tag ?? this.tag,
      tagged: tagged ?? this.tagged,
    );
  }

  @override
  String toString() {
    return 'FirewallRule(uuid: $uuid, type: $type, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FirewallRule && other.uuid == uuid;
  }

  @override
  int get hashCode => uuid.hashCode;
}

/// Request model for creating/updating firewall rules
@JsonSerializable(createToJson: false)
class FirewallRuleRequest {
  // Use 'action' instead of 'type' as per OPNsense API
  @JsonKey(name: 'action')
  final String type;
  @JsonKey(name: 'interface')
  final String interfaceName;
  final String protocol;
  @JsonKey(name: 'icmptype', defaultValue: '')
  final String icmpType;
  @JsonKey(name: 'icmp6type', defaultValue: '')
  final String icmp6Type;

  // Source fields
  @JsonKey(name: 'source_net')
  final String source;
  @JsonKey(name: 'source_not', defaultValue: '0')
  final String sourceNot;

  // Destination fields
  @JsonKey(name: 'destination_net')
  final String destination;
  @JsonKey(name: 'destination_not', defaultValue: '0')
  final String destinationNot;

  @JsonKey(name: 'destination_port')
  final String destinationPort;
  @JsonKey(name: 'description')
  final String description;
  final String enabled;

  // Source port
  @JsonKey(name: 'source_port', defaultValue: '')
  final String sourcePort;

  // Direction / IP version / quick / log
  @JsonKey(name: 'log', defaultValue: '0')
  final String log;
  @JsonKey(name: 'ipprotocol', defaultValue: 'inet')
  final String ipProtocol;
  @JsonKey(name: 'direction', defaultValue: 'in')
  final String direction;
  @JsonKey(name: 'quick', defaultValue: '1')
  final String quick;
  @JsonKey(name: 'statetype', defaultValue: 'keep')
  final String stateType;

  // Organisation
  @JsonKey(name: 'interfacenot', defaultValue: '0')
  final String interfaceNot;
  @JsonKey(name: 'nosync', defaultValue: '0')
  final String noSync;
  @JsonKey(name: 'sequence', defaultValue: '')
  final String sequence;

  // Filter (advanced)
  @JsonKey(name: 'allowopts', defaultValue: '0')
  final String allowOpts;
  @JsonKey(name: 'tcpflags1', defaultValue: [])
  final List<String> tcpFlags1;
  @JsonKey(name: 'tcpflags2', defaultValue: [])
  final List<String> tcpFlags2;
  @JsonKey(name: 'tcpflags_any', defaultValue: '0')
  final String tcpFlagsAny;
  @JsonKey(name: 'sched', defaultValue: '')
  final String schedule;
  @JsonKey(name: 'divert-to', defaultValue: '')
  final String divertTo;

  // Source Routing
  @JsonKey(name: 'gateway', defaultValue: '')
  final String gateway;
  @JsonKey(name: 'replyto', defaultValue: '')
  final String replyTo;
  @JsonKey(name: 'disablereplyto', defaultValue: '0')
  final String disableReplyTo;

  // Stateful Firewall
  @JsonKey(name: 'state-policy', defaultValue: '')
  final String statePolicy;
  @JsonKey(name: 'nopfsync', defaultValue: '0')
  final String noPfsync;
  @JsonKey(name: 'statetimeout', defaultValue: '')
  final String statTimeout;
  @JsonKey(name: 'udp-first', defaultValue: '')
  final String udpFirst;
  @JsonKey(name: 'udp-single', defaultValue: '')
  final String udpSingle;
  @JsonKey(name: 'udp-multiple', defaultValue: '')
  final String udpMultiple;
  @JsonKey(name: 'adaptivestart', defaultValue: '')
  final String adaptiveStart;
  @JsonKey(name: 'adaptiveend', defaultValue: '')
  final String adaptiveEnd;
  @JsonKey(name: 'max', defaultValue: '')
  final String max;
  @JsonKey(name: 'max-src-nodes', defaultValue: '')
  final String maxSrcNodes;
  @JsonKey(name: 'max-src-states', defaultValue: '')
  final String maxSrcStates;
  @JsonKey(name: 'max-src-conn', defaultValue: '')
  final String maxSrcConn;
  @JsonKey(name: 'max-src-conn-rate', defaultValue: '')
  final String maxSrcConnRate;
  @JsonKey(name: 'max-src-conn-rates', defaultValue: '')
  final String maxSrcConnRates;
  @JsonKey(name: 'overload', defaultValue: '')
  final String overload;

  // Traffic Shaping
  @JsonKey(name: 'shaper1', defaultValue: '')
  final String shaper1;
  @JsonKey(name: 'shaper2', defaultValue: '')
  final String shaper2;

  // Priority
  @JsonKey(name: 'prio', defaultValue: '')
  final String prio;
  @JsonKey(name: 'set-prio', defaultValue: '')
  final String setPrio;
  @JsonKey(name: 'set-prio-low', defaultValue: '')
  final String setPrioLow;
  @JsonKey(name: 'tos', defaultValue: '')
  final String tos;

  // Internal Tagging
  @JsonKey(name: 'tag', defaultValue: '')
  final String tag;
  @JsonKey(name: 'tagged', defaultValue: '')
  final String tagged;

  // Organisation
  @JsonKey(name: 'categories', defaultValue: [])
  final List<String> categories;

  FirewallRuleRequest({
    required this.type,
    required this.interfaceName,
    required this.protocol,
    this.icmpType = '',
    this.icmp6Type = '',
    required this.source,
    required this.destination,
    required this.destinationPort,
    required this.description,
    this.enabled = '1',
    this.sourceNot = '0',
    this.destinationNot = '0',
    this.ipProtocol = 'inet',
    this.direction = 'in',
    this.quick = '1',
    this.sourcePort = '',
    this.log = '0',
    this.stateType = 'keep',
    this.interfaceNot = '0',
    this.noSync = '0',
    this.sequence = '',
    this.allowOpts = '0',
    this.tcpFlags1 = const [],
    this.tcpFlags2 = const [],
    this.tcpFlagsAny = '0',
    this.schedule = '',
    this.divertTo = '',
    this.gateway = '',
    this.replyTo = '',
    this.disableReplyTo = '0',
    this.statePolicy = '',
    this.noPfsync = '0',
    this.statTimeout = '',
    this.udpFirst = '',
    this.udpSingle = '',
    this.udpMultiple = '',
    this.adaptiveStart = '',
    this.adaptiveEnd = '',
    this.max = '',
    this.maxSrcNodes = '',
    this.maxSrcStates = '',
    this.maxSrcConn = '',
    this.maxSrcConnRate = '',
    this.maxSrcConnRates = '',
    this.overload = '',
    this.shaper1 = '',
    this.shaper2 = '',
    this.prio = '',
    this.setPrio = '',
    this.setPrioLow = '',
    this.tos = '',
    this.tag = '',
    this.tagged = '',
    this.categories = const [],
  });

  /// Create from JSON
  factory FirewallRuleRequest.fromJson(Map<String, dynamic> json) =>
      _$FirewallRuleRequestFromJson(json);

  /// Convert to JSON — builds the exact payload structure expected by
  /// POST /api/firewall/filter/add_rule and setRule.
  /// ALL fields must be present (the API rejects missing keys).
  Map<String, dynamic> toJson() {
    // protocol: 'any' stays lowercase; everything else uppercase per OPNsense
    final String protocolValue = protocol.toLowerCase() == 'any'
        ? 'any'
        : protocol.toUpperCase();

    // categories: join list to comma-separated string (API expects string, not array)
    final String categoriesValue = categories.join(',');

    // tcpflags: join list to comma-separated string
    // (the request model stores them but they come from form state via tcpFlags1/2
    //  which are passed separately — for now we send empty strings)
    // Source/dest always present as-is; empty fallback to 'any'
    final String src = source.isEmpty ? 'any' : source;
    final String dst = destination.isEmpty ? 'any' : destination;

    // sequence: OPNsense rejects empty string — default to '1' for new rules
    final String sequenceValue = sequence.isEmpty ? '1' : sequence;

    return <String, dynamic>{
      'enabled':          enabled,
      'sequence':         sequenceValue,
      'categories':       categoriesValue,
      'nosync':           noSync,
      'description':      description,
      'interfacenot':     interfaceNot,
      'interface':        interfaceName,
      'quick':            quick,
      'action':           type,
      'allowopts':        allowOpts,
      'direction':        direction,
      'ipprotocol':       ipProtocol,
      'protocol':         protocolValue,
      'icmptype':         icmpType,
      'icmp6type':        icmp6Type,
      'source_not':       sourceNot,
      'source_net':       src,
      'source_port':      sourcePort,
      'destination_not':  destinationNot,
      'destination_net':  dst,
      'destination_port': destinationPort,
      'log':              log,
      'tcpflags1':        tcpFlags1.join(','),
      'tcpflags2':        tcpFlags2.join(','),
      'tcpflags_any':     tcpFlagsAny,
      'sched':            schedule,
      'divert-to':        divertTo,
      'statetype':        stateType,
      'state-policy':     statePolicy,
      'nopfsync':         noPfsync,
      'statetimeout':     statTimeout,
      'udp-first':        udpFirst,
      'udp-single':       udpSingle,
      'udp-multiple':     udpMultiple,
      'adaptivestart':    adaptiveStart,
      'adaptiveend':      adaptiveEnd,
      'max':              max,
      'max-src-nodes':    maxSrcNodes,
      'max-src-states':   maxSrcStates,
      'max-src-conn':     maxSrcConn,
      'max-src-conn-rate':  maxSrcConnRate,
      'max-src-conn-rates': maxSrcConnRates,
      'overload':         overload,
      'shaper1':          shaper1,
      'shaper2':          shaper2,
      'gateway':          gateway,
      'disablereplyto':   disableReplyTo,
      'replyto':          replyTo,
      'prio':             prio,
      'set-prio':         setPrio,
      'set-prio-low':     setPrioLow,
      'tos':              tos,
      'tag':              tag,
      'tagged':           tagged,
    };
  }

  /// Create from FirewallRule
  factory FirewallRuleRequest.fromRule(FirewallRule rule) {
    return FirewallRuleRequest(
      type: rule.type,
      interfaceName: rule.interfaceName,
      protocol: rule.protocol,
      source: rule.source,
      destination: rule.destination,
      destinationPort: rule.destinationPort,
      description: rule.description,
      enabled: rule.enabled,
      sourceNot: rule.sourceNot,
      destinationNot: rule.destinationNot,
      direction: rule.direction,
      ipProtocol: rule.ipProtocol,
      quick: rule.quick,
      log: rule.log,
      stateType: rule.stateType,
      sourcePort: rule.sourcePort,
      interfaceNot: rule.interfaceNot,
      noSync: rule.noSync,
      allowOpts: rule.allowOpts,
      tcpFlags1: List<String>.from(rule.tcpFlags1),
      tcpFlags2: List<String>.from(rule.tcpFlags2),
      tcpFlagsAny: rule.tcpFlagsAny,
      schedule: rule.schedule,
      divertTo: rule.divertTo,
      gateway: rule.gateway,
      replyTo: rule.replyTo,
      disableReplyTo: rule.disableReplyTo,
      statePolicy: rule.statePolicy,
      noPfsync: rule.noPfsync,
      statTimeout: rule.statTimeout,
      udpFirst: rule.udpFirst,
      udpSingle: rule.udpSingle,
      udpMultiple: rule.udpMultiple,
      adaptiveStart: rule.adaptiveStart,
      adaptiveEnd: rule.adaptiveEnd,
      max: rule.max,
      maxSrcNodes: rule.maxSrcNodes,
      maxSrcStates: rule.maxSrcStates,
      maxSrcConn: rule.maxSrcConn,
      maxSrcConnRate: rule.maxSrcConnRate,
      maxSrcConnRates: rule.maxSrcConnRates,
      overload: rule.overload,
      shaper1: rule.shaper1,
      shaper2: rule.shaper2,
      prio: rule.prio,
      setPrio: rule.setPrio,
      setPrioLow: rule.setPrioLow,
      tos: rule.tos,
      tag: rule.tag,
      tagged: rule.tagged,
    );
  }
}
