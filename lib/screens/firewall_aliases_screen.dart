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
import '../utils/snackbar_helper.dart';
import '../widgets/app_drawer.dart';
import '../widgets/common/error_display.dart';
import '../widgets/common/empty_state_widget.dart';
import '../l10n/app_localizations.dart';

/// Firewall aliases management screen
class FirewallAliasesScreen extends StatefulWidget {
  const FirewallAliasesScreen({super.key});

  @override
  State<FirewallAliasesScreen> createState() => _FirewallAliasesScreenState();
}

class _FirewallAliasesScreenState extends State<FirewallAliasesScreen> {
  // All 14 alias types supported by OPNsense
  static const List<String> _allAliasTypes = [
    'host',
    'network',
    'port',
    'url',
    'urltable',
    'urljson',
    'geoip',
    'networkgroup',
    'mac',
    'asn',
    'dynipv6host',
    'authgroup',
    'internal',
    'external',
  ];

  List<FirewallAlias> _aliases = [];
  SystemInfo? _systemInfo;
  bool _isLoading = true;
  String? _errorMessage;
  String _searchQuery = '';
  Set<String> _selectedTypes = {}; // Changed from String? to Set<String> for multi-select
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

    // Apply type filter - show aliases that match ANY of the selected types
    if (_selectedTypes.isNotEmpty) {
      filtered = filtered.where((alias) => _selectedTypes.contains(alias.type)).toList();
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

  void _showTypeFilterDialog() {
    final l10n = AppLocalizations.of(context)!;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Text(l10n.filterByType),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Select All / Clear All buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          setDialogState(() {
                            _selectedTypes = Set.from(_allAliasTypes);
                          });
                        },
                        icon: const Icon(Icons.select_all),
                        label: const Text('Select All'),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          setDialogState(() {
                            _selectedTypes.clear();
                          });
                        },
                        icon: const Icon(Icons.clear),
                        label: const Text('Clear All'),
                      ),
                    ],
                  ),
                  const Divider(),
                  // Checkbox list for all types
                  ..._allAliasTypes.map((type) {
                    return CheckboxListTile(
                      title: Text(FirewallAlias(
                        uuid: '',
                        name: '',
                        type: type,
                        content: '',
                      ).typeDisplayName),
                      value: _selectedTypes.contains(type),
                      onChanged: (bool? value) {
                        setDialogState(() {
                          if (value == true) {
                            _selectedTypes.add(type);
                          } else {
                            _selectedTypes.remove(type);
                          }
                        });
                      },
                      dense: true,
                    );
                  }),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.cancel),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    // Apply the filter
                  });
                  Navigator.of(context).pop();
                },
                child: const Text('Apply'),
              ),
            ],
          );
        },
      ),
    );
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
        SnackBarHelper.showSuccess(context, alias.isEnabled ? l10n.aliasDisabledSuccessfully : l10n.aliasEnabledSuccessfully);
        await _loadAliases();
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        SnackBarHelper.showError(context, l10n.failedToToggleAlias(e.toString()));
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
          SnackBarHelper.showSuccess(context, l10n.aliasDeletedSuccessfully);
          _loadAliases();
        }
      } catch (e) {
        if (mounted) {
          SnackBarHelper.showError(context, l10n.failedToDeleteAlias(e.toString()));
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
              _buildDetailRow('UUID', alias.uuid),
              _buildDetailRow(l10n.type, alias.typeDisplayName),
              _buildDetailRow(l10n.description, alias.description.isEmpty ? 'N/A' : alias.description),
              _buildDetailRow('Loaded #', _formatNumber(alias.currentItems)),
              _buildDetailRow(l10n.enabled, alias.isEnabled ? 'Yes' : 'No'),
              if (_formatCategories(alias.categories).isNotEmpty)
                _buildDetailRow(l10n.categories, _formatCategories(alias.categories)),
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

  /// Format number with thousand separators
  String _formatNumber(String value) {
    try {
      final number = int.parse(value);
      // Format with thousand separators
      final formatter = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
      return number.toString().replaceAllMapped(formatter, (Match m) => '${m[1]},');
    } catch (e) {
      // If parsing fails, return as-is
      return value;
    }
  }

  /// Format categories field - handles arrays and comma-separated values
  String _formatCategories(String categories) {
    if (categories.isEmpty) return '';
    
    // Handle empty array notation
    if (categories.trim() == '[]' || categories.trim() == '{}') {
      return '';
    }
    
    // If it's a JSON array, try to parse it
    if (categories.startsWith('[') && categories.endsWith(']')) {
      try {
        // Remove brackets and quotes, split by comma
        final cleaned = categories
            .substring(1, categories.length - 1)
            .replaceAll('"', '')
            .replaceAll("'", '')
            .trim();
        
        if (cleaned.isEmpty) return '';
        
        return cleaned.split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .join(', ');
      } catch (e) {
        // If parsing fails, return as-is
        return categories;
      }
    }
    
    // Handle comma-separated values
    if (categories.contains(',')) {
      return categories.split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .join(', ');
    }
    
    return categories;
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
                IconButton(
                  icon: Icon(
                    Icons.filter_list,
                    color: _selectedTypes.isNotEmpty ? Theme.of(context).colorScheme.primary : null,
                  ),
                  tooltip: l10n.filterByType,
                  onPressed: _showTypeFilterDialog,
                ),
              ],
            ),
          ),
          // Active filter indicator
          if (_selectedTypes.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  Chip(
                    avatar: const Icon(Icons.filter_alt, size: 18),
                    label: Text(
                      _selectedTypes.length == 1
                          ? FirewallAlias(
                              uuid: '',
                              name: '',
                              type: _selectedTypes.first,
                              content: '',
                            ).typeDisplayName
                          : '${_selectedTypes.length} types selected',
                    ),
                    onDeleted: () {
                      setState(() {
                        _selectedTypes.clear();
                      });
                    },
                    deleteIcon: const Icon(Icons.close, size: 18),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.itemsCount(filteredAliases.length),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          // Aliases list
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                    ? ErrorDisplay(message: _errorMessage!, onRetry: _loadAliases)
                    : filteredAliases.isEmpty
                        ? EmptyStateWidget(
                            icon: Icons.inbox,
                            title: _searchQuery.isNotEmpty || _selectedTypes.isNotEmpty
                                ? l10n.noAliasesMatchFilters
                                : l10n.noAliasesConfigured,
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
          SnackBarHelper.showInfo(context, l10n.createAliasComingSoon);
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
      case 'urljson':
        return Icons.link;
      case 'geoip':
        return Icons.public;
      case 'networkgroup':
        return Icons.group_work;
      case 'mac':
        return Icons.devices;
      case 'asn':
        return Icons.numbers;
      case 'dynipv6host':
        return Icons.dns;
      case 'authgroup':
        return Icons.group;
      case 'internal':
        return Icons.home;
      case 'external':
        return Icons.cloud;
      default:
        return Icons.label;
    }
  }
}


