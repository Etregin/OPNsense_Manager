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
import '../../models/firewall_form_options.dart';
import '../../constants/api_endpoints.dart';

/// Service for firewall rule operations
class FirewallService extends BaseOPNsenseService {
  /// Fetch all firewall rules via POST /firewall/filter/search_rule.
  /// Returns rules sorted by sort_order so the list matches the web UI order.
  Future<List<FirewallRule>> getFirewallRules() async {
    ensureInitialized();

    try {
      final response = await dio.post(
        ApiEndpoints.firewallRulesSearch,
        data: {'current': 1, 'rowCount': 500, 'sort': {}},
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final rows = data['rows'];
        if (rows is List) {
          final rules = <FirewallRule>[];
          for (final row in rows) {
            if (row is Map<String, dynamic>) {
              try {
                rules.add(_parseSearchRule(row));
              } catch (e) {
                assert(() {
                  debugPrint('[FirewallService] failed to parse rule: $e');
                  return true;
                }());
              }
            }
          }
          return rules;
        }
      }
      return [];
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Get available interfaces by fetching a blank new-rule form from the API.
  /// Falls back to a hard-coded default set on any error.
  Future<Map<String, String>> getAvailableInterfaces() async {
    ensureInitialized();

    try {
      // GET /firewall/filter/getRule/ with no UUID returns a blank rule form
      // whose 'interface' field is a nested dropdown with all available interfaces.
      final response = await dio.get(ApiEndpoints.firewallRuleGetOne(''));
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final ruleObj = data['rule'] as Map<String, dynamic>?;
        if (ruleObj != null) {
          final interfaceField = ruleObj['interface'];
          if (interfaceField is Map<String, dynamic>) {
            final interfaces = <String, String>{};
            for (final entry in interfaceField.entries) {
              final val = entry.value;
              if (val is Map<String, dynamic> && val.containsKey('value')) {
                interfaces[entry.key] = val['value'].toString();
              }
            }
            if (interfaces.isNotEmpty) return interfaces;
          }
        }
      }
    } on DioException {
      // fall through to defaults
    }

    return {'lan': 'LAN', 'wan': 'WAN'};
  }

  /// Extract option map from a nested dropdown field in the API response.
  Map<String, String> _extractOptions(dynamic field, String fallbackKey, String fallbackValue) {
    if (field is Map<String, dynamic>) {
      final result = <String, String>{};
      for (final entry in field.entries) {
        final val = entry.value;
        if (val is Map<String, dynamic> && val.containsKey('value')) {
          result[entry.key] = val['value'].toString();
        }
      }
      if (result.isNotEmpty) return result;
    }
    return {fallbackKey: fallbackValue};
  }

  /// Fetch all dynamic dropdown option maps needed by the rule form.
  /// Uses GET /firewall/filter/getRule/ (no UUID) to get a blank rule form
  /// that contains all populated dropdown options from the live system.
  Future<FirewallFormOptions> getFirewallRuleFormOptions() async {
    ensureInitialized();

    Map<String, dynamic>? ruleObj;

    try {
      final response = await dio.get(ApiEndpoints.firewallRuleGetOne(''));
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        ruleObj = data['rule'] as Map<String, dynamic>?;
      }
    } on DioException {
      // fall through to return defaults
    }

    // Fetch firewall categories from dedicated endpoint
    Map<String, String> categoryMap = {};
    try {
      final catResponse = await dio.get('/firewall/category/searchItem');
      if (catResponse.statusCode == 200) {
        final catData = catResponse.data as Map<String, dynamic>;
        final rows = catData['rows'];
        if (rows is List) {
          for (final row in rows) {
            if (row is Map<String, dynamic>) {
              final name = row['name']?.toString() ?? '';
              if (name.isNotEmpty) categoryMap[name] = name;
            }
          }
        }
      }
    } on DioException {
      // leave empty — categories are optional
    }

    return FirewallFormOptions(
      gateways:   _extractOptions(ruleObj?['gateway'],   '', 'None'),
      replyTo:    _extractOptions(ruleObj?['replyto'],   '', 'None'),
      divertTo:   _extractOptions(ruleObj?['divert-to'], '', 'None'),
      overload:   _extractOptions(ruleObj?['overload'],  '', 'None'),
      schedules:  _extractOptions(ruleObj?['sched'],     '', 'None'),
      shapers:    _extractOptions(ruleObj?['shaper1'],   '', 'None'),
      prio:       _extractOptions(ruleObj?['prio'],      '', 'Any priority'),
      setPrio:    _extractOptions(ruleObj?['set-prio'],  '', 'Keep current priority'),
      tos:        _extractOptions(ruleObj?['tos'],       '', 'Any'),
      categories: categoryMap,
    );
  }



  /// Create a new firewall rule
  Future<String> createFirewallRule(FirewallRuleRequest request) async {
    ensureInitialized();

    try {
      final payload = {'rule': request.toJson()};

      debugPrint('[FirewallService] create payload: $payload');

      final response = await dio.post(
        ApiEndpoints.firewallRuleAdd,
        data: payload,
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;

        debugPrint('[FirewallService] create response: $data');

        final result = data['result'] as String?;
        if (result == 'failed') {
          final validations = data['validations'] as Map<String, dynamic>?;
          // Build a human-readable message showing field → error
          final errorMessage = validations != null
              ? validations.entries.map((e) => '${e.key}: ${e.value}').join('\n')
              : 'Unknown validation error';
          debugPrint('[FirewallService] validation errors:\n$errorMessage');
          throw ApiException('Failed to create rule:\n$errorMessage', 400, ApiErrorType.unknown);
        }

        final uuid = data['uuid'] as String?;
        if (uuid == null || uuid.isEmpty) {
          throw const ApiException('No UUID returned from add_rule', 500, ApiErrorType.unknown);
        }

        // Apply changes to make the rule active
        await applyFirewallChanges();

        return uuid;
      } else {
        throw ApiException('Failed to create firewall rule', response.statusCode, ApiErrorType.unknown);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Parse a rule row from POST /firewall/filter/search_rule.
  /// All fields are flat strings; human-readable percent-prefixed fields
  /// (e.g. '%action', '%direction') are available as display labels.
  FirewallRule _parseSearchRule(Map<String, dynamic> r) {
    // action: prefer the raw value, fall back to the display value stripped
    String type = r['action']?.toString() ?? '';
    if (type.isEmpty) type = (r['%action']?.toString() ?? '').toLowerCase();
    if (type.isEmpty) type = 'pass';

    // interface: raw key (e.g. 'lan', 'wan', '') — '' means any/floating
    final String interfaceName = r['interface']?.toString() ?? '';

    // protocol: raw lowercase (e.g. 'tcp', 'udp', 'any', '')
    String protocol = r['protocol']?.toString() ?? '';
    if (protocol.isEmpty) protocol = 'any';

    // source / destination
    String source = r['source_net']?.toString() ?? '';
    if (source.isEmpty) source = 'any';
    String destination = r['destination_net']?.toString() ?? '';
    if (destination.isEmpty) destination = 'any';

    final String sourcePort      = r['source_port']?.toString()      ?? '';
    final String destinationPort = r['destination_port']?.toString()  ?? '';
    final String description     = r['description']?.toString()       ?? '';
    final String direction       = r['direction']?.toString()         ?? 'in';
    final String ipProtocol      = r['ipprotocol']?.toString()        ?? 'inet';

    // enabled: the search_rule endpoint returns "1"/"0" or bool
    final dynamic rawEnabled = r['enabled'];
    final String enabled = rawEnabled == false || rawEnabled == '0' ? '0' : '1';

    // sequence: numeric string or int
    final int sequence =
        int.tryParse(r['sequence']?.toString() ?? '0') ?? 0;

    // sort_order present in search_rule — store in sortOrder
    final String sortOrder = r['sort_order']?.toString() ?? '';

    // system/automatic rules: 'is_automatic' or 'legacy' flags
    final bool isAutomatic = r['is_automatic'] == true || r['legacy'] == true;
    // Use 'automatic' sentinel when ref is absent or empty (some rules have ref: "")
    final String rawRef = r['ref']?.toString() ?? '';
    final String origin = isAutomatic ? (rawRef.isEmpty ? 'automatic' : rawRef) : '';

    // quick: "1"/"0" or bool
    final dynamic rawQuick = r['quick'];
    final String quick = rawQuick == false || rawQuick == '0' ? '0' : '1';

    // log: same pattern
    final dynamic rawLog = r['log'];
    final String log = rawLog == true || rawLog == '1' ? '1' : '0';

    return FirewallRule(
      uuid:            r['uuid']?.toString() ?? '',
      type:            type,
      interfaceName:   interfaceName,
      protocol:        protocol,
      source:          source,
      destination:     destination,
      sourcePort:      sourcePort,
      destinationPort: destinationPort,
      description:     description,
      enabled:         enabled,
      sequence:        sequence,
      sortOrder:       sortOrder,
      origin:          origin,
      direction:       direction,
      ipProtocol:      ipProtocol,
      quick:           quick,
      log:             log,
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
          // OPNsense returns complex nested structures for dropdowns —
          // extract the selected key from each.
          final type         = extractSelectedValue(ruleData['action']);
          final interfaceName = extractSelectedValue(ruleData['interface']);
          final protocol     = extractSelectedValue(ruleData['protocol']);
          final direction    = extractSelectedValue(ruleData['direction']);
          final ipProtocol   = extractSelectedValue(ruleData['ipprotocol']);
          final stateType    = extractSelectedValue(ruleData['statetype']);
          final statePolicy  = extractSelectedValue(ruleData['state-policy']);
          final divertTo     = extractSelectedValue(ruleData['divert-to']);
          final gateway      = extractSelectedValue(ruleData['gateway']);
          final replyTo      = extractSelectedValue(ruleData['replyto']);
          final overload     = extractSelectedValue(ruleData['overload']);
          final prio         = extractSelectedValue(ruleData['prio']);
          final setPrio      = extractSelectedValue(ruleData['set-prio']);
          final setPrioLow   = extractSelectedValue(ruleData['set-prio-low']);
          final tos          = extractSelectedValue(ruleData['tos']);
          final sched        = extractSelectedValue(ruleData['sched']);
          final shaper1      = extractSelectedValue(ruleData['shaper1']);
          final shaper2      = extractSelectedValue(ruleData['shaper2']);

          // icmptype / icmp6type — extract the selected key ('' means "any")
          final icmpType  = extractSelectedValue(ruleData['icmptype']);
          final icmp6Type = extractSelectedValue(ruleData['icmp6type']);

          // Flat string fields
          final source      = ruleData['source_net']?.toString() ?? ruleData['source']?.toString() ?? 'any';
          final destination = ruleData['destination_net']?.toString() ?? ruleData['destination']?.toString() ?? 'any';
          final description = ruleData['descr']?.toString() ?? ruleData['description']?.toString() ?? '';
          final sourcePort  = ruleData['source_port']?.toString() ?? '';
          final destPort    = ruleData['destination_port']?.toString() ?? '';

          return FirewallRule(
            uuid: uuid,
            type:            type.isNotEmpty ? type : 'pass',
            interfaceName:   interfaceName,
            protocol:        protocol.isNotEmpty ? protocol : 'any',
            icmpType:        icmpType,
            icmp6Type:       icmp6Type,
            source:          source,
            destination:     destination,
            sourcePort:      sourcePort,
            destinationPort: destPort,
            description:     description,
            enabled:         ruleData['enabled']?.toString() ?? '1',
            sequence:        int.tryParse(ruleData['sequence']?.toString() ?? '0') ?? 0,
            direction:       direction.isNotEmpty ? direction : 'in',
            ipProtocol:      ipProtocol.isNotEmpty ? ipProtocol : 'inet',
            quick:           ruleData['quick']?.toString() ?? '1',
            log:             ruleData['log']?.toString() ?? '0',
            stateType:       stateType.isNotEmpty ? stateType : 'keep',
            statePolicy:     statePolicy,
            divertTo:        divertTo,
            gateway:         gateway,
            replyTo:         replyTo,
            overload:        overload,
            prio:            prio,
            setPrio:         setPrio,
            setPrioLow:      setPrioLow,
            tos:             tos,
            schedule:        sched,
            shaper1:         shaper1,
            shaper2:         shaper2,
            interfaceNot:    ruleData['interfacenot']?.toString() ?? '0',
            sourceNot:       ruleData['source_not']?.toString() ?? '0',
            destinationNot:  ruleData['destination_not']?.toString() ?? '0',
            noSync:          ruleData['nosync']?.toString() ?? '0',
            allowOpts:       ruleData['allowopts']?.toString() ?? '0',
            noPfsync:        ruleData['nopfsync']?.toString() ?? '0',
            disableReplyTo:  ruleData['disablereplyto']?.toString() ?? '0',
            statTimeout:     ruleData['statetimeout']?.toString() ?? '',
            udpFirst:        ruleData['udp-first']?.toString() ?? '',
            udpSingle:       ruleData['udp-single']?.toString() ?? '',
            udpMultiple:     ruleData['udp-multiple']?.toString() ?? '',
            adaptiveStart:   ruleData['adaptivestart']?.toString() ?? '',
            adaptiveEnd:     ruleData['adaptiveend']?.toString() ?? '',
            max:             ruleData['max']?.toString() ?? '',
            maxSrcNodes:     ruleData['max-src-nodes']?.toString() ?? '',
            maxSrcStates:    ruleData['max-src-states']?.toString() ?? '',
            maxSrcConn:      ruleData['max-src-conn']?.toString() ?? '',
            maxSrcConnRate:  ruleData['max-src-conn-rate']?.toString() ?? '',
            maxSrcConnRates: ruleData['max-src-conn-rates']?.toString() ?? '',
            tag:             ruleData['tag']?.toString() ?? '',
            tagged:          ruleData['tagged']?.toString() ?? '',
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

  /// Apply firewall changes so that saved rules become active.
  ///
  /// OPNsense reloads pf while serving this request, which can cause the
  /// connection to drop or return an empty body — that is normal behaviour.
  /// We therefore swallow ALL errors here and only log them as debug output.
  /// A failed apply does NOT mean the rule was not saved; the rule is always
  /// persisted by add_rule / set_rule regardless of whether apply succeeds.
  Future<void> applyFirewallChanges() async {
    if (!isInitialized) return;

    try {
      await dio.post(ApiEndpoints.firewallRulesApply);
    } on DioException catch (e) {
      // Ignore connection/timeout errors from the apply endpoint — pf reload
      // can legitimately drop the HTTP connection mid-response.
      debugPrint('[FirewallService] applyFirewallChanges warning (ignored): ${e.message}');
    } catch (e) {
      debugPrint('[FirewallService] applyFirewallChanges unexpected error (ignored): $e');
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


