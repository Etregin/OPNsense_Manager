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
import 'package:opnsense_manager/models/system_health_graph.dart';
import 'package:opnsense_manager/models/system_health_rrd_list.dart';
import 'package:opnsense_manager/models/system_health_status.dart';

void main() {
  // -------------------------------------------------------------------------
  // SystemHealthStatus
  // -------------------------------------------------------------------------
  group('SystemHealthStatus', () {
    test('parses enabled "1" string', () {
      final s = SystemHealthStatus.fromJson({
        'systemhealth': {'enabled': '1'},
      });
      expect(s.isEnabled, isTrue);
    });

    test('parses disabled "0" string', () {
      final s = SystemHealthStatus.fromJson({
        'systemhealth': {'enabled': '0'},
      });
      expect(s.isEnabled, isFalse);
    });

    test('parses enabled integer 1', () {
      final s = SystemHealthStatus.fromJson({
        'systemhealth': {'enabled': 1},
      });
      expect(s.isEnabled, isTrue);
    });

    test('parses disabled integer 0', () {
      final s = SystemHealthStatus.fromJson({
        'systemhealth': {'enabled': 0},
      });
      expect(s.isEnabled, isFalse);
    });

    test('parses enabled boolean true', () {
      final s = SystemHealthStatus.fromJson({
        'systemhealth': {'enabled': true},
      });
      expect(s.isEnabled, isTrue);
    });

    test('parses disabled boolean false', () {
      final s = SystemHealthStatus.fromJson({
        'systemhealth': {'enabled': false},
      });
      expect(s.isEnabled, isFalse);
    });

    test('returns false when systemhealth key is absent', () {
      final s = SystemHealthStatus.fromJson({});
      expect(s.isEnabled, isFalse);
    });

    test('returns false when enabled key is null', () {
      final s = SystemHealthStatus.fromJson({
        'systemhealth': {'enabled': null},
      });
      expect(s.isEnabled, isFalse);
    });

    test('toJson round-trips enabled state', () {
      final s = const SystemHealthStatus(isEnabled: true);
      final json = s.toJson();
      final roundTripped = SystemHealthStatus.fromJson(json);
      expect(roundTripped.isEnabled, isTrue);
    });
  });

  // -------------------------------------------------------------------------
  // SystemHealthRrdList
  // -------------------------------------------------------------------------
  group('SystemHealthRrdList', () {
    final sampleJson = {
      'data': {
        'packets': ['ipsec', 'lan', 'wan', 'opt1'],
        'services': ['ntpd'],
        'system': ['mbuf', 'memory', 'processor', 'states'],
        'traffic': ['ipsec', 'lan', 'wan', 'opt1'],
      },
      'files': [
        {'key': 'ipsec-packets', 'filename': 'ipsec-packets.rrd'},
        {'key': 'lan-traffic', 'filename': 'lan-traffic.rrd'},
        {'key': 'ntpd', 'filename': 'ntpd.rrd'},
        {'key': 'system-memory', 'filename': 'system-memory.rrd'},
      ],
      'interfaces': {
        'wan': {'descr': 'wan'},
        'lan': {'descr': 'lan'},
        'lo0': {'descr': 'Loopback'},
        'opt1': {'descr': 'WAN2_MIFI'},
      },
      'result': 'ok',
    };

    test('parses all four categories in API order', () {
      final rrd = SystemHealthRrdList.fromJson(sampleJson);
      expect(rrd.categories, ['packets', 'services', 'system', 'traffic']);
    });

    test('preserves subject order within each category', () {
      final rrd = SystemHealthRrdList.fromJson(sampleJson);
      expect(rrd.subjectsFor('packets'), ['ipsec', 'lan', 'wan', 'opt1']);
      expect(rrd.subjectsFor('system'), [
        'mbuf',
        'memory',
        'processor',
        'states',
      ]);
    });

    test('returns empty list for unknown category', () {
      final rrd = SystemHealthRrdList.fromJson(sampleJson);
      expect(rrd.subjectsFor('unknown'), isEmpty);
    });

    test('parses files list', () {
      final rrd = SystemHealthRrdList.fromJson(sampleJson);
      expect(rrd.files.length, 4);
      expect(rrd.files.first.key, 'ipsec-packets');
      expect(rrd.files.first.filename, 'ipsec-packets.rrd');
    });

    test('parses interface descriptions', () {
      final rrd = SystemHealthRrdList.fromJson(sampleJson);
      expect(rrd.interfaces['wan']?.descr, 'wan');
      expect(rrd.interfaces['opt1']?.descr, 'WAN2_MIFI');
      expect(rrd.interfaces['lo0']?.descr, 'Loopback');
    });

    test('returns null for unknown interface', () {
      final rrd = SystemHealthRrdList.fromJson(sampleJson);
      expect(rrd.interfaces['nonexistent'], isNull);
    });

    test('toJson round-trips without data loss', () {
      final rrd = SystemHealthRrdList.fromJson(sampleJson);
      final json = rrd.toJson();
      final rrd2 = SystemHealthRrdList.fromJson(json);
      expect(rrd2.categories, rrd.categories);
      expect(rrd2.subjectsFor('traffic'), ['ipsec', 'lan', 'wan', 'opt1']);
      expect(rrd2.files.length, rrd.files.length);
      expect(rrd2.interfaces['opt1']?.descr, 'WAN2_MIFI');
    });
  });

  // -------------------------------------------------------------------------
  // SystemHealthRrdFile
  // -------------------------------------------------------------------------
  group('SystemHealthRrdFile', () {
    test('parses key and filename', () {
      final f = SystemHealthRrdFile.fromJson({
        'key': 'system-processor',
        'filename': 'system-processor.rrd',
      });
      expect(f.key, 'system-processor');
      expect(f.filename, 'system-processor.rrd');
    });
  });

  // -------------------------------------------------------------------------
  // SystemHealthInterface
  // -------------------------------------------------------------------------
  group('SystemHealthInterface', () {
    test('parses description', () {
      final iface = SystemHealthInterface.fromJson({'descr': 'WAN2_MIFI'});
      expect(iface.descr, 'WAN2_MIFI');
    });
  });

  // -------------------------------------------------------------------------
  // SystemHealthGraphResponse
  // -------------------------------------------------------------------------
  group('SystemHealthGraphResponse', () {
    final sampleGraph = {
      'step': 60,
      'lastupdate': 1788859381,
      'set': {
        'count': 2,
        'data': [
          {
            'key': 'inpass',
            'values': [
              [1788787440000, 0],
              [1788787500000, 42],
              [1788787560000, null],
            ],
          },
          {
            'key': 'outpass',
            'values': [
              [1788787440000, 100],
              [1788787500000, 200],
            ],
          },
        ],
      },
      'title': 'System Information - Packets | Lan',
      'y-axis_label': 'Packets/Second',
    };

    test('parses graph metadata', () {
      final g = SystemHealthGraphResponse.fromJson(sampleGraph);
      expect(g.step, 60);
      expect(g.lastupdate, 1788859381);
      expect(g.title, 'System Information - Packets | Lan');
      expect(g.yAxisLabel, 'Packets/Second');
    });

    test('parses series count', () {
      final g = SystemHealthGraphResponse.fromJson(sampleGraph);
      expect(g.set.count, 2);
      expect(g.set.data.length, 2);
    });

    test('parses series keys', () {
      final g = SystemHealthGraphResponse.fromJson(sampleGraph);
      expect(g.set.data[0].key, 'inpass');
      expect(g.set.data[1].key, 'outpass');
    });

    test('parses timestamp and value in points', () {
      final g = SystemHealthGraphResponse.fromJson(sampleGraph);
      final points = g.set.data[0].values;
      expect(points[0].timestampMs, 1788787440000);
      expect(points[0].value, 0.0);
      expect(points[1].timestampMs, 1788787500000);
      expect(points[1].value, 42.0);
    });

    test('preserves null slot as null value', () {
      final g = SystemHealthGraphResponse.fromJson(sampleGraph);
      final nullPoint = g.set.data[0].values[2];
      expect(nullPoint.timestampMs, 1788787560000);
      expect(nullPoint.value, isNull);
    });

    test('timestamp getter returns correct DateTime', () {
      final g = SystemHealthGraphResponse.fromJson(sampleGraph);
      final dt = g.set.data[0].values[0].timestamp;
      // 1788787440000 ms = 1788787440 s since epoch, UTC
      expect(dt.millisecondsSinceEpoch, 1788787440000);
      expect(dt.isUtc, isTrue);
    });

    test('parses empty series data list', () {
      final g = SystemHealthGraphResponse.fromJson({
        'step': 300,
        'lastupdate': 0,
        'set': {'count': 0, 'data': []},
      });
      expect(g.set.data, isEmpty);
    });

    test('toJson round-trips multi-series graph', () {
      final g = SystemHealthGraphResponse.fromJson(sampleGraph);
      final json = g.toJson();
      final g2 = SystemHealthGraphResponse.fromJson(json);
      expect(g2.step, 60);
      expect(g2.title, g.title);
      expect(g2.yAxisLabel, g.yAxisLabel);
      expect(g2.set.data[0].key, 'inpass');
      expect(g2.set.data[0].values[1].value, 42.0);
      expect(g2.set.data[0].values[2].value, isNull);
    });
  });

  // -------------------------------------------------------------------------
  // SystemHealthSeries — edge cases for point parsing
  // -------------------------------------------------------------------------
  group('SystemHealthSeries point parsing', () {
    test('handles empty values array', () {
      final s = SystemHealthSeries.fromJson({'key': 'mbuf', 'values': []});
      expect(s.values, isEmpty);
    });

    test('handles string numeric value', () {
      final s = SystemHealthSeries.fromJson({
        'key': 'mem',
        'values': [
          [1788787440000, '3.14'],
        ],
      });
      expect(s.values.first.value, closeTo(3.14, 0.001));
    });

    test('handles malformed entry gracefully', () {
      final s = SystemHealthSeries.fromJson({
        'key': 'mem',
        'values': [
          [], // empty sub-array
          [1788787440000], // missing value element
        ],
      });
      expect(s.values.length, 2);
      expect(s.values[0].timestampMs, 0);
      expect(s.values[1].value, isNull);
    });
  });
}
