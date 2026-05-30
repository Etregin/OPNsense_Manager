import 'openvpn_client_override_list_item.dart';

/// Represents the response from the OpenVPN client overrides search API.
///
/// This model wraps the paginated list of OpenVPN client overrides returned
/// by the search endpoint.
class OpenvpnClientOverrideSearchResponse {
  /// List of OpenVPN client override items
  final List<OpenvpnClientOverrideListItem> rows;

  /// Number of rows in the current page
  final int rowCount;

  /// Total number of overrides available
  final int total;

  /// Current page number (1-based)
  final int current;

  const OpenvpnClientOverrideSearchResponse({
    required this.rows,
    required this.rowCount,
    required this.total,
    required this.current,
  });

  /// Creates an instance from JSON
  factory OpenvpnClientOverrideSearchResponse.fromJson(Map<String, dynamic> json) {
    final rowsJson = json['rows'] as List<dynamic>? ?? [];
    final rows = rowsJson
        .map((item) => OpenvpnClientOverrideListItem.fromJson(item as Map<String, dynamic>))
        .toList();

    return OpenvpnClientOverrideSearchResponse(
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

  /// Checks if there are any overrides
  bool get isEmpty => rows.isEmpty;

  /// Checks if there are overrides
  bool get isNotEmpty => rows.isNotEmpty;

  /// Gets the number of overrides
  int get length => rows.length;

  /// Checks if there are more pages available
  bool get hasMorePages => (current * rowCount) < total;

  /// Gets the total number of pages
  int get totalPages => (total / rowCount).ceil();

  /// Gets all enabled overrides
  List<OpenvpnClientOverrideListItem> get enabledOverrides {
    return rows.where((item) => item.enabled).toList();
  }

  /// Gets all disabled overrides
  List<OpenvpnClientOverrideListItem> get disabledOverrides {
    return rows.where((item) => !item.enabled).toList();
  }

  @override
  String toString() => 'OpenvpnClientOverrideSearchResponse(rows: ${rows.length}, total: $total, current: $current)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OpenvpnClientOverrideSearchResponse &&
        other.rowCount == rowCount &&
        other.total == total &&
        other.current == current &&
        _listEquals(other.rows, rows);
  }

  @override
  int get hashCode => Object.hash(rowCount, total, current, rows);

  /// Helper method to compare lists
  static bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}


