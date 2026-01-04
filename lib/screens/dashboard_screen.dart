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
import '../services/opnsense_api_service.dart';
import '../utils/constants.dart';
import '../utils/formatters.dart';
import '../widgets/stat_card.dart';
import '../widgets/app_drawer.dart';

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
    _loadDashboardData();
    _startAutoRefresh();
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
      final apiService = context.read<OPNsenseApiService>();
      
      // Load all data in parallel for faster loading
      final results = await Future.wait([
        apiService.getSystemInfo(),
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
      final apiService = context.read<OPNsenseApiService>();
      final services = await apiService.getServices();
      return {'services': services};
    } catch (e) {
      return {'services': []};
    }
  }

  Future<List<Map<String, dynamic>>> _loadGateways() async {
    try {
      final apiService = context.read<OPNsenseApiService>();
      final gateways = await apiService.getGateways();
      return gateways.cast<Map<String, dynamic>>();
    } catch (e) {
      return [];
    }
  }

  Future<void> _controlService(String serviceId, String action, String serviceName) async {
    // Show confirmation dialog
    final actionText = action[0].toUpperCase() + action.substring(1);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$actionText Service'),
        content: Text('Are you sure you want to $action "$serviceName"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
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
      final apiService = context.read<OPNsenseApiService>();
      
      // Show loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$actionText $serviceName...'),
          duration: const Duration(seconds: 2),
        ),
      );

      final success = await apiService.controlService(serviceId, action);

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Successfully ${action}ed $serviceName'),
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
              content: Text('Failed to $action $serviceName'),
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
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _loadDashboardData,
            tooltip: 'Refresh',
          ),
        ],
      ),
      drawer: AppDrawer(
        currentRoute: 'dashboard',
        systemInfo: _systemInfo,
      ),
      body: RefreshIndicator(
        onRefresh: _loadDashboardData,
        child: _buildBody(),
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
              'Error loading system information',
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
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(AppConstants.standardPadding),
      children: [
        // Resource Usage Section
        Text(
          'Resource Usage',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        
        _buildResourceCards(),
        const SizedBox(height: 24),
        
        // Services Section
        Text(
          'Services',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        
        _buildServicesWidget(),
        const SizedBox(height: 24),
        
        // Gateways Section
        Text(
          'Gateways',
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

    return Column(
      children: [
        // CPU Usage
        ProgressStatCard(
          title: 'CPU Usage',
          value: Formatters.formatPercentage(_systemInfo!.cpuUsage),
          progress: _systemInfo!.cpuUsage / 100,
          icon: Icons.speed,
        ),
        const SizedBox(height: 12),
        
        // Memory Usage
        ProgressStatCard(
          title: 'Memory Usage',
          value: '${Formatters.formatMemoryGB(_systemInfo!.memoryUsed)} / '
              '${Formatters.formatMemoryGB(_systemInfo!.memoryTotal)}',
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
            title: 'Disk Usage',
            value: '${Formatters.formatMemoryGB(_systemInfo!.diskUsed)} / '
                '${Formatters.formatMemoryGB(_systemInfo!.diskTotal)}',
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
    final services = _servicesData['services'] as List<dynamic>? ?? [];
    
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.apps),
            title: const Text('Services'),
            subtitle: Text('${services.length} services'),
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
    // Handle different possible field names from OPNsense API
    final name = (service['name'] ?? service['description'] ?? service['id'] ?? 'Unknown').toString();
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
      subtitle: Text(isRunning ? 'Running' : 'Stopped'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(
              isRunning ? Icons.stop : Icons.play_arrow,
              size: 20,
            ),
            onPressed: () => _controlService(serviceId, isRunning ? 'stop' : 'start', name),
            tooltip: isRunning ? 'Stop' : 'Start',
          ),
          IconButton(
            icon: const Icon(Icons.refresh, size: 20),
            onPressed: () => _controlService(serviceId, 'restart', name),
            tooltip: 'Restart',
          ),
        ],
      ),
    );
  }

  Widget _buildGatewaysWidget() {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.router),
            title: const Text('Gateways'),
            subtitle: Text('${_gateways.length} gateways'),
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
    // Handle different possible field names from OPNsense API
    final name = (gateway['name'] ?? gateway['gateway'] ?? gateway['interface'] ?? 'Unknown').toString();
    final address = (gateway['address'] ?? gateway['gateway_ip'] ?? gateway['ip'] ?? 'N/A').toString();
    final status = (gateway['status'] ?? gateway['status_translated'] ?? 'unknown').toString().toLowerCase();
    final delay = (gateway['delay'] ?? gateway['rtt'] ?? gateway['latency'] ?? 'N/A').toString();
    final loss = (gateway['loss'] ?? gateway['loss_percentage'] ?? gateway['packet_loss'] ?? 'N/A').toString();
    
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

