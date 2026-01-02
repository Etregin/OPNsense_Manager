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
  static const String appVersion = '1.0.0';
  
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
}

/// App color constants
class AppColors {
  static const primary = Color(0xFF046371); // Deep Teal (Shield body)
  static const secondary = Color(0xFF00FFFF); // Electric Cyan (Wi-Fi signal)
  static const success = Color(0xFF4CAF50); // Green
  static const warning = Color(0xFFFF9800); // Orange
  static const error = Color(0xFFF44336); // Red
}

