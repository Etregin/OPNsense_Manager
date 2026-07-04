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
import '../../services/settings/file_operations_service.dart';
import '../../utils/constants.dart';
import '../../utils/snackbar_helper.dart';
import '../../widgets/settings/settings_section.dart';
import '../../l10n/app_localizations.dart';

/// Screen for importing and exporting profiles
class ProfileImportExportScreen extends StatefulWidget {
  final VoidCallback onProfilesChanged;

  const ProfileImportExportScreen({
    super.key,
    required this.onProfilesChanged,
  });

  @override
  State<ProfileImportExportScreen> createState() => _ProfileImportExportScreenState();
}

class _ProfileImportExportScreenState extends State<ProfileImportExportScreen> {
  final FileOperationsService _fileOperations = FileOperationsService();

  Future<void> _exportProfiles() async {
    final l10n = AppLocalizations.of(context)!;
    
    // Show confirmation dialog for including credentials
    final includeCredentials = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.exportProfilesTitle),
        content: Text(l10n.exportProfilesContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.withoutCredentials),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.orange,
            ),
            child: Text(l10n.includeCredentials),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(null),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
    
    // User cancelled
    if (includeCredentials == null) return;
    
    final result = await _fileOperations.exportProfiles(
      includeCredentials: includeCredentials,
    );
    
    if (mounted) {
      if (result.success) {
        SnackBarHelper.showSuccess(context, '${l10n.exportSuccess}\nSaved to: ${result.filePath}', duration: const Duration(seconds: 8));
      } else {
        SnackBarHelper.showError(context, result.errorMessage ?? l10n.exportFailed, duration: const Duration(seconds: 5));
      }
    }
  }

  Future<void> _importProfiles() async {
    final l10n = AppLocalizations.of(context)!;
    
    // Show import options dialog
    final overwrite = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.importProfilesTitle),
        content: Text(l10n.importProfilesDialog),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(null),
            child: Text(l10n.cancel),
          ),
          OutlinedButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.keepBoth),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.overwrite),
          ),
        ],
      ),
    );
    
    if (overwrite == null) return; // User cancelled
    
    final result = await _fileOperations.importProfiles(
      overwrite: overwrite,
    );
    
    if (mounted) {
      if (result.success) {
        // Notify parent to reload profiles
        widget.onProfilesChanged();
        
        final String message;
        if (result.failedCount == 0) {
          message = l10n.successfullyImportedProfiles(result.successCount);
          SnackBarHelper.showSuccess(context, message, duration: const Duration(seconds: 5));
        } else if (result.successCount == 0) {
          message = l10n.importFailedWithErrors(result.errors.join(', '));
          SnackBarHelper.showError(context, message, duration: const Duration(seconds: 5));
        } else {
          message = l10n.importedWithFailures(result.successCount, result.failedCount);
          SnackBarHelper.showWarning(context, message, duration: const Duration(seconds: 5));
        }
      } else {
        final errorMessage = result.errors.isNotEmpty
            ? l10n.importFailed(result.errors.first)
            : l10n.importFailed('Unknown error');
        SnackBarHelper.showError(context, errorMessage, duration: const Duration(seconds: 5));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return ListView(
      padding: const EdgeInsets.all(AppConstants.standardPadding),
      children: [
        SettingsSection(
          title: l10n.importAndExport,
          icon: Icons.import_export,
          children: [
            ListTile(
              leading: Icon(
                Icons.upload_file,
                color: Theme.of(context).primaryColor,
              ),
              title: Text(l10n.import),
              subtitle: Text(l10n.importProfilesSubtitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: _importProfiles,
            ),
            const Divider(),
            ListTile(
              leading: Icon(
                Icons.download,
                color: Theme.of(context).primaryColor,
              ),
              title: Text(l10n.exportAllProfiles),
              subtitle: Text(l10n.exportAllProfilesSubtitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: _exportProfiles,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue[700]),
                    const SizedBox(width: 8),
                    Text(
                      l10n.aboutImportExport,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.importExportDescription,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          color: Colors.orange[50],
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.warning_amber, color: Colors.orange[700]),
                    const SizedBox(width: 8),
                    Text(
                      l10n.securityWarning,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange[900],
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.exportCredentialsWarning,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.orange[900],
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}


