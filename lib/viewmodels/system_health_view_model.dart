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
import '../models/system_health_graph.dart';
import '../models/system_health_rrd_list.dart';
import '../models/system_health_status.dart';
import '../services/base/api_exception.dart';
import '../services/demo_api_service.dart';

/// Granularity options for the RRD graph period parameter.
///
/// The integer value is passed directly as the `period` path segment to
/// `get_system_health/{key}/{period}`.
enum HealthGranularity {
  oneMinute(0),
  fiveMinutes(1),
  oneHour(2),
  twentyFourHours(3);

  const HealthGranularity(this.period);
  final int period;
}

/// ViewModel for the Reporting → Health screen.
///
/// Owns the three loading phases:
///  1. [loadInitial] — fetches status + RRD metadata and selects defaults.
///  2. [loadGraph]   — fetches graph data for the current (category, subject).
/// Selection changes cascade automatically via [selectCategory] / [selectSubject].
class SystemHealthViewModel extends ChangeNotifier {
  final DemoApiService _apiService;

  SystemHealthViewModel(this._apiService);

  // ── Disposed guard ───────────────────────────────────────────────────────────
  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) super.notifyListeners();
  }

  // ── Initial loading state ────────────────────────────────────────────────────
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // ── Status & metadata ────────────────────────────────────────────────────────
  SystemHealthStatus? _status;
  SystemHealthRrdList? _rrdList;

  bool get isEnabled => _status?.isEnabled ?? false;

  // ── Settings mutations ───────────────────────────────────────────────────────

  /// Saves the enabled/disabled toggle and refreshes status.
  Future<void> setEnabled(bool value) async {
    try {
      await _apiService.setSystemHealthEnabled(value);
      _status = SystemHealthStatus(isEnabled: value);
      notifyListeners();
    } catch (_) {
      // Surface errors to the caller; UI can read errorMessage if needed.
    }
  }

  /// Deletes one RRD file and refreshes the RRD list.
  Future<void> deleteRrdFile(String filename) async {
    try {
      await _apiService.deleteSystemHealthRrdFile(filename);
      // Refresh the list so the deleted file disappears.
      _rrdList = await _apiService.getSystemHealthRrdList();
      notifyListeners();
    } catch (_) {}
  }

  /// Deletes all RRD data and refreshes.
  Future<void> deleteAllRrd() async {
    try {
      await _apiService.deleteAllSystemHealthRrd();
      _rrdList = await _apiService.getSystemHealthRrdList();
      notifyListeners();
    } catch (_) {}
  }

  /// The flat list of RRD files (from [_rrdList.files]) for the Settings tab.
  List<SystemHealthRrdFile> get rrdFiles => _rrdList?.files ?? const [];

  /// Ordered categories from the RRD list.
  List<String> get categories => _rrdList?.categories ?? const [];

  /// Subjects for the currently selected category.
  List<String> get subjectsForSelectedCategory =>
      _rrdList?.subjectsFor(_selectedCategory ?? '') ?? const [];

  // ── Selection state ──────────────────────────────────────────────────────────
  String? _selectedCategory;
  String? _selectedSubject;

  String? get selectedCategory => _selectedCategory;
  String? get selectedSubject => _selectedSubject;

  // ── Graph loading state ──────────────────────────────────────────────────────
  bool _isGraphLoading = false;
  String? _graphErrorMessage;
  SystemHealthGraphResponse? _graphResponse;
  HealthGranularity _selectedGranularity = HealthGranularity.oneMinute;

  bool get isGraphLoading => _isGraphLoading;
  String? get graphErrorMessage => _graphErrorMessage;
  SystemHealthGraphResponse? get graphResponse => _graphResponse;
  HealthGranularity get selectedGranularity => _selectedGranularity;

  bool get hasGraphData =>
      _graphResponse != null && _graphResponse!.set.data.isNotEmpty;

  // ── Initial load ─────────────────────────────────────────────────────────────

  /// Fetches system-health status and RRD metadata.
  ///
  /// After metadata is loaded the first category and subject are selected as
  /// defaults, then [loadGraph] is called — unless health is disabled.
  Future<void> loadInitial() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final statusFuture = _apiService.getSystemHealthStatus();
      final rrdFuture = _apiService.getSystemHealthRrdList();
      final results = await Future.wait([statusFuture, rrdFuture]);

      _status = results[0] as SystemHealthStatus;
      _rrdList = results[1] as SystemHealthRrdList;

      _applyDefaultSelection();

      if (isEnabled && _selectedCategory != null && _selectedSubject != null) {
        await loadGraph();
        return; // loadGraph sets _isLoading = false via its own flow
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

  void _applyDefaultSelection() {
    final cats = _rrdList?.categories ?? const [];
    if (cats.isNotEmpty) {
      _selectedCategory = cats.first;
      final subjects = _rrdList?.subjectsFor(cats.first) ?? const [];
      _selectedSubject = subjects.isNotEmpty ? subjects.first : null;
    } else {
      _selectedCategory = null;
      _selectedSubject = null;
    }
  }

  // ── Graph load ───────────────────────────────────────────────────────────────

  /// Fetches graph data for the current [_selectedCategory] + [_selectedSubject].
  Future<void> loadGraph() async {
    final cat = _selectedCategory;
    final sub = _selectedSubject;
    if (cat == null || sub == null) return;

    _isGraphLoading = true;
    _graphErrorMessage = null;
    notifyListeners();

    try {
      final key = _deriveKey(cat, sub);
      _graphResponse = await _apiService.getSystemHealthGraph(
        key,
        period: _selectedGranularity.period,
      );
    } on ApiException catch (e) {
      _graphErrorMessage = e.message;
    } catch (e) {
      _graphErrorMessage = e.toString();
    } finally {
      _isGraphLoading = false;
      notifyListeners();
    }
  }

  // ── Selection mutations ──────────────────────────────────────────────────────

  /// Changes the selected category, resets the subject to the first available
  /// subject in that category, clears stale graph data, and reloads the graph.
  Future<void> selectCategory(String category) async {
    if (category == _selectedCategory) return;
    _selectedCategory = category;
    final subjects = _rrdList?.subjectsFor(category) ?? const [];
    _selectedSubject = subjects.isNotEmpty ? subjects.first : null;
    _graphResponse = null;
    notifyListeners();

    if (_selectedSubject != null) await loadGraph();
  }

  /// Changes the selected subject within the current category and reloads the
  /// graph.
  Future<void> selectSubject(String subject) async {
    if (subject == _selectedSubject) return;
    _selectedSubject = subject;
    _graphResponse = null;
    notifyListeners();

    await loadGraph();
  }

  /// Changes the granularity and reloads the graph.
  Future<void> selectGranularity(HealthGranularity granularity) async {
    if (granularity == _selectedGranularity) return;
    _selectedGranularity = granularity;
    _graphResponse = null;
    notifyListeners();

    if (_selectedSubject != null) await loadGraph();
  }

  /// Refreshes status, metadata, and graph data.
  Future<void> refresh() => loadInitial();

  // ── Key derivation ───────────────────────────────────────────────────────────

  /// Derives the RRD graph key from [category] and [subject].
  ///
  /// Convention (confirmed from live API URLs):
  ///   packets  → `"{subject}-packets"` (e.g. `lan-packets`)
  ///   traffic  → `"{subject}-traffic"` (e.g. `wan-traffic`)
  ///   system   → `"{subject}-system"`  (e.g. `mbuf-system`)
  ///   services → `"{subject}-services"` (e.g. `ntpd-services`)
  static String _deriveKey(String category, String subject) {
    switch (category) {
      case 'packets':
        return '$subject-packets';
      case 'traffic':
        return '$subject-traffic';
      case 'system':
        return '$subject-system';
      default:
        return '$subject-services';
    }
  }

  /// Exposed for tests.
  static String deriveGraphKey(String category, String subject) =>
      _deriveKey(category, subject);
}
