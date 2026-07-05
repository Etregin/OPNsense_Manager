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

/// Widget for displaying a single firewall rule card
class FirewallRuleCard extends StatelessWidget {
  final FirewallRule rule;
  final VoidCallback onTap;
  final ValueChanged<bool>? onToggle;

  const FirewallRuleCard({
    super.key,
    required this.rule,
    required this.onTap,
    this.onToggle,
  });

  Color _getTypeColor() {
    switch (rule.type.toLowerCase()) {
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

  IconData _getTypeIcon() {
    switch (rule.type.toLowerCase()) {
      case 'pass':
        return Icons.check_circle;
      case 'block':
        return Icons.block;
      case 'reject':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.standardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getTypeColor().withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getTypeIcon(),
                      color: _getTypeColor(),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          rule.description.isEmpty
                              ? l10n.unnamedRule
                              : rule.description,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${rule.typeDisplayName} • ${rule.interfaceName} • ${rule.protocolDisplayName}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: rule.isEnabled,
                    onChanged: rule.isSystemGenerated ? null : onToggle,
                    activeTrackColor: AppColors.success,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceMid : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildRuleInfo(
                        context,
                        l10n.source,
                        '${rule.source}${rule.sourcePort != 'any' && rule.sourcePort.isNotEmpty ? ':${rule.sourcePort}' : ''}',
                        Icons.arrow_forward,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward,
                      size: 16,
                      color: isDark ? AppColors.iconMuted : AppColors.textSecondary,
                    ),
                    Expanded(
                      child: _buildRuleInfo(
                        context,
                        l10n.destination,
                        '${rule.destination}${rule.destinationPort != 'any' && rule.destinationPort.isNotEmpty ? ':${rule.destinationPort}' : ''}',
                        Icons.location_on,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRuleInfo(
      BuildContext context, String label, String value, IconData icon) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: isDark ? AppColors.iconMuted : AppColors.textSecondary,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: isDark ? AppColors.iconMuted : AppColors.textSecondary,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.surfaceLight : AppColors.onSurface,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}


