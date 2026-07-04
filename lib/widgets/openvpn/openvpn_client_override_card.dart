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
import '../../l10n/app_localizations.dart';
import '../../models/openvpn_client_override_list_item.dart';
import '../../utils/constants.dart';

/// Card widget for displaying OpenVPN client specific override information
class OpenvpnClientOverrideCard extends StatelessWidget {
  final OpenvpnClientOverrideListItem clientOverride;
  final bool isToggling;
  final VoidCallback onTap;
  final ValueChanged<bool> onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const OpenvpnClientOverrideCard({
    super.key,
    required this.clientOverride,
    required this.isToggling,
    required this.onTap,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: clientOverride.enabled ? AppColors.success : Theme.of(context).disabledColor,
          child: Icon(
            clientOverride.enabled ? Icons.check_circle : Icons.cancel,
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Row(
          children: [
            _buildStatusBadge(theme),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                clientOverride.description.isNotEmpty
                    ? clientOverride.description
                    : 'No Description',
                style: const TextStyle(fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            // Common Name
            if (clientOverride.commonName.isNotEmpty)
              Text(
                'Common Name: ${clientOverride.commonName}',
                style: TextStyle(
                  fontSize: 13,
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            // IPv4 Tunnel Network
            if (clientOverride.tunnelNetwork.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  children: [
                    Icon(
                      Icons.vpn_lock,
                      size: 14,
                      color: Theme.of(context).disabledColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Tunnel: ${clientOverride.tunnelNetwork}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).disabledColor,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isToggling)
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              Switch(
                value: clientOverride.enabled,
                onChanged: onToggle,
                activeTrackColor: AppColors.success,
              ),
            const SizedBox(width: 8),
            PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'edit':
                    onEdit();
                    break;
                  case 'delete':
                    onDelete();
                    break;
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      const Icon(Icons.edit),
                      const SizedBox(width: 8),
                      Text(l10n.edit),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
                      const SizedBox(width: 8),
                      Text(l10n.delete, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildStatusBadge(ThemeData theme) {
    final color = clientOverride.enabled ? AppColors.success : theme.disabledColor;
    final label = clientOverride.enabled ? 'Enabled' : 'Disabled';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}


