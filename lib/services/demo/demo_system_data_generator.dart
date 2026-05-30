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
import '../../models/system_info.dart';
import 'demo_state_manager.dart';

/// Generator for system-related demo data
/// 
/// Handles generation of:
/// - System information (CPU, memory, disk, uptime)
/// - Services status
/// - Gateway information
class DemoSystemDataGenerator {
  final DemoStateManager _stateManager;
  final Random _random = Random();

  DemoSystemDataGenerator(this._stateManager);

  /// Generate demo system info with realistic resource usage
  SystemInfo generateSystemInfo() {
    final uptime = Duration(
      days: 15,
      hours: _random.nextInt(24),
      minutes: _random.nextInt(60),
    );
    final cpuUsage = 15 + _random.nextInt(30); // 15-45%
    final memoryUsage = 40 + _random.nextInt(20); // 40-60%
    final diskUsage = 25 + _random.nextInt(30); // 25-55%

    final memoryTotal = 8589934592; // 8GB
    final memoryUsed = (memoryTotal * memoryUsage / 100).round();
    // ARC typically uses 50-60% of used memory on ZFS systems
    final memoryArc = (memoryUsed * (0.5 + _random.nextDouble() * 0.1)).round();

    return SystemInfo(
      hostname: 'demo-opnsense',
      version: '24.7.1',
      platform: 'amd64',
      uptime: uptime.inSeconds,
      cpuUsage: cpuUsage.toDouble(),
      memoryTotal: memoryTotal,
      memoryUsed: memoryUsed,
      memoryArc: memoryArc,
      diskTotal: 107374182400, // 100GB
      diskUsed: (107374182400 * diskUsage / 100).round(),
      type: 'opnsense',
      architecture: 'amd64',
      commit: 'c2f076f30',
      mirror: 'https://pkg.opnsense.org',
      repositories: 'OPNsense (Priority: 11)',
      updatedOn: DateTime.now().subtract(const Duration(days: 7)).toIso8601String(),
    );
  }

  /// Generate demo services with stateful status
  Map<String, dynamic> generateServices() {
    return {
      'services': [
        {
          'name': 'unbound',
          'description': 'DNS Resolver',
          'status': _stateManager.getServiceState('unbound', true) ? 'running' : 'stopped',
        },
        {
          'name': 'ntpd',
          'description': 'NTP Service',
          'status': _stateManager.getServiceState('ntpd', true) ? 'running' : 'stopped',
        },
        {
          'name': 'sshd',
          'description': 'SSH Service',
          'status': _stateManager.getServiceState('sshd', true) ? 'running' : 'stopped',
        },
        {
          'name': 'dhcpd',
          'description': 'DHCP Service',
          'status': _stateManager.getServiceState('dhcpd', true) ? 'running' : 'stopped',
        },
        {
          'name': 'openvpn',
          'description': 'OpenVPN Service',
          'status': _stateManager.getServiceState('openvpn', true) ? 'running' : 'stopped',
        },
      ],
    };
  }

  /// Generate demo gateways with realistic latency
  List<Map<String, dynamic>> generateGateways() {
    return [
      {
        'name': 'WAN_DHCP',
        'address': '203.0.113.1',
        'status': 'online',
        'delay': '${5 + _random.nextInt(10)}ms',
        'stddev': '${1 + _random.nextInt(3)}ms',
        'loss': '0%',
      },
      {
        'name': 'WAN_BACKUP',
        'address': '198.51.100.1',
        'status': 'online',
        'delay': '${8 + _random.nextInt(15)}ms',
        'stddev': '${2 + _random.nextInt(4)}ms',
        'loss': '0%',
      },
    ];
  }
}


