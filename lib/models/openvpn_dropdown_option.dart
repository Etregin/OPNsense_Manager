/// Represents a dropdown option in OpenVPN configuration.
///
/// Used for fields that have multiple selectable values with a selected state.
class OpenvpnDropdownOption {
  /// The value of the option
  final String value;

  /// Whether this option is currently selected
  final bool selected;

  /// Optional group name for grouped options (e.g., cipher groups)
  final String? optgroup;

  const OpenvpnDropdownOption({
    required this.value,
    required this.selected,
    this.optgroup,
  });

  /// Creates an instance from JSON
  factory OpenvpnDropdownOption.fromJson(Map<String, dynamic> json) {
    return OpenvpnDropdownOption(
      value: json['value'] as String? ?? '',
      selected: json['selected'] == 1 || json['selected'] == true,
      optgroup: json['optgroup'] as String?,
    );
  }

  /// Converts to JSON
  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'selected': selected ? 1 : 0,
      if (optgroup != null) 'optgroup': optgroup,
    };
  }

  @override
  String toString() => 'OpenvpnDropdownOption(value: $value, selected: $selected)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OpenvpnDropdownOption &&
        other.value == value &&
        other.selected == selected &&
        other.optgroup == optgroup;
  }

  @override
  int get hashCode => Object.hash(value, selected, optgroup);
}


