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
import '../models/system_info.dart';
import '../services/demo_api_service.dart';
import '../widgets/app_drawer.dart';
import '../l10n/app_localizations.dart';
import 'settings/general_settings_screen.dart';
import 'settings/security_settings_screen.dart';
import 'settings/profile_management_screen.dart';
import 'settings/profile_import_export_screen.dart';

/// Main Settings screen with tabs for different settings categories
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  SystemInfo? _systemInfo;
  int _profilesTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadSystemInfo();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadSystemInfo() async {
    try {
      final demoApiService = context.read<DemoApiService>();
      final systemInfo = await demoApiService.getSystemInfo();
      if (mounted) {
        setState(() {
          _systemInfo = systemInfo;
        });
      }
    } catch (e) {
      // Silently fail - system info is optional for drawer
    }
  }

  void _onProfilesChanged() {
    // Trigger a rebuild of the profiles tab
    setState(() {
      _profilesTabIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              text: l10n.general,
              icon: const Icon(Icons.settings),
            ),
            Tab(
              text: l10n.profiles,
              icon: const Icon(Icons.dns),
            ),
          ],
        ),
      ),
      drawer: AppDrawer(
        currentRoute: 'settings',
        systemInfo: _systemInfo,
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _GeneralAndSecurityTab(),
          _ProfilesTab(
            key: ValueKey(_profilesTabIndex),
            onProfilesChanged: _onProfilesChanged,
          ),
        ],
      ),
    );
  }
}

/// Combined General and Security settings tab
class _GeneralAndSecurityTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const GeneralSettingsScreen(),
          const SizedBox(height: 16),
          const SecuritySettingsScreen(),
        ],
      ),
    );
  }
}

/// Combined Profiles and Import/Export tab
class _ProfilesTab extends StatelessWidget {
  final VoidCallback onProfilesChanged;

  const _ProfilesTab({
    super.key,
    required this.onProfilesChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(text: 'Manage Profiles'),
              Tab(text: 'Import/Export'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                ProfileManagementScreen(),
                ProfileImportExportScreen(
                  onProfilesChanged: onProfilesChanged,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


