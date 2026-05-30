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
import 'openvpn_instances_list_screen.dart';
import 'openvpn_static_keys_list_screen.dart';
import 'openvpn_instance_form_screen.dart';
import 'openvpn_static_key_form_screen.dart';

/// Screen for managing OpenVPN instances and static keys
class OpenvpnInstancesScreen extends StatefulWidget {
  const OpenvpnInstancesScreen({super.key});

  @override
  State<OpenvpnInstancesScreen> createState() => _OpenvpnInstancesScreenState();
}

class _OpenvpnInstancesScreenState extends State<OpenvpnInstancesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late DemoApiService _apiService;
  SystemInfo? _systemInfo;
  bool _isInitialized = false;
  
  // Callbacks to refresh child screens
  VoidCallback? _refreshInstancesList;
  VoidCallback? _refreshStaticKeysList;

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
    // Trigger rebuild when tab changes to update FAB
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

  Future<void> _onAddInstance() async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => const OpenvpnInstanceFormScreen(),
      ),
    );
    
    // Refresh list if instance was added
    if (result == true && mounted) {
      _refreshInstancesList?.call();
      _loadSystemInfo();
    }
  }

  Future<void> _onAddStaticKey() async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => const OpenvpnStaticKeyFormScreen(),
      ),
    );
    
    // Refresh list if static key was added
    if (result == true && mounted) {
      _refreshStaticKeysList?.call();
      _loadSystemInfo();
    }
  }
  
  void _refreshCurrentTab() {
    if (_tabController.index == 0) {
      _refreshInstancesList?.call();
    } else {
      _refreshStaticKeysList?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.openvpnInstances),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              text: l10n.instances,
              icon: const Icon(Icons.vpn_lock),
            ),
            Tab(
              text: l10n.staticKeys,
              icon: const Icon(Icons.vpn_key),
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
        currentRoute: 'openvpn_instances',
        systemInfo: _systemInfo,
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          OpenvpnInstancesListScreen(
            apiService: _apiService,
            onRefresh: _loadSystemInfo,
            onRegisterRefresh: (callback) => _refreshInstancesList = callback,
          ),
          OpenvpnStaticKeysListScreen(
            apiService: _apiService,
            onRefresh: _loadSystemInfo,
            onRegisterRefresh: (callback) => _refreshStaticKeysList = callback,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _tabController.index == 0 ? _onAddInstance : _onAddStaticKey,
        icon: const Icon(Icons.add),
        label: Text(_tabController.index == 0 ? l10n.addInstance : l10n.addStaticKey),
        tooltip: _tabController.index == 0 ? l10n.addOpenVpnInstance : l10n.addStaticKeyTooltip,
      ),
    );
  }

}


