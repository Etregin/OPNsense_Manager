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

import 'dart:async';
import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/snackbar_helper.dart';

/// Service for managing navigation and route handling in the app drawer
class NavigationService {
  /// Navigate to a screen with optional unsaved changes check
  static Future<void> navigateWithCheck({
    required BuildContext context,
    required Widget destination,
    required String currentRoute,
    required String targetRoute,
    Future<bool> Function()? onBeforeNavigate,
  }) async {
    // If already on target route, just close drawer
    if (currentRoute == targetRoute) {
      Navigator.pop(context);
      return;
    }

    // Check if there's a callback and if navigation should proceed
    if (onBeforeNavigate != null) {
      final shouldNavigate = await onBeforeNavigate();
      if (!shouldNavigate) return;
    }

    // Navigate to destination
    if (context.mounted) {
      unawaited(
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => destination),
        ),
      );
    }
  }

  /// Navigate to a screen without unsaved changes check
  static void navigate({
    required BuildContext context,
    required Widget destination,
    required String currentRoute,
    required String targetRoute,
  }) {
    // If already on target route, just close drawer
    if (currentRoute == targetRoute) {
      Navigator.pop(context);
      return;
    }

    // Navigate to destination
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => destination),
    );
  }

  /// Check if a route is currently active
  static bool isRouteActive(String currentRoute, String targetRoute) {
    return currentRoute == targetRoute;
  }

  /// Check if a route starts with a specific prefix (for expansion state)
  static bool isRouteInSection(String currentRoute, String prefix) {
    return currentRoute.startsWith(prefix);
  }

  /// Show a "coming soon" snackbar and close drawer
  static void showComingSoon(BuildContext context, String feature) {
    final l10n = AppLocalizations.of(context)!;
    Navigator.pop(context);
    SnackBarHelper.showInfo(context, l10n.featureComingSoon(feature));
  }
}


