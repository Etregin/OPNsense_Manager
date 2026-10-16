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
import '../constants/routes.dart';
import '../l10n/app_localizations.dart';
import '../models/changelog_entry.dart';
import '../services/changelog_service.dart';
import '../utils/constants.dart';
import '../widgets/app_drawer.dart';
import '../widgets/common/changelog_entry_view.dart';
import '../widgets/common/error_display.dart';

/// Lists every version from the bundled CHANGELOG.md, newest first.
class ChangelogScreen extends StatefulWidget {
  const ChangelogScreen({super.key});

  @override
  State<ChangelogScreen> createState() => _ChangelogScreenState();
}

class _ChangelogScreenState extends State<ChangelogScreen> {
  late Future<List<ChangelogEntry>> _entries;

  @override
  void initState() {
    super.initState();
    _entries = ChangelogService().getAll();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.changelog)),
      drawer: const AppDrawer(currentRoute: Routes.changelog),
      body: FutureBuilder<List<ChangelogEntry>>(
        future: _entries,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErrorDisplay(
              message: l10n.errorLoadingData,
              onRetry: () => setState(() => _entries = ChangelogService().getAll()),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
            padding: const EdgeInsets.all(AppConstants.standardPadding),
            children: [
              for (final entry in snapshot.data!)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppConstants.standardPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.isUnreleased ? l10n.changelogUnreleased : entry.version,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: AppConstants.compactPadding),
                        ChangelogEntryView(entry: entry),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
