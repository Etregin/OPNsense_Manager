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
import '../services/opnsense_api_service.dart';
import '../utils/constants.dart';
import '../utils/formatters.dart';
import '../widgets/app_drawer.dart';

/// System information screen showing detailed system data
class SystemInfoScreen extends StatefulWidget {
  const SystemInfoScreen({super.key});

  @override
  State<SystemInfoScreen> createState() => _SystemInfoScreenState();
}

class _SystemInfoScreenState extends State<SystemInfoScreen> {
  SystemInfo? _systemInfo;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadSystemInfo();
  }

  Future<void> _loadSystemInfo() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final apiService = context.read<OPNsenseApiService>();
      final systemInfo = await apiService.getSystemInfo();

      if (mounted) {
        setState(() {
          _systemInfo = systemInfo;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('System Information'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _loadSystemInfo,
            tooltip: 'Refresh',
          ),
        ],
      ),
      drawer: AppDrawer(
        currentRoute: 'system_info',
        systemInfo: _systemInfo,
      ),
      body: RefreshIndicator(
        onRefresh: _loadSystemInfo,
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
              onPressed: _loadSystemInfo,
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
        _buildInfoCard(
          'System Information',
          [
            _buildInfoRow(Icons.computer, 'Hostname', _systemInfo!.hostname),
            _buildInfoRow(Icons.dns, 'Type', _systemInfo!.type),
            _buildInfoRow(Icons.info_outline, 'Version', _systemInfo!.version),
            _buildInfoRow(Icons.architecture, 'Architecture', _systemInfo!.architecture),
            _buildInfoRow(Icons.memory, 'Platform', _systemInfo!.platform),
            if (_systemInfo!.commit.isNotEmpty)
              _buildInfoRow(Icons.commit, 'Commit', _systemInfo!.commit),
            if (_systemInfo!.mirror.isNotEmpty)
              _buildInfoRow(Icons.cloud, 'Mirror', _systemInfo!.mirror),
            if (_systemInfo!.repositories.isNotEmpty)
              _buildInfoRow(Icons.source, 'Repositories', _systemInfo!.repositories),
            if (_systemInfo!.updatedOn != null && _systemInfo!.updatedOn!.isNotEmpty)
              _buildInfoRow(Icons.update, 'Updated on', _systemInfo!.updatedOn!),
            _buildInfoRow(
              Icons.access_time,
              'Uptime',
              Formatters.formatUptime(_systemInfo!.uptime),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.standardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            ...children.map((child) {
              final index = children.indexOf(child);
              return Column(
                children: [
                  if (index > 0) const Divider(),
                  child,
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

