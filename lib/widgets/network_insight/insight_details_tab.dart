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
import '../../l10n/app_localizations.dart';
import '../../models/insight_flow_detail.dart';
import '../../utils/constants.dart';
import '../../utils/formatters.dart';
import '../../viewmodels/network_insight_view_model.dart';
import '../common/empty_state_widget.dart';
import '../common/error_display.dart';

/// The "Details" tab of the Insights screen.
///
/// Provides a filter form (date range, interface, optional address/port
/// filters) and renders the [InsightFlowDetail] results in a table that
/// mirrors the OPNsense GUI output exactly.
class InsightDetailsTab extends StatefulWidget {
  final NetworkInsightViewModel viewModel;

  const InsightDetailsTab({super.key, required this.viewModel});

  @override
  State<InsightDetailsTab> createState() => _InsightDetailsTabState();
}

class _InsightDetailsTabState extends State<InsightDetailsTab> {
  final TextEditingController _dstPortCtrl = TextEditingController();
  final TextEditingController _dstAddrCtrl = TextEditingController();
  final TextEditingController _srcAddrCtrl = TextEditingController();

  NetworkInsightViewModel get _vm => widget.viewModel;

  @override
  void initState() {
    super.initState();
    _dstPortCtrl.text = _vm.detailsDstPort;
    _dstAddrCtrl.text = _vm.detailsDstAddr;
    _srcAddrCtrl.text = _vm.detailsSrcAddr;
    // Sync controllers when a drilldown resets the filter fields.
    _vm.addListener(_syncControllers);
  }

  void _syncControllers() {
    if (_dstPortCtrl.text != _vm.detailsDstPort) {
      _dstPortCtrl.text = _vm.detailsDstPort;
    }
    if (_dstAddrCtrl.text != _vm.detailsDstAddr) {
      _dstAddrCtrl.text = _vm.detailsDstAddr;
    }
    if (_srcAddrCtrl.text != _vm.detailsSrcAddr) {
      _srcAddrCtrl.text = _vm.detailsSrcAddr;
    }
  }

  @override
  void dispose() {
    _vm.removeListener(_syncControllers);
    _dstPortCtrl.dispose();
    _dstAddrCtrl.dispose();
    _srcAddrCtrl.dispose();
    super.dispose();
  }

  // ── Date picker helpers ───────────────────────────────────────────────────

  Future<void> _pickFrom(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _vm.detailsFrom,
      firstDate: DateTime(2020),
      lastDate: _vm.detailsTo,
    );
    if (picked != null) {
      _vm.setDetailsDateRange(picked, _vm.detailsTo);
    }
  }

  Future<void> _pickTo(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _vm.detailsTo,
      firstDate: _vm.detailsFrom,
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (picked != null) {
      // Preserve time-of-day for "to": snap to end of the picked day.
      final end = DateTime(picked.year, picked.month, picked.day, 23, 59, 59);
      _vm.setDetailsDateRange(_vm.detailsFrom, end);
    }
  }

  // ── Percentage calculation ────────────────────────────────────────────────

  /// Calculates percentage of [row] relative to the grand total of all rows
  /// (including the "Other" sentinel), matching OPNsense GUI output exactly.
  String _percent(InsightFlowDetail row, List<InsightFlowDetail> rows) {
    final grandTotal = rows.fold<int>(0, (sum, r) => sum + r.total);
    if (grandTotal == 0) return '0.00 %';
    final pct = row.total / grandTotal * 100;
    return '${pct.toStringAsFixed(2)} %';
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListenableBuilder(
      listenable: _vm,
      builder: (context, _) {
        // Sync controllers on every rebuild — handles the case where the tab
        // was lazily built after a drilldown already mutated the VM state.
        _syncControllers();
        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.standardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildFilterForm(context, l10n),
              const SizedBox(height: AppConstants.standardPadding),
              _buildResults(context, l10n),
            ],
          ),
        );
      },
    );
  }

  // ── Filter form ───────────────────────────────────────────────────────────

  Widget _buildFilterForm(BuildContext context, AppLocalizations l10n) {
    return Card(
      elevation: AppConstants.cardElevation,
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.standardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Row 1: Date From | Date To
            Row(
              children: [
                Expanded(
                  child: _DateField(
                    label: l10n.dateFrom,
                    date: _vm.detailsFrom,
                    onTap: () => _pickFrom(context),
                  ),
                ),
                const SizedBox(width: AppConstants.standardPadding),
                Expanded(
                  child: _DateField(
                    label: l10n.dateTo,
                    date: _vm.detailsTo,
                    onTap: () => _pickTo(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.standardPadding),

            // Row 2: Interface dropdown
            if (_vm.interfaces.isNotEmpty)
              _InterfaceRow(
                label: l10n.interface,
                interfaces: _vm.interfaces,
                selectedKey: _vm.detailsInterface.isEmpty
                    ? _vm.interfaces.keys.first
                    : _vm.detailsInterface,
                onChanged: _vm.setDetailsInterface,
              ),
            if (_vm.interfaces.isNotEmpty)
              const SizedBox(height: AppConstants.standardPadding),

            // Row 3: (dst) Port
            TextField(
              controller: _dstPortCtrl,
              decoration: InputDecoration(
                labelText: '(dst) ${l10n.destinationPort}',
                border: const OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (v) {
                _vm.clearDrilldown();
                _vm.setDetailsDstPort(v);
              },
            ),
            const SizedBox(height: AppConstants.standardPadding),

            // Row 4: (dst) Address
            TextField(
              controller: _dstAddrCtrl,
              decoration: InputDecoration(
                labelText: '(dst) ${l10n.destinationAddress}',
                border: const OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (v) {
                _vm.clearDrilldown();
                _vm.setDetailsDstAddr(v);
              },
            ),
            const SizedBox(height: AppConstants.standardPadding),

            // Row 5: (src) Address
            TextField(
              controller: _srcAddrCtrl,
              decoration: InputDecoration(
                labelText: '(src) ${l10n.sourceAddress}',
                border: const OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (v) {
                _vm.clearDrilldown();
                _vm.setDetailsSrcAddr(v);
              },
            ),
            const SizedBox(height: AppConstants.standardPadding),

            // Refresh button
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: Text(l10n.refresh),
              onPressed: _vm.isLoadingDetails ? null : _vm.loadFlowDetails,
            ),
          ],
        ),
      ),
    );
  }

  // ── Results area ──────────────────────────────────────────────────────────

  Widget _buildResults(BuildContext context, AppLocalizations l10n) {
    if (_vm.isLoadingDetails) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_vm.detailsErrorMessage != null) {
      return ErrorDisplay(
        message: _vm.detailsErrorMessage!,
        onRetry: _vm.loadFlowDetails,
      );
    }

    if (_vm.flowDetails.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.search_off,
        title: l10n.noDataAvailable,
      );
    }

    return _buildTable(context, l10n, _vm.flowDetails);
  }

  Widget _buildTable(
    BuildContext context,
    AppLocalizations l10n,
    List<InsightFlowDetail> rows,
  ) {
    final grandTotal = rows.fold<int>(0, (sum, r) => sum + r.total);
    final boldStyle = const TextStyle(fontWeight: FontWeight.bold);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: AppConstants.standardPadding,
        headingRowHeight: 40,
        dataRowMinHeight: 36,
        dataRowMaxHeight: 48,
        columns: [
          DataColumn(label: Text(l10n.serviceColumn)),
          DataColumn(label: Text(l10n.source)),
          DataColumn(label: Text(l10n.destination)),
          DataColumn(label: Text(l10n.bytesColumn), numeric: true),
          DataColumn(label: Text(l10n.lastSeenColumn)),
          DataColumn(label: Text(l10n.percentColumn), numeric: true),
        ],
        rows: [
          ...rows.map((row) => DataRow(
                cells: [
                  DataCell(Text(row.label)),
                  DataCell(Text(row.srcAddr)),
                  DataCell(Text(row.dstAddr)),
                  DataCell(Text(Formatters.formatBytes(row.total))),
                  DataCell(Text(row.lastSeenStr ?? '')),
                  DataCell(Text(_percent(row, rows))),
                ],
              )),
          // Totals row
          DataRow(
            cells: [
              DataCell(Text(l10n.total, style: boldStyle)),
              const DataCell(Text('')),
              const DataCell(Text('')),
              DataCell(Text(
                Formatters.formatBytes(grandTotal),
                style: boldStyle,
              )),
              const DataCell(Text('')),
              DataCell(Text('100.00 %', style: boldStyle)),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Private helpers ───────────────────────────────────────────────────────────

/// A tappable read-only date field.
class _DateField extends StatelessWidget {
  final String label;
  final DateTime date;
  final VoidCallback onTap;

  const _DateField({
    required this.label,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final formatted =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppConstants.buttonBorderRadius),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          isDense: true,
          suffixIcon: const Icon(Icons.calendar_today, size: 18),
        ),
        child: Text(formatted),
      ),
    );
  }
}

/// Interface selection row (label + dropdown).
class _InterfaceRow extends StatelessWidget {
  final String label;
  final Map<String, String> interfaces;
  final String selectedKey;
  final ValueChanged<String> onChanged;

  const _InterfaceRow({
    required this.label,
    required this.interfaces,
    required this.selectedKey,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(width: AppConstants.standardPadding),
        Expanded(
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: interfaces.containsKey(selectedKey)
                  ? selectedKey
                  : interfaces.keys.first,
              isExpanded: true,
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
          ),
        ),
      ],
    );
  }
}
