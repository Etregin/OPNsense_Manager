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
import '../../viewmodels/tailscale_settings_form_state.dart';

/// Widget for Tailscale DNS settings
class DnsSettingsCard extends StatelessWidget {
  final TailscaleSettingsFormState formState;
  final VoidCallback onChanged;

  const DnsSettingsCard({
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
              'DNS',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Accept DNS'),
              subtitle: const Text('Use DNS servers provided by Tailscale'),
              value: formState.acceptDNS,
              onChanged: (value) {
                formState.acceptDNS = value;
                onChanged();
              },
            ),
          ],
        ),
      ),
    );
  }
}


