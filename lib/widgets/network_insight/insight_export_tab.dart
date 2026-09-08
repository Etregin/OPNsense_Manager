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
import '../../utils/app_colors.dart';
import '../../utils/constants.dart';
import '../../utils/snackbar_helper.dart';
import '../../viewmodels/network_insight_view_model.dart';

/// The "Export" tab of the Insights screen.
///
/// Allows selecting:
/// - Collection (FlowSourceAddrDetails, FlowSourceAddrTotals, FlowDstPortTotals, FlowInterfaceTotals)
/// - Resolution (seconds): 86400 (1 day)
/// - From Date
/// - To Date
///
/// And triggers downloading the CSV report via [FilePicker.saveFile].
class InsightExportTab extends StatelessWidget {
  final NetworkInsightViewModel viewModel;

  const InsightExportTab({super.key, required this.viewModel});

  Future<void> _pickFrom(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: viewModel.exportFrom,
      firstDate: DateTime(2020),
      lastDate: viewModel.exportTo,
    );
    if (picked != null) {
      viewModel.setExportDateRange(picked, viewModel.exportTo);
    }
  }

  Future<void> _pickTo(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: viewModel.exportTo,
      firstDate: viewModel.exportFrom,
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (picked != null) {
      // Snap to end of day
      final end = DateTime(picked.year, picked.month, picked.day, 23, 59, 59);
      viewModel.setExportDateRange(viewModel.exportFrom, end);
    }
  }

  Future<void> _handleExport(BuildContext context, AppLocalizations l10n) async {
    final success = await viewModel.exportNetflowCsv();
    if (!context.mounted) return;

    if (success) {
      SnackBarHelper.showSuccess(context, l10n.netflowExportSuccess);
    } else if (viewModel.exportErrorMessage != null) {
      SnackBarHelper.showError(
        context,
        l10n.netflowExportFailed(viewModel.exportErrorMessage!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.standardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: AppConstants.cardElevation,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.standardPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Field 1: Collection Dropdown
                      DropdownButtonFormField<String>(
                        initialValue: viewModel.exportCollection,
                        decoration: InputDecoration(
                          labelText: l10n.collection,
                          border: const OutlineInputBorder(),
                          isDense: true,
                        ),
                        items: NetworkInsightViewModel.exportCollections.map((col) {
                          return DropdownMenuItem<String>(
                            value: col,
                            child: Text(col),
                          );
                        }).toList(),
                        onChanged: viewModel.isExporting
                            ? null
                            : (val) {
                                if (val != null) {
                                  viewModel.setExportCollection(val);
                                }
                              },
                      ),
                      const SizedBox(height: AppConstants.standardPadding),

                      // Field 2: Resolution (seconds) - 86400 (only this option)
                      DropdownButtonFormField<int>(
                        initialValue: NetworkInsightViewModel.exportResolution,
                        decoration: InputDecoration(
                          labelText: l10n.resolutionSeconds,
                          border: const OutlineInputBorder(),
                          isDense: true,
                        ),
                        items: [
                          DropdownMenuItem<int>(
                            value: NetworkInsightViewModel.exportResolution,
                            child: Text(l10n.resolution86400),
                          ),
                        ],
                        onChanged: viewModel.isExporting ? null : (_) {},
                      ),
                      const SizedBox(height: AppConstants.standardPadding),

                      // Field 3 & 4: From Date & To Date
                      Row(
                        children: [
                          Expanded(
                            child: _ExportDateField(
                              label: l10n.dateFrom,
                              date: viewModel.exportFrom,
                              enabled: !viewModel.isExporting,
                              onTap: () => _pickFrom(context),
                            ),
                          ),
                          const SizedBox(width: AppConstants.standardPadding),
                          Expanded(
                            child: _ExportDateField(
                              label: l10n.dateTo,
                              date: viewModel.exportTo,
                              enabled: !viewModel.isExporting,
                              onTap: () => _pickTo(context),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppConstants.standardPadding),

                      // Export Button
                      FilledButton.icon(
                        onPressed: viewModel.isExporting
                            ? null
                            : () => _handleExport(context, l10n),
                        icon: viewModel.isExporting
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.onPrimary,
                                ),
                              )
                            : const Icon(Icons.download, size: 18),
                        label: Text(l10n.export),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppConstants.standardPadding,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppConstants.buttonBorderRadius,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ExportDateField extends StatelessWidget {
  final String label;
  final DateTime date;
  final bool enabled;
  final VoidCallback onTap;

  const _ExportDateField({
    required this.label,
    required this.date,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final formatted =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

    return InkWell(
      onTap: enabled ? onTap : null,
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
