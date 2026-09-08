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
import 'package:opnsense_manager/services/demo_api_service.dart';
import 'package:opnsense_manager/services/opnsense_api_service.dart';
import 'package:opnsense_manager/viewmodels/unbound_dns_view_model.dart';

class FakeDemoApiService extends DemoApiService {
  bool stubOverviewEnabled = true;
  UnboundSettings stubSettings = const UnboundSettings(
    general: UnboundGeneralSettings(enabled: true, stats: true),
  );
  UnboundTotals stubTotals = const UnboundTotals(
    total: 500,
    blocklistSize: 100,
    passed: 450,
  );
  List<UnboundRollingPoint> stubRolling = [
    const UnboundRollingPoint(
      timestamp: 1000,
      total: 10,
      passed: 9,
      blocked: 1,
      dropped: 0,
      resolved: 5,
      local: 2,
      cached: 3,
    ),
  ];
  List<UnboundRollingClientPoint> stubClientActivity = [
    const UnboundRollingClientPoint(
      timestamp: 1000,
      clients: [
        UnboundClientHit(ip: '192.168.1.100', count: 10, hostname: 'host'),
      ],
    ),
  ];

  bool setStatsEnabledCalled = false;
  bool reconfigureGeneralCalled = false;
  bool resetDnsDataCalled = false;

  FakeDemoApiService() : super(OPNsenseApiService());

  @override
  Future<UnboundOverviewStatus> checkUnboundOverviewEnabled() async =>
      UnboundOverviewStatus(isEnabled: stubOverviewEnabled);

  @override
  Future<UnboundSettings> getUnboundSettings() async => stubSettings;

  @override
  Future<UnboundTotals> getUnboundTotals({int limit = 10}) async => stubTotals;

  @override
  Future<List<UnboundRollingPoint>> getUnboundRolling(int hours) async =>
      stubRolling;

  @override
  Future<List<UnboundRollingClientPoint>> getUnboundClientActivity(
          int hours) async =>
      stubClientActivity;

  @override
  Future<void> setUnboundStatsEnabled(bool enabled) async {
    setStatsEnabledCalled = true;
    stubOverviewEnabled = enabled;
  }

  @override
  Future<void> reconfigureUnboundGeneral() async {
    reconfigureGeneralCalled = true;
  }

  @override
  Future<void> resetUnboundDnsData() async {
    resetDnsDataCalled = true;
  }
}

void main() {
  late FakeDemoApiService fakeApiService;
  late UnboundDnsViewModel viewModel;

  setUp(() {
    fakeApiService = FakeDemoApiService();
    viewModel = UnboundDnsViewModel(fakeApiService);
  });

  tearDown(() {
    viewModel.dispose();
  });

  group('UnboundDnsViewModel', () {
    test('initial load with statistics disabled', () async {
      fakeApiService.stubOverviewEnabled = false;
      fakeApiService.stubSettings = const UnboundSettings(
        general: UnboundGeneralSettings(enabled: true, stats: false),
      );

      await viewModel.loadInitial();

      expect(viewModel.isOverviewEnabled, isFalse);
      expect(viewModel.statsToggleValue, isFalse);
      expect(viewModel.totals, isNull);
    });

    test('initial load with statistics enabled loads overview data', () async {
      fakeApiService.stubOverviewEnabled = true;
      fakeApiService.stubSettings = const UnboundSettings(
        general: UnboundGeneralSettings(enabled: true, stats: true),
      );

      await viewModel.loadInitial();

      expect(viewModel.isOverviewEnabled, isTrue);
      expect(viewModel.statsToggleValue, isTrue);
      expect(viewModel.totals?.total, 500);
      expect(viewModel.rollingPoints.length, 1);
      expect(viewModel.clientActivityPoints.length, 1);
    });

    test('toggleLogarithmic updates state independently', () {
      expect(viewModel.isRollingLogarithmic, isFalse);
      expect(viewModel.isClientLogarithmic, isFalse);

      viewModel.toggleRollingLogarithmic(true);
      expect(viewModel.isRollingLogarithmic, isTrue);
      expect(viewModel.isClientLogarithmic, isFalse);

      viewModel.toggleClientLogarithmic(true);
      expect(viewModel.isRollingLogarithmic, isTrue);
      expect(viewModel.isClientLogarithmic, isTrue);
    });

    test('setDurationHours updates duration independently', () async {
      expect(viewModel.selectedRollingDurationHours, 24);
      expect(viewModel.selectedClientDurationHours, 24);

      await viewModel.setRollingDurationHours(12);
      expect(viewModel.selectedRollingDurationHours, 12);
      expect(viewModel.selectedClientDurationHours, 24);

      await viewModel.setClientDurationHours(1);
      expect(viewModel.selectedRollingDurationHours, 12);
      expect(viewModel.selectedClientDurationHours, 1);
    });

    test('setStatsToggle detects unsaved changes', () async {
      fakeApiService.stubOverviewEnabled = true;
      fakeApiService.stubSettings = const UnboundSettings(
        general: UnboundGeneralSettings(enabled: true, stats: true),
      );

      await viewModel.loadInitial();
      expect(viewModel.hasUnsavedSettingsChanges, isFalse);

      viewModel.setStatsToggle(false);
      expect(viewModel.hasUnsavedSettingsChanges, isTrue);

      viewModel.setStatsToggle(true);
      expect(viewModel.hasUnsavedSettingsChanges, isFalse);
    });

    test('applySettings calls API and updates state', () async {
      fakeApiService.stubOverviewEnabled = false;
      fakeApiService.stubSettings = const UnboundSettings(
        general: UnboundGeneralSettings(enabled: true, stats: false),
      );

      await viewModel.loadInitial();
      viewModel.setStatsToggle(true);

      final success = await viewModel.applySettings();
      expect(success, isTrue);
      expect(fakeApiService.setStatsEnabledCalled, isTrue);
      expect(fakeApiService.reconfigureGeneralCalled, isTrue);
      expect(viewModel.isOverviewEnabled, isTrue);
    });

    test('resetDnsData calls API', () async {
      final success = await viewModel.resetDnsData();
      expect(success, isTrue);
      expect(fakeApiService.resetDnsDataCalled, isTrue);
    });
  });
}
