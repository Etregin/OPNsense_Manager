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
import '../../viewmodels/tailscale_settings_form_state.dart';

/// Widget for general Tailscale settings
class GeneralSettingsCard extends StatelessWidget {
  final TailscaleSettingsFormState formState;
  final VoidCallback onChanged;

  const GeneralSettingsCard({
    super.key,
    required this.formState,
    required this.onChanged,
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
              'General Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Enable Tailscale'),
              subtitle: const Text('Enable or disable the Tailscale service'),
              value: formState.enabled,
              onChanged: (value) {
                formState.enabled = value;
                onChanged();
              },
            ),
            const Divider(),
            TextFormField(
              controller: formState.loginTimeoutController,
              decoration: const InputDecoration(
                labelText: 'Login Timeout (minutes)',
                hintText: 'e.g., 60',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: formState.validateLoginTimeout,
              onChanged: (value) => onChanged(),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: formState.listenPortController,
              decoration: const InputDecoration(
                labelText: 'Listen Port',
                hintText: 'e.g., 41641',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: formState.validateListenPort,
              onChanged: (value) => onChanged(),
            ),
          ],
        ),
      ),
    );
  }
}

// Made with Bob
