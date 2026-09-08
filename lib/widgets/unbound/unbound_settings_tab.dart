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
import '../../viewmodels/unbound_dns_view_model.dart';
import '../common/confirmation_dialog.dart';

class UnboundSettingsTab extends StatelessWidget {
  final UnboundDnsViewModel viewModel;

  const UnboundSettingsTab({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.standardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: AppConstants.cardElevation,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.standardPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      l10n.enableUnboundStatistics,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      l10n.enableUnboundStatisticsDescription,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    value: viewModel.statsToggleValue,
                    onChanged: (val) {
                      viewModel.setStatsToggle(val);
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppConstants.standardPadding),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: viewModel.isActionLoading
                      ? null
                      : () async {
                          final success = await viewModel.applySettings();
                          if (context.mounted) {
                            if (success) {
                              SnackBarHelper.showSuccess(context, l10n.unboundSettingsSaved);
                            } else if (viewModel.errorMessage != null) {
                              SnackBarHelper.showError(context, viewModel.errorMessage!);
                            }
                          }
                        },
                  icon: viewModel.isActionLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.check),
                  label: Text(l10n.apply),
                ),
              ),
              const SizedBox(width: AppConstants.standardPadding),
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error),
                  ),
                  onPressed: viewModel.isActionLoading
                      ? null
                      : () async {
                          final confirmed = await ConfirmationDialog.show(
                            context: context,
                            title: l10n.resetDnsData,
                            message: l10n.resetDnsDataConfirmation,
                            confirmText: l10n.resetDnsData,
                            cancelText: l10n.cancel,
                            isDestructive: true,
                          );
                          if (confirmed == true && context.mounted) {
                            final success = await viewModel.resetDnsData();
                            if (context.mounted) {
                              if (success) {
                                SnackBarHelper.showSuccess(context, l10n.dnsDataResetSuccess);
                              } else if (viewModel.errorMessage != null) {
                                SnackBarHelper.showError(context, viewModel.errorMessage!);
                              }
                            }
                          }
                        },
                  icon: const Icon(Icons.delete_sweep),
                  label: Text(l10n.resetDnsData),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
