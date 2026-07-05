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

/// App-wide constants
class AppConstants {
  // App Information
  static const String appName = 'OPNsense Manager';

  // API Configuration
  static const int defaultPort = 443;
  static const bool defaultUseHttps = true;
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration connectionTestTimeout = Duration(seconds: 10);
  
  // Refresh Intervals
  static const Duration dashboardRefreshInterval = Duration(seconds: 30);
  static const Duration minRefreshInterval = Duration(seconds: 5);
  
  // Storage Keys
  static const String keyHost = 'host';
  static const String keyPort = 'port';
  static const String keyApiKey = 'api_key';
  static const String keyApiSecret = 'api_secret';
  static const String keyUseHttps = 'use_https';
  
  // Theme Colors - Matching OPNsense Manager Logo
  static const int primaryColorValue = 0xFF046371; // Deep Teal (Shield body)
  static const int secondaryColorValue = 0xFF00FFFF; // Electric Cyan (Wi-Fi signal)
  static const int successColorValue = 0xFF4CAF50; // Green
  static const int warningColorValue = 0xFFFF9800; // Orange
  static const int errorColorValue = 0xFFF44336; // Red
  
  // UI Constants
  static const double standardPadding = 16.0;
  static const double compactPadding = 8.0;
  static const double cardElevation = 2.0;
  static const double cardBorderRadius = 12.0;
  static const double buttonBorderRadius = 8.0;
  static const double iconSize = 24.0;
  static const double featureIconSize = 48.0;
  
  // Domain Constants
  static const int defaultWireGuardPort = 51820;
  static const String tailscaleLoginServer = 'https://login.tailscale.com';

  // Supported Languages
  static const Map<String, String> supportedLanguages = {
    'en': 'English',
    'ar': 'العربية',
    'es': 'Español',
    'fr': 'Français',
    'de': 'Deutsch',
  };
}

/// App color constants
class AppColors {
  static const Color primary   = Color(0xFF046371); // Deep Teal (Shield body)
  static const Color secondary = Color(0xFF00FFFF); // Electric Cyan (Wi-Fi signal)

  // Semantic status colours
  static const Color success = Color(0xFF4CAF50); // Colors.green
  static const Color warning = Color(0xFFFF9800); // Colors.orange
  static const Color error   = Color(0xFFF44336); // Colors.red
  static const Color danger  = Color(0xFFF44336); // Colors.red (alias for error)
  static const Color disabled = Color(0xFF9E9E9E); // Colors.grey

  // Online / offline aliases (semantic clarity at call sites)
  static const Color online  = Color(0xFF4CAF50); // Colors.green  (= success)
  static const Color offline = Color(0xFF9E9E9E); // Colors.grey   (= disabled)

  // Text & icon tones (Material grey scale)
  static const Color textSecondary = Color(0xFF757575); // Colors.grey[600]
  static const Color iconMuted     = Color(0xFFBDBDBD); // Colors.grey[400]
  static const Color surfaceMid    = Color(0xFFE0E0E0); // Colors.grey[300]
  static const Color surfaceLight  = Color(0xFFEEEEEE); // Colors.grey[200]

  // Informational
  static const Color info            = Color(0xFF2196F3); // Colors.blue
  static const Color infoBackground  = Color(0xFFE3F2FD); // Colors.blue[50]
  static const Color infoText        = Color(0xFF1565C0); // Colors.blue[900]
}

