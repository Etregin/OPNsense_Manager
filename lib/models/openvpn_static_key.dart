/// Represents an OpenVPN static key configuration.
///
/// Static keys are used for TLS authentication and can be shared
/// across multiple OpenVPN instances for additional security.
class OpenvpnStaticKey {
  /// Unique identifier for the static key
  final String? keyid;

  /// Description of the static key
  final String description;

  /// The actual key content (PEM format)
  final String key;

  /// Key mode (short value like "crypt", "auth", etc.)
  final String? mode;

  /// Key mode with full description (e.g., "crypt (Encrypt and authenticate all control channel packets)")
  final String? modeDisplay;

  /// Creation timestamp
  final DateTime? createdAt;

  /// Last modified timestamp
  final DateTime? modifiedAt;

  const OpenvpnStaticKey({
    this.keyid,
    required this.description,
    required this.key,
    this.mode,
    this.modeDisplay,
    this.createdAt,
    this.modifiedAt,
  });

  /// Creates an instance from JSON
  factory OpenvpnStaticKey.fromJson(Map<String, dynamic> json) {
    return OpenvpnStaticKey(
      keyid: json['uuid'] as String?,
      description: json['description'] as String? ?? '',
      key: json['key'] as String? ?? '',
      mode: _extractSelectedKey(json['mode']),
      modeDisplay: json['%mode'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      modifiedAt: json['modified_at'] != null
          ? DateTime.tryParse(json['modified_at'] as String)
          : null,
    );
  }

  /// Extracts the selected key from a dropdown map structure
  ///
  /// Handles both String values (from list endpoint) and Map structures (from edit endpoint).
  /// When the value is a Map, it finds the key with selected: 1 or selected: true.
  static String? _extractSelectedKey(dynamic json) {
    if (json == null) return null;
    if (json is String) return json; // Already a string
    if (json is! Map) return null;

    // Find the key with selected: 1 or selected: true
    for (var entry in json.entries) {
      if (entry.value is Map) {
        final value = entry.value as Map;
        if (value['selected'] == 1 || value['selected'] == '1' || value['selected'] == true) {
          return entry.key as String;
        }
      }
    }
    return null;
  }

  /// Converts to JSON
  Map<String, dynamic> toJson() {
    return {
      if (keyid != null) 'keyid': keyid,
      'description': description,
      'key': key,
      if (mode != null) 'mode': mode,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (modifiedAt != null) 'modified_at': modifiedAt!.toIso8601String(),
    };
  }

  /// Checks if the key is valid (non-empty)
  bool get isValid => key.isNotEmpty;

  /// Gets the key mode as a human-readable string
  String get modeDescription {
    // Use the full display text from %mode if available
    if (modeDisplay != null && modeDisplay!.isNotEmpty) {
      return modeDisplay!;
    }
    
    // Fallback to mode value if modeDisplay is not available
    if (mode != null && mode!.isNotEmpty) {
      return mode!;
    }
    
    return 'Unknown';
  }

  /// Gets a truncated version of the key for display (first 50 chars)
  String get keyPreview {
    if (key.length <= 50) return key;
    return '${key.substring(0, 50)}...';
  }

  /// Checks if this is a bidirectional key
  bool get isBidirectional => mode == '0';

  /// Checks if this is a unidirectional key
  bool get isUnidirectional => mode == '1';

  /// Creates a copy with updated fields
  OpenvpnStaticKey copyWith({
    String? keyid,
    String? description,
    String? key,
    String? mode,
    String? modeDisplay,
    DateTime? createdAt,
    DateTime? modifiedAt,
  }) {
    return OpenvpnStaticKey(
      keyid: keyid ?? this.keyid,
      description: description ?? this.description,
      key: key ?? this.key,
      mode: mode ?? this.mode,
      modeDisplay: modeDisplay ?? this.modeDisplay,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
    );
  }

  @override
  String toString() => 'OpenvpnStaticKey(keyid: $keyid, description: $description)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OpenvpnStaticKey &&
        other.keyid == keyid &&
        other.description == description &&
        other.key == key &&
        other.mode == mode &&
        other.modeDisplay == modeDisplay &&
        other.createdAt == createdAt &&
        other.modifiedAt == modifiedAt;
  }

  @override
  int get hashCode => Object.hash(
        keyid,
        description,
        key,
        mode,
        modeDisplay,
        createdAt,
        modifiedAt,
      );
}

/// Represents the response from the static keys search API.
class OpenvpnStaticKeySearchResponse {
  /// List of static keys
  final List<OpenvpnStaticKey> rows;

  /// Number of rows in the current page
  final int rowCount;

  /// Total number of keys available
  final int total;

  /// Current page number (1-based)
  final int current;

  const OpenvpnStaticKeySearchResponse({
    required this.rows,
    required this.rowCount,
    required this.total,
    required this.current,
  });

  /// Creates an instance from JSON
  factory OpenvpnStaticKeySearchResponse.fromJson(Map<String, dynamic> json) {
    final rowsJson = json['rows'] as List<dynamic>? ?? [];
    final rows = rowsJson
        .map((item) => OpenvpnStaticKey.fromJson(item as Map<String, dynamic>))
        .toList();

    return OpenvpnStaticKeySearchResponse(
      rows: rows,
      rowCount: json['rowCount'] as int? ?? rows.length,
      total: json['total'] as int? ?? rows.length,
      current: json['current'] as int? ?? 1,
    );
  }

  /// Converts to JSON
  Map<String, dynamic> toJson() {
    return {
      'rows': rows.map((item) => item.toJson()).toList(),
      'rowCount': rowCount,
      'total': total,
      'current': current,
    };
  }

  /// Checks if there are any keys
  bool get isEmpty => rows.isEmpty;

  /// Checks if there are keys
  bool get isNotEmpty => rows.isNotEmpty;

  /// Gets the number of keys
  int get length => rows.length;

  /// Checks if there are more pages available
  bool get hasMorePages => (current * rowCount) < total;

  /// Gets the total number of pages
  int get totalPages => (total / rowCount).ceil();

  @override
  String toString() => 'OpenvpnStaticKeySearchResponse(rows: ${rows.length}, total: $total)';
}


