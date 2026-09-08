/*
 * OPNsense Manager - Flutter application for managing OPNsense firewalls
 * Copyright (C) 2026 OPNsense Manager
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import '../models/opnsense_config.dart';
import '../models/system_info.dart';
import '../models/thermal_sensor.dart';
import '../models/firewall_rule.dart';
import '../models/firewall_form_options.dart';
import '../models/firewall_alias.dart';
import '../models/vpn_connection.dart';
import '../models/insight_flow_detail.dart';
import '../models/netflow_cache_stat.dart';
import '../models/netflow_config.dart';
import '../models/netflow_status.dart';
import '../models/network_host.dart';
import '../models/network_insight_direction_total.dart';
import '../models/network_insight_timeserie.dart';
import '../models/network_insight_top_addr.dart';
import '../models/network_insight_top_port.dart';
import '../models/wireguard_server.dart';
import '../models/wireguard_peer.dart';
import '../models/wireguard_key_pair.dart';
import '../models/wireguard_client_builder.dart';
import '../models/wireguard_status.dart';
import '../models/tailscale_status.dart';
import '../models/tailscale_settings.dart';
import '../models/wol_host.dart';
import '../models/openvpn_instance.dart';
import '../models/openvpn_search_response.dart';
import '../models/openvpn_static_key.dart';
import '../models/openvpn_client_override.dart';
import '../models/openvpn_client_override_search_response.dart';
import '../models/openvpn_session_search_response.dart';
import '../models/openvpn_route_search_response.dart';
import '../models/openvpn_log_search_response.dart';
import '../models/neighbor.dart';
import '../models/unbound_overview_status.dart';
import '../models/unbound_query_item.dart';
import '../models/unbound_rolling.dart';
import '../models/unbound_settings.dart';
import '../models/unbound_totals.dart';
import '../utils/constants.dart';

// Import all specialized services
import 'system/system_service.dart';
import 'firewall/firewall_service.dart';
import 'firewall/firewall_alias_service.dart' as alias_service;
import 'vpn/vpn_service.dart';
import 'vpn/wireguard_service.dart';
import 'network/netflow_config_service.dart';
import 'network/network_insight_service.dart';
import 'network/network_service.dart';
import 'network/dhcp_service.dart';
import 'network/gateway_service.dart';
import 'network/vip_service.dart';
import 'network/wol_service.dart';
import 'network/neighbor_discovery_service.dart';
import 'services/service_control_service.dart';
import 'tailscale/tailscale_service.dart';
import 'vpn/openvpn_service.dart';
import 'system/system_log_service.dart';
import 'unbound/unbound_dns_service.dart';

// Re-export ApiException and helper classes for backward compatibility
export 'base/api_exception.dart';
export '../models/firewall_alias.dart' show AliasCategory, AliasCountry, AliasTableEntry;
export 'network/vip_service.dart' show CarpVipOption;

/// Facade service for interacting with OPNsense API
/// 
/// This service maintains backward compatibility with the original monolithic
/// service while delegating to specialized services internally.
class OPNsenseApiService {
  static final OPNsenseApiService _instance = OPNsenseApiService._internal();
  factory OPNsenseApiService() => _instance;
  OPNsenseApiService._internal();

  // Service instances
  final SystemService _systemService = SystemService();
  final FirewallService _firewallService = FirewallService();
  final alias_service.FirewallAliasService _firewallAliasService = alias_service.FirewallAliasService();
  final VPNService _vpnService = VPNService();
  final WireGuardService _wireguardService = WireGuardService();
  final OpenvpnService _openvpnService = OpenvpnService();
  final NetworkService _networkService = NetworkService();
  final DHCPService _dhcpService = DHCPService();
  final GatewayService _gatewayService = GatewayService();
  final VipService _vipService = VipService();
  final WolService _wolService = WolService();
  final NeighborDiscoveryService _neighborDiscoveryService = NeighborDiscoveryService();
  final ServiceControlService _serviceControlService = ServiceControlService();
  final TailscaleService _tailscaleService = TailscaleService();
  final SystemLogService _systemLogService = SystemLogService();
  final NetflowConfigService _netflowConfigService = NetflowConfigService();
  final NetworkInsightService _networkInsightService = NetworkInsightService();
  final UnboundDnsService _unboundDnsService = UnboundDnsService();

  Dio? _dio;
  OPNsenseConfig? _config;

  /// Check if service is initialized
  bool get isInitialized => _dio != null && _config != null;

  /// Initialize the API service with configuration
  void init(OPNsenseConfig config) {
    _config = config;
    
    _dio = Dio(
      BaseOptions(
        baseUrl: config.baseUrl,
        connectTimeout: AppConstants.apiTimeout,
        receiveTimeout: AppConstants.apiTimeout,
        headers: {
          'Authorization': config.authHeader,
        },
        validateStatus: (status) => status! < 500,
      ),
    );

    if (config.allowSelfSignedCerts) {
      (_dio!.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
        final client = HttpClient();
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) =>
                host == config.host && port == config.port;
        return client;
      };
    }

    // Initialize all specialized services
    _systemService.init(_dio!, config);
    _firewallService.init(_dio!, config);
    _firewallAliasService.init(_dio!, config);
    _vpnService.init(_dio!, config);
    _wireguardService.init(_dio!, config);
    _openvpnService.init(_dio!, config);
    _networkService.init(_dio!, config);
    _dhcpService.init(_dio!, config);
    _gatewayService.init(_dio!, config);
    _vipService.init(_dio!, config);
    _wolService.init(_dio!, config);
    _neighborDiscoveryService.init(_dio!, config);
    _serviceControlService.init(_dio!, config);
    _tailscaleService.init(_dio!, config);
    _systemLogService.init(_dio!, config);
    _netflowConfigService.init(_dio!, config);
    _networkInsightService.init(_dio!, config);
    _unboundDnsService.init(_dio!, config);
  }

  /// Test connection to OPNsense
  Future<bool> testConnection() async {
    if (!isInitialized) {
      return false;
    }

    try {
      final response = await _dio!.get(
        '/core/system/status',
        options: Options(
          receiveTimeout: AppConstants.connectionTestTimeout,
          sendTimeout: AppConstants.connectionTestTimeout,
        ),
      );
      
      // Accept various status codes that indicate server is reachable
      if (response.statusCode == 200 ||
          response.statusCode == 400 ||
          response.statusCode == 401 ||
          response.statusCode == 403) {
        return true;
      }
      
      return false;
    } on DioException catch (e) {
      if (e.response != null) {
        // If we get a response (even 400/401), the server is reachable
        if (e.response!.statusCode == 400 ||
            e.response!.statusCode == 401 ||
            e.response!.statusCode == 403) {
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Clear service state
  void clear() {
    // Clear all specialized services
    _systemService.clear();
    _firewallService.clear();
    _firewallAliasService.clear();
    _vpnService.clear();
    _wireguardService.clear();
    _openvpnService.clear();
    _networkService.clear();
    _dhcpService.clear();
    _gatewayService.clear();
    _vipService.clear();
    _neighborDiscoveryService.clear();
    _serviceControlService.clear();
    _tailscaleService.clear();
    _systemLogService.clear();
    _netflowConfigService.clear();
    _networkInsightService.clear();
    _unboundDnsService.clear();

    // Clear main service state
    _dio = null;
    _config = null;
  }

  // ============================================================================
  // System Service Delegations
  // ============================================================================

  Future<Map<String, dynamic>> getSystemStatus() => _systemService.getSystemStatus();
  
  Future<Map<String, dynamic>> getSystemInformation() => _systemService.getSystemInformation();
  
  Future<Map<String, dynamic>> getSystemActivity() => _systemService.getSystemActivity();
  
  Future<Map<String, dynamic>> getFilesystemInfo() => _systemService.getFilesystemInfo();
  
  Future<Map<String, dynamic>> getSystemResources() => _systemService.getSystemResources();
  
  Future<SystemInfo> getSystemInfo() => _systemService.getSystemInfo();
  
  Future<List<ThermalSensor>> getSystemTemperature() => _systemService.getSystemTemperature();
  
  Future<void> rebootSystem() => _systemService.rebootSystem();
  Future<Map<String, dynamic>> triggerFirmwareCheck() => _systemService.triggerFirmwareCheck();
  Future<Map<String, dynamic>> triggerFirmwareUpdate() => _systemService.triggerFirmwareUpdate();
  Future<Map<String, dynamic>> getFirmwareUpgradeStatus() => _systemService.getFirmwareUpgradeStatus();
  Future<Map<String, dynamic>> getFirmwareStatus() => _systemService.getFirmwareStatus();
  Future<Map<String, dynamic>> getFirmwareChangelog(String version) => _systemService.getFirmwareChangelog(version);

  // ============================================================================
  // Firewall Service Delegations
  // ============================================================================

  Future<List<FirewallRule>> getFirewallRules() => _firewallService.getFirewallRules();
  
  Future<Map<String, String>> getAvailableInterfaces() => _firewallService.getAvailableInterfaces();

  Future<FirewallFormOptions> getFirewallRuleFormOptions() => _firewallService.getFirewallRuleFormOptions();
  
  Future<String> createFirewallRule(FirewallRuleRequest request) => _firewallService.createFirewallRule(request);
  
  Future<FirewallRule?> getFirewallRule(String uuid) => _firewallService.getFirewallRule(uuid);
  
  Future<void> updateFirewallRule(String uuid, FirewallRuleRequest request) => _firewallService.updateFirewallRule(uuid, request);
  
  Future<void> toggleFirewallRule(String uuid) => _firewallService.toggleFirewallRule(uuid);
  
  Future<void> deleteFirewallRule(String uuid) => _firewallService.deleteFirewallRule(uuid);
  
  Future<void> applyFirewallChanges() => _firewallService.applyFirewallChanges();
  
  Future<List<dynamic>> getFirewallLogs({int limit = 100}) => _firewallService.getFirewallLogs(limit: limit);

  // ============================================================================
  // Firewall Alias Service Delegations
  // ============================================================================

  Future<List<FirewallAlias>> getFirewallAliases() => _firewallAliasService.getFirewallAliases();
  
  Future<FirewallAlias> getFirewallAlias(String uuid) => _firewallAliasService.getFirewallAlias(uuid);
  
  Future<String?> getAliasUuidByName(String name) => _firewallAliasService.getAliasUuidByName(name);
  
  Future<Map<String, dynamic>> createFirewallAlias(FirewallAliasRequest request) => _firewallAliasService.createFirewallAlias(request);
  
  Future<Map<String, dynamic>> updateFirewallAlias(String uuid, FirewallAliasRequest request) => _firewallAliasService.updateFirewallAlias(uuid, request);
  
  Future<void> toggleFirewallAlias(String uuid) => _firewallAliasService.toggleFirewallAlias(uuid);
  
  Future<void> deleteFirewallAlias(String uuid) => _firewallAliasService.deleteFirewallAlias(uuid);
  
  
  Future<Map<String, dynamic>> getGeoIP() => _firewallAliasService.getGeoIP();
  
  Future<Map<String, dynamic>> getAliasTableSize() => _firewallAliasService.getAliasTableSize();
  
  Future<List<AliasCategory>> listAliasCategories() => _firewallAliasService.listAliasCategories();
  
  Future<List<AliasCountry>> listAliasCountries() => _firewallAliasService.listAliasCountries();
  
  Future<Map<String, dynamic>> listNetworkAliases() => _firewallAliasService.listNetworkAliases();
  
  Future<Map<String, dynamic>> listUserGroups() => _firewallAliasService.listUserGroups();
  
  Future<Map<String, dynamic>> getAliasesUtil() => _firewallAliasService.getAliasesUtil();
  
  Future<List<AliasTableEntry>> listAliasTable(String aliasName) => _firewallAliasService.listAliasTable(aliasName);
  
  Future<Map<String, dynamic>> addToAliasTable(String aliasName, String address) => _firewallAliasService.addToAliasTable(aliasName, address);
  
  Future<Map<String, dynamic>> deleteFromAliasTable(String aliasName, String address) => _firewallAliasService.deleteFromAliasTable(aliasName, address);
  
  Future<Map<String, dynamic>> flushAliasTable(String aliasName) => _firewallAliasService.flushAliasTable(aliasName);
  
  Future<Map<String, dynamic>> findAliasReferences(String aliasName) => _firewallAliasService.findAliasReferences(aliasName);
  
  Future<Map<String, dynamic>> updateBogons() => _firewallAliasService.updateBogons();
  
  Future<Map<String, dynamic>> getAliasItemDefaults() => _firewallAliasService.getAliasItemDefaults();

  // ============================================================================
  // VPN Service Delegations
  // ============================================================================

  Future<List<VPNConnection>> getVPNConnections() => _vpnService.getVPNConnections();
  
  Future<VPNConnection?> getTailscaleStatus() => _vpnService.getTailscaleStatus();
  
  Future<TailscaleStatus> getTailscaleDetails() => _vpnService.getTailscaleDetails();
  
  Future<bool> toggleVPNConnection(String id, String type, bool currentStatus) => _vpnService.toggleVPNConnection(id, type, currentStatus);
  
  Future<bool> restartVPNService(String type) => _vpnService.restartVPNService(type);
  
  Future<VPNConnection?> getVPNConnectionDetails(String id, String type) => _vpnService.getVPNConnectionDetails(id, type);

  // ============================================================================
  // WireGuard Service Delegations
  // ============================================================================

  Future<List<WireGuardServer>> getWireGuardServers() => _wireguardService.getWireGuardServers();
  
  Future<WireGuardServer> getWireGuardServer(String uuid) => _wireguardService.getWireGuardServer(uuid);
  
  Future<String> createWireGuardServer(WireGuardServerRequest request) => _wireguardService.createWireGuardServer(request);
  
  Future<void> updateWireGuardServer(String uuid, WireGuardServerRequest request) => _wireguardService.updateWireGuardServer(uuid, request);
  
  Future<void> deleteWireGuardServer(String uuid) => _wireguardService.deleteWireGuardServer(uuid);
  
  Future<void> toggleWireGuardServer(String uuid, bool enabled) => _wireguardService.toggleWireGuardServer(uuid, enabled);
  
  Future<Map<String, dynamic>> searchWireGuardPeers({int current = 1, int rowCount = 50, Map<String, dynamic>? sort}) =>
      _wireguardService.searchClients(current: current, rowCount: rowCount, sort: sort);
  
  Future<List<WireGuardPeer>> getWireGuardPeers() => _wireguardService.getWireGuardPeers();
  
  Future<Map<String, dynamic>> getPeer(String uuid) => _wireguardService.getPeer(uuid);
  
  Future<WireGuardPeer> getWireGuardPeer(String uuid) => _wireguardService.getWireGuardPeer(uuid);
  
  Future<String> createWireGuardPeer(WireGuardPeerRequest request) => _wireguardService.createWireGuardPeer(request);
  
  Future<void> updateWireGuardPeer(String uuid, WireGuardPeerRequest request) => _wireguardService.updateWireGuardPeer(uuid, request);
  
  Future<void> deleteWireGuardPeer(String uuid) => _wireguardService.deleteWireGuardPeer(uuid);
  
  Future<void> toggleWireGuardPeer(String uuid, bool enabled) => _wireguardService.toggleWireGuardPeer(uuid, enabled);
  
  Future<WireGuardKeyPair> generateWireGuardKeyPair() => _wireguardService.generateWireGuardKeyPair();
  
  Future<String> generateWireGuardPSK() => _wireguardService.generateWireGuardPSK();
  
  Future<void> applyWireGuardConfiguration() => _wireguardService.reconfigureWireGuard();
  
  Future<Map<String, dynamic>> getWireGuardStatus() => _wireguardService.getWireGuardStatus();
  
  Future<WireGuardStatusResponse> getWireGuardStatusResponse() => _wireguardService.getStatus();
  
  Future<void> restartWireGuardService() => _wireguardService.restartWireGuardService();
  
  Future<void> startWireGuardInstance(String uuid) => _wireguardService.startWireGuardInstance(uuid);
  
  Future<void> stopWireGuardInstance(String uuid) => _wireguardService.stopWireGuardInstance(uuid);
  
  Future<WireGuardClientBuilder> getClientBuilder() => _wireguardService.getClientBuilder();
  
  Future<WireGuardServerInfo> getServerInfo(String uuid) => _wireguardService.getServerInfo(uuid);
  
  Future<void> addClientBuilder(WireGuardClientBuilderRequest request) => _wireguardService.addClientBuilder(request);
  
  Future<Map<String, dynamic>> reconfigureWireGuard() => _wireguardService.reconfigureWireGuard();
  
  Future<Map<String, dynamic>> startWireGuardService() => _wireguardService.startWireGuardService();
  
  Future<Map<String, dynamic>> stopWireGuardService() => _wireguardService.stopWireGuardService();
  
  Future<void> restartWireGuardInstance(String uuid) => _wireguardService.restartWireGuardInstance(uuid);

  Future<OpenvpnLogSearchResponse> getWireGuardLogs({
    int rowCount = 50,
    List<String>? severity,
    double? validFrom,
  }) => _wireguardService.getWireGuardLogs(
    rowCount: rowCount,
    severity: severity,
    validFrom: validFrom,
  );

  Future<OpenvpnLogSearchResponse> searchOpenvpnLogs({
    int current = 1,
    int rowCount = 50,
    Map<String, dynamic>? sort,
    List<String>? severity,
    double? validFrom,
  }) => _openvpnService.searchLogs(
    current: current,
    rowCount: rowCount,
    sort: sort,
    severity: severity,
    validFrom: validFrom,
  );

  // ── System Log Files ─────────────────────────────────────────────────────────

  Future<OpenvpnLogSearchResponse> searchAuditLogs({
    int current = 1,
    int rowCount = 50,
    Map<String, dynamic>? sort,
    List<String>? severity,
    double? validFrom,
  }) => _systemLogService.searchAuditLogs(
    current: current, rowCount: rowCount, sort: sort,
    severity: severity, validFrom: validFrom,
  );

  Future<OpenvpnLogSearchResponse> searchBackendLogs({
    int current = 1,
    int rowCount = 50,
    Map<String, dynamic>? sort,
    List<String>? severity,
    double? validFrom,
  }) => _systemLogService.searchBackendLogs(
    current: current, rowCount: rowCount, sort: sort,
    severity: severity, validFrom: validFrom,
  );

  Future<OpenvpnLogSearchResponse> searchBootLogs({
    int current = 1,
    int rowCount = 50,
    Map<String, dynamic>? sort,
    List<String>? severity,
    double? validFrom,
  }) => _systemLogService.searchBootLogs(
    current: current, rowCount: rowCount, sort: sort,
    severity: severity, validFrom: validFrom,
  );

  Future<OpenvpnLogSearchResponse> searchGeneralLogs({
    int current = 1,
    int rowCount = 50,
    Map<String, dynamic>? sort,
    List<String>? severity,
    double? validFrom,
  }) => _systemLogService.searchGeneralLogs(
    current: current, rowCount: rowCount, sort: sort,
    severity: severity, validFrom: validFrom,
  );

  Future<OpenvpnLogSearchResponse> searchWebGuiLogs({
    int current = 1,
    int rowCount = 50,
    Map<String, dynamic>? sort,
    List<String>? severity,
    double? validFrom,
  }) => _systemLogService.searchWebGuiLogs(
    current: current, rowCount: rowCount, sort: sort,
    severity: severity, validFrom: validFrom,
  );

  // ============================================================================
  // Network Service Delegations
  // ============================================================================

  Future<List<Map<String, dynamic>>> getTrafficTop(String interface) => _networkService.getTrafficTop(interface);
  
  Future<List<NetworkHost>> getNetworkHosts({String interface = 'lan'}) => _networkService.getNetworkHosts(interface: interface);

  // ============================================================================
  // VIP Service Delegations
  // ============================================================================

  Future<List<CarpVipOption>> getCarpVipOptions() => _vipService.getCarpVipOptions();

  // ============================================================================
  // DHCP Service Delegations
  // ============================================================================

  Future<List<Map<String, dynamic>>> getDhcpLeases() => _dhcpService.getDhcpLeases();

  // ============================================================================
  // Neighbor Discovery Service Delegations
  // ============================================================================

  Future<NeighborDiscoveryStatus> checkNeighborDiscoveryStatus() =>
      _neighborDiscoveryService.checkStatus();

  Future<NeighborDiscoveryResponse> getNeighbors({
    int current = 1,
    int rowCount = 50,
    String? searchPhrase,
  }) async {
    return await _neighborDiscoveryService.searchNeighbors(
      current: current,
      rowCount: rowCount,
      searchPhrase: searchPhrase,
    );
  }

  Future<Map<String, dynamic>> startNeighborDiscoveryService() =>
      _neighborDiscoveryService.startService();

  Future<Map<String, dynamic>> stopNeighborDiscoveryService() =>
      _neighborDiscoveryService.stopService();

  Future<Map<String, dynamic>> restartNeighborDiscoveryService() =>
      _neighborDiscoveryService.restartService();

  // ============================================================================
  // WOL Service Delegations
  // ============================================================================

  Future<bool> isWolPluginAvailable() => _wolService.isWolPluginAvailable();

  Future<List<WolHost>> getWolHosts() => _wolService.getHosts();
  
  Future<Map<String, WolInterfaceOption>> getWolInterfaceOptions() => _wolService.getInterfaceOptions();
  
  Future<String> addWolHost(String interface, String mac, String description) =>
      _wolService.addHost(interface, mac, description);
  
  Future<void> updateWolHost(String uuid, String interface, String mac, String description) =>
      _wolService.updateHost(uuid, interface, mac, description);
  
  Future<void> deleteWolHost(String uuid) => _wolService.deleteHost(uuid);
  
  Future<void> wakeHost(String uuid) => _wolService.wakeHost(uuid);

  Future<Map<String, dynamic>> copyWolHost(String uuid) => _wolService.copyHost(uuid);
  
  Future<List<WolWakeAllResult>> wakeAllHosts() => _wolService.wakeAllHosts();

  // ============================================================================
  // Gateway Service Delegations
  // ============================================================================

  Future<List<dynamic>> getGateways() => _gatewayService.getGateways();

  // ============================================================================
  // Service Control Service Delegations
  // ============================================================================

  Future<List<dynamic>> getServices() => _serviceControlService.getServices();
  
  Future<bool> controlService(String serviceName, String action) => _serviceControlService.controlService(serviceName, action);

  // ============================================================================
  // OpenVPN Service Delegations
  // ============================================================================

  Future<OpenvpnSearchResponse> searchOpenvpnInstances({
    int current = 1,
    int rowCount = 50,
    Map<String, dynamic>? sort,
    String? searchPhrase,
    String? enabled,
  }) => _openvpnService.searchInstances(
        current: current,
        rowCount: rowCount,
        sort: sort,
        searchPhrase: searchPhrase,
        enabled: enabled,
      );
  
  Future<OpenvpnInstance> getOpenvpnInstance(String? vpnid) => _openvpnService.getInstance(vpnid);
  
  Future<Map<String, dynamic>> addOpenvpnInstance(OpenvpnInstance instance) => _openvpnService.addInstance(instance);
  
  Future<Map<String, dynamic>> updateOpenvpnInstance(String vpnid, OpenvpnInstance instance) => _openvpnService.updateInstance(vpnid, instance);
  
  Future<Map<String, dynamic>> deleteOpenvpnInstance(String vpnid) => _openvpnService.deleteInstance(vpnid);
  
  
  Future<Map<String, dynamic>> reconfigureOpenvpn() => _openvpnService.reconfigureOpenvpn();
  Future<Map<String, dynamic>> toggleOpenvpnInstance(String vpnid) => _openvpnService.toggleInstance(vpnid);
  
  Future<String> generateOpenvpnAuthToken() => _openvpnService.generateAuthToken();
  
  Future<OpenvpnStaticKeySearchResponse> searchOpenvpnStaticKeys({
    int current = 1,
    int rowCount = 50,
  }) => _openvpnService.searchStaticKeys(current: current, rowCount: rowCount);
  
  Future<OpenvpnStaticKey> getOpenvpnStaticKey(String? keyid) => _openvpnService.getStaticKey(keyid);
  
  Future<String> generateOpenvpnStaticKey(String mode) => _openvpnService.generateStaticKey(mode);
  
  Future<Map<String, dynamic>> addOpenvpnStaticKey(OpenvpnStaticKey key) => _openvpnService.addStaticKey(key);
  
  Future<Map<String, dynamic>> updateOpenvpnStaticKey(String keyid, OpenvpnStaticKey key) => _openvpnService.updateStaticKey(keyid, key);
  
  Future<Map<String, dynamic>> deleteOpenvpnStaticKey(String keyid) => _openvpnService.deleteStaticKey(keyid);

  // Client Specific Override methods
  Future<OpenvpnClientOverrideSearchResponse> searchClientOverrides({
    int current = 1,
    int rowCount = 50,
    Map<String, dynamic>? sort,
    String? searchPhrase,
  }) => _openvpnService.searchClientOverrides(
        current: current,
        rowCount: rowCount,
        sort: sort,
        searchPhrase: searchPhrase,
      );

  Future<OpenvpnClientOverride> getClientOverride(String? uuid) => _openvpnService.getClientOverride(uuid);

  Future<Map<String, dynamic>> setClientOverride(String uuid, OpenvpnClientOverride override) =>
      _openvpnService.setClientOverride(uuid, override);

  Future<Map<String, dynamic>> deleteClientOverride(String uuid) => _openvpnService.deleteClientOverride(uuid);

  Future<Map<String, dynamic>> toggleClientOverride(String uuid) => _openvpnService.toggleClientOverride(uuid);

  // Connection Status methods
  Future<OpenvpnSessionSearchResponse> searchSessions({
    int current = 1,
    int rowCount = 50,
    Map<String, dynamic>? sort,
  }) => _openvpnService.searchSessions(
        current: current,
        rowCount: rowCount,
        sort: sort,
      );

  Future<Map<String, dynamic>> startService(String id) => _openvpnService.startService(id);

  Future<Map<String, dynamic>> stopService(String id) => _openvpnService.stopService(id);

  Future<Map<String, dynamic>> restartService(String id) => _openvpnService.restartService(id);

  Future<OpenvpnRouteSearchResponse> searchRoutes({
    int current = 1,
    int rowCount = 50,
    Map<String, dynamic>? sort,
  }) => _openvpnService.searchRoutes(
        current: current,
        rowCount: rowCount,
        sort: sort,
      );

  // ============================================================================
  // Tailscale Service Delegations
  // ============================================================================

  Future<bool> isTailscalePluginAvailable() => _tailscaleService.isTailscalePluginAvailable();

  Future<bool> controlTailscaleService(String action) => _tailscaleService.controlTailscaleService(action);
  
  Future<bool> updateTailscaleSettings(Map<String, dynamic> settings) => _tailscaleService.updateTailscaleSettings(settings);
  
  Future<Map<String, String?>> getTailscaleAuthentication() => _tailscaleService.getTailscaleAuthentication();
  
  Future<bool> setTailscaleAuthentication(String loginServer, String preAuthKey) => _tailscaleService.setTailscaleAuthentication(loginServer, preAuthKey);
  
  Future<bool> logoutTailscale() => _tailscaleService.logoutTailscale();
  
  Future<TailscaleSettingsResponse> getTailscaleSettings() => _tailscaleService.getTailscaleSettings();
  
  Future<Map<String, dynamic>> setTailscaleSettings(TailscaleSettings settings) => _tailscaleService.setTailscaleSettings(settings);
  
  Future<TailscaleSubnetSearchResponse> searchTailscaleSubnets() => _tailscaleService.searchTailscaleSubnets();
  
  Future<TailscaleSubnetResponse> getTailscaleSubnet(String uuid) => _tailscaleService.getTailscaleSubnet(uuid);
  
  Future<Map<String, dynamic>> addTailscaleSubnet(TailscaleSubnet subnet) => _tailscaleService.addTailscaleSubnet(subnet);
  
  Future<Map<String, dynamic>> setTailscaleSubnet(String uuid, TailscaleSubnet subnet) => _tailscaleService.setTailscaleSubnet(uuid, subnet);
  
  Future<Map<String, dynamic>> deleteTailscaleSubnet(String uuid) => _tailscaleService.deleteTailscaleSubnet(uuid);
  
  Future<Map<String, dynamic>> reloadTailscaleSettings() => _tailscaleService.reloadTailscaleSettings();

  // ============================================================================
  // NetFlow Config Service Delegations
  // ============================================================================

  Future<NetflowConfig> getNetflowConfig() =>
      _netflowConfigService.getConfig();

  Future<void> saveNetflowConfig(NetflowConfig config) =>
      _netflowConfigService.saveConfig(config);

  Future<void> reconfigureNetflow() =>
      _netflowConfigService.reconfigure();

  Future<void> resetNetflowData() =>
      _netflowConfigService.resetData();

  Future<List<NetflowCacheStat>> getNetflowCacheStats() =>
      _netflowConfigService.getCacheStats();

  // ============================================================================
  // Network Insight Service Delegations
  // ============================================================================

  Future<NetflowStatus> checkNetflowEnabled() =>
      _networkInsightService.checkNetflowEnabled();

  Future<Map<String, String>> getInsightInterfaces() =>
      _networkInsightService.getInterfaces();

  Future<List<NetworkInsightSeries>> getInsightTimeseries({
    required int startTs,
    required int endTs,
    required int resolution,
  }) =>
      _networkInsightService.getTimeseries(
        startTs: startTs,
        endTs: endTs,
        resolution: resolution,
      );

  Future<List<NetworkInsightTopPort>> getInsightTopPorts({
    required String interface,
    required int startTs,
    required int endTs,
  }) =>
      _networkInsightService.getTopPorts(
        interface: interface,
        startTs: startTs,
        endTs: endTs,
      );

  Future<List<NetworkInsightTopAddr>> getInsightTopAddresses({
    required String interface,
    required int startTs,
    required int endTs,
  }) =>
      _networkInsightService.getTopAddresses(
        interface: interface,
        startTs: startTs,
        endTs: endTs,
      );

  Future<Map<String, String>> reverseLookupAddresses(
          List<String> addresses) =>
      _networkInsightService.reverseLookup(addresses);

  Future<List<NetworkInsightDirectionTotal>> getInsightDirectionTotals({
    required String interface,
    required int startTs,
    required int endTs,
    required String measure,
  }) =>
      _networkInsightService.getDirectionTotals(
        interface: interface,
        startTs: startTs,
        endTs: endTs,
        measure: measure,
      );

  Future<List<InsightFlowDetail>> getInsightFlowDetails({
    required int startTs,
    required int endTs,
    required String interface,
    String? extraFilterField,
    String? extraFilterValue,
    String? dstPort,
    String? dstAddr,
    String? srcAddr,
  }) =>
      _networkInsightService.getFlowDetails(
        startTs: startTs,
        endTs: endTs,
        interface: interface,
        extraFilterField: extraFilterField,
        extraFilterValue: extraFilterValue,
        dstPort: dstPort,
        dstAddr: dstAddr,
        srcAddr: srcAddr,
      );

  Future<String> exportInsightData({
    required String collection,
    required int fromTs,
    required int toTs,
    required int resolution,
  }) =>
      _networkInsightService.exportNetflowData(
        collection: collection,
        fromTs: fromTs,
        toTs: toTs,
        resolution: resolution,
      );

  // ============================================================================
  // Unbound DNS Reporting Delegations
  // ============================================================================

  Future<UnboundOverviewStatus> checkUnboundOverviewEnabled() =>
      _unboundDnsService.checkIsEnabled();

  Future<UnboundTotals> getUnboundTotals({int limit = 10}) =>
      _unboundDnsService.getTotals(limit: limit);

  Future<List<UnboundRollingPoint>> getUnboundRolling(int hours) =>
      _unboundDnsService.getRolling(hours);

  Future<List<UnboundRollingClientPoint>> getUnboundClientActivity(int hours) =>
      _unboundDnsService.getClientActivity(hours);

  Future<UnboundQuerySearchResponse> searchUnboundQueries({
    int current = 1,
    int rowCount = 50,
    String? searchPhrase,
    String? client,
    int? timeStart,
    int? timeEnd,
  }) =>
      _unboundDnsService.searchQueries(
        current: current,
        rowCount: rowCount,
        searchPhrase: searchPhrase,
        client: client,
        timeStart: timeStart,
        timeEnd: timeEnd,
      );

  Future<UnboundSettings> getUnboundSettings() =>
      _unboundDnsService.getSettings();

  Future<void> setUnboundStatsEnabled(bool enabled) =>
      _unboundDnsService.setStatsEnabled(enabled);

  Future<void> reconfigureUnboundGeneral() =>
      _unboundDnsService.reconfigureGeneral();

  Future<void> resetUnboundDnsData() =>
      _unboundDnsService.resetDnsData();

  Future<String> getUnboundServiceStatus() =>
      _unboundDnsService.getServiceStatus();
}


