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

import 'dart:async';
import 'package:flutter/material.dart';
import '../models/openvpn_instance_list_item.dart';
import '../services/demo_api_service.dart';
import '../utils/snackbar_helper.dart';
import '../viewmodels/openvpn_instances_view_model.dart';
import '../widgets/openvpn/openvpn_instance_card.dart';
import '../widgets/common/error_display.dart';
import '../widgets/common/empty_state_widget.dart';
import '../l10n/app_localizations.dart';
import '../widgets/common/confirmation_dialog.dart';

import 'openvpn_instance_form_screen.dart';

/// Screen for displaying OpenVPN instances list with pagination and search
class OpenvpnInstancesListScreen extends StatefulWidget {
  final DemoApiService apiService;
  final VoidCallback? onRefresh;
  final void Function(VoidCallback)? onRegisterRefresh;

  const OpenvpnInstancesListScreen({
    super.key,
    required this.apiService,
    this.onRefresh,
    this.onRegisterRefresh,
  });

  @override
  State<OpenvpnInstancesListScreen> createState() => _OpenvpnInstancesListScreenState();
}

class _OpenvpnInstancesListScreenState extends State<OpenvpnInstancesListScreen> {
  late OpenvpnInstancesViewModel _viewModel;
  int _rowCount = 50;
  int _totalCount = 0;
  String _roleFilter = 'all';
  String _statusFilter = 'all';
  String _searchQuery = '';
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    _viewModel = OpenvpnInstancesViewModel(
      widget.apiService,
      roleFilter: _roleFilter,
      statusFilter: _statusFilter,
      rowCount: _rowCount,
      apiSearchQuery: _searchQuery,
    );
    // Register the refresh callback with parent
    widget.onRegisterRefresh?.call(_loadInstances);
    // Load instances after the first frame to ensure context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadInstances();
      }
    });
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _loadInstances() async {
    _viewModel.roleFilter = _roleFilter;
    _viewModel.statusFilter = _statusFilter;
    _viewModel.rowCount = _rowCount;
    _viewModel.apiSearchQuery = _searchQuery;
    await _viewModel.loadItems();
    if (mounted) {
      setState(() {
        _totalCount = _viewModel.items.length;
      });
    }
  }

  Future<void> _toggleInstance(OpenvpnInstanceListItem instance) async {
    try {
      await _viewModel.toggleInstance(instance.uuid);
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        SnackBarHelper.showSuccess(
          context,
          l10n.instanceToggledSuccessfully(
              instance.enabled ? l10n.disabled : l10n.enabled),
        );
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        SnackBarHelper.showError(context, l10n.failedToToggleInstance(e.toString()));
      }
    }
  }

  Future<void> _deleteInstance(OpenvpnInstanceListItem instance) async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await ConfirmationDialog.show(
      context: context,
      title: l10n.deleteInstance,
      message: l10n.confirmDeleteInstance(
          instance.description.isNotEmpty ? instance.description : instance.vpnid),
      confirmText: l10n.delete,
      cancelText: l10n.cancel,
      isDestructive: true,
    );

    if (confirmed == true && mounted) {
      try {
        await _viewModel.deleteInstance(instance.uuid);
        if (mounted) {
          SnackBarHelper.showSuccess(context, l10n.instanceDeletedSuccessfully);
        }
      } catch (e) {
        if (mounted) {
          SnackBarHelper.showError(context, l10n.failedToDeleteInstance(e.toString()));
        }
      }
    }
  }

  void _showInstanceDetails(OpenvpnInstanceListItem instance) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(instance.description.isNotEmpty
            ? instance.description
            : l10n.instanceDetails),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow(l10n.id, instance.vpnid),
              _buildDetailRow(l10n.role, instance.role),
              _buildDetailRow(l10n.status, instance.statusText),
              if (instance.protocol != null)
                _buildDetailRow(l10n.protocol, instance.protocol!.toUpperCase()),
              if (instance.port != null)
                _buildDetailRow(l10n.port, instance.port!),
              if (instance.devType != null)
                _buildDetailRow(l10n.deviceType, instance.devType!),
              if (instance.local != null && instance.local!.isNotEmpty)
                _buildDetailRow(l10n.localAddress, instance.local!),
              if (instance.remote != null && instance.remote!.isNotEmpty)
                _buildDetailRow(l10n.remoteAddress, instance.remote!),
              if (instance.server != null && instance.server!.isNotEmpty)
                _buildDetailRow(l10n.serverNetwork, instance.server!),
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

  Future<void> _onEditInstance(OpenvpnInstanceListItem instance) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => OpenvpnInstanceFormScreen(vpnid: instance.uuid),
      ),
    );

    if (result == true && mounted) {
      await _loadInstances();
      widget.onRefresh?.call();
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
        final instances = _viewModel.items;

        return Column(
          children: [
            // Search and filters
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Search bar
                  TextField(
                    decoration: InputDecoration(
                      hintText: l10n.searchInstances,
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                      _searchDebounce?.cancel();
                      _searchDebounce = Timer(const Duration(milliseconds: 500), () {
                        _loadInstances();
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  // Filters row
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: _roleFilter,
                          decoration: InputDecoration(
                            labelText: l10n.role,
                            border: const OutlineInputBorder(),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                          ),
                          items: [
                            DropdownMenuItem(value: 'all', child: Text(l10n.allRoles)),
                            DropdownMenuItem(value: 'server', child: Text(l10n.server)),
                            DropdownMenuItem(value: 'client', child: Text(l10n.client)),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _roleFilter = value;
                              });
                              _loadInstances();
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: _statusFilter,
                          decoration: InputDecoration(
                            labelText: l10n.status,
                            border: const OutlineInputBorder(),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                          ),
                          items: [
                            DropdownMenuItem(value: 'all', child: Text(l10n.allStatus)),
                            DropdownMenuItem(
                                value: 'enabled', child: Text(l10n.enabled)),
                            DropdownMenuItem(
                                value: 'disabled', child: Text(l10n.disabled)),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _statusFilter = value;
                              });
                              _loadInstances();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Row count selector
                  Row(
                    children: [
                      Text(l10n.rowsPerPage),
                      const SizedBox(width: 12),
                      DropdownButton<int>(
                        value: _rowCount,
                        items: [
                          const DropdownMenuItem(value: 50, child: Text('50')),
                          const DropdownMenuItem(value: 100, child: Text('100')),
                          const DropdownMenuItem(value: 200, child: Text('200')),
                          const DropdownMenuItem(value: 500, child: Text('500')),
                          const DropdownMenuItem(value: 1000, child: Text('1000')),
                          DropdownMenuItem(value: -1, child: Text(l10n.all)),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _rowCount = value;
                            });
                            _loadInstances();
                          }
                        },
                      ),
                      const Spacer(),
                      Text(l10n.showingInstancesCount(
                          instances.length.toString(), _totalCount.toString())),
                    ],
                  ),
                ],
              ),
            ),
            // Instances list
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : errorMessage != null
                      ? ErrorDisplay(
                          message: errorMessage, onRetry: _loadInstances)
                      : instances.isEmpty
                          ? EmptyStateWidget(
                              icon: Icons.vpn_lock,
                              title: _searchQuery.isNotEmpty ||
                                      _roleFilter != 'all' ||
                                      _statusFilter != 'all'
                                  ? l10n.noInstancesMatchFilters
                                  : l10n.noOpenvpnInstancesConfigured,
                              subtitle: _searchQuery.isEmpty &&
                                      _roleFilter == 'all' &&
                                      _statusFilter == 'all'
                                  ? l10n.tapPlusButtonToCreateFirstInstance
                                  : null,
                            )
                          : RefreshIndicator(
                              onRefresh: () async {
                                await _loadInstances();
                                widget.onRefresh?.call();
                              },
                              child: ListView.builder(
                                itemCount: instances.length,
                                itemBuilder: (context, index) {
                                  final instance = instances[index];
                                  return OpenvpnInstanceCard(
                                    instance: instance,
                                    isToggling:
                                        _viewModel.isToggling(instance.uuid),
                                    onTap: () => _showInstanceDetails(instance),
                                    onToggle: (value) =>
                                        _toggleInstance(instance),
                                    onEdit: () => _onEditInstance(instance),
                                    onDelete: () => _deleteInstance(instance),
                                  );
                                },
                              ),
                            ),
            ),
          ],
        );
      },
    );
  }
}
