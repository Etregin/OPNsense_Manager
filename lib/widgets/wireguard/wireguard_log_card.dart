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
import '../../utils/formatters.dart';

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

  @override
  String toString() {
    return 'WireGuardLogEntry(time: $timestamp, severity: $severity, process: $processName[$processPid], message: $line)';
  }
}

/// Card widget for displaying a WireGuard log entry
class WireGuardLogCard extends StatelessWidget {
  final WireGuardLogEntry log;
  final VoidCallback onTap;

  const WireGuardLogCard({
    super.key,
    required this.log,
    required this.onTap,
  });

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'emergency':
      case 'alert':
      case 'critical':
        return Colors.red;
      case 'error':
        return Colors.orange;
      case 'warning':
        return Colors.yellow[700]!;
      case 'notice':
      case 'informational':
        return Colors.blue;
      case 'debug':
      default:
        return Colors.grey;
    }
  }

  IconData _getSeverityIcon(String severity) {
    switch (severity.toLowerCase()) {
      case 'emergency':
      case 'alert':
        return Icons.error;
      case 'critical':
        return Icons.warning;
      case 'error':
        return Icons.error_outline;
      case 'warning':
        return Icons.warning_amber;
      case 'notice':
        return Icons.info;
      case 'informational':
        return Icons.info_outline;
      case 'debug':
      default:
        return Icons.bug_report;
    }
  }

  @override
  Widget build(BuildContext context) {
    final severityColor = _getSeverityColor(log.severity);
    final severityIcon = _getSeverityIcon(log.severity);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        child: ListTile(
          leading: Icon(
            severityIcon,
            color: severityColor,
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: severityColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  log.severity.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: severityColor,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${log.processName}[${log.processPid}]',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
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
                log.line,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatTimestamp(log.timestamp),
                style: TextStyle(
                  fontSize: 10,
                  color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 4),
              Icon(
                Icons.info_outline,
                size: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTimestamp(String timestamp) {
    try {
      final dateTime = DateTime.parse(timestamp);
      return Formatters.formatTime(dateTime);
    } catch (e) {
      return timestamp;
    }
  }
}


