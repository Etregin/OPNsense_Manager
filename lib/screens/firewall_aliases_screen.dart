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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/firewall_alias.dart';
import '../models/system_info.dart';
import '../services/demo_api_service.dart';
import '../widgets/app_drawer.dart';
import '../l10n/app_localizations.dart';

/// Firewall aliases management screen
class FirewallAliasesScreen extends StatefulWidget {
  const FirewallAliasesScreen({super.key});

  @override
  State<FirewallAliasesScreen> createState() => _FirewallAliasesScreenState();
}

class _FirewallAliasesScreenState extends State<FirewallAliasesScreen> {
  List<FirewallAlias> _aliases = [];
  SystemInfo? _systemInfo;
  bool _isLoading = true;
  String? _errorMessage;
  String _searchQuery = '';
  String? _filterType;
  // Track which aliases are currently being toggled
  final Set<String> _togglingAliases = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.wait([
      _loadAliases(),
      _loadSystemInfo(),
    ]);
  }

  Future<void> _loadSystemInfo() async {
    try {
      final demoApiService = context.read<DemoApiService>();
      final systemInfo = await demoApiService.getSystemInfo();

      if (mounted) {
        setState(() {
          _systemInfo = systemInfo;
        });
      }
    } catch (e) {
      // Silently fail - system info is optional for drawer
    }
  }

  Future<void> _loadAliases() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final demoApiService = context.read<DemoApiService>();
      final aliases = await demoApiService.getFirewallAliases();

      if (mounted) {
        setState(() {
          _aliases = aliases;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  List<FirewallAlias> get _filteredAliases {
    var filtered = _aliases;

    // Apply type filter
    if (_filterType != null && _filterType!.isNotEmpty) {
      filtered = filtered.where((alias) => alias.type == _filterType).toList();
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((alias) {
        return alias.name.toLowerCase().contains(query) ||
            alias.description.toLowerCase().contains(query) ||
            alias.content.toLowerCase().contains(query);
      }).toList();
    }

    return filtered;
  }

  Set<String> get _availableTypes {
    return _aliases.map((alias) => alias.type).toSet();
  }

  Future<void> _toggleAlias(FirewallAlias alias, bool newValue) async {
    // Prevent multiple simultaneous toggles
    if (_togglingAliases.contains(alias.uuid)) {
      return;
    }

    setState(() {
      _togglingAliases.add(alias.uuid);
    });

    try {
      final demoApiService = context.read<DemoApiService>();
      await demoApiService.toggleFirewallAlias(alias.uuid);

      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(alias.isEnabled ? l10n.aliasDisabledSuccessfully : l10n.aliasEnabledSuccessfully),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
        await _loadAliases();
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.failedToToggleAlias(e.toString())),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _togglingAliases.remove(alias.uuid);
        });
      }
    }
  }

  Future<void> _deleteAlias(FirewallAlias alias) async {
    final l10n = AppLocalizations.of(context)!;
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteRule),
        content: Text(
          l10n.deleteAliasConfirmation(alias.name),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        final demoApiService = context.read<DemoApiService>();
        await demoApiService.deleteFirewallAlias(alias.uuid);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.aliasDeletedSuccessfully),
              backgroundColor: Colors.green,
            ),
          );
          _loadAliases();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.failedToDeleteAlias(e.toString())),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _showAliasDetails(FirewallAlias alias) {
    final l10n = AppLocalizations.of(context)!;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(alias.name),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow(l10n.type, alias.typeDisplayName),
              _buildDetailRow(l10n.description, alias.description.isEmpty ? 'N/A' : alias.description),
              _buildDetailRow(l10n.enabled, alias.isEnabled ? 'Yes' : 'No'),
              if (alias.proto.isNotEmpty)
                _buildDetailRow(l10n.protocol, alias.proto.toUpperCase()),
              if (alias.categories.isNotEmpty)
                _buildDetailRow(l10n.categories, alias.categories),
              const Divider(),
              Text(
                l10n.content,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...alias.contentList.map((item) => Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 4),
                child: Text('• $item'),
              )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final filteredAliases = _filteredAliases;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.firewallAliases),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAliases,
            tooltip: l10n.refresh,
          ),
        ],
      ),
      drawer: AppDrawer(
        currentRoute: 'firewall_aliases',
        systemInfo: _systemInfo,
      ),
      body: Column(
        children: [
          // Search and filter bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: l10n.searchAliases,
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.filter_list),
                  tooltip: l10n.filterByType,
                  onSelected: (value) {
                    setState(() {
                      _filterType = value == 'all' ? null : value;
                    });
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'all',
                      child: Text(l10n.allTypes),
                    ),
                    const PopupMenuDivider(),
                    ..._availableTypes.map((type) => PopupMenuItem(
                      value: type,
                      child: Text(FirewallAlias(
                        uuid: '',
                        name: '',
                        type: type,
                        content: '',
                      ).typeDisplayName),
                    )),
                  ],
                ),
              ],
            ),
          ),
          // Aliases list
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline, size: 48, color: Colors.red),
                            const SizedBox(height: 16),
                            Text(
                              l10n.error,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(_errorMessage!),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: _loadAliases,
                              icon: const Icon(Icons.refresh),
                              label: Text(l10n.retry),
                            ),
                          ],
                        ),
                      )
                    : filteredAliases.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.inbox, size: 48, color: Colors.grey),
                                const SizedBox(height: 16),
                                Text(
                                  _searchQuery.isNotEmpty || _filterType != null
                                      ? l10n.noAliasesMatchFilters
                                      : l10n.noAliasesConfigured,
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _loadAliases,
                            child: ListView.builder(
                              itemCount: filteredAliases.length,
                              itemBuilder: (context, index) {
                                final alias = filteredAliases[index];
                                final isToggling = _togglingAliases.contains(alias.uuid);
                                
                                return Card(
                                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: alias.isEnabled
                                          ? Colors.green
                                          : Colors.grey,
                                      child: Icon(
                                        _getIconForType(alias.type),
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                    title: Text(
                                      alias.name,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(alias.typeDisplayName),
                                        if (alias.description.isNotEmpty)
                                          Text(
                                            alias.description,
                                            style: const TextStyle(fontSize: 12),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        Text(
                                          l10n.itemsCount(alias.contentList.length),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // Toggle switch with loading indicator
                                        if (isToggling)
                                          const SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: CircularProgressIndicator(strokeWidth: 2),
                                          )
                                        else
                                          Switch(
                                            value: alias.isEnabled,
                                            onChanged: (value) => _toggleAlias(alias, value),
                                            activeTrackColor: Colors.green,
                                          ),
                                        const SizedBox(width: 8),
                                        // Menu button
                                        PopupMenuButton<String>(
                                          onSelected: (value) {
                                            switch (value) {
                                              case 'view':
                                                _showAliasDetails(alias);
                                                break;
                                              case 'delete':
                                                _deleteAlias(alias);
                                                break;
                                            }
                                          },
                                          itemBuilder: (context) => [
                                            PopupMenuItem(
                                              value: 'view',
                                              child: Row(
                                                children: [
                                                  const Icon(Icons.visibility),
                                                  const SizedBox(width: 8),
                                                  Text(l10n.viewDetails),
                                                ],
                                              ),
                                            ),
                                            PopupMenuItem(
                                              value: 'delete',
                                              child: Row(
                                                children: [
                                                  const Icon(Icons.delete, color: Colors.red),
                                                  const SizedBox(width: 8),
                                                  Text(l10n.delete, style: const TextStyle(color: Colors.red)),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    onTap: () => _showAliasDetails(alias),
                                  ),
                                );
                              },
                            ),
                          ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.createAliasComingSoon),
              duration: Duration(seconds: 2),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type.toLowerCase()) {
      case 'host':
        return Icons.computer;
      case 'network':
        return Icons.lan;
      case 'port':
        return Icons.settings_ethernet;
      case 'url':
      case 'urltable':
        return Icons.link;
      case 'geoip':
        return Icons.public;
      case 'mac':
        return Icons.devices;
      default:
        return Icons.label;
    }
  }
}


