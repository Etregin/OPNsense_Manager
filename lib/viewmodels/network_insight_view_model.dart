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

import 'dart:async' show unawaited;
import 'dart:convert' show utf8;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import '../models/insight_flow_detail.dart';
import '../models/netflow_status.dart';
import '../models/network_insight_direction_total.dart';
import '../models/network_insight_timeserie.dart';
import '../models/network_insight_top_addr.dart';
import '../models/network_insight_top_port.dart';
import '../services/demo_api_service.dart';

/// ViewModel for the Network Insight screen.
///
/// Manages:
/// - NetFlow gate check (must be enabled before showing charts).
/// - Time range and resolution selection.
/// - Interface list and per-interface filter for the breakdown section.
/// - Parallel loading of all chart data.
class NetworkInsightViewModel extends ChangeNotifier {
  final DemoApiService _apiService;

  NetworkInsightViewModel(this._apiService);

  // ── NetFlow gate ────────────────────────────────────────────────────────────

  bool _isCheckingNetflow = false;
  NetflowStatus? _netflowStatus;
  String? _errorMessage;

  bool get isCheckingNetflow => _isCheckingNetflow;
  NetflowStatus? get netflowStatus => _netflowStatus;
  bool get netflowEnabled => _netflowStatus?.isEnabled ?? false;
  String? get errorMessage => _errorMessage;

  // ── Interfaces ──────────────────────────────────────────────────────────────

  Map<String, String> _interfaces = {};
  String? _selectedInterface;

  /// Interface key → human-readable label.
  Map<String, String> get interfaces => Map.unmodifiable(_interfaces);

  /// Currently selected interface key for the breakdown section.
  String? get selectedInterface => _selectedInterface;

  // ── Time range ──────────────────────────────────────────────────────────────

  // Duration of the selected window (e.g. 2 hours). The end is always
  // recalculated to DateTime.now() on each load so data stays current.
  Duration _windowDuration = const Duration(hours: 2);
  int _resolution = 30; // seconds

  Duration get windowDuration => _windowDuration;
  int get resolution => _resolution;

  // ── Chart data ──────────────────────────────────────────────────────────────

  bool _isLoadingCharts = false;
  bool get isLoadingCharts => _isLoadingCharts;

  List<NetworkInsightSeries> _timeseries = [];
  List<NetworkInsightTopPort> _topPorts = [];
  List<NetworkInsightTopAddr> _topAddresses = [];
  List<NetworkInsightDirectionTotal> _directionOctetTotals = [];
  List<NetworkInsightDirectionTotal> _directionPacketTotals = [];

  List<NetworkInsightSeries> get timeseries => List.unmodifiable(_timeseries);
  List<NetworkInsightTopPort> get topPorts => List.unmodifiable(_topPorts);
  List<NetworkInsightTopAddr> get topAddresses => List.unmodifiable(_topAddresses);
  List<NetworkInsightDirectionTotal> get directionOctetTotals =>
      List.unmodifiable(_directionOctetTotals);
  List<NetworkInsightDirectionTotal> get directionPacketTotals =>
      List.unmodifiable(_directionPacketTotals);

  // ── Details tab state ───────────────────────────────────────────────────────

  late DateTime _detailsFrom;
  late DateTime _detailsTo;
  String _detailsInterface = '';
  String _detailsDstPort = '';
  String _detailsDstAddr = '';
  String _detailsSrcAddr = '';
  // Extra server-side filter applied during pie chart drilldowns.
  String? _detailsExtraFilterField;
  String? _detailsExtraFilterValue;
  bool _isLoadingDetails = false;
  String? _detailsErrorMessage;
  List<InsightFlowDetail> _flowDetails = [];

  DateTime get detailsFrom => _detailsFrom;
  DateTime get detailsTo => _detailsTo;
  String get detailsInterface => _detailsInterface;
  String get detailsDstPort => _detailsDstPort;
  String get detailsDstAddr => _detailsDstAddr;
  String get detailsSrcAddr => _detailsSrcAddr;
  bool get isLoadingDetails => _isLoadingDetails;
  String? get detailsErrorMessage => _detailsErrorMessage;
  List<InsightFlowDetail> get flowDetails => List.unmodifiable(_flowDetails);

  // ── Export tab state ────────────────────────────────────────────────────────

  static const List<String> exportCollections = [
    'FlowSourceAddrDetails',
    'FlowSourceAddrTotals',
    'FlowDstPortTotals',
    'FlowInterfaceTotals',
  ];

  String _exportCollection = 'FlowSourceAddrDetails';
  static const int exportResolution = 86400; // 86400 seconds (1 day)
  late DateTime _exportFrom;
  late DateTime _exportTo;
  bool _isExporting = false;
  String? _exportErrorMessage;

  String get exportCollection => _exportCollection;
  DateTime get exportFrom => _exportFrom;
  DateTime get exportTo => _exportTo;
  bool get isExporting => _isExporting;
  String? get exportErrorMessage => _exportErrorMessage;

  void setExportCollection(String collection) {
    if (_exportCollection == collection) return;
    _exportCollection = collection;
    notifyListeners();
  }

  void setExportDateRange(DateTime from, DateTime to) {
    _exportFrom = from;
    _exportTo = to;
    notifyListeners();
  }

  /// Downloads the NetFlow CSV export data and prompts the user to save it via [FilePicker.saveFile].
  ///
  /// Returns `true` if saved successfully, `false` if cancelled or failed.
  Future<bool> exportNetflowCsv() async {
    _isExporting = true;
    _exportErrorMessage = null;
    notifyListeners();

    try {
      final fromTs = _exportFrom.millisecondsSinceEpoch ~/ 1000;
      final toTs = _exportTo.millisecondsSinceEpoch ~/ 1000;

      final csvData = await _apiService.exportInsightData(
        collection: _exportCollection,
        fromTs: fromTs,
        toTs: toTs,
        resolution: exportResolution,
      );

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final suggestedName = 'netflow_${_exportCollection}_$timestamp.csv';
      final bytes = utf8.encode(csvData);

      final filePath = await FilePicker.saveFile(
        dialogTitle: 'Save NetFlow CSV Export',
        fileName: suggestedName,
        type: FileType.custom,
        allowedExtensions: ['csv'],
        bytes: bytes,
      );

      if (filePath == null) {
        // User cancelled picker
        _isExporting = false;
        notifyListeners();
        return false;
      }

      _isExporting = false;
      notifyListeners();
      return true;
    } catch (e) {
      _exportErrorMessage = e.toString();
      _isExporting = false;
      notifyListeners();
      return false;
    }
  }

  void setDetailsDateRange(DateTime from, DateTime to) {
    _detailsFrom = from;
    _detailsTo = to;
    notifyListeners();
  }

  void setDetailsInterface(String key) {
    _detailsInterface = key;
    notifyListeners();
  }

  void setDetailsDstPort(String v) {
    _detailsDstPort = v;
    notifyListeners();
  }

  void setDetailsDstAddr(String v) {
    _detailsDstAddr = v;
    notifyListeners();
  }

  void setDetailsSrcAddr(String v) {
    _detailsSrcAddr = v;
    notifyListeners();
  }

  // ── Reverse DNS lookup ──────────────────────────────────────────────────────

  bool _reverseLookupEnabled = false;
  bool _isResolvingDns = false;

  /// Whether the reverse-lookup toggle is currently on.
  bool get reverseLookupEnabled => _reverseLookupEnabled;

  /// True while the DNS batch request is in flight.
  bool get isResolvingDns => _isResolvingDns;

  /// Map of `ip → resolved hostname` (or back to IP if unresolvable).
  /// Populated after a successful reverse lookup; cleared when toggle is off.
  Map<String, String> _resolvedLabels = {};
  Map<String, String> get resolvedLabels => Map.unmodifiable(_resolvedLabels);

  // ── Initialisation ──────────────────────────────────────────────────────────

  /// First call on screen open.
  ///
  /// Checks NetFlow status and, if enabled, loads interfaces and chart data.
  Future<void> loadInitial() async {
    _setDefaultTimeRange();
    _setDefaultDetailsRange();
    _setDefaultExportRange();
    _isCheckingNetflow = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _netflowStatus = await _apiService.checkNetflowEnabled();

      if (_netflowStatus!.isEnabled) {
        await _loadInterfaces();
        await loadChartData();
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isCheckingNetflow = false;
      notifyListeners();
    }
  }

  void _setDefaultTimeRange() {
    _windowDuration = const Duration(hours: 2);
    _resolution = 30;
  }

  void _setDefaultDetailsRange() {
    final now = DateTime.now();
    _detailsFrom = DateTime(now.year, now.month, now.day); // midnight today
    _detailsTo = now;
  }

  void _setDefaultExportRange() {
    final now = DateTime.now();
    _exportFrom = DateTime(now.year, now.month, now.day); // start of today (00:00:00)
    _exportTo = DateTime(now.year, now.month, now.day, 23, 59, 59); // end of today (23:59:59)
  }

  Future<void> _loadInterfaces() async {
    try {
      _interfaces = await _apiService.getInsightInterfaces();
      // Default to first non-loopback interface
      _selectedInterface = _interfaces.keys.firstWhere(
        (k) => !_isLoopback(_interfaces[k]!),
        orElse: () => _interfaces.keys.first,
      );
      // Mirror the selected interface to the Details tab default.
      _detailsInterface = _selectedInterface ?? '';
    } catch (e) {
      _errorMessage = e.toString();
    }
  }

  // ── Data loading ────────────────────────────────────────────────────────────

  /// Loads all chart data in parallel.
  Future<void> loadChartData() async {
    _isLoadingCharts = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Match the OPNsense GUI timestamp algorithm exactly:
      //   endTs   = now (raw, no snapping)
      //   startTs = floor((now - window) / 3600) * 3600  (snapped to hour boundary)
      final endTs = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final rawStart = endTs - _windowDuration.inSeconds;
      final startTs = (rawStart ~/ 3600) * 3600;
      final iface = _selectedInterface ?? '';

      final results = await Future.wait([
        _apiService.getInsightTimeseries(
          startTs: startTs,
          endTs: endTs,
          resolution: _resolution,
        ),
        _apiService.getInsightTopPorts(
          interface: iface,
          startTs: startTs,
          endTs: endTs,
        ),
        _apiService.getInsightTopAddresses(
          interface: iface,
          startTs: startTs,
          endTs: endTs,
        ),
        _apiService.getInsightDirectionTotals(
          interface: iface,
          startTs: startTs,
          endTs: endTs,
          measure: 'octets',
        ),
        _apiService.getInsightDirectionTotals(
          interface: iface,
          startTs: startTs,
          endTs: endTs,
          measure: 'packets',
        ),
      ]);

      _timeseries = results[0] as List<NetworkInsightSeries>;
      _topPorts = results[1] as List<NetworkInsightTopPort>;
      _topAddresses = results[2] as List<NetworkInsightTopAddr>;
      _directionOctetTotals = results[3] as List<NetworkInsightDirectionTotal>;
      _directionPacketTotals = results[4] as List<NetworkInsightDirectionTotal>;
      // Re-run DNS resolution if the toggle is still on (new address list).
      if (_reverseLookupEnabled) {
        unawaited(toggleReverseLookup(enabled: true));
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoadingCharts = false;
      notifyListeners();
    }
  }

  /// Loads only the per-interface breakdown data (pie charts + totals).
  Future<void> _loadBreakdownData() async {
    _isLoadingCharts = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final endTs = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final rawStart = endTs - _windowDuration.inSeconds;
      final startTs = (rawStart ~/ 3600) * 3600;
      final iface = _selectedInterface ?? '';

      final results = await Future.wait([
        _apiService.getInsightTopPorts(
          interface: iface,
          startTs: startTs,
          endTs: endTs,
        ),
        _apiService.getInsightTopAddresses(
          interface: iface,
          startTs: startTs,
          endTs: endTs,
        ),
        _apiService.getInsightDirectionTotals(
          interface: iface,
          startTs: startTs,
          endTs: endTs,
          measure: 'octets',
        ),
        _apiService.getInsightDirectionTotals(
          interface: iface,
          startTs: startTs,
          endTs: endTs,
          measure: 'packets',
        ),
      ]);

      _topPorts = results[0] as List<NetworkInsightTopPort>;
      _topAddresses = results[1] as List<NetworkInsightTopAddr>;
      _directionOctetTotals = results[2] as List<NetworkInsightDirectionTotal>;
      _directionPacketTotals = results[3] as List<NetworkInsightDirectionTotal>;
      // Re-run DNS resolution if the toggle is still on (new address list).
      if (_reverseLookupEnabled) {
        unawaited(toggleReverseLookup(enabled: true));
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoadingCharts = false;
      notifyListeners();
    }
  }

  // ── Details loading ─────────────────────────────────────────────────────────

  /// Loads the per-flow details for the Details tab.
  ///
  /// Uses [_detailsExtraFilterField] / [_detailsExtraFilterValue] when set
  /// (drilldown from pie chart), otherwise falls back to the manual form
  /// text field filters.
  Future<void> loadFlowDetails() async {
    _isLoadingDetails = true;
    _detailsErrorMessage = null;
    notifyListeners();

    try {
      final startTs = _detailsFrom.millisecondsSinceEpoch ~/ 1000;
      final endTs = _detailsTo.millisecondsSinceEpoch ~/ 1000;
      _flowDetails = await _apiService.getInsightFlowDetails(
        startTs: startTs,
        endTs: endTs,
        interface: _detailsInterface,
        extraFilterField: _detailsExtraFilterField,
        extraFilterValue: _detailsExtraFilterValue,
        dstPort: _detailsDstPort.isEmpty ? null : _detailsDstPort,
        dstAddr: _detailsDstAddr.isEmpty ? null : _detailsDstAddr,
        srcAddr: _detailsSrcAddr.isEmpty ? null : _detailsSrcAddr,
      );
    } catch (e) {
      _detailsErrorMessage = e.toString();
    } finally {
      _isLoadingDetails = false;
      notifyListeners();
    }
  }

  /// Drilldown from a pie chart slice into the Details tab.
  ///
  /// Populates the corresponding visible form field with [filterValue] so the
  /// user sees the active filter, and sets the extra server-side filter for an
  /// accurate API query. The caller is responsible for switching the tab.
  ///
  /// [filterField] must be `'service_port'` (port chart) or `'src_addr'`
  /// (address chart).
  void drilldownToDetails({
    required String filterField,
    required String filterValue,
  }) {
    _detailsExtraFilterField = filterField;
    _detailsExtraFilterValue = filterValue;

    // Mirror the currently selected Totals interface into the Details form.
    if (_selectedInterface != null && _selectedInterface!.isNotEmpty) {
      _detailsInterface = _selectedInterface!;
    }

    // Populate the matching visible form field; clear the others.
    if (filterField == 'service_port') {
      _detailsDstPort = filterValue;
      _detailsDstAddr = '';
      _detailsSrcAddr = '';
    } else if (filterField == 'src_addr') {
      _detailsDstPort = '';
      _detailsDstAddr = '';
      _detailsSrcAddr = filterValue;
    } else {
      _detailsDstPort = '';
      _detailsDstAddr = '';
      _detailsSrcAddr = '';
    }

    // Notify immediately so the Details tab controllers sync even if the tab
    // was already mounted before the drilldown (lazy-build safe).
    notifyListeners();

    loadFlowDetails();
  }

  /// Clears the drilldown filter (called when the user edits the form manually).
  void clearDrilldown() {
    _detailsExtraFilterField = null;
    _detailsExtraFilterValue = null;
    notifyListeners();
  }

  // ── Mutations ───────────────────────────────────────────────────────────────

  /// Updates the window duration and resolution, then reloads all chart data.
  ///
  /// The end timestamp is always computed as DateTime.now() at load time, so
  /// only the duration and resolution need to be stored.
  void setTimeRange(Duration duration, int resolution) {
    _windowDuration = duration;
    _resolution = resolution;
    loadChartData();
  }

  /// Updates the selected interface for the breakdown section and reloads.
  void setSelectedInterface(String key) {
    if (_selectedInterface == key) return;
    _selectedInterface = key;
    // Clear any previous resolved labels when the interface changes —
    // the address list will be different after reload.
    _resolvedLabels = {};
    _loadBreakdownData();
  }

  /// Toggles reverse DNS resolution for the source-address pie chart.
  ///
  /// When turned on, calls the OPNsense DNS reverse-lookup endpoint with all
  /// non-empty, non-"other" IP addresses from [_topAddresses].
  /// When turned off, clears [_resolvedLabels] immediately.
  Future<void> toggleReverseLookup({required bool enabled}) async {
    _reverseLookupEnabled = enabled;
    if (!enabled) {
      _resolvedLabels = {};
      notifyListeners();
      return;
    }

    // Collect the real IP addresses (skip the empty "Other" sentinel row).
    final addresses = _topAddresses
        .where((a) => !a.isOther && a.srcAddr.isNotEmpty)
        .map((a) => a.srcAddr)
        .toList();

    if (addresses.isEmpty) {
      notifyListeners();
      return;
    }

    _isResolvingDns = true;
    notifyListeners();

    try {
      _resolvedLabels =
          await _apiService.reverseLookupAddresses(addresses);
    } catch (_) {
      // On failure leave _resolvedLabels empty; IPs are shown as-is.
      _resolvedLabels = {};
    } finally {
      _isResolvingDns = false;
      notifyListeners();
    }
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  static bool _isLoopback(String label) {
    final l = label.toLowerCase();
    return l.contains('loopback') || l == 'lo0';
  }
}
