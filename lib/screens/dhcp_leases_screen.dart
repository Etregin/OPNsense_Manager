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
import '../models/dhcp_lease.dart';
import '../models/dhcp_server_type.dart';
import '../services/demo_api_service.dart';
import '../services/profile_service.dart';
import '../widgets/app_drawer.dart';
import '../l10n/app_localizations.dart';
import '../utils/constants.dart';
import 'package:intl/intl.dart';

/// Screen displaying DHCP leases from OPNsense
class DhcpLeasesScreen extends StatefulWidget {
  const DhcpLeasesScreen({super.key});

  @override
  State<DhcpLeasesScreen> createState() => _DhcpLeasesScreenState();
}

class _DhcpLeasesScreenState extends State<DhcpLeasesScreen> {
  List<DhcpLease> _leases = [];
  List<DhcpLease> _filteredLeases = [];
  bool _isLoading = true;
  String? _errorMessage;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _filterStatus = 'all'; // all, active, expired
  String _sortBy = 'hostname'; // hostname, ip, expiry
  bool _sortAscending = true;
  DhcpServerType? _dhcpServerType;

  @override
  void initState() {
    super.initState();
    _loadDhcpServerType();
    _loadLeases();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
      _filterLeases();
    });
  }

  void _filterLeases() {
    _filteredLeases = _leases.where((lease) {
      // Apply search filter
      final matchesSearch = _searchQuery.isEmpty ||
          lease.hostname.toLowerCase().contains(_searchQuery) ||
          lease.address.toLowerCase().contains(_searchQuery) ||
          lease.macAddress.toLowerCase().contains(_searchQuery) ||
          (lease.manufacturer?.toLowerCase().contains(_searchQuery) ?? false);

      if (!matchesSearch) return false;

      // Apply status filter
      switch (_filterStatus) {
        case 'active':
          return lease.isActive;
        case 'expired':
          return lease.isExpired;
        default:
          return true;
      }
    }).toList();

    // Apply sorting
    _filteredLeases.sort((a, b) {
      int comparison = 0;
      switch (_sortBy) {
        case 'ip':
          // Sort by IP address (convert to comparable format)
          final aOctets = a.address.split('.').map(int.parse).toList();
          final bOctets = b.address.split('.').map(int.parse).toList();
          for (int i = 0; i < 4; i++) {
            comparison = aOctets[i].compareTo(bOctets[i]);
            if (comparison != 0) break;
          }
          break;
        case 'expiry':
          // Sort by expiry time (nulls last)
          if (a.expiryDateTime == null && b.expiryDateTime == null) {
            comparison = 0;
          } else if (a.expiryDateTime == null) {
            comparison = 1;
          } else if (b.expiryDateTime == null) {
            comparison = -1;
          } else {
            comparison = a.expiryDateTime!.compareTo(b.expiryDateTime!);
          }
          break;
        case 'hostname':
        default:
          comparison = a.hostname.toLowerCase().compareTo(b.hostname.toLowerCase());
          break;
      }
      return _sortAscending ? comparison : -comparison;
    });
  }

  Future<void> _loadDhcpServerType() async {
    try {
      final profileService = ProfileService();
      final activeProfile = await profileService.getActiveProfile();
      if (activeProfile != null && mounted) {
        setState(() {
          _dhcpServerType = activeProfile.dhcpServerType;
        });
      }
    } catch (e) {
      // Silently fail, will use default
    }
  }

  Future<void> _loadLeases() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final demoApiService = context.read<DemoApiService>();
      final leasesData = await demoApiService.getDhcpLeases();
      
      final leases = leasesData.map((data) => DhcpLease.fromJson(data)).toList();

      if (mounted) {
        setState(() {
          _leases = leases;
          _filterLeases();
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
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.dhcpLeases),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            tooltip: l10n.sortBy,
            onSelected: (value) {
              setState(() {
                if (_sortBy == value) {
                  _sortAscending = !_sortAscending;
                } else {
                  _sortBy = value;
                  _sortAscending = true;
                }
                _filterLeases();
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'hostname',
                child: Row(
                  children: [
                    Icon(
                      _sortBy == 'hostname'
                          ? (_sortAscending ? Icons.arrow_upward : Icons.arrow_downward)
                          : Icons.sort_by_alpha,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(l10n.sortByHostname),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'ip',
                child: Row(
                  children: [
                    Icon(
                      _sortBy == 'ip'
                          ? (_sortAscending ? Icons.arrow_upward : Icons.arrow_downward)
                          : Icons.language,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(l10n.sortByIP),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'expiry',
                child: Row(
                  children: [
                    Icon(
                      _sortBy == 'expiry'
                          ? (_sortAscending ? Icons.arrow_upward : Icons.arrow_downward)
                          : Icons.schedule,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text('Expiry Time'),
                  ],
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _loadLeases,
            tooltip: l10n.refresh,
          ),
        ],
      ),
      drawer: const AppDrawer(currentRoute: 'dhcp_leases'),
      body: Column(
        children: [
          // Search and filter bar
          Padding(
            padding: const EdgeInsets.all(AppConstants.standardPadding),
            child: Column(
              children: [
                // Search field
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: l10n.searchHostnameIpOrMac,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppConstants.buttonBorderRadius),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                
                // Status filter chips
                Row(
                  children: [
                    Text(
                      '${l10n.status}:',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildFilterChip(l10n.all, 'all'),
                            const SizedBox(width: 8),
                            _buildFilterChip(l10n.active, 'active'),
                            const SizedBox(width: 8),
                            _buildFilterChip(l10n.expired, 'expired'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // DHCP Server Type and Lease count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.standardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_dhcpServerType != null) ...[
                  Row(
                    children: [
                      Icon(
                        Icons.settings_ethernet,
                        size: 16,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'DHCP Server: ${_dhcpServerType!.displayName}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                ],
                Row(
                  children: [
                    Icon(
                      Icons.dns,
                      size: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.leasesCount(_filteredLeases.length, _leases.length),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Leases list
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Theme.of(context).colorScheme.error,
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
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: _loadLeases,
                              icon: const Icon(Icons.refresh),
                              label: Text(l10n.retry),
                            ),
                          ],
                        ),
                      )
                    : _filteredLeases.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.dns_outlined,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  l10n.noLeasesFound,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        color: Colors.grey[600],
                                      ),
                                ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _loadLeases,
                            child: ListView.builder(
                              padding: const EdgeInsets.all(AppConstants.standardPadding),
                              itemCount: _filteredLeases.length,
                              itemBuilder: (context, index) {
                                return _buildLeaseCard(_filteredLeases[index]);
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _filterStatus == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _filterStatus = value;
          _filterLeases();
        });
      },
      selectedColor: Theme.of(context).colorScheme.primaryContainer,
      checkmarkColor: Theme.of(context).colorScheme.onPrimaryContainer,
    );
  }

  Widget _buildLeaseCard(DhcpLease lease) {
    final l10n = AppLocalizations.of(context)!;
    final isExpired = lease.isExpired;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => _showLeaseDetails(lease),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Hostname and status
              Row(
                children: [
                  Icon(
                    isExpired ? Icons.computer_outlined : Icons.computer,
                    color: isExpired 
                        ? Colors.grey 
                        : Theme.of(context).colorScheme.primary,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      lease.hostname,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isExpired ? Colors.grey : null,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Static/Dynamic badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: lease.isStatic
                          ? Colors.blue[100]
                          : Colors.orange[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      lease.isStatic ? l10n.staticLease : l10n.dynamicLease,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: lease.isStatic ? Colors.blue[900] : Colors.orange[900],
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  // Active/Expired badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: isExpired
                          ? Colors.grey[300]
                          : Colors.green[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      isExpired ? l10n.expired : l10n.active,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isExpired ? Colors.grey[700] : Colors.green[900],
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.chevron_right,
                    size: 20,
                    color: Colors.grey[400],
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // IP Address
              Row(
                children: [
                  Icon(
                    Icons.language,
                    size: 14,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    lease.address,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontFamily: 'monospace',
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
              
              const SizedBox(height: 4),
              
              // MAC Address
              Row(
                children: [
                  Icon(
                    Icons.router,
                    size: 14,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    lease.macAddress,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontFamily: 'monospace',
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
              
              // Manufacturer
              if (lease.manufacturer != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.business,
                      size: 14,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        lease.manufacturer!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
              
              // Expiry time
              if (lease.expiryDateTime != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      size: 14,
                      color: isExpired ? Colors.red : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${l10n.expires}: ${_formatDateTime(lease.expiryDateTime!)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: isExpired ? Colors.red : Theme.of(context).colorScheme.onSurfaceVariant,
                            fontSize: 11,
                          ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = dateTime.difference(now);
    
    if (difference.isNegative) {
      // Expired
      final absDiff = difference.abs();
      if (absDiff.inDays > 0) {
        return '${absDiff.inDays}d ago';
      } else if (absDiff.inHours > 0) {
        return '${absDiff.inHours}h ago';
      } else if (absDiff.inMinutes > 0) {
        return '${absDiff.inMinutes}m ago';
      } else {
        return 'just now';
      }
    } else {
      // Active
      if (difference.inDays > 0) {
        return 'in ${difference.inDays}d';
      } else if (difference.inHours > 0) {
        return 'in ${difference.inHours}h';
      } else if (difference.inMinutes > 0) {
        return 'in ${difference.inMinutes}m';
      } else {
        return 'soon';
      }
    }
  }

  void _showLeaseDetails(DhcpLease lease) {
    final l10n = AppLocalizations.of(context)!;
    final dateFormat = DateFormat('MMM d, y HH:mm:ss');
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.computer,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                lease.hostname,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow(l10n.ipAddress, lease.address),
              _buildDetailRow(l10n.macAddress, lease.macAddress),
              if (lease.manufacturer != null)
                _buildDetailRow('Manufacturer', lease.manufacturer!),
              if (lease.interface != null)
                _buildDetailRow('Interface', lease.interface!),
              const Divider(height: 24),
              _buildDetailRow(
                l10n.status,
                lease.isExpired ? l10n.expired : l10n.active,
              ),
              if (lease.startDateTime != null)
                _buildDetailRow(
                  'Start Time',
                  dateFormat.format(lease.startDateTime!),
                ),
              if (lease.expiryDateTime != null)
                _buildDetailRow(
                  'Expiry Time',
                  dateFormat.format(lease.expiryDateTime!),
                ),
              if (lease.endDateTime != null)
                _buildDetailRow(
                  'End Time',
                  dateFormat.format(lease.endDateTime!),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
