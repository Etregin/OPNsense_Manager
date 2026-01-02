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
  
  /// Validate quota limit (must be positive number)
  static bool isValidQuotaLimit(String value) {
    if (value.isEmpty) return false;
    final num = int.tryParse(value);
    if (num == null) return false;
    return num > 0;
  }
  
  /// Get error message for host validation
  static String? validateHost(String? value) {
    if (value == null || value.isEmpty) {
      return 'Host is required';
    }
    if (!isValidHostname(value)) {
      return 'Invalid hostname or IP address';
    }
    return null;
  }
  
  /// Get error message for port validation
  static String? validatePort(String? value) {
    if (value == null || value.isEmpty) {
      return 'Port is required';
    }
    if (!isValidPort(value)) {
      return 'Port must be between 1 and 65535';
    }
    return null;
  }
  
  /// Get error message for API key validation
  static String? validateApiKey(String? value) {
    if (value == null || value.isEmpty) {
      return 'API Key is required';
    }
    if (!isValidApiKey(value)) {
      return 'Invalid API Key format';
    }
    return null;
  }
  
  /// Get error message for API secret validation
  static String? validateApiSecret(String? value) {
    if (value == null || value.isEmpty) {
      return 'API Secret is required';
    }
    if (!isValidApiSecret(value)) {
      return 'Invalid API Secret format';
    }
    return null;
  }
  
  /// Get error message for required field validation
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }
}

