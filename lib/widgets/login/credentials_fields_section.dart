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

/// Widget for API credentials fields
class CredentialsFieldsSection extends StatelessWidget {
  final TextEditingController apiKeyController;
  final TextEditingController apiSecretController;
  final bool obscureSecret;
  final bool isLoading;
  final VoidCallback onToggleSecretVisibility;

  const CredentialsFieldsSection({
    super.key,
    required this.apiKeyController,
    required this.apiSecretController,
    required this.obscureSecret,
    required this.isLoading,
    required this.onToggleSecretVisibility,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // API Key Field
        TextFormField(
          controller: apiKeyController,
          decoration: InputDecoration(
            labelText: l10n.apiKey,
            hintText: l10n.enterYourApiKey,
            prefixIcon: const Icon(Icons.vpn_key),
          ),
          validator: Validators.validateApiKey,
          enabled: !isLoading,
        ),
        const SizedBox(height: 16),

        // API Secret Field
        TextFormField(
          controller: apiSecretController,
          decoration: InputDecoration(
            labelText: l10n.apiSecret,
            hintText: l10n.enterYourApiSecret,
            prefixIcon: const Icon(Icons.lock),
            suffixIcon: IconButton(
              icon: Icon(
                obscureSecret ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: onToggleSecretVisibility,
            ),
          ),
          obscureText: obscureSecret,
          validator: Validators.validateApiSecret,
          enabled: !isLoading,
        ),
      ],
    );
  }
}


