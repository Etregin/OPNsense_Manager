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
import 'package:opnsense_manager/services/demo_api_service.dart';
import 'package:opnsense_manager/services/opnsense_api_service.dart';
import 'package:opnsense_manager/viewmodels/system_health_view_model.dart';

// ---------------------------------------------------------------------------
// Stub service
// ---------------------------------------------------------------------------

class _FakeDemoApiService extends DemoApiService {
  SystemHealthStatus stubStatus = const SystemHealthStatus(isEnabled: true);
  SystemHealthRrdList stubRrdList = const SystemHealthRrdList(
    data: {
      'packets': ['lan', 'wan'],
      'system': ['memory', 'processor'],
      'services': ['ntpd'],
    },
    files: [],
    interfaces: {},
  );
  SystemHealthGraphResponse stubGraph = const SystemHealthGraphResponse(
    step: 60,
    lastupdate: 1_700_000_000,
    set: SystemHealthDataSet(
      count: 2,
      data: [
        SystemHealthSeries(
          key: 'in',
          values: [
            SystemHealthPoint(timestampMs: 1_700_000_000_000, value: 1.0),
            SystemHealthPoint(timestampMs: 1_700_000_060_000, value: 2.0),
          ],
        ),
        SystemHealthSeries(
          key: 'out',
          values: [
            SystemHealthPoint(timestampMs: 1_700_000_000_000, value: 0.5),
            SystemHealthPoint(timestampMs: 1_700_000_060_000, value: 0.8),
          ],
        ),
      ],
    ),
  );

  // Track which graph keys were requested.
  final List<String> graphKeysCalled = [];
  // Optionally throw on graph fetch.
  Exception? graphError;

  _FakeDemoApiService() : super(OPNsenseApiService());

  @override
  Future<SystemHealthStatus> getSystemHealthStatus() async => stubStatus;

  @override
  Future<SystemHealthRrdList> getSystemHealthRrdList() async => stubRrdList;

  @override
  Future<SystemHealthGraphResponse> getSystemHealthGraph(
    String key, {
    int period = 0,
  }) async {
    graphKeysCalled.add(key);
    if (graphError != null) throw graphError!;
    return stubGraph;
  }
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  // ── deriveGraphKey static helper ──────────────────────────────────────────

  group('SystemHealthViewModel.deriveGraphKey', () {
    test('packets category produces subject-packets', () {
      expect(
        SystemHealthViewModel.deriveGraphKey('packets', 'lan'),
        'lan-packets',
      );
    });

    test('traffic category produces subject-traffic', () {
      expect(
        SystemHealthViewModel.deriveGraphKey('traffic', 'wan'),
        'wan-traffic',
      );
    });

    test('system category produces subject-system', () {
      expect(
        SystemHealthViewModel.deriveGraphKey('system', 'memory'),
        'memory-system',
      );
    });

    test('services category produces subject-services', () {
      expect(
        SystemHealthViewModel.deriveGraphKey('services', 'ntpd'),
        'ntpd-services',
      );
    });

    test('unknown category falls through to subject-services', () {
      expect(
        SystemHealthViewModel.deriveGraphKey('other', 'foo'),
        'foo-services',
      );
    });
  });

  // ── loadInitial ───────────────────────────────────────────────────────────

  group('SystemHealthViewModel.loadInitial', () {
    test('selects first category and subject as defaults', () async {
      final fake = _FakeDemoApiService();
      final vm = SystemHealthViewModel(fake);

      await vm.loadInitial();

      expect(vm.selectedCategory, 'packets');
      expect(vm.selectedSubject, 'lan');
    });

    test('reports isEnabled = true from stub', () async {
      final fake = _FakeDemoApiService();
      final vm = SystemHealthViewModel(fake);

      await vm.loadInitial();

      expect(vm.isEnabled, isTrue);
    });

    test('loads graph data on init when enabled', () async {
      final fake = _FakeDemoApiService();
      final vm = SystemHealthViewModel(fake);

      await vm.loadInitial();

      expect(vm.hasGraphData, isTrue);
      expect(fake.graphKeysCalled, contains('lan-packets'));
    });

    test('does not request graph when disabled', () async {
      final fake = _FakeDemoApiService();
      fake.stubStatus = const SystemHealthStatus(isEnabled: false);
      final vm = SystemHealthViewModel(fake);

      await vm.loadInitial();

      expect(vm.isEnabled, isFalse);
      expect(vm.hasGraphData, isFalse);
      expect(fake.graphKeysCalled, isEmpty);
    });

    test('empty metadata leaves selection null and no graph request', () async {
      final fake = _FakeDemoApiService();
      fake.stubRrdList = const SystemHealthRrdList(
        data: {},
        files: [],
        interfaces: {},
      );
      final vm = SystemHealthViewModel(fake);

      await vm.loadInitial();

      expect(vm.selectedCategory, isNull);
      expect(vm.selectedSubject, isNull);
      expect(fake.graphKeysCalled, isEmpty);
    });

    test('sets errorMessage when status call throws', () async {
      final fake = _ThrowingStatusFakeDemoApiService();
      final vm = SystemHealthViewModel(fake);

      await vm.loadInitial();

      expect(vm.errorMessage, isNotNull);
    });
  });

  // ── selectCategory ────────────────────────────────────────────────────────

  group('SystemHealthViewModel.selectCategory', () {
    test(
      'changes category and resets subject to first in new category',
      () async {
        final fake = _FakeDemoApiService();
        final vm = SystemHealthViewModel(fake);
        await vm.loadInitial();

        await vm.selectCategory('system');

        expect(vm.selectedCategory, 'system');
        expect(vm.selectedSubject, 'memory');
      },
    );

    test('requests correct graph key after category change', () async {
      final fake = _FakeDemoApiService();
      final vm = SystemHealthViewModel(fake);
      await vm.loadInitial();
      fake.graphKeysCalled.clear();

      await vm.selectCategory('system');

      expect(fake.graphKeysCalled, contains('memory-system'));
    });

    test('no-op when same category selected', () async {
      final fake = _FakeDemoApiService();
      final vm = SystemHealthViewModel(fake);
      await vm.loadInitial();
      final initialSubject = vm.selectedSubject;
      fake.graphKeysCalled.clear();

      await vm.selectCategory('packets');

      expect(vm.selectedSubject, initialSubject);
      expect(fake.graphKeysCalled, isEmpty);
    });

    test('subject dropdown repopulated for new category', () async {
      final fake = _FakeDemoApiService();
      final vm = SystemHealthViewModel(fake);
      await vm.loadInitial();

      await vm.selectCategory('services');

      expect(vm.subjectsForSelectedCategory, ['ntpd']);
    });
  });

  // ── selectSubject ─────────────────────────────────────────────────────────

  group('SystemHealthViewModel.selectSubject', () {
    test('changes subject and loads corresponding graph', () async {
      final fake = _FakeDemoApiService();
      final vm = SystemHealthViewModel(fake);
      await vm.loadInitial();
      fake.graphKeysCalled.clear();

      await vm.selectSubject('wan');

      expect(vm.selectedSubject, 'wan');
      expect(fake.graphKeysCalled, contains('wan-packets'));
    });

    test('no-op when same subject selected', () async {
      final fake = _FakeDemoApiService();
      final vm = SystemHealthViewModel(fake);
      await vm.loadInitial();
      fake.graphKeysCalled.clear();

      await vm.selectSubject('lan'); // already selected

      expect(fake.graphKeysCalled, isEmpty);
    });
  });

  // ── graph error state ─────────────────────────────────────────────────────

  group('SystemHealthViewModel graph error', () {
    test('sets graphErrorMessage when graph call fails', () async {
      final fake = _FakeDemoApiService();
      fake.graphError = Exception('timeout');
      final vm = SystemHealthViewModel(fake);

      await vm.loadInitial();

      expect(vm.graphErrorMessage, isNotNull);
      expect(vm.hasGraphData, isFalse);
    });

    test('clears graphErrorMessage on successful retry', () async {
      final fake = _FakeDemoApiService();
      fake.graphError = Exception('timeout');
      final vm = SystemHealthViewModel(fake);
      await vm.loadInitial();
      expect(vm.graphErrorMessage, isNotNull);

      fake.graphError = null;
      await vm.loadGraph();

      expect(vm.graphErrorMessage, isNull);
      expect(vm.hasGraphData, isTrue);
    });
  });

  // ── categories / subjects helpers ─────────────────────────────────────────

  group('SystemHealthViewModel accessors', () {
    test('categories returns keys in insertion order', () async {
      final fake = _FakeDemoApiService();
      final vm = SystemHealthViewModel(fake);
      await vm.loadInitial();

      expect(vm.categories, ['packets', 'system', 'services']);
    });

    test('subjectsForSelectedCategory reflects current category', () async {
      final fake = _FakeDemoApiService();
      final vm = SystemHealthViewModel(fake);
      await vm.loadInitial();

      expect(vm.subjectsForSelectedCategory, ['lan', 'wan']);
    });
  });
}

// ---------------------------------------------------------------------------
// Helper: throws on getSystemHealthStatus
// ---------------------------------------------------------------------------

class _ThrowingStatusFakeDemoApiService extends _FakeDemoApiService {
  @override
  Future<SystemHealthStatus> getSystemHealthStatus() async {
    throw Exception('status fetch failed');
  }
}
