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
import 'package:opnsense_manager/models/unbound_overview_status.dart';
import 'package:opnsense_manager/models/unbound_rolling.dart';
import 'package:opnsense_manager/models/unbound_settings.dart';
import 'package:opnsense_manager/models/unbound_totals.dart';

void main() {
  group('UnboundOverviewStatus', () {
    test('parses enabled 1 and 0 string and boolean', () {
      final s1 = UnboundOverviewStatus.fromJson({'enabled': '1'});
      expect(s1.isEnabled, isTrue);

      final s0 = UnboundOverviewStatus.fromJson({'enabled': '0'});
      expect(s0.isEnabled, isFalse);

      final sBool = UnboundOverviewStatus.fromJson({'enabled': true});
      expect(sBool.isEnabled, isTrue);
    });
  });

  group('UnboundTotals', () {
    test('parses sample totals response', () {
      final json = {
        'total': 660,
        'blocklist_size': 0,
        'passed': 655,
        'resolved': {'total': 174, 'pcnt': '26.36'},
        'blocked': {'total': 0, 'pcnt': 0},
        'local': {'total': 269, 'pcnt': '40.76'},
        'start_time': 1788794591,
        'top': {
          'api.themoviedb.org.': {'total': 62, 'pcnt': '9.47'},
          'ghcr.io.': {'total': 46, 'pcnt': '7.02'},
        },
        'top_blocked': [],
      };

      final totals = UnboundTotals.fromJson(json);
      expect(totals.total, 660);
      expect(totals.blocklistSize, 0);
      expect(totals.passed, 655);
      expect(totals.resolved?.total, 174);
      expect(totals.resolved?.pcnt, 26.36);
      expect(totals.blocked?.total, 0);
      expect(totals.blocked?.pcnt, 0.0);
      expect(totals.local?.total, 269);
      expect(totals.startTime, 1788794591);
      expect(totals.top.length, 2);
      expect(totals.top.first.domain, 'api.themoviedb.org.');
      expect(totals.top.first.total, 62);
      expect(totals.top.first.pcnt, 9.47);
      expect(totals.topBlocked, isEmpty);
    });

    test('parses empty or reset totals response safely', () {
      final emptyJson = <String, dynamic>{};
      final totals = UnboundTotals.fromJson(emptyJson);

      expect(totals.total, 0);
      expect(totals.blocklistSize, 0);
      expect(totals.passed, 0);
      expect(totals.resolved, isNull);
      expect(totals.blocked, isNull);
      expect(totals.local, isNull);
      expect(totals.startTime, isNull);
      expect(totals.top, isEmpty);
      expect(totals.topBlocked, isEmpty);
    });

    test('parses totals response with null and string numeric values', () {
      final jsonWithStrings = {
        'total': '120',
        'blocklist_size': null,
        'passed': '100',
        'resolved': {'total': '50', 'pcnt': '41.6'},
        'blocked': {'total': 0, 'pcnt': null},
        'top': {
          'example.com': {'total': '10', 'pcnt': '8.3'},
        },
      };
      final totals = UnboundTotals.fromJson(jsonWithStrings);

      expect(totals.total, 120);
      expect(totals.blocklistSize, 0);
      expect(totals.passed, 100);
      expect(totals.resolved?.total, 50);
      expect(totals.resolved?.pcnt, 41.6);
      expect(totals.blocked?.total, 0);
      expect(totals.blocked?.pcnt, 0.0);
      expect(totals.top.first.domain, 'example.com');
      expect(totals.top.first.total, 10);
      expect(totals.top.first.pcnt, 8.3);
    });
  });

  group('UnboundRollingPoint', () {
    test('parses rolling data point', () {
      final point = UnboundRollingPoint.fromJson({
        'timestamp': 1788794400.0,
        'total': 134,
        'passed': 133,
        'blocked': 0,
        'dropped': 1,
        'resolved': 51,
        'local': 6,
        'cached': 76,
      });

      expect(point.total, 134);
      expect(point.cached, 76);
      expect(point.passed, 133);
    });
  });

  group('UnboundSettings', () {
    test('parses settings correctly', () {
      final json = {
        'unbound': {
          'general': {
            'enabled': '1',
            'port': '53',
            'stats': '1',
          },
        },
      };

      final settings = UnboundSettings.fromJson(json);
      expect(settings.general?.enabled, isTrue);
      expect(settings.general?.stats, isTrue);
      expect(settings.general?.port, '53');
    });
  });
}
