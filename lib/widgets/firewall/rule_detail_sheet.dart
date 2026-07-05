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
import '../../models/firewall_rule.dart';
import '../../utils/constants.dart';
import '../../l10n/app_localizations.dart';

/// Bottom sheet widget for displaying firewall rule details
class RuleDetailSheet extends StatelessWidget {
  final FirewallRule rule;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const RuleDetailSheet({
    super.key,
    required this.rule,
    this.onEdit,
    this.onDelete,
  });

  /// Show the rule detail sheet
  static void show(
    BuildContext context, {
    required FirewallRule rule,
    VoidCallback? onEdit,
    VoidCallback? onDelete,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => RuleDetailSheet(
        rule: rule,
        onEdit: onEdit,
        onDelete: onDelete,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(AppConstants.standardPadding * 2),
          child: ListView(
            controller: scrollController,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.ruleDetails,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildDetailRow(context, l10n.description, rule.description),
              _buildDetailRow(context, l10n.type, rule.typeDisplayName),
              _buildDetailRow(context, l10n.interface, rule.interfaceName),
              _buildDetailRow(context, l10n.protocol, rule.protocolDisplayName),
              _buildDetailRow(
                context,
                l10n.source,
                '${rule.source}${rule.sourcePort != 'any' && rule.sourcePort.isNotEmpty ? ':${rule.sourcePort}' : ''}',
              ),
              _buildDetailRow(
                context,
                l10n.destination,
                '${rule.destination}${rule.destinationPort != 'any' && rule.destinationPort.isNotEmpty ? ':${rule.destinationPort}' : ''}',
              ),
              if (rule.sourcePort != 'any' && rule.sourcePort.isNotEmpty)
                _buildDetailRow(context, l10n.sourcePort, rule.sourcePort),
              if (rule.destinationPort != 'any' &&
                  rule.destinationPort.isNotEmpty)
                _buildDetailRow(
                    context, l10n.destinationPort, rule.destinationPort),
              _buildDetailRow(
                context,
                l10n.status,
                rule.isEnabled ? l10n.enabled : l10n.disabled,
              ),
              _buildDetailRow(context, l10n.sequence, rule.sequence.toString()),
              const SizedBox(height: 24),
              if (rule.isSystemGenerated)
                _buildSystemGeneratedWarning(context)
              else
                _buildActionButtons(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.disabled,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemGeneratedWarning(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: AppColors.warning, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              l10n.systemGeneratedRule,
              style: const TextStyle(
                color: AppColors.warning,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onEdit,
            icon: const Icon(Icons.edit),
            label: Text(l10n.edit),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onDelete,
            icon: const Icon(Icons.delete),
            label: Text(l10n.delete),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}


