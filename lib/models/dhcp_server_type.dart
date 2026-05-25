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

import 'package:json_annotation/json_annotation.dart';

/// Enum representing different DHCP server types supported by OPNsense
enum DhcpServerType {
  /// dnsmasq DHCP server (lightweight, commonly used)
  @JsonValue('dnsmasq')
  dnsmasq,
  
  /// ISC DHCP server (traditional, feature-rich)
  @JsonValue('isc')
  isc,
  
  /// KEA DHCP server (modern, high-performance)
  @JsonValue('kea')
  kea;

  /// Get display name for the DHCP server type
  String get displayName {
    switch (this) {
      case DhcpServerType.dnsmasq:
        return 'dnsmasq';
      case DhcpServerType.isc:
        return 'ISC DHCP';
      case DhcpServerType.kea:
        return 'KEA DHCP';
    }
  }

  /// Get description for the DHCP server type
  String get description {
    switch (this) {
      case DhcpServerType.dnsmasq:
        return 'Lightweight DNS/DHCP server, ideal for small networks';
      case DhcpServerType.isc:
        return 'Traditional ISC DHCP server with extensive features';
      case DhcpServerType.kea:
        return 'Modern high-performance DHCP server from ISC';
    }
  }

  /// Get API endpoint path for this DHCP server type
  String get apiEndpoint {
    switch (this) {
      case DhcpServerType.dnsmasq:
        return '/dnsmasq/leases/search';
      case DhcpServerType.isc:
        return '/dhcpv4/leases/search_lease';
      case DhcpServerType.kea:
        return '/kea/leases4/search';
    }
  }

  /// Convert from string value
  static DhcpServerType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'dnsmasq':
        return DhcpServerType.dnsmasq;
      case 'isc':
        return DhcpServerType.isc;
      case 'kea':
        return DhcpServerType.kea;
      default:
        return DhcpServerType.dnsmasq; // Default fallback
    }
  }

  /// Convert to string value
  String toStringValue() {
    switch (this) {
      case DhcpServerType.dnsmasq:
        return 'dnsmasq';
      case DhcpServerType.isc:
        return 'isc';
      case DhcpServerType.kea:
        return 'kea';
    }
  }
}
