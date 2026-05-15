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
import '../../utils/wireguard_validators.dart';

/// Widget for WireGuard peer settings (endpoint, keepalive, PSK)
class PeerSettingsCard extends StatelessWidget {
  final TextEditingController endpointController;
  final TextEditingController keepaliveController;
  final TextEditingController pskController;
  final bool enabled;
  final ValueChanged<bool> onEnabledChanged;
  final bool isLoading;

  const PeerSettingsCard({
    super.key,
    required this.endpointController,
    required this.keepaliveController,
    required this.pskController,
    required this.enabled,
    required this.onEnabledChanged,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Endpoint
        TextFormField(
          controller: endpointController,
          decoration: const InputDecoration(
            labelText: 'Endpoint (Optional)',
            hintText: 'vpn.example.com:51820',
            prefixIcon: Icon(Icons.dns),
            helperText: 'Format: host:port (e.g., vpn.example.com:51820)',
          ),
          validator: WireGuardValidators.validateEndpoint,
          enabled: !isLoading,
        ),
        const SizedBox(height: 16),

        // Keepalive
        TextFormField(
          controller: keepaliveController,
          decoration: const InputDecoration(
            labelText: 'Keepalive Interval (Optional)',
            hintText: '25',
            prefixIcon: Icon(Icons.timer),
            helperText: 'Seconds (0-65535). Recommended: 25 for NAT traversal',
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: WireGuardValidators.validateKeepalive,
          enabled: !isLoading,
        ),
        const SizedBox(height: 16),

        // Pre-shared Key
        TextFormField(
          controller: pskController,
          decoration: const InputDecoration(
            labelText: 'Pre-shared Key (Optional)',
            prefixIcon: Icon(Icons.security),
            helperText: 'Additional layer of symmetric encryption',
          ),
          obscureText: true,
          enabled: !isLoading,
        ),
        const SizedBox(height: 16),

        // Enabled Switch
        SwitchListTile(
          title: const Text('Enabled'),
          subtitle: const Text('Peer will be active when enabled'),
          value: enabled,
          onChanged: isLoading ? null : onEnabledChanged,
        ),
      ],
    );
  }
}

// Made with Bob