/// Represents a simplified OpenVPN instance for list views.
///
/// This model is used in search results and list displays where
/// full instance details are not needed.
class OpenvpnInstanceListItem {
  /// Unique identifier for the instance
  final String vpnid;

  /// UUID for the instance
  final String uuid;

  /// Whether the instance is enabled
  final bool enabled;

  /// Role of the instance ('client' or 'server')
  final String role;

  /// Description of the instance
  final String description;

  /// Device type (tun, tap, ovpn)
  final String? devType;

  /// Protocol (udp, tcp, etc.)
  final String? protocol;

  /// Port number
  final String? port;

  /// Local address
  final String? local;

  /// Remote address (for clients)
  final String? remote;

  /// Server network (for servers)
  final String? server;

  const OpenvpnInstanceListItem({
    required this.vpnid,
    required this.uuid,
    required this.enabled,
    required this.role,
    required this.description,
    this.devType,
    this.protocol,
    this.port,
    this.local,
    this.remote,
    this.server,
  });

  /// Creates an instance from JSON
  factory OpenvpnInstanceListItem.fromJson(Map<String, dynamic> json) {
    return OpenvpnInstanceListItem(
      vpnid: json['vpnid'] as String? ?? '',
      uuid: json['uuid'] as String? ?? '',
      enabled: json['enabled'] == '1' || json['enabled'] == 1 || json['enabled'] == true,
      role: json['role'] as String? ?? 'server',
      description: json['description'] as String? ?? '',
      devType: json['dev_type'] as String?,
      protocol: json['protocol'] as String?,
      port: json['port'] as String?,
      local: json['local'] as String?,
      remote: json['remote'] as String?,
      server: json['server'] as String?,
    );
  }

  /// Converts to JSON
  Map<String, dynamic> toJson() {
    return {
      'vpnid': vpnid,
      'uuid': uuid,
      'enabled': enabled ? '1' : '0',
      'role': role,
      'description': description,
      if (devType != null) 'dev_type': devType,
      if (protocol != null) 'protocol': protocol,
      if (port != null) 'port': port,
      if (local != null) 'local': local,
      if (remote != null) 'remote': remote,
      if (server != null) 'server': server,
    };
  }

  /// Checks if this is a server instance
  bool get isServer => role == 'server';

  /// Checks if this is a client instance
  bool get isClient => role == 'client';

  /// Gets a display-friendly status text
  String get statusText => enabled ? 'Enabled' : 'Disabled';

  /// Gets the primary connection info (remote for clients, server for servers)
  String? get primaryConnectionInfo {
    if (isClient) return remote;
    if (isServer) return server;
    return null;
  }

  @override
  String toString() => 'OpenvpnInstanceListItem(vpnid: $vpnid, uuid: $uuid, role: $role, description: $description)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OpenvpnInstanceListItem &&
        other.vpnid == vpnid &&
        other.uuid == uuid &&
        other.enabled == enabled &&
        other.role == role &&
        other.description == description &&
        other.devType == devType &&
        other.protocol == protocol &&
        other.port == port &&
        other.local == local &&
        other.remote == remote &&
        other.server == server;
  }

  @override
  int get hashCode => Object.hash(
        vpnid,
        uuid,
        enabled,
        role,
        description,
        devType,
        protocol,
        port,
        local,
        remote,
        server,
      );
}


