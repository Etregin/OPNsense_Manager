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
import '../utils/constants.dart';
import '../utils/formatters.dart';
import '../widgets/stat_card.dart';
import '../widgets/app_drawer.dart';
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
  bool _servicesExpanded = false;
  bool _gatewaysExpanded = false;
  String? _errorMessage;
  Timer? _refreshTimer;

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
      
      // Load all data in parallel for faster loading
      final results = await Future.wait([
        demoApiService.getSystemInfo(),
        _loadServices(),
        _loadGateways(),
      ]);

      if (mounted) {
        setState(() {
          _systemInfo = results[0] as SystemInfo;
          _servicesData = results[1] as Map<String, dynamic>;
          _gateways = results[2] as List<Map<String, dynamic>>;
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

  Future<Map<String, dynamic>> _loadServices() async {
    try {
      final demoApiService = context.read<DemoApiService>();
      final services = await demoApiService.getServices();
      return {'services': services};
    } catch (e) {
      return {'services': []};
    }
  }

  Future<List<Map<String, dynamic>>> _loadGateways() async {
    try {
      final demoApiService = context.read<DemoApiService>();
      final gateways = await demoApiService.getGateways();
      return gateways.cast<Map<String, dynamic>>();
    } catch (e) {
      return [];
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

    final l10n = AppLocalizations.of(context)!;
    return ListView(
      padding: const EdgeInsets.all(AppConstants.standardPadding),
      children: [
        // Resource Usage Section
        Text(
          '${l10n.cpuUsage} / ${l10n.memoryUsage}',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        
        _buildResourceCards(),
        const SizedBox(height: 24),
        
        // Services Section
        Text(
          l10n.services,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        
        _buildServicesWidget(),
        const SizedBox(height: 24),
        
        // Gateways Section
        Text(
          l10n.gateways,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        
        _buildGatewaysWidget(),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildResourceCards() {
    if (_systemInfo == null) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        // CPU Usage
        ProgressStatCard(
          title: l10n.cpuUsage,
          value: Formatters.formatPercentage(_systemInfo!.cpuUsage),
          progress: _systemInfo!.cpuUsage / 100,
          icon: Icons.speed,
        ),
        const SizedBox(height: 12),
        
        // Memory Usage
        ProgressStatCard(
          title: l10n.memoryUsage,
          value: '${Formatters.formatMemoryGB(_systemInfo!.memoryUsed, context)} / '
              '${Formatters.formatMemoryGB(_systemInfo!.memoryTotal, context)}',
          progress: _systemInfo!.memoryUsagePercentage / 100,
          icon: Icons.memory,
          subtitle: Formatters.formatPercentage(
            _systemInfo!.memoryUsagePercentage,
          ),
        ),
        const SizedBox(height: 12),
        
        // Disk Usage
        if (_systemInfo!.diskTotal > 0)
          ProgressStatCard(
            title: l10n.diskUsage,
            value: '${Formatters.formatMemoryGB(_systemInfo!.diskUsed, context)} / '
                '${Formatters.formatMemoryGB(_systemInfo!.diskTotal, context)}',
            progress: _systemInfo!.diskUsagePercentage / 100,
            icon: Icons.storage,
            subtitle: Formatters.formatPercentage(
              _systemInfo!.diskUsagePercentage,
            ),
          ),
      ],
    );
  }



  Widget _buildServicesWidget() {
    final l10n = AppLocalizations.of(context)!;
    final services = _servicesData['services'] as List<dynamic>? ?? [];
    
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.apps),
            title: Text(l10n.services),
            subtitle: Text('${services.length} ${l10n.services}'),
            trailing: Icon(
              _servicesExpanded ? Icons.expand_less : Icons.expand_more,
            ),
            onTap: () {
              setState(() {
                _servicesExpanded = !_servicesExpanded;
              });
            },
          ),
          if (_servicesExpanded) ...[
            const Divider(height: 1),
            ...services.map((service) => _buildServiceTile(service)),
          ],
        ],
      ),
    );
  }

  Widget _buildServiceTile(Map<String, dynamic> service) {
    final l10n = AppLocalizations.of(context)!;
    // Handle different possible field names from OPNsense API
    final name = (service['name'] ?? service['description'] ?? service['id'] ?? l10n.unknown).toString();
    final serviceId = (service['id'] ?? service['name'] ?? name).toString();
    final status = (service['status'] ?? service['running'] ?? 'unknown').toString();
    final isRunning = status.toLowerCase() == 'running' ||
                      status == '1' ||
                      service['running'] == '1' ||
                      service['running'] == true;

    return ListTile(
      dense: true,
      leading: Icon(
        isRunning ? Icons.check_circle : Icons.cancel,
        color: isRunning ? Colors.green : Colors.red,
        size: 20,
      ),
      title: Text(name),
      subtitle: Text(isRunning ? l10n.running : l10n.stopped),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(
              isRunning ? Icons.stop : Icons.play_arrow,
              size: 20,
            ),
            onPressed: () => _controlService(serviceId, isRunning ? 'stop' : 'start', name),
            tooltip: isRunning ? l10n.stop : l10n.start,
          ),
          IconButton(
            icon: const Icon(Icons.refresh, size: 20),
            onPressed: () => _controlService(serviceId, 'restart', name),
            tooltip: l10n.restart,
          ),
        ],
      ),
    );
  }

  Widget _buildGatewaysWidget() {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.router),
            title: Text(l10n.gateways),
            subtitle: Text('${_gateways.length} ${l10n.gateways}'),
            trailing: Icon(
              _gatewaysExpanded ? Icons.expand_less : Icons.expand_more,
            ),
            onTap: () {
              setState(() {
                _gatewaysExpanded = !_gatewaysExpanded;
              });
            },
          ),
          if (_gatewaysExpanded) ...[
            const Divider(height: 1),
            ..._gateways.map((gateway) => _buildGatewayTile(gateway)),
          ],
        ],
      ),
    );
  }

  Widget _buildGatewayTile(Map<String, dynamic> gateway) {
    final l10n = AppLocalizations.of(context)!;
    // Handle different possible field names from OPNsense API
    final name = (gateway['name'] ?? gateway['gateway'] ?? gateway['interface'] ?? l10n.unknown).toString();
    final address = (gateway['address'] ?? gateway['gateway_ip'] ?? gateway['ip'] ?? l10n.notAvailable).toString();
    final status = (gateway['status'] ?? gateway['status_translated'] ?? l10n.unknown).toString().toLowerCase();
    final delay = (gateway['delay'] ?? gateway['rtt'] ?? gateway['latency'] ?? l10n.notAvailable).toString();
    final loss = (gateway['loss'] ?? gateway['loss_percentage'] ?? gateway['packet_loss'] ?? l10n.notAvailable).toString();
    
    // Check various status indicators
    final isOnline = status.contains('online') ||
                     status.contains('up') ||
                     status == 'none' ||
                     gateway['status_translated']?.toString().toLowerCase().contains('online') == true;

    return ListTile(
      dense: true,
      leading: Icon(
        isOnline ? Icons.check_circle : Icons.error,
        color: isOnline ? Colors.green : Colors.red,
        size: 20,
      ),
      title: Text(name),
      subtitle: Text(address),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            delay.toString(),
            style: TextStyle(
              fontSize: 12,
              color: isOnline ? Colors.green : Colors.red,
            ),
          ),
          Text(
            loss.toString(),
            style: TextStyle(
              fontSize: 12,
              color: isOnline ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}

