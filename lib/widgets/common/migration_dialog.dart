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
import 'package:url_launcher/url_launcher.dart';
import '../../l10n/app_localizations.dart';
import '../../services/supporter_service.dart';
import '../../utils/constants.dart';

/// One-time migration dialog shown on first launch after moving to free model.
/// Explains the change, ad placement transparency, and legacy user options.
class MigrationDialog extends StatelessWidget {
  const MigrationDialog({super.key});

  /// Shows the migration dialog. Non-dismissible — user must tap an action.
  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const MigrationDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.celebration_outlined, color: colorScheme.primary),
          const SizedBox(width: AppConstants.compactPadding),
          Expanded(
            child: Text(l10n.migrationDialogTitle, style: theme.textTheme.titleLarge),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.migrationDialogWhyTitle, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(l10n.migrationDialogWhyBody, style: theme.textTheme.bodyMedium),
            const SizedBox(height: AppConstants.standardPadding),
            Text(l10n.migrationDialogAdsTitle, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(l10n.migrationDialogAdsBody, style: theme.textTheme.bodyMedium),
            const SizedBox(height: AppConstants.standardPadding),
            Text(l10n.migrationDialogLegacyTitle, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(l10n.migrationDialogLegacyBody, style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            await launchUrl(
              Uri.parse(StringConstants.legacyClaimMailtoUri),
              mode: LaunchMode.externalApplication,
            );
          },
          child: Text(l10n.claimLegacyAccess),
        ),
        FilledButton(
          onPressed: () async {
            await context.read<SupporterService>().setMigrationDismissed();
            if (context.mounted) Navigator.of(context).pop();
          },
          child: Text(l10n.continueToApp),
        ),
      ],
    );
  }
}
