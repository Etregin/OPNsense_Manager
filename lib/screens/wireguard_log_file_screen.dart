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
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../services/demo_api_service.dart';
import '../services/vpn/wireguard_service.dart';
import '../widgets/app_drawer.dart';
import '../widgets/wireguard/wireguard_log_card.dart';
import '../widgets/wireguard/wireguard_log_detail_sheet.dart';
import '../utils/constants.dart';
import 'package:opnsense_manager/l10n/app_localizations.dart';

/// Screen for viewing WireGuard log files with filtering and manual refresh
class WireGuardLogFileScreen extends StatefulWidget {
  const WireGuardLogFileScreen({super.key});

  @override
  State<WireGuardLogFileScreen> createState() => _WireGuardLogFileScreenState();
}

class _WireGuardLogFileScreenState extends State<WireGuardLogFileScreen> {
  final List<WireGuardLogEntry> _logs = [];
  bool _isLoading = true;
  String? _errorMessage;
  
  // Filter state
  String _selectedSeverity = 'Debug';
  String _selectedTimeFilter = 'No Limit';
  int _selectedLimit = 100;
  
  // Severity options - keys for localization
  final List<String> _severityOptions = [
    'Emergency',
    'Alert',
    'Critical',
    'Error',
    'Warning',
    'Notice',
    'Informational',
    'Debug',
  ];
  
  // Time filter options - keys for localization
  final List<String> _timeFilterOptions = [
    'Last Day',
    'Last Week',
    'Last Month',
    'No Limit',
  ];
  
  // Limit options
  final List<int> _limitOptions = [50, 100, 200, 500, 1000, 2000];

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get the initialized API service from Provider
      final apiService = context.read<DemoApiService>();
      final severityLevels = WireGuardService.getSeverityLevels(_selectedSeverity);

      // Calculate validFrom timestamp based on time filter
      double? validFrom;
      if (_selectedTimeFilter != 'No Limit') {
        int secondsAgo;
        switch (_selectedTimeFilter) {
          case 'Last Day':
            secondsAgo = WireGuardService.lastDaySeconds;
            break;
          case 'Last Week':
            secondsAgo = WireGuardService.lastWeekSeconds;
            break;
          case 'Last Month':
            secondsAgo = WireGuardService.lastMonthSeconds;
            break;
          default:
            secondsAgo = 0;
        }
        validFrom = WireGuardService.getTimestampFromNow(secondsAgo);
      }

      // Fetch logs with filters using the initialized service
      final logsData = await apiService.getWireGuardLogs(
        rowCount: _selectedLimit,
        severity: severityLevels,
        validFrom: validFrom,
      );

      if (mounted) {
        final rows = logsData['rows'] as List? ?? [];
        final parsedLogs = rows
            .map((log) => WireGuardLogEntry.fromJson(log as Map<String, dynamic>))
            .toList();

        setState(() {
          _logs.clear();
          _logs.addAll(parsedLogs);
          _isLoading = false;
          _errorMessage = null;
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

  /// Export logs to a text file and share it
  Future<void> _exportLogs() async {
    final l10n = AppLocalizations.of(context)!;
    
    if (_logs.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.noLogsToExport),
            duration: const Duration(seconds: 2),
          ),
        );
      }
      return;
    }

    try {
      // Format the current timestamp
      final now = DateTime.now();
      final dateFormatter = DateFormat('yyyy-MM-dd HH:mm:ss');
      final fileNameFormatter = DateFormat('yyyy-MM-dd_HHmmss');
      
      // Build the export content
      final buffer = StringBuffer();
      buffer.writeln(l10n.wireguardLogsExport);
      buffer.writeln('${l10n.generated}: ${dateFormatter.format(now)}');
      buffer.writeln('${l10n.totalEntries}: ${_logs.length}');
      buffer.writeln('${l10n.filters}: ${l10n.severity}=$_selectedSeverity, ${l10n.time}=$_selectedTimeFilter, ${l10n.limit}=$_selectedLimit');
      buffer.writeln('=' * 60);
      buffer.writeln();

      // Add each log entry
      for (final log in _logs) {
        // Parse and format the timestamp
        final timestamp = DateTime.fromMillisecondsSinceEpoch(
          (double.parse(log.timestamp) * 1000).toInt(),
        );
        final formattedTimestamp = dateFormatter.format(timestamp);
        
        buffer.writeln('[$formattedTimestamp] [${log.severity}] ${log.processName} (${log.processPid})');
        buffer.writeln(log.line);
        buffer.writeln();
      }

      // Get temporary directory
      final directory = await getTemporaryDirectory();
      final fileName = 'wireguard_logs_${fileNameFormatter.format(now)}.txt';
      final filePath = '${directory.path}/$fileName';
      
      // Write to file
      final file = File(filePath);
      await file.writeAsString(buffer.toString());

      // Share the file
      final result = await SharePlus.instance.share(
        ShareParams(
          files: [XFile(filePath)],
          subject: l10n.wireguardLogsExport,
          text: l10n.wireguardLogsExportedOn(dateFormatter.format(now)),
        ),
      );

      if (mounted && result.status == ShareResultStatus.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.logsExportedSuccessfully),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.failedToExportLogs(e.toString())),
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showLogDetails(WireGuardLogEntry log) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => WireGuardLogDetailSheet(log: log),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.wireguardLogs),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _isLoading || _logs.isEmpty ? null : _exportLogs,
            tooltip: l10n.exportLogs,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _loadLogs,
            tooltip: l10n.refresh,
          ),
        ],
      ),
      drawer: const AppDrawer(currentRoute: 'wireguard_logs'),
      body: Column(
        children: [
          _buildFilterRow(),
          _buildStatusBar(),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildFilterRow() {
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Row(
        children: [
          // Severity Filter
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.severity,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                const SizedBox(height: 4),
                DropdownButtonFormField<String>(
                  initialValue: _selectedSeverity,
                  isDense: true,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    border: OutlineInputBorder(),
                  ),
                  items: _severityOptions.map((severity) {
                    final displayText = switch (severity) {
                      'Emergency' => l10n.severityEmergency,
                      'Alert' => l10n.severityAlert,
                      'Critical' => l10n.severityCritical,
                      'Error' => l10n.severityError,
                      'Warning' => l10n.severityWarning,
                      'Notice' => l10n.severityNotice,
                      'Informational' => l10n.severityInformational,
                      'Debug' => l10n.severityDebug,
                      _ => severity,
                    };
                    // Use compact version for display
                    final compactText = switch (severity) {
                      'Emergency' => l10n.severityEmergencyShort,
                      'Informational' => l10n.severityInformationalShort,
                      _ => displayText,
                    };
                    return DropdownMenuItem(
                      value: severity,
                      child: Text(
                        compactText,
                        style: const TextStyle(fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedSeverity = value;
                      });
                      _loadLogs();
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Time Filter
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.validFrom,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                const SizedBox(height: 4),
                DropdownButtonFormField<String>(
                  initialValue: _selectedTimeFilter,
                  isDense: true,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    border: OutlineInputBorder(),
                  ),
                  items: _timeFilterOptions.map((timeFilter) {
                    final displayText = switch (timeFilter) {
                      'Last Day' => l10n.lastDay,
                      'Last Week' => l10n.lastWeek,
                      'Last Month' => l10n.lastMonth,
                      'No Limit' => l10n.noLimit,
                      _ => timeFilter,
                    };
                    // Use compact version for display
                    final compactText = switch (timeFilter) {
                      'Last Day' => l10n.lastDayShort,
                      'Last Week' => l10n.lastWeekShort,
                      'Last Month' => l10n.lastMonthShort,
                      'No Limit' => l10n.noLimitShort,
                      _ => displayText,
                    };
                    return DropdownMenuItem(
                      value: timeFilter,
                      child: Text(
                        compactText,
                        style: const TextStyle(fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedTimeFilter = value;
                      });
                      _loadLogs();
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Limit Filter
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.limit,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                const SizedBox(height: 4),
                DropdownButtonFormField<int>(
                  initialValue: _selectedLimit,
                  isDense: true,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    border: OutlineInputBorder(),
                  ),
                  items: _limitOptions.map((limit) {
                    return DropdownMenuItem(
                      value: limit,
                      child: Text(
                        '$limit',
                        style: const TextStyle(fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedLimit = value;
                      });
                      _loadLogs();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBar() {
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Row(
        children: [
          Text(
            '${l10n.severity}: $_selectedSeverity',
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '• $_selectedTimeFilter',
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '• ${l10n.limit}: $_selectedLimit',
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const Spacer(),
          Text(
            l10n.entriesCount(_logs.length),
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    final l10n = AppLocalizations.of(context)!;
    
    if (_isLoading && _logs.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_errorMessage != null && _logs.isEmpty) {
      return Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
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
                l10n.errorLoadingLogs,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _loadLogs,
                icon: const Icon(Icons.refresh),
                label: Text(l10n.retry),
              ),
            ],
          ),
        ),
      );
    }

    if (_logs.isEmpty) {
      return Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
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
                l10n.noLogsAvailable,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.logsMatchingFiltersWillAppearHere,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.standardPadding),
      itemCount: _logs.length,
      itemBuilder: (context, index) {
        final log = _logs[index];
        return WireGuardLogCard(
          log: log,
          onTap: () => _showLogDetails(log),
        );
      },
    );
  }
}


