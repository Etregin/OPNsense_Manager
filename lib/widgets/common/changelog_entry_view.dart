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
import '../../models/changelog_entry.dart';
import '../../utils/constants.dart';

/// Renders the sections and bullets of a single [ChangelogEntry].
/// Shared by the What's New dialog and the Changelog screen.
class ChangelogEntryView extends StatelessWidget {
  final ChangelogEntry entry;

  const ChangelogEntryView({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final section in entry.sections.entries) ...[
          Text(
            section.key,
            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          for (final item in section.value)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('\u2022 ', style: theme.textTheme.bodyMedium),
                  Expanded(child: Text(item, style: theme.textTheme.bodyMedium)),
                ],
              ),
            ),
          const SizedBox(height: AppConstants.compactPadding),
        ],
      ],
    );
  }
}
