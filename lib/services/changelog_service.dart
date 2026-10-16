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

import 'package:flutter/services.dart';
import '../models/changelog_entry.dart';
import '../utils/constants.dart';
import 'storage_service.dart';

/// Loads and parses the bundled CHANGELOG.md and tracks which version's
/// "What's New" dialog the user has already seen.
class ChangelogService {
  static final ChangelogService _instance = ChangelogService._internal();
  factory ChangelogService() => _instance;
  ChangelogService._internal();

  static const String _assetPath = 'CHANGELOG.md';

  static final RegExp _versionHeading = RegExp(r'^##\s+\[([^\]]+)\]');
  static final RegExp _sectionHeading = RegExp(r'^###\s+(.+?)\s*$');
  static final RegExp _bullet = RegExp(r'^-\s+(.*\S)\s*$');

  List<ChangelogEntry>? _cache;

  /// Returns all versions in file order (newest first).
  Future<List<ChangelogEntry>> getAll() async {
    return _cache ??= parse(await rootBundle.loadString(_assetPath));
  }

  /// Returns the entry whose version equals [version], or null.
  Future<ChangelogEntry?> getForVersion(String version) async {
    for (final entry in await getAll()) {
      if (entry.version == version) return entry;
    }
    return null;
  }

  /// Returns the entry to show in the "What's New" dialog, or null when the
  /// user has already seen [version] or the changelog has no entry for it.
  Future<ChangelogEntry?> pendingWhatsNew(String version) async {
    final lastSeen = await StorageService().loadString(AppConstants.keyLastSeenChangelogVersion);
    if (lastSeen == version) return null;
    return getForVersion(version);
  }

  /// Records [version] as seen so the dialog is not shown again for it.
  Future<void> markSeen(String version) {
    return StorageService().saveString(AppConstants.keyLastSeenChangelogVersion, version);
  }

  /// Parses CHANGELOG.md markdown into entries. Empty sections are dropped.
  static List<ChangelogEntry> parse(String markdown) {
    final entries = <ChangelogEntry>[];
    Map<String, List<String>>? sections;
    String? section;

    for (final rawLine in markdown.split('\n')) {
      final line = rawLine.trimRight();

      final versionMatch = _versionHeading.firstMatch(line);
      if (versionMatch != null) {
        sections = <String, List<String>>{};
        section = null;
        entries.add(ChangelogEntry(version: versionMatch.group(1)!.trim(), sections: sections));
        continue;
      }
      if (sections == null) continue;

      final sectionMatch = _sectionHeading.firstMatch(line);
      if (sectionMatch != null) {
        section = sectionMatch.group(1);
        continue;
      }

      final bulletMatch = _bullet.firstMatch(line);
      if (bulletMatch != null && section != null) {
        sections.putIfAbsent(section, () => []).add(bulletMatch.group(1)!);
      }
    }
    return entries;
  }
}
