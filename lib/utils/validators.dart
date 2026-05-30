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
import '../l10n/app_localizations.dart';

/// Utility class for input validation
class Validators {
  /// Validate IP address (IPv4)
  static bool isValidIPv4(String ip) {
    if (ip.isEmpty) return false;
    
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
  
  /// Validate hostname
  static bool isValidHostname(String hostname) {
    if (hostname.isEmpty) return false;
    
    // Allow IP addresses
    if (isValidIPv4(hostname)) return true;
    
    // Hostname regex pattern
    final hostnamePattern = RegExp(
      r'^([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)*[a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?$'
    );
    
    return hostnamePattern.hasMatch(hostname);
  }
  
  /// Validate port number
  static bool isValidPort(String port) {
    final num = int.tryParse(port);
    if (num == null) return false;
    return num >= 1 && num <= 65535;
  }
  
  /// Validate CIDR notation (e.g., 192.168.1.0/24)
  static bool isValidCIDR(String cidr) {
    if (cidr.isEmpty) return false;
    
    final parts = cidr.split('/');
    if (parts.length != 2) return false;
    
    // Validate IP part
    if (!isValidIPv4(parts[0])) return false;
    
    // Validate prefix length
    final prefix = int.tryParse(parts[1]);
    if (prefix == null || prefix < 0 || prefix > 32) {
      return false;
    }
    
    return true;
  }
  
  /// Validate port range (e.g., 80-443)
  static bool isValidPortRange(String portRange) {
    if (portRange.isEmpty) return false;
    
    // Single port
    if (!portRange.contains('-')) {
      return isValidPort(portRange);
    }
    
    // Port range
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
  
  /// Validate source/destination field (any, IP, CIDR, or alias)
  static bool isValidSourceDestination(String value) {
    if (value.isEmpty) return false;
    
    // Allow "any"
    if (value.toLowerCase() == 'any') return true;
    
    // Check if it's a valid IP
    if (isValidIPv4(value)) return true;
    
    // Check if it's a valid CIDR
    if (isValidCIDR(value)) return true;
    
    // Allow alphanumeric aliases (simplified validation)
    final aliasPattern = RegExp(r'^[a-zA-Z0-9_-]+$');
    if (aliasPattern.hasMatch(value)) return true;
    
    return false;
  }
  
  /// Validate destination port field (any, port, port range, or alias)
  static bool isValidDestinationPort(String value) {
    if (value.isEmpty) return false;
    
    // Allow "any"
    if (value.toLowerCase() == 'any') return true;
    
    // Check if it's a valid port or port range
    if (isValidPortRange(value)) return true;
    
    // Allow alphanumeric aliases (simplified validation)
    final aliasPattern = RegExp(r'^[a-zA-Z0-9_-]+$');
    if (aliasPattern.hasMatch(value)) return true;
    
    return false;
  }
  
  /// Validate API key format (basic validation)
  static bool isValidApiKey(String apiKey) {
    if (apiKey.isEmpty) return false;
    // API keys are typically alphanumeric with some special characters
    return apiKey.length >= 10;
  }
  
  /// Validate API secret format (basic validation)
  static bool isValidApiSecret(String apiSecret) {
    if (apiSecret.isEmpty) return false;
    // API secrets are typically alphanumeric with some special characters
    return apiSecret.length >= 10;
  }
  
  /// Validate non-empty string
  static bool isNotEmpty(String value) {
    return value.trim().isNotEmpty;
  }
  
  /// Validate MAC address format
  static bool isValidMacAddress(String mac) {
    if (mac.isEmpty) return false;
    
    // MAC address patterns:
    // - AA:BB:CC:DD:EE:FF
    // - AA-BB-CC-DD-EE-FF
    // - AABBCCDDEEFF
    final macPattern = RegExp(
      r'^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$|^([0-9A-Fa-f]{12})$'
    );
    
    return macPattern.hasMatch(mac);
  }
  
  /// Validate quota limit (must be positive number)
  static bool isValidQuotaLimit(String value) {
    if (value.isEmpty) return false;
    final num = int.tryParse(value);
    if (num == null) return false;
    return num > 0;
  }
  
  /// Get error message for host validation
  /// Note: BuildContext is optional for backward compatibility, but should always be provided
  static String? validateHost(String? value, [BuildContext? context]) {
    // If context is not provided, return a generic error (not recommended for production)
    if (context == null) {
      if (value == null || value.isEmpty) return 'Required';
      if (!isValidHostname(value)) return 'Invalid';
      return null;
    }
    
    final l10n = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) {
      return l10n.hostIsRequired;
    }
    if (!isValidHostname(value)) {
      return l10n.invalidHostnameOrIp;
    }
    return null;
  }
  
  /// Get error message for port validation
  /// Note: BuildContext is optional for backward compatibility, but should always be provided
  static String? validatePort(String? value, [BuildContext? context]) {
    // If context is not provided, return a generic error (not recommended for production)
    if (context == null) {
      if (value == null || value.isEmpty) return 'Required';
      if (!isValidPort(value)) return 'Invalid';
      return null;
    }
    
    final l10n = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) {
      return l10n.portIsRequired;
    }
    if (!isValidPort(value)) {
      return l10n.portMustBeBetween;
    }
    return null;
  }
  
  /// Get error message for API key validation
  /// Note: BuildContext is optional for backward compatibility, but should always be provided
  static String? validateApiKey(String? value, [BuildContext? context]) {
    // If context is not provided, return a generic error (not recommended for production)
    if (context == null) {
      if (value == null || value.isEmpty) return 'Required';
      if (!isValidApiKey(value)) return 'Invalid';
      return null;
    }
    
    final l10n = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) {
      return l10n.apiKeyIsRequired;
    }
    if (!isValidApiKey(value)) {
      return l10n.invalidApiKeyFormat;
    }
    return null;
  }
  
  /// Get error message for API secret validation
  /// Note: BuildContext is optional for backward compatibility, but should always be provided
  static String? validateApiSecret(String? value, [BuildContext? context]) {
    // If context is not provided, return a generic error (not recommended for production)
    if (context == null) {
      if (value == null || value.isEmpty) return 'Required';
      if (!isValidApiSecret(value)) return 'Invalid';
      return null;
    }
    
    final l10n = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) {
      return l10n.apiSecretIsRequired;
    }
    if (!isValidApiSecret(value)) {
      return l10n.invalidApiSecretFormat;
    }
    return null;
  }
  
  /// Get error message for required field validation
  /// Note: BuildContext is optional for backward compatibility, but should always be provided
  static String? validateRequired(String? value, String fieldName, [BuildContext? context]) {
    // If context is not provided, return a generic error (not recommended for production)
    if (context == null) {
      if (value == null || value.trim().isEmpty) return 'Required';
      return null;
    }
    
    final l10n = AppLocalizations.of(context)!;
    if (value == null || value.trim().isEmpty) {
      return l10n.fieldIsRequired(fieldName);
    }
    return null;
  }
  
  /// Get error message for MAC address validation
  static String? validateMacAddress(String? value, [BuildContext? context]) {
    // If context is not provided, return a generic error (not recommended for production)
    if (context == null) {
      if (value == null || value.isEmpty) return 'MAC address is required';
      if (!isValidMacAddress(value)) return 'Invalid MAC address format';
      return null;
    }
    
    if (value == null || value.isEmpty) {
      return 'MAC address is required';
    }
    if (!isValidMacAddress(value)) {
      return 'Invalid MAC address format (e.g., AA:BB:CC:DD:EE:FF)';
    }
    return null;
  }
}

