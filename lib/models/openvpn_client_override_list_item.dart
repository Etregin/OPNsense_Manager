/// Represents a simplified OpenVPN Client Specific Override for list views.
///
/// This model is used in search results and list displays where
/// full override details are not needed.
class OpenvpnClientOverrideListItem {
  /// Unique identifier for the override
  final String uuid;

  /// Whether the override is enabled (stored as string from API)
  final bool enabled;

  /// Display text for associated servers
  final String servers;

  /// Common name for the client certificate
  final String commonName;

  /// Description of the override
  final String description;

  /// IPv4 tunnel network
  final String tunnelNetwork;

  const OpenvpnClientOverrideListItem({
    required this.uuid,
    required this.enabled,
    required this.servers,
    required this.commonName,
    required this.description,
    required this.tunnelNetwork,
  });

  /// Creates an instance from JSON
  factory OpenvpnClientOverrideListItem.fromJson(Map<String, dynamic> json) {
    return OpenvpnClientOverrideListItem(
      uuid: json['uuid'] as String? ?? '',
      enabled: json['enabled'] == '1' || json['enabled'] == 1 || json['enabled'] == true,
      servers: json['servers'] as String? ?? '',
      commonName: json['common_name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      tunnelNetwork: json['tunnel_network'] as String? ?? '',
    );
  }

  /// Converts to JSON
  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'enabled': enabled ? '1' : '0',
      'servers': servers,
      'common_name': commonName,
      'description': description,
      'tunnel_network': tunnelNetwork,
    };
  }

  /// Gets a display-friendly status text
  String get statusText => enabled ? 'Enabled' : 'Disabled';

  @override
  String toString() =>
      'OpenvpnClientOverrideListItem(uuid: $uuid, commonName: $commonName, description: $description)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OpenvpnClientOverrideListItem &&
        other.uuid == uuid &&
        other.enabled == enabled &&
        other.servers == servers &&
        other.commonName == commonName &&
        other.description == description &&
        other.tunnelNetwork == tunnelNetwork;
  }

  @override
  int get hashCode => Object.hash(
        uuid,
        enabled,
        servers,
        commonName,
        description,
        tunnelNetwork,
      );
}


