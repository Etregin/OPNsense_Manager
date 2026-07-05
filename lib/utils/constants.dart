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

