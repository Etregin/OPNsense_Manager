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
import '../../models/network_host.dart';

/// Generator for network-related demo data
/// 
/// Handles generation of:
/// - Network hosts with bandwidth usage
/// - DHCP leases (active and expired)
class DemoNetworkDataGenerator {
  final Random _random = Random();

  /// Generate demo network hosts with realistic bandwidth usage
  List<NetworkHost> generateNetworkHosts() {
    final hosts = <NetworkHost>[
      NetworkHost(
        address: '192.168.1.10',
        hostname: 'desktop-gaming',
        manufacturer: 'Intel Corporate',
        macAddress: '00:1A:2B:3C:4D:5E',
        rateIn: 15000000 + _random.nextInt(5000000), // 15-20 Mbps download
        rateOut: 2000000 + _random.nextInt(1000000),  // 2-3 Mbps upload
        leaseExpiry: DateTime.now().add(Duration(hours: 12 + _random.nextInt(12))),
      ),
      NetworkHost(
        address: '192.168.1.15',
        hostname: 'iphone-john',
        manufacturer: 'Apple, Inc.',
        macAddress: '00:1B:63:84:45:E6',
        rateIn: 8000000 + _random.nextInt(4000000),  // 8-12 Mbps download
        rateOut: 1000000 + _random.nextInt(500000),  // 1-1.5 Mbps upload
        leaseExpiry: DateTime.now().add(Duration(hours: 6 + _random.nextInt(6))),
      ),
      NetworkHost(
        address: '192.168.1.20',
        hostname: 'smart-tv-living',
        manufacturer: 'Samsung Electronics',
        macAddress: '00:1C:42:00:00:09',
        rateIn: 25000000 + _random.nextInt(10000000), // 25-35 Mbps (4K streaming)
        rateOut: 500000 + _random.nextInt(300000),    // 0.5-0.8 Mbps upload
        leaseExpiry: DateTime.now().add(const Duration(hours: 24)),
      ),
      NetworkHost(
        address: '192.168.1.25',
        hostname: 'laptop-work',
        manufacturer: 'Dell Inc.',
        macAddress: '00:1D:60:B3:01:84',
        rateIn: 5000000 + _random.nextInt(3000000),  // 5-8 Mbps download
        rateOut: 800000 + _random.nextInt(400000),   // 0.8-1.2 Mbps upload
        leaseExpiry: DateTime.now().add(Duration(hours: 8 + _random.nextInt(8))),
      ),
      NetworkHost(
        address: '192.168.1.30',
        hostname: 'nas-server',
        manufacturer: 'Synology Inc.',
        macAddress: '00:11:32:2C:A7:85',
        rateIn: 3000000 + _random.nextInt(2000000),  // 3-5 Mbps download
        rateOut: 10000000 + _random.nextInt(5000000), // 10-15 Mbps upload (backup)
        leaseExpiry: DateTime.now().add(const Duration(days: 7)),
      ),
      NetworkHost(
        address: '192.168.1.35',
        hostname: 'tablet-kids',
        manufacturer: 'Amazon Technologies',
        macAddress: '00:FC:8B:33:44:55',
        rateIn: 4000000 + _random.nextInt(2000000),  // 4-6 Mbps download
        rateOut: 300000 + _random.nextInt(200000),   // 0.3-0.5 Mbps upload
        leaseExpiry: DateTime.now().add(Duration(hours: 4 + _random.nextInt(4))),
      ),
      NetworkHost(
        address: '192.168.1.40',
        hostname: 'security-camera-1',
        manufacturer: 'Hikvision',
        macAddress: '00:12:17:A0:B1:C2',
        rateIn: 100000 + _random.nextInt(50000),     // 0.1-0.15 Mbps download
        rateOut: 2000000 + _random.nextInt(1000000), // 2-3 Mbps upload (video)
        leaseExpiry: DateTime.now().add(const Duration(days: 30)),
      ),
      NetworkHost(
        address: '192.168.1.45',
        hostname: 'iot-hub',
        manufacturer: 'Raspberry Pi Foundation',
        macAddress: 'B8:27:EB:12:34:56',
        rateIn: 200000 + _random.nextInt(100000),    // 0.2-0.3 Mbps download
        rateOut: 150000 + _random.nextInt(100000),   // 0.15-0.25 Mbps upload
        leaseExpiry: DateTime.now().add(const Duration(days: 90)),
      ),
      NetworkHost(
        address: '192.168.1.50',
        hostname: 'android-tablet',
        manufacturer: 'Google, Inc.',
        macAddress: '00:1A:11:FF:EE:DD',
        rateIn: 6000000 + _random.nextInt(3000000),  // 6-9 Mbps download
        rateOut: 700000 + _random.nextInt(300000),   // 0.7-1 Mbps upload
        leaseExpiry: DateTime.now().add(Duration(hours: 10 + _random.nextInt(10))),
      ),
      NetworkHost(
        address: '192.168.1.55',
        hostname: '192.168.1.55', // Unknown device (no hostname)
        manufacturer: null,
        macAddress: null,
        rateIn: 1000000 + _random.nextInt(500000),   // 1-1.5 Mbps download
        rateOut: 500000 + _random.nextInt(300000),   // 0.5-0.8 Mbps upload
        leaseExpiry: null,
      ),
    ];

    // Sort by total bandwidth usage (highest first)
    hosts.sort((a, b) => b.totalRate.compareTo(a.totalRate));
    
    return hosts;
  }

  /// Generate demo DHCP leases with active and expired entries
  List<Map<String, dynamic>> generateDhcpLeases() {
    final now = DateTime.now();
    
    return [
      {
        'address': '192.168.1.10',
        'hostname': 'desktop-gaming',
        'hwaddr': '00:1A:2B:3C:4D:5E',
        'mac_info': 'ASUS',
        'starts': now.subtract(const Duration(hours: 48)).millisecondsSinceEpoch ~/ 1000,
        'ends': now.add(const Duration(hours: 24)).millisecondsSinceEpoch ~/ 1000,
        'expire': now.add(const Duration(hours: 24)).millisecondsSinceEpoch ~/ 1000,
        'state': 'active',
        'if': 'lan',
        'type': 'static',
      },
      {
        'address': '192.168.1.15',
        'hostname': 'iphone-john',
        'hwaddr': '00:1B:63:84:45:E6',
        'mac_info': 'Apple, Inc.',
        'starts': now.subtract(const Duration(hours: 12)).millisecondsSinceEpoch ~/ 1000,
        'ends': now.add(const Duration(hours: 12)).millisecondsSinceEpoch ~/ 1000,
        'expire': now.add(const Duration(hours: 12)).millisecondsSinceEpoch ~/ 1000,
        'state': 'active',
        'if': 'lan',
        'type': 'dynamic',
      },
      {
        'address': '192.168.1.20',
        'hostname': 'smart-tv-living',
        'hwaddr': '00:1C:42:00:00:09',
        'mac_info': 'Samsung Electronics',
        'starts': now.subtract(const Duration(days: 2)).millisecondsSinceEpoch ~/ 1000,
        'ends': now.add(const Duration(hours: 24)).millisecondsSinceEpoch ~/ 1000,
        'expire': now.add(const Duration(hours: 24)).millisecondsSinceEpoch ~/ 1000,
        'state': 'active',
        'if': 'lan',
        'type': 'dynamic',
      },
      {
        'address': '192.168.1.25',
        'hostname': 'laptop-work',
        'hwaddr': '00:1D:60:B3:01:84',
        'mac_info': 'Dell Inc.',
        'starts': now.subtract(const Duration(hours: 8)).millisecondsSinceEpoch ~/ 1000,
        'ends': now.add(const Duration(hours: 16)).millisecondsSinceEpoch ~/ 1000,
        'expire': now.add(const Duration(hours: 16)).millisecondsSinceEpoch ~/ 1000,
        'state': 'active',
        'if': 'lan',
        'type': 'dynamic',
      },
      {
        'address': '192.168.1.30',
        'hostname': 'nas-server',
        'hwaddr': '00:11:32:2C:A7:85',
        'mac_info': 'Synology Inc.',
        'starts': now.subtract(const Duration(days: 7)).millisecondsSinceEpoch ~/ 1000,
        'ends': now.add(const Duration(days: 7)).millisecondsSinceEpoch ~/ 1000,
        'expire': now.add(const Duration(days: 7)).millisecondsSinceEpoch ~/ 1000,
        'state': 'active',
        'if': 'lan',
        'type': 'static',
      },
      {
        'address': '192.168.1.35',
        'hostname': 'tablet-kids',
        'hwaddr': '00:FC:8B:33:44:55',
        'mac_info': 'Amazon Technologies',
        'starts': now.subtract(const Duration(hours: 6)).millisecondsSinceEpoch ~/ 1000,
        'ends': now.add(const Duration(hours: 6)).millisecondsSinceEpoch ~/ 1000,
        'expire': now.add(const Duration(hours: 6)).millisecondsSinceEpoch ~/ 1000,
        'state': 'active',
        'if': 'lan',
        'type': 'dynamic',
      },
      {
        'address': '192.168.1.40',
        'hostname': 'security-camera-1',
        'hwaddr': '00:12:17:A0:B1:C2',
        'mac_info': 'Hikvision',
        'starts': now.subtract(const Duration(days: 30)).millisecondsSinceEpoch ~/ 1000,
        'ends': now.add(const Duration(days: 30)).millisecondsSinceEpoch ~/ 1000,
        'expire': now.add(const Duration(days: 30)).millisecondsSinceEpoch ~/ 1000,
        'state': 'active',
        'if': 'lan',
        'type': 'static',
      },
      {
        'address': '192.168.1.45',
        'hostname': 'iot-hub',
        'hwaddr': 'B8:27:EB:12:34:56',
        'mac_info': 'Raspberry Pi Foundation',
        'starts': now.subtract(const Duration(days: 90)).millisecondsSinceEpoch ~/ 1000,
        'ends': now.add(const Duration(days: 90)).millisecondsSinceEpoch ~/ 1000,
        'expire': now.add(const Duration(days: 90)).millisecondsSinceEpoch ~/ 1000,
        'state': 'active',
        'if': 'lan',
        'type': 'static',
      },
      {
        'address': '192.168.1.50',
        'hostname': 'android-tablet',
        'hwaddr': '00:1A:11:FF:EE:DD',
        'mac_info': 'Google, Inc.',
        'starts': now.subtract(const Duration(hours: 18)).millisecondsSinceEpoch ~/ 1000,
        'ends': now.add(const Duration(hours: 18)).millisecondsSinceEpoch ~/ 1000,
        'expire': now.add(const Duration(hours: 18)).millisecondsSinceEpoch ~/ 1000,
        'state': 'active',
        'if': 'lan',
        'type': 'dynamic',
      },
      {
        'address': '192.168.1.100',
        'hostname': 'old-laptop',
        'hwaddr': 'AA:BB:CC:DD:EE:FF',
        'mac_info': 'HP Inc.',
        'starts': now.subtract(const Duration(days: 5)).millisecondsSinceEpoch ~/ 1000,
        'ends': now.subtract(const Duration(hours: 2)).millisecondsSinceEpoch ~/ 1000,
        'expire': now.subtract(const Duration(hours: 2)).millisecondsSinceEpoch ~/ 1000,
        'state': 'expired',
        'if': 'lan',
        'type': 'dynamic',
      },
      {
        'address': '192.168.1.101',
        'hostname': 'guest-phone',
        'hwaddr': '11:22:33:44:55:66',
        'mac_info': 'Xiaomi Communications',
        'starts': now.subtract(const Duration(days: 1)).millisecondsSinceEpoch ~/ 1000,
        'ends': now.subtract(const Duration(minutes: 30)).millisecondsSinceEpoch ~/ 1000,
        'expire': now.subtract(const Duration(minutes: 30)).millisecondsSinceEpoch ~/ 1000,
        'state': 'expired',
        'if': 'lan',
      },
    ];
  }
}


