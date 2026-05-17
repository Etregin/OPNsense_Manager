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
import '../../screens/firewall_logs_screen.dart';

/// Bottom sheet widget that displays detailed information about a firewall log entry
class LogDetailSheet extends StatelessWidget {
  final FirewallLogEntry log;

  const LogDetailSheet({
    super.key,
    required this.log,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final actionColor = _getActionColor(log.action);

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
                      _getActionIcon(log.action),
                      color: actionColor,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Log Details',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: actionColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              log.action.toUpperCase(),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: actionColor,
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
                    // Rule Information Section
                    if (log.ruleDescription.isNotEmpty) ...[
                      _buildSectionHeader(context, 'Rule Information', Icons.rule),
                      _buildDetailCard(
                        context,
                        children: [
                          if (log.ruleDescription.isNotEmpty)
                            _buildDetailRow(
                              context,
                              'Rule Description',
                              log.ruleDescription,
                              icon: Icons.description,
                            ),
                          if (log.ruleId.isNotEmpty)
                            _buildDetailRow(
                              context,
                              'Rule ID',
                              log.ruleId,
                              icon: Icons.tag,
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                    
                    // Connection Information Section
                    _buildSectionHeader(context, 'Connection Information', Icons.swap_horiz),
                    _buildDetailCard(
                      context,
                      children: [
                        _buildDetailRow(
                          context,
                          'Source Address',
                          '${log.sourceIp}:${log.sourcePort}',
                          icon: Icons.upload,
                          copyable: true,
                        ),
                        _buildDetailRow(
                          context,
                          'Destination Address',
                          '${log.destIp}:${log.destPort}',
                          icon: Icons.download,
                          copyable: true,
                        ),
                        _buildDetailRow(
                          context,
                          'Protocol',
                          log.protocol.toUpperCase(),
                          icon: Icons.settings_ethernet,
                        ),
                        if (log.direction.isNotEmpty)
                          _buildDetailRow(
                            context,
                            'Direction',
                            log.direction == 'in' ? 'Inbound' : 'Outbound',
                            icon: log.direction == 'in' ? Icons.arrow_downward : Icons.arrow_upward,
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Network Information Section
                    _buildSectionHeader(context, 'Network Information', Icons.network_check),
                    _buildDetailCard(
                      context,
                      children: [
                        _buildDetailRow(
                          context,
                          'Interface',
                          log.interface.toUpperCase(),
                          icon: Icons.router,
                        ),
                        _buildDetailRow(
                          context,
                          'Action',
                          log.action.toUpperCase(),
                          icon: _getActionIcon(log.action),
                          valueColor: actionColor,
                        ),
                        if (log.length.isNotEmpty)
                          _buildDetailRow(
                            context,
                            'Packet Length',
                            '${log.length} bytes',
                            icon: Icons.data_usage,
                          ),
                        if (log.tcpFlags.isNotEmpty)
                          _buildDetailRow(
                            context,
                            'TCP Flags',
                            log.tcpFlags,
                            icon: Icons.flag,
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Additional Information Section
                    _buildSectionHeader(context, 'Additional Information', Icons.info_outline),
                    _buildDetailCard(
                      context,
                      children: [
                        _buildDetailRow(
                          context,
                          'Timestamp',
                          _formatTimestamp(log.timestamp),
                          icon: Icons.access_time,
                          copyable: true,
                        ),
                        if (log.reason.isNotEmpty)
                          _buildDetailRow(
                            context,
                            'Reason',
                            log.reason,
                            icon: Icons.info,
                          ),
                        if (log.label.isNotEmpty && log.label != log.ruleDescription)
                          _buildDetailRow(
                            context,
                            'Label',
                            log.label,
                            icon: Icons.label,
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
          Icon(icon, size: 20, color: Theme.of(context).primaryColor),
          const SizedBox(width: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
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
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      color: valueColor ?? Theme.of(context).colorScheme.onSurface,
                      fontWeight: valueColor != null ? FontWeight.bold : FontWeight.normal,
                    ),
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
      return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
          '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
    } catch (e) {
      return timestamp;
    }
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _copyAllDetails(BuildContext context) {
    final details = StringBuffer();
    
    details.writeln('=== Log Details ===\n');
    
    if (log.ruleDescription.isNotEmpty) {
      details.writeln('Rule Information:');
      details.writeln('  Rule Description: ${log.ruleDescription}');
      if (log.ruleId.isNotEmpty) {
        details.writeln('  Rule ID: ${log.ruleId}');
      }
      details.writeln();
    }
    
    details.writeln('Connection Information:');
    details.writeln('  Source Address: ${log.sourceIp}:${log.sourcePort}');
    details.writeln('  Destination Address: ${log.destIp}:${log.destPort}');
    details.writeln('  Protocol: ${log.protocol.toUpperCase()}');
    if (log.direction.isNotEmpty) {
      details.writeln('  Direction: ${log.direction == 'in' ? 'Inbound' : 'Outbound'}');
    }
    details.writeln();
    
    details.writeln('Network Information:');
    details.writeln('  Interface: ${log.interface.toUpperCase()}');
    details.writeln('  Action: ${log.action.toUpperCase()}');
    if (log.length.isNotEmpty) {
      details.writeln('  Packet Length: ${log.length} bytes');
    }
    if (log.tcpFlags.isNotEmpty) {
      details.writeln('  TCP Flags: ${log.tcpFlags}');
    }
    details.writeln();
    
    details.writeln('Additional Information:');
    details.writeln('  Timestamp: ${_formatTimestamp(log.timestamp)}');
    if (log.reason.isNotEmpty) {
      details.writeln('  Reason: ${log.reason}');
    }
    if (log.label.isNotEmpty && log.label != log.ruleDescription) {
      details.writeln('  Label: ${log.label}');
    }
    
    Clipboard.setData(ClipboardData(text: details.toString()));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All details copied to clipboard'),
        duration: Duration(seconds: 2),
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
}

// Made with Bob
