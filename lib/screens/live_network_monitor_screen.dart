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
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/network_host.dart';
import '../models/firewall_rule.dart';
import '../services/demo_api_service.dart';
import '../utils/snackbar_helper.dart';
import '../services/storage_service.dart';
import '../utils/constants.dart';
import '../utils/formatters.dart';
import '../widgets/app_drawer.dart';
import '../widgets/common/error_display.dart';
import '../widgets/common/empty_state_widget.dart';
import '../l10n/app_localizations.dart';

/// Live Network Monitor screen showing real-time bandwidth usage
class LiveNetworkMonitorScreen extends StatefulWidget {
  const LiveNetworkMonitorScreen({super.key});

  @override
  State<LiveNetworkMonitorScreen> createState() => _LiveNetworkMonitorScreenState();
}

class _LiveNetworkMonitorScreenState extends State<LiveNetworkMonitorScreen> {
  List<NetworkHost> _hosts = [];
  List<NetworkHost> _filteredHosts = [];
  bool _isLoading = true;
  String? _errorMessage;
  Timer? _refreshTimer;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Store previous rates for sparkline effect
  final Map<String, List<int>> _rateHistory = {};
  static const int _maxHistoryLength = 20;
  
  // Bandwidth limit in Mbps (default 1000 = 1 Gbps)
  int _bandwidthLimitMbps = 1000;
  
  // Interface selection (default 'lan')
  List<String> _selectedInterfaces = ['lan'];
  Map<String, String> _availableInterfaces = {'lan': 'LAN'};
  
  // Sort options
  String _sortBy = ''; // bandwidth, hostname, ip, manufacturer
  bool _sortAscending = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _loadAvailableInterfaces();
    _loadNetworkHosts();
    _startAutoRefresh();
    _searchController.addListener(_onSearchChanged);
  }
  
  Future<void> _loadSettings() async {
    final storageService = context.read<StorageService>();
    final limit = await storageService.loadInt('network_monitor_bandwidth_limit');
    final interfacesJson = await storageService.loadString('network_monitor_interfaces');
    
    if (mounted) {
      setState(() {
        if (limit != null) _bandwidthLimitMbps = limit;
        if (interfacesJson != null && interfacesJson.isNotEmpty) {
          try {
            final List<dynamic> decoded = jsonDecode(interfacesJson);
            _selectedInterfaces = decoded.cast<String>();
          } catch (e) {
            // Keep default if parsing fails
          }
        }
      });
    }
  }
  
  Future<void> _loadAvailableInterfaces() async {
    try {
      final demoApiService = context.read<DemoApiService>();
      final interfaces = await demoApiService.getAvailableInterfaces();
      if (mounted) {
        setState(() {
          _availableInterfaces = Map<String, String>.from(interfaces);
        });
      }
    } catch (e) {
      // Use default if loading fails
    }
  }
  
  Future<void> _saveBandwidthLimit(int limitMbps) async {
    final storageService = context.read<StorageService>();
    await storageService.saveInt('network_monitor_bandwidth_limit', limitMbps);
    setState(() {
      _bandwidthLimitMbps = limitMbps;
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _startAutoRefresh() {
    // Refresh every 2-3 seconds for live feed simulation
    _refreshTimer = Timer.periodic(
      const Duration(seconds: 2),
      (timer) {
        if (mounted) {
          _loadNetworkHosts(showLoading: false);
        }
      },
    );
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
      _filterHosts();
    });
  }

  void _filterHosts() {
    if (_searchQuery.isEmpty) {
      _filteredHosts = List.from(_hosts);
    } else {
      _filteredHosts = _hosts.where((host) {
        return host.hostname.toLowerCase().contains(_searchQuery) ||
               host.address.toLowerCase().contains(_searchQuery) ||
               (host.manufacturer?.toLowerCase().contains(_searchQuery) ?? false) ||
               (host.macAddress?.toLowerCase().contains(_searchQuery) ?? false);
      }).toList();
    }
    _sortHosts();
  }
  
  void _sortHosts() {
    _filteredHosts.sort((a, b) {
      int comparison = 0;
      
      // Default to bandwidth sorting (descending) if no sort is selected
      if (_sortBy.isEmpty) {
        return b.totalRate.compareTo(a.totalRate);
      }
      
      switch (_sortBy) {
        case 'bandwidth':
          comparison = b.totalRate.compareTo(a.totalRate);
          break;
        case 'hostname':
          comparison = a.hostname.toLowerCase().compareTo(b.hostname.toLowerCase());
          break;
        case 'ip':
          comparison = _compareIpAddresses(a.address, b.address);
          break;
        case 'manufacturer':
          final aMan = a.manufacturer ?? '';
          final bMan = b.manufacturer ?? '';
          comparison = aMan.toLowerCase().compareTo(bMan.toLowerCase());
          break;
      }
      
      return _sortAscending ? comparison : -comparison;
    });
  }
  
  int _compareIpAddresses(String a, String b) {
    final aParts = a.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    final bParts = b.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    
    for (int i = 0; i < 4; i++) {
      if (aParts[i] != bParts[i]) {
        return aParts[i].compareTo(bParts[i]);
      }
    }
    return 0;
  }

  Future<void> _loadNetworkHosts({bool showLoading = true}) async {
    if (showLoading) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final demoApiService = context.read<DemoApiService>();
      
      // Fetch hosts from all selected interfaces and merge them
      List<NetworkHost> allHosts = [];
      for (final interface in _selectedInterfaces) {
        final hosts = await demoApiService.getNetworkHosts(interface: interface);
        allHosts.addAll(hosts);
      }
      
      // Remove duplicates based on IP address (keep the one with highest bandwidth)
      final Map<String, NetworkHost> uniqueHosts = {};
      for (final host in allHosts) {
        if (!uniqueHosts.containsKey(host.address) ||
            host.totalRate > uniqueHosts[host.address]!.totalRate) {
          uniqueHosts[host.address] = host;
        }
      }
      
      final hosts = uniqueHosts.values.toList();

      // Update rate history for sparkline effect
      for (final host in hosts) {
        final history = _rateHistory.putIfAbsent(host.address, () => []);
        history.add(host.totalRate);
        if (history.length > _maxHistoryLength) {
          history.removeAt(0);
        }
      }

      if (mounted) {
        setState(() {
          _hosts = hosts;
          _filterHosts();
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
        title: Text(l10n.liveNetworkMonitor),
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
                  // Bandwidth should be descending (highest first), others ascending
                  _sortAscending = value != 'bandwidth';
                }
                _sortHosts();
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'bandwidth',
                child: Row(
                  children: [
                    Icon(
                      _sortBy == 'bandwidth' ? Icons.check : Icons.speed,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(l10n.sortByBandwidth),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'hostname',
                child: Row(
                  children: [
                    Icon(
                      _sortBy == 'hostname' ? Icons.check : Icons.computer,
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
                      _sortBy == 'ip' ? Icons.check : Icons.numbers,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(l10n.sortByIP),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'manufacturer',
                child: Row(
                  children: [
                    Icon(
                      _sortBy == 'manufacturer' ? Icons.check : Icons.business,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(l10n.sortByManufacturer),
                  ],
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showSettingsDialog,
            tooltip: l10n.settings,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : () => _loadNetworkHosts(),
            tooltip: l10n.refresh,
          ),
        ],
      ),
      drawer: const AppDrawer(currentRoute: 'live_network_monitor'),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(AppConstants.standardPadding),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: l10n.searchHostnameOrIp,
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
          ),
          
          // Host count and refresh indicator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.standardPadding),
            child: Row(
              children: [
                Icon(
                  Icons.devices,
                  size: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.activeHosts(_filteredHosts.length),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Spacer(),
                if (!_isLoading)
                  Row(
                    children: [
                      Icon(
                        Icons.circle,
                        size: 8,
                        color: Colors.green,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        l10n.live,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Totals section
          if (_filteredHosts.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.standardPadding),
              child: _buildTotalsCard(),
            ),
            const SizedBox(height: 12),
          ],
          
          // Host list
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadNetworkHosts,
              child: _buildBody(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading && _hosts.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_errorMessage != null && _hosts.isEmpty) {
      return ErrorDisplay(message: _errorMessage!, onRetry: _loadNetworkHosts);
    }

    if (_filteredHosts.isEmpty) {
      final l10n = AppLocalizations.of(context)!;
      return EmptyStateWidget(
        icon: Icons.search_off,
        title: l10n.noHostsFound,
        subtitle: l10n.tryDifferentSearch,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.standardPadding),
      itemCount: _filteredHosts.length,
      itemBuilder: (context, index) {
        return _buildHostCard(_filteredHosts[index]);
      },
    );
  }
  Widget _buildTotalsCard() {
    final l10n = AppLocalizations.of(context)!;
    
    // Calculate totals
    int totalDownload = 0;
    int totalUpload = 0;
    int activeHosts = 0;
    
    for (final host in _filteredHosts) {
      totalDownload += host.rateIn;
      totalUpload += host.rateOut;
      if (host.totalRate > 0) {
        activeHosts++;
      }
    }
    
    final totalBandwidth = totalDownload + totalUpload;
    
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.analytics,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.networkTotals,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTotalStat(
                    label: l10n.totalDownload,
                    value: Formatters.formatBytesPerSecond(totalDownload, context, decimals: 1),
                    icon: Icons.arrow_downward,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTotalStat(
                    label: l10n.totalUpload,
                    value: Formatters.formatBytesPerSecond(totalUpload, context, decimals: 1),
                    icon: Icons.arrow_upward,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildTotalStat(
                    label: l10n.totalBandwidth,
                    value: Formatters.formatBytesPerSecond(totalBandwidth, context, decimals: 1),
                    icon: Icons.swap_vert,
                    color: Colors.purple,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTotalStat(
                    label: l10n.activeDevices,
                    value: '$activeHosts / ${_filteredHosts.length}',
                    icon: Icons.devices_other,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalStat({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }


  Widget _buildHostCard(NetworkHost host) {
    final l10n = AppLocalizations.of(context)!;
    final history = _rateHistory[host.address] ?? [];
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => _showHostDetails(host),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Hostname and IP
              Row(
                children: [
                  Icon(
                    Icons.computer,
                    color: Theme.of(context).colorScheme.primary,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          host.hostname,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (host.hostname != host.address)
                          Text(
                            host.address,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  fontSize: 11,
                                ),
                          ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    size: 20,
                    color: Colors.grey[400],
                  ),
                ],
              ),
              
              // Manufacturer and MAC in one line
              if (host.manufacturer != null || host.macAddress != null) ...[
                const SizedBox(height: 6),
                Row(
                  children: [
                    if (host.manufacturer != null) ...[
                      Icon(
                        Icons.business,
                        size: 12,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          host.manufacturer!,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                                fontSize: 11,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
              
              const SizedBox(height: 10),
              
              // Bandwidth usage
              Row(
                children: [
                  Expanded(
                    child: _buildBandwidthIndicator(
                      label: l10n.download,
                      rate: host.rateIn,
                      icon: Icons.arrow_downward,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildBandwidthIndicator(
                      label: l10n.upload,
                      rate: host.rateOut,
                      icon: Icons.arrow_upward,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Progress bar showing usage relative to bandwidth limit
              _buildUsageProgressBar(host.totalRate),
              
              // Sparkline (if we have history)
              if (history.length > 1) ...[
                const SizedBox(height: 8),
                SizedBox(
                  height: 60,
                  child: _buildSparkline(history),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBandwidthIndicator({
    required String label,
    required int rate,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            Formatters.formatBytesPerSecond(rate, context, decimals: 1),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsageProgressBar(int totalRate) {
    final l10n = AppLocalizations.of(context)!;
    // Convert Mbps to bytes per second: Mbps * 1,000,000 / 8
    final maxRate = (_bandwidthLimitMbps * 1000000 / 8).round();
    final actualPercentage = (totalRate / maxRate) * 100;
    final progress = (totalRate / maxRate).clamp(0.0, 1.0);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.totalBandwidth,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            Text(
              '${actualPercentage.toStringAsFixed(1)}% of $_bandwidthLimitMbps Mbps',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(
              _getProgressColor(progress),
            ),
          ),
        ),
      ],
    );
  }

  Color _getProgressColor(double progress) {
    if (progress < 0.5) return Colors.green;
    if (progress < 0.75) return Colors.orange;
    return Colors.red;
  }

  void _showHostDetails(NetworkHost host) {
    final l10n = AppLocalizations.of(context)!;
    final history = _rateHistory[host.address] ?? [];
    
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
                host.hostname,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('IP Address', host.address),
              if (host.macAddress != null)
                _buildDetailRow(l10n.macAddress, host.macAddress!),
              if (host.manufacturer != null)
                _buildDetailRow('Manufacturer', host.manufacturer!),
              const Divider(height: 24),
              _buildDetailRow(
                l10n.download,
                Formatters.formatBytesPerSecond(host.rateIn, context, decimals: 2),
              ),
              _buildDetailRow(
                l10n.upload,
                Formatters.formatBytesPerSecond(host.rateOut, context, decimals: 2),
              ),
              _buildDetailRow(
                l10n.totalBandwidth,
                Formatters.formatBytesPerSecond(host.totalRate, context, decimals: 2),
              ),
              if (history.isNotEmpty) ...[
                const Divider(height: 24),
                Text(
                  'Bandwidth History',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 100,
                  child: _buildSparkline(history),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.close),
          ),
          TextButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              _blockHost(host);
            },
            icon: Icon(
              Icons.block,
              color: Theme.of(context).colorScheme.error,
            ),
            label: Text(
              l10n.blockHost,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
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
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontFamily: 'monospace',
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _blockHost(NetworkHost host) async {
    final l10n = AppLocalizations.of(context)!;
    
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.block,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(width: 8),
            Text(
              l10n.blockHost,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
        content: Text(
          l10n.blockHostConfirmation(host.hostname, host.address),
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: Text(l10n.blockHost),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    // Show loading indicator
    if (mounted) {
      SnackBarHelper.showInfo(context, l10n.blockingHost);
    }

    if (!mounted) return;
    
    try {
      final demoApiService = context.read<DemoApiService>();
      
      // Create a firewall rule to block the host
      // The rule will block all traffic from the source IP
      final request = FirewallRuleRequest(
        type: 'block',
        interfaceName: 'lan',
        protocol: 'any',
        source: host.address,
        destination: 'any',
        destinationPort: '',
        description: 'Block ${host.hostname} (${host.address}) - Created from Live Network Monitor',
        enabled: '1',
      );
      
      await demoApiService.createFirewallRule(request);

      if (mounted) {
        SnackBarHelper.showSuccess(context, l10n.hostBlocked);
      }
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showError(context, '${l10n.failedToBlockHost}: $e', duration: const Duration(seconds: 4));
      }
    }
  }

  void _showSettingsDialog() {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController(text: _bandwidthLimitMbps.toString());
    List<String> selectedInterfaces = List.from(_selectedInterfaces);
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(l10n.settings),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Interface Selection
                Text(
                  l10n.monitorInterface,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.selectMultipleInterfaces,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
                ..._availableInterfaces.entries.map((entry) {
                  return CheckboxListTile(
                    title: Text('${entry.value} (${entry.key})'),
                    value: selectedInterfaces.contains(entry.key),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          selectedInterfaces.add(entry.key);
                        } else {
                          selectedInterfaces.remove(entry.key);
                        }
                      });
                    },
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                  );
                }),
                const SizedBox(height: 24),
                
                // Bandwidth Limit
                Text(
                  l10n.bandwidthLimitMbps,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.enterBandwidthLimit,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: l10n.bandwidthLimitMbps,
                    suffixText: 'Mbps',
                    helperText: 'e.g., 100, 500, 1000',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () async {
                final value = int.tryParse(controller.text);
                if (value != null && value > 0 && selectedInterfaces.isNotEmpty) {
                  await _saveBandwidthLimit(value);
                  await _saveInterfaces(selectedInterfaces);
                  if (context.mounted) {
                    Navigator.of(context).pop();
                    // Reload data with new interfaces
                    _loadNetworkHosts();
                  }
                }
              },
              child: Text(l10n.save),
            ),
          ],
        ),
      ),
    );
  }
  
  Future<void> _saveInterfaces(List<String> interfaces) async {
    final storageService = context.read<StorageService>();
    await storageService.saveString('network_monitor_interfaces', jsonEncode(interfaces));
    setState(() {
      _selectedInterfaces = interfaces;
    });
  }


  Widget _buildSparkline(List<int> history) {
    if (history.isEmpty) return const SizedBox.shrink();
    
    // Use bandwidth limit as max value instead of auto-scaling
    // Convert Mbps to bytes per second: Mbps * 1,000,000 / 8
    final maxRate = (_bandwidthLimitMbps * 1000000 / 8).toDouble();
    
    return InteractiveSparkline(
      data: history,
      maxValue: maxRate,
      color: Theme.of(context).colorScheme.primary,
    );
  }
}
/// Interactive sparkline widget with tap-to-show-value functionality
class InteractiveSparkline extends StatefulWidget {
  final List<int> data;
  final double maxValue;
  final Color color;
  final double? height;

  const InteractiveSparkline({
    super.key,
    required this.data,
    required this.maxValue,
    required this.color,
    this.height,
  });

  @override
  State<InteractiveSparkline> createState() => _InteractiveSparklineState();
}

class _InteractiveSparklineState extends State<InteractiveSparkline> {
  int? _selectedIndex;
  Offset? _tapPosition;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        final RenderBox box = context.findRenderObject() as RenderBox;
        final localPosition = box.globalToLocal(details.globalPosition);
        final stepX = box.size.width / (widget.data.length - 1);
        final index = (localPosition.dx / stepX).round().clamp(0, widget.data.length - 1);
        
        setState(() {
          _selectedIndex = index;
          _tapPosition = localPosition;
        });
      },
      onTapUp: (_) {
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              _selectedIndex = null;
              _tapPosition = null;
            });
          }
        });
      },
      child: Stack(
        children: [
          CustomPaint(
            painter: SparklinePainter(
              data: widget.data,
              maxValue: widget.maxValue,
              color: widget.color,
              selectedIndex: _selectedIndex,
            ),
            child: Container(),
          ),
          if (_selectedIndex != null && _tapPosition != null)
            Builder(
              builder: (context) {
                // Calculate tooltip position to keep it visible
                final tooltipWidth = 120.0;
                final tooltipHeight = 32.0;
                
                // Determine if tooltip should be above or below the point
                final showAbove = _tapPosition!.dy > tooltipHeight + 10;
                final topPosition = showAbove
                    ? _tapPosition!.dy - tooltipHeight - 10
                    : _tapPosition!.dy + 10;
                
                // Keep tooltip horizontally centered but within bounds
                var leftPosition = _tapPosition!.dx - (tooltipWidth / 2);
                final RenderBox? box = context.findRenderObject() as RenderBox?;
                if (box != null) {
                  if (leftPosition < 0) leftPosition = 0;
                  if (leftPosition + tooltipWidth > box.size.width) {
                    leftPosition = box.size.width - tooltipWidth;
                  }
                }
                
                return Positioned(
                  left: leftPosition,
                  top: topPosition,
                  child: Container(
                    width: tooltipWidth,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      Formatters.formatBytesPerSecond(widget.data[_selectedIndex!], context, decimals: 2),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}


/// Custom painter for sparkline chart
class SparklinePainter extends CustomPainter {
  final List<int> data;
  final double maxValue;
  final Color color;
  final int? selectedIndex;

  SparklinePainter({
    required this.data,
    required this.maxValue,
    required this.color,
    this.selectedIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty || maxValue == 0) return;

    final paint = Paint()
      ..color = color.withValues(alpha: 0.7)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = color.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;

    final path = Path();
    final fillPath = Path();
    
    final stepX = size.width / (data.length - 1);
    
    // Start from bottom left
    fillPath.moveTo(0, size.height);
    
    for (var i = 0; i < data.length; i++) {
      final x = i * stepX;
      final normalizedValue = (data[i] / maxValue).clamp(0.0, 1.0);
      final y = size.height - (normalizedValue * size.height);
      
      if (i == 0) {
        path.moveTo(x, y);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }
    
    // Complete the fill path
    fillPath.lineTo(size.width, size.height);
    fillPath.close();
    
    // Draw fill first, then line
    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);
    
    // Draw selected point highlight
    if (selectedIndex != null && selectedIndex! < data.length) {
      final x = selectedIndex! * stepX;
      final normalizedValue = data[selectedIndex!] / maxValue;
      final y = size.height - (normalizedValue * size.height);
      
      // Draw outer circle
      final outerCirclePaint = Paint()
        ..color = color.withValues(alpha: 0.3)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(x, y), 8, outerCirclePaint);
      
      // Draw inner circle
      final innerCirclePaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(x, y), 4, innerCirclePaint);
    }
  }

  @override
  bool shouldRepaint(SparklinePainter oldDelegate) {
    return oldDelegate.data != data ||
           oldDelegate.maxValue != maxValue ||
           oldDelegate.selectedIndex != selectedIndex ||
           oldDelegate.color != color;
  }
}
