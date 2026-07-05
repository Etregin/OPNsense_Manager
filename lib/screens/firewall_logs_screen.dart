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
import '../services/demo_api_service.dart';
import '../utils/constants.dart';
import '../utils/snackbar_helper.dart';
import '../viewmodels/firewall_logs_view_model.dart';
import '../widgets/app_drawer.dart';
import '../widgets/firewall/log_detail_sheet.dart';
import '../l10n/app_localizations.dart';

/// Firewall logs screen with live log streaming
class FirewallLogsScreen extends StatefulWidget {
  const FirewallLogsScreen({super.key});

  @override
  State<FirewallLogsScreen> createState() => _FirewallLogsScreenState();
}

class _FirewallLogsScreenState extends State<FirewallLogsScreen> {
  late FirewallLogsViewModel _viewModel;
  bool _isInitialized = false;

  bool _isPaused = false;
  Timer? _refreshTimer;
  final ScrollController _scrollController = ScrollController();
  bool _autoScroll = true;
  int _historySize = 100;
  final Set<int> _selectedIndices = {};
  bool _isSelectionMode = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final apiService = context.read<DemoApiService>();
      _viewModel = FirewallLogsViewModel(apiService, historySize: _historySize);
      _isInitialized = true;
      _viewModel.loadItems();
      _startAutoRefresh();
      _scrollController.addListener(_onScroll);
    }
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.offset;
      if (maxScroll - currentScroll > 100) {
        if (_autoScroll) {
          setState(() {
            _autoScroll = false;
          });
        }
      }
    }
  }

  void _startAutoRefresh() {
    _refreshTimer = Timer.periodic(
      const Duration(seconds: 3),
      (timer) {
        if (!_isPaused && mounted) {
          _viewModel.loadItems();
          _doAutoScroll();
        }
      },
    );
  }

  void _doAutoScroll() {
    if (_autoScroll && _scrollController.hasClients) {
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

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
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
      _selectedIndices.clear();
      _isSelectionMode = false;
    });
    _viewModel.setItems([]);
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
      _selectedIndices
          .addAll(List.generate(_viewModel.items.length, (index) => index));
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
    final logs = _viewModel.items;

    final selectedLogs = _selectedIndices
        .map((index) => logs[index])
        .map((log) =>
            '${log.timestamp} | ${log.action.toUpperCase()} | '
            '${log.sourceIp}:${log.sourcePort} → ${log.destIp}:${log.destPort} | '
            'Proto: ${log.protocol} | IF: ${log.interface}'
            '${log.reason.isNotEmpty ? ' | Reason: ${log.reason}' : ''}')
        .join('\n');

    await Clipboard.setData(ClipboardData(text: selectedLogs));

    if (mounted) {
      final l10n = AppLocalizations.of(context)!;
      SnackBarHelper.showInfo(context, l10n.copiedLogEntries(_selectedIndices.length));
      _clearSelection();
    }
  }

  void _showHistorySizeDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.historySize),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.selectNumberOfEntries),
            const SizedBox(height: 16),
            ...[50, 100, 200, 500, 1000].map((size) => ListTile(
                  title: Text('$size ${l10n.entries}'),
                  leading: Icon(
                    _historySize == size
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    color: _historySize == size
                        ? Theme.of(context).primaryColor
                        : null,
                  ),
                  onTap: () {
                    setState(() {
                      _historySize = size;
                      _viewModel.historySize = size;
                    });
                    Navigator.of(context).pop();
                    _viewModel.loadItems();
                  },
                )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }

  Color _getActionColor(String action) {
    switch (action.toLowerCase()) {
      case 'pass':
    return AppColors.success;
  case 'block':
    return AppColors.error;
  case 'reject':
    return AppColors.warning;
  default:
    return AppColors.disabled;
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
    final l10n = AppLocalizations.of(context)!;

    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        final isLoading = _viewModel.isLoading;
        final errorMessage = _viewModel.errorMessage;
        final logs = _viewModel.items;

        return Scaffold(
          appBar: AppBar(
            leading: _isSelectionMode
                ? IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: _clearSelection,
                  )
                : null,
            title: Text(_isSelectionMode
                ? '${_selectedIndices.length} ${l10n.selected}'
                : l10n.firewallLogs),
            actions: _isSelectionMode
                ? [
                    IconButton(
                      icon: const Icon(Icons.select_all),
                      onPressed: _selectAll,
                      tooltip: l10n.selectAll,
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: _copySelected,
                      tooltip: l10n.copy,
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
                              Text('${l10n.historySize} ($_historySize)'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'auto_scroll',
                          child: Row(
                            children: [
                              Icon(
                                _autoScroll
                                    ? Icons.arrow_downward
                                    : Icons.arrow_downward_outlined,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Text(_autoScroll
                                  ? l10n.disableAutoScroll
                                  : l10n.enableAutoScroll),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'clear',
                          enabled: logs.isNotEmpty,
                          child: Row(
                            children: [
                              const Icon(Icons.delete_sweep, size: 20),
                              const SizedBox(width: 12),
                              Text(l10n.clearLogs),
                            ],
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
                      onPressed: _togglePause,
                      tooltip: _isPaused ? l10n.resume : l10n.pause,
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: isLoading ? null : _viewModel.loadItems,
                      tooltip: l10n.refresh,
                    ),
                  ],
          ),
          drawer: const AppDrawer(
            currentRoute: 'firewall_logs'
          ),
          body: Column(
            children: [
              _buildStatusBar(l10n, logs),
              Expanded(child: _buildBody(l10n, isLoading, errorMessage, logs)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusBar(AppLocalizations l10n, List<FirewallLogEntry> logs) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: _isPaused
          ? AppColors.warning.withValues(alpha: 0.1)
          : AppColors.success.withValues(alpha: 0.1),
      child: Row(
        children: [
          Icon(
            _isPaused ? Icons.pause_circle : Icons.fiber_manual_record,
            size: 16,
            color: _isPaused ? AppColors.warning : AppColors.success,
          ),
          const SizedBox(width: 8),
          Text(
            _isPaused ? l10n.paused : l10n.live,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: _isPaused ? AppColors.warning : AppColors.success,
            ),
          ),
          const Spacer(),
          Text(
            '${logs.length} ${l10n.entries}',
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(
    AppLocalizations l10n,
    bool isLoading,
    String? errorMessage,
    List<FirewallLogEntry> logs,
  ) {
    if (isLoading && logs.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null && logs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              l10n.errorLoadingLogs,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _viewModel.loadItems,
              icon: const Icon(Icons.refresh),
              label: Text(l10n.retry),
            ),
          ],
        ),
      );
    }

    if (logs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.article_outlined, size: 64, color: AppColors.iconMuted),
            const SizedBox(height: 16),
            Text(
              l10n.noLogsAvailable,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.logsWillAppear,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurfaceVariant
                      .withValues(alpha: 0.7)),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(AppConstants.standardPadding),
      itemCount: logs.length,
      itemBuilder: (context, index) {
        final log = logs[index];
        final isSelected = _selectedIndices.contains(index);
        return _buildLogEntry(l10n, log, index, isSelected);
      },
    );
  }

  Widget _buildLogEntry(
    AppLocalizations l10n,
    FirewallLogEntry log,
    int index,
    bool isSelected,
  ) {
    final actionColor = _getActionColor(log.action);
    final actionIcon = _getActionIcon(log.action);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: isSelected
          ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
          : null,
      child: InkWell(
        onTap: _isSelectionMode
            ? () => _toggleSelection(index)
            : () => _showLogDetails(log),
        onLongPress: () {
          if (!_isPaused) {
            SnackBarHelper.showInfo(context, l10n.pauseLiveViewToSelect);
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
              : Icon(actionIcon, color: actionColor),
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
              if (log.ruleDescription.isNotEmpty) ...[
                Row(
                  children: [
                    Icon(Icons.rule,
                        size: 12,
                        color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        log.ruleDescription,
                        style: TextStyle(
                          fontSize: 11,
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
              ],
              Text(
                '${l10n.protocol}: ${log.protocol} | ${l10n.interface}: ${log.interface}',
                style: TextStyle(
                    fontSize: 11,
                    color:
                        Theme.of(context).colorScheme.onSurfaceVariant),
              ),
              if (log.reason.isNotEmpty)
                Text(
                  '${l10n.reason}: ${log.reason}',
                  style: TextStyle(
                      fontSize: 11,
                      color:
                          Theme.of(context).colorScheme.onSurfaceVariant),
                ),
            ],
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                log.timestamp,
                style: TextStyle(
                    fontSize: 10,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurfaceVariant
                        .withValues(alpha: 0.7)),
              ),
              if (!_isSelectionMode) ...[
                const SizedBox(height: 4),
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurfaceVariant
                      .withValues(alpha: 0.5),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showLogDetails(FirewallLogEntry log) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (context) => LogDetailSheet(log: log),
    );
  }
}

/// Log entry model for firewall logs — kept in this file for backward compatibility.
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
  final String ruleId;
  final String ruleDescription;
  final String direction;
  final String length;
  final String tcpFlags;

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
    this.ruleId = '',
    this.ruleDescription = '',
    this.direction = '',
    this.length = '',
    this.tcpFlags = '',
  });

  factory FirewallLogEntry.fromJson(Map<String, dynamic> json) {
    return FirewallLogEntry(
      timestamp: json['timestamp'] ?? json['__timestamp__'] ?? json['time'] ?? '',
      action: json['action'] ?? json['act'] ?? '',
      interface: json['interface'] ?? json['if'] ?? json['iface'] ?? '',
      protocol: json['proto'] ?? json['protocol'] ?? json['protoname'] ?? '',
      sourceIp: json['src'] ?? json['source_ip'] ?? json['srcip'] ?? '',
      sourcePort: (json['srcport'] ?? json['source_port'] ?? json['sport'] ?? '').toString(),
      destIp: json['dst'] ?? json['dest_ip'] ?? json['dstip'] ?? json['destination'] ?? '',
      destPort: (json['dstport'] ?? json['dest_port'] ?? json['dport'] ?? '').toString(),
      reason: json['reason'] ?? json['label'] ?? '',
      label: json['label'] ?? json['rule_label'] ?? '',
      ruleId: json['rule_id'] ?? json['rid'] ?? '',
      ruleDescription: json['rule_description'] ?? json['rule_desc'] ?? json['label'] ?? '',
      direction: json['direction'] ?? json['dir'] ?? '',
      length: (json['length'] ?? json['len'] ?? '').toString(),
      tcpFlags: json['tcpflags'] ?? json['flags'] ?? '',
    );
  }

  @override
  String toString() {
    return 'FirewallLogEntry(time: $timestamp, action: $action, $sourceIp:$sourcePort -> $destIp:$destPort, proto: $protocol, if: $interface, rule: $ruleDescription)';
  }
}
