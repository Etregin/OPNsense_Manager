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
import '../../models/changelog_entry.dart';
import '../../services/changelog_service.dart';
import '../../utils/constants.dart';
import 'changelog_entry_view.dart';

/// Dialog shown on first install and after each app update, listing the
/// changes of the current version taken from CHANGELOG.md.
class WhatsNewDialog extends StatelessWidget {
  final ChangelogEntry entry;

  const WhatsNewDialog({super.key, required this.entry});

  /// Shows the dialog and records the version as seen once dismissed.
  static Future<void> show(BuildContext context, ChangelogEntry entry) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => WhatsNewDialog(entry: entry),
    );
    await ChangelogService().markSeen(entry.version);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.new_releases_outlined, color: theme.colorScheme.primary),
          const SizedBox(width: AppConstants.compactPadding),
          Expanded(
            child: Text(l10n.whatsNewTitle(entry.version), style: theme.textTheme.titleLarge),
          ),
        ],
      ),
      content: SingleChildScrollView(child: ChangelogEntryView(entry: entry)),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.done),
        ),
      ],
    );
  }
}
