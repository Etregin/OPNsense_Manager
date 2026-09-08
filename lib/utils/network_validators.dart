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

/// Canonical network validation primitives shared across all validator classes.
///
/// All methods are pure static bool functions with no side effects or
/// localisation concerns — callers are responsible for producing error messages.
class NetworkValidators {
  /// Returns true if [ip] is a valid IPv4 address in dotted-decimal notation.
  ///
  /// Uses manual octet parsing (no regex) for maximum accuracy.
  static bool isValidIPv4(String ip) {
    if (ip.isEmpty) return false;

    final parts = ip.split('.');
    if (parts.length != 4) return false;

    for (final part in parts) {
      final num = int.tryParse(part);
      if (num == null || num < 0 || num > 255) return false;
    }

    return true;
  }

  /// Returns true if [ip] is a valid IPv6 address.
  ///
  /// Uses a simplified pattern that accepts the common colon-hex format.
  static bool isValidIPv6(String ip) {
    final ipv6Pattern = RegExp(r'^([0-9a-fA-F]{0,4}:){2,7}[0-9a-fA-F]{0,4}$');
    return ipv6Pattern.hasMatch(ip);
  }

  /// Returns true if [cidr] is valid CIDR notation.
  ///
  /// When [allowIPv6] is false (default) only IPv4 CIDRs are accepted.
  /// When [allowIPv6] is true both IPv4 and IPv6 CIDRs are accepted.
  static bool isValidCIDR(String cidr, {bool allowIPv6 = false}) {
    if (cidr.isEmpty) return false;

    final parts = cidr.split('/');
    if (parts.length != 2) return false;

    final prefix = int.tryParse(parts[1]);
    if (prefix == null) return false;

    if (isValidIPv4(parts[0])) {
      return prefix >= 0 && prefix <= 32;
    }

    if (allowIPv6 && isValidIPv6(parts[0])) {
      return prefix >= 0 && prefix <= 128;
    }

    return false;
  }

  /// Returns true if [value] is a valid plain IP address or CIDR notation
  /// (IPv4 or IPv6).
  static bool isValidIPOrCIDR(String value) {
    if (value.contains('/')) return isValidCIDR(value, allowIPv6: true);
    return isValidIPv4(value) || isValidIPv6(value);
  }

  /// Returns true if [port] represents a valid TCP/UDP port number (1–65535).
  static bool isValidPort(String port) {
    final num = int.tryParse(port);
    if (num == null) return false;
    return num >= 1 && num <= 65535;
  }

  /// Returns true if [portRange] is a valid single port or hyphen-delimited
  /// port range (e.g. `80` or `80-443`).
  static bool isValidPortRange(String portRange) {
    if (portRange.isEmpty) return false;

    if (!portRange.contains('-')) return isValidPort(portRange);

    final parts = portRange.split('-');
    if (parts.length != 2) return false;

    final start = int.tryParse(parts[0].trim());
    final end = int.tryParse(parts[1].trim());

    if (start == null || end == null) return false;
    if (start < 1 || start > 65535) return false;
    if (end < 1 || end > 65535) return false;
    if (start > end) return false;

    return true;
  }

  /// Returns true if [hostname] is a valid hostname or IPv4 address.
  static bool isValidHostname(String hostname) {
    if (hostname.isEmpty) return false;

    if (isValidIPv4(hostname)) return true;

    final hostnamePattern = RegExp(
      r'^([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)*[a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?$',
    );

    return hostnamePattern.hasMatch(hostname);
  }

  /// Returns true if [mac] is a valid MAC address.
  ///
  /// Accepts colon-separated (`AA:BB:CC:DD:EE:FF`), hyphen-separated
  /// (`AA-BB-CC-DD-EE-FF`), and compact (`AABBCCDDEEFF`) formats.
  static bool isValidMacAddress(String mac) {
    if (mac.isEmpty) return false;

    final macPattern = RegExp(
      r'^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$|^([0-9A-Fa-f]{12})$',
    );

    return macPattern.hasMatch(mac);
  }
}
