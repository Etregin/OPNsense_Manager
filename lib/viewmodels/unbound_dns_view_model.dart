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

import 'package:flutter/foundation.dart';
import '../models/unbound_overview_status.dart';
import '../models/unbound_query_item.dart';
import '../models/unbound_rolling.dart';
import '../models/unbound_settings.dart';
import '../models/unbound_totals.dart';
import '../services/base/api_exception.dart';
import '../services/demo_api_service.dart';

/// ViewModel managing state for the Unbound DNS Reporting screen.
class UnboundDnsViewModel extends ChangeNotifier {
  final DemoApiService _apiService;

  bool _isLoading = false;
  bool _isActionLoading = false;
  String? _errorMessage;

  // Overview status (enabled vs disabled)
  UnboundOverviewStatus? _overviewStatus;

  // Overview data
  UnboundTotals? _totals;
  List<UnboundRollingPoint> _rollingPoints = [];
  List<UnboundRollingClientPoint> _clientActivityPoints = [];

  // Duration & filter selections
  int _selectedRollingDurationHours = 24; // 24, 12, 1
  bool _isRollingLogarithmic = false;

  int _selectedClientDurationHours = 24; // 24, 12, 1
  bool _isClientLogarithmic = false;

  int _selectedDomainLimit = 10; // 10, 25, 50, 75, 100

  // Details tab state
  UnboundQuerySearchResponse? _querySearchResponse;
  int _queriesCurrentPage = 1;
  int _queriesRowCount = 50; // 50, 100, 200, 500, 1000, -1 (all)
  String _queriesSearchPhrase = '';
  String? _queriesFilterClient;
  int? _queriesFilterTimeStart;
  int? _queriesFilterTimeEnd;
  bool _isQueriesLoading = false;

  // Settings tab state
  UnboundSettings? _settings;
  bool _statsToggleValue = false;
  bool _hasUnsavedSettingsChanges = false;

  UnboundDnsViewModel(this._apiService);

  // ── Getters ─────────────────────────────────────────────────────────────────
  bool get isLoading => _isLoading;
  bool get isActionLoading => _isActionLoading;
  String? get errorMessage => _errorMessage;

  bool get isOverviewEnabled => _overviewStatus?.isEnabled ?? false;
  UnboundTotals? get totals => _totals;
  List<UnboundRollingPoint> get rollingPoints => _rollingPoints;
  List<UnboundRollingClientPoint> get clientActivityPoints => _clientActivityPoints;

  int get selectedRollingDurationHours => _selectedRollingDurationHours;
  bool get isRollingLogarithmic => _isRollingLogarithmic;

  int get selectedClientDurationHours => _selectedClientDurationHours;
  bool get isClientLogarithmic => _isClientLogarithmic;

  int get selectedDomainLimit => _selectedDomainLimit;

  UnboundQuerySearchResponse? get querySearchResponse => _querySearchResponse;
  List<UnboundQueryItem> get queries => _querySearchResponse?.rows ?? [];
  int get queriesTotal => _querySearchResponse?.total ?? 0;
  int get queriesCurrentPage => _queriesCurrentPage;
  int get queriesRowCount => _queriesRowCount;
  String get queriesSearchPhrase => _queriesSearchPhrase;
  String? get queriesFilterClient => _queriesFilterClient;
  int? get queriesFilterTimeStart => _queriesFilterTimeStart;
  int? get queriesFilterTimeEnd => _queriesFilterTimeEnd;
  bool get isQueriesLoading => _isQueriesLoading;

  String? get activeFilterLabel {
    if (_queriesFilterClient == null && _queriesFilterTimeStart == null) return null;
    final clientPart = _queriesFilterClient ?? '';
    if (_queriesFilterTimeStart != null && _queriesFilterTimeEnd != null) {
      final startDt = DateTime.fromMillisecondsSinceEpoch(_queriesFilterTimeStart! * 1000);
      final endDt = DateTime.fromMillisecondsSinceEpoch(_queriesFilterTimeEnd! * 1000);
      final startFormatted = '${startDt.month.toString().padLeft(2, '0')}-${startDt.day.toString().padLeft(2, '0')} ${startDt.hour.toString().padLeft(2, '0')}:${startDt.minute.toString().padLeft(2, '0')}';
      final endFormatted = '${endDt.month.toString().padLeft(2, '0')}-${endDt.day.toString().padLeft(2, '0')} ${endDt.hour.toString().padLeft(2, '0')}:${endDt.minute.toString().padLeft(2, '0')}';
      if (clientPart.isNotEmpty) {
        return '$clientPart ($startFormatted - $endFormatted)';
      }
      return '($startFormatted - $endFormatted)';
    }
    return clientPart;
  }

  UnboundSettings? get settings => _settings;
  bool get statsToggleValue => _statsToggleValue;
  bool get hasUnsavedSettingsChanges => _hasUnsavedSettingsChanges;

  // ── Initial / Refresh Load ──────────────────────────────────────────────────
  Future<void> loadInitial() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _overviewStatus = await _apiService.checkUnboundOverviewEnabled();
      _settings = await _apiService.getUnboundSettings();
      _statsToggleValue = _settings?.general?.stats ?? _overviewStatus?.isEnabled ?? false;
      _hasUnsavedSettingsChanges = false;

      if (_overviewStatus?.isEnabled == true) {
        await _loadOverviewData();
      }
    } on ApiException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    try {
      _overviewStatus = await _apiService.checkUnboundOverviewEnabled();
      _settings = await _apiService.getUnboundSettings();
      _statsToggleValue = _settings?.general?.stats ?? _overviewStatus?.isEnabled ?? false;

      if (_overviewStatus?.isEnabled == true) {
        await _loadOverviewData();
      }
    } on ApiException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> _loadOverviewData() async {
    final totalsFuture = _apiService.getUnboundTotals(limit: _selectedDomainLimit);
    final rollingFuture = _apiService.getUnboundRolling(_selectedRollingDurationHours);
    final clientFuture = _apiService.getUnboundClientActivity(_selectedClientDurationHours);

    final queriesFuture = _loadQueriesInternal();

    final results = await Future.wait([totalsFuture, rollingFuture, clientFuture, queriesFuture]);
    _totals = results[0] as UnboundTotals;
    _rollingPoints = results[1] as List<UnboundRollingPoint>;
    _clientActivityPoints = results[2] as List<UnboundRollingClientPoint>;
  }

  Future<void> _loadQueriesInternal() async {
    _isQueriesLoading = true;
    try {
      final actualRowCount = _queriesRowCount == -1 ? 9999 : _queriesRowCount;
      _querySearchResponse = await _apiService.searchUnboundQueries(
        current: _queriesCurrentPage,
        rowCount: actualRowCount,
        searchPhrase: _queriesSearchPhrase.isNotEmpty ? _queriesSearchPhrase : null,
        client: _queriesFilterClient,
        timeStart: _queriesFilterTimeStart,
        timeEnd: _queriesFilterTimeEnd,
      );
    } catch (_) {
      // Handled silently or reported
    } finally {
      _isQueriesLoading = false;
    }
  }

  Future<void> loadQueries() async {
    _isQueriesLoading = true;
    notifyListeners();
    try {
      final actualRowCount = _queriesRowCount == -1 ? 9999 : _queriesRowCount;
      _querySearchResponse = await _apiService.searchUnboundQueries(
        current: _queriesCurrentPage,
        rowCount: actualRowCount,
        searchPhrase: _queriesSearchPhrase.isNotEmpty ? _queriesSearchPhrase : null,
        client: _queriesFilterClient,
        timeStart: _queriesFilterTimeStart,
        timeEnd: _queriesFilterTimeEnd,
      );
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isQueriesLoading = false;
      notifyListeners();
    }
  }

  Future<void> setQueriesRowCount(int count) async {
    _queriesRowCount = count;
    _queriesCurrentPage = 1;
    await loadQueries();
  }

  Future<void> setQueriesSearchPhrase(String phrase) async {
    _queriesSearchPhrase = phrase;
    _queriesCurrentPage = 1;
    await loadQueries();
  }

  Future<void> setQueriesPage(int page) async {
    _queriesCurrentPage = page;
    await loadQueries();
  }

  Future<void> filterQueriesByClientTime({
    required String client,
    required int timeStart,
    required int timeEnd,
  }) async {
    _queriesFilterClient = client;
    _queriesFilterTimeStart = timeStart;
    _queriesFilterTimeEnd = timeEnd;
    _queriesCurrentPage = 1;
    await loadQueries();
  }

  Future<void> clearQueriesClientTimeFilter() async {
    _queriesFilterClient = null;
    _queriesFilterTimeStart = null;
    _queriesFilterTimeEnd = null;
    _queriesCurrentPage = 1;
    await loadQueries();
  }

  // ── Control / Filter Methods ────────────────────────────────────────────────
  Future<void> setRollingDurationHours(int hours) async {
    if (_selectedRollingDurationHours == hours) return;
    _selectedRollingDurationHours = hours;
    notifyListeners();

    try {
      _rollingPoints = await _apiService.getUnboundRolling(hours);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }

  void toggleRollingLogarithmic(bool value) {
    _isRollingLogarithmic = value;
    notifyListeners();
  }

  Future<void> setClientDurationHours(int hours) async {
    if (_selectedClientDurationHours == hours) return;
    _selectedClientDurationHours = hours;
    notifyListeners();

    try {
      _clientActivityPoints = await _apiService.getUnboundClientActivity(hours);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }

  void toggleClientLogarithmic(bool value) {
    _isClientLogarithmic = value;
    notifyListeners();
  }

  Future<void> setDomainLimit(int limit) async {
    if (_selectedDomainLimit == limit) return;
    _selectedDomainLimit = limit;
    notifyListeners();

    try {
      _totals = await _apiService.getUnboundTotals(limit: limit);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }

  void setStatsToggle(bool value) {
    _statsToggleValue = value;
    final original = _settings?.general?.stats ?? false;
    _hasUnsavedSettingsChanges = (_statsToggleValue != original);
    notifyListeners();
  }

  // ── Action Mutations ────────────────────────────────────────────────────────
  Future<bool> applySettings() async {
    _isActionLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _apiService.setUnboundStatsEnabled(_statsToggleValue);
      await _apiService.reconfigureUnboundGeneral();

      // Refresh overview status
      _overviewStatus = await _apiService.checkUnboundOverviewEnabled();
      _settings = await _apiService.getUnboundSettings();
      _hasUnsavedSettingsChanges = false;

      if (_overviewStatus?.isEnabled == true) {
        await _loadOverviewData();
      }
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isActionLoading = false;
      notifyListeners();
    }
  }

  Future<bool> resetDnsData() async {
    _isActionLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _apiService.resetUnboundDnsData();
      if (_overviewStatus?.isEnabled == true) {
        await _loadOverviewData();
      }
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isActionLoading = false;
      notifyListeners();
    }
  }
}
