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


import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/system_info.dart';
import '../services/demo_api_service.dart';
import '../services/opnsense_api_service.dart';
import '../services/profile_service.dart';
import '../services/dashboard/dashboard_data_loader.dart';
import '../utils/constants.dart';
import '../widgets/app_drawer.dart';
import '../widgets/dashboard/resource_usage_section.dart';
import '../widgets/dashboard/services_section.dart';
import '../widgets/dashboard/gateways_section.dart';
import '../l10n/app_localizations.dart';

/// Main dashboard screen showing system overview
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  SystemInfo? _systemInfo;
  Map<String, dynamic> _servicesData = {};
  List<Map<String, dynamic>> _gateways = [];
  bool _isLoading = true;
  String? _errorMessage;
  Timer? _refreshTimer;
  DashboardDataLoader? _dataLoader;

  @override
  void initState() {
    super.initState();
    _initializeAndLoad();
    _startAutoRefresh();
  }

  Future<void> _initializeAndLoad() async {
    // Ensure API service is initialized with active profile
    final profileService = context.read<ProfileService>();
    final apiService = context.read<OPNsenseApiService>();
    
    final activeProfile = await profileService.getActiveProfile();
    if (activeProfile != null && !activeProfile.isDemo) {
      // Re-initialize API service to ensure it's ready
      apiService.init(activeProfile.toOPNsenseConfig());
    }
    
    await _loadDashboardData();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  void _startAutoRefresh() {
    _refreshTimer = Timer.periodic(
      const Duration(seconds: 30),
      (timer) {
        if (mounted) {
          _loadDashboardData();
        }
      },
    );
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final demoApiService = context.read<DemoApiService>();
      
      // Initialize data loader if not already done
      _dataLoader ??= DashboardDataLoader(demoApiService);
      
      // Load all data in parallel using the data loader
      final dashboardData = await _dataLoader!.loadAllData();

      if (mounted) {
        setState(() {
          _systemInfo = dashboardData.systemInfo;
          _servicesData = dashboardData.servicesData;
          _gateways = dashboardData.gateways;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _controlService(String serviceId, String action, String serviceName) async {
    final l10n = AppLocalizations.of(context)!;
    // Show confirmation dialog
    final actionText = action == 'start' ? l10n.start : action == 'stop' ? l10n.stop : l10n.restart;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.actionService(actionText)),
        content: Text(l10n.confirmServiceAction(actionText, serviceName)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: action == 'stop' ? Colors.red : null,
            ),
            child: Text(actionText),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    if (!mounted) return;

    try {
      // Get API service before async gap
      final demoApiService = context.read<DemoApiService>();
      
      // Show loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.actioningService(actionText, serviceName)),
          duration: const Duration(seconds: 2),
        ),
      );

      final success = await demoApiService.controlService(serviceId, action);

      if (mounted) {
        if (success) {
          final successMsg = action == 'start' ? l10n.serviceStarted :
                           action == 'stop' ? l10n.serviceStopped : l10n.serviceRestarted;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(successMsg),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
          // Reload dashboard to reflect changes
          await Future.delayed(const Duration(seconds: 1));
          if (mounted) {
            _loadDashboardData();
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.serviceActionFailed),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.error}: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final demoApiService = context.watch<DemoApiService>();
    final isDemoMode = demoApiService.isDemoMode;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _loadDashboardData,
            tooltip: l10n.refresh,
          ),
        ],
      ),
      drawer: AppDrawer(
        currentRoute: 'dashboard',
        systemInfo: _systemInfo,
      ),
      body: Column(
        children: [
          // Demo mode banner
          if (isDemoMode)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange.shade400, Colors.orange.shade600],
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.play_circle_outline, color: Colors.white),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Demo Mode - Showing sample data',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Icon(Icons.info_outline, color: Colors.white.withValues(alpha: 0.8), size: 20),
                ],
              ),
            ),
          // Main content
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadDashboardData,
              child: _buildBody(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading && _systemInfo == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_errorMessage != null && _systemInfo == null) {
      return _buildErrorState();
    }

    return ListView(
      padding: const EdgeInsets.all(AppConstants.standardPadding),
      children: [
        // Resource Usage Section
        if (_systemInfo != null)
          ResourceUsageSection(systemInfo: _systemInfo!),
        const SizedBox(height: 24),
        
        // Services Section
        ServicesSection(
          servicesData: _servicesData,
          onServiceControl: _controlService,
        ),
        const SizedBox(height: 24),
        
        // Gateways Section
        GatewaysSection(gateways: _gateways),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildErrorState() {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[300],
          ),
          const SizedBox(height: 16),
          Text(
            l10n.error,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _loadDashboardData,
            icon: const Icon(Icons.refresh),
            label: Text(l10n.retry),
          ),
        ],
      ),
    );
  }
}


