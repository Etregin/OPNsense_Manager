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

/// One version block from CHANGELOG.md (e.g. `## [1.8.2]`).
class ChangelogEntry {
  /// Placeholder heading used in CHANGELOG.md for the not-yet-released block.
  static const String unreleasedLabel = 'new_version';

  /// Version label exactly as written between the brackets.
  final String version;

  /// Section title (Added, Changed, Fixed, ...) mapped to its bullet items,
  /// in the order they appear in the file.
  final Map<String, List<String>> sections;

  const ChangelogEntry({required this.version, required this.sections});

  bool get isUnreleased => version == unreleasedLabel;
}
