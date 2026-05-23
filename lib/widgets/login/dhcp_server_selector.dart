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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.dns),
          title: const Text('DHCP Server Type'),
          subtitle: Text(selectedType.displayName),
          trailing: DropdownButton<DhcpServerType>(
            value: selectedType,
            items: DhcpServerType.values.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Text(type.displayName),
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
            selectedType.description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
          ),
        ),
      ],
    );
  }
}


