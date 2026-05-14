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
import '../models/wireguard_client.dart';
import '../models/wireguard_peer.dart';
import '../models/wireguard_key_pair.dart';
import '../models/tailscale_status.dart';
import '../models/tailscale_settings.dart';
import '../utils/constants.dart';
import 'dhcp_lease_adapter.dart';

/// Service for interacting with OPNsense API
class OPNsenseApiService {
  static final OPNsenseApiService _instance = OPNsenseApiService._internal();
  factory OPNsenseApiService() => _instance;
  OPNsenseApiService._internal();

  Dio? _dio;
  OPNsenseConfig? _config;
  

  /// Parse storage string like "8.0G" or "40G" to bytes
  int _parseStorageString(String value) {
    // Remove any whitespace
    value = value.trim();
    
    // Extract number and unit
    final match = RegExp(r'([\d.]+)([KMGT]?)').firstMatch(value);
    if (match == null) return 0;
    
    final number = double.tryParse(match.group(1) ?? '0') ?? 0;
    final unit = match.group(2) ?? '';
    
    // Convert to bytes
    switch (unit.toUpperCase()) {
      case 'T':
        return (number * 1024 * 1024 * 1024 * 1024).toInt();
      case 'G':
        return (number * 1024 * 1024 * 1024).toInt();
      case 'M':
        return (number * 1024 * 1024).toInt();
      case 'K':
        return (number * 1024).toInt();
      default:
        return number.toInt(); // Assume bytes if no unit
    }
  }

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
          // Don't set Content-Type globally - let Dio handle it per request
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
  }

  /// Check if service is initialized
  bool get isInitialized => _dio != null && _config != null;

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
      
      // Accept various status codes that indicate server is reachable:
      // 200 = Success
      // 400 = Bad Request (server reachable, might need different endpoint/auth)
      // 401 = Unauthorized (server reachable, needs credentials)
      // 403 = Forbidden (server reachable, insufficient permissions)
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
        // 400 = Bad Request (server reachable, endpoint might need auth)
        // 401 = Unauthorized (server reachable, needs valid credentials)
        // 403 = Forbidden (server reachable, insufficient permissions)
        if (e.response!.statusCode == 400 ||
            e.response!.statusCode == 401 ||
            e.response!.statusCode == 403) {
          return true;
        }
      }
      
      // Check for certificate validation errors and throw a more specific exception
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.unknown) {
        if (e.message?.contains('CERTIFICATE_VERIFY_FAILED') == true ||
            e.message?.contains('certificate') == true ||
            e.error is HandshakeException) {
          throw ApiException(
            'Certificate validation failed. The server is using a self-signed certificate. '
            'Please enable "Allow Self-Signed Certificates" in connection settings.',
            null,
          );
        }
      }
      
      // Network errors (timeout, connection refused, etc.)
      return false;
    } catch (e) {
      // Re-throw ApiException so it can be caught by the caller
      if (e is ApiException) {
        rethrow;
      }
      // Silently handle other errors
      return false;
    }
  }

  // ==================== System Information ====================

  /// Get system status
  Future<Map<String, dynamic>> getSystemStatus() async {
    _ensureInitialized();

    try {
      final response = await _dio!.get('/core/system/status');
      
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw ApiException('Failed to get system status', response.statusCode);
      }
    } on DioException catch (e) {
      if (e.response != null) {
      }
      throw _handleDioError(e);
    }
  }

  /// Get system information (hostname, version, etc.)
  Future<Map<String, dynamic>> getSystemInformation() async {
    _ensureInitialized();

    try {
      final response = await _dio!.get('/core/firmware/info');
      
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
    } catch (_) {
      // Silently handle error
    }

    // Try alternative endpoints
    try {
      final response = await _dio!.get('/core/firmware/status');
      
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
    } catch (_) {
      // Silently handle error
    }

    try {
      final response = await _dio!.get('/core/system/info');
      
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
    } catch (_) {
      // Silently handle error
    }

    return {};
  }

  /// Get system activity (CPU, uptime)
  Future<Map<String, dynamic>> getSystemActivity() async {
    _ensureInitialized();

    try {
      final response = await _dio!.get('/diagnostics/activity/getActivity');
      
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
    } catch (_) {
      // Silently handle error
    }

    return {};
  }

  /// Get filesystem information
  Future<Map<String, dynamic>> getFilesystemInfo() async {
    _ensureInitialized();

    // Try multiple endpoints for disk information
    try {
      final response = await _dio!.get('/diagnostics/system/systemDisk');
      
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
    } catch (_) {
      // Silently handle error
    }

    // Try alternative endpoint
    try {
      final response = await _dio!.get('/core/system/systemDisk');
      
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
    } catch (_) {
      // Silently handle error
    }

    return {};
  }

  /// Get system resources (CPU, memory, uptime)
  Future<Map<String, dynamic>> getSystemResources() async {
    _ensureInitialized();

    try {
      final response = await _dio!.get('/diagnostics/system/systemResources');
      
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw ApiException('Failed to get system resources', response.statusCode);
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Get complete system information
  Future<SystemInfo> getSystemInfo() async {
    try {
      final resourcesData = await getSystemResources();
      final systemInfoData = await getSystemInformation();
      final activityData = await getSystemActivity();
      final diskData = await getFilesystemInfo();

      // Extract firmware/system details from /api/core/firmware/info
      String type = 'opnsense';
      String version = 'Unknown';
      String architecture = 'amd64';
      String commit = '';
      String mirror = '';
      String repositories = '';
      String? updatedOn;
      
      // Extract from product map (from /core/firmware/status)
      if (systemInfoData.containsKey('product')) {
        final product = systemInfoData['product'] as Map<String, dynamic>?;
        if (product != null) {
          // Version from CORE_VERSION or product_version
          version = product['CORE_VERSION'] as String? ??
                   product['product_version'] as String? ??
                   'Unknown';
          
          // Type from CORE_PRODUCT or CORE_NAME
          type = product['CORE_PRODUCT'] as String? ??
                 product['CORE_NAME'] as String? ??
                 'opnsense';
          
          // Architecture from CORE_ARCH or product_arch
          architecture = product['CORE_ARCH'] as String? ??
                        product['product_arch'] as String? ??
                        'amd64';
          
          // Commit from CORE_HASH or product_hash
          commit = product['CORE_HASH'] as String? ??
                  product['product_hash'] as String? ??
                  '';
          
          // Mirror from product_mirror (from /core/firmware/info)
          mirror = product['product_mirror'] as String? ??
                  product['CORE_PACKAGESITE'] as String? ?? '';
          
          // Repository from product_repos (from /core/firmware/info)
          repositories = product['product_repos'] as String? ?? '';
          if (repositories.isEmpty) {
            final repo = product['CORE_REPOSITORY'] as String? ?? '';
            if (repo.isNotEmpty) {
              repositories = 'OPNsense ($repo)';
            }
          }
          
          // Updated on from product_time (from /core/firmware/info)
          updatedOn = product['product_time'] as String?;
        }
      }
      
      // Fallback checks for updated time
      if (updatedOn == null || updatedOn.isEmpty) {
        if (systemInfoData.containsKey('product_time')) {
          updatedOn = systemInfoData['product_time'] as String?;
        } else if (systemInfoData.containsKey('status_msg')) {
          updatedOn = systemInfoData['status_msg'] as String?;
        } else if (systemInfoData.containsKey('last_check')) {
          updatedOn = systemInfoData['last_check'] as String?;
        }
      }
      
      // Fallback checks for mirror
      if (mirror.isEmpty && systemInfoData.containsKey('product_mirror')) {
        mirror = systemInfoData['product_mirror'] as String? ?? '';
      }
      
      // Fallback checks for repositories
      if (repositories.isEmpty && systemInfoData.containsKey('product_repos')) {
        repositories = systemInfoData['product_repos'] as String? ?? '';
      }
      
      String hostname = 'OPNsense Router';
      String platform = 'FreeBSD';
      
      // Try to get hostname from system info
      if (systemInfoData.containsKey('hostname')) {
        hostname = systemInfoData['hostname'] as String? ?? hostname;
      }
      
      // Try to get platform details
      if (systemInfoData.containsKey('os')) {
        final os = systemInfoData['os'] as Map<String, dynamic>?;
        if (os != null) {
          platform = '${os['name'] ?? 'FreeBSD'} ${os['version'] ?? ''}';
        }
      } else if (systemInfoData.containsKey('os_version')) {
        platform = 'FreeBSD ${systemInfoData['os_version']}';
      }
      
      
      // Parse uptime and CPU from activity headers
      // Headers format: "last pid: 31779;  load averages:  0.86,  1.02,  0.89  up 0+07:16:41    19:59:35"
      // and "CPU:  2.7% user,  0.0% nice,  1.5% system,  0.7% interrupt, 95.0% idle"
      int uptime = 0;
      double cpuUsage = 0.0;
      
      if (activityData.containsKey('headers')) {
        final headers = activityData['headers'] as List?;
        if (headers != null && headers.isNotEmpty) {
          
          // Parse uptime from first header line
          final firstHeader = headers[0] as String;
          
          // Parse uptime: "up 0+07:16:41" means 0 days, 7 hours, 16 minutes, 41 seconds
          final uptimeMatch = RegExp(r'up (\d+)\+(\d+):(\d+):(\d+)').firstMatch(firstHeader);
          if (uptimeMatch != null) {
            final days = int.parse(uptimeMatch.group(1)!);
            final hours = int.parse(uptimeMatch.group(2)!);
            final minutes = int.parse(uptimeMatch.group(3)!);
            final seconds = int.parse(uptimeMatch.group(4)!);
            uptime = (days * 86400) + (hours * 3600) + (minutes * 60) + seconds;
          }
          
          // Parse CPU - check all header lines for CPU info
          for (int i = 0; i < headers.length; i++) {
            final headerLine = headers[i] as String;
            
            // "CPU:  2.0% user,  0.0% nice,  1.4% system,  0.5% interrupt, 96.0% idle"
            if (headerLine.contains('CPU:')) {
              final idleMatch = RegExp(r'(\d+\.?\d*)% idle').firstMatch(headerLine);
              if (idleMatch != null) {
                final idle = double.parse(idleMatch.group(1)!);
                cpuUsage = 100.0 - idle;
                break;
              }
            }
          }
          
          if (cpuUsage == 0.0) {
          }
        }
      }
      
      // Parse memory from nested structure - handle both int and string types
      final memoryData = resourcesData['memory'] as Map<String, dynamic>?;
      
      // Memory values might be int or string, parse safely
      int memoryUsed = 0;
      int memoryTotal = 0;
      
      if (memoryData != null) {
        final usedValue = memoryData['used'];
        final totalValue = memoryData['total'];
        
        if (usedValue is int) {
          memoryUsed = usedValue;
        } else if (usedValue is String) {
          memoryUsed = int.tryParse(usedValue) ?? 0;
        }
        
        if (totalValue is int) {
          memoryTotal = totalValue;
        } else if (totalValue is String) {
          memoryTotal = int.tryParse(totalValue) ?? 0;
        }
      }

      // Parse disk usage from disk data
      // Data format: {device: /dev/gpt/rootfs, blocks: 40G, used: 8.0G, ...}
      int diskUsed = 0;
      int diskTotal = 0;
      
      if (diskData.isNotEmpty) {
        if (diskData.containsKey('devices')) {
          final devices = diskData['devices'] as List?;
          if (devices != null && devices.isNotEmpty) {
            // Find root filesystem (usually mounted on /)
            for (var device in devices) {
              if (device is Map<String, dynamic>) {
                final mountpoint = device['mountpoint'] as String?;
                if (mountpoint == '/') {
                  final usedStr = device['used'] as String?;
                  final totalStr = device['blocks'] as String?;
                  
                  
                  // Parse strings like "8.0G" or "40G" to bytes
                  if (usedStr != null) {
                    diskUsed = _parseStorageString(usedStr);
                  }
                  if (totalStr != null) {
                    diskTotal = _parseStorageString(totalStr);
                  }
                  
                  break;
                }
              }
            }
          }
        }
      }
      

      return SystemInfo(
        hostname: hostname,
        version: version,
        platform: platform,
        uptime: uptime,
        cpuUsage: cpuUsage,
        memoryUsed: memoryUsed,
        diskUsed: diskUsed,
        diskTotal: diskTotal,
        memoryTotal: memoryTotal,
        type: type,
        architecture: architecture,
        commit: commit,
        mirror: mirror,
        repositories: repositories,
        updatedOn: updatedOn,
      );
    } catch (_) {
      // Silently handle error
      rethrow;
    }
  }

  // ==================== Firewall Rules ====================

  /// Get all firewall rules (only from /firewall/filter/get endpoint for automation rules)
  Future<List<FirewallRule>> getFirewallRules() async {
    _ensureInitialized();

    try {
      final List<FirewallRule> allRules = [];
      
      // Fetch automation rules using /firewall/filter/get endpoint only
      final automationResponse = await _dio!.get('/firewall/filter/get');
      
      if (automationResponse.statusCode == 200) {
        final data = automationResponse.data as Map<String, dynamic>;
        
        // The /get endpoint returns: filter.rules.rule
        if (data.containsKey('filter')) {
          final filterData = data['filter'] as Map<String, dynamic>?;
          if (filterData != null && filterData.containsKey('rules')) {
            final rulesContainer = filterData['rules'] as Map<String, dynamic>?;
            if (rulesContainer != null && rulesContainer.containsKey('rule')) {
              final rules = rulesContainer['rule'];
              
              if (rules is List) {
                for (var rule in rules) {
                  if (rule is Map<String, dynamic>) {
                    try {
                      allRules.add(_parseFirewallRule(rule));
                    } catch (_) {
                      // Silently handle error
                    }
                  }
                }
              } else if (rules is Map) {
                // Rules are a map with UUIDs as keys
                for (var entry in rules.entries) {
                  if (entry.value is Map<String, dynamic>) {
                    try {
                      final ruleData = Map<String, dynamic>.from(entry.value as Map);
                      ruleData['uuid'] = entry.key; // Add UUID from key
                      allRules.add(_parseFirewallRule(ruleData));
                    } catch (_) {
                      // Silently handle error
                    }
                  }
                }
              }
            }
          }
        }
      }
      
      return allRules;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Get available interfaces from OPNsense
  Future<Map<String, String>> getAvailableInterfaces() async {
    _ensureInitialized();

    try {
      final response = await _dio!.get('/firewall/filter/get');
      
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        
        // Navigate to filter.rules.rule to get a sample rule with interface data
        if (data.containsKey('filter')) {
          final filterData = data['filter'] as Map<String, dynamic>?;
          if (filterData != null && filterData.containsKey('rules')) {
            final rulesContainer = filterData['rules'] as Map<String, dynamic>?;
            if (rulesContainer != null && rulesContainer.containsKey('rule')) {
              final rules = rulesContainer['rule'];
              
              // Get interface options from the first rule's interface field
              if (rules is Map && rules.isNotEmpty) {
                final firstRule = rules.values.first;
                if (firstRule is Map<String, dynamic> && firstRule.containsKey('interface')) {
                  final interfaceField = firstRule['interface'];
                  if (interfaceField is Map<String, dynamic>) {
                    // Extract all interface options
                    final Map<String, String> interfaces = {};
                    for (var entry in interfaceField.entries) {
                      final value = entry.value;
                      if (value is Map<String, dynamic> && value.containsKey('value')) {
                        // key is the internal name (e.g., 'lan'), value['value'] is display name (e.g., 'LAN')
                        interfaces[entry.key] = value['value'].toString();
                      }
                    }
                    return interfaces;
                  }
                }
              }
            }
          }
        }
      }
      
      // Fallback to default interfaces if API doesn't provide them
      return {
        'lan': 'LAN',
        'wan': 'WAN',
        'opt1': 'OPT1',
        'opt2': 'OPT2',
      };
    } on DioException {
      // Return default interfaces on error
      return {
        'lan': 'LAN',
        'wan': 'WAN',
        'opt1': 'OPT1',
        'opt2': 'OPT2',
      };
    }
  }

  /// Create a new firewall rule
  Future<String> createFirewallRule(FirewallRuleRequest request) async {
    _ensureInitialized();

    try {
      final requestJson = request.toJson();
      
      final payload = {'rule': requestJson};
      
      // According to OPNsense API docs, we need to wrap the rule in a 'rule' object
      final response = await _dio!.post(
        '/firewall/filter/addRule',
        data: payload,
      );
      
      
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        
        // Check if the operation succeeded
        final result = data['result'] as String?;
        if (result == 'failed') {
          final validations = data['validations'] as Map<String, dynamic>?;
          final errorMessage = validations?.values.join(', ') ?? 'Unknown validation error';
          throw ApiException('Failed to create rule: $errorMessage', 400);
        }
        
        final uuid = data['uuid'] as String?;
        if (uuid == null || uuid.isEmpty) {
          throw ApiException('No UUID returned from addRule', 500);
        }
        
        
        // Verify the rule was created by fetching it
        final createdRule = await getFirewallRule(uuid);
        if (createdRule != null) {
        } else {
        }
        
        // Apply changes - this is required to make the rule active
        await applyFirewallChanges();
        
        return uuid;
      } else {
        throw ApiException('Failed to create firewall rule', response.statusCode);
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Extract selected value from OPNsense dropdown structure
  String _extractSelectedValue(dynamic field, {bool returnDisplayValue = false}) {
    if (field is String) {
      return field;
    }
    if (field is List) {
      // If it's a list, return the first element as string
      return field.isNotEmpty ? field.first.toString() : '';
    }
    if (field is Map<String, dynamic>) {
      // Find the selected option
      for (var entry in field.entries) {
        final value = entry.value;
        if (value is Map<String, dynamic> && value['selected'] == 1) {
          // Return the display value if requested and available, otherwise return the key
          if (returnDisplayValue && value.containsKey('value')) {
            return value['value'].toString();
          }
          return entry.key;
        }
      }
    }
    return '';
  }

  /// Parse a firewall rule from API response
  FirewallRule _parseFirewallRule(Map<String, dynamic> ruleData) {
    // Different endpoints return different structures:
    // - searchRule: simple strings (action, interface, protocol, source_net, destination_net, description)
    // - filter/get: nested dropdown objects with 'selected' flags
    
    // Get action/type - could be string or nested object
    String type;
    if (ruleData['action'] is String) {
      type = ruleData['action'] as String;
    } else {
      type = _extractSelectedValue(ruleData['action']);
    }
    if (type.isEmpty) type = 'pass';
    
    // Get interface - could be string or nested object
    // Use returnDisplayValue=true to get the friendly name (e.g., "LAN" instead of "lan")
    String interfaceName;
    if (ruleData['interface'] is String) {
      interfaceName = ruleData['interface'] as String;
    } else {
      interfaceName = _extractSelectedValue(ruleData['interface'], returnDisplayValue: true);
    }
    
    // Get protocol - could be string or nested object
    String protocol;
    if (ruleData['protocol'] is String) {
      protocol = ruleData['protocol'] as String;
    } else {
      protocol = _extractSelectedValue(ruleData['protocol']);
    }
    if (protocol.isEmpty) protocol = 'any';
    
    // Get source - always a string field
    String source = ruleData['source_net']?.toString() ?? 'any';
    if (source.isEmpty) source = 'any';
    
    // Get destination - always a string field
    String destination = ruleData['destination_net']?.toString() ?? 'any';
    if (destination.isEmpty) destination = 'any';
    
    // Get description - could be 'description' or 'descr'
    String description = ruleData['description']?.toString() ??
                        ruleData['descr']?.toString() ?? '';
    
    // Get source port - always a string field
    String sourcePort = ruleData['source_port']?.toString() ?? '';
    if (sourcePort.isEmpty) sourcePort = 'any';
    
    // Get destination port - always a string field
    String destPort = ruleData['destination_port']?.toString() ?? '';
    if (destPort.isEmpty) destPort = 'any';
    
    // Get origin field to identify system-generated rules
    // System-generated rules typically have origin field set (e.g., 'filter', 'nat', etc.)
    String origin = ruleData['origin']?.toString() ?? '';
    
    return FirewallRule(
      uuid: ruleData['uuid']?.toString() ?? '',
      type: type,
      interfaceName: interfaceName,
      protocol: protocol,
      source: source,
      destination: destination,
      sourcePort: sourcePort,
      destinationPort: destPort,
      description: description,
      enabled: ruleData['enabled']?.toString() ?? '1',
      sequence: int.tryParse(ruleData['sequence']?.toString() ?? '0') ?? 0,
      origin: origin,
    );
  }

  /// Get a specific firewall rule by UUID
  Future<FirewallRule?> getFirewallRule(String uuid) async {
    _ensureInitialized();

    try {
      final response = await _dio!.get('/firewall/filter/getRule/$uuid');
      
      
      if (response.statusCode == 200) {
        final data = response.data;
        
        // Handle both Map and other response types
        Map<String, dynamic>? ruleData;
        if (data is Map<String, dynamic>) {
          final ruleField = data['rule'];
          if (ruleField is Map<String, dynamic>) {
            ruleData = ruleField;
          }
        }
        
        if (ruleData != null) {
          // OPNsense returns complex nested structures for dropdowns
          // Extract the selected values
          final type = _extractSelectedValue(ruleData['action']);
          final interfaceName = _extractSelectedValue(ruleData['interface']);
          final protocol = _extractSelectedValue(ruleData['protocol']);
          
          // Try both 'source_net' and 'source' field names
          final source = ruleData['source_net']?.toString() ??
                        ruleData['source']?.toString() ??
                        'any';
          final destination = ruleData['destination_net']?.toString() ??
                             ruleData['destination']?.toString() ??
                             'any';
          final description = ruleData['descr']?.toString() ?? '';
          
          final sourcePort = ruleData['source_port']?.toString() ?? 'any';
          final destPort = ruleData['destination_port']?.toString() ?? 'any';
          
          
          return FirewallRule(
            uuid: uuid,
            type: type.isNotEmpty ? type : 'pass',
            interfaceName: interfaceName,
            protocol: protocol.isNotEmpty ? protocol : 'any',
            source: source,
            destination: destination,
            sourcePort: sourcePort,
            destinationPort: destPort,
            description: description,
            enabled: ruleData['enabled']?.toString() ?? '1',
            sequence: int.tryParse(ruleData['sequence']?.toString() ?? '0') ?? 0,
          );
        }
      }
      return null;
    } on DioException {
      return null;
    }
  }

  /// Update an existing firewall rule
  Future<void> updateFirewallRule(String uuid, FirewallRuleRequest request) async {
    _ensureInitialized();

    try {
      final response = await _dio!.post(
        '/firewall/filter/setRule/$uuid',
        data: {'rule': request.toJson()},
      );
      
      if (response.statusCode == 200) {
        // Apply changes
        await applyFirewallChanges();
      } else {
        throw ApiException('Failed to update firewall rule', response.statusCode);
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Toggle firewall rule (enable/disable)
  Future<void> toggleFirewallRule(String uuid) async {
    _ensureInitialized();

    try {
      // Use the toggle endpoint
      final response = await _dio!.post('/firewall/filter/toggleRule/$uuid');
      
      if (response.statusCode == 200) {
        // Apply changes to make the toggle take effect
        await applyFirewallChanges();
      } else {
        throw ApiException('Failed to toggle firewall rule', response.statusCode);
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Delete a firewall rule
  Future<void> deleteFirewallRule(String uuid) async {
    _ensureInitialized();

    try {
      final response = await _dio!.post('/firewall/filter/delRule/$uuid');
      
      if (response.statusCode == 200) {
        // Apply changes
        await applyFirewallChanges();
      } else {
        throw ApiException('Failed to delete firewall rule', response.statusCode);
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Apply firewall changes
  Future<void> applyFirewallChanges() async {
    _ensureInitialized();

    try {
      await _dio!.post('/firewall/filter/apply');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Apply firewall alias changes
  /// This must be called after creating, updating, toggling, or deleting aliases
  /// to actually apply the changes to the running firewall configuration
  Future<void> applyFirewallAliasChanges() async {
    _ensureInitialized();

    try {
      await _dio!.post('/firewall/alias/reconfigure');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // ==================== System Control ====================

  /// Reboot the OPNsense system
  Future<void> rebootSystem() async {
    _ensureInitialized();

    try {
      
      final response = await _dio!.post('/core/system/reboot');
      
      if (response.statusCode == 200) {
      } else {
        throw ApiException('Failed to reboot system', response.statusCode);
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // ==================== Firewall Logs ====================

  /// Get firewall logs (live view)
  Future<List<dynamic>> getFirewallLogs({int limit = 100}) async {
    _ensureInitialized();

    try {
      
      // Use the same endpoint as the web UI live view
      // Endpoint: /api/diagnostics/firewall/log
      final response = await _dio!.get(
        '/diagnostics/firewall/log',
        queryParameters: {
          'limit': limit, // Number of entries to fetch
        },
      );
      
      
      if (response.statusCode == 200) {
        final data = response.data;
        
        // The response should be a map with 'rows' containing the log entries
        if (data is Map<String, dynamic>) {
          
          if (data.containsKey('rows')) {
            final rows = data['rows'] as List<dynamic>?;
            return rows ?? [];
          } else if (data.containsKey('data')) {
            final dataList = data['data'] as List<dynamic>?;
            return dataList ?? [];
          }
        } else if (data is List) {
          return data;
        }
        
        return [];
      } else {
        throw ApiException('Failed to get firewall logs', response.statusCode);
      }
    } on DioException catch (e) {
      if (e.response != null) {
      }
      throw _handleDioError(e);
    }
  }
  /// Get system services status
  /// Endpoint: /api/core/service/search
  Future<List<dynamic>> getServices() async {
    if (!isInitialized) {
      throw ApiException('API service not initialized', null);
    }

    try {
      
      final response = await _dio!.get('/core/service/search');
      
      
      if (response.statusCode == 200) {
        final data = response.data;
        
        if (data is Map<String, dynamic> && data.containsKey('rows')) {
          final services = data['rows'] as List<dynamic>?;
          return services ?? [];
        } else if (data is List) {
          return data;
        }
        
        return [];
      } else {
        throw ApiException('Failed to get services', response.statusCode);
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Get gateway status
  /// Endpoint: /api/routes/gateway/status
  Future<List<dynamic>> getGateways() async {
    if (!isInitialized) {
      throw ApiException('API service not initialized', null);
    }

    try {
      
      final response = await _dio!.get('/routes/gateway/status');
      
      
      if (response.statusCode == 200) {
        final data = response.data;
        
        if (data is Map<String, dynamic> && data.containsKey('items')) {
          final gateways = data['items'] as List<dynamic>?;
          return gateways ?? [];
        } else if (data is Map<String, dynamic> && data.containsKey('rows')) {
          final gateways = data['rows'] as List<dynamic>?;
          return gateways ?? [];
        } else if (data is List) {
          return data;
        }
        
        return [];
      } else {
        throw ApiException('Failed to get gateways', response.statusCode);
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }
  /// Control a service (start, stop, restart)
  /// Endpoint: /api/core/service/{action}/{serviceName}
  /// Actions: start, stop, restart
  Future<bool> controlService(String serviceName, String action) async {
    if (!isInitialized) {
      throw ApiException('API service not initialized', null);
    }

    try {
      
      final response = await _dio!.post('/core/service/$action/$serviceName');
      
      
      if (response.statusCode == 200) {
        final data = response.data;
        
        // Check if response indicates success
        if (data is Map<String, dynamic>) {
          final result = data['result'] ?? data['status'] ?? 'ok';
          return result.toString().toLowerCase() == 'ok' || 
                 result.toString().toLowerCase() == 'success';
        }
        return true;
      } else {
        throw ApiException('Failed to $action service', response.statusCode);
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }



  // ==================== Helper Methods ====================

  /// Ensure service is initialized
  void _ensureInitialized() {
    if (!isInitialized) {
      throw ApiException('API service not initialized', null);
    }
  }

  /// Handle Dio errors
  ApiException _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException('Connection timeout', null);
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 401) {
          return ApiException('Invalid credentials', statusCode);
        } else if (statusCode == 403) {
          return ApiException('Insufficient permissions', statusCode);
        } else if (statusCode == 404) {
          return ApiException('Resource not found', statusCode);
        } else {
          return ApiException('Server error', statusCode);
        }
      case DioExceptionType.cancel:
        return ApiException('Request cancelled', null);
      case DioExceptionType.connectionError:
        // Check for certificate validation errors
        if (e.message?.contains('CERTIFICATE_VERIFY_FAILED') == true ||
            e.message?.contains('certificate') == true ||
            e.error is HandshakeException) {
          return ApiException(
            'Certificate validation failed. The server is using a self-signed certificate. '
            'Please enable "Allow Self-Signed Certificates" in connection settings.',
            null,
          );
        }
        if (e.error is SocketException) {
          return ApiException('Network error: Unable to connect', null);
        }
        return ApiException('Connection error: ${e.message}', null);
      case DioExceptionType.unknown:
        // Check for certificate validation errors in unknown type as well
        if (e.message?.contains('CERTIFICATE_VERIFY_FAILED') == true ||
            e.message?.contains('certificate') == true ||
            e.error is HandshakeException) {
          return ApiException(
            'Certificate validation failed. The server is using a self-signed certificate. '
            'Please enable "Allow Self-Signed Certificates" in connection settings.',
            null,
          );
        }
        if (e.error is SocketException) {
          return ApiException('Network error: Unable to connect', null);
        }
        return ApiException('Unknown error: ${e.message}', null);
      default:
        return ApiException('Request failed: ${e.message}', null);
    }
  }

  /// Get all VPN connections (OpenVPN, WireGuard, IPsec, and Tailscale)
  Future<List<VPNConnection>> getVPNConnections() async {
    _ensureInitialized();

    try {
      final connections = <VPNConnection>[];
      final errors = <String, String>{};

      // Get VPN services from the service list (using correct endpoint without /api prefix)
      try {
        final servicesResponse = await _dio!.get('/core/service/search');
        
        if (servicesResponse.statusCode == 200 && servicesResponse.data != null) {
          final data = servicesResponse.data as Map<String, dynamic>;
          final rows = data['rows'] as List<dynamic>? ?? [];
          
          for (final row in rows) {
            final rowData = row as Map<String, dynamic>;
            final serviceName = rowData['name']?.toString().toLowerCase() ?? '';
            final serviceId = rowData['id']?.toString() ?? '';
            final isRunning = rowData['running']?.toString() == '1' || rowData['running'] == true;
            
            // Check if this is Tailscale VPN service
            if (serviceName == 'tailscale') {
              connections.add(VPNConnection(
                id: serviceId,
                name: 'Tailscale',
                type: serviceName,
                status: isRunning ? 'up' : 'down',
                description: rowData['description']?.toString() ?? 'Tailscale VPN Service',
                enabled: isRunning,
              ));
            }
          }
        }
      } catch (e) {
        errors['Services'] = e.toString();
      }

      // Get OpenVPN sessions (active connections)
      try {
        final openVpnConnections = await _getOpenVPNSessions();
        connections.addAll(openVpnConnections);
      } catch (e) {
        errors['OpenVPN'] = e.toString();
      }

      // Get WireGuard connections
      try {
        final wireguardConnections = await _getWireGuardConnections();
        connections.addAll(wireguardConnections);
      } catch (e) {
        errors['WireGuard'] = e.toString();
      }

      // Get IPsec connections
      try {
        final ipsecConnections = await _getIPsecConnections();
        connections.addAll(ipsecConnections);
      } catch (e) {
        errors['IPsec'] = e.toString();
      }

      return connections;
    } catch (e) {
      throw ApiException('Failed to get VPN connections: ${e.toString()}', null);
    }
  }

  /// Get Tailscale connection status
  Future<VPNConnection?> getTailscaleStatus() async {
    _ensureInitialized();

    try {
      // Get VPN services from the service list
      final servicesResponse = await _dio!.get('/core/service/search');
      
      if (servicesResponse.statusCode == 200 && servicesResponse.data != null) {
        final data = servicesResponse.data as Map<String, dynamic>;
        final rows = data['rows'] as List<dynamic>? ?? [];
        
        for (final row in rows) {
          final rowData = row as Map<String, dynamic>;
          final serviceName = rowData['name']?.toString().toLowerCase() ?? '';
          final serviceId = rowData['id']?.toString() ?? '';
          final isRunning = rowData['running']?.toString() == '1' || rowData['running'] == true;
          
          // Check if this is Tailscale VPN service
          if (serviceName == 'tailscale') {
            return VPNConnection(
              id: serviceId,
              name: 'Tailscale',
              type: serviceName,
              status: isRunning ? 'up' : 'down',
              description: rowData['description']?.toString() ?? 'Tailscale VPN Service',
              enabled: isRunning,
            );
          }
        }
      }
      
      // Return null if Tailscale service not found
      return null;
    } catch (e) {
      // Return null on error - drawer will show "Unknown" status
      return null;
    }
  }

  /// Get detailed Tailscale status and configuration
  Future<TailscaleStatus> getTailscaleDetails() async {
    _ensureInitialized();

    try {
      // Get service status
      final serviceStatusResponse = await _dio!.post('/tailscale/service/status');
      
      bool serviceRunning = false;
      if (serviceStatusResponse.statusCode == 200 && serviceStatusResponse.data != null) {
        final serviceData = serviceStatusResponse.data as Map<String, dynamic>;
        final status = serviceData['status']?.toString().toLowerCase() ?? '';
        serviceRunning = status == 'running';
      }

      // Get comprehensive Tailscale status
      final statusResponse = await _dio!.get('/tailscale/status/status');
      final statusData = statusResponse.data as Map<String, dynamic>? ?? {};

      // Get Tailscale settings
      final settingsResponse = await _dio!.get('/tailscale/settings/get');
      final settingsData = settingsResponse.data as Map<String, dynamic>? ?? {};
      // Fix: API returns 'settings' not 'tailscale'
      final settings = settingsData['settings'] as Map<String, dynamic>? ?? {};

      // Get authentication configuration
      final authResponse = await _dio!.get('/tailscale/authentication/get');
      final authData = authResponse.data as Map<String, dynamic>? ?? {};
      final authentication = authData['authentication'] as Map<String, dynamic>? ?? {};
      final loginServer = authentication['loginServer']?.toString();
      final preAuthKey = authentication['preAuthKey']?.toString();

      // Extract data from status response
      final backendState = statusData['BackendState']?.toString() ?? 'Stopped';
      final authUrl = statusData['AuthURL']?.toString();
      final version = statusData['Version']?.toString();
      
      // Extract Self data
      final selfData = statusData['Self'] as Map<String, dynamic>? ?? {};
      final hostName = selfData['HostName']?.toString();
      final dnsName = selfData['DNSName']?.toString();
      final tailscaleIPs = selfData['TailscaleIPs'] as List<dynamic>? ?? [];
      final ips = tailscaleIPs.map((ip) => ip.toString()).toList();
      final rxBytes = selfData['RxBytes'] as int?;
      final txBytes = selfData['TxBytes'] as int?;
      
      // Extract CurrentTailnet data
      final currentTailnet = statusData['CurrentTailnet'] as Map<String, dynamic>? ?? {};
      final tailnetName = currentTailnet['Name']?.toString();
      final magicDnsEnabled = currentTailnet['MagicDNSEnabled'] == true;
      
      // Extract User data
      final userMap = statusData['User'] as Map<String, dynamic>? ?? {};
      String? userName;
      if (userMap.isNotEmpty) {
        // User map has userID as key, get first user
        final firstUserData = userMap.values.first as Map<String, dynamic>? ?? {};
        userName = firstUserData['LoginName']?.toString();
      }
      
      // Extract Peer data for count
      final peerMap = statusData['Peer'] as Map<String, dynamic>? ?? {};
      final peersCount = peerMap.length;
      
      // Extract Health data
      final healthList = statusData['Health'] as List<dynamic>? ?? [];
      String? healthStatus;
      if (healthList.isNotEmpty) {
        healthStatus = healthList.join(', ');
      }
      
      // Extract settings - Fix: Convert "1"/"0" strings to booleans
      final acceptSubnetRoutes = settings['acceptSubnetRoutes']?.toString() == '1';
      final acceptDNS = settings['acceptDNS']?.toString() == '1';
      final enableSSH = settings['enableSSH']?.toString() == '1';
      
      // Fix: Parse exit node correctly
      final useExitNodeData = settings['useExitNode'] as Map<String, dynamic>?;
      String? exitNodeValue;
      bool useExitNode = false;
      if (useExitNodeData != null) {
        // Find the selected exit node
        for (final entry in useExitNodeData.entries) {
          if (entry.value is Map && entry.value['selected'] == 1) {
            exitNodeValue = entry.key.isEmpty ? null : entry.key;
            useExitNode = exitNodeValue != null;
            break;
          }
        }
      }
      
      // Fix: Extract advertised subnets from nested structure
      final subnetsData = settings['subnets'] as Map<String, dynamic>?;
      String? advertiseRoutes;
      if (subnetsData != null) {
        final subnetList = <String>[];
        // Handle subnet4 structure
        final subnet4 = subnetsData['subnet4'] as Map<String, dynamic>?;
        if (subnet4 != null) {
          // Iterate through UUIDs
          for (final entry in subnet4.values) {
            if (entry is Map<String, dynamic>) {
              final subnet = entry['subnet']?.toString();
              if (subnet != null && subnet.isNotEmpty) {
                subnetList.add(subnet);
              }
            }
          }
        }
        if (subnetList.isNotEmpty) {
          advertiseRoutes = subnetList.join(', ');
        }
      }
      
      // Determine authentication status
      final authenticated = authUrl == null || authUrl.isEmpty;
      final loginState = authenticated ? 'authenticated' : 'unauthenticated';
      
      return TailscaleStatus(
        // Authentication fields
        authenticated: authenticated,
        loginState: loginState,
        authUrl: authUrl,
        tailnet: tailnetName,
        user: userName,
        deviceName: hostName ?? dnsName,
        loginServer: loginServer,
        preAuthKey: preAuthKey,
        
        // Settings fields
        acceptRoutes: acceptSubnetRoutes,
        advertiseRoutes: advertiseRoutes,
        exitNode: exitNodeValue,
        useExitNode: useExitNode,
        dnsEnabled: acceptDNS,
        magicDns: magicDnsEnabled,
        sshEnabled: enableSSH,
        tags: const [], // Tags not available in current API
        hostname: _config?.host,
        
        // Status fields
        serviceRunning: serviceRunning,
        backendState: backendState,
        ips: ips,
        bytesReceived: rxBytes,
        bytesSent: txBytes,
        connectedSince: null, // Not available in current API
        health: healthStatus,
        peersCount: peersCount,
        version: version,
      );
    } catch (e) {
      throw ApiException('Failed to get Tailscale details: ${e.toString()}', null);
    }
  }

  /// Get OpenVPN instances and sessions
  Future<List<VPNConnection>> _getOpenVPNSessions() async {
    try {
      final connections = <VPNConnection>[];
      
      // Get OpenVPN instances (servers and clients)
      try {
        final response = await _dio!.get('/openvpn/service/searchSessions');
        
        if (response.statusCode == 200 && response.data != null) {
          final data = response.data as Map<String, dynamic>;
          final rows = data['rows'] as List<dynamic>? ?? [];
          
          for (final row in rows) {
            final rowData = row as Map<String, dynamic>;
            final instanceType = rowData['type']?.toString() ?? '';
            final status = rowData['status']?.toString() ?? '';
            
            // This endpoint returns both server instances and client sessions
            if (instanceType == 'server' || instanceType == 'client') {
              // This is an OpenVPN server or client instance
              connections.add(VPNConnection(
                id: rowData['id']?.toString() ?? '',
                name: rowData['description']?.toString() ?? 'OpenVPN ${instanceType[0].toUpperCase()}${instanceType.substring(1)}',
                type: 'openvpn',
                status: status == 'ok' ? 'up' : 'down',
                description: rowData['description']?.toString(),
                enabled: status == 'ok',
              ));
            } else {
              // This is a connected client session
              connections.add(VPNConnection(
                id: rowData['id']?.toString() ?? '',
                name: rowData['common_name']?.toString() ?? 'OpenVPN Client',
                type: 'openvpn',
                status: 'up',
                description: rowData['common_name']?.toString(),
                remoteAddress: rowData['real_address']?.toString(),
                virtualAddress: rowData['virtual_address']?.toString(),
                bytesReceived: int.tryParse(rowData['bytes_received']?.toString() ?? '0'),
                bytesSent: int.tryParse(rowData['bytes_sent']?.toString() ?? '0'),
                connectedSince: rowData['connected_since'] != null
                    ? DateTime.tryParse(rowData['connected_since'].toString())
                    : null,
                enabled: true,
              ));
            }
          }
        }
      } catch (e) {
        // Silent fail
      }
      
      return connections;
    } catch (e) {
      return [];
    }
  }
  /// Get WireGuard connections
  Future<List<VPNConnection>> _getWireGuardConnections() async {
    try {
      final connections = <VPNConnection>[];

      // Get WireGuard servers
      try {
        final servers = await getWireGuardServers();
        for (var server in servers) {
          connections.add(VPNConnection(
            id: server.uuid,
            name: server.name,
            type: 'wireguard',
            status: server.isEnabled ? 'up' : 'down',
            description: 'WireGuard VPN Server',
            localAddress: server.tunneladdress,
            port: server.portNumber,
            enabled: server.isEnabled,
          ));
        }
      } catch (e) {
        // Silently handle error
      }

      // Get WireGuard clients
      try {
        final clients = await getWireGuardClients();
        for (var client in clients) {
          connections.add(VPNConnection(
            id: client.uuid,
            name: client.name,
            type: 'wireguard',
            status: client.isEnabled ? 'up' : 'down',
            description: 'WireGuard VPN Client',
            virtualAddress: client.tunneladdress,
            enabled: client.isEnabled,
          ));
        }
      } catch (e) {
        // Silently handle error
      }

      return connections;
    } catch (e) {
      return [];
    }
  }

  /// Get IPsec connections
  Future<List<VPNConnection>> _getIPsecConnections() async {
    try {
      final connections = <VPNConnection>[];

      // Get IPsec connections
      try {
        final ipsecConns = await getIPsecConnections();
        for (var conn in ipsecConns) {
          final enabled = conn['enabled'] == '1';
          final description = conn['description']?.toString() ?? 'IPsec Connection';
          final uuid = conn['uuid']?.toString() ?? '';
          
          connections.add(VPNConnection(
            id: uuid,
            name: description,
            type: 'ipsec',
            status: enabled ? 'up' : 'down',
            description: description,
            localAddress: conn['local_addrs']?.toString(),
            remoteAddress: conn['remote_addrs']?.toString(),
            enabled: enabled,
          ));
        }
      } catch (e) {
        // Silently handle error
      }

      // Get IPsec sessions to update status
      try {
        final sessions = await getIPsecSessionsPhase1();
        for (var session in sessions) {
          final sessionName = session['name']?.toString() ?? '';
          final state = session['state']?.toString() ?? '';
          
          // Update connection status based on session state
          for (var conn in connections) {
            if (conn.name == sessionName && state == 'ESTABLISHED') {
              final index = connections.indexOf(conn);
              connections[index] = VPNConnection(
                id: conn.id,
                name: conn.name,
                type: conn.type,
                status: 'up',
                description: conn.description,
                localAddress: conn.localAddress,
                remoteAddress: conn.remoteAddress,
                enabled: conn.enabled,
                connectedSince: DateTime.now().subtract(
                  Duration(seconds: int.tryParse(session['established']?.toString() ?? '0') ?? 0)
                ),
              );
            }
          }
        }
      } catch (e) {
        // Silently handle error
      }

      return connections;
    } catch (e) {
      return [];
    }
  }



  /// Toggle VPN connection (connect/disconnect)
  Future<bool> toggleVPNConnection(String id, String type, bool currentStatus) async {
    _ensureInitialized();

    try {
      String action = currentStatus ? 'stop' : 'start';

      // Use the core service control endpoint for all services
      final response = await _dio!.post('/core/service/$action/$id');
      
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>?;
        return data?['result'] == 'ok' || data?['status'] == 'ok';
      }
      
      return false;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ApiException('Failed to toggle VPN connection: ${e.toString()}', null);
    }
  }

  /// Restart VPN service
  Future<bool> restartVPNService(String type) async {
    _ensureInitialized();

    try {
      String endpoint;

      switch (type.toLowerCase()) {
        case 'openvpn':
          endpoint = '/api/openvpn/service/restart';
          break;
        case 'tailscale':
          endpoint = '/tailscale/service/restart';
          break;
        default:
          throw ApiException('Unknown VPN type: $type', null);
      }

      final response = await _dio!.post(endpoint);
      
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>?;
        return data?['result'] == 'ok' || data?['status'] == 'ok';
      }
      
      return false;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ApiException('Failed to restart VPN service: ${e.toString()}', null);
    }
  }

  /// Get VPN connection details
  Future<VPNConnection?> getVPNConnectionDetails(String id, String type) async {
    _ensureInitialized();

    try {
      final connections = await getVPNConnections();
      return connections.firstWhere(
        (conn) => conn.id == id && conn.type.toLowerCase() == type.toLowerCase(),
        orElse: () => throw ApiException('VPN connection not found', 404),
      );
    } catch (e) {
      throw ApiException('Failed to get VPN connection details: ${e.toString()}', null);
    }
  }

  // ==================== WireGuard VPN ====================
  // Endpoints verified against OPNsense 24.x API
  // All write operations use POST method
  // Response format: {"result":"saved"} for success, {"result":"failed","validations":{...}} for errors

  // Server Management Methods

  /// Get all WireGuard servers
  /// Endpoint: GET /api/wireguard/server/search_server
  /// Returns: List of servers in {"rows": [...]} format
  Future<List<WireGuardServer>> getWireGuardServers() async {
    _ensureInitialized();

    try {
      final response = await _dio!.get('/api/wireguard/server/search_server');
      
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data.containsKey('rows') && data['rows'] is List) {
          final rows = data['rows'] as List;
          return rows.map((row) => WireGuardServer.fromJson(row as Map<String, dynamic>)).toList();
        }
        return [];
      } else {
        throw ApiException('Failed to get WireGuard servers', response.statusCode);
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Get a specific WireGuard server by UUID
  /// Endpoint: GET /api/wireguard/server/get_server/$uuid
  /// Returns: Server object in {"server": {...}} format
  Future<WireGuardServer> getWireGuardServer(String uuid) async {
    _ensureInitialized();

    try {
      final response = await _dio!.get('/api/wireguard/server/get_server/$uuid');
      
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data.containsKey('server')) {
          return WireGuardServer.fromJson(data['server'] as Map<String, dynamic>);
        }
        throw ApiException('Server data not found in response', response.statusCode);
      } else {
        throw ApiException('Failed to get WireGuard server', response.statusCode);
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Create a new WireGuard server
  /// Endpoint: POST /api/wireguard/server/add_server
  /// Requires: Full server object including privkey
  /// Returns: UUID of created server
  Future<String> createWireGuardServer(WireGuardServerRequest request) async {
    _ensureInitialized();

    try {
      final response = await _dio!.post(
        '/api/wireguard/server/add_server',
        data: {'server': request.toJson()},
      );
      
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data.containsKey('uuid')) {
          return data['uuid'] as String;
        }
        throw ApiException('UUID not found in response', response.statusCode);
      } else {
        throw ApiException('Failed to create WireGuard server', response.statusCode);
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Update an existing WireGuard server
  /// Endpoint: POST /api/wireguard/server/set_server/$uuid
  /// Note: Can also be used for creation, but add_server is more explicit
  Future<void> updateWireGuardServer(String uuid, WireGuardServerRequest request) async {
    _ensureInitialized();

    try {
      final response = await _dio!.post(
        '/api/wireguard/server/set_server/$uuid',
        data: {'server': request.toJson()},
      );
      
      if (response.statusCode != 200) {
        throw ApiException('Failed to update WireGuard server', response.statusCode);
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Delete a WireGuard server
  /// Endpoint: POST /api/wireguard/server/del_server/$uuid
  Future<void> deleteWireGuardServer(String uuid) async {
    _ensureInitialized();

    try {
      final response = await _dio!.post('/api/wireguard/server/del_server/$uuid');
      
      if (response.statusCode != 200) {
        throw ApiException('Failed to delete WireGuard server', response.statusCode);
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Toggle WireGuard server enabled/disabled state
  /// Endpoint: POST /api/wireguard/server/toggle_server/$uuid
  Future<void> toggleWireGuardServer(String uuid, bool enabled) async {
    _ensureInitialized();

    try {
      final response = await _dio!.post(
        '/api/wireguard/server/toggle_server/$uuid',
        data: {'enabled': enabled ? '1' : '0'},
      );
      
      if (response.statusCode != 200) {
        throw ApiException('Failed to toggle WireGuard server', response.statusCode);
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // Client Management Methods

  /// Get all WireGuard clients
  /// Endpoint: GET /api/wireguard/client/search_client
  /// Returns: List of clients in {"rows": [...]} format
  Future<List<WireGuardClient>> getWireGuardClients() async {
    _ensureInitialized();

    try {
      final response = await _dio!.get('/api/wireguard/client/search_client');
      
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data.containsKey('rows') && data['rows'] is List) {
          final rows = data['rows'] as List;
          return rows.map((row) => WireGuardClient.fromJson(row as Map<String, dynamic>)).toList();
        }
        return [];
      } else {
        throw ApiException('Failed to get WireGuard clients', response.statusCode);
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Get a specific WireGuard client by UUID
  /// Endpoint: GET /api/wireguard/client/get_client/$uuid
  /// Returns: Client object in {"client": {...}} format
  Future<WireGuardClient> getWireGuardClient(String uuid) async {
    _ensureInitialized();

    try {
      final response = await _dio!.get('/api/wireguard/client/get_client/$uuid');
      
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data.containsKey('client')) {
          return WireGuardClient.fromJson(data['client'] as Map<String, dynamic>);
        }
        throw ApiException('Client data not found in response', response.statusCode);
      } else {
        throw ApiException('Failed to get WireGuard client', response.statusCode);
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Create a new WireGuard client
  /// Endpoint: POST /api/wireguard/client/add_client
  /// Requires: Full client object including pubkey
  /// Returns: UUID of created client
  Future<String> createWireGuardClient(WireGuardClientRequest request) async {
    _ensureInitialized();

    try {
      final response = await _dio!.post(
        '/api/wireguard/client/add_client',
        data: {'client': request.toJson()},
      );
      
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data.containsKey('uuid')) {
          return data['uuid'] as String;
        }
        throw ApiException('UUID not found in response', response.statusCode);
      } else {
        throw ApiException('Failed to create WireGuard client', response.statusCode);
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Update an existing WireGuard client
  /// Endpoint: POST /api/wireguard/client/set_client/$uuid
  /// Note: Can also be used for creation, but add_client is more explicit
  Future<void> updateWireGuardClient(String uuid, WireGuardClientRequest request) async {
    _ensureInitialized();

    try {
      final response = await _dio!.post(
        '/api/wireguard/client/set_client/$uuid',
        data: {'client': request.toJson()},
      );
      
      if (response.statusCode != 200) {
        throw ApiException('Failed to update WireGuard client', response.statusCode);
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Delete a WireGuard client
  /// Endpoint: POST /api/wireguard/client/del_client/$uuid
  Future<void> deleteWireGuardClient(String uuid) async {
    _ensureInitialized();

    try {
      final response = await _dio!.post('/api/wireguard/client/del_client/$uuid');
      
      if (response.statusCode != 200) {
        throw ApiException('Failed to delete WireGuard client', response.statusCode);
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Toggle WireGuard client enabled/disabled state
  /// Endpoint: POST /api/wireguard/client/toggle_client/$uuid
  Future<void> toggleWireGuardClient(String uuid, bool enabled) async {
    _ensureInitialized();

    try {
      final response = await _dio!.post(
        '/api/wireguard/client/toggle_client/$uuid',
        data: {'enabled': enabled ? '1' : '0'},
      );
      
      if (response.statusCode != 200) {
        throw ApiException('Failed to toggle WireGuard client', response.statusCode);
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // Peer Management Methods

  /// Get all WireGuard peers
  /// Endpoint: GET /api/wireguard/server/search_peer
  /// Returns: List of peers in {"rows": [...]} format
  Future<List<WireGuardPeer>> getWireGuardPeers() async {
    _ensureInitialized();

    try {
      final response = await _dio!.get('/api/wireguard/server/search_peer');
      
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data.containsKey('rows') && data['rows'] is List) {
          final rows = data['rows'] as List;
          return rows.map((row) => WireGuardPeer.fromJson(row as Map<String, dynamic>)).toList();
        }
        return [];
      } else {
        throw ApiException('Failed to get WireGuard peers', response.statusCode);
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Get a specific WireGuard peer by UUID
  /// Endpoint: GET /api/wireguard/server/get_peer/$uuid
  /// Returns: Peer object in {"peer": {...}} format
  Future<WireGuardPeer> getWireGuardPeer(String uuid) async {
    _ensureInitialized();

    try {
      final response = await _dio!.get('/api/wireguard/server/get_peer/$uuid');
      
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data.containsKey('peer')) {
          return WireGuardPeer.fromJson(data['peer'] as Map<String, dynamic>);
        }
        throw ApiException('Peer data not found in response', response.statusCode);
      } else {
        throw ApiException('Failed to get WireGuard peer', response.statusCode);
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Create a new WireGuard peer
  /// Endpoint: POST /api/wireguard/server/add_peer
  /// Returns: UUID of created peer
  Future<String> createWireGuardPeer(WireGuardPeerRequest request) async {
    _ensureInitialized();

    try {
      final response = await _dio!.post(
        '/api/wireguard/server/add_peer',
        data: {'peer': request.toJson()},
      );
      
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data.containsKey('uuid')) {
          return data['uuid'] as String;
        }
        throw ApiException('UUID not found in response', response.statusCode);
      } else {
        throw ApiException('Failed to create WireGuard peer', response.statusCode);
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Update an existing WireGuard peer
  /// Endpoint: POST /api/wireguard/server/set_peer/$uuid
  /// Note: Can also be used for creation, but add_peer is more explicit
  Future<void> updateWireGuardPeer(String uuid, WireGuardPeerRequest request) async {
    _ensureInitialized();

    try {
      final response = await _dio!.post(
        '/api/wireguard/server/set_peer/$uuid',
        data: {'peer': request.toJson()},
      );
      
      if (response.statusCode != 200) {
        throw ApiException('Failed to update WireGuard peer', response.statusCode);
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Delete a WireGuard peer
  /// Endpoint: POST /api/wireguard/server/del_peer/$uuid
  Future<void> deleteWireGuardPeer(String uuid) async {
    _ensureInitialized();

    try {
      final response = await _dio!.post('/api/wireguard/server/del_peer/$uuid');
      
      if (response.statusCode != 200) {
        throw ApiException('Failed to delete WireGuard peer', response.statusCode);
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Toggle WireGuard peer enabled/disabled state
  /// Endpoint: POST /api/wireguard/server/toggle_peer/$uuid
  Future<void> toggleWireGuardPeer(String uuid, bool enabled) async {
    _ensureInitialized();

    try {
      final response = await _dio!.post(
        '/api/wireguard/server/toggle_peer/$uuid',
        data: {'enabled': enabled ? '1' : '0'},
      );
      
      if (response.statusCode != 200) {
        throw ApiException('Failed to toggle WireGuard peer', response.statusCode);
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // Key Generation and Service Control Methods

  /// Generate a new WireGuard key pair
  /// Endpoint: GET /api/wireguard/service/genkey
  Future<WireGuardKeyPair> generateWireGuardKeyPair() async {
    _ensureInitialized();

    try {
      final response = await _dio!.get('/api/wireguard/service/genkey');
      
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return WireGuardKeyPair.fromJson(data);
      } else {
        throw ApiException('Failed to generate WireGuard key pair', response.statusCode);
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Apply WireGuard configuration changes
  /// Endpoint: POST /api/wireguard/service/reconfigure
  Future<void> applyWireGuardConfiguration() async {
    _ensureInitialized();

    try {
      final response = await _dio!.post('/api/wireguard/service/reconfigure');
      
      if (response.statusCode != 200) {
        throw ApiException('Failed to apply WireGuard configuration', response.statusCode);
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Get WireGuard service status
  /// Endpoint: GET /api/wireguard/service/show
  Future<Map<String, dynamic>> getWireGuardStatus() async {
    _ensureInitialized();

    try {
      final response = await _dio!.get('/api/wireguard/service/show');
      
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw ApiException('Failed to get WireGuard status', response.statusCode);
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Restart WireGuard service
  /// Endpoint: POST /api/wireguard/service/restart
  Future<void> restartWireGuardService() async {
    _ensureInitialized();

    try {
      final response = await _dio!.post('/api/wireguard/service/restart');
      
      if (response.statusCode != 200) {
        throw ApiException('Failed to restart WireGuard service', response.statusCode);
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Start a specific WireGuard instance
  /// Endpoint: POST /api/wireguard/service/start/$uuid
  Future<void> startWireGuardInstance(String uuid) async {
    _ensureInitialized();

    try {
      final response = await _dio!.post('/api/wireguard/service/start/$uuid');
      
      if (response.statusCode != 200) {
        throw ApiException('Failed to start WireGuard instance', response.statusCode);
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Stop a specific WireGuard instance
  /// Endpoint: POST /api/wireguard/service/stop/$uuid
  Future<void> stopWireGuardInstance(String uuid) async {
    _ensureInitialized();

    try {
      final response = await _dio!.post('/api/wireguard/service/stop/$uuid');
      
      if (response.statusCode != 200) {
        throw ApiException('Failed to stop WireGuard instance', response.statusCode);
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Restart a specific WireGuard instance
  /// Endpoint: POST /api/wireguard/service/restart/$uuid
  Future<void> restartWireGuardInstance(String uuid) async {
    _ensureInitialized();

    try {
      final response = await _dio!.post('/api/wireguard/service/restart/$uuid');
      
      if (response.statusCode != 200) {
        throw ApiException('Failed to restart WireGuard instance', response.statusCode);
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // ==================== IPsec VPN ====================

  /// Get all IPsec connections
  Future<List<Map<String, dynamic>>> getIPsecConnections() async {
    _ensureInitialized();

    try {
      final response = await _dio!.get('/ipsec/connections/search_connection');
      
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data.containsKey('rows') && data['rows'] is List) {
          return List<Map<String, dynamic>>.from(data['rows']);
        }
        return [];
      } else {
        throw ApiException('Failed to get IPsec connections', response.statusCode);
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Get IPsec sessions (Phase 1)
  Future<List<Map<String, dynamic>>> getIPsecSessionsPhase1() async {
    _ensureInitialized();

    try {
      final response = await _dio!.get('/ipsec/sessions/search_phase1');
      
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data.containsKey('rows') && data['rows'] is List) {
          return List<Map<String, dynamic>>.from(data['rows']);
        }
        return [];
      } else {
        throw ApiException('Failed to get IPsec Phase 1 sessions', response.statusCode);
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Get DHCP leases from configured DHCP server
  /// Returns a list of active DHCP leases with hostname, IP, and MAC info
  /// Supports dnsmasq, ISC DHCP, and KEA DHCP servers
  Future<List<Map<String, dynamic>>> getDhcpLeases() async {
    _ensureInitialized();
    
    // Get the configured DHCP server type
    final serverType = _config!.dhcpServerType;
    
    try {
      // Use the appropriate API endpoint for the server type
      final response = await _dio!.get(serverType.apiEndpoint);
      
      if (response.statusCode == 200) {
        final data = response.data;
        
        // Use the adapter to parse leases based on server type
        return DhcpLeaseAdapter.parseLeases(data, serverType);
      } else {
        throw ApiException(
          'Failed to get DHCP leases: HTTP ${response.statusCode}',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ApiException('Failed to get DHCP leases: ${e.toString()}', null);
    }
  }

  /// Get real-time traffic statistics for a specific interface
  /// Returns a list of hosts with their current bandwidth usage
  /// Note: This requires the diagnostics plugin to be installed and enabled
  Future<List<Map<String, dynamic>>> getTrafficTop(String interface) async {
    _ensureInitialized();
    
    try {
      final response = await _dio!.get('/diagnostics/traffic/top/$interface');
      
      if (response.statusCode == 200) {
        final data = response.data;
        
        // Handle OPNsense traffic API response format
        // Response structure: {"lan": {"records": [...], "status": "ok"}}
        if (data is Map<String, dynamic>) {
          // Check for interface-specific data (e.g., data['lan'])
          if (data.containsKey(interface)) {
            final interfaceData = data[interface];
            if (interfaceData is Map<String, dynamic>) {
              // Check for records array inside interface data
              if (interfaceData.containsKey('records') && interfaceData['records'] is List) {
                return List<Map<String, dynamic>>.from(interfaceData['records']);
              }
            }
          }
          
          // Fallback: Check for direct records array
          if (data.containsKey('records') && data['records'] is List) {
            return List<Map<String, dynamic>>.from(data['records']);
          }
          
          // Check for rows array
          if (data.containsKey('rows') && data['rows'] is List) {
            return List<Map<String, dynamic>>.from(data['rows']);
          }
        }
        
        // If response is directly a list
        if (data is List) {
          return List<Map<String, dynamic>>.from(data);
        }
        
        return [];
      } else {
        throw ApiException(
          'Failed to get traffic data: HTTP ${response.statusCode}',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ApiException('Failed to get traffic data: ${e.toString()}', null);
    }
  }

  /// Get network hosts by merging DHCP leases and traffic data
  /// Returns a list of NetworkHost objects with identity and bandwidth info
  /// Shows ALL leased hosts, even those with zero traffic
  Future<List<NetworkHost>> getNetworkHosts({String interface = 'lan'}) async {
    _ensureInitialized();
    
    try {
      // Fetch both datasets in parallel for better performance
      final results = await Future.wait([
        getDhcpLeases(),
        getTrafficTop(interface),
      ]);
      
      final leases = results[0];
      final trafficData = results[1];
      
      // Create a map of IP addresses to traffic data for quick lookup
      final trafficMap = <String, Map<String, dynamic>>{};
      for (final traffic in trafficData) {
        final address = traffic['address'] as String?;
        if (address != null && address.isNotEmpty) {
          trafficMap[address] = traffic;
        }
      }
      
      // Start with all leased hosts
      final hosts = <NetworkHost>[];
      final processedAddresses = <String>{};
      
      // Add all hosts from leases (with or without traffic)
      for (final lease in leases) {
        final address = lease['address'] as String?;
        if (address == null || address.isEmpty) continue;
        
        processedAddresses.add(address);
        
        // Check if we have traffic data for this IP
        final traffic = trafficMap[address];
        
        if (traffic != null) {
          // Merge lease and traffic data
          hosts.add(NetworkHost.fromLeaseAndTraffic(
            lease: lease,
            traffic: traffic,
          ));
        } else {
          // Only lease data available (no current traffic)
          hosts.add(NetworkHost.fromLeaseAndTraffic(
            lease: lease,
            traffic: {
              'address': address,
              'rate_bits_in': 0,
              'rate_bits_out': 0,
            },
          ));
        }
      }
      
      // Add any hosts from traffic that don't have lease data
      for (final traffic in trafficData) {
        final address = traffic['address'] as String?;
        if (address == null || address.isEmpty) continue;
        
        if (!processedAddresses.contains(address)) {
          hosts.add(NetworkHost.fromTrafficOnly(traffic));
        }
      }
      
      // Sort by total bandwidth usage (highest first), then by hostname
      hosts.sort((a, b) {
        final rateCompare = b.totalRate.compareTo(a.totalRate);
        if (rateCompare != 0) return rateCompare;
        return a.hostname.compareTo(b.hostname);
      });
      
      return hosts;
    } catch (e) {
      throw ApiException('Failed to get network hosts: ${e.toString()}', null);
    }
  }

  // ============================================================================
  // Firewall Alias Methods
  // ============================================================================

  /// Get all firewall aliases
  Future<List<FirewallAlias>> getFirewallAliases() async {
    _ensureInitialized();
    
    try {
      final response = await _dio!.get('/firewall/alias/get');
      
      if (response.statusCode == 200) {
        final data = response.data;
        
        // Response structure: {"alias": {"aliases": {"alias": {...}}}}
        // The "alias" map contains alias names as keys, each with nested properties
        if (data is Map &&
            data['alias'] != null &&
            data['alias']['aliases'] != null &&
            data['alias']['aliases']['alias'] != null) {
          
          final aliasesMap = data['alias']['aliases']['alias'] as Map<String, dynamic>;
          final List<FirewallAlias> aliases = [];
          
          // Iterate through each alias entry
          aliasesMap.forEach((aliasName, aliasData) {
            if (aliasData is Map<String, dynamic>) {
              // Extract the type - it's an object where one entry has "selected": 1
              String aliasType = '';
              if (aliasData['type'] is Map) {
                final typeMap = aliasData['type'] as Map<String, dynamic>;
                typeMap.forEach((key, value) {
                  if (value is Map && value['selected'] == 1) {
                    aliasType = key;
                  }
                });
              }
              
              // Extract content from current_items if available
              String content = '';
              if (aliasData['content'] != null) {
                content = aliasData['content'].toString();
              } else if (aliasData['current_items'] != null) {
                if (aliasData['current_items'] is List) {
                  content = (aliasData['current_items'] as List).join(',');
                } else {
                  content = aliasData['current_items'].toString();
                }
              }
              
              // Extract description
              String description = '';
              if (aliasData['description'] != null) {
                description = aliasData['description'].toString();
              }
              
              // Extract enabled status
              String enabled = '1';
              if (aliasData['enabled'] != null) {
                enabled = aliasData['enabled'].toString();
              }
              
              // Use the alias name as UUID since the response doesn't include UUIDs
              aliases.add(FirewallAlias(
                uuid: aliasName,
                name: aliasName,
                type: aliasType,
                content: content,
                description: description,
                enabled: enabled,
                counters: aliasData['counters']?.toString() ?? '0',
                proto: aliasData['proto']?.toString() ?? '',
                interface: aliasData['interface']?.toString() ?? '',
                categories: aliasData['categories']?.toString() ?? '',
              ));
            }
          });
          
          return aliases;
        }
        
        return [];
      } else {
        throw ApiException(
          'Failed to get firewall aliases: ${response.statusMessage}',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ApiException('Failed to get firewall aliases: ${e.toString()}', null);
    }
  }

  /// Get a specific firewall alias by UUID
  Future<FirewallAlias> getFirewallAlias(String uuid) async {
    _ensureInitialized();
    
    try {
      final response = await _dio!.get('/firewall/alias/getItem/$uuid');
      
      if (response.statusCode == 200) {
        final data = response.data;
        
        if (data is Map && data['alias'] != null) {
          final aliasData = data['alias'] as Map<String, dynamic>;
          return FirewallAlias(
            uuid: uuid,
            name: _extractSelectedValue(aliasData['name']) as String? ?? '',
            type: _extractSelectedValue(aliasData['type']) as String? ?? '',
            content: _extractSelectedValue(aliasData['content']) as String? ?? '',
            description: _extractSelectedValue(aliasData['description']) as String? ?? '',
            enabled: _extractSelectedValue(aliasData['enabled']) as String? ?? '1',
            counters: _extractSelectedValue(aliasData['counters']) as String? ?? '0',
            proto: _extractSelectedValue(aliasData['proto']) as String? ?? '',
            interface: _extractSelectedValue(aliasData['interface']) as String? ?? '',
            categories: _extractSelectedValue(aliasData['categories']) as String? ?? '',
          );
        }
        
        throw ApiException('Invalid alias data received', response.statusCode);
      } else {
        throw ApiException(
          'Failed to get firewall alias: ${response.statusMessage}',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ApiException('Failed to get firewall alias: ${e.toString()}', null);
    }
  }

  /// Get alias by name
  Future<String?> getAliasUuidByName(String name) async {
    _ensureInitialized();
    
    try {
      final response = await _dio!.get('/api/firewall/alias/get_alias_uuid/$name');
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map && data['uuid'] != null) {
          return data['uuid'] as String;
        }
        return null;
      }
      return null;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ApiException('Failed to get alias UUID: ${e.toString()}', null);
    }
  }

  /// Create a new firewall alias
  Future<Map<String, dynamic>> createFirewallAlias(FirewallAliasRequest request) async {
    _ensureInitialized();
    
    try {
      final response = await _dio!.post(
        '/firewall/alias/addItem',
        data: {'alias': request.toJson()},
      );
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map) {
          // Apply changes after creating
          if (data['result'] == 'saved') {
            await applyFirewallAliasChanges();
          }
          return data as Map<String, dynamic>;
        }
        throw ApiException('Invalid response format', response.statusCode);
      } else {
        throw ApiException(
          'Failed to create firewall alias: ${response.statusMessage}',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ApiException('Failed to create firewall alias: ${e.toString()}', null);
    }
  }

  /// Update an existing firewall alias
  Future<Map<String, dynamic>> updateFirewallAlias(
    String uuid,
    FirewallAliasRequest request,
  ) async {
    _ensureInitialized();
    
    try {
      final response = await _dio!.post(
        '/firewall/alias/setItem/$uuid',
        data: {'alias': request.toJson()},
      );
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map) {
          // Apply changes after updating
          if (data['result'] == 'saved') {
            await applyFirewallAliasChanges();
          }
          return data as Map<String, dynamic>;
        }
        throw ApiException('Invalid response format', response.statusCode);
      } else {
        throw ApiException(
          'Failed to update firewall alias: ${response.statusMessage}',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ApiException('Failed to update firewall alias: ${e.toString()}', null);
    }
  }

  /// Toggle firewall alias enabled/disabled state
  Future<void> toggleFirewallAlias(String uuid) async {
    _ensureInitialized();
    
    try {
      final response = await _dio!.post('/firewall/alias/toggleItem/$uuid');
      
      if (response.statusCode == 200) {
        await applyFirewallAliasChanges();
      } else {
        throw ApiException(
          'Failed to toggle firewall alias: ${response.statusMessage}',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Delete a firewall alias
  Future<void> deleteFirewallAlias(String uuid) async {
    _ensureInitialized();
    
    try {
      final response = await _dio!.post('/firewall/alias/delItem/$uuid');
      
      if (response.statusCode == 200) {
        await applyFirewallAliasChanges();
      } else {
        throw ApiException(
          'Failed to delete firewall alias: ${response.statusMessage}',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Get GeoIP information
  Future<Map<String, dynamic>> getGeoIP() async {
    _ensureInitialized();
    
    try {
      final response = await _dio!.get('/api/firewall/alias/get_geoip');
      
      if (response.statusCode == 200 && response.data is Map) {
        return response.data as Map<String, dynamic>;
      }
      throw ApiException('Failed to get GeoIP data', response.statusCode);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ApiException('Failed to get GeoIP data: ${e.toString()}', null);
    }
  }

  /// Get alias table size
  Future<Map<String, dynamic>> getAliasTableSize() async {
    _ensureInitialized();
    
    try {
      final response = await _dio!.get('/api/firewall/alias/get_table_size');
      
      if (response.statusCode == 200 && response.data is Map) {
        return response.data as Map<String, dynamic>;
      }
      throw ApiException('Failed to get table size', response.statusCode);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ApiException('Failed to get table size: ${e.toString()}', null);
    }
  }

  /// List available categories
  Future<List<AliasCategory>> listAliasCategories() async {
    _ensureInitialized();
    
    try {
      final response = await _dio!.get('/api/firewall/alias/listCategories');
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map && data['categories'] != null) {
          final categories = data['categories'] as Map<String, dynamic>;
          return categories.entries.map((entry) {
            return AliasCategory(
              name: entry.key,
              description: entry.value.toString(),
            );
          }).toList();
        }
        return [];
      }
      throw ApiException('Failed to list categories', response.statusCode);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ApiException('Failed to list categories: ${e.toString()}', null);
    }
  }

  /// List available countries for GeoIP
  Future<List<AliasCountry>> listAliasCountries() async {
    _ensureInitialized();
    
    try {
      final response = await _dio!.get('/api/firewall/alias/listCountries');
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map && data['countries'] != null) {
          final countries = data['countries'] as Map<String, dynamic>;
          return countries.entries.map((entry) {
            return AliasCountry(
              code: entry.key,
              name: entry.value.toString(),
            );
          }).toList();
        }
        return [];
      }
      throw ApiException('Failed to list countries', response.statusCode);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ApiException('Failed to list countries: ${e.toString()}', null);
    }
  }

  /// List network aliases
  Future<Map<String, dynamic>> listNetworkAliases() async {
    _ensureInitialized();
    
    try {
      final response = await _dio!.get('/api/firewall/alias/listNetworkAliases');
      
      if (response.statusCode == 200 && response.data is Map) {
        return response.data as Map<String, dynamic>;
      }
      throw ApiException('Failed to list network aliases', response.statusCode);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ApiException('Failed to list network aliases: ${e.toString()}', null);
    }
  }

  /// List user groups
  Future<Map<String, dynamic>> listUserGroups() async {
    _ensureInitialized();
    
    try {
      final response = await _dio!.get('/api/firewall/alias/listUserGroups');
      
      if (response.statusCode == 200 && response.data is Map) {
        return response.data as Map<String, dynamic>;
      }
      throw ApiException('Failed to list user groups', response.statusCode);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ApiException('Failed to list user groups: ${e.toString()}', null);
    }
  }

  // ============================================================================
  // Firewall Alias Utility Methods
  // ============================================================================

  /// Get all aliases (utility endpoint)
  Future<Map<String, dynamic>> getAliasesUtil() async {
    _ensureInitialized();
    
    try {
      final response = await _dio!.get('/api/firewall/alias_util/aliases');
      
      if (response.statusCode == 200 && response.data is Map) {
        return response.data as Map<String, dynamic>;
      }
      throw ApiException('Failed to get aliases', response.statusCode);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ApiException('Failed to get aliases: ${e.toString()}', null);
    }
  }

  /// List alias table entries
  Future<List<AliasTableEntry>> listAliasTable(String aliasName) async {
    _ensureInitialized();
    
    try {
      final response = await _dio!.get('/api/firewall/alias_util/list/$aliasName');
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map && data['rows'] != null) {
          final rows = data['rows'] as List;
          return rows.map((row) {
            return AliasTableEntry(
              ip: row['ip'] ?? '',
              hostname: row['hostname'] ?? '',
            );
          }).toList();
        }
        return [];
      }
      throw ApiException('Failed to list alias table', response.statusCode);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ApiException('Failed to list alias table: ${e.toString()}', null);
    }
  }

  /// Add item to alias table
  Future<Map<String, dynamic>> addToAliasTable(String aliasName, String address) async {
    _ensureInitialized();
    
    try {
      final response = await _dio!.post(
        '/api/firewall/alias_util/add/$aliasName',
        data: {'address': address},
      );
      
      if (response.statusCode == 200 && response.data is Map) {
        return response.data as Map<String, dynamic>;
      }
      throw ApiException('Failed to add to alias table', response.statusCode);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ApiException('Failed to add to alias table: ${e.toString()}', null);
    }
  }

  /// Delete item from alias table
  Future<Map<String, dynamic>> deleteFromAliasTable(String aliasName, String address) async {
    _ensureInitialized();
    
    try {
      final response = await _dio!.post(
        '/api/firewall/alias_util/delete/$aliasName',
        data: {'address': address},
      );
      
      if (response.statusCode == 200 && response.data is Map) {
        return response.data as Map<String, dynamic>;
      }
      throw ApiException('Failed to delete from alias table', response.statusCode);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ApiException('Failed to delete from alias table: ${e.toString()}', null);
    }
  }

  /// Flush alias table
  Future<Map<String, dynamic>> flushAliasTable(String aliasName) async {
    _ensureInitialized();
    
    try {
      final response = await _dio!.post('/api/firewall/alias_util/flush/$aliasName');
      
      if (response.statusCode == 200 && response.data is Map) {
        return response.data as Map<String, dynamic>;
      }
      throw ApiException('Failed to flush alias table', response.statusCode);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ApiException('Failed to flush alias table: ${e.toString()}', null);
    }
  }

  /// Find references to an alias
  Future<Map<String, dynamic>> findAliasReferences(String aliasName) async {
    _ensureInitialized();
    
    try {
      final response = await _dio!.post(
        '/api/firewall/alias_util/find_references',
        data: {'alias': aliasName},
      );
      
      if (response.statusCode == 200 && response.data is Map) {
        return response.data as Map<String, dynamic>;
      }
      throw ApiException('Failed to find alias references', response.statusCode);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ApiException('Failed to find alias references: ${e.toString()}', null);
    }
  }

  /// Update bogons
  Future<Map<String, dynamic>> updateBogons() async {
    _ensureInitialized();
    
    try {
      final response = await _dio!.get('/api/firewall/alias_util/update_bogons');
      
      if (response.statusCode == 200 && response.data is Map) {
        return response.data as Map<String, dynamic>;
      }
      throw ApiException('Failed to update bogons', response.statusCode);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ApiException('Failed to update bogons: ${e.toString()}', null);
    }
  }

  /// Control Tailscale service (start, stop, restart)
  Future<bool> controlTailscaleService(String action) async {
    _ensureInitialized();

    try {
      // Map action to Tailscale API service control endpoint
      final endpoint = action == 'start'
          ? '/tailscale/service/start'
          : action == 'stop'
              ? '/tailscale/service/stop'
              : '/tailscale/service/restart';

      final response = await _dio!.post(endpoint);

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>?;
        final result = data?['response']?.toString() ?? '';
        
        // Handle success
        if (result == 'OK') {
          return true;
        }
        
        // Handle error responses (e.g., "Error (1)" when service is already in desired state)
        if (result.contains('Error')) {
          // Service might already be in the desired state
          // Return false to indicate no change was made
          return false;
        }
        
        return false;
      }
      return false;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Update Tailscale settings
  Future<bool> updateTailscaleSettings(Map<String, dynamic> settings) async {
    _ensureInitialized();

    try {
      // Map settings to OPNsense Tailscale API format
      final opnsenseSettings = <String, dynamic>{};
      
      // Map accept_routes to acceptSubnetRoutes
      if (settings.containsKey('accept_routes')) {
        opnsenseSettings['acceptSubnetRoutes'] = settings['accept_routes'] == true ? '1' : '0';
      }
      
      // Map exit_node to useExitNode
      if (settings.containsKey('exit_node')) {
        final exitNode = settings['exit_node'];
        if (exitNode != null && exitNode.toString().isNotEmpty) {
          opnsenseSettings['useExitNode'] = '1';
          opnsenseSettings['exitNode'] = exitNode.toString();
        } else {
          opnsenseSettings['useExitNode'] = '0';
          opnsenseSettings['exitNode'] = '';
        }
      }
      
      // Map dns_enabled to acceptDNS
      if (settings.containsKey('dns_enabled')) {
        opnsenseSettings['acceptDNS'] = settings['dns_enabled'] == true ? '1' : '0';
      }
      
      // Map ssh_enabled to enableSSH
      if (settings.containsKey('ssh_enabled')) {
        opnsenseSettings['enableSSH'] = settings['ssh_enabled'] == true ? '1' : '0';
      }
      
      // Note: advertise_routes (subnets) requires separate subnet management API calls
      // For now, we skip this field as it needs add_subnet/del_subnet/set_subnet endpoints
      
      final response = await _dio!.post(
        '/api/tailscale/settings/set',
        data: {'tailscale': opnsenseSettings},
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>?;
        return data?['result'] == 'saved';
      }
      return false;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Get Tailscale authentication URL
  /// Get Tailscale authentication settings
  /// Returns a map with 'loginServer' and 'preAuthKey' fields
  Future<Map<String, String?>> getTailscaleAuthentication() async {
    _ensureInitialized();

    try {
      final url = '/tailscale/authentication/get';
      final response = await _dio!.get(url);

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>?;
        final auth = data?['authentication'] as Map<String, dynamic>?;
        
        return {
          'loginServer': auth?['loginServer'] as String?,
          'preAuthKey': auth?['preAuthKey'] as String?,
        };
      }
      return {'loginServer': null, 'preAuthKey': null};
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Set Tailscale authentication settings
  /// Saves the login server and pre-authentication key
  Future<bool> setTailscaleAuthentication(String loginServer, String preAuthKey) async {
    _ensureInitialized();

    try {
      final url = '/tailscale/authentication/set';
      final response = await _dio!.post(
        url,
        data: {
          'authentication': {
            'loginServer': loginServer,
            'preAuthKey': preAuthKey,
          },
        },
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>?;
        return data?['result'] == 'saved';
      }
      return false;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Logout from Tailscale
  /// Note: This functionality is not supported by the OPNsense Tailscale API.
  /// The API does not provide a logout endpoint. To logout, you would need to
  /// stop the service and manually remove authentication on the Tailscale admin console.
  Future<bool> logoutTailscale() async {
    _ensureInitialized();

    try {
      // The OPNsense Tailscale API does not provide a logout endpoint
      // As a workaround, we could stop the service, but that's not a true logout
      // Return false to indicate this operation is not supported
      return false;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // ==================== Tailscale Settings Management ====================

  /// Get Tailscale settings
  /// Retrieves the current Tailscale configuration settings
  Future<TailscaleSettingsResponse> getTailscaleSettings() async {
    _ensureInitialized();

    try {
      final response = await _dio!.get('/tailscale/settings/get');

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return TailscaleSettingsResponse.fromJson(data);
      }
      throw ApiException('Failed to get Tailscale settings', response.statusCode);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Set Tailscale settings
  /// Updates the Tailscale configuration with the provided settings
  Future<Map<String, dynamic>> setTailscaleSettings(TailscaleSettings settings) async {
    _ensureInitialized();

    try {
      final response = await _dio!.post(
        '/tailscale/settings/set',
        data: {'settings': settings.toJson()},
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
      throw ApiException('Failed to set Tailscale settings', response.statusCode);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Search Tailscale subnets
  /// Returns a paginated list of configured subnets
  Future<TailscaleSubnetSearchResponse> searchTailscaleSubnets() async {
    _ensureInitialized();

    try {
      final response = await _dio!.get('/tailscale/settings/search_subnet');

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return TailscaleSubnetSearchResponse.fromJson(data);
      }
      throw ApiException('Failed to search Tailscale subnets', response.statusCode);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Get a specific Tailscale subnet by UUID
  /// Returns the subnet configuration for the given UUID
  Future<TailscaleSubnetResponse> getTailscaleSubnet(String uuid) async {
    _ensureInitialized();

    try {
      final response = await _dio!.get('/tailscale/settings/get_subnet/$uuid');

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return TailscaleSubnetResponse.fromJson(data);
      }
      throw ApiException('Failed to get Tailscale subnet', response.statusCode);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Add a new Tailscale subnet
  /// Creates a new subnet configuration
  Future<Map<String, dynamic>> addTailscaleSubnet(TailscaleSubnet subnet) async {
    _ensureInitialized();

    try {
      // Convert subnet to JSON and remove uuid field (not needed for add operation)
      final subnetData = subnet.toJson();
      subnetData.remove('uuid');
      
      final response = await _dio!.post(
        '/tailscale/settings/add_subnet',
        data: {'subnet4': subnetData},
      );
      
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
      throw ApiException('Failed to add Tailscale subnet', response.statusCode);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Update an existing Tailscale subnet
  /// Modifies the subnet configuration for the given UUID
  Future<Map<String, dynamic>> setTailscaleSubnet(String uuid, TailscaleSubnet subnet) async {
    _ensureInitialized();

    try {
      // Convert subnet to JSON and remove uuid field (UUID is in the URL path)
      final subnetData = subnet.toJson();
      subnetData.remove('uuid');
      
      final response = await _dio!.post(
        '/tailscale/settings/set_subnet/$uuid',
        data: {'subnet4': subnetData},
      );
      
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
      throw ApiException('Failed to update Tailscale subnet', response.statusCode);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Delete a Tailscale subnet
  /// Removes the subnet configuration for the given UUID
  Future<Map<String, dynamic>> deleteTailscaleSubnet(String uuid) async {
    _ensureInitialized();

    try {
      final response = await _dio!.post(
        '/tailscale/settings/del_subnet/$uuid',
      );
      
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
      throw ApiException('Failed to delete Tailscale subnet', response.statusCode);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Reload Tailscale settings
  /// Applies the current configuration and restarts the service if needed
  Future<Map<String, dynamic>> reloadTailscaleSettings() async {
    _ensureInitialized();

    try {
      final response = await _dio!.get('/tailscale/settings/reload');

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
      throw ApiException('Failed to reload Tailscale settings', response.statusCode);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  void clear() {
    _dio = null;
    _config = null;
  }
}

/// Custom exception for API errors
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, this.statusCode);

  @override
  String toString() {
    if (statusCode != null) {
      return 'ApiException: $message (Status: $statusCode)';
    }
    return 'ApiException: $message';
  }
}

