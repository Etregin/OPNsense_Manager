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
import '../../models/profile.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/constants.dart';

/// A reusable card widget for displaying profile information
class ProfileCard extends StatelessWidget {
  final Profile profile;
  final bool isActive;
  final VoidCallback? onTap;
  final VoidCallback? onActivate;
  final VoidCallback? onEdit;
  final VoidCallback? onExport;
  final VoidCallback? onDelete;

  const ProfileCard({
    super.key,
    required this.profile,
    required this.isActive,
    this.onTap,
    this.onActivate,
    this.onEdit,
    this.onExport,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isActive 
              ? Theme.of(context).primaryColor
              : AppColors.iconMuted,
          child: Icon(
            isActive ? Icons.check : Icons.dns,
            color: Colors.white,
          ),
        ),
        title: Text(
          profile.name,
          style: TextStyle(
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: Text(
          '${profile.useHttps ? 'https' : 'http'}://${profile.host}:${profile.port}',
          style: const TextStyle(fontSize: 12),
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'activate':
                onActivate?.call();
                break;
              case 'edit':
                onEdit?.call();
                break;
              case 'export':
                onExport?.call();
                break;
              case 'delete':
                onDelete?.call();
                break;
            }
          },
          itemBuilder: (context) => [
            if (!isActive)
              PopupMenuItem(
                value: 'activate',
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, size: 20),
                    const SizedBox(width: 12),
                    Text(l10n.activate),
                  ],
                ),
              ),
            PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  const Icon(Icons.edit, size: 20),
                  const SizedBox(width: 12),
                  Text(l10n.edit),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'export',
              child: Row(
                children: [
                  const Icon(Icons.download, size: 20),
                  const SizedBox(width: 12),
                  Text(l10n.exportThisProfile),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  const Icon(Icons.delete, size: 20, color: AppColors.danger),
                  const SizedBox(width: 12),
                  Text(l10n.delete, style: const TextStyle(color: AppColors.danger)),
                ],
              ),
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}


