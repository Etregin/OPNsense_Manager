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
import '../../models/vpn_connection.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/constants.dart';
import 'vpn_detail_section.dart';

/// Widget for displaying a single VPN connection card
class VPNConnectionCard extends StatelessWidget {
  final VPNConnection connection;
  final VoidCallback onToggle;
  final VoidCallback onRestartService;

  const VPNConnectionCard({
    super.key,
    required this.connection,
    required this.onToggle,
    required this.onRestartService,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: Icon(
          _getVPNIcon(connection.type),
          color: connection.isConnected ? AppColors.success : AppColors.disabled,
          size: 32,
        ),
        title: Text(
          connection.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(connection.typeDisplay),
            Row(
              children: [
                Icon(
                  connection.isConnected ? Icons.check_circle : Icons.cancel,
                  size: 16,
                  color: connection.isConnected ? AppColors.success : AppColors.error,
                ),
                const SizedBox(width: 4),
                Text(
                  connection.statusDisplay,
                  style: TextStyle(
                    color: connection.isConnected ? AppColors.success : AppColors.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                connection.isConnected ? Icons.stop : Icons.play_arrow,
                color: connection.isConnected ? AppColors.error : AppColors.success,
              ),
              onPressed: onToggle,
              tooltip: connection.isConnected ? l10n.disconnect : l10n.connect,
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                if (value == 'restart_service') {
                  onRestartService();
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'restart_service',
                  child: Text('${l10n.restart} ${connection.typeDisplay} Service'),
                ),
              ],
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: VPNDetailSection(connection: connection),
          ),
        ],
      ),
    );
  }

  IconData _getVPNIcon(String type) {
    switch (type.toLowerCase()) {
      case 'openvpn':
        return Icons.vpn_key;
      case 'wireguard':
        return Icons.security;
      case 'tailscale':
        return Icons.cloud_queue;
      default:
        return Icons.vpn_lock_outlined;
    }
  }
}


