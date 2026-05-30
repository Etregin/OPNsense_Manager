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
import 'package:json_annotation/json_annotation.dart';
import '../l10n/app_localizations.dart';

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
  String getDisplayName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case DhcpServerType.dnsmasq:
        return l10n.dnsmasqServerName;
      case DhcpServerType.isc:
        return l10n.iscDhcpServerName;
      case DhcpServerType.kea:
        return l10n.keaDhcpServerName;
    }
  }

  /// Get description for the DHCP server type
  String getDescription(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case DhcpServerType.dnsmasq:
        return l10n.dnsmasqDescription;
      case DhcpServerType.isc:
        return l10n.iscDhcpDescription;
      case DhcpServerType.kea:
        return l10n.keaDhcpDescription;
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
