class ApiResponseParser {
  static T? parseField<T>(Map<String, dynamic> data, String key, {T? defaultValue}) {
    try {
      if (!data.containsKey(key)) return defaultValue;
      final value = data[key];
      if (value == null) return defaultValue;
      return value as T;
    } catch (e) {
      return defaultValue;
    }
  }

  static String parseString(Map<String, dynamic> data, String key, {String defaultValue = ''}) {
    return parseField<String>(data, key, defaultValue: defaultValue) ?? defaultValue;
  }

  static int parseInt(Map<String, dynamic> data, String key, {int defaultValue = 0}) {
    final value = data[key];
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? defaultValue;
    return defaultValue;
  }

  static bool parseBool(Map<String, dynamic> data, String key, {bool defaultValue = false}) {
    final value = data[key];
    if (value is bool) return value;
    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }
    if (value is int) return value == 1;
    return defaultValue;
  }

  static List<T> parseList<T>(
    Map<String, dynamic> data,
    String key,
    T Function(dynamic) parser, {
    List<T> defaultValue = const [],
  }) {
    try {
      final value = data[key];
      if (value == null) return defaultValue;
      if (value is! List) return defaultValue;
      return value.map((item) => parser(item)).toList();
    } catch (e) {
      return defaultValue;
    }
  }

  static Map<String, dynamic> parseMap(
    Map<String, dynamic> data,
    String key, {
    Map<String, dynamic> defaultValue = const {},
  }) {
    try {
      final value = data[key];
      if (value == null) return defaultValue;
      if (value is! Map) return defaultValue;
      return Map<String, dynamic>.from(value);
    } catch (e) {
      return defaultValue;
    }
  }
}

// Made with Bob
