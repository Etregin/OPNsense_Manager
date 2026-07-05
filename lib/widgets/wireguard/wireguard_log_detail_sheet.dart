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
import '../../l10n/app_localizations.dart';
import '../../utils/color_helpers.dart';
import '../../utils/formatters.dart';
import '../../utils/snackbar_helper.dart';
import 'wireguard_log_card.dart';

/// Bottom sheet widget that displays detailed information about a WireGuard log entry
class WireGuardLogDetailSheet extends StatelessWidget {
  final WireGuardLogEntry log;

  const WireGuardLogDetailSheet({
    super.key,
    required this.log,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final severityColor = wireguardSeverityColor(log.severity, context: context);

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Icon(
                      _getSeverityIcon(log.severity),
                      color: severityColor,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'WireGuard Log Details',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: severityColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              log.severity.toUpperCase(),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: severityColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              const Divider(),
              // Content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Process Information Section
                    _buildSectionHeader(context, l10n.processInformation, Icons.settings),
                    _buildDetailCard(
                      context,
                      children: [
                        _buildDetailRow(
                          context,
                          l10n.processName,
                          log.processName,
                          icon: Icons.app_settings_alt,
                          copyable: true,
                        ),
                        _buildDetailRow(
                          context,
                          l10n.processId,
                          log.processPid.toString(),
                          icon: Icons.tag,
                          copyable: true,
                        ),
                        _buildDetailRow(
                          context,
                          l10n.severity,
                          log.severity,
                          icon: _getSeverityIcon(log.severity),
                          valueColor: severityColor,
                        ),
                        if (log.facility != null && log.facility!.isNotEmpty)
                          _buildDetailRow(
                            context,
                            l10n.facility,
                            log.facility!,
                            icon: Icons.category,
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Log Message Section
                    _buildSectionHeader(context, l10n.logMessage, Icons.message),
                    _buildDetailCard(
                      context,
                      children: [
                        _buildDetailRow(
                          context,
                          l10n.message,
                          log.line,
                          icon: Icons.description,
                          copyable: true,
                          multiline: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Timestamp Information Section
                    _buildSectionHeader(context, l10n.timestampInformation, Icons.access_time),
                    _buildDetailCard(
                      context,
                      children: [
                        _buildDetailRow(
                          context,
                          l10n.timestamp,
                          _formatTimestamp(log.timestamp),
                          icon: Icons.schedule,
                          copyable: true,
                        ),
                        _buildDetailRow(
                          context,
                          l10n.rawTimestamp,
                          log.timestamp,
                          icon: Icons.code,
                          copyable: true,
                        ),
                        if (log.host != null && log.host!.isNotEmpty)
                          _buildDetailRow(
                            context,
                            l10n.host,
                            log.host!,
                            icon: Icons.computer,
                            copyable: true,
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Copy All Button
                    ElevatedButton.icon(
                      onPressed: () => _copyAllDetails(context),
                      icon: const Icon(Icons.copy_all),
                      label: const Text('Copy All Details'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(BuildContext context, {required List<Widget> children}) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: children,
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value, {
    IconData? icon,
    Color? valueColor,
    bool copyable = false,
    bool multiline = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: Theme.of(context).colorScheme.onSurfaceVariant),
            const SizedBox(width: 8),
          ],
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      color: valueColor ?? Theme.of(context).colorScheme.onSurface,
                      fontWeight: valueColor != null ? FontWeight.bold : FontWeight.normal,
                    ),
                    maxLines: multiline ? null : 1,
                    overflow: multiline ? null : TextOverflow.ellipsis,
                  ),
                ),
                if (copyable)
                  IconButton(
                    icon: const Icon(Icons.copy, size: 16),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () => _copyToClipboard(context, value),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(String timestamp) {
    try {
      final dateTime = DateTime.parse(timestamp);
      return Formatters.formatDateTime(dateTime);
    } catch (e) {
      return timestamp;
    }
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    SnackBarHelper.showInfo(context, 'Copied to clipboard', duration: const Duration(seconds: 1));
  }

  void _copyAllDetails(BuildContext context) {
    final details = StringBuffer();
    
    details.writeln('=== WireGuard Log Details ===\n');
    
    details.writeln('Process Information:');
    details.writeln('  Process Name: ${log.processName}');
    details.writeln('  Process ID: ${log.processPid}');
    details.writeln('  Severity: ${log.severity}');
    if (log.facility != null && log.facility!.isNotEmpty) {
      details.writeln('  Facility: ${log.facility}');
    }
    details.writeln();
    
    details.writeln('Log Message:');
    details.writeln('  ${log.line}');
    details.writeln();
    
    details.writeln('Timestamp Information:');
    details.writeln('  Timestamp: ${_formatTimestamp(log.timestamp)}');
    details.writeln('  Raw Timestamp: ${log.timestamp}');
    if (log.host != null && log.host!.isNotEmpty) {
      details.writeln('  Host: ${log.host}');
    }
    
    Clipboard.setData(ClipboardData(text: details.toString()));
    SnackBarHelper.showInfo(context, 'All details copied to clipboard');
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
}


