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
  
  // UI Constants
  static const double standardPadding = 16.0;
  static const double compactPadding = 8.0;
  static const double cardElevation = 2.0;
  static const double cardBorderRadius = 12.0;
  static const double buttonBorderRadius = 8.0;
  static const double iconSize = 24.0;
  static const double featureIconSize = 48.0;
  
  // Pagination sentinels
  static const int maxPeerRowCount = 1000;  // max WireGuard peers to fetch per request
  static const int allRowsSentinel = 9999;  // sentinel value meaning "fetch all rows"

  // UI timing delays
  static const Duration toggleDebounceDelay = Duration(milliseconds: 1500); // post-toggle feedback delay
  static const Duration drawerCloseDelay    = Duration(milliseconds: 150);  // grace period for drawer close animation

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
///   Colors.black87                   → AppColors.onSurface
///   Colors.black26                   → AppColors.shadowLight
///   Colors.redAccent                 → AppColors.error
///   Colors.transparent               → AppColors.transparent
///   const Color(0xFF9E9E9E)          → AppColors.disabled
class AppColors {
  static const Color primary   = Color(0xFF046371); // Deep Teal (Shield body)
  static const Color secondary = Color(0xFF00FFFF); // Electric Cyan (Wi-Fi signal)

  // Semantic status colours
  static const Color success  = Color(0xFF4CAF50); // Colors.green
  static const Color warning  = Color(0xFFFF9800); // Colors.orange
  static const Color error    = Color(0xFFF44336); // Colors.red
  static const Color disabled = Color(0xFF9E9E9E); // Colors.grey

  // Text & icon tones (Material grey scale)
  static const Color textSecondary = Color(0xFF757575); // Colors.grey[600]
  static const Color iconMuted     = Color(0xFFBDBDBD); // Colors.grey[400]
  static const Color surfaceMid    = Color(0xFFE0E0E0); // Colors.grey[300]
  static const Color surfaceLight  = Color(0xFFEEEEEE); // Colors.grey[200]

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
  static const Color onSurface   = Color(0xDD000000); // 87% black — high-emphasis text on light surfaces
}

/// Non-translatable display strings — brand names, technical acronyms,
/// unit symbols, and form-field hint text that are identical in every locale.
/// These must never be passed through AppLocalizations.
class StringConstants {
  StringConstants._();

  // App / product names (not translated — use as-is in all locales)
  static const String wireguard    = 'WireGuard';
  static const String openvpn      = 'OpenVPN';
  static const String tailscale    = 'Tailscale';
  static const String dnsmasq      = 'Dnsmasq';
  static const String iscDhcp      = 'ISC DHCP';
  static const String keaDhcp      = 'Kea DHCP';
  static const String magicDns     = 'Magic DNS';

  // Network protocol acronyms (universally recognised — never translated)
  static const String tcp          = 'TCP';
  static const String udp          = 'UDP';
  static const String tcpUdp       = 'TCP/UDP';
  static const String icmp         = 'ICMP';
  static const String icmpv6       = 'ICMPv6';
  static const String igmp         = 'IGMP';
  static const String ipv6Protocol = 'IPv6';
  static const String ospf         = 'OSPF';
  static const String ah           = 'AH';
  static const String esp          = 'ESP';
  static const String gre          = 'GRE';
  static const String pim          = 'PIM';
  static const String http         = 'http';
  static const String https        = 'https';

  // Data unit symbols (SI / IEC — language-invariant)
  static const String unitB        = 'B';
  static const String unitKB       = 'KB';
  static const String unitMB       = 'MB';
  static const String unitGB       = 'GB';
  static const String unitTB       = 'TB';
  static const String unitPB       = 'PB';
  static const String unitPerSec   = '/s';
  static const String of1Gbps      = 'of 1 Gbps';
  static const String hourAbbrev   = 'h';
  static const String minuteAbbrev = 'm';
  static const String secondAbbrev = 's';

  // Technical hint / example text for form fields
  static const String ipv4CidrHint       = '10.8.0.0/24';
  static const String ipv6CidrHint       = 'fd00::/64';
  static const String ipv4OrIpv6CidrHint = '10.8.0.0/24 or fd00::/64';
  static const String routeGatewayHint   = '10.8.0.1';
  static const String defaultPortHint    = '443';

  // Legal / license metadata (verbatim — must not be translated)
  static const String gnuLicenseTitle = 'GNU General Public License v3.0';
}

