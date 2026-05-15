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

/// Validators specific to WireGuard configuration
class WireGuardValidators {
  /// Validate WireGuard key (public or private)
  static String? validateKey(String? value) {
    if (value == null || value.isEmpty) {
      return 'Key is required';
    }
    if (value.length != 44) {
      return 'Invalid key length (must be 44 characters)';
    }
    // Basic base64 validation
    final base64Pattern = RegExp(r'^[A-Za-z0-9+/]+=*$');
    if (!base64Pattern.hasMatch(value)) {
      return 'Invalid key format (must be base64)';
    }
    return null;
  }

  /// Validate MTU value
  static String? validateMTU(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }
    final mtu = int.tryParse(value);
    if (mtu == null || mtu < 576 || mtu > 9000) {
      return 'MTU must be between 576 and 9000';
    }
    return null;
  }

  /// Validate CIDR notation (IPv4 or IPv6)
  static bool isValidCIDR(String cidr) {
    final parts = cidr.split('/');
    if (parts.length != 2) return false;

    final prefix = int.tryParse(parts[1]);
    if (prefix == null) return false;

    // Check for IPv4
    if (isValidIPv4(parts[0])) {
      return prefix >= 0 && prefix <= 32;
    }

    // Check for IPv6
    if (isValidIPv6(parts[0])) {
      return prefix >= 0 && prefix <= 128;
    }

    return false;
  }

  /// Validate IPv4 address
  static bool isValidIPv4(String ip) {
    final parts = ip.split('.');
    if (parts.length != 4) return false;

    for (final part in parts) {
      final num = int.tryParse(part);
      if (num == null || num < 0 || num > 255) {
        return false;
      }
    }
    return true;
  }

  /// Validate IPv6 address
  static bool isValidIPv6(String ip) {
    // Simplified IPv6 validation
    final ipv6Pattern = RegExp(r'^([0-9a-fA-F]{0,4}:){2,7}[0-9a-fA-F]{0,4}$');
    return ipv6Pattern.hasMatch(ip);
  }

  /// Validate allowed IPs (comma-separated CIDRs)
  static String? validateAllowedIPs(String? value) {
    if (value == null || value.isEmpty) {
      return 'At least one allowed IP is required';
    }

    final ips = value.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty);
    for (final ip in ips) {
      if (!isValidCIDR(ip)) {
        return 'Invalid CIDR notation: $ip';
      }
    }
    return null;
  }

  /// Validate endpoint (host:port format)
  static String? validateEndpoint(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional for servers
    }

    final parts = value.split(':');
    if (parts.length != 2) {
      return 'Endpoint must be in format host:port';
    }

    final port = int.tryParse(parts[1]);
    if (port == null || port < 1 || port > 65535) {
      return 'Invalid port number';
    }

    return null;
  }

  /// Validate persistent keepalive
  static String? validateKeepalive(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional
    }

    final keepalive = int.tryParse(value);
    if (keepalive == null || keepalive < 0 || keepalive > 65535) {
      return 'Keepalive must be between 0 and 65535 seconds';
    }
    return null;
  }
}

// Made with Bob
