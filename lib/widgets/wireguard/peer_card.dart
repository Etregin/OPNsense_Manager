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
import '../../models/wireguard_peer.dart';

/// Card widget for displaying WireGuard peer information
class PeerCard extends StatelessWidget {
  final WireGuardPeer peer;
  final bool isToggling;
  final VoidCallback onTap;
  final ValueChanged<bool> onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const PeerCard({
    super.key,
    required this.peer,
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
          backgroundColor: peer.isEnabled ? Colors.green : Colors.grey,
          child: Icon(
            peer.isEnabled ? Icons.vpn_key : Icons.vpn_key_off,
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          peer.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (peer.serverName != null && peer.serverName!.isNotEmpty)
              Text(
                'Server: ${peer.serverName}',
                style: TextStyle(
                  fontSize: 13,
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            Text('Tunnel: ${peer.tunneladdress}'),
            Text('Endpoint: ${peer.serveraddress}:${peer.serverport}'),
            if (peer.keepaliveInterval != null)
              Text(
                'Keepalive: ${peer.keepaliveInterval}s',
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
                value: peer.isEnabled,
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
}

// Made with Bob
