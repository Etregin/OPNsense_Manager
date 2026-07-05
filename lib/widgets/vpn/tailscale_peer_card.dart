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
import '../../utils/constants.dart';

/// Widget for displaying a Tailscale peer card
/// This is a placeholder for future Tailscale peer display functionality
class TailscalePeerCard extends StatelessWidget {
  final String peerName;
  final String? ipAddress;
  final bool isOnline;

  const TailscalePeerCard({
    super.key,
    required this.peerName,
    this.ipAddress,
    this.isOnline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(
          isOnline ? Icons.computer : Icons.computer_outlined,
          color: isOnline ? AppColors.success : AppColors.disabled,
          size: 32,
        ),
        title: Text(
          peerName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: ipAddress != null
            ? Text(ipAddress!)
            : const Text('No IP address'),
        trailing: Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isOnline ? AppColors.success : AppColors.disabled,
          ),
        ),
      ),
    );
  }
}


