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
import 'package:provider/provider.dart';
import '../../constants/routes.dart';
import '../../l10n/app_localizations.dart';
import '../../screens/system_info_screen.dart';
import '../../services/opnsense_api_service.dart';
import '../../services/app_version_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/constants.dart';
import '../../utils/snackbar_helper.dart';
import 'navigation_tile.dart';

/// System navigation section for the app drawer
class SystemNavigationSection extends StatelessWidget {
  final String currentRoute;
  final Future<bool> Function()? onBeforeNavigate;

  const SystemNavigationSection({
    super.key,
    required this.currentRoute,
    this.onBeforeNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        NavigationTile(
          icon: Icons.info_outline,
          title: l10n.systemInformation,
          currentRoute: currentRoute,
          targetRoute: Routes.systemInfo,
          destination: const SystemInfoScreen(),
          onBeforeNavigate: onBeforeNavigate,
        ),
        ListTile(
          leading: const Icon(Icons.restart_alt, color: AppColors.error),
          title: Text(
            l10n.rebootSystem,
            style: const TextStyle(color: AppColors.error),
          ),
          onTap: () {
            Navigator.pop(context);
            _rebootFirewall(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.help_outline),
          title: Text(l10n.about),
          onTap: () {
            Navigator.pop(context);
            _showAboutDialog(context);
          },
        ),
      ],
    );
  }

  Future<void> _rebootFirewall(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.warning, color: AppColors.warning),
            const SizedBox(width: 8),
            Text(l10n.rebootSystem),
          ],
        ),
        content: Text(l10n.rebootConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(l10n.restart),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        // Show loading indicator
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(l10n.loading),
              ],
            ),
          ),
        );

        final apiService = context.read<OPNsenseApiService>();
        await apiService.rebootSystem();

        if (context.mounted) {
          Navigator.of(context).pop(); // Close loading dialog
          
          SnackBarHelper.showError(context, l10n.rebootSuccess, duration: const Duration(seconds: 5));
        }
      } catch (e) {
        if (context.mounted) {
          Navigator.of(context).pop(); // Close loading dialog
          
          SnackBarHelper.showError(context, l10n.rebootFailedWithError(l10n.rebootFailed, e.toString()));
        }
      }
    }
  }

  void _showAboutDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showAboutDialog(
      context: context,
      applicationName: AppConstants.appName,
      applicationVersion: context.read<AppVersionService>().version,
      applicationIcon: const Icon(Icons.router, size: 48),
      applicationLegalese: '© 2026 OPNsense Manager\n\nLicensed under GNU General Public License v3.0\n\nThis program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.',
      children: [
        const SizedBox(height: 16),
        Text(
          l10n.aboutDescription,
          style: const TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 16),
        Text(
          l10n.featuresTitle,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        Text(
          l10n.featuresList,
          style: const TextStyle(fontSize: 13),
        ),
        const SizedBox(height: 16),
        Builder(
          builder: (builderContext) {
            final l10n = AppLocalizations.of(builderContext)!;
            return TextButton.icon(
              onPressed: () {
                showDialog(
                  context: builderContext,
                  builder: (dialogContext) {
                    final l10n = AppLocalizations.of(dialogContext)!;
                    return AlertDialog(
                      title: const Text(StringConstants.gnuLicenseTitle),
                      content: const SingleChildScrollView(
                        child: Text(
                          'This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.\n\nThis program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.\n\nYou should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.\n\nWhy GPLv3?\n\n• Ensures the software remains free and open source\n• Any modifications or derivatives must also be open source\n• Users have the freedom to use, study, share, and modify the software\n• The community benefits from improvements and contributions',
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(dialogContext).pop(),
                          child: Text(l10n.close),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.gavel),
              label: Text(l10n.viewFullLicense),
            );
          },
        ),
      ],
    );
  }
}


