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

import 'dart:async' show unawaited;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/firewall_constants.dart';
import '../utils/app_colors.dart';
import '../models/firewall_alias.dart';
import '../services/demo_api_service.dart';
import '../utils/single_init_mixin.dart';
import '../utils/snackbar_helper.dart';
import '../viewmodels/firewall_aliases_view_model.dart';
import '../widgets/app_drawer.dart';
import '../widgets/common/confirmation_dialog.dart';
import '../widgets/common/error_display.dart';
import '../widgets/firewall/alias_detail_sheet.dart';
import '../widgets/common/empty_state_widget.dart';
import '../widgets/common/search_bar_field.dart';
import '../l10n/app_localizations.dart';
import 'firewall_alias_form_screen.dart';

/// Firewall aliases management screen
class FirewallAliasesScreen extends StatefulWidget {
  const FirewallAliasesScreen({super.key});

  @override
  State<FirewallAliasesScreen> createState() => _FirewallAliasesScreenState();
}

class _FirewallAliasesScreenState extends State<FirewallAliasesScreen>
    with SingleInitMixin {
  late FirewallAliasesViewModel _viewModel;
  String _searchQuery = '';
  Set<String> _selectedTypes = {};
  Set<String> _selectedCategoryUuids = {};

  @override
  void onFirstDependency() {
    _viewModel = FirewallAliasesViewModel(context.read<DemoApiService>());
    _viewModel.loadItems();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  List<FirewallAlias> _getFilteredAliases(List<FirewallAlias> allItems) {
    var result = allItems;
    if (_selectedTypes.isNotEmpty) {
      result = result.where((a) => _selectedTypes.contains(a.type)).toList();
    }
    if (_selectedCategoryUuids.isNotEmpty) {
      result = result.where((a) =>
        a.categoriesUuid.any((u) => _selectedCategoryUuids.contains(u))
      ).toList();
    }
    return result;
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

  void _showCategoryFilterDialog() {
    final l10n = AppLocalizations.of(context)!;
    final categoryMap = _viewModel.categoryMap;

    if (categoryMap.isEmpty) {
      SnackBarHelper.showInfo(context, l10n.noItemsConfigured);
      return;
    }

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(l10n.filterByCategory),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton.icon(
                      onPressed: () => setDialogState(
                          () => _selectedCategoryUuids = Set.from(categoryMap.keys)),
                      icon: const Icon(Icons.select_all),
                      label: Text(l10n.selectAll),
                    ),
                    TextButton.icon(
                      onPressed: () =>
                          setDialogState(() => _selectedCategoryUuids.clear()),
                      icon: const Icon(Icons.clear),
                      label: Text(l10n.clearAll),
                    ),
                  ],
                ),
                const Divider(),
                ...categoryMap.entries.map((entry) {
                  final info = entry.value;
                  return CheckboxListTile(
                    secondary: CircleAvatar(
                      backgroundColor: info.color,
                      radius: 8,
                    ),
                    title: Text(info.name),
                    value: _selectedCategoryUuids.contains(entry.key),
                    onChanged: (val) => setDialogState(() {
                      if (val == true) {
                        _selectedCategoryUuids.add(entry.key);
                      } else {
                        _selectedCategoryUuids.remove(entry.key);
                      }
                    }),
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
                setState(() {});
                Navigator.of(context).pop();
              },
              child: Text(l10n.apply),
            ),
          ],
        ),
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

  Future<void> _navigateToForm({FirewallAlias? alias}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FirewallAliasFormScreen(alias: alias),
      ),
    );
    if (mounted) {
      unawaited(_viewModel.loadItems());
    }
  }

  void _showAliasDetails(FirewallAlias alias) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (_) => AliasDetailSheet(
        alias: alias,
        apiService: context.read<DemoApiService>(),
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
                      child: SearchBarField(
                        hintText: l10n.searchAliases,
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
                    IconButton(
                      icon: Icon(
                        Icons.label_outline,
                        color: _selectedCategoryUuids.isNotEmpty
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ),
                      tooltip: l10n.categoriesLabel,
                      onPressed: _showCategoryFilterDialog,
                    ),
                  ],
                ),
              ),
              // Active filter chips
              if (_selectedTypes.isNotEmpty || _selectedCategoryUuids.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 4.0),
                  child: Row(
                    children: [
                      if (_selectedTypes.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: Chip(
                            avatar: const Icon(Icons.filter_alt, size: 16),
                            label: Text(
                              _selectedTypes.length == 1
                                  ? FirewallAlias(
                                      uuid: '',
                                      name: '',
                                      type: _selectedTypes.first,
                                      content: '',
                                    ).typeDisplayName
                                  : '${_selectedTypes.length} types',
                            ),
                            onDeleted: () => setState(() => _selectedTypes.clear()),
                            deleteIcon: const Icon(Icons.close, size: 16),
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity.compact,
                          ),
                        ),
                      if (_selectedCategoryUuids.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: Chip(
                            avatar: const Icon(Icons.label_outline, size: 16),
                            label: Text(
                              _selectedCategoryUuids.length == 1
                                  ? (_viewModel.categoryMap[_selectedCategoryUuids.first]?.name ?? '')
                                  : '${_selectedCategoryUuids.length} categories',
                            ),
                            onDeleted: () => setState(() => _selectedCategoryUuids.clear()),
                            deleteIcon: const Icon(Icons.close, size: 16),
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity.compact,
                          ),
                        ),
                      const SizedBox(width: 4),
                      Text(
                        l10n.itemsCount(filteredAliases.length),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                                        _selectedTypes.isNotEmpty ||
                                        _selectedCategoryUuids.isNotEmpty
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
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                                              ),
                                            ),
                                            // Category color dots
                                            if (alias.categoriesUuid.isNotEmpty)
                                              Padding(
                                                padding: const EdgeInsets.only(top: 4),
                                                child: Wrap(
                                                  spacing: 4,
                                                  children: alias.categoriesUuid.map((uuid) {
                                                    final cat = _viewModel.categoryMap[uuid];
                                                    if (cat == null) return const SizedBox.shrink();
                                                    return Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        CircleAvatar(
                                                          backgroundColor: cat.color,
                                                          radius: 5,
                                                        ),
                                                        const SizedBox(width: 3),
                                                        Text(
                                                          cat.name,
                                                          style: TextStyle(
                                                            fontSize: 11,
                                                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  }).toList(),
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
                                                onChanged: alias.isSystemAlias
                                                    ? null
                                                    : (value) => _toggleAlias(alias, value),
                                                activeTrackColor: AppColors.success,
                                              ),
                                            const SizedBox(width: 8),
                                            PopupMenuButton<String>(
                                              onSelected: (value) {
                                                switch (value) {
                                                  case 'edit':
                                                    _navigateToForm(alias: alias);
                                                    break;
                                                  case 'view':
                                                    _showAliasDetails(alias);
                                                    break;
                                                  case 'delete':
                                                    _deleteAlias(alias);
                                                    break;
                                                }
                                              },
                                              itemBuilder: (context) => [
                                                if (!alias.isSystemAlias)
                                                  PopupMenuItem(
                                                    value: 'edit',
                                                    child: Row(
                                                      children: [
                                                        const Icon(Icons.edit),
                                                        const SizedBox(width: 8),
                                                        Text(l10n.edit),
                                                      ],
                                                    ),
                                                  ),
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
                                                if (!alias.isSystemAlias)
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
            onPressed: () => _navigateToForm(),
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
