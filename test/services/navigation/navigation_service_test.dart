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

import 'package:flutter_test/flutter_test.dart';
import 'package:opnsense_manager/services/navigation/navigation_service.dart';

void main() {
  group('NavigationService', () {
    group('isRouteActive', () {
      test('returns true when routes match exactly', () {
        expect(
          NavigationService.isRouteActive('dashboard', 'dashboard'),
          isTrue,
        );
      });

      test('returns false when routes do not match', () {
        expect(
          NavigationService.isRouteActive('dashboard', 'settings'),
          isFalse,
        );
      });

      test('returns false for partial matches', () {
        expect(
          NavigationService.isRouteActive('firewall_rules', 'firewall'),
          isFalse,
        );
      });
    });

    group('isRouteInSection', () {
      test('returns true when route starts with prefix', () {
        expect(
          NavigationService.isRouteInSection('firewall_rules', 'firewall_'),
          isTrue,
        );
      });

      test('returns true for exact match with prefix', () {
        expect(
          NavigationService.isRouteInSection('firewall_', 'firewall_'),
          isTrue,
        );
      });

      test('returns false when route does not start with prefix', () {
        expect(
          NavigationService.isRouteInSection('dashboard', 'firewall_'),
          isFalse,
        );
      });

      test('returns false for partial prefix match', () {
        expect(
          NavigationService.isRouteInSection('fire', 'firewall_'),
          isFalse,
        );
      });

      test('handles multiple route prefixes correctly', () {
        const route = 'wireguard_servers';
        expect(
          NavigationService.isRouteInSection(route, 'wireguard_'),
          isTrue,
        );
        expect(
          NavigationService.isRouteInSection(route, 'vpn_'),
          isFalse,
        );
      });

      test('handles nested route prefixes', () {
        const route = 'tailscale_authentication';
        expect(
          NavigationService.isRouteInSection(route, 'tailscale_'),
          isTrue,
        );
        expect(
          NavigationService.isRouteInSection(route, 'vpn_'),
          isFalse,
        );
      });
    });

    group('Route prefix patterns', () {
      test('firewall routes are detected correctly', () {
        final firewallRoutes = [
          'firewall_rules',
          'firewall_aliases',
          'firewall_logs',
        ];

        for (final route in firewallRoutes) {
          expect(
            NavigationService.isRouteInSection(route, 'firewall_'),
            isTrue,
            reason: '$route should be in firewall section',
          );
        }
      });

      test('VPN routes are detected correctly', () {
        final vpnRoutes = [
          'wireguard_servers',
          'wireguard_clients',
          'wireguard_peers',
          'openvpn_servers',
          'openvpn_clients',
          'tailscale_authentication',
          'tailscale_settings',
          'tailscale_status',
        ];

        for (final route in vpnRoutes) {
          final prefix = '${route.split('_')[0]}_';
          expect(
            NavigationService.isRouteInSection(route, prefix),
            isTrue,
            reason: '$route should be in its respective VPN section',
          );
        }
      });

      test('non-VPN routes are not detected as VPN routes', () {
        final nonVpnRoutes = [
          'dashboard',
          'system_info',
          'firewall_rules',
          'live_network_monitor',
          'dhcp_leases',
          'settings',
        ];

        for (final route in nonVpnRoutes) {
          expect(
            NavigationService.isRouteInSection(route, 'vpn_'),
            isFalse,
            reason: '$route should not be in VPN section',
          );
        }
      });
    });
  });
}


