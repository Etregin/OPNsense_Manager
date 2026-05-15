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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.exportSuccess}\nSaved to: ${result.filePath}'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 8),
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.errorMessage ?? 'Export failed'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
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
        
        String message;
        Color backgroundColor;
        
        if (result.failedCount == 0) {
          message = l10n.successfullyImportedProfiles(result.successCount);
          backgroundColor = Colors.green;
        } else if (result.successCount == 0) {
          message = l10n.importFailedWithErrors(result.errors.join(', '));
          backgroundColor = Colors.red;
        } else {
          message = l10n.importedWithFailures(result.successCount, result.failedCount);
          backgroundColor = Colors.orange;
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: backgroundColor,
            duration: const Duration(seconds: 5),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.errors.isNotEmpty ? result.errors.first : 'Import failed'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
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
          title: 'Import & Export',
          icon: Icons.import_export,
          children: [
            ListTile(
              leading: Icon(
                Icons.upload_file,
                color: Theme.of(context).primaryColor,
              ),
              title: Text(l10n.import),
              subtitle: const Text('Import profiles from a JSON file'),
              trailing: const Icon(Icons.chevron_right),
              onTap: _importProfiles,
            ),
            const Divider(),
            ListTile(
              leading: Icon(
                Icons.download,
                color: Theme.of(context).primaryColor,
              ),
              title: const Text('Export All Profiles'),
              subtitle: const Text('Export all profiles to a JSON file'),
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
                      'About Import/Export',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  '• Export profiles to backup your configuration\n'
                  '• Choose to include or exclude API credentials\n'
                  '• Import profiles from backup files\n'
                  '• Keep both or overwrite existing profiles during import',
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
                      'Security Warning',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange[900],
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Exported files with credentials contain sensitive API keys in plain text. '
                  'Store these files securely and avoid sharing them. '
                  'Anyone with access to these files can control your OPNsense firewall.',
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


