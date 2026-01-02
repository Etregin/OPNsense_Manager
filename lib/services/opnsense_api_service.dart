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
import '../utils/constants.dart';

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

    // Allow self-signed certificates (for development/testing)
    (_dio!.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
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
      
      // Network errors (timeout, connection refused, etc.)
      return false;
    } catch (_) {
      // Silently handle error
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
      case DioExceptionType.unknown:
        if (e.error is SocketException) {
          return ApiException('Network error: Unable to connect', null);
        }
        return ApiException('Unknown error: ${e.message}', null);
      default:
        return ApiException('Request failed: ${e.message}', null);
    }
  }

  /// Clear configuration and reset service
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

