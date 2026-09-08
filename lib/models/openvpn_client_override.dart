import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'openvpn_dropdown_option.dart';

/// Represents a complete OpenVPN Client Specific Override configuration.
///
/// This model contains all configuration options for overriding client-specific
/// settings in OpenVPN server instances.
class OpenvpnClientOverride {
  /// Whether the override is enabled
  final String enabled;

  /// Associated OpenVPN server instances
  final Map<String, OpenvpnDropdownOption> servers;

  /// Common name for the client certificate
  @JsonKey(name: 'common_name')
  final String commonName;

  /// Whether to block this client
  final String block;

  /// Whether to reset pushed options
  @JsonKey(name: 'push_reset')
  final String pushReset;

  /// IPv4 tunnel network override
  @JsonKey(name: 'tunnel_network')
  final String tunnelNetwork;

  /// IPv6 tunnel network override
  @JsonKey(name: 'tunnel_networkv6')
  final String tunnelNetworkv6;

  /// Local networks accessible to the client
  @JsonKey(name: 'local_networks')
  final Map<String, OpenvpnDropdownOption> localNetworks;

  /// Remote networks accessible to the client
  @JsonKey(name: 'remote_networks')
  final Map<String, OpenvpnDropdownOption> remoteNetworks;

  /// Route gateway override
  @JsonKey(name: 'route_gateway')
  final String routeGateway;

  /// Redirect gateway options
  @JsonKey(name: 'redirect_gateway')
  final Map<String, OpenvpnDropdownOption> redirectGateway;

  /// Whether to register DNS
  @JsonKey(name: 'register_dns')
  final String registerDns;

  /// DNS domain override
  @JsonKey(name: 'dns_domain')
  final Map<String, OpenvpnDropdownOption> dnsDomain;

  /// DNS domain search override
  @JsonKey(name: 'dns_domain_search')
  final Map<String, OpenvpnDropdownOption> dnsDomainSearch;

  /// DNS servers override
  @JsonKey(name: 'dns_servers')
  final Map<String, OpenvpnDropdownOption> dnsServers;

  /// NTP servers override
  @JsonKey(name: 'ntp_servers')
  final Map<String, OpenvpnDropdownOption> ntpServers;

  /// WINS servers override
  @JsonKey(name: 'wins_servers')
  final Map<String, OpenvpnDropdownOption> winsServers;

  /// Description of the override
  final String description;

  const OpenvpnClientOverride({
    required this.enabled,
    required this.servers,
    required this.commonName,
    required this.block,
    required this.pushReset,
    required this.tunnelNetwork,
    required this.tunnelNetworkv6,
    required this.localNetworks,
    required this.remoteNetworks,
    required this.routeGateway,
    required this.redirectGateway,
    required this.registerDns,
    required this.dnsDomain,
    required this.dnsDomainSearch,
    required this.dnsServers,
    required this.ntpServers,
    required this.winsServers,
    required this.description,
  });

  /// Creates an instance from JSON
  factory OpenvpnClientOverride.fromJson(Map<String, dynamic> json) {
    // Handle the nested 'cso' wrapper if present
    final data = json.containsKey('cso') ? json['cso'] as Map<String, dynamic> : json;
    
    return OpenvpnClientOverride(
      enabled: data['enabled'] as String? ?? '0',
      servers: _parseDropdownOptions(data['servers']) ?? {},
      commonName: data['common_name'] as String? ?? '',
      block: data['block'] as String? ?? '0',
      pushReset: data['push_reset'] as String? ?? '0',
      tunnelNetwork: data['tunnel_network'] as String? ?? '',
      tunnelNetworkv6: data['tunnel_networkv6'] as String? ?? '',
      localNetworks: _parseDropdownOptions(data['local_networks']) ?? {},
      remoteNetworks: _parseDropdownOptions(data['remote_networks']) ?? {},
      routeGateway: data['route_gateway'] as String? ?? '',
      redirectGateway: _parseDropdownOptions(data['redirect_gateway']) ?? {},
      registerDns: data['register_dns'] as String? ?? '0',
      dnsDomain: _parseDropdownOptions(data['dns_domain']) ?? {},
      dnsDomainSearch: _parseDropdownOptions(data['dns_domain_search']) ?? {},
      dnsServers: _parseDropdownOptions(data['dns_servers']) ?? {},
      ntpServers: _parseDropdownOptions(data['ntp_servers']) ?? {},
      winsServers: _parseDropdownOptions(data['wins_servers']) ?? {},
      description: data['description'] as String? ?? '',
    );
  }

  /// Converts to JSON
  Map<String, dynamic> toJson() {
    return {
      'enabled': enabled,
      'servers': _dropdownOptionsToCommaSeparated(servers),
      'common_name': commonName,
      'block': block,
      'push_reset': pushReset,
      'tunnel_network': tunnelNetwork,
      'tunnel_networkv6': tunnelNetworkv6,
      'local_networks': _dropdownOptionsToCommaSeparated(localNetworks),
      'remote_networks': _dropdownOptionsToCommaSeparated(remoteNetworks),
      'route_gateway': routeGateway,
      'redirect_gateway': _dropdownOptionsToCommaSeparated(redirectGateway),
      'register_dns': registerDns,
      'dns_domain': _dropdownOptionsToCommaSeparated(dnsDomain),
      'dns_domain_search': _dropdownOptionsToCommaSeparated(dnsDomainSearch),
      'dns_servers': _dropdownOptionsToCommaSeparated(dnsServers),
      'ntp_servers': _dropdownOptionsToCommaSeparated(ntpServers),
      'wins_servers': _dropdownOptionsToCommaSeparated(winsServers),
      'description': description,
    };
  }

  /// Creates an empty instance with default values
  factory OpenvpnClientOverride.empty() {
    return const OpenvpnClientOverride(
      enabled: '1',
      servers: {},
      commonName: '',
      block: '0',
      pushReset: '0',
      tunnelNetwork: '',
      tunnelNetworkv6: '',
      localNetworks: {},
      remoteNetworks: {},
      routeGateway: '',
      redirectGateway: {},
      registerDns: '0',
      dnsDomain: {},
      dnsDomainSearch: {},
      dnsServers: {},
      ntpServers: {},
      winsServers: {},
      description: '',
    );
  }

  /// Helper method to parse dropdown options from JSON
  static Map<String, OpenvpnDropdownOption>? _parseDropdownOptions(dynamic json) {
    if (json == null) return null;
    if (json is! Map) return null;

    final options = <String, OpenvpnDropdownOption>{};
    json.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        try {
          options[key as String] = OpenvpnDropdownOption.fromJson(value);
        } catch (e) {
          assert(() {
            debugPrint('OpenvpnClientOverride: failed to parse dropdown option: $e');
            return true;
          }());
        }
      }
    });

    return options.isEmpty ? null : options;
  }

  /// Helper method to convert dropdown options to comma-separated string
  /// This is used when sending data to the API, which expects comma-separated values
  static String _dropdownOptionsToCommaSeparated(Map<String, OpenvpnDropdownOption> options) {
    final selectedKeys = options.entries
        .where((entry) => entry.value.selected)
        .map((entry) => entry.key)
        .toList();
    return selectedKeys.join(',');
  }

  /// Gets the selected server IDs
  List<String> get selectedServerIds {
    return servers.entries
        .where((entry) => entry.value.selected)
        .map((entry) => entry.key)
        .toList();
  }

  /// Gets the selected local networks
  List<String> get selectedLocalNetworks {
    return localNetworks.entries
        .where((entry) => entry.value.selected && entry.value.value.isNotEmpty)
        .map((entry) => entry.value.value)
        .toList();
  }

  /// Gets the selected remote networks
  List<String> get selectedRemoteNetworks {
    return remoteNetworks.entries
        .where((entry) => entry.value.selected && entry.value.value.isNotEmpty)
        .map((entry) => entry.value.value)
        .toList();
  }

  /// Gets the selected redirect gateway options
  List<String> get selectedRedirectGatewayOptions {
    return redirectGateway.entries
        .where((entry) => entry.value.selected)
        .map((entry) => entry.key)
        .toList();
  }

  /// Checks if the override is enabled
  bool get isEnabled => enabled == '1';

  /// Checks if the client is blocked
  bool get isBlocked => block == '1';

  /// Checks if push reset is enabled
  bool get isPushResetEnabled => pushReset == '1';

  /// Checks if DNS registration is enabled
  bool get isDnsRegistrationEnabled => registerDns == '1';

  @override
  String toString() =>
      'OpenvpnClientOverride(commonName: $commonName, description: $description, enabled: $enabled)';
}


