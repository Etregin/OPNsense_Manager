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
import '../../utils/validators.dart';

/// Widget for connection fields (host, port, HTTPS)
class ConnectionFieldsSection extends StatelessWidget {
  final TextEditingController hostController;
  final TextEditingController portController;
  final bool useHttps;
  final bool allowSelfSignedCerts;
  final bool isLoading;
  final ValueChanged<bool> onHttpsChanged;
  final ValueChanged<bool> onSelfSignedChanged;

  const ConnectionFieldsSection({
    super.key,
    required this.hostController,
    required this.portController,
    required this.useHttps,
    required this.allowSelfSignedCerts,
    required this.isLoading,
    required this.onHttpsChanged,
    required this.onSelfSignedChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Host Field
        TextFormField(
          controller: hostController,
          decoration: InputDecoration(
            labelText: l10n.hostIpAddress,
            hintText: l10n.hostPlaceholder,
            prefixIcon: const Icon(Icons.dns),
          ),
          keyboardType: TextInputType.url,
          validator: Validators.validateHost,
          enabled: !isLoading,
        ),
        const SizedBox(height: 16),

        // Port Field
        TextFormField(
          controller: portController,
          decoration: InputDecoration(
            labelText: l10n.port,
            hintText: l10n.portPlaceholder,
            prefixIcon: const Icon(Icons.settings_ethernet),
          ),
          keyboardType: TextInputType.number,
          validator: Validators.validatePort,
          enabled: !isLoading,
        ),
        const SizedBox(height: 16),

        // HTTPS Toggle
        SwitchListTile(
          title: Text(l10n.useHttps),
          subtitle: Text(l10n.recommendedForSecureConnections),
          value: useHttps,
          onChanged: isLoading ? null : onHttpsChanged,
        ),
        const SizedBox(height: 16),

        // Self-Signed Certificate Toggle
        SwitchListTile(
          title: Text(l10n.allowSelfSigned),
          subtitle: const Text(
            'WARNING: Disables TLS certificate validation for this profile. Only enable this if you trust the server and intentionally use a self-signed certificate.',
          ),
          value: allowSelfSignedCerts,
          onChanged: !useHttps || isLoading ? null : onSelfSignedChanged,
        ),
      ],
    );
  }
}

// Made with Bob
