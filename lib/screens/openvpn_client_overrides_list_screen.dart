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
import '../models/openvpn_client_override_list_item.dart';
import '../services/demo_api_service.dart';
import '../utils/snackbar_helper.dart';
import '../viewmodels/openvpn_client_overrides_view_model.dart';
import '../widgets/openvpn/openvpn_client_override_card.dart';
import '../widgets/app_drawer.dart';
import '../widgets/common/error_display.dart';
import '../widgets/common/empty_state_widget.dart';
import '../l10n/app_localizations.dart';

/// Screen for displaying OpenVPN client specific overrides list
class OpenvpnClientOverridesListScreen extends StatefulWidget {
  const OpenvpnClientOverridesListScreen({super.key});

  @override
  State<OpenvpnClientOverridesListScreen> createState() =>
      _OpenvpnClientOverridesListScreenState();
}

class _OpenvpnClientOverridesListScreenState
    extends State<OpenvpnClientOverridesListScreen> {
  late OpenvpnClientOverridesViewModel _viewModel;
  bool _isInitialized = false;
  String _statusFilter = 'all';
  int _rowCount = 50;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final apiService = context.read<DemoApiService>();
      _viewModel = OpenvpnClientOverridesViewModel(
        apiService,
        statusFilter: _statusFilter,
        rowCount: _rowCount,
        apiSearchQuery: _searchQuery,
      );
      _isInitialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _loadOverrides();
        }
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _loadOverrides() async {
    _viewModel.statusFilter = _statusFilter;
    _viewModel.rowCount = _rowCount;
    _viewModel.apiSearchQuery = _searchQuery;
    await _viewModel.loadItems();
  }

  Future<void> _toggleOverride(OpenvpnClientOverrideListItem clientOverride) async {
    try {
      await _viewModel.toggleOverride(clientOverride.uuid);
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        SnackBarHelper.showSuccess(
          context,
          l10n.overrideToggledSuccessfully(
              clientOverride.enabled ? l10n.disabled : l10n.enabled),
        );
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        SnackBarHelper.showError(context, l10n.failedToToggleOverride(e.toString()));
      }
    }
  }

  Future<void> _deleteOverride(OpenvpnClientOverrideListItem clientOverride) async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteOverride),
        content: Text(
          'Are you sure you want to delete override for "${clientOverride.commonName}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await _viewModel.deleteOverride(clientOverride.uuid);
        if (mounted) {
          SnackBarHelper.showSuccess(context, l10n.overrideDeletedSuccessfully);
        }
      } catch (e) {
        if (mounted) {
          SnackBarHelper.showError(context, l10n.failedToDeleteOverride(e.toString()));
        }
      }
    }
  }

  void _showOverrideDetails(OpenvpnClientOverrideListItem clientOverride) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(clientOverride.commonName.isNotEmpty
            ? clientOverride.commonName
            : 'Override Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Common Name', clientOverride.commonName),
              _buildDetailRow('Status', clientOverride.statusText),
              if (clientOverride.description.isNotEmpty)
                _buildDetailRow('Description', clientOverride.description),
              if (clientOverride.tunnelNetwork.isNotEmpty)
                _buildDetailRow('Tunnel Network', clientOverride.tunnelNetwork),
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

  Future<void> _onEditOverride(OpenvpnClientOverrideListItem clientOverride) async {
    final result = await Navigator.of(context).pushNamed(
      '/openvpn/client-overrides/form',
      arguments: clientOverride.uuid,
    );

    if (result == true && mounted) {
      await _loadOverrides();
    }
  }

  Future<void> _onAddOverride() async {
    final result = await Navigator.of(context).pushNamed(
      '/openvpn/client-overrides/form',
      arguments: null,
    );

    if (result == true && mounted) {
      await _loadOverrides();
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
        final overrides = _viewModel.items;

        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.clientSpecificOverrides),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _loadOverrides,
                tooltip: 'Refresh',
              ),
            ],
          ),
          drawer: const AppDrawer(currentRoute: 'openvpn_client_overrides'),
          body: Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search overrides...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _searchQuery = '';
                                _searchController.clear();
                              });
                              _loadOverrides();
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  onSubmitted: (_) => _loadOverrides(),
                ),
              ),
              // Pagination dropdown
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    const Text(
                      'Rows per page: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    DropdownButton<int>(
                      value: _rowCount,
                      items: const [
                        DropdownMenuItem(value: 50, child: Text('50')),
                        DropdownMenuItem(value: 100, child: Text('100')),
                        DropdownMenuItem(value: 200, child: Text('200')),
                        DropdownMenuItem(value: 500, child: Text('500')),
                        DropdownMenuItem(value: 1000, child: Text('1000')),
                        DropdownMenuItem(value: 9999, child: Text('All')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _rowCount = value!;
                        });
                        _loadOverrides();
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // Filter chips
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    const Text(
                      'Filter: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Wrap(
                        spacing: 8,
                        children: [
                          FilterChip(
                            label: const Text('All'),
                            selected: _statusFilter == 'all',
                            onSelected: (selected) {
                              if (selected) {
                                setState(() {
                                  _statusFilter = 'all';
                                });
                                _loadOverrides();
                              }
                            },
                          ),
                          FilterChip(
                            label: const Text('Enabled'),
                            selected: _statusFilter == 'enabled',
                            onSelected: (selected) {
                              if (selected) {
                                setState(() {
                                  _statusFilter = 'enabled';
                                });
                                _loadOverrides();
                              }
                            },
                          ),
                          FilterChip(
                            label: const Text('Disabled'),
                            selected: _statusFilter == 'disabled',
                            onSelected: (selected) {
                              if (selected) {
                                setState(() {
                                  _statusFilter = 'disabled';
                                });
                                _loadOverrides();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Overrides list
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : errorMessage != null
                        ? ErrorDisplay(
                            message: errorMessage, onRetry: _loadOverrides)
                        : overrides.isEmpty
                            ? EmptyStateWidget(
                                icon: Icons.person_off,
                                title: _statusFilter != 'all'
                                    ? 'No overrides match your filter'
                                    : 'No client specific overrides configured',
                                subtitle: _statusFilter == 'all'
                                    ? 'Tap the + button to create your first override'
                                    : null,
                              )
                            : RefreshIndicator(
                                onRefresh: _loadOverrides,
                                child: ListView.builder(
                                  itemCount: overrides.length,
                                  itemBuilder: (context, index) {
                                    final clientOverride = overrides[index];
                                    return OpenvpnClientOverrideCard(
                                      clientOverride: clientOverride,
                                      isToggling:
                                          _viewModel.isToggling(clientOverride.uuid),
                                      onTap: () =>
                                          _showOverrideDetails(clientOverride),
                                      onToggle: (value) =>
                                          _toggleOverride(clientOverride),
                                      onEdit: () =>
                                          _onEditOverride(clientOverride),
                                      onDelete: () =>
                                          _deleteOverride(clientOverride),
                                    );
                                  },
                                ),
                              ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _onAddOverride,
            tooltip: 'Add Override',
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
