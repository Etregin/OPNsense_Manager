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
import '../../constants/routes.dart';
import '../../l10n/app_localizations.dart';
import '../../screens/netflow_screen.dart';
import '../../utils/app_colors.dart';
import '../../utils/constants.dart';

/// Warning banner shown when NetFlow local data collection is disabled.
///
/// Informs the user that data collection is not active and provides a button
/// to navigate to the NetFlow configuration screen.
class NetflowDisabledBanner extends StatelessWidget {
  const NetflowDisabledBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.standardPadding),
        child: Container(
          padding: const EdgeInsets.all(AppConstants.standardPadding),
          decoration: BoxDecoration(
            color: AppColors.warningBackground,
            borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
            border: Border.all(
              color: AppColors.warningIcon.withValues(
                alpha: AppColors.opacityDivider,
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: AppColors.warningIcon,
                    size: AppConstants.iconSize,
                  ),
                  const SizedBox(width: AppConstants.compactPadding),
                  Expanded(
                    child: Text(
                      l10n.netflowNotEnabled,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.warningDark,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.standardPadding),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const NetflowScreen(),
                        settings:
                            const RouteSettings(name: Routes.netflow),
                      ),
                    );
                  },
                  icon: const Icon(Icons.settings, size: 18),
                  label: Text(l10n.goToNetflowConfig),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.warningDark,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
