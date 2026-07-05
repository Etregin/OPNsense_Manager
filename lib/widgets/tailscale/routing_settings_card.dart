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
import '../../l10n/app_localizations.dart';
import '../../models/tailscale_settings.dart';
import '../../utils/constants.dart';
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
    final l10n = AppLocalizations.of(context)!;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.routing,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: Text(l10n.advertiseExitNode),
              subtitle: Text(l10n.advertiseExitNodeDescription),
              value: formState.advertiseExitNode,
              onChanged: (value) {
                formState.advertiseExitNode = value;
                onChanged();
              },
            ),
            const Divider(),
            const SizedBox(height: 16),
            Text(l10n.useExitNode, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: formState.selectedExitNode,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                hintText: l10n.selectExitNode,
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
              title: Text(l10n.acceptSubnetRoutes),
              subtitle: Text(l10n.acceptSubnetRoutesDescription),
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
              title: Text(l10n.manageSubnets),
              subtitle: Text(l10n.configureAdvertisedSubnets),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                if (hasUnsavedChanges) {
                  final shouldNavigate = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(l10n.unsavedChanges),
                      content: Text(
                        l10n.unsavedChangesConfirmation,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text(l10n.cancel),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          style: TextButton.styleFrom(foregroundColor: AppColors.danger),
                          child: Text(l10n.discard),
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


