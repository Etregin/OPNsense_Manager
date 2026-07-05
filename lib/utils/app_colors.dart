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

/// Centralised colour palette for OPNsense Manager.
///
/// Groups:
///   • Brand       — primary, secondary
///   • Status      — success, warning, error, disabled
///   • Text/Surface — textSecondary, iconMuted, surfaceMid, surfaceLight
///   • Info         — info, infoBackground, infoText, infoIcon
///   • Warning tones — warningBackground, warningLight, warningIcon, warningDark
///   • On-color/Surface tokens — onPrimary, transparent
///   • Shadow/Overlay tokens   — shadow, shadowLight, overlay, onSurface
///
/// MIGRATION REFERENCE (old → new):
///   AppConstants.primaryColorValue   → AppColors.primary
///   AppConstants.secondaryColorValue → AppColors.secondary
///   AppConstants.successColorValue   → AppColors.success
///   AppConstants.warningColorValue   → AppColors.warning
///   AppConstants.errorColorValue     → AppColors.error
///   AppColors.danger                 → AppColors.error       (removed — identical value)
///   AppColors.online                 → AppColors.success     (removed — identical value)
///   AppColors.offline                → AppColors.disabled    (removed — identical value)
///   Colors.white (on coloured bg)    → AppColors.onPrimary
///   Colors.white (dark-mode ternary) → Theme.of(ctx).colorScheme.onSurface
///   Colors.white70                   → AppColors.onPrimary.withValues(alpha: 0.7)
///   Colors.black.withValues(a:0.2)   → AppColors.shadow
///   Colors.black.withValues(a:0.1)   → AppColors.shadow.withValues(alpha: 0.5)
///   Colors.black54                   → AppColors.overlay
///   Colors.black87                   → Theme.of(ctx).colorScheme.onSurface  (was AppColors.onSurface)
///   Colors.black26                   → AppColors.shadowLight
///   Colors.redAccent                 → AppColors.error
///   Colors.transparent               → AppColors.transparent
///   const Color(0xFF9E9E9E)          → AppColors.disabled
///
/// REMOVED TOKENS (replaced with dynamic colorScheme equivalents for dark-mode correctness):
///   AppColors.textSecondary          → Theme.of(ctx).colorScheme.onSurfaceVariant
///   AppColors.iconMuted              → Theme.of(ctx).colorScheme.onSurfaceVariant
///   AppColors.surfaceLight           → Theme.of(ctx).colorScheme.surfaceContainerHighest
///   AppColors.surfaceMid             → Theme.of(ctx).colorScheme.surfaceContainerHighest
///   AppColors.surfaceMid (border)    → Theme.of(ctx).colorScheme.outlineVariant
///   AppColors.onSurface (text)       → Theme.of(ctx).colorScheme.onSurface
///   AppColors.onSurface (tooltip bg) → Theme.of(ctx).colorScheme.inverseSurface
///   Tooltip text on inverseSurface   → Theme.of(ctx).colorScheme.onInverseSurface
class AppColors {
  static const Color primary   = Color(0xFF046371); // Deep Teal (Shield body)
  static const Color secondary = Color(0xFF00FFFF); // Electric Cyan (Wi-Fi signal)

  // Semantic status colours
  static const Color success  = Color(0xFF4CAF50); // Colors.green
  static const Color warning  = Color(0xFFFF9800); // Colors.orange
  static const Color error    = Color(0xFFF44336); // Colors.red
  static const Color disabled = Color(0xFF9E9E9E); // Colors.grey

  // Informational
  static const Color info            = Color(0xFF2196F3); // Colors.blue
  static const Color infoBackground  = Color(0xFFE3F2FD); // Colors.blue[50]
  static const Color infoText        = Color(0xFF1565C0); // Colors.blue[900]
  static const Color infoIcon        = Color(0xFF1976D2); // Colors.blue[700]

  // Warning tones (orange scale)
  static const Color warningBackground = Color(0xFFFFF3E0); // Colors.orange[50]
  static const Color warningLight      = Color(0xFFFFE0B2); // Colors.orange[100]  (shade100)
  static const Color warningIcon       = Color(0xFFF57C00); // Colors.orange[700]
  static const Color warningDark       = Color(0xFFE65100); // Colors.orange[900]

  // On-color & surface tokens
  static const Color onPrimary  = Color(0xFFFFFFFF); // White — text/icons on primary-coloured surfaces
  static const Color transparent = Color(0x00000000); // Fully transparent

  // Shadow & overlay tokens
  static const Color shadow      = Color(0x33000000); // 20% black — card/logo drop-shadows
  static const Color shadowLight = Color(0x42000000); // 26% black — tooltip shadows
  static const Color overlay     = Color(0x8A000000); // 54% black — loading modal overlay

  // Opacity constants — use with .withValues(alpha: ...)
  static const double opacitySubtle   = 0.10; // icon/status container backgrounds
  static const double opacityDisabled = 0.12; // disabled-state backgrounds (M3 standard)
  static const double opacityMuted    = 0.38; // disabled text/icons (M3 standard)

  // Chart / Miscellaneous
  static const Color bandwidth = Color(0xFF9C27B0); // Purple — total-bandwidth stat chip
}
