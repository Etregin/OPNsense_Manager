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

/// Firewall-domain constants for the OPNsense Manager app.
class FirewallConstants {
  /// All 14 alias types supported by OPNsense.
  static const List<String> aliasTypes = [
    'host',
    'network',
    'port',
    'url',
    'urltable',
    'urljson',
    'geoip',
    'networkgroup',
    'mac',
    'asn',
    'dynipv6host',
    'authgroup',
    'internal',
    'external',
  ];
}
