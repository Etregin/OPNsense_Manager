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
import '../../models/system_info.dart';
import '../../utils/app_colors.dart'; // opacityStrong
import '../../utils/constants.dart';

/// Reusable drawer header widget with app branding and system info
class DrawerHeaderWidget extends StatelessWidget {
  final SystemInfo? systemInfo;

  const DrawerHeaderWidget({
    super.key,
    this.systemInfo,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return DrawerHeader(
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(
            Icons.router,
            size: 48,
            color: colorScheme.onPrimaryContainer,
          ),
          const SizedBox(height: 8),
          Text(
            AppConstants.appName,
            style: TextStyle(
              color: colorScheme.onPrimaryContainer,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (systemInfo != null)
            Text(
              systemInfo!.hostname,
              style: TextStyle(
                color: colorScheme.onPrimaryContainer.withValues(alpha: AppColors.opacityStrong),
                fontSize: 14,
              ),
            ),
        ],
      ),
    );
  }
}


