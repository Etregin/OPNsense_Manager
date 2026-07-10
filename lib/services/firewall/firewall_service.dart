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

import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../base/base_opnsense_service.dart';
import '../base/api_exception.dart';
import '../../models/firewall_rule.dart';
import '../../constants/api_endpoints.dart';

/// Service for firewall rule operations
class FirewallService extends BaseOPNsenseService {
  Future<List<FirewallRule>> getFirewallRules() async {
    ensureInitialized();

    try {
      final List<FirewallRule> allRules = [];
      
      // Fetch automation rules using /firewall/filter/get endpoint only
      final automationResponse = await dio.get(ApiEndpoints.firewallRulesGet);
      
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
                    } catch (e) {
                      assert(() {
                        debugPrint('FirewallService: failed to parse rule: $e');
                        return true;
                      }());
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
                    } catch (e) {
                      assert(() {
                        debugPrint('FirewallService: failed to parse rule: $e');
                        return true;
                      }());
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
      throw handleDioError(e);
    }
  }

  /// Get available interfaces from OPNsense
  Future<Map<String, String>> getAvailableInterfaces() async {
    ensureInitialized();

    try {
      final response = await dio.get(ApiEndpoints.firewallRulesGet);
      
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
    ensureInitialized();

    try {
      final requestJson = request.toJson();
      
      final payload = {'rule': requestJson};
      
      // According to OPNsense API docs, we need to wrap the rule in a 'rule' object
      final response = await dio.post(
        ApiEndpoints.firewallRuleAdd,
        data: payload,
      );
      
      
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        
        // Check if the operation succeeded
        final result = data['result'] as String?;
        if (result == 'failed') {
          final validations = data['validations'] as Map<String, dynamic>?;
          final errorMessage = validations?.values.join(', ') ?? 'Unknown validation error';
          throw ApiException('Failed to create rule: $errorMessage', 400, ApiErrorType.unknown);
        }
        
        final uuid = data['uuid'] as String?;
        if (uuid == null || uuid.isEmpty) {
          throw const ApiException('No UUID returned from addRule', 500, ApiErrorType.unknown);
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
        throw ApiException('Failed to create firewall rule', response.statusCode, ApiErrorType.unknown);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
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
      type = extractSelectedValue(ruleData['action']);
    }
    if (type.isEmpty) type = 'pass';
    
    // Get interface - could be string or nested object
    // Use returnDisplayValue=true to get the friendly name (e.g., "LAN" instead of "lan")
    String interfaceName;
    if (ruleData['interface'] is String) {
      interfaceName = ruleData['interface'] as String;
    } else {
      interfaceName = extractSelectedValue(ruleData['interface'], returnDisplayValue: true);
    }
    
    // Get protocol - could be string or nested object
    String protocol;
    if (ruleData['protocol'] is String) {
      protocol = ruleData['protocol'] as String;
    } else {
      protocol = extractSelectedValue(ruleData['protocol']);
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
    ensureInitialized();

    try {
      final response = await dio.get(ApiEndpoints.firewallRuleGetOne(uuid));
      
      
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
          final type = extractSelectedValue(ruleData['action']);
          final interfaceName = extractSelectedValue(ruleData['interface']);
          final protocol = extractSelectedValue(ruleData['protocol']);
          
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
    ensureInitialized();

    try {
      final response = await dio.post(
        ApiEndpoints.firewallRuleSet(uuid),
        data: {'rule': request.toJson()},
      );
      
      if (response.statusCode == 200) {
        // Apply changes
        await applyFirewallChanges();
      } else {
        throw ApiException('Failed to update firewall rule', response.statusCode, ApiErrorType.unknown);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Toggle firewall rule (enable/disable)
  Future<void> toggleFirewallRule(String uuid) async {
    ensureInitialized();

    try {
      // Use the toggle endpoint
      final response = await dio.post(ApiEndpoints.firewallRuleToggle(uuid));
      
      if (response.statusCode == 200) {
        // Apply changes to make the toggle take effect
        await applyFirewallChanges();
      } else {
        throw ApiException('Failed to toggle firewall rule', response.statusCode, ApiErrorType.unknown);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Delete a firewall rule
  Future<void> deleteFirewallRule(String uuid) async {
    ensureInitialized();

    try {
      final response = await dio.post(ApiEndpoints.firewallRuleDelete(uuid));
      
      if (response.statusCode == 200) {
        // Apply changes
        await applyFirewallChanges();
      } else {
        throw ApiException('Failed to delete firewall rule', response.statusCode, ApiErrorType.unknown);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Apply firewall changes
  Future<void> applyFirewallChanges() async {
    ensureInitialized();

    try {
      await dio.post(ApiEndpoints.firewallRulesApply);
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Get firewall logs (live view)
  Future<List<dynamic>> getFirewallLogs({int limit = 100}) async {
    ensureInitialized();

    try {
      
      // Use the same endpoint as the web UI live view
      // Endpoint: /api/diagnostics/firewall/log
      final response = await dio.get(
        ApiEndpoints.diagnosticsFirewallLog,
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
        throw ApiException('Failed to get firewall logs', response.statusCode, ApiErrorType.unknown);
      }
    } on DioException catch (e) {
      if (e.response != null) {
      }
      throw handleDioError(e);
    }
  }
}


