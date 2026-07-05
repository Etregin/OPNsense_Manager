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
import '../models/neighbor.dart';
import '../utils/constants.dart';
import '../services/demo_api_service.dart';
import '../utils/snackbar_helper.dart';
import '../viewmodels/neighbor_discovery_view_model.dart';
import '../widgets/app_drawer.dart';
import '../widgets/common/error_display.dart';
import '../widgets/common/empty_state_widget.dart';

/// Screen displaying discovered neighbors from OPNsense
class NeighborDiscoveryScreen extends StatefulWidget {
  const NeighborDiscoveryScreen({super.key});

  @override
  State<NeighborDiscoveryScreen> createState() =>
      _NeighborDiscoveryScreenState();
}

class _NeighborDiscoveryScreenState extends State<NeighborDiscoveryScreen> {
  late NeighborDiscoveryViewModel _viewModel;
  bool _isInitialized = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final apiService = context.read<DemoApiService>();
      _viewModel = NeighborDiscoveryViewModel(apiService);
      _isInitialized = true;
      _viewModel.checkServiceStatus();
      _viewModel.loadItems();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _startService() async {
    SnackBarHelper.showInfo(context, 'Starting service...');
    try {
      await _viewModel.startService();
      if (mounted) {
        SnackBarHelper.showInfo(context, 'Service started successfully');
      }
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showInfo(context, 'Failed to start service: ${e.toString()}');
      }
    }
  }

  Future<void> _stopService() async {
    SnackBarHelper.showInfo(context, 'Stopping service...');
    try {
      await _viewModel.stopService();
      if (mounted) {
        SnackBarHelper.showInfo(context, 'Service stopped successfully');
      }
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showInfo(context, 'Failed to stop service: ${e.toString()}');
      }
    }
  }

  Future<void> _restartService() async {
    SnackBarHelper.showInfo(context, 'Restarting service...');
    try {
      await _viewModel.restartService();
      if (mounted) {
        SnackBarHelper.showInfo(context, 'Service restarted successfully');
      }
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showInfo(
            context, 'Failed to restart service: ${e.toString()}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        final serviceStatus = _viewModel.serviceStatus;
        final serviceWidget = _viewModel.serviceWidget;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Neighbor Discovery'),
            actions: [
              if (serviceStatus == 'running') ...[
                IconButton(
                  icon: const Icon(Icons.stop),
                  tooltip: serviceWidget?.captionStop ?? 'Stop',
                  onPressed: _stopService,
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  tooltip: serviceWidget?.captionRestart ?? 'Restart',
                  onPressed: _restartService,
                ),
              ],
              if (serviceStatus != 'running' && serviceStatus != null)
                IconButton(
                  icon: const Icon(Icons.play_arrow),
                  tooltip: serviceWidget?.captionStart ?? 'Start',
                  onPressed: _startService,
                ),
              if (serviceStatus != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Chip(
                    label: Text(
                      serviceStatus,
                      style: const TextStyle(fontSize: 12),
                    ),
                    backgroundColor: serviceStatus == 'running'
                        ? AppColors.success.withValues(alpha: 0.15)
                        : serviceStatus == 'stopped'
                            ? AppColors.warning.withValues(alpha: 0.15)
                            : AppColors.surfaceLight,
                    labelStyle: TextStyle(
                      color: serviceStatus == 'running'
                          ? AppColors.success
                          : serviceStatus == 'stopped'
                              ? AppColors.warning
                              : AppColors.textSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          drawer: const AppDrawer(currentRoute: '/neighbor_discovery'),
          body: _viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : _viewModel.errorMessage != null
                  ? ErrorDisplay(
                      message: _viewModel.errorMessage!,
                      onRetry: _viewModel.loadItems,
                    )
                  : _buildContent(),
        );
      },
    );
  }

  Widget _buildContent() {
    final neighbors = _viewModel.items;

    return Column(
      children: [
        // Search field
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search by IP, MAC, or organization...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _viewModel.setSearchQuery('');
                        _viewModel.setPage(1);
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onChanged: (value) {
              _viewModel.setSearchQuery(value);
            },
            onSubmitted: (_) {
              _viewModel.setPage(1);
            },
          ),
        ),

        // Row count dropdown
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              const Text(
                'Rows per page: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              DropdownButton<int>(
                value: _viewModel.rowCount,
                items: const [
                  DropdownMenuItem(value: 50, child: Text('50')),
                  DropdownMenuItem(value: 100, child: Text('100')),
                  DropdownMenuItem(value: 200, child: Text('200')),
                  DropdownMenuItem(value: 500, child: Text('500')),
                  DropdownMenuItem(value: 1000, child: Text('1000')),
                  DropdownMenuItem(value: AppConstants.allRowsSentinel, child: Text('All')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    _viewModel.setRowCount(value);
                  }
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Results list
        Expanded(
          child: neighbors.isEmpty
              ? const EmptyStateWidget(
                  icon: Icons.devices_other,
                  title: 'No neighbors discovered',
                )
              : RefreshIndicator(
                  onRefresh: _viewModel.loadItems,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: neighbors.length,
                    itemBuilder: (context, index) {
                      return _buildNeighborCard(neighbors[index]);
                    },
                  ),
                ),
        ),

        // Pagination controls
        _buildPaginationControls(),
      ],
    );
  }

  Widget _buildNeighborCard(Neighbor neighbor) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.devices,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    neighbor.ipAddress,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'monospace',
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.router,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Text(
                  neighbor.etherAddress,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontFamily: 'monospace',
                        color:
                            Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.settings_ethernet,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Text(
                  neighbor.interfaceName,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color:
                            Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
            if (neighbor.organizationName != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.business,
                    size: 16,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      neighbor.organizationName!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.schedule, size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 6),
                Text(
                  'First seen: ${_formatLastSeen(neighbor.firstSeen)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.access_time, size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 6),
                Text(
                  'Last seen: ${_formatLastSeen(neighbor.lastSeen)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaginationControls() {
    final totalResults = _viewModel.totalResults;
    final rowCount = _viewModel.rowCount;
    final currentPage = _viewModel.currentPage;
    final totalPages = (totalResults / rowCount).ceil();

    if (totalPages <= 1) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(color: theme.dividerColor),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed:
                currentPage > 1 ? () => _viewModel.setPage(currentPage - 1) : null,
          ),
          Text(
            'Page $currentPage of $totalPages ($totalResults total)',
            style: theme.textTheme.bodyMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: currentPage < totalPages
                ? () => _viewModel.setPage(currentPage + 1)
                : null,
          ),
        ],
      ),
    );
  }

  String _formatLastSeen(String timestamp) {
    try {
      final lastSeenTime = DateTime.fromMillisecondsSinceEpoch(
        int.parse(timestamp) * 1000,
      );
      final now = DateTime.now();
      final difference = now.difference(lastSeenTime);

      if (difference.inDays > 0) {
        return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return timestamp;
    }
  }
}
