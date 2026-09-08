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
import '../../utils/app_colors.dart';
import '../../l10n/app_localizations.dart';

/// Full-width banner displayed at the top of a screen when demo mode is active.
class DemoModeBanner extends StatelessWidget {
  const DemoModeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: AppColors.warning,
      child: Row(
        children: [
          const Icon(Icons.play_circle_outline, color: AppColors.onPrimary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              l10n.demoModeIndicator,
              style: const TextStyle(
                color: AppColors.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Icon(
            Icons.info_outline,
            color: AppColors.onPrimary.withValues(alpha: AppColors.opacityHeavy),
            size: 20,
          ),
        ],
      ),
    );
  }
}
