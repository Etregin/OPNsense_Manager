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
import '../services/demo_api_service.dart';
import '../services/storage_service.dart';
import '../utils/constants.dart';
import '../utils/formatters.dart';
import '../widgets/app_drawer.dart';
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
              onPressed: _loadNetworkHosts,
              icon: const Icon(Icons.refresh),
              label: Text(l10n.retry),
            ),
          ],
        ),
      );
    }

    if (_filteredHosts.isEmpty) {
      final l10n = AppLocalizations.of(context)!;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              l10n.noHostsFound,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.tryDifferentSearch,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
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
      padding: const EdgeInsets.all(12),
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
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
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
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Hostname and IP
            Row(
              children: [
                Icon(
                  Icons.computer,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        host.hostname,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (host.hostname != host.address)
                        Text(
                          host.address,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            
            // Manufacturer
            if (host.manufacturer != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.business,
                    size: 14,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      host.manufacturer!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
            
            // MAC Address
            if (host.macAddress != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.router,
                    size: 14,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      '${l10n.macAddress}: ${host.macAddress}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                            fontFamily: 'monospace',
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
            
            const SizedBox(height: 16),
            
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
                const SizedBox(width: 16),
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
            
            const SizedBox(height: 12),
            
            // Progress bar showing usage relative to 1Gbps
            _buildUsageProgressBar(host.totalRate),
            
            // Sparkline (if we have history)
            if (history.length > 1) ...[
              const SizedBox(height: 12),
              _buildSparkline(history),
            ],
          ],
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            Formatters.formatBytesPerSecond(rate, context, decimals: 1),
            style: TextStyle(
              fontSize: 16,
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
                    color: Colors.grey[600],
                  ),
            ),
            Text(
              '${(progress * 100).toStringAsFixed(1)}% of $_bandwidthLimitMbps Mbps',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
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
    
    final maxRate = history.reduce((a, b) => a > b ? a : b);
    if (maxRate == 0) return const SizedBox.shrink();
    
    return SizedBox(
      height: 40,
      child: CustomPaint(
        painter: SparklinePainter(
          data: history,
          maxValue: maxRate.toDouble(),
          color: Theme.of(context).colorScheme.primary,
        ),
        child: Container(),
      ),
    );
  }
}

/// Custom painter for sparkline chart
class SparklinePainter extends CustomPainter {
  final List<int> data;
  final double maxValue;
  final Color color;

  SparklinePainter({
    required this.data,
    required this.maxValue,
    required this.color,
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
      final normalizedValue = data[i] / maxValue;
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
  }

  @override
  bool shouldRepaint(SparklinePainter oldDelegate) {
    return oldDelegate.data != data ||
           oldDelegate.maxValue != maxValue ||
           oldDelegate.color != color;
  }
}

// Made with Bob
