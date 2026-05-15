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
import '../../utils/common_validators.dart';

/// Widget for WireGuard client server connection settings
class ClientServerSettingsCard extends StatelessWidget {
  final TextEditingController serverAddressController;
  final TextEditingController serverPortController;
  final TextEditingController serverPublicKeyController;
  final bool isLoading;

  const ClientServerSettingsCard({
    super.key,
    required this.serverAddressController,
    required this.serverPortController,
    required this.serverPublicKeyController,
    this.isLoading = false,
  });

  String? _validateServerAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Server address is required';
    }
    // Allow IP addresses or hostnames
    if (WireGuardValidators.isValidIPv4(value) || 
        WireGuardValidators.isValidIPv6(value)) {
      return null;
    }
    // Basic hostname validation
    final hostnamePattern = RegExp(
      r'^[a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?(\.[a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?)*$'
    );
    if (hostnamePattern.hasMatch(value)) {
      return null;
    }
    return 'Invalid server address';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Server Address
        TextFormField(
          controller: serverAddressController,
          decoration: const InputDecoration(
            labelText: 'Server Address',
            hintText: 'vpn.example.com or 203.0.113.1',
            prefixIcon: Icon(Icons.dns),
            helperText: 'IP address or hostname of the WireGuard server',
          ),
          validator: _validateServerAddress,
          enabled: !isLoading,
        ),
        const SizedBox(height: 16),

        // Server Port
        TextFormField(
          controller: serverPortController,
          decoration: const InputDecoration(
            labelText: 'Server Port',
            hintText: '51820',
            prefixIcon: Icon(Icons.settings_ethernet),
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Port is required';
            }
            return CommonValidators.port(value);
          },
          enabled: !isLoading,
        ),
        const SizedBox(height: 16),

        // Server Public Key
        TextFormField(
          controller: serverPublicKeyController,
          decoration: const InputDecoration(
            labelText: 'Server Public Key',
            prefixIcon: Icon(Icons.vpn_key),
            helperText: 'Public key of the WireGuard server',
          ),
          validator: WireGuardValidators.validateKey,
          enabled: !isLoading,
          maxLines: 2,
        ),
      ],
    );
  }
}

// Made with Bob