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
import 'package:intl/intl.dart';
import '../../models/wireguard_status.dart';

/// Card widget for displaying WireGuard status information
class StatusCard extends StatelessWidget {
  final WireGuardStatusItem item;

  const StatusCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with status indicator and interface name
            Row(
              children: [
                // Status indicator
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: item.isUp ? Colors.green : Colors.red,
                  ),
                ),
                const SizedBox(width: 12),
                // Interface name (ifname)
                Expanded(
                  child: Text(
                    item.ifname,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                // Type badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: item.isInterface ? Colors.blue.withValues(alpha: 0.1) : Colors.orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    item.type,
                    style: TextStyle(
                      color: item.isInterface ? Colors.blue : Colors.orange,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Status (up/down)
            _buildInfoRow(
              context,
              'Status',
              item.status.toUpperCase(),
              icon: Icons.power_settings_new,
              valueColor: item.isUp ? Colors.green : Colors.red,
            ),
            
            // Device (interface name like wg0, wg1)
            _buildInfoRow(
              context,
              'Device',
              item.interfaceName,
              icon: Icons.router,
            ),
            
            // Name/Description (only if not null and not empty)
            if (item.name != null && item.name!.isNotEmpty)
              _buildInfoRow(
                context,
                'Name',
                item.name!,
                icon: Icons.label,
              ),
            
            // Listen Port
            _buildInfoRow(
              context,
              'Listen Port',
              item.listenPort,
              icon: Icons.settings_ethernet,
            ),
            
            // Endpoint (only if different from listen port and not empty)
            if (item.endpoint.isNotEmpty && item.endpoint != item.listenPort)
              _buildInfoRow(
                context,
                'Endpoint',
                item.endpoint,
                icon: Icons.location_on,
              ),
            
            // Firewall Mark (only if not "off" or "0")
            if (item.fwmark.isNotEmpty && item.fwmark != 'off' && item.fwmark != '0')
              _buildInfoRow(
                context,
                'FW Mark',
                item.fwmark,
                icon: Icons.security,
              ),
            
            // Peer Status (only if not null and not empty)
            if (item.peerStatus.isNotEmpty)
              _buildInfoRow(
                context,
                'Peer Status',
                item.peerStatus,
                icon: Icons.link,
                valueColor: item.isOnline ? Colors.green : Colors.grey,
              ),
            
            // Handshake Age (only if not null)
            if (item.latestHandshakeAge != null)
              _buildInfoRow(
                context,
                'Handshake Age',
                item.latestHandshakeAge!,
                icon: Icons.access_time,
              ),
            
            // Public Key (only if value is not "(none)" and not empty)
            if (item.hasPublicKey)
              _buildInfoRow(
                context,
                'Public Key',
                item.publicKey,
                icon: Icons.vpn_key,
                monospace: true,
              ),
            
            // Handshake Timestamp (only if not null)
            if (item.latestHandshakeDateTime != null)
              _buildInfoRow(
                context,
                'Handshake',
                DateFormat('yyyy-MM-dd HH:mm:ss').format(item.latestHandshakeDateTime!),
                icon: Icons.schedule,
                monospace: true,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value, {
    IconData? icon,
    Color? valueColor,
    bool monospace = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 16,
              color: Colors.grey[600],
            ),
            const SizedBox(width: 8),
          ],
          SizedBox(
            width: 110,
            child: Text(
              '$label:',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: valueColor,
                fontFamily: monospace ? 'monospace' : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


