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
import '../../l10n/app_localizations.dart';
import '../../utils/constants.dart';
import '../../utils/snackbar_helper.dart';

/// Bottom sheet widget that displays detailed information about a firewall log entry
class LogDetailSheet extends StatelessWidget {
  final FirewallLogEntry log;

  const LogDetailSheet({
    super.key,
    required this.log,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
                            l10n.logDetails,
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
                      _buildSectionHeader(context, l10n.ruleInformation, Icons.rule),
                      _buildDetailCard(
                        context,
                        children: [
                          if (log.ruleDescription.isNotEmpty)
                            _buildDetailRow(
                              context,
                              l10n.ruleDescription,
                              log.ruleDescription,
                              icon: Icons.description,
                            ),
                          if (log.ruleId.isNotEmpty)
                            _buildDetailRow(
                              context,
                              l10n.ruleId,
                              log.ruleId,
                              icon: Icons.tag,
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                    
                    // Connection Information Section
                    _buildSectionHeader(context, l10n.connectionInformation, Icons.swap_horiz),
                    _buildDetailCard(
                      context,
                      children: [
                        _buildDetailRow(
                          context,
                          l10n.sourceAddress,
                          '${log.sourceIp}:${log.sourcePort}',
                          icon: Icons.upload,
                          copyable: true,
                        ),
                        _buildDetailRow(
                          context,
                          l10n.destinationAddress,
                          '${log.destIp}:${log.destPort}',
                          icon: Icons.download,
                          copyable: true,
                        ),
                        _buildDetailRow(
                          context,
                          l10n.protocol,
                          log.protocol.toUpperCase(),
                          icon: Icons.settings_ethernet,
                        ),
                        if (log.direction.isNotEmpty)
                          _buildDetailRow(
                            context,
                            l10n.direction,
                            log.direction == 'in' ? l10n.inbound : l10n.outbound,
                            icon: log.direction == 'in' ? Icons.arrow_downward : Icons.arrow_upward,
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Network Information Section
                    _buildSectionHeader(context, l10n.networkInformation, Icons.network_check),
                    _buildDetailCard(
                      context,
                      children: [
                        _buildDetailRow(
                          context,
                          l10n.interface,
                          log.interface.toUpperCase(),
                          icon: Icons.router,
                        ),
                        _buildDetailRow(
                          context,
                          l10n.action,
                          log.action.toUpperCase(),
                          icon: _getActionIcon(log.action),
                          valueColor: actionColor,
                        ),
                        if (log.length.isNotEmpty)
                          _buildDetailRow(
                            context,
                            l10n.packetLength,
                            '${log.length} bytes',
                            icon: Icons.data_usage,
                          ),
                        if (log.tcpFlags.isNotEmpty)
                          _buildDetailRow(
                            context,
                            l10n.tcpFlags,
                            log.tcpFlags,
                            icon: Icons.flag,
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Additional Information Section
                    _buildSectionHeader(context, l10n.additionalInformation, Icons.info_outline),
                    _buildDetailCard(
                      context,
                      children: [
                        _buildDetailRow(
                          context,
                          l10n.timestamp,
                          _formatTimestamp(log.timestamp),
                          icon: Icons.access_time,
                          copyable: true,
                        ),
                        if (log.reason.isNotEmpty)
                          _buildDetailRow(
                            context,
                            l10n.reason,
                            log.reason,
                            icon: Icons.info,
                          ),
                        if (log.label.isNotEmpty && log.label != log.ruleDescription)
                          _buildDetailRow(
                            context,
                            l10n.label,
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
                      label: Text(l10n.copyAllDetails),
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
    final l10n = AppLocalizations.of(context)!;
    Clipboard.setData(ClipboardData(text: text));
    SnackBarHelper.showInfo(context, l10n.copiedToClipboard, duration: const Duration(seconds: 1));
  }

  void _copyAllDetails(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final details = StringBuffer();
    
    details.writeln('=== ${l10n.logDetails} ===\n');
    
    if (log.ruleDescription.isNotEmpty) {
      details.writeln('${l10n.ruleInformation}:');
      details.writeln('  ${l10n.ruleDescription}: ${log.ruleDescription}');
      if (log.ruleId.isNotEmpty) {
        details.writeln('  ${l10n.ruleId}: ${log.ruleId}');
      }
      details.writeln();
    }
    
    details.writeln('${l10n.connectionInformation}:');
    details.writeln('  ${l10n.sourceAddress}: ${log.sourceIp}:${log.sourcePort}');
    details.writeln('  ${l10n.destinationAddress}: ${log.destIp}:${log.destPort}');
    details.writeln('  ${l10n.protocol}: ${log.protocol.toUpperCase()}');
    if (log.direction.isNotEmpty) {
      details.writeln('  ${l10n.direction}: ${log.direction == 'in' ? l10n.inbound : l10n.outbound}');
    }
    details.writeln();
    
    details.writeln('${l10n.networkInformation}:');
    details.writeln('  ${l10n.interface}: ${log.interface.toUpperCase()}');
    details.writeln('  ${l10n.action}: ${log.action.toUpperCase()}');
    if (log.length.isNotEmpty) {
      details.writeln('  ${l10n.packetLength}: ${log.length} bytes');
    }
    if (log.tcpFlags.isNotEmpty) {
      details.writeln('  ${l10n.tcpFlags}: ${log.tcpFlags}');
    }
    details.writeln();
    
    details.writeln('${l10n.additionalInformation}:');
    details.writeln('  ${l10n.timestamp}: ${_formatTimestamp(log.timestamp)}');
    if (log.reason.isNotEmpty) {
      details.writeln('  ${l10n.reason}: ${log.reason}');
    }
    if (log.label.isNotEmpty && log.label != log.ruleDescription) {
      details.writeln('  ${l10n.label}: ${log.label}');
    }
    
    Clipboard.setData(ClipboardData(text: details.toString()));
    SnackBarHelper.showInfo(context, l10n.allDetailsCopiedToClipboard);
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
}


