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

import '../../models/firewall_alias.dart';
import 'alias/firewall_alias_crud_service.dart';
import 'alias/firewall_alias_metadata_service.dart';
import 'alias/firewall_alias_util_service.dart';

/// Service for firewall alias operations
/// Acts as a facade for specialized alias services
class FirewallAliasService {
  final FirewallAliasCrudService _crudService;
  final FirewallAliasMetadataService _metadataService;
  final FirewallAliasUtilService _utilService;

  FirewallAliasService()
      : _crudService = FirewallAliasCrudService(),
        _metadataService = FirewallAliasMetadataService(),
        _utilService = FirewallAliasUtilService();

  // ==================== CRUD Operations ====================

  /// Get all firewall aliases
  Future<List<FirewallAlias>> getFirewallAliases() async {
    return await _crudService.getFirewallAliases();
  }

  /// Get a specific firewall alias by UUID
  Future<FirewallAlias> getFirewallAlias(String uuid) async {
    return await _crudService.getFirewallAlias(uuid);
  }

  /// Get alias UUID by name
  Future<String?> getAliasUuidByName(String name) async {
    return await _crudService.getAliasUuidByName(name);
  }

  /// Create a new firewall alias
  Future<Map<String, dynamic>> createFirewallAlias(
      FirewallAliasRequest request) async {
    return await _crudService.createFirewallAlias(request);
  }

  /// Update an existing firewall alias
  Future<Map<String, dynamic>> updateFirewallAlias(
    String uuid,
    FirewallAliasRequest request,
  ) async {
    return await _crudService.updateFirewallAlias(uuid, request);
  }

  /// Toggle firewall alias enabled/disabled state
  Future<void> toggleFirewallAlias(String uuid) async {
    await _crudService.toggleFirewallAlias(uuid);
  }

  /// Delete a firewall alias
  Future<void> deleteFirewallAlias(String uuid) async {
    await _crudService.deleteFirewallAlias(uuid);
  }

  /// Apply firewall alias changes
  /// This must be called after creating, updating, toggling, or deleting aliases
  /// to actually apply the changes to the running firewall configuration
  Future<void> applyFirewallAliasChanges() async {
    await _crudService.toggleFirewallAlias(''); // Triggers reconfigure
  }

  // ==================== Metadata Operations ====================

  /// Get GeoIP information
  Future<Map<String, dynamic>> getGeoIP() async {
    return await _metadataService.getGeoIP();
  }

  /// Get alias table size
  Future<Map<String, dynamic>> getAliasTableSize() async {
    return await _metadataService.getAliasTableSize();
  }

  /// List available categories
  Future<List<AliasCategory>> listAliasCategories() async {
    return await _metadataService.listAliasCategories();
  }

  /// List available countries for GeoIP
  Future<List<AliasCountry>> listAliasCountries() async {
    return await _metadataService.listAliasCountries();
  }

  /// List network aliases
  Future<Map<String, dynamic>> listNetworkAliases() async {
    return await _metadataService.listNetworkAliases();
  }

  /// List user groups
  Future<Map<String, dynamic>> listUserGroups() async {
    return await _metadataService.listUserGroups();
  }

  // ==================== Utility Operations ====================

  /// Get all aliases (utility endpoint)
  Future<Map<String, dynamic>> getAliasesUtil() async {
    return await _utilService.getAliasesUtil();
  }

  /// List alias table entries
  Future<List<AliasTableEntry>> listAliasTable(String aliasName) async {
    return await _utilService.listAliasTable(aliasName);
  }

  /// Add item to alias table
  Future<Map<String, dynamic>> addToAliasTable(
      String aliasName, String address) async {
    return await _utilService.addToAliasTable(aliasName, address);
  }

  /// Delete item from alias table
  Future<Map<String, dynamic>> deleteFromAliasTable(
      String aliasName, String address) async {
    return await _utilService.deleteFromAliasTable(aliasName, address);
  }

  /// Flush alias table
  Future<Map<String, dynamic>> flushAliasTable(String aliasName) async {
    return await _utilService.flushAliasTable(aliasName);
  }

  /// Find references to an alias
  Future<Map<String, dynamic>> findAliasReferences(String aliasName) async {
    return await _utilService.findAliasReferences(aliasName);
  }

  /// Update bogons
  Future<Map<String, dynamic>> updateBogons() async {
    return await _utilService.updateBogons();
  }
}

// Made with Bob
