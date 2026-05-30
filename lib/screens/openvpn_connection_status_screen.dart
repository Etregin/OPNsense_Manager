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
import '../l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../models/system_info.dart';
import '../services/demo_api_service.dart';
import '../widgets/app_drawer.dart';
import 'openvpn_sessions_tab.dart';
import 'openvpn_routes_tab.dart';

/// Screen for managing OpenVPN connection status with sessions and routes
class OpenvpnConnectionStatusScreen extends StatefulWidget {
  const OpenvpnConnectionStatusScreen({super.key});

  @override
  State<OpenvpnConnectionStatusScreen> createState() => _OpenvpnConnectionStatusScreenState();
}

class _OpenvpnConnectionStatusScreenState extends State<OpenvpnConnectionStatusScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late DemoApiService _apiService;
  SystemInfo? _systemInfo;
  bool _isInitialized = false;
  
  // Callbacks to refresh child tabs
  VoidCallback? _refreshSessionsTab;
  VoidCallback? _refreshRoutesTab;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _apiService = context.read<DemoApiService>();
      _isInitialized = true;
      _loadSystemInfo();
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    // Trigger rebuild when tab changes
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _loadSystemInfo() async {
    try {
      final apiService = context.read<DemoApiService>();
      final systemInfo = await apiService.getSystemInfo();

      if (mounted) {
        setState(() {
          _systemInfo = systemInfo;
        });
      }
    } catch (e) {
      // Silently fail - system info is optional for drawer
    }
  }
  
  void _refreshCurrentTab() {
    if (_tabController.index == 0) {
      _refreshSessionsTab?.call();
    } else {
      _refreshRoutesTab?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.openvpnConnectionStatus),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              text: l10n.sessions,
              icon: const Icon(Icons.connect_without_contact),
            ),
            Tab(
              text: l10n.routes,
              icon: const Icon(Icons.route),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshCurrentTab,
            tooltip: l10n.refresh,
          ),
        ],
      ),
      drawer: AppDrawer(
        currentRoute: 'openvpn_connection_status',
        systemInfo: _systemInfo,
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          OpenvpnSessionsTab(
            apiService: _apiService,
            onRegisterRefresh: (callback) => _refreshSessionsTab = callback,
          ),
          OpenvpnRoutesTab(
            apiService: _apiService,
            onRegisterRefresh: (callback) => _refreshRoutesTab = callback,
          ),
        ],
      ),
    );
  }
}


