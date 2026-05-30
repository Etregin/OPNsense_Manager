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
import '../../services/storage_service.dart';
import '../../utils/constants.dart';
import '../../widgets/settings/settings_section.dart';
import '../../l10n/app_localizations.dart';

/// Screen for general app settings (theme, language)
class GeneralSettingsScreen extends StatefulWidget {
  const GeneralSettingsScreen({super.key});

  @override
  State<GeneralSettingsScreen> createState() => _GeneralSettingsScreenState();
}

class _GeneralSettingsScreenState extends State<GeneralSettingsScreen> {
  String _themeMode = 'system'; // 'system', 'light', or 'dark'
  String? _locale; // null means system default

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final themeMode = await StorageService().loadString('theme_mode') ?? 'system';
    final locale = await StorageService().loadString('locale');
    
    if (mounted) {
      setState(() {
        _themeMode = themeMode;
        _locale = locale;
      });
    }
  }

  void _updateThemeMode(String? value) {
    if (value == null) return;
    setState(() {
      _themeMode = value;
    });
    final updateTheme = context.read<Function(String)>();
    updateTheme(value);
  }

  void _updateLocale(String? value) {
    setState(() {
      _locale = value;
    });
    final updateLocale = context.read<Function(String?)>();
    updateLocale(value);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppConstants.standardPadding),
      children: [
        SettingsSection(
          title: l10n.appearance,
          icon: Icons.palette,
          children: [
            ListTile(
              leading: Icon(
                _themeMode == 'dark'
                    ? Icons.dark_mode
                    : _themeMode == 'light'
                        ? Icons.light_mode
                        : Icons.brightness_auto,
                color: Theme.of(context).primaryColor,
              ),
              title: Text(l10n.theme),
              subtitle: Text(
                _themeMode == 'system'
                    ? l10n.systemDefault
                    : _themeMode == 'light'
                        ? l10n.lightMode
                        : l10n.darkMode,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: SizedBox(
                width: 140,
                child: DropdownButton<String>(
                  value: _themeMode,
                  underline: const SizedBox(),
                  isExpanded: true,
                  items: [
                    DropdownMenuItem(
                      value: 'system',
                      child: Text(
                        l10n.systemDefault,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'light',
                      child: Text(
                        l10n.lightMode,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'dark',
                      child: Text(
                        l10n.darkMode,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                  onChanged: _updateThemeMode,
                ),
              ),
            ),
            const Divider(),
            ListTile(
              leading: Icon(
                Icons.language,
                color: Theme.of(context).primaryColor,
              ),
              title: Text(l10n.language),
              subtitle: Text(
                _locale == null
                    ? l10n.systemDefault
                    : (AppConstants.supportedLanguages[_locale] ?? _locale!),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: SizedBox(
                width: 140,
                child: DropdownButton<String?>(
                  value: _locale,
                  underline: const SizedBox(),
                  isExpanded: true,
                  items: [
                    DropdownMenuItem(
                      value: null,
                      child: Text(
                        l10n.systemDefault,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    ...AppConstants.supportedLanguages.entries.map(
                      (entry) => DropdownMenuItem(
                        value: entry.key,
                        child: Text(
                          entry.value,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                  onChanged: _updateLocale,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}


