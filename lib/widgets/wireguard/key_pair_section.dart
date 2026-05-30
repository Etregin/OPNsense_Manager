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
import '../../utils/wireguard_validators.dart';

/// Widget for WireGuard key pair input and generation
class KeyPairSection extends StatelessWidget {
  final TextEditingController publicKeyController;
  final TextEditingController privateKeyController;
  final VoidCallback onGenerateKeys;
  final bool isLoading;
  final bool isGenerating;

  const KeyPairSection({
    super.key,
    required this.publicKeyController,
    required this.privateKeyController,
    required this.onGenerateKeys,
    this.isLoading = false,
    this.isGenerating = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        // Public Key
        TextFormField(
          controller: publicKeyController,
          decoration: InputDecoration(
            labelText: l10n.publicKey,
            prefixIcon: const Icon(Icons.vpn_key),
            helperText: l10n.base64EncodedPublicKey,
          ),
          validator: WireGuardValidators.validateKey,
          enabled: !isLoading && !isGenerating,
          maxLines: 2,
        ),
        const SizedBox(height: 16),

        // Private Key
        TextFormField(
          controller: privateKeyController,
          decoration: InputDecoration(
            labelText: l10n.privateKey,
            prefixIcon: const Icon(Icons.lock),
            helperText: l10n.base64EncodedPrivateKeyKeepSecret,
          ),
          validator: WireGuardValidators.validateKey,
          enabled: !isLoading && !isGenerating,
          obscureText: true,
          maxLines: 1,
        ),
        const SizedBox(height: 8),

        // Generate Keys Button
        ElevatedButton.icon(
          onPressed: isLoading || isGenerating ? null : onGenerateKeys,
          icon: isGenerating
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.refresh),
          label: Text(isGenerating ? l10n.generating : l10n.generateKeyPair),
        ),
      ],
    );
  }
}


