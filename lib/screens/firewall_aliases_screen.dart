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
import '../constants/firewall_constants.dart';
import '../utils/app_colors.dart';
import '../models/firewall_alias.dart';
import '../services/demo_api_service.dart';
import '../utils/snackbar_helper.dart';
import '../viewmodels/firewall_aliases_view_model.dart';
import '../widgets/app_drawer.dart';
import '../widgets/common/confirmation_dialog.dart';
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
  late FirewallAliasesViewModel _viewModel;
  bool _isInitialized = false;
  String _searchQuery = '';
  Set<String> _selectedTypes = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final apiService = context.read<DemoApiService>();
      _viewModel = FirewallAliasesViewModel(apiService);
      _isInitialized = true;
      _loadData();
    }
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    await Future.wait([
      _viewModel.loadItems(),
    ]);
  }

  List<FirewallAlias> _getFilteredAliases(List<FirewallAlias> allItems) {
    if (_selectedTypes.isEmpty) return allItems;
    return allItems.where((alias) => _selectedTypes.contains(alias.type)).toList();
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          setDialogState(() {
                            _selectedTypes = Set.from(FirewallConstants.aliasTypes);
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
                  ...FirewallConstants.aliasTypes.map((type) {
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
                    // Trigger rebuild to apply type filter
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
    try {
      await _viewModel.toggleAlias(alias.uuid);
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        SnackBarHelper.showSuccess(
          context,
          alias.isEnabled ? l10n.aliasDisabledSuccessfully : l10n.aliasEnabledSuccessfully,
        );
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        SnackBarHelper.showError(context, l10n.failedToToggleAlias(e.toString()));
      }
    }
  }

  Future<void> _deleteAlias(FirewallAlias alias) async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await ConfirmationDialog.show(
      context: context,
      title: l10n.deleteRule,
      message: l10n.deleteAliasConfirmation(alias.name),
      confirmText: l10n.delete,
      cancelText: l10n.cancel,
      isDestructive: true,
    );

    if (confirmed == true && mounted) {
      try {
        await _viewModel.deleteAlias(alias.uuid);
        if (mounted) {
          SnackBarHelper.showSuccess(context, l10n.aliasDeletedSuccessfully);
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
              _buildDetailRow(l10n.description, alias.description),
              _buildDetailRow(l10n.enabled, alias.isEnabled ? l10n.yes : l10n.no),
              const Divider(),
              Text(
                '${l10n.content}:',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...alias.contentList.take(20).map((item) => Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 4),
                child: Text('• $item'),
              )),
              if (alias.contentList.length > 20)
                Text('... and ${alias.contentList.length - 20} more'),
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
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        final isLoading = _viewModel.isLoading;
        final errorMessage = _viewModel.errorMessage;
        final filteredAliases = _getFilteredAliases(_viewModel.items);

        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.firewallAliases),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _viewModel.loadItems,
                tooltip: l10n.refresh,
              ),
            ],
          ),
          drawer: const AppDrawer(
            currentRoute: 'firewall_aliases'
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
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                          _viewModel.setSearchQuery(value);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Icon(
                        Icons.filter_list,
                        color: _selectedTypes.isNotEmpty
                            ? Theme.of(context).colorScheme.primary
                            : null,
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
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
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              // Aliases list
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : errorMessage != null
                        ? ErrorDisplay(
                            message: errorMessage,
                            onRetry: _viewModel.loadItems,
                          )
                        : filteredAliases.isEmpty
                            ? EmptyStateWidget(
                                icon: Icons.inbox,
                                title: _searchQuery.isNotEmpty ||
                                        _selectedTypes.isNotEmpty
                                    ? l10n.noAliasesMatchFilters
                                    : l10n.noAliasesConfigured,
                              )
                            : RefreshIndicator(
                                onRefresh: _viewModel.loadItems,
                                child: ListView.builder(
                                  itemCount: filteredAliases.length,
                                  itemBuilder: (context, index) {
                                    final alias = filteredAliases[index];
                                    final isToggling =
                                        _viewModel.isToggling(alias.uuid);

                                    return Card(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 4),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor: alias.isEnabled
                                              ? AppColors.success
                                              : AppColors.disabled,
                                          child: Icon(
                                            _getIconForType(alias.type),
                                            color: AppColors.onPrimary,
                                            size: 20,
                                          ),
                                        ),
                                        title: Text(
                                          alias.name,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(alias.typeDisplayName),
                                            if (alias.description.isNotEmpty)
                                              Text(
                                                alias.description,
                                                style: const TextStyle(
                                                    fontSize: 12),
                                                maxLines: 1,
                                                overflow:
                                                    TextOverflow.ellipsis,
                                              ),
                                            Text(
                                              l10n.itemsCount(
                                                  alias.contentList.length),
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: AppColors.textSecondary,
                                              ),
                                            ),
                                          ],
                                        ),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            if (isToggling)
                                              const SizedBox(
                                                width: 24,
                                                height: 24,
                                                child:
                                                    CircularProgressIndicator(
                                                        strokeWidth: 2),
                                              )
                                            else
                                              Switch(
                                                value: alias.isEnabled,
                                                onChanged: (value) =>
                                                    _toggleAlias(
                                                        alias, value),
                                                activeTrackColor: AppColors.success,
                                              ),
                                            const SizedBox(width: 8),
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
                                                      const Icon(
                                                          Icons.visibility),
                                                      const SizedBox(width: 8),
                                                      Text(l10n.viewDetails),
                                                    ],
                                                  ),
                                                ),
                                                PopupMenuItem(
                                                  value: 'delete',
                                                  child: Row(
                                                    children: [
                                                      const Icon(Icons.delete,
                                                          color: AppColors.error),
                                                      const SizedBox(width: 8),
                                                      Text(l10n.delete,
                                                          style:
                                                              const TextStyle(
                                                                  color: AppColors.error)),
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
      },
    );
  }
}
