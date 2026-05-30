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
import '../../models/openvpn_instance_list_item.dart';

/// Card widget for displaying OpenVPN instance information
class OpenvpnInstanceCard extends StatelessWidget {
  final OpenvpnInstanceListItem instance;
  final bool isToggling;
  final VoidCallback onTap;
  final ValueChanged<bool> onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const OpenvpnInstanceCard({
    super.key,
    required this.instance,
    required this.isToggling,
    required this.onTap,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: instance.enabled ? Colors.green : Colors.grey,
          child: Icon(
            instance.enabled ? Icons.vpn_lock : Icons.vpn_lock_outlined,
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                instance.description.isNotEmpty 
                    ? instance.description 
                    : 'Unnamed Instance',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            _buildRoleBadge(theme),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            // Protocol and Port
            if (instance.protocol != null || instance.port != null)
              Text(
                '${instance.protocol?.toUpperCase() ?? 'UDP'} • Port ${instance.port ?? 'N/A'}',
                style: TextStyle(
                  fontSize: 13,
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            // Local address
            if (instance.local != null && instance.local!.isNotEmpty)
              Text('Local: ${instance.local}'),
            // Connection info based on role
            if (instance.primaryConnectionInfo != null && 
                instance.primaryConnectionInfo!.isNotEmpty)
              Text(
                '${instance.isServer ? "Server" : "Remote"}: ${instance.primaryConnectionInfo}',
              ),
            // Device type
            if (instance.devType != null && instance.devType!.isNotEmpty)
              Text(
                'Device: ${instance.devType}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
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
                value: instance.enabled,
                onChanged: onToggle,
                activeTrackColor: Colors.green,
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
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete', style: TextStyle(color: Colors.red)),
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

  Widget _buildRoleBadge(ThemeData theme) {
    final isServer = instance.isServer;
    final color = isServer ? Colors.blue : Colors.orange;
    final label = isServer ? 'Server' : 'Client';

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


