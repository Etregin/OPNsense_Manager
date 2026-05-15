class CommonValidators {
  static String? required(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? ipAddress(String? value) {
    if (value == null || value.isEmpty) return null;
    
    final ipv4Pattern = RegExp(
      r'^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$'
    );
    
    if (!ipv4Pattern.hasMatch(value)) {
      return 'Invalid IP address';
    }
    return null;
  }

  static String? cidr(String? value) {
    if (value == null || value.isEmpty) return null;
    
    final parts = value.split('/');
    if (parts.length != 2) {
      return 'Invalid CIDR notation (use format: IP/prefix)';
    }
    
    final ipError = ipAddress(parts[0]);
    if (ipError != null) return ipError;
    
    final prefix = int.tryParse(parts[1]);
    if (prefix == null || prefix < 0 || prefix > 32) {
      return 'Invalid CIDR prefix (must be 0-32)';
    }
    
    return null;
  }

  static String? port(String? value) {
    if (value == null || value.isEmpty) return null;
    
    final port = int.tryParse(value);
    if (port == null || port < 1 || port > 65535) {
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

// Made with Bob
