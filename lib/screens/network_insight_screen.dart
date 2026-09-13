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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/routes.dart';
import '../l10n/app_localizations.dart';
import '../services/demo_api_service.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../utils/formatters.dart';
import '../utils/single_init_mixin.dart';
import '../viewmodels/network_insight_view_model.dart';
import '../widgets/app_drawer.dart';
import '../widgets/common/error_display.dart';
import '../widgets/network_insight/insight_details_tab.dart';
import '../widgets/network_insight/insight_export_tab.dart';
import '../widgets/network_insight/interface_totals_chart.dart';
import '../widgets/network_insight/netflow_disabled_banner.dart';
import '../widgets/network_insight/top_breakdown_pie_chart.dart';
import '../widgets/common/app_banner_ad_widget.dart';

/// Insights screen.
///
/// Shows three tabs:
/// - Totals: Interface Totals bps chart and per-interface breakdown with
///   protocol/address pie charts.
/// - Details: Per-flow breakdown with filters.
/// - Export: Placeholder (to be implemented).
class NetworkInsightScreen extends StatefulWidget {
  const NetworkInsightScreen({super.key});

  @override
  State<NetworkInsightScreen> createState() => _NetworkInsightScreenState();
}

class _NetworkInsightScreenState extends State<NetworkInsightScreen>
    with SingleInitMixin, TickerProviderStateMixin {
  late NetworkInsightViewModel _vm;
  late TabController _tabController;

  // ── Loopback visibility toggle ──────────────────────────────────────────────
  bool _showLoopback = true;

  @override
  void onFirstDependency() {
    _tabController = TabController(length: 3, vsync: this);
    _vm = NetworkInsightViewModel(context.read<DemoApiService>());
    _vm.addListener(_onVmChanged);
    _vm.loadInitial();
  }

  void _onVmChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    _vm.removeListener(_onVmChanged);
    _vm.dispose();
    super.dispose();
  }

  // ── Time range presets ──────────────────────────────────────────────────────

  /// Raw preset definitions (duration + resolution). Labels are built from
  /// l10n at build time via [_buildPresetLabel].
  static const List<_TimePreset> _presets = [
    _TimePreset(Duration(hours: 2),    30),
    _TimePreset(Duration(hours: 8),    300),
    _TimePreset(Duration(hours: 24),   300),
    _TimePreset(Duration(days: 7),     3600),
    _TimePreset(Duration(days: 14),    3600),
    _TimePreset(Duration(days: 30),    86400),
    _TimePreset(Duration(days: 60),    86400),
    _TimePreset(Duration(days: 90),    86400),
    _TimePreset(Duration(days: 182),   86400),
    _TimePreset(Duration(days: 365),   86400),
  ];

  int _selectedPresetIndex = 0;

  void _onPresetChanged(int index) {
    setState(() => _selectedPresetIndex = index);
    final preset = _presets[index];
    _vm.setTimeRange(preset.duration, preset.resolution);
  }

  /// Builds the human-readable label for a preset using l10n.
  String _buildPresetLabel(AppLocalizations l10n, _TimePreset preset) {
    final String window;
    if (preset.duration.inDays == 365) {
      window = l10n.durationLastYear;
    } else if (preset.duration.inDays > 0) {
      window = l10n.durationDays(preset.duration.inDays);
    } else {
      window = l10n.durationHours(preset.duration.inHours);
    }

    final String avgInterval;
    switch (preset.resolution) {
      case 30:
        avgInterval = l10n.resolution30s;
      case 300:
        avgInterval = l10n.resolution5min;
      case 3600:
        avgInterval = l10n.oneHour;
      default:
        avgInterval = l10n.resolution24hr;
    }

    return l10n.timePresetLabel(window, avgInterval);
  }

  // ── Build ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.networkInsight),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: l10n.tabTotals),
            Tab(text: l10n.tabDetails),
            Tab(text: l10n.export),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: l10n.refresh,
            onPressed: _vm.isLoadingCharts ? null : _vm.loadChartData,
          ),
        ],
      ),
      drawer: const AppDrawer(currentRoute: Routes.networkInsight),
      body: Column(
        children: [
          Expanded(child: _buildBody(context, l10n)),
          const AppBannerAdWidget(),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, AppLocalizations l10n) {
    if (_vm.isCheckingNetflow) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: AppConstants.standardPadding),
            Text(l10n.checkingNetflowStatus),
          ],
        ),
      );
    }

    if (_vm.errorMessage != null && !_vm.netflowEnabled) {
      return ErrorDisplay(
        message: _vm.errorMessage!,
        onRetry: _vm.loadInitial,
      );
    }

    if (!_vm.netflowEnabled) {
      return const NetflowDisabledBanner();
    }

    return TabBarView(
      controller: _tabController,
      children: [
        _TotalsTab(
          vm: _vm,
          presets: _presets,
          selectedPresetIndex: _selectedPresetIndex,
          showLoopback: _showLoopback,
          onPresetChanged: _onPresetChanged,
          onShowLoopbackChanged: (v) => setState(() => _showLoopback = v),
          buildPresetLabel: _buildPresetLabel,
          onDrilldown: (filterField, filterValue) {
            _vm.drilldownToDetails(
              filterField: filterField,
              filterValue: filterValue,
            );
            _tabController.animateTo(1); // switch to Details tab
          },
        ),
        _DetailsTab(vm: _vm),
        _ExportTab(vm: _vm),
      ],
    );
  }
}

// ── Totals tab ────────────────────────────────────────────────────────────────

class _TotalsTab extends StatelessWidget {
  final NetworkInsightViewModel vm;
  final List<_TimePreset> presets;
  final int selectedPresetIndex;
  final bool showLoopback;
  final ValueChanged<int> onPresetChanged;
  final ValueChanged<bool> onShowLoopbackChanged;
  final String Function(AppLocalizations, _TimePreset) buildPresetLabel;
  /// Called with (filterField, filterValue) when the user drills down from
  /// a pie chart item. filterField is `service_port` or `src_addr`.
  final void Function(String filterField, String filterValue) onDrilldown;

  const _TotalsTab({
    required this.vm,
    required this.presets,
    required this.selectedPresetIndex,
    required this.showLoopback,
    required this.onPresetChanged,
    required this.onShowLoopbackChanged,
    required this.buildPresetLabel,
    required this.onDrilldown,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return RefreshIndicator(
      onRefresh: vm.loadChartData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppConstants.standardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTimeRangeSelector(context, l10n),
            const SizedBox(height: AppConstants.standardPadding),
            _buildInterfaceTotalsSection(context, l10n),
            const SizedBox(height: AppConstants.standardPadding * 1.5),
            _buildBreakdownSection(context, l10n),
          ],
        ),
      ),
    );
  }

  // ── Time range selector ────────────────────────────────────────────────────

  Widget _buildTimeRangeSelector(BuildContext context, AppLocalizations l10n) {
    return Card(
      elevation: AppConstants.cardElevation,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.standardPadding,
          vertical: AppConstants.compactPadding,
        ),
        child: Row(
          children: [
            Icon(Icons.access_time,
                size: 18,
                color: Theme.of(context).colorScheme.onSurfaceVariant),
            const SizedBox(width: AppConstants.compactPadding),
            Expanded(
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: selectedPresetIndex,
                  isExpanded: true,
                  items: List.generate(
                    presets.length,
                    (i) => DropdownMenuItem(
                      value: i,
                      child: Text(
                        buildPresetLabel(l10n, presets[i]),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                  onChanged: (i) {
                    if (i != null) onPresetChanged(i);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Interface totals (top charts) ──────────────────────────────────────────

  Widget _buildInterfaceTotalsSection(
      BuildContext context, AppLocalizations l10n) {
    return Card(
      elevation: AppConstants.cardElevation,
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.standardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.interfaceTotalsBitsPerSec,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      l10n.showLoopback,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Switch(
                      value: showLoopback,
                      onChanged: onShowLoopbackChanged,
                    ),
                    const SizedBox(width: AppConstants.compactPadding),
                    IconButton(
                      icon: const Icon(Icons.fullscreen, size: 20),
                      tooltip: l10n.fullScreen,
                      onPressed: vm.timeseries.isEmpty
                          ? null
                          : () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  fullscreenDialog: true,
                                  builder: (ctx) {
                                    return StatefulBuilder(
                                      builder: (context, setDialogState) {
                                        return Scaffold(
                                          appBar: AppBar(
                                            title: Text(l10n.interfaceTotalsBitsPerSec),
                                          ),
                                          body: SafeArea(
                                            child: Padding(
                                              padding: const EdgeInsets.all(AppConstants.standardPadding),
                                              child: InterfaceTotalsChart(
                                                series: vm.timeseries,
                                                showLoopback: showLoopback,
                                                isFullScreen: true,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              );
                            },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppConstants.compactPadding),
            if (vm.isLoadingCharts)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(AppConstants.standardPadding),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (vm.timeseries.isEmpty)
              const SizedBox(height: 80)
            else
              InterfaceTotalsChart(
                series: vm.timeseries,
                showLoopback: showLoopback,
              ),
          ],
        ),
      ),
    );
  }

  // ── Per-interface breakdown (pie charts) ───────────────────────────────────

  Widget _buildBreakdownSection(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.perInterfaceBreakdown,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            if (vm.interfaces.isNotEmpty)
              _InterfaceDropdown(
                interfaces: vm.interfaces,
                selectedKey: vm.selectedInterface,
                onChanged: vm.setSelectedInterface,
              ),
          ],
        ),
        const SizedBox(height: AppConstants.standardPadding),
        if (vm.isLoadingCharts)
          const Center(child: CircularProgressIndicator())
        else ...[
          _buildTotalsSummary(context, l10n),
          const SizedBox(height: AppConstants.standardPadding),
          _buildPieCharts(context, l10n),
        ],
      ],
    );
  }

  Widget _buildTotalsSummary(BuildContext context, AppLocalizations l10n) {
    final octets = vm.directionOctetTotals;
    final packets = vm.directionPacketTotals;
    double bytesIn = 0, bytesOut = 0, pktsIn = 0, pktsOut = 0;
    for (final e in octets) {
      if (e.direction == 'in') bytesIn = e.total;
      if (e.direction == 'out') bytesOut = e.total;
    }
    for (final e in packets) {
      if (e.direction == 'in') pktsIn = e.total;
      if (e.direction == 'out') pktsOut = e.total;
    }

    return Card(
      elevation: AppConstants.cardElevation,
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.standardPadding),
        child: Column(
          children: [
            _SummaryRow(
              label: l10n.totalBytesIn,
              value: Formatters.formatBytes(bytesIn.round()),
              icon: Icons.arrow_downward,
              color: AppColors.success,
            ),
            _SummaryRow(
              label: l10n.totalBytesOut,
              value: Formatters.formatBytes(bytesOut.round()),
              icon: Icons.arrow_upward,
              color: AppColors.error,
            ),
            _SummaryRow(
              label: l10n.totalPacketsIn,
              value: Formatters.formatNumber(pktsIn.round()),
              icon: Icons.arrow_downward,
              color: AppColors.success,
            ),
            _SummaryRow(
              label: l10n.totalPacketsOut,
              value: Formatters.formatNumber(pktsOut.round()),
              icon: Icons.arrow_upward,
              color: AppColors.error,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieCharts(BuildContext context, AppLocalizations l10n) {
    // Build port chart items keeping a label→rawPort map for drilldown.
    final Map<String, String> labelToPort = {};
    final portItems = vm.topPorts.map((p) {
      if (p.isOther) return (l10n.other, p.total);
      final label = p.label.isEmpty ? p.dstPort : p.label;
      labelToPort[label] = p.dstPort;
      return (label, p.total);
    }).toList();

    // Build address chart items keeping a label→rawAddr map for drilldown.
    final Map<String, String> labelToAddr = {};
    final addrItems = vm.topAddresses.map((a) {
      if (a.isOther) return (l10n.other, a.total);
      final label = vm.reverseLookupEnabled
          ? (vm.resolvedLabels[a.srcAddr] ?? a.srcAddr)
          : a.srcAddr;
      labelToAddr[label] = a.srcAddr; // always map to the raw IP
      return (label, a.total);
    }).toList();

    return Column(
      children: [
        Card(
          elevation: AppConstants.cardElevation,
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.standardPadding),
            child: TopBreakdownPieChart(
              title: l10n.protocolsBreakdown,
              items: portItems,
              otherLabel: l10n.other,
              onItemTap: (label) {
                final rawPort = labelToPort[label];
                if (rawPort != null && rawPort.isNotEmpty) {
                  onDrilldown('service_port', rawPort);
                }
              },
            ),
          ),
        ),
        const SizedBox(height: AppConstants.standardPadding),
        Card(
          elevation: AppConstants.cardElevation,
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.standardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Reverse lookup toggle ───────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.sourceAddressBreakdown,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                    if (vm.isResolvingDns)
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    const SizedBox(width: AppConstants.compactPadding),
                    Text(
                      l10n.reverseLookup,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Switch(
                      value: vm.reverseLookupEnabled,
                      onChanged: vm.isLoadingCharts
                          ? null
                          : (v) => vm.toggleReverseLookup(enabled: v),
                    ),
                  ],
                ),
                // ── Pie chart (title already shown in header above) ─
                TopBreakdownPieChart(
                  title: '',
                  items: addrItems,
                  otherLabel: l10n.other,
                  onItemTap: (label) {
                    final rawAddr = labelToAddr[label] ?? label;
                    onDrilldown('src_addr', rawAddr);
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── Details tab ───────────────────────────────────────────────────────────────

class _DetailsTab extends StatelessWidget {
  final NetworkInsightViewModel vm;

  const _DetailsTab({required this.vm});

  @override
  Widget build(BuildContext context) {
    return InsightDetailsTab(viewModel: vm);
  }
}

// ── Export tab ────────────────────────────────────────────────────────────────

class _ExportTab extends StatelessWidget {
  final NetworkInsightViewModel vm;

  const _ExportTab({required this.vm});

  @override
  Widget build(BuildContext context) {
    return InsightExportTab(viewModel: vm);
  }
}

// ── Private helpers ───────────────────────────────────────────────────────────

/// Dropdown for the per-interface breakdown filter.
class _InterfaceDropdown extends StatelessWidget {
  final Map<String, String> interfaces;
  final String? selectedKey;
  final ValueChanged<String> onChanged;

  const _InterfaceDropdown({
    required this.interfaces,
    required this.selectedKey,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: selectedKey,
        items: interfaces.entries
            .map((e) => DropdownMenuItem(
                  value: e.key,
                  child: Text(e.value),
                ))
            .toList(),
        onChanged: (v) {
          if (v != null) onChanged(v);
        },
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryRow({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: AppConstants.compactPadding),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}

/// Simple data class for time-range presets.
class _TimePreset {
  final Duration duration;
  final int resolution;

  const _TimePreset(this.duration, this.resolution);
}
