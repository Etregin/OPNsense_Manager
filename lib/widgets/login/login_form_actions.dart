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
import '../../utils/app_colors.dart';

/// Widget for login form action buttons
class LoginFormActions extends StatelessWidget {
  final bool isEditing;
  final bool isLoading;
  final String? loadingButton; // Which button is currently loading: 'test', 'save', or 'connect'
  final VoidCallback onTest;
  final VoidCallback onSave;
  final VoidCallback onConnect;
  final VoidCallback? onImport;

  const LoginFormActions({
    super.key,
    required this.isEditing,
    required this.isLoading,
    this.loadingButton,
    required this.onTest,
    required this.onSave,
    required this.onConnect,
    this.onImport,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Three buttons when editing
        if (isEditing) ...[
          // Test Profile Button
          OutlinedButton.icon(
            onPressed: isLoading ? null : onTest,
            icon: loadingButton == 'test'
                ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.network_check, size: 20),
            label: Text(
              l10n.testProfile,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: AppColors.opacityHalf),
                width: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Two buttons in a row: Save and Save & Connect
          Row(
            children: [
              // Save Button
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: isLoading ? null : onSave,
                  icon: loadingButton == 'save'
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save, size: 20),
                  label: Text(
                    l10n.save,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Save & Connect Button
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: isLoading ? null : onConnect,
                  icon: loadingButton == 'connect'
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.onPrimary),
                          ),
                        )
                      : const Icon(Icons.login, size: 20),
                  label: Text(
                    l10n.saveAndConnect,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: AppColors.onPrimary,
                  ),
                ),
              ),
            ],
          ),
        ],

        // Connect Button (only show when not editing)
        if (!isEditing)
          ElevatedButton(
            onPressed: isLoading ? null : onConnect,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: AppColors.onPrimary,
            ),
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.onPrimary),
                    ),
                  )
                : Text(
                    l10n.connect,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),

        const SizedBox(height: 16),

        // Import Profiles button (only show when not editing)
        if (!isEditing && onImport != null)
          OutlinedButton.icon(
            onPressed: isLoading ? null : onImport,
            icon: const Icon(Icons.upload_file),
            label: Text(l10n.importProfiles),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: AppColors.opacityHalf),
                width: 1,
              ),
            ),
          ),
      ],
    );
  }
}


