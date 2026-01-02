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
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/system_info.dart';
import '../services/opnsense_api_service.dart';
import '../utils/constants.dart';
import '../widgets/app_drawer.dart';

/// Firewall logs screen with live log streaming
class FirewallLogsScreen extends StatefulWidget {
  const FirewallLogsScreen({super.key});

  @override
  State<FirewallLogsScreen> createState() => _FirewallLogsScreenState();
}

class _FirewallLogsScreenState extends State<FirewallLogsScreen> {
  final List<FirewallLogEntry> _logs = [];
  SystemInfo? _systemInfo;
  bool _isLoading = true;
  bool _isPaused = false;
  String? _errorMessage;
  Timer? _refreshTimer;
  final ScrollController _scrollController = ScrollController();
  bool _autoScroll = true;
  int _historySize = 100; // Default 100 entries
  final Set<int> _selectedIndices = {};
  bool _isSelectionMode = false;

  @override
  void initState() {
    super.initState();
    _loadSystemInfo();
    _loadLogs();
    _startAutoRefresh();
    
    // Listen to scroll events to detect manual scrolling
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // If user scrolls up from the bottom, disable auto-scroll
    if (_scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.offset;
      
      // If user is not at the bottom (with 100px threshold), disable auto-scroll
      if (maxScroll - currentScroll > 100) {
        if (_autoScroll) {
          setState(() {
            _autoScroll = false;
          });
        }
      }
    }
  }

  Future<void> _loadSystemInfo() async {
    try {
      final apiService = context.read<OPNsenseApiService>();
      final systemInfo = await apiService.getSystemInfo();
      if (mounted) {
        setState(() {
          _systemInfo = systemInfo;
        });
      }
    } catch (e) {
      // Silently fail - system info is optional for drawer
    }
  }

  void _startAutoRefresh() {
    _refreshTimer = Timer.periodic(
      const Duration(seconds: 3), // Refresh every 3 seconds for live logs
      (timer) {
        if (!_isPaused && mounted) {
          _loadLogs();
        }
      },
    );
  }

  Future<void> _loadLogs() async {
    if (_isPaused) return;

    try {
      final apiService = context.read<OPNsenseApiService>();
      final logsData = await apiService.getFirewallLogs(limit: _historySize);

      if (mounted) {
        final parsedLogs = logsData
            .map((log) => FirewallLogEntry.fromJson(log as Map<String, dynamic>))
            .toList();

        setState(() {
          _logs.clear();
          _logs.addAll(parsedLogs);
          _isLoading = false;
          _errorMessage = null;
        });

        // Auto-scroll to bottom if enabled and user is already near bottom
        if (_autoScroll && _scrollController.hasClients) {
          // Only auto-scroll if we're already near the bottom (within 200px)
          final maxScroll = _scrollController.position.maxScrollExtent;
          final currentScroll = _scrollController.offset;
          
          if (maxScroll - currentScroll < 200) {
            _scrollController.animateTo(
              maxScroll,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        }
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

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
      // Clear selection when resuming live view
      if (!_isPaused && _isSelectionMode) {
        _selectedIndices.clear();
        _isSelectionMode = false;
      }
    });
  }

  void _toggleAutoScroll() {
    setState(() {
      _autoScroll = !_autoScroll;
    });
    
    // If enabling auto-scroll, scroll to bottom immediately
    if (_autoScroll && _scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _clearLogs() {
    setState(() {
      _logs.clear();
      _selectedIndices.clear();
      _isSelectionMode = false;
    });
  }

  void _toggleSelection(int index) {
    setState(() {
      if (_selectedIndices.contains(index)) {
        _selectedIndices.remove(index);
        if (_selectedIndices.isEmpty) {
          _isSelectionMode = false;
        }
      } else {
        _selectedIndices.add(index);
        _isSelectionMode = true;
      }
    });
  }

  void _selectAll() {
    setState(() {
      _selectedIndices.clear();
      _selectedIndices.addAll(List.generate(_logs.length, (index) => index));
      _isSelectionMode = true;
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedIndices.clear();
      _isSelectionMode = false;
    });
  }

  Future<void> _copySelected() async {
    if (_selectedIndices.isEmpty) return;

    final selectedLogs = _selectedIndices
        .map((index) => _logs[index])
        .map((log) => '${log.timestamp} | ${log.action.toUpperCase()} | '
            '${log.sourceIp}:${log.sourcePort} → ${log.destIp}:${log.destPort} | '
            'Proto: ${log.protocol} | IF: ${log.interface}${log.reason.isNotEmpty ? ' | Reason: ${log.reason}' : ''}')
        .join('\n');

    await Clipboard.setData(ClipboardData(text: selectedLogs));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Copied ${_selectedIndices.length} log ${_selectedIndices.length == 1 ? 'entry' : 'entries'}'),
          duration: const Duration(seconds: 2),
        ),
      );
      _clearSelection();
    }
  }

  void _showHistorySizeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('History Size'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Select the number of log entries to display:'),
            const SizedBox(height: 16),
            ...[50, 100, 200, 500, 1000].map((size) => ListTile(
              title: Text('$size entries'),
              leading: Icon(
                _historySize == size ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                color: _historySize == size ? Theme.of(context).primaryColor : null,
              ),
              onTap: () {
                setState(() {
                  _historySize = size;
                });
                Navigator.of(context).pop();
                _loadLogs();
              },
            )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Color _getActionColor(String action) {
    switch (action.toLowerCase()) {
      case 'pass':
        return Colors.green;
      case 'block':
        return Colors.red;
      case 'reject':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getActionIcon(String action) {
    switch (action.toLowerCase()) {
      case 'pass':
        return Icons.check_circle;
      case 'block':
        return Icons.block;
      case 'reject':
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: _isSelectionMode
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: _clearSelection,
              )
            : null,
        title: Text(_isSelectionMode
            ? '${_selectedIndices.length} selected'
            : 'Firewall Logs'),
        actions: _isSelectionMode
            ? [
                IconButton(
                  icon: const Icon(Icons.select_all),
                  onPressed: _selectAll,
                  tooltip: 'Select All',
                ),
                IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: _copySelected,
                  tooltip: 'Copy',
                ),
              ]
            : [
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (value) {
                    switch (value) {
                      case 'history_size':
                        _showHistorySizeDialog();
                        break;
                      case 'auto_scroll':
                        _toggleAutoScroll();
                        break;
                      case 'clear':
                        _clearLogs();
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'history_size',
                      child: Row(
                        children: [
                          const Icon(Icons.history, size: 20),
                          const SizedBox(width: 12),
                          Text('History Size ($_historySize)'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'auto_scroll',
                      child: Row(
                        children: [
                          Icon(
                            _autoScroll ? Icons.arrow_downward : Icons.arrow_downward_outlined,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Text(_autoScroll ? 'Disable Auto-scroll' : 'Enable Auto-scroll'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'clear',
                      enabled: _logs.isNotEmpty,
                      child: const Row(
                        children: [
                          Icon(Icons.delete_sweep, size: 20),
                          SizedBox(width: 12),
                          Text('Clear Logs'),
                        ],
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
                  onPressed: _togglePause,
                  tooltip: _isPaused ? 'Resume' : 'Pause',
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _isLoading ? null : _loadLogs,
                  tooltip: 'Refresh',
                ),
              ],
      ),
      drawer: AppDrawer(
        currentRoute: 'firewall_logs',
        systemInfo: _systemInfo,
      ),
      body: Column(
        children: [
          _buildStatusBar(),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildStatusBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: _isPaused ? Colors.orange.withValues(alpha: 0.1) : Colors.green.withValues(alpha: 0.1),
      child: Row(
        children: [
          Icon(
            _isPaused ? Icons.pause_circle : Icons.fiber_manual_record,
            size: 16,
            color: _isPaused ? Colors.orange : Colors.green,
          ),
          const SizedBox(width: 8),
          Text(
            _isPaused ? 'Paused' : 'Live',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: _isPaused ? Colors.orange : Colors.green,
            ),
          ),
          const Spacer(),
          Text(
            '${_logs.length} entries',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading && _logs.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_errorMessage != null && _logs.isEmpty) {
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
              'Error loading logs',
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
              onPressed: _loadLogs,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_logs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.article_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No logs available',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'Logs will appear here as they are generated',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(AppConstants.standardPadding),
      itemCount: _logs.length,
      itemBuilder: (context, index) {
        final log = _logs[index];
        final isSelected = _selectedIndices.contains(index);
        return _buildLogEntry(log, index, isSelected);
      },
    );
  }

  Widget _buildLogEntry(FirewallLogEntry log, int index, bool isSelected) {
    final actionColor = _getActionColor(log.action);
    final actionIcon = _getActionIcon(log.action);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: isSelected ? Theme.of(context).primaryColor.withValues(alpha: 0.1) : null,
      child: InkWell(
        onTap: _isSelectionMode ? () => _toggleSelection(index) : null,
        onLongPress: () {
          if (!_isPaused) {
            // Show message that selection is only available when paused
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Pause live view to select log entries'),
                duration: Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
              ),
            );
            return;
          }
          if (!_isSelectionMode) {
            _toggleSelection(index);
          }
        },
        child: ListTile(
          leading: _isSelectionMode
              ? Checkbox(
                  value: isSelected,
                  onChanged: (_) => _toggleSelection(index),
                )
              : Icon(
                  actionIcon,
                  color: actionColor,
                ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: actionColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  log.action.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: actionColor,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${log.sourceIp}:${log.sourcePort} → ${log.destIp}:${log.destPort}',
                  style: const TextStyle(fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                'Protocol: ${log.protocol} | Interface: ${log.interface}',
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              ),
              if (log.reason.isNotEmpty)
                Text(
                  'Reason: ${log.reason}',
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
            ],
          ),
          trailing: Text(
            log.timestamp,
            style: TextStyle(fontSize: 10, color: Colors.grey[500]),
          ),
        ),
      ),
    );
  }
}

/// Firewall log entry model
class FirewallLogEntry {
  final String timestamp;
  final String action;
  final String interface;
  final String protocol;
  final String sourceIp;
  final String sourcePort;
  final String destIp;
  final String destPort;
  final String reason;
  final String label;

  FirewallLogEntry({
    required this.timestamp,
    required this.action,
    required this.interface,
    required this.protocol,
    required this.sourceIp,
    required this.sourcePort,
    required this.destIp,
    required this.destPort,
    this.reason = '',
    this.label = '',
  });

  factory FirewallLogEntry.fromJson(Map<String, dynamic> json) {
    // OPNsense log format fields
    return FirewallLogEntry(
      timestamp: json['timestamp'] ?? json['__timestamp__'] ?? json['time'] ?? '',
      action: json['action'] ?? json['act'] ?? '',
      interface: json['interface'] ?? json['if'] ?? json['iface'] ?? '',
      protocol: json['proto'] ?? json['protocol'] ?? json['protoname'] ?? '',
      sourceIp: json['src'] ?? json['source_ip'] ?? json['srcip'] ?? '',
      sourcePort: json['srcport'] ?? json['source_port'] ?? json['sport'] ?? '',
      destIp: json['dst'] ?? json['dest_ip'] ?? json['dstip'] ?? json['destination'] ?? '',
      destPort: json['dstport'] ?? json['dest_port'] ?? json['dport'] ?? '',
      reason: json['reason'] ?? json['label'] ?? '',
      label: json['label'] ?? json['rule_label'] ?? '',
    );
  }

  @override
  String toString() {
    return 'FirewallLogEntry(time: $timestamp, action: $action, $sourceIp:$sourcePort -> $destIp:$destPort, proto: $protocol, if: $interface)';
  }
}

