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
import '../../l10n/app_localizations.dart';
import '../../models/openvpn_static_key.dart';
import '../../utils/constants.dart';
import '../../utils/snackbar_helper.dart';
import 'package:intl/intl.dart';

/// Card widget for displaying OpenVPN static key information
class OpenvpnStaticKeyCard extends StatelessWidget {
  final OpenvpnStaticKey staticKey;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const OpenvpnStaticKeyCard({
    super.key,
    required this.staticKey,
    required this.onTap,
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
          backgroundColor: staticKey.isValid ? AppColors.success : AppColors.disabled,
          child: const Icon(
            Icons.vpn_key,
            color: AppColors.onPrimary,
            size: 20,
          ),
        ),
        title: Text(
          staticKey.description.isNotEmpty 
              ? staticKey.description 
              : 'Key ${staticKey.keyid ?? "N/A"}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            // Mode badge and creation date
            Row(
              children: [
                Expanded(
                  child: _buildModeBadge(theme),
                ),
                if (staticKey.createdAt != null) ...[
                  const SizedBox(width: 8),
                  Text(
                    '• ${_formatDate(context, staticKey.createdAt!)}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.disabled,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.copy, size: 20),
              onPressed: () => _copyKeyToClipboard(context),
              tooltip: 'Copy key',
            ),
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

  Widget _buildModeBadge(ThemeData theme) {
    final color = staticKey.isBidirectional ? theme.colorScheme.primary : theme.colorScheme.secondary;
    final label = staticKey.modeDescription;

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

  String _formatDate(BuildContext context, DateTime date) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return l10n.today;
    } else if (difference.inDays == 1) {
      return l10n.yesterday;
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return DateFormat('MMM d, yyyy').format(date);
    }
  }

  void _copyKeyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: staticKey.key));
    SnackBarHelper.showSuccess(context, 'Key copied to clipboard');
  }
}


