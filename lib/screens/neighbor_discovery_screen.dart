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
import '../services/demo_api_service.dart';
import '../widgets/app_drawer.dart';
import '../widgets/common/error_display.dart';

/// Screen displaying discovered neighbors from OPNsense
class NeighborDiscoveryScreen extends StatefulWidget {
  const NeighborDiscoveryScreen({super.key});

  @override
  State<NeighborDiscoveryScreen> createState() => _NeighborDiscoveryScreenState();
}

class _NeighborDiscoveryScreenState extends State<NeighborDiscoveryScreen> {
  List<Neighbor> _neighbors = [];
  bool _isLoading = true;
  String? _errorMessage;
  String? _serviceStatus;
  ServiceWidget? _serviceWidget;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  int _rowCount = 50;
  int _currentPage = 1;
  int _totalResults = 0;

  @override
  void initState() {
    super.initState();
    _checkServiceStatus();
    _loadNeighbors();
  }

  /// Check if the host discovery service is running
  Future<void> _checkServiceStatus() async {
    try {
      final demoApiService = context.read<DemoApiService>();
      final status = await demoApiService.checkNeighborDiscoveryStatus();
      
      if (mounted) {
        setState(() {
          _serviceStatus = status.status;
          _serviceWidget = status.widget;
        });
      }
    } catch (e) {
      // Service status check failed, but don't block the UI
      if (mounted) {
        setState(() {
          _serviceStatus = 'unknown';
          _serviceWidget = null;
        });
      }
    }
  }

  /// Load the neighbors list
  Future<void> _loadNeighbors() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final demoApiService = context.read<DemoApiService>();
      final response = await demoApiService.getNeighbors(
        current: _currentPage,
        rowCount: _rowCount,
        searchPhrase: _searchQuery.isNotEmpty ? _searchQuery : null,
      );
      
      if (mounted) {
        setState(() {
          _neighbors = response.rows;
          _totalResults = response.total;
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

  /// Start the neighbor discovery service
  Future<void> _startService() async {
    try {
      final demoApiService = context.read<DemoApiService>();
      
      // Show loading indicator
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Starting service...')),
        );
      }
      
      await demoApiService.startNeighborDiscoveryService();
      
      // Refresh status
      await _checkServiceStatus();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Service started successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to start service: ${e.toString()}')),
        );
      }
    }
  }

  /// Stop the neighbor discovery service
  Future<void> _stopService() async {
    try {
      final demoApiService = context.read<DemoApiService>();
      
      // Show loading indicator
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Stopping service...')),
        );
      }
      
      await demoApiService.stopNeighborDiscoveryService();
      
      // Refresh status
      await _checkServiceStatus();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Service stopped successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to stop service: ${e.toString()}')),
        );
      }
    }
  }

  /// Restart the neighbor discovery service
  Future<void> _restartService() async {
    try {
      final demoApiService = context.read<DemoApiService>();
      
      // Show loading indicator
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Restarting service...')),
        );
      }
      
      await demoApiService.restartNeighborDiscoveryService();
      
      // Refresh status
      await _checkServiceStatus();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Service restarted successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to restart service: ${e.toString()}')),
        );
      }
    }
  }

  /// Build the main content
  Widget _buildContent() {
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
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                          _currentPage = 1;
                        });
                        _loadNeighbors();
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onChanged: (value) {
              setState(() => _searchQuery = value);
            },
            onSubmitted: (_) {
              setState(() => _currentPage = 1);
              _loadNeighbors();
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
                value: _rowCount,
                items: const [
                  DropdownMenuItem(value: 50, child: Text('50')),
                  DropdownMenuItem(value: 100, child: Text('100')),
                  DropdownMenuItem(value: 200, child: Text('200')),
                  DropdownMenuItem(value: 500, child: Text('500')),
                  DropdownMenuItem(value: 1000, child: Text('1000')),
                  DropdownMenuItem(value: 9999, child: Text('All')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _rowCount = value;
                      _currentPage = 1;
                    });
                    _loadNeighbors();
                  }
                },
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Results list
        Expanded(
          child: _neighbors.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.devices_other, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'No neighbors discovered',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadNeighbors,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _neighbors.length,
                    itemBuilder: (context, index) {
                      return _buildNeighborCard(_neighbors[index]);
                    },
                  ),
                ),
        ),
        
        // Pagination controls
        _buildPaginationControls(),
      ],
    );
  }

  /// Build a card for each neighbor
  Widget _buildNeighborCard(Neighbor neighbor) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IP Address (prominent)
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
            
            // MAC Address
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
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            // Interface name
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
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
            
            // Organization name (if available)
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
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
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
            
            // First seen timestamp
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  size: 14,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 6),
                Text(
                  'First seen: ${_formatLastSeen(neighbor.firstSeen)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                ),
              ],
            ),
            
            const SizedBox(height: 4),
            
            // Last seen timestamp
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 14,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 6),
                Text(
                  'Last seen: ${_formatLastSeen(neighbor.lastSeen)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
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

  /// Build pagination controls
  Widget _buildPaginationControls() {
    final totalPages = (_totalResults / _rowCount).ceil();
    
    if (totalPages <= 1) {
      return const SizedBox.shrink();
    }
    
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.dividerColor,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous button
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: _currentPage > 1
                ? () {
                    setState(() => _currentPage--);
                    _loadNeighbors();
                  }
                : null,
          ),
          
          // Page info
          Text(
            'Page $_currentPage of $totalPages ($_totalResults total)',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          
          // Next button
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: _currentPage < totalPages
                ? () {
                    setState(() => _currentPage++);
                    _loadNeighbors();
                  }
                : null,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Format the last seen timestamp to a human-readable format
  String _formatLastSeen(String timestamp) {
    try {
      // Parse the timestamp (assuming Unix timestamp in seconds)
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
      // If parsing fails, return the raw timestamp
      return timestamp;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Neighbor Discovery'),
        actions: [
          // Service control buttons
          if (_serviceStatus == 'running') ...[
            IconButton(
              icon: const Icon(Icons.stop),
              tooltip: _serviceWidget?.captionStop ?? 'Stop',
              onPressed: _stopService,
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: _serviceWidget?.captionRestart ?? 'Restart',
              onPressed: _restartService,
            ),
          ],
          if (_serviceStatus != 'running' && _serviceStatus != null)
            IconButton(
              icon: const Icon(Icons.play_arrow),
              tooltip: _serviceWidget?.captionStart ?? 'Start',
              onPressed: _startService,
            ),
          // Show service status indicator if available
          if (_serviceStatus != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Chip(
                label: Text(
                  _serviceStatus!,
                  style: const TextStyle(fontSize: 12),
                ),
                backgroundColor: _serviceStatus == 'running'
                    ? Colors.green.shade100
                    : _serviceStatus == 'stopped'
                        ? Colors.orange.shade100
                        : Colors.grey.shade200,
                labelStyle: TextStyle(
                  color: _serviceStatus == 'running'
                      ? Colors.green.shade900
                      : _serviceStatus == 'stopped'
                          ? Colors.orange.shade900
                          : Colors.grey.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      drawer: const AppDrawer(currentRoute: '/neighbor_discovery'),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? ErrorDisplay(
                  message: _errorMessage!,
                  onRetry: _loadNeighbors,
                )
              : _buildContent(),
    );
  }
}


