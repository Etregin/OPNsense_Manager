import 'network_validators.dart';

class CommonValidators {
  static String? required(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? ipAddress(String? value) {
    if (value == null || value.isEmpty) return null;
    if (!NetworkValidators.isValidIPv4(value)) {
      return 'Invalid IP address';
    }
    return null;
  }

  static String? cidr(String? value) {
    if (value == null || value.isEmpty) return null;
    if (!NetworkValidators.isValidCIDR(value)) {
      return 'Invalid CIDR notation (use format: IP/prefix)';
    }
    return null;
  }

  static String? port(String? value) {
    if (value == null || value.isEmpty) return null;
    if (!NetworkValidators.isValidPort(value)) {
      return 'Invalid port (must be 1-65535)';
    }
    return null;
  }

  static String? url(String? value) {
    if (value == null || value.isEmpty) return null;
    
    final urlPattern = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$'
    );
    
    if (!urlPattern.hasMatch(value)) {
      return 'Invalid URL';
    }
    return null;
  }

  static String? minLength(String? value, int min, {String fieldName = 'This field'}) {
    if (value == null || value.isEmpty) return null;
    
    if (value.length < min) {
      return '$fieldName must be at least $min characters';
    }
    return null;
  }

  static String? maxLength(String? value, int max, {String fieldName = 'This field'}) {
    if (value == null || value.isEmpty) return null;
    
    if (value.length > max) {
      return '$fieldName must be at most $max characters';
    }
    return null;
  }

  static String? combine(List<String? Function(String?)> validators, String? value) {
    for (final validator in validators) {
      final error = validator(value);
      if (error != null) return error;
    }
    return null;
  }
}


