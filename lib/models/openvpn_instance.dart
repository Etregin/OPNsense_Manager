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
  final bool strictusercn;

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
  final bool authGenToken;
  final String? authGenTokenRenewal;
  final String? authGenTokenSecret;
  final bool provisionExclusive;

  // Client routing options
  final bool redirectGateway;
  final String? routeMetric;
  final bool registerDns;

  // DNS and NTP
  final String? dnsDomain;
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
    this.dnsDomain,
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
      portShare: json['port_share'] as String?,
      topology: _extractSelectedKey(json['topology']) ?? 'subnet',
      remote: _extractSelectedKey(json['remote']),
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
      dataCiphers: _extractSelectedKeys(json['data_ciphers']),
      dataCiphersFallback: _extractSelectedKeys(json['data_ciphers_fallback']),
      authmode: _extractSelectedKey(json['authmode']),
      localGroup: _extractSelectedKey(json['local_group']),
      usernameAsCommonName: json['username_as_common_name'] == '1' || json['username_as_common_name'] == 1 || json['username_as_common_name'] == true,
      strictusercn: _extractSelectedFromArray(json['strictusercn']) == '1',
      username: json['username'] as String?,
      password: json['password'] as String?,
      maxclients: json['maxclients'] as String?,
      keepaliveInterval: json['keepalive_interval'] as String?,
      keepaliveTimeout: json['keepalive_timeout'] as String?,
      renegSec: json['reneg_sec'] as String?,
      authGenToken: json['auth_gen_token'] == '1' || json['auth_gen_token'] == 1 || json['auth_gen_token'] == true,
      authGenTokenRenewal: json['auth_gen_token_renewal'] as String?,
      authGenTokenSecret: json['auth_gen_token_secret'] as String?,
      provisionExclusive: json['provision_exclusive'] == '1' || json['provision_exclusive'] == 1 || json['provision_exclusive'] == true,
      redirectGateway: (_extractSelectedKeys(json['redirect_gateway']) ?? '').isNotEmpty,
      routeMetric: json['route_metric'] as String?,
      registerDns: json['register_dns'] == '1' || json['register_dns'] == 1 || json['register_dns'] == true,
      dnsDomain: _extractSelectedKey(json['dns_domain']),
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
      ifconfigPoolPersist: json['ifconfig_pool_persist'] == '1' || json['ifconfig_pool_persist'] == 1 || json['ifconfig_pool_persist'] == true,
      httpProxy: json['http_proxy'] as String?,
      verifyX509Name: json['verify_x509_name'] as String?,
      verb: _extractSelectedFromArray(json['verb']),
    );
  }

  /// Converts to JSON
  Map<String, dynamic> toJson() {
    return {
      if (vpnid != null) 'vpnid': vpnid,
      'enabled': enabled ? '1' : '0',
      'role': role,
      'description': description,
      'dev_type': devType,
      'proto': proto,
      'port': port,
      if (local != null) 'local': local,
      if (portShare != null) 'port_share': portShare,
      'topology': topology,
      if (remote != null) 'remote': remote,
      if (server != null) 'server': server,
      if (serverIpv6 != null) 'server_ipv6': serverIpv6,
      'nopool': nopool ? '1' : '0',
      if (bridgeGateway != null) 'bridge_gateway': bridgeGateway,
      if (bridgePool != null) 'bridge_pool': bridgePool,
      'route': route,
      'push_route': pushRoute,
      'push_excluded_routes': pushExcludedRoutes,
      if (cert != null) 'cert': cert,
      if (crl != null) 'crl': crl,
      if (ca != null) 'ca': ca,
      if (certDepth != null) 'cert_depth': certDepth,
      if (remoteCertTls != null) 'remote_cert_tls': remoteCertTls,
      if (verifyClientCert != null) 'verify_client_cert': verifyClientCert,
      'use_ocsp': useOcsp ? '1' : '0',
      if (tlsKey != null) 'tls_key': tlsKey,
      if (auth != null) 'auth': auth,
      if (dataCiphers != null) 'data_ciphers': dataCiphers,
      if (dataCiphersFallback != null) 'data_ciphers_fallback': dataCiphersFallback,
      if (authmode != null) 'authmode': authmode,
      if (localGroup != null) 'local_group': localGroup,
      'username_as_common_name': usernameAsCommonName ? '1' : '0',
      'strictusercn': strictusercn ? '1' : '0',
      if (username != null) 'username': username,
      if (password != null) 'password': password,
      if (maxclients != null) 'maxclients': maxclients,
      if (keepaliveInterval != null) 'keepalive_interval': keepaliveInterval,
      if (keepaliveTimeout != null) 'keepalive_timeout': keepaliveTimeout,
      if (renegSec != null) 'reneg_sec': renegSec,
      'auth_gen_token': authGenToken ? '1' : '0',
      if (authGenTokenRenewal != null) 'auth_gen_token_renewal': authGenTokenRenewal,
      if (authGenTokenSecret != null) 'auth_gen_token_secret': authGenTokenSecret,
      'provision_exclusive': provisionExclusive ? '1' : '0',
      'redirect_gateway': redirectGateway ? '1' : '0',
      if (routeMetric != null) 'route_metric': routeMetric,
      'register_dns': registerDns ? '1' : '0',
      if (dnsDomain != null) 'dns_domain': dnsDomain,
      'dns_domain_search': dnsDomainSearch,
      'dns_servers': dnsServers,
      'ntp_servers': ntpServers,
      if (tunMtu != null) 'tun_mtu': tunMtu,
      if (fragment != null) 'fragment': fragment,
      if (mssfix != null) 'mssfix': mssfix,
      if (carpDependOn != null) 'carp_depend_on': carpDependOn,
      'various_flags': _boolMapToJson(variousFlags),
      'various_push_flags': _boolMapToJson(variousPushFlags),
      if (pushInactive != null) 'push_inactive': pushInactive,
      if (compressMigrate != null) 'compress_migrate': compressMigrate,
      'ifconfig_pool_persist': ifconfigPoolPersist ? '1' : '0',
      if (httpProxy != null) 'http_proxy': httpProxy,
      if (verifyX509Name != null) 'verify_x509_name': verifyX509Name,
      if (verb != null) 'verb': verb,
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
    if (json is String) return json; // Already a string
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
    return [];
  }

  static Map<String, bool> _parseBoolMap(dynamic json) {
    if (json == null) return {};
    if (json is! Map) return {};

    final result = <String, bool>{};
    json.forEach((key, value) {
      result[key as String] = value == '1' || value == 1 || value == true;
    });
    return result;
  }

  static Map<String, dynamic> _boolMapToJson(Map<String, bool> map) {
    final result = <String, dynamic>{};
    map.forEach((key, value) {
      result[key] = value ? '1' : '0';
    });
    return result;
  }

  @override
  String toString() => 'OpenvpnInstance(vpnid: $vpnid, role: $role, description: $description)';
}


