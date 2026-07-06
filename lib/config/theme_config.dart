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
import '../utils/app_colors.dart';
import '../utils/constants.dart';

/// Centralised theme configuration for OPNsense Manager.
///
/// Keeps theme-building logic out of [main.dart] and ensures all component
/// themes reference [AppColors] tokens explicitly, so palette changes
/// propagate without hunting for implicit fallbacks.
class ThemeConfig {
  ThemeConfig._();

  /// Converts a stored string value to a [ThemeMode].
  ///
  /// Recognises `'light'` and `'dark'`; falls back to [ThemeMode.system] for
  /// any other value (including `'system'` and null-derived empty strings).
  static ThemeMode themeModeFromString(String mode) {
    switch (mode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  /// Builds a [ThemeData] appropriate for [brightness].
  ///
  /// Uses [ColorScheme.fromSeed] seeded from [AppColors.primary] so that all
  /// automatically-generated scheme colours stay on-brand while still adapting
  /// to light / dark mode.
  static ThemeData build(Brightness brightness) {
    return ThemeData(
      primaryColor: AppColors.primary,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        secondary: AppColors.secondary,
        brightness: brightness,
      ),
      useMaterial3: true,
      cardTheme: CardThemeData(
        elevation: AppConstants.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          // Explicitly set to AppColors.onPrimary so button label colour is
          // enforced rather than relying on Material's seed-colour algorithm.
          foregroundColor: AppColors.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.buttonBorderRadius),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.buttonBorderRadius),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }
}
