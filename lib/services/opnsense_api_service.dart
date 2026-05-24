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
import '../models/firewall_rule.dart';
import '../models/firewall_alias.dart';
import '../models/vpn_connection.dart';
import '../models/network_host.dart';
import '../models/wireguard_server.dart';
import '../models/wireguard_peer.dart';
import '../models/wireguard_key_pair.dart';
import '../models/wireguard_client_builder.dart';
import '../models/wireguard_status.dart';
import '../models/tailscale_status.dart';
import '../models/tailscale_settings.dart';
import '../utils/constants.dart';

// Import all specialized services
import 'system/system_service.dart';
import 'firewall/firewall_service.dart';
import 'firewall/firewall_alias_service.dart' as alias_service;
import 'vpn/vpn_service.dart';
import 'vpn/wireguard_service.dart';
import 'network/network_service.dart';
import 'network/dhcp_service.dart';
import 'network/gateway_service.dart';
import 'network/vip_service.dart';
import 'services/service_control_service.dart';
import 'tailscale/tailscale_service.dart';

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
  final NetworkService _networkService = NetworkService();
  final DHCPService _dhcpService = DHCPService();
  final GatewayService _gatewayService = GatewayService();
  final VipService _vipService = VipService();
  final ServiceControlService _serviceControlService = ServiceControlService();
  final TailscaleService _tailscaleService = TailscaleService();

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
    _networkService.init(_dio!, config);
    _dhcpService.init(_dio!, config);
    _gatewayService.init(_dio!, config);
    _vipService.init(_dio!, config);
    _serviceControlService.init(_dio!, config);
    _tailscaleService.init(_dio!, config);
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
    _networkService.clear();
    _dhcpService.clear();
    _gatewayService.clear();
    _vipService.clear();
    _serviceControlService.clear();
    _tailscaleService.clear();
    
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
  
  Future<void> rebootSystem() => _systemService.rebootSystem();

  // ============================================================================
  // Firewall Service Delegations
  // ============================================================================

  Future<List<FirewallRule>> getFirewallRules() => _firewallService.getFirewallRules();
  
  Future<Map<String, String>> getAvailableInterfaces() => _firewallService.getAvailableInterfaces();
  
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
  
  Future<void> applyFirewallAliasChanges() => _firewallAliasService.applyFirewallAliasChanges();
  
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

  Future<Map<String, dynamic>> getWireGuardLogs({
    int rowCount = 50,
    List<String>? severity,
    double? validFrom,
  }) => _wireguardService.getWireGuardLogs(
    rowCount: rowCount,
    severity: severity,
    validFrom: validFrom,
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
  // Gateway Service Delegations
  // ============================================================================

  Future<List<dynamic>> getGateways() => _gatewayService.getGateways();

  // ============================================================================
  // Service Control Service Delegations
  // ============================================================================

  Future<List<dynamic>> getServices() => _serviceControlService.getServices();
  
  Future<bool> controlService(String serviceName, String action) => _serviceControlService.controlService(serviceName, action);

  // ============================================================================
  // Tailscale Service Delegations
  // ============================================================================

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
}


