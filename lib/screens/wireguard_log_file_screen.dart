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
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../services/demo_api_service.dart';
import '../utils/snackbar_helper.dart';
import '../widgets/app_drawer.dart';
import '../widgets/common/error_display.dart';
import '../utils/formatters.dart';
import 'package:opnsense_manager/l10n/app_localizations.dart';

/// Model class for WireGuard log entries
class WireGuardLogEntry {
  final String timestamp;
  final String severity;
  final String processName;
  final int processPid;
  final String line;
  final String? facility;
  final String? host;

  WireGuardLogEntry({
    required this.timestamp,
    required this.severity,
    required this.processName,
    required this.processPid,
    required this.line,
    this.facility,
    this.host,
  });

  factory WireGuardLogEntry.fromJson(Map<String, dynamic> json) {
    return WireGuardLogEntry(
      timestamp: json['timestamp'] ?? json['__timestamp__'] ?? '',
      severity: json['severity'] ?? json['priority'] ?? 'Debug',
      processName: json['process_name'] ?? json['processname'] ?? '',
      processPid: int.tryParse(json['process_pid']?.toString() ?? json['pid']?.toString() ?? '0') ?? 0,
      line: json['line'] ?? json['message'] ?? '',
      facility: json['facility']?.toString(),
      host: json['host'] ?? json['hostname'],
    );
  }
}

/// Screen for viewing WireGuard log entries with severity filters.
class WireGuardLogFileScreen extends StatefulWidget {
  const WireGuardLogFileScreen({super.key});

  @override
  State<WireGuardLogFileScreen> createState() => _WireGuardLogFileScreenState();
}

class _WireGuardLogFileScreenState extends State<WireGuardLogFileScreen> {
  List<String> _severityOptions = <String>[];

  static const List<int> _rowCountOptions = <int>[50, 100, 200];

  final Set<String> _selectedSeverities = <String>{};
  final Set<int> _selectedLogIndexes = <int>{};

  late DemoApiService _apiService;

  List<WireGuardLogEntry> _logs = <WireGuardLogEntry>[];
  bool _isInitialized = false;
  bool _isLoading = true;
  bool _isRefreshing = false;
  String? _errorMessage;
  int _currentPage = 1;
  int _rowCount = 50;
  String _selectedTimeFilter = 'Last Day';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      final l10n = AppLocalizations.of(context)!;
      _severityOptions = <String>[
        l10n.emergency,
        l10n.alert,
        l10n.critical,
        l10n.error,
        l10n.warning,
        l10n.notice,
        l10n.info,
        l10n.debug,
      ];
      _selectedSeverities.addAll([
        l10n.emergency,
        l10n.alert,
        l10n.critical,
        l10n.error,
        l10n.warning,
      ]);
      _apiService = context.read<DemoApiService>();
      _isInitialized = true;
      _loadLogs();
    }
  }

  Future<void> _loadLogs({bool isRefresh = false}) async {
    if (!mounted) {
      return;
    }

    final validFrom = _getValidFromForTimeFilter();

    setState(() {
      if (isRefresh) {
        _isRefreshing = true;
      } else {
        _isLoading = true;
      }
      _errorMessage = null;
    });

    try {
      // Get severity levels for API call
      final severityLevels = _getSeverityLevelsForApi();

      final logsData = await _apiService.getWireGuardLogs(
        rowCount: _rowCount,
        severity: severityLevels,
        validFrom: validFrom,
      );

      if (mounted) {
        final rows = logsData['rows'] as List? ?? [];
        final parsedLogs = rows
            .map((log) => WireGuardLogEntry.fromJson(log as Map<String, dynamic>))
            .toList();

        setState(() {
          _logs = parsedLogs;
          _selectedLogIndexes.clear();
          _isLoading = false;
          _isRefreshing = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
          _isRefreshing = false;
        });
      }
    }
  }

  List<String> _getSeverityLevelsForApi() {
    final l10n = AppLocalizations.of(context)!;
    final List<String> apiSeverities = [];
    
    for (final severity in _selectedSeverities) {
      if (severity == l10n.emergency) {
        apiSeverities.add('Emergency');
      } else if (severity == l10n.alert) {
        apiSeverities.add('Alert');
      } else if (severity == l10n.critical) {
        apiSeverities.add('Critical');
      } else if (severity == l10n.error) {
        apiSeverities.add('Error');
      } else if (severity == l10n.warning) {
        apiSeverities.add('Warning');
      } else if (severity == l10n.notice) {
        apiSeverities.add('Notice');
      } else if (severity == l10n.info) {
        apiSeverities.add('Informational');
      } else if (severity == l10n.debug) {
        apiSeverities.add('Debug');
      }
    }
    
    return apiSeverities;
  }

  Future<void> _onRefresh() async {
    await _loadLogs(isRefresh: true);
  }

  double? _getValidFromForTimeFilter() {
    final nowSeconds =
        DateTime.now().millisecondsSinceEpoch.toDouble() / 1000;

    switch (_selectedTimeFilter) {
      case 'Last Day':
        return nowSeconds - const Duration(days: 1).inSeconds;
      case 'Last Week':
        return nowSeconds - const Duration(days: 7).inSeconds;
      case 'Last Month':
        return nowSeconds - const Duration(days: 31).inSeconds;
      case 'No Limit':
      default:
        return null;
    }
  }

  Future<void> _changeTimeFilter(String? value) async {
    if (value == null || value == _selectedTimeFilter) {
      return;
    }

    setState(() {
      _selectedTimeFilter = value;
      _currentPage = 1;
    });

    await _loadLogs();
  }

  Future<void> _toggleSeverity(String severity, bool selected) async {
    setState(() {
      if (selected) {
        _selectedSeverities.add(severity);
      } else if (_selectedSeverities.length > 1) {
        _selectedSeverities.remove(severity);
      }
      _currentPage = 1;
    });

    await _loadLogs();
  }

  Future<void> _changeRowCount(int? value) async {
    if (value == null || value == _rowCount) {
      return;
    }

    setState(() {
      _rowCount = value;
      _currentPage = 1;
    });

    await _loadLogs();
  }

  Future<void> _changePage(int nextPage) async {
    if (nextPage < 1 || nextPage == _currentPage) {
      return;
    }

    setState(() {
      _currentPage = nextPage;
    });

    await _loadLogs();
  }

  Color _severityColor(BuildContext context, String severity) {
    final colorScheme = Theme.of(context).colorScheme;

    switch (severity) {
      case 'Emergency':
      case 'Alert':
      case 'Critical':
      case 'Error':
        return colorScheme.error;
      case 'Warning':
        return Colors.orange;
      case 'Notice':
        return Colors.amber;
      case 'Info':
      case 'Informational':
        return colorScheme.primary;
      case 'Debug':
      default:
        return colorScheme.outline;
    }
  }

  String _formatTimestamp(String timestamp) {
    try {
      final parsed = DateTime.parse(timestamp);
      return Formatters.formatDateTime(parsed.toLocal());
    } catch (e) {
      // Try parsing as Unix timestamp
      try {
        final unixTimestamp = double.parse(timestamp);
        final dateTime = DateTime.fromMillisecondsSinceEpoch(
          (unixTimestamp * 1000).toInt(),
        );
        return Formatters.formatDateTime(dateTime.toLocal());
      } catch (_) {
        return timestamp;
      }
    }
  }

  String _timeFilterLabel() => _selectedTimeFilter;

  int get _displayStart {
    if (_logs.isEmpty) {
      return 0;
    }

    return ((_currentPage - 1) * _rowCount) + 1;
  }

  int get _displayEnd {
    if (_logs.isEmpty) {
      return 0;
    }

    return _displayStart + _logs.length - 1;
  }

  int get _totalPages {
    if (_rowCount <= 0) {
      return 1;
    }

    final hasFullPage = _logs.length == _rowCount;
    if (!hasFullPage && _currentPage == 1) {
      return 1;
    }

    return _currentPage + (hasFullPage ? 1 : 0);
  }

  bool get _isSelectionMode => _selectedLogIndexes.isNotEmpty;

  String _buildLogDetails(WireGuardLogEntry log) {
    final details = StringBuffer()
      ..writeln('Timestamp: ${_formatTimestamp(log.timestamp)}')
      ..writeln('Severity: ${log.severity}')
      ..writeln('Process: ${log.processName}[${log.processPid}]');

    if (log.facility != null && log.facility!.isNotEmpty) {
      details.writeln('Facility: ${log.facility}');
    }

    if (log.host != null && log.host!.isNotEmpty) {
      details.writeln('Host: ${log.host}');
    }

    details
      ..writeln()
      ..writeln('Message:')
      ..writeln(log.line);

    return details.toString();
  }

  Future<void> _copySelectedLogs() async {
    final selectedLogs = _selectedLogIndexes.toList()..sort();
    final content = selectedLogs
        .map((index) => _buildLogDetails(_logs[index]))
        .join('\n${'-' * 40}\n');

    await Clipboard.setData(ClipboardData(text: content));

    if (mounted) {
      SnackBarHelper.showInfo(context, '${selectedLogs.length} log entr${selectedLogs.length == 1 ? 'y' : 'ies'} copied');

      setState(() {
        _selectedLogIndexes.clear();
      });
    }
  }

  void _toggleLogSelection(int index) {
    setState(() {
      if (_selectedLogIndexes.contains(index)) {
        _selectedLogIndexes.remove(index);
      } else {
        _selectedLogIndexes.add(index);
      }
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedLogIndexes.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isSelectionMode
              ? '${_selectedLogIndexes.length} selected'
              : 'WireGuard Log File',
        ),
        leading: _isSelectionMode
            ? IconButton(
                onPressed: _clearSelection,
                icon: const Icon(Icons.close),
                tooltip: 'Clear selection',
              )
            : null,
        actions: [
          if (_isSelectionMode)
            IconButton(
              onPressed: _copySelectedLogs,
              icon: const Icon(Icons.copy),
              tooltip: 'Copy selected',
            )
          else
            IconButton(
              onPressed: _isLoading ? null : _onRefresh,
              icon: const Icon(Icons.refresh),
              tooltip: 'Refresh',
            ),
        ],
      ),
      drawer: const AppDrawer(currentRoute: 'wireguard_logs'),
      body: Column(
        children: [
          _buildFilters(),
          _buildSummaryBar(context),
          Expanded(child: _buildBody(context)),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: ExpansionTile(
        initiallyExpanded: true,
        leading: const Icon(Icons.filter_list),
        title: const Text('Filters'),
        subtitle: Text(
          '${_selectedSeverities.length} severities • ${_timeFilterLabel()}',
        ),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _severityOptions.map((severity) {
                final isSelected = _selectedSeverities.contains(severity);

                return FilterChip(
                  selected: isSelected,
                  label: Text(severity),
                  avatar: CircleAvatar(
                    radius: 6,
                    backgroundColor: _severityColor(context, severity),
                  ),
                  onSelected: (selected) => _toggleSeverity(severity, selected),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text('Time range'),
              const SizedBox(width: 12),
              DropdownButton<String>(
                value: _selectedTimeFilter,
                items: const [
                  DropdownMenuItem<String>(
                    value: 'Last Day',
                    child: Text('Last Day'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'Last Week',
                    child: Text('Last Week'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'Last Month',
                    child: Text('Last Month'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'No Limit',
                    child: Text('No Limit'),
                  ),
                ],
                onChanged: _isLoading ? null : _changeTimeFilter,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text('Rows per page'),
              const SizedBox(width: 12),
              DropdownButton<int>(
                value: _rowCount,
                items: _rowCountOptions
                    .map(
                      (value) => DropdownMenuItem<int>(
                        value: value,
                        child: Text('$value'),
                      ),
                    )
                    .toList(),
                onChanged: _isLoading ? null : _changeRowCount,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryBar(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: theme.colorScheme.surfaceContainerHighest,
      child: Row(
        children: [
          Expanded(
            child: Text(
              _logs.isEmpty
                  ? 'Showing 0 entries'
                  : 'Showing $_displayStart to $_displayEnd',
              style: theme.textTheme.bodyMedium,
            ),
          ),
          if (_isRefreshing)
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
        ],
      ),
    );
  }

  Future<void> _showLogDetails(WireGuardLogEntry log) async {
    final details = _buildLogDetails(log);

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return SafeArea(
              child: Column(
                children: [
                  // Header with drag handle and close button
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 8, 8, 8),
                    child: Row(
                      children: [
                        // Drag handle indicator
                        Expanded(
                          child: Center(
                            child: Container(
                              width: 40,
                              height: 4,
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close),
                          tooltip: 'Close',
                        ),
                      ],
                    ),
                  ),
                  // Title and copy button
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Log Entry Details',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            await Clipboard.setData(
                              ClipboardData(text: details),
                            );

                            if (context.mounted) {
                              final l10n = AppLocalizations.of(context)!;
                              SnackBarHelper.showInfo(context, l10n.logEntryCopied);
                            }
                          },
                          icon: const Icon(Icons.copy),
                          tooltip: 'Copy',
                        ),
                      ],
                    ),
                  ),
                  // Scrollable content
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      child: SelectableText(
                        details,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_isLoading && _logs.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_errorMessage != null && _logs.isEmpty) {
      return ErrorDisplay(message: _errorMessage!, onRetry: _loadLogs);
    }

    if (_logs.isEmpty) {
      return RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.article_outlined,
                      size: 64,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No log entries found',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Try adjusting the selected severity or date filters.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        itemCount: _logs.length + 1,
        itemBuilder: (context, index) {
          if (index == _logs.length) {
            return _buildPaginationControls();
          }

          final log = _logs[index];
          final severityColor = _severityColor(context, log.severity);
          final isSelected = _selectedLogIndexes.contains(index);

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            color: isSelected
                ? Theme.of(context).colorScheme.primaryContainer
                : null,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: _isSelectionMode
                  ? () => _toggleLogSelection(index)
                  : () => _showLogDetails(log),
              onLongPress: () => _toggleLogSelection(index),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_isSelectionMode) ...[
                      Padding(
                        padding: const EdgeInsets.only(right: 12, top: 2),
                        child: Icon(
                          isSelected
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.outline,
                        ),
                      ),
                    ],
                    Container(
                      width: 12,
                      height: 12,
                      margin: const EdgeInsets.only(top: 6),
                      decoration: BoxDecoration(
                        color: severityColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  '${log.processName}[${log.processPid}]',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Flexible(
                                child: Text(
                                  _formatTimestamp(log.timestamp),
                                  textAlign: TextAlign.end,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              Chip(
                                label: Text(log.severity),
                                visualDensity: VisualDensity.compact,
                                side: BorderSide(color: severityColor),
                                labelStyle: TextStyle(color: severityColor),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            log.line,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPaginationControls() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _isLoading || _currentPage <= 1
                  ? null
                  : () => _changePage(_currentPage - 1),
              icon: const Icon(Icons.chevron_left),
              label: const Text('Previous'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text('Page $_currentPage of $_totalPages'),
          ),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _isLoading || _currentPage >= _totalPages
                  ? null
                  : () => _changePage(_currentPage + 1),
              icon: const Icon(Icons.chevron_right),
              label: const Text('Next'),
            ),
          ),
        ],
      ),
    );
  }
}

