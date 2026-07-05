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
import 'app_colors.dart';

/// Utility class providing static helpers for showing consistent SnackBars.
class SnackBarHelper {
  SnackBarHelper._();

  static void showSuccess(BuildContext context, String message, {Duration duration = const Duration(seconds: 2)}) {
    _show(context, message, backgroundColor: AppColors.success, duration: duration);
  }

  static void showError(BuildContext context, String message, {Duration duration = const Duration(seconds: 3)}) {
    _show(context, message, backgroundColor: AppColors.error, duration: duration);
  }

  static void showWarning(BuildContext context, String message, {Duration duration = const Duration(seconds: 2)}) {
    _show(context, message, backgroundColor: AppColors.warning, duration: duration);
  }

  static void showInfo(BuildContext context, String message, {Duration duration = const Duration(seconds: 2)}) {
    _show(context, message, duration: duration);
  }

  static void _show(BuildContext context, String message, {Color? backgroundColor, Duration duration = const Duration(seconds: 2)}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        // Enforce white text when a semantic background color is applied so
        // legibility is guaranteed regardless of future palette changes.
        content: Text(
          message,
          style: backgroundColor != null
              ? const TextStyle(color: AppColors.onPrimary)
              : null,
        ),
        backgroundColor: backgroundColor,
        duration: duration,
      ),
    );
  }
}
