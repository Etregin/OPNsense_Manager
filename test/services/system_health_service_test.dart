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
import 'package:opnsense_manager/constants/api_endpoints.dart';
import 'package:opnsense_manager/services/demo/demo_system_health_data_generator.dart';

void main() {
  // -------------------------------------------------------------------------
  // ApiEndpoints — system-health constants
  // -------------------------------------------------------------------------
  group('ApiEndpoints system-health', () {
    test('systemHealthGet path is correct', () {
      expect(ApiEndpoints.systemHealthGet, '/diagnostics/systemhealth/get');
    });

    test('systemHealthGetRrdList path is correct', () {
      expect(
        ApiEndpoints.systemHealthGetRrdList,
        '/diagnostics/systemhealth/get_rrd_list',
      );
    });

    test('systemHealthGetGraph with default period', () {
      expect(
        ApiEndpoints.systemHealthGetGraph('lan-packets'),
        '/diagnostics/systemhealth/get_system_health/lan-packets/0',
      );
    });

    test('systemHealthGetGraph with explicit period', () {
      expect(
        ApiEndpoints.systemHealthGetGraph('memory-system', period: 2),
        '/diagnostics/systemhealth/get_system_health/memory-system/2',
      );
    });

    // Verify the documented key derivation convention for each category type:
    // packets/traffic → "{subject}-{category}"
    // system          → "{subject}-system"
    // services        → "{subject}" (bare)
    test('packets key derivation: subject-packets', () {
      const subject = 'lan';
      const category = 'packets';
      final key = '$subject-$category'; // lan-packets
      expect(
        ApiEndpoints.systemHealthGetGraph(key),
        '/diagnostics/systemhealth/get_system_health/lan-packets/0',
      );
    });

    test('traffic key derivation: subject-traffic', () {
      const subject = 'wan';
      const category = 'traffic';
      final key = '$subject-$category'; // wan-traffic
      expect(
        ApiEndpoints.systemHealthGetGraph(key),
        '/diagnostics/systemhealth/get_system_health/wan-traffic/0',
      );
    });

    test('system key derivation: subject-system', () {
      const subject = 'processor';
      final key = '$subject-system'; // processor-system
      expect(
        ApiEndpoints.systemHealthGetGraph(key),
        '/diagnostics/systemhealth/get_system_health/processor-system/0',
      );
    });

    test('services key derivation: subject-services', () {
      const key = 'ntpd-services';
      expect(
        ApiEndpoints.systemHealthGetGraph(key),
        '/diagnostics/systemhealth/get_system_health/ntpd-services/0',
      );
    });
  });

  // -------------------------------------------------------------------------
  // DemoSystemHealthDataGenerator
  // -------------------------------------------------------------------------
  group('DemoSystemHealthDataGenerator', () {
    final gen = DemoSystemHealthDataGenerator();

    group('generateStatus', () {
      test('returns enabled status', () {
        final status = gen.generateStatus();
        expect(status.isEnabled, isTrue);
      });
    });

    group('generateRrdList', () {
      test('returns all four categories in order', () {
        final rrd = gen.generateRrdList();
        expect(rrd.categories, ['packets', 'services', 'system', 'traffic']);
      });

      test('packets category has four subjects', () {
        final rrd = gen.generateRrdList();
        expect(rrd.subjectsFor('packets'), ['ipsec', 'lan', 'wan', 'opt1']);
      });

      test('system category has four subjects', () {
        final rrd = gen.generateRrdList();
        expect(rrd.subjectsFor('system'), [
          'mbuf',
          'memory',
          'processor',
          'states',
        ]);
      });

      test('services category has ntpd subject', () {
        final rrd = gen.generateRrdList();
        expect(rrd.subjectsFor('services'), contains('ntpd'));
      });

      test('files list is non-empty', () {
        final rrd = gen.generateRrdList();
        expect(rrd.files, isNotEmpty);
      });

      test('interfaces map has wan, lan, and opt1 entries', () {
        final rrd = gen.generateRrdList();
        expect(rrd.interfaces.containsKey('wan'), isTrue);
        expect(rrd.interfaces.containsKey('lan'), isTrue);
        expect(rrd.interfaces.containsKey('opt1'), isTrue);
        expect(rrd.interfaces['opt1']?.descr, 'WAN2_MIFI');
      });
    });

    group('generateGraph', () {
      test('packets graph has four series', () {
        final graph = gen.generateGraph('lan-packets');
        expect(graph.set.count, 4);
        expect(
          graph.set.data.map((s) => s.key).toList(),
          containsAll(['inpass', 'outpass', 'inblock', 'outblock']),
        );
      });

      test('traffic graph has two series', () {
        final graph = gen.generateGraph('wan-traffic');
        expect(graph.set.count, 2);
        expect(
          graph.set.data.map((s) => s.key).toList(),
          containsAll(['in', 'out']),
        );
      });

      test('processor-system graph has four series', () {
        final graph = gen.generateGraph('processor-system');
        expect(
          graph.set.data.map((s) => s.key).toList(),
          containsAll(['user', 'system', 'interrupt', 'nice']),
        );
      });

      test('memory-system graph has four series', () {
        final graph = gen.generateGraph('memory-system');
        expect(
          graph.set.data.map((s) => s.key).toList(),
          containsAll(['active', 'inactive', 'wired', 'free']),
        );
      });

      test('mbuf-system graph has four series', () {
        final graph = gen.generateGraph('mbuf-system');
        expect(
          graph.set.data.map((s) => s.key).toList(),
          containsAll(['current', 'cache', 'total', 'max']),
        );
      });

      test('states-system graph has two series', () {
        final graph = gen.generateGraph('states-system');
        expect(
          graph.set.data.map((s) => s.key).toList(),
          containsAll(['current', 'max']),
        );
      });

      test('service graph (ntpd-services) has offset and frequency series', () {
        final graph = gen.generateGraph('ntpd-services');
        expect(
          graph.set.data.map((s) => s.key).toList(),
          containsAll(['offset', 'frequency']),
        );
      });

      test('graph step is 60 seconds', () {
        final graph = gen.generateGraph('lan-packets');
        expect(graph.step, 60);
      });

      test('graph has 1440 points per series (24 h at 60 s)', () {
        final graph = gen.generateGraph('lan-packets');
        for (final series in graph.set.data) {
          expect(series.values.length, 1440);
        }
      });

      test('all points have non-null timestamps', () {
        final graph = gen.generateGraph('processor-system');
        for (final series in graph.set.data) {
          for (final point in series.values) {
            expect(point.timestampMs, greaterThan(0));
          }
        }
      });

      test('all generated values are non-negative', () {
        final graph = gen.generateGraph('lan-traffic');
        for (final series in graph.set.data) {
          for (final point in series.values) {
            if (point.value != null) {
              expect(point.value!, greaterThanOrEqualTo(0.0));
            }
          }
        }
      });

      test('points are in ascending timestamp order', () {
        final graph = gen.generateGraph('memory-system');
        final points = graph.set.data.first.values;
        for (int i = 1; i < points.length; i++) {
          expect(points[i].timestampMs, greaterThan(points[i - 1].timestampMs));
        }
      });

      test('consecutive timestamps differ by 60 000 ms', () {
        final graph = gen.generateGraph('wan-packets');
        final points = graph.set.data.first.values;
        for (int i = 1; i < points.length; i++) {
          expect(points[i].timestampMs - points[i - 1].timestampMs, 60000);
        }
      });

      test('ipsec-packets is treated as packets category', () {
        final graph = gen.generateGraph('ipsec-packets');
        expect(
          graph.set.data.map((s) => s.key).toList(),
          containsAll(['inpass', 'outpass']),
        );
      });

      test('opt1-traffic is treated as traffic category', () {
        final graph = gen.generateGraph('opt1-traffic');
        expect(
          graph.set.data.map((s) => s.key).toList(),
          containsAll(['in', 'out']),
        );
      });
    });
  });
}
