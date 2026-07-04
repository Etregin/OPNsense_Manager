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
import 'network_validators.dart';

/// Utility class for input validation
class Validators {
  /// Validate IP address (IPv4)
  static bool isValidIPv4(String ip) => NetworkValidators.isValidIPv4(ip);

  /// Validate hostname
  static bool isValidHostname(String hostname) =>
      NetworkValidators.isValidHostname(hostname);

  /// Validate port number
  static bool isValidPort(String port) => NetworkValidators.isValidPort(port);

  /// Validate CIDR notation (e.g., 192.168.1.0/24)
  static bool isValidCIDR(String cidr) => NetworkValidators.isValidCIDR(cidr);

  /// Validate port range (e.g., 80-443)
  static bool isValidPortRange(String portRange) =>
      NetworkValidators.isValidPortRange(portRange);

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
  static bool isValidMacAddress(String mac) =>
      NetworkValidators.isValidMacAddress(mac);

  /// Validate quota limit (must be positive number)
  static bool isValidQuotaLimit(String value) {
    if (value.isEmpty) return false;
    final num = int.tryParse(value);
    if (num == null) return false;
    return num > 0;
  }

  /// Get error message for host validation
  static String? validateHost(String? value, BuildContext context) {
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
  static String? validatePort(String? value, BuildContext context) {
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
  static String? validateApiKey(String? value, BuildContext context) {
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
  static String? validateApiSecret(String? value, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) {
      return l10n.apiSecretIsRequired;
    }
    if (!isValidApiSecret(value)) {
      return l10n.invalidApiSecretFormat;
    }
    return null;
  }

  /// Get error message for required field validation (with l10n)
  static String? validateRequired(
      String? value, String fieldName, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (value == null || value.trim().isEmpty) {
      return l10n.fieldIsRequired(fieldName);
    }
    return null;
  }

  /// Validate that [value] is non-empty. Returns a plain-English error or null.
  ///
  /// Use this overload in form validators that do not have access to a
  /// [BuildContext] (e.g. inline `validator:` callbacks).
  static String? required(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validate that [value] is a valid port number (1–65535).
  ///
  /// Context-free overload for inline `validator:` callbacks.
  static String? port(String? value) {
    if (value == null || value.isEmpty) return null;
    if (!NetworkValidators.isValidPort(value)) {
      return 'Invalid port (must be 1-65535)';
    }
    return null;
  }

  /// Validate maximum string length.
  ///
  /// Context-free overload for inline `validator:` callbacks.
  static String? maxLength(String? value, int max,
      {String fieldName = 'This field'}) {
    if (value == null || value.isEmpty) return null;
    if (value.length > max) {
      return '$fieldName must be at most $max characters';
    }
    return null;
  }

  /// Run [validators] in order, returning the first non-null error message.
  ///
  /// Useful for combining multiple validators on a single form field.
  static String? combine(
      List<String? Function(String?)> validators, String? value) {
    for (final validator in validators) {
      final error = validator(value);
      if (error != null) return error;
    }
    return null;
  }

  /// Get error message for MAC address validation
  static String? validateMacAddress(String? value, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) {
      return l10n.macAddressIsRequired;
    }
    if (!isValidMacAddress(value)) {
      return l10n.invalidMacAddressFormat;
    }
    return null;
  }
}
