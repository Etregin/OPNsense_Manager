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
import '../../utils/app_colors.dart';
import '../../utils/formatters.dart';

/// Widget for displaying detailed VPN connection information
class VPNDetailSection extends StatelessWidget {
  final VPNConnection connection;

  const VPNDetailSection({
    super.key,
    required this.connection,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (connection.description != null) ...[
          _buildDetailRow(l10n.description, connection.description!),
          const SizedBox(height: 8),
        ],
        if (connection.remoteAddress != null) ...[
          _buildDetailRow(l10n.remoteAddress, connection.remoteAddress!),
          const SizedBox(height: 8),
        ],
        if (connection.localAddress != null) ...[
          _buildDetailRow(l10n.localAddress, connection.localAddress!),
          const SizedBox(height: 8),
        ],
        if (connection.virtualAddress != null) ...[
          _buildDetailRow(l10n.virtualAddress, connection.virtualAddress!),
          const SizedBox(height: 8),
        ],
        if (connection.protocol != null) ...[
          _buildDetailRow(l10n.protocol, connection.protocol!),
          const SizedBox(height: 8),
        ],
        if (connection.port != null) ...[
          _buildDetailRow(l10n.port, connection.port.toString()),
          const SizedBox(height: 8),
        ],
        if (connection.bytesReceived != null || connection.bytesSent != null) ...[
          Row(
            children: [
              if (connection.bytesReceived != null)
                Expanded(
                  child: _buildDetailRow(
                    l10n.received,
                    Formatters.formatBytes(connection.bytesReceived!),
                  ),
                ),
              if (connection.bytesSent != null)
                Expanded(
                  child: _buildDetailRow(
                    l10n.sent,
                    Formatters.formatBytes(connection.bytesSent!),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
        ],
        if (connection.connectedSince != null) ...[
          _buildDetailRow(
            l10n.connectedSince,
            Formatters.formatDateTime(connection.connectedSince!),
          ),
        ],
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            '$label:',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: AppColors.disabled,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}


