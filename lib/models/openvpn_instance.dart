import 'openvpn_dropdown_option.dart';

/// Represents a complete OpenVPN instance configuration.
///
/// This model supports both client and server roles and includes all
/// configuration options available in the OPNsense OpenVPN API.
class OpenvpnInstance {
  // Basic identification
  final String? vpnid;
  final bool enabled;
  final String role; // 'client' or 'server'
  final String description;

  // Device and protocol settings
  final String devType;
  final String proto;
  final String port;
  final String? local;
  final String? portShare;

  // Network topology
  final String topology;
  final String? remote;
  final String? server;
  final String? serverIpv6;
  final bool nopool;

  // Bridge settings
  final String? bridgeGateway;
  final String? bridgePool;

  // Routing
  final List<String> route;
  final List<String> pushRoute;
  final List<String> pushExcludedRoutes;

  // Certificate and authentication
  final String? cert;
  final String? crl;
  final String? ca;
  final String? certDepth;
  final String? remoteCertTls;
  final String? verifyClientCert;
  final bool useOcsp;

  // TLS and encryption
  final String? tlsKey;
  final String? auth;
  final String? dataCiphers; // Comma-separated list for multi-select
  final String? dataCiphersFallback; // Comma-separated list for multi-select

  // User authentication
  final String? authmode;
  final String? localGroup;
  final bool usernameAsCommonName;
  final String strictusercn;

  // Client credentials
  final String? username;
  final String? password;

  // Connection limits
  final String? maxclients;

  // Keepalive and timeouts
  final String? keepaliveInterval;
  final String? keepaliveTimeout;
  final String? renegSec;

  // Token authentication
  final String? authGenToken; // Changed from bool to String to store actual value
  final String? authGenTokenRenewal;
  final String? authGenTokenSecret;
  final bool provisionExclusive;

  // Client routing options
  final String redirectGateway; // Comma-separated list of redirect gateway options
  final String? routeMetric;
  final bool registerDns;

  // DNS and NTP
  final List<String> dnsDomain;
  final List<String> dnsDomainSearch;
  final List<String> dnsServers;
  final List<String> ntpServers;

  // MTU and fragmentation
  final String? tunMtu;
  final String? fragment;
  final String? mssfix;

  // High availability
  final String? carpDependOn;

  // Various flags
  final Map<String, bool> variousFlags;
  final Map<String, bool> variousPushFlags;
  final String? pushInactive;

  // Advanced options
  final String? compressMigrate;
  final bool ifconfigPoolPersist;
  final String? httpProxy;
  final String? verifyX509Name;
  final String? verb;

  // Dropdown options (populated from API response)
  final Map<String, OpenvpnDropdownOption>? devTypeOptions;
  final Map<String, OpenvpnDropdownOption>? protoOptions;
  final Map<String, OpenvpnDropdownOption>? topologyOptions;
  final Map<String, OpenvpnDropdownOption>? certOptions;
  final Map<String, OpenvpnDropdownOption>? caOptions;
  final Map<String, OpenvpnDropdownOption>? crlOptions;
  final Map<String, OpenvpnDropdownOption>? tlsKeyOptions;
  final Map<String, OpenvpnDropdownOption>? authOptions;
  final Map<String, OpenvpnDropdownOption>? authmodeOptions;
  final Map<String, OpenvpnDropdownOption>? localGroupOptions;
  final Map<String, OpenvpnDropdownOption>? carpDependOnOptions;
  final Map<String, OpenvpnDropdownOption>? compressMigrateOptions;
  final Map<String, OpenvpnDropdownOption>? certDepthOptions;
  final Map<String, OpenvpnDropdownOption>? strictusercnOptions;
  final Map<String, OpenvpnDropdownOption>? dataCiphersOptions;
  final Map<String, OpenvpnDropdownOption>? dataCiphersFallbackOptions;
  final Map<String, OpenvpnDropdownOption>? variousFlagsOptions;
  final Map<String, OpenvpnDropdownOption>? variousPushFlagsOptions;
  final Map<String, OpenvpnDropdownOption>? redirectGatewayOptions;
  final Map<String, OpenvpnDropdownOption>? remoteCertTlsOptions;
  final Map<String, OpenvpnDropdownOption>? verifyClientCertOptions;
  final Map<String, OpenvpnDropdownOption>? verbOptions;

  const OpenvpnInstance({
    this.vpnid,
    required this.enabled,
    required this.role,
    required this.description,
    required this.devType,
    required this.proto,
    required this.port,
    this.local,
    this.portShare,
    required this.topology,
    this.remote,
    this.server,
    this.serverIpv6,
    required this.nopool,
    this.bridgeGateway,
    this.bridgePool,
    required this.route,
    required this.pushRoute,
    required this.pushExcludedRoutes,
    this.cert,
    this.crl,
    this.ca,
    this.certDepth,
    this.remoteCertTls,
    this.verifyClientCert,
    required this.useOcsp,
    this.tlsKey,
    this.auth,
    this.dataCiphers,
    this.dataCiphersFallback,
    this.authmode,
    this.localGroup,
    required this.usernameAsCommonName,
    required this.strictusercn,
    this.username,
    this.password,
    this.maxclients,
    this.keepaliveInterval,
    this.keepaliveTimeout,
    this.renegSec,
    required this.authGenToken,
    this.authGenTokenRenewal,
    this.authGenTokenSecret,
    required this.provisionExclusive,
    required this.redirectGateway,
    this.routeMetric,
    required this.registerDns,
    required this.dnsDomain,
    required this.dnsDomainSearch,
    required this.dnsServers,
    required this.ntpServers,
    this.tunMtu,
    this.fragment,
    this.mssfix,
    this.carpDependOn,
    required this.variousFlags,
    required this.variousPushFlags,
    this.pushInactive,
    this.compressMigrate,
    required this.ifconfigPoolPersist,
    this.httpProxy,
    this.verifyX509Name,
    this.verb,
    this.devTypeOptions,
    this.protoOptions,
    this.topologyOptions,
    this.certOptions,
    this.caOptions,
    this.crlOptions,
    this.tlsKeyOptions,
    this.authOptions,
    this.authmodeOptions,
    this.localGroupOptions,
    this.carpDependOnOptions,
    this.compressMigrateOptions,
    this.certDepthOptions,
    this.strictusercnOptions,
    this.dataCiphersOptions,
    this.dataCiphersFallbackOptions,
    this.variousFlagsOptions,
    this.variousPushFlagsOptions,
    this.redirectGatewayOptions,
    this.remoteCertTlsOptions,
    this.verifyClientCertOptions,
    this.verbOptions,
  });

  /// Creates an instance from JSON
  factory OpenvpnInstance.fromJson(Map<String, dynamic> json) {
    return OpenvpnInstance(
      vpnid: json['vpnid'] as String?,
      enabled: json['enabled'] == '1' || json['enabled'] == 1 || json['enabled'] == true,
      role: _extractSelectedKey(json['role']) ?? 'server',
      description: json['description'] as String? ?? '',
      devType: _extractSelectedKey(json['dev_type']) ?? 'tun',
      proto: _extractSelectedKey(json['proto']) ?? 'udp',
      port: json['port'] as String? ?? '1194',
      local: json['local'] as String?,
      portShare: json['port-share'] as String?,
      topology: _extractSelectedKey(json['topology']) ?? 'subnet',
      remote: _extractSelectedKeys(json['remote']),
      server: json['server'] as String?,
      serverIpv6: json['server_ipv6'] as String?,
      nopool: json['nopool'] == '1' || json['nopool'] == 1 || json['nopool'] == true,
      bridgeGateway: json['bridge_gateway'] as String?,
      bridgePool: json['bridge_pool'] as String?,
      route: _parseStringList(json['route']),
      pushRoute: _parseStringList(json['push_route']),
      pushExcludedRoutes: _parseStringList(json['push_excluded_routes']),
      cert: _extractSelectedKey(json['cert']),
      crl: _extractSelectedKey(json['crl']),
      ca: _extractSelectedKey(json['ca']),
      certDepth: _extractSelectedKey(json['cert_depth']),
      remoteCertTls: _extractSelectedKey(json['remote_cert_tls']),
      verifyClientCert: _extractSelectedKey(json['verify_client_cert']),
      useOcsp: json['use_ocsp'] == '1' || json['use_ocsp'] == 1 || json['use_ocsp'] == true,
      tlsKey: _extractSelectedKey(json['tls_key']),
      auth: _extractSelectedKey(json['auth']),
      dataCiphers: _extractSelectedKeys(json['data-ciphers']),
      dataCiphersFallback: _extractSelectedKeys(json['data-ciphers-fallback']),
      authmode: _extractSelectedKey(json['authmode']),
      localGroup: _extractSelectedKey(json['local_group']),
      usernameAsCommonName: json['username_as_common_name'] == '1' || json['username_as_common_name'] == 1 || json['username_as_common_name'] == true,
      strictusercn: _extractSelectedFromArray(json['strictusercn']) ?? '0',
      username: json['username'] as String?,
      password: json['password'] as String?,
      maxclients: json['maxclients'] as String?,
      keepaliveInterval: json['keepalive_interval'] as String?,
      keepaliveTimeout: json['keepalive_timeout'] as String?,
      renegSec: json['reneg-sec'] as String?,
      authGenToken: json['auth-gen-token']?.toString(),
      authGenTokenRenewal: json['auth-gen-token-renewal'] as String?,
      authGenTokenSecret: json['auth-gen-token-secret'] as String?,
      provisionExclusive: json['provision_exclusive'] == '1' || json['provision_exclusive'] == 1 || json['provision_exclusive'] == true,
      redirectGateway: _extractSelectedKeys(json['redirect_gateway']) ?? '',
      routeMetric: json['route_metric'] as String?,
      registerDns: json['register_dns'] == '1' || json['register_dns'] == 1 || json['register_dns'] == true,
      dnsDomain: _parseStringList(json['dns_domain']),
      dnsDomainSearch: _parseStringList(json['dns_domain_search']),
      dnsServers: _parseStringList(json['dns_servers']),
      ntpServers: _parseStringList(json['ntp_servers']),
      tunMtu: json['tun_mtu'] as String?,
      fragment: json['fragment'] as String?,
      mssfix: json['mssfix'] as String?,
      carpDependOn: _extractSelectedKey(json['carp_depend_on']),
      variousFlags: _parseBoolMap(json['various_flags']),
      variousPushFlags: _parseBoolMap(json['various_push_flags']),
      pushInactive: json['push_inactive'] as String?,
      compressMigrate: _extractSelectedKey(json['compress_migrate']),
      ifconfigPoolPersist: json['ifconfig-pool-persist'] == '1' || json['ifconfig-pool-persist'] == 1 || json['ifconfig-pool-persist'] == true,
      httpProxy: json['http-proxy'] as String?,
      verifyX509Name: json['verify-x509-name'] as String?,
      verb: _extractSelectedFromArray(json['verb']),
      // Parse dropdown options from API response
      devTypeOptions: _parseDropdownOptions(json['dev_type']),
      protoOptions: _parseDropdownOptions(json['proto']),
      topologyOptions: _parseDropdownOptions(json['topology']),
      certOptions: _parseDropdownOptions(json['cert']),
      caOptions: _parseDropdownOptions(json['ca']),
      crlOptions: _parseDropdownOptions(json['crl']),
      tlsKeyOptions: _parseDropdownOptions(json['tls_key']),
      authOptions: _parseDropdownOptions(json['auth']),
      authmodeOptions: _parseDropdownOptions(json['authmode']),
      localGroupOptions: _parseDropdownOptions(json['local_group']),
      carpDependOnOptions: _parseDropdownOptions(json['carp_depend_on']),
      compressMigrateOptions: _parseDropdownOptions(json['compress_migrate']),
      certDepthOptions: _parseDropdownOptions(json['cert_depth']),
      strictusercnOptions: _parseDropdownOptionsFromArray(json['strictusercn']),
      dataCiphersOptions: _parseDropdownOptions(json['data-ciphers'], fieldName: 'data-ciphers'),
      dataCiphersFallbackOptions: _parseDropdownOptions(json['data-ciphers-fallback'], fieldName: 'data-ciphers-fallback'),
      variousFlagsOptions: _parseDropdownOptions(json['various_flags']),
      variousPushFlagsOptions: _parseDropdownOptions(json['various_push_flags']),
      redirectGatewayOptions: _parseDropdownOptions(json['redirect_gateway']),
      remoteCertTlsOptions: _parseDropdownOptions(json['remote_cert_tls']),
      verifyClientCertOptions: _parseDropdownOptions(json['verify_client_cert']),
      verbOptions: _parseDropdownOptionsFromArray(json['verb']),
    );
  }

  /// Converts to JSON
  Map<String, dynamic> toJson() {
    return {
      // Fix 1: Always include vpnid (empty string for new instances)
      'vpnid': vpnid ?? '',
      'enabled': enabled ? '1' : '0',
      'role': role,
      'description': description,
      'dev_type': devType,
      'proto': proto,
      'port': port,
      if (local != null && local!.isNotEmpty) 'local': local,
      if (portShare != null && portShare!.isNotEmpty) 'port-share': portShare,
      'topology': topology,
      if (remote != null && remote!.isNotEmpty) 'remote': remote,
      if (server != null && server!.isNotEmpty) 'server': server,
      if (serverIpv6 != null && serverIpv6!.isNotEmpty) 'server_ipv6': serverIpv6,
      // Only send role-specific boolean fields
      if (role == 'server') 'nopool': nopool ? '1' : '0',
      if (bridgeGateway != null && bridgeGateway!.isNotEmpty) 'bridge_gateway': bridgeGateway,
      if (bridgePool != null && bridgePool!.isNotEmpty) 'bridge_pool': bridgePool,
      // Convert List fields to comma-separated strings for API, omit if empty
      if (route.isNotEmpty) 'route': route.join(','),
      if (pushRoute.isNotEmpty) 'push_route': pushRoute.join(','),
      if (pushExcludedRoutes.isNotEmpty) 'push_excluded_routes': pushExcludedRoutes.join(','),
      if (cert != null && cert!.isNotEmpty) 'cert': cert,
      if (crl != null && crl!.isNotEmpty) 'crl': crl,
      if (ca != null && ca!.isNotEmpty) 'ca': ca,
      if (certDepth != null && certDepth!.isNotEmpty) 'cert_depth': certDepth,
      if (remoteCertTls != null && remoteCertTls!.isNotEmpty) 'remote_cert_tls': remoteCertTls,
      if (verifyClientCert != null && verifyClientCert!.isNotEmpty) 'verify_client_cert': verifyClientCert,
      // Only send role-specific boolean fields
      if (role == 'server') 'use_ocsp': useOcsp ? '1' : '0',
      if (tlsKey != null && tlsKey!.isNotEmpty) 'tls_key': tlsKey,
      if (auth != null && auth!.isNotEmpty) 'auth': auth,
      if (dataCiphers != null && dataCiphers!.isNotEmpty) 'data-ciphers': dataCiphers,
      if (dataCiphersFallback != null && dataCiphersFallback!.isNotEmpty) 'data-ciphers-fallback': dataCiphersFallback,
      if (authmode != null && authmode!.isNotEmpty) 'authmode': authmode,
      if (localGroup != null && localGroup!.isNotEmpty) 'local_group': localGroup,
      'username_as_common_name': usernameAsCommonName ? '1' : '0',
      // Only send strictusercn for server role
      if (role == 'server') 'strictusercn': strictusercn,
      if (username != null && username!.isNotEmpty) 'username': username,
      if (password != null && password!.isNotEmpty) 'password': password,
      if (maxclients != null && maxclients!.isNotEmpty) 'maxclients': maxclients,
      if (keepaliveInterval != null && keepaliveInterval!.isNotEmpty) 'keepalive_interval': keepaliveInterval,
      if (keepaliveTimeout != null && keepaliveTimeout!.isNotEmpty) 'keepalive_timeout': keepaliveTimeout,
      if (renegSec != null && renegSec!.isNotEmpty) 'reneg-sec': renegSec,
      if (authGenToken != null && authGenToken!.isNotEmpty) 'auth-gen-token': authGenToken,
      if (authGenTokenRenewal != null && authGenTokenRenewal!.isNotEmpty) 'auth-gen-token-renewal': authGenTokenRenewal,
      if (authGenTokenSecret != null && authGenTokenSecret!.isNotEmpty) 'auth-gen-token-secret': authGenTokenSecret,
      // Only send role-specific boolean fields
      if (role == 'server') 'provision_exclusive': provisionExclusive ? '1' : '0',
      // Fix 4: redirect_gateway as comma-separated string, only if not empty
      if (redirectGateway.isNotEmpty) 'redirect_gateway': redirectGateway,
      if (routeMetric != null && routeMetric!.isNotEmpty) 'route_metric': routeMetric,
      // Only send role-specific boolean fields
      if (role == 'server') 'register_dns': registerDns ? '1' : '0',
      // Convert List fields to comma-separated strings for API, omit if empty
      if (dnsDomain.isNotEmpty) 'dns_domain': dnsDomain.join(','),
      if (dnsDomainSearch.isNotEmpty) 'dns_domain_search': dnsDomainSearch.join(','),
      if (dnsServers.isNotEmpty) 'dns_servers': dnsServers.join(','),
      if (ntpServers.isNotEmpty) 'ntp_servers': ntpServers.join(','),
      if (tunMtu != null && tunMtu!.isNotEmpty) 'tun_mtu': tunMtu,
      if (fragment != null && fragment!.isNotEmpty) 'fragment': fragment,
      if (mssfix != null && mssfix!.isNotEmpty) 'mssfix': mssfix,
      if (carpDependOn != null && carpDependOn!.isNotEmpty) 'carp_depend_on': carpDependOn,
      // Fix 2: Convert various_flags Map to comma-separated string, omit if empty
      if (_boolMapToCommaSeparated(variousFlags).isNotEmpty)
        'various_flags': _boolMapToCommaSeparated(variousFlags),
      // Fix 3: Convert various_push_flags Map to comma-separated string, omit if empty
      if (_boolMapToCommaSeparated(variousPushFlags).isNotEmpty)
        'various_push_flags': _boolMapToCommaSeparated(variousPushFlags),
      if (pushInactive != null && pushInactive!.isNotEmpty) 'push_inactive': pushInactive,
      if (compressMigrate != null && compressMigrate!.isNotEmpty) 'compress_migrate': compressMigrate,
      // Only send role-specific boolean fields
      if (role == 'server') 'ifconfig-pool-persist': ifconfigPoolPersist ? '1' : '0',
      if (httpProxy != null && httpProxy!.isNotEmpty) 'http-proxy': httpProxy,
      if (verifyX509Name != null && verifyX509Name!.isNotEmpty) 'verify-x509-name': verifyX509Name,
      if (verb != null && verb!.isNotEmpty) 'verb': verb,
    };
  }

  // Helper methods

  /// Gets the selected device type (tun, tap, or ovpn)
  String get selectedDevType => devType;

  /// Gets the selected protocol (udp, tcp, etc.)
  String get selectedProto => proto;

  /// Gets the selected topology
  String get selectedTopology => topology;

  /// Checks if this is a server instance
  bool get isServer => role == 'server';

  /// Checks if this is a client instance
  bool get isClient => role == 'client';

  // Static helper methods for parsing

  /// Extracts the selected key from a dropdown map structure
  static String? _extractSelectedKey(dynamic json) {
    if (json == null) return null;
    if (json is String) return json;
    if (json is List) {
      if (json.isEmpty) return null;
      if (json.first is String) {
        return json.join(',');
      }
      final selected = json.where((item) {
        if (item is Map) {
          return item['selected'] == 1 || item['selected'] == '1' || item['selected'] == true;
        }
        return false;
      }).toList();
      if (selected.isNotEmpty && selected.first is Map) {
        return (selected.first as Map)['value']?.toString();
      }
      return null;
    }

    if (json is! Map) {
      return null;
    }

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

  /// Extracts the selected index from an array structure as a string
  static String? _extractSelectedFromArray(dynamic value) {
    if (value == null) return null;
    if (value is! List) return null;

    for (int i = 0; i < value.length; i++) {
      final item = value[i];
      if (item is Map &&
          (item['selected'] == 1 ||
              item['selected'] == '1' ||
              item['selected'] == true)) {
        return i.toString();
      }
    }
    return null;
  }

  /// Extracts all selected keys from a multi-select dropdown map as comma-separated string
  static String? _extractSelectedKeys(dynamic json) {
    if (json == null) return null;
    if (json is String) return json;
    if (json is! Map) return null;

    final selectedKeys = <String>[];
    json.forEach((key, value) {
      if (value is Map) {
        if (value['selected'] == 1 || value['selected'] == '1' || value['selected'] == true) {
          selectedKeys.add(key as String);
        }
      }
    });
    return selectedKeys.isEmpty ? null : selectedKeys.join(',');
  }

  static List<String> _parseStringList(dynamic json) {
    if (json == null) return [];

    if (json is List) {
      return json.map((e) => e.toString()).toList();
    }
    if (json is String && json.isNotEmpty) {
      return [json];
    }
    if (json is Map) {
      final result = <String>[];

      json.forEach((key, val) {
        if (val is Map && val.containsKey('value') && val.containsKey('selected')) {
          if (val['selected'] == 1 || val['selected'] == '1' || val['selected'] == true) {
            final extractedValue = val['value']?.toString() ?? '';
            if (extractedValue.isNotEmpty) {
              result.add(extractedValue);
            }
          }
        } else {
          final directValue = val.toString();
          if (directValue.isNotEmpty) {
            result.add(directValue);
          }
        }
      });

      return result;
    }

    return [];
  }

  static Map<String, bool> _parseBoolMap(dynamic json) {
    if (json == null) return {};

    if (json is List) {
      final result = <String, bool>{};
      for (int i = 0; i < json.length; i++) {
        final item = json[i];
        if (item is Map && item.containsKey('value')) {
          result[item['value'].toString()] =
              item['selected'] == 1 || item['selected'] == '1' || item['selected'] == true;
        }
      }
      return result;
    }

    if (json is! Map) {
      return {};
    }

    final result = <String, bool>{};
    json.forEach((key, value) {
      if (value is Map && value.containsKey('selected')) {
        final isSelected = value['selected'] == 1 || value['selected'] == '1' || value['selected'] == true;
        result[key as String] = isSelected;
      } else {
        result[key as String] = value == '1' || value == 1 || value == true;
      }
    });
    return result;
  }

  /// Converts a bool map to comma-separated string of keys where value is true
  /// Returns empty string if no keys are selected
  static String _boolMapToCommaSeparated(Map<String, bool> map) {
    final selectedKeys = map.entries
        .where((entry) => entry.value == true)
        .map((entry) => entry.key)
        .toList();
    return selectedKeys.isEmpty ? '' : selectedKeys.join(',');
  }

  /// Parses dropdown options from API response
  ///
  /// API returns options in format: {"key": {"value": "Label", "selected": 1}}
  static Map<String, OpenvpnDropdownOption>? _parseDropdownOptions(dynamic json, {String? fieldName}) {
    if (json == null) return null;
    if (json is! Map) return null;

    final options = <String, OpenvpnDropdownOption>{};
    json.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        try {
          options[key as String] = OpenvpnDropdownOption.fromJson(value);
        } catch (_) {}
      }
    });

    return options.isEmpty ? null : options;
  }

  /// Parses dropdown options from array format
  ///
  /// API returns some options as arrays: [{"value": "Label", "selected": 1}, ...]
  static Map<String, OpenvpnDropdownOption>? _parseDropdownOptionsFromArray(dynamic json) {
    if (json == null) return null;
    if (json is! List) return null;

    final options = <String, OpenvpnDropdownOption>{};
    for (int i = 0; i < json.length; i++) {
      final item = json[i];
      if (item is Map<String, dynamic>) {
        try {
          options[i.toString()] = OpenvpnDropdownOption.fromJson(item);
        } catch (_) {}
      }
    }

    return options.isEmpty ? null : options;
  }

  @override
  String toString() => 'OpenvpnInstance(vpnid: $vpnid, role: $role, description: $description)';
}


