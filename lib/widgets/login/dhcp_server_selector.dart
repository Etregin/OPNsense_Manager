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
import '../../models/dhcp_server_type.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/constants.dart';

/// Widget for selecting DHCP server type
class DhcpServerSelector extends StatelessWidget {
  final DhcpServerType selectedType;
  final bool isLoading;
  final ValueChanged<DhcpServerType> onChanged;

  const DhcpServerSelector({
    super.key,
    required this.selectedType,
    required this.isLoading,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.dns),
          title: Text(l10n.dhcpServerType),
          subtitle: Text(selectedType.getDisplayName(context)),
          trailing: DropdownButton<DhcpServerType>(
            value: selectedType,
            items: DhcpServerType.values.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Text(type.getDisplayName(context)),
              );
            }).toList(),
            onChanged: isLoading
                ? null
                : (value) {
                    if (value != null) {
                      onChanged(value);
                    }
                  },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            selectedType.getDescription(context),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
          ),
        ),
      ],
    );
  }
}


