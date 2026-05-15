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

import 'dart:math';
import '../../models/firewall_rule.dart';
import '../../models/firewall_alias.dart';
import 'demo_state_manager.dart';

/// Generator for firewall-related demo data
/// 
/// Handles generation of:
/// - Firewall rules with stateful enabled/disabled states
/// - Firewall aliases (hosts, networks, ports, geoip)
/// - Firewall logs with realistic traffic patterns
/// - Available network interfaces
class DemoFirewallDataGenerator {
  final DemoStateManager _stateManager;
  final Random _random = Random();

  DemoFirewallDataGenerator(this._stateManager);

  /// Generate demo firewall rules with stateful enabled/disabled states
  List<FirewallRule> generateFirewallRules() {
    final rules = <FirewallRule>[
      FirewallRule(
        uuid: 'demo-rule-1',
        type: 'pass',
        interfaceName: 'wan',
        protocol: 'tcp',
        source: 'any',
        sourcePort: '',
        destination: 'any',
        destinationPort: '443',
        description: 'Allow HTTPS from WAN',
        enabled: _stateManager.getFirewallRuleState('demo-rule-1', true) ? '1' : '0',
        sequence: 1,
      ),
      FirewallRule(
        uuid: 'demo-rule-2',
        type: 'pass',
        interfaceName: 'lan',
        protocol: 'any',
        source: '192.168.1.0/24',
        sourcePort: '',
        destination: 'any',
        destinationPort: '',
        description: 'Allow LAN to any',
        enabled: _stateManager.getFirewallRuleState('demo-rule-2', true) ? '1' : '0',
        sequence: 2,
      ),
      FirewallRule(
        uuid: 'demo-rule-3',
        type: 'block',
        interfaceName: 'wan',
        protocol: 'tcp',
        source: 'any',
        sourcePort: '',
        destination: 'any',
        destinationPort: '22',
        description: 'Block SSH from WAN',
        enabled: _stateManager.getFirewallRuleState('demo-rule-3', false) ? '1' : '0',
        sequence: 3,
      ),
      FirewallRule(
        uuid: 'demo-rule-4',
        type: 'pass',
        interfaceName: 'wan',
        protocol: 'tcp',
        source: 'any',
        sourcePort: '',
        destination: 'any',
        destinationPort: '80',
        description: 'Allow HTTP from WAN',
        enabled: _stateManager.getFirewallRuleState('demo-rule-4', true) ? '1' : '0',
        sequence: 4,
      ),
    ];

    return rules;
  }

  /// Generate demo firewall aliases with various types
  List<FirewallAlias> generateFirewallAliases() {
    final aliases = <FirewallAlias>[
      FirewallAlias(
        uuid: 'demo-alias-1',
        name: 'RFC1918_Networks',
        type: 'network',
        content: '10.0.0.0/8,172.16.0.0/12,192.168.0.0/16',
        description: 'Private IPv4 address ranges',
        enabled: _stateManager.getFirewallAliasState('demo-alias-1', true) ? '1' : '0',
        counters: '1',
      ),
      FirewallAlias(
        uuid: 'demo-alias-2',
        name: 'Trusted_Hosts',
        type: 'host',
        content: '192.168.1.10,192.168.1.15,192.168.1.20',
        description: 'Trusted devices on LAN',
        enabled: _stateManager.getFirewallAliasState('demo-alias-2', true) ? '1' : '0',
        counters: '1',
      ),
      FirewallAlias(
        uuid: 'demo-alias-3',
        name: 'Web_Ports',
        type: 'port',
        content: '80,443,8080,8443',
        description: 'Common web service ports',
        enabled: _stateManager.getFirewallAliasState('demo-alias-3', true) ? '1' : '0',
        proto: 'tcp',
      ),
      FirewallAlias(
        uuid: 'demo-alias-4',
        name: 'DNS_Servers',
        type: 'host',
        content: '8.8.8.8,8.8.4.4,1.1.1.1,1.0.0.1',
        description: 'Public DNS servers (Google, Cloudflare)',
        enabled: _stateManager.getFirewallAliasState('demo-alias-4', true) ? '1' : '0',
        counters: '1',
      ),
      FirewallAlias(
        uuid: 'demo-alias-5',
        name: 'Blocked_Countries',
        type: 'geoip',
        content: 'CN,RU,KP',
        description: 'Countries to block',
        enabled: _stateManager.getFirewallAliasState('demo-alias-5', false) ? '1' : '0',
      ),
      FirewallAlias(
        uuid: 'demo-alias-6',
        name: 'Mail_Ports',
        type: 'port',
        content: '25,465,587,993,995',
        description: 'Email service ports',
        enabled: _stateManager.getFirewallAliasState('demo-alias-6', true) ? '1' : '0',
        proto: 'tcp',
      ),
      FirewallAlias(
        uuid: 'demo-alias-7',
        name: 'IoT_Devices',
        type: 'host',
        content: '192.168.1.40,192.168.1.45',
        description: 'IoT and smart home devices',
        enabled: _stateManager.getFirewallAliasState('demo-alias-7', true) ? '1' : '0',
        counters: '1',
      ),
      FirewallAlias(
        uuid: 'demo-alias-8',
        name: 'VPN_Ports',
        type: 'port',
        content: '1194,1723,500,4500',
        description: 'VPN service ports (OpenVPN, PPTP, IPSec)',
        enabled: _stateManager.getFirewallAliasState('demo-alias-8', true) ? '1' : '0',
        proto: 'udp',
      ),
    ];

    // Filter out deleted aliases
    return aliases.where((alias) => !_stateManager.isAliasDeleted(alias.uuid)).toList();
  }

  /// Generate demo firewall logs with realistic traffic patterns
  List<Map<String, dynamic>> generateFirewallLogs({int limit = 100}) {
    final logs = <Map<String, dynamic>>[];
    final actions = ['pass', 'block'];
    final interfaces = ['wan', 'lan', 'opt1'];
    final protocols = ['tcp', 'udp', 'icmp'];
    final sources = ['192.168.1.100', '192.168.1.101', '203.0.113.50', '198.51.100.75', '10.0.0.25'];
    final destinations = ['192.168.1.1', '8.8.8.8', '1.1.1.1', '192.168.1.50'];

    for (int i = 0; i < limit; i++) {
      final timestamp = DateTime.now().subtract(Duration(minutes: i * 2));
      logs.add({
        'timestamp': timestamp.toIso8601String(),
        'action': actions[_random.nextInt(actions.length)],
        'interface': interfaces[_random.nextInt(interfaces.length)],
        'protocol': protocols[_random.nextInt(protocols.length)],
        'source': sources[_random.nextInt(sources.length)],
        'destination': destinations[_random.nextInt(destinations.length)],
        'sourcePort': 1024 + _random.nextInt(64000),
        'destinationPort': [80, 443, 22, 53, 123][_random.nextInt(5)],
      });
    }

    return logs;
  }

  /// Generate available interfaces for firewall rules
  Map<String, dynamic> generateAvailableInterfaces() {
    return {
      'wan': {'value': 'wan', 'selected': 0, 'description': 'WAN'},
      'lan': {'value': 'lan', 'selected': 0, 'description': 'LAN'},
      'opt1': {'value': 'opt1', 'selected': 0, 'description': 'OPT1'},
    };
  }
}


