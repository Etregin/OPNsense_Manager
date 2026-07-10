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
/// Tokens marked * are light-mode only. In adaptive UI, prefer the equivalent
/// colorScheme token: infoBackground → primaryContainer, infoText/infoIcon →
/// onPrimaryContainer, warningBackground → errorContainer, warningDark →
/// onErrorContainer.
class AppColors {
  // Brand
  static const Color primary   = Color(0xFF046371); // Deep Teal
  static const Color secondary = Color(0xFF00FFFF); // Electric Cyan

  // Status
  static const Color success  = Color(0xFF4CAF50);
  static const Color warning  = Color(0xFFFF9800);
  static const Color error    = Color(0xFFF44336);
  static const Color disabled = Color(0xFF9E9E9E);

  // Informational — light-mode only *
  static const Color info            = Color(0xFF2196F3);
  static const Color infoBackground  = Color(0xFFE3F2FD);
  static const Color infoText        = Color(0xFF1565C0);
  static const Color infoIcon        = Color(0xFF1976D2);

  // Warning tones — background/text tokens are light-mode only *
  static const Color warningBackground = Color(0xFFFFF3E0);
  static const Color warningLight      = Color(0xFFFFE0B2);
  static const Color warningIcon       = Color(0xFFF57C00); // readable in both modes
  static const Color warningDark       = Color(0xFFE65100);

  // On-color
  static const Color onPrimary   = Color(0xFFFFFFFF);
  static const Color transparent = Color(0x00000000);

  // Shadow & overlay
  static const Color shadow      = Color(0x33000000); // 20% black
  static const Color shadowLight = Color(0x42000000); // 26% black
  static const Color overlay     = Color(0x8A000000); // 54% black

  // Opacity constants — use with .withValues(alpha: ...).
  // Ordered by ascending opacity.
  static const double opacityBare     = 0.05;
  static const double opacitySubtle   = 0.10;
  static const double opacityDisabled = 0.12; // M3 disabled-state backgrounds
  static const double opacityFaint    = 0.15;
  static const double opacityLight    = 0.20;
  static const double opacityDivider  = 0.30;
  static const double opacityMuted    = 0.38; // M3 disabled text/icons
  static const double opacityMedium   = 0.40;
  static const double opacityHalf     = 0.50;
  static const double opacitySubdued  = 0.60;
  static const double opacityStrong   = 0.70;
  static const double opacityHeavy    = 0.80;

  // Chart
  static const Color bandwidth = Color(0xFF9C27B0); // Purple
}
