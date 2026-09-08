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
import '../../models/unbound_totals.dart';
import '../../utils/app_colors.dart';
import '../../utils/constants.dart';
import '../../utils/formatters.dart';

class UnboundMetricsHeader extends StatelessWidget {
  final UnboundTotals? totals;

  const UnboundMetricsHeader({
    super.key,
    required this.totals,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final startDateTimeStr = totals?.startTime != null
        ? Formatters.formatDateTime(
            DateTime.fromMillisecondsSinceEpoch(totals!.startTime! * 1000),
          )
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (startDateTimeStr != null) ...[
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.compactPadding,
              vertical: AppConstants.compactPadding,
            ),
            child: Text(
              l10n.startingFrom(startDateTimeStr),
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: AppConstants.compactPadding),
        ],
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                title: l10n.totalQueries,
                value: totals != null ? Formatters.formatNumber(totals!.total) : '—',
                color: AppColors.primary,
                icon: Icons.query_stats,
              ),
            ),
            const SizedBox(width: AppConstants.compactPadding),
            Expanded(
              child: _MetricCard(
                title: l10n.resolvedQueries,
                value: totals?.resolved != null
                    ? '${Formatters.formatNumber(totals!.resolved!.total)} (${totals!.resolved!.pcnt.toStringAsFixed(1)}%)'
                    : '—',
                color: AppColors.success,
                icon: Icons.check_circle_outline,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.compactPadding),
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                title: l10n.blockedQueries,
                value: totals?.blocked != null
                    ? '${Formatters.formatNumber(totals!.blocked!.total)} (${totals!.blocked!.pcnt.toStringAsFixed(1)}%)'
                    : '—',
                color: AppColors.error,
                icon: Icons.block,
              ),
            ),
            const SizedBox(width: AppConstants.compactPadding),
            Expanded(
              child: _MetricCard(
                title: l10n.blocklistSize,
                value: totals != null ? Formatters.formatNumber(totals!.blocklistSize) : '—',
                color: AppColors.disabled,
                icon: Icons.security,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: AppConstants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.standardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: color),
                const SizedBox(width: AppConstants.compactPadding),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.compactPadding),
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
