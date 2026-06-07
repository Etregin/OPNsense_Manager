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
import '../models/neighbor.dart';
import '../services/network/neighbor_discovery_service.dart';
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
  final NeighborDiscoveryService _service = NeighborDiscoveryService();

  @override
  void initState() {
    super.initState();
    _checkServiceStatus();
    _loadNeighbors();
  }

  /// Check if the host discovery service is running
  Future<void> _checkServiceStatus() async {
    try {
      final status = await _service.checkStatus();
      if (mounted) {
        setState(() {
          _serviceStatus = status.status;
        });
      }
    } catch (e) {
      // Silently fail - don't block the UI if status check fails
      if (mounted) {
        setState(() {
          _serviceStatus = 'unknown';
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
      final neighbors = await _service.searchNeighbors();
      
      if (mounted) {
        setState(() {
          _neighbors = neighbors;
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

  /// Build the main content
  Widget _buildContent() {
    if (_neighbors.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.devices_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No neighbors discovered',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Pull down to refresh',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[500],
                  ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadNeighbors,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _neighbors.length,
        itemBuilder: (context, index) {
          return _buildNeighborCard(_neighbors[index]);
        },
      ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: _isLoading ? null : _loadNeighbors,
        tooltip: 'Refresh',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}


