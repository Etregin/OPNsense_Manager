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
import '../../models/tailscale_settings.dart';
import '../../viewmodels/tailscale_settings_form_state.dart';

/// Widget for Tailscale routing settings
class RoutingSettingsCard extends StatelessWidget {
  final TailscaleSettingsFormState formState;
  final TailscaleSettings? settings;
  final VoidCallback onChanged;
  final VoidCallback onManageSubnets;
  final bool hasUnsavedChanges;

  const RoutingSettingsCard({
    super.key,
    required this.formState,
    required this.settings,
    required this.onChanged,
    required this.onManageSubnets,
    required this.hasUnsavedChanges,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Routing',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Advertise Exit Node'),
              subtitle: const Text('Allow other devices to route through this node'),
              value: formState.advertiseExitNode,
              onChanged: (value) {
                formState.advertiseExitNode = value;
                onChanged();
              },
            ),
            const Divider(),
            const SizedBox(height: 16),
            Text('Use Exit Node', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: formState.selectedExitNode,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                hintText: 'Select exit node',
              ),
              items: [
                const DropdownMenuItem<String>(
                  value: '',
                  child: Text('None'),
                ),
                if (settings?.useExitNode != null)
                  ...settings!.useExitNode!.entries
                      .where((entry) => entry.key.isNotEmpty)
                      .map((entry) {
                    return DropdownMenuItem<String>(
                      value: entry.key,
                      child: Text(entry.value.value ?? entry.key),
                    );
                  }),
              ],
              onChanged: (value) {
                formState.selectedExitNode = value ?? '';
                onChanged();
              },
            ),
            const SizedBox(height: 16),
            const Divider(),
            SwitchListTile(
              title: const Text('Accept Subnet Routes'),
              subtitle: const Text('Accept routes advertised by other nodes'),
              value: formState.acceptSubnetRoutes,
              onChanged: (value) {
                formState.acceptSubnetRoutes = value;
                onChanged();
              },
            ),
            const Divider(),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.lan),
              title: const Text('Manage Subnets'),
              subtitle: const Text('Configure advertised subnets'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                if (hasUnsavedChanges) {
                  final shouldNavigate = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Unsaved Changes'),
                      content: const Text(
                        'You have unsaved changes. Do you want to discard them and continue?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          style: TextButton.styleFrom(foregroundColor: Colors.red),
                          child: const Text('Discard'),
                        ),
                      ],
                    ),
                  );
                  if (shouldNavigate != true) return;
                }
                onManageSubnets();
              },
            ),
          ],
        ),
      ),
    );
  }
}


