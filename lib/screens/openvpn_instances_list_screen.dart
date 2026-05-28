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
import 'package:provider/provider.dart';
import '../models/openvpn_instance_list_item.dart';
import '../services/opnsense_api_service.dart';
import '../widgets/openvpn/openvpn_instance_card.dart';
import '../l10n/app_localizations.dart';
import 'openvpn_instance_form_screen.dart';

/// Screen for displaying OpenVPN instances list with pagination and search
class OpenvpnInstancesListScreen extends StatefulWidget {
  final OPNsenseApiService apiService;
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
  List<OpenvpnInstanceListItem> _instances = [];
  bool _isLoading = false;
  String? _errorMessage;
  int _currentPage = 1;
  int _rowCount = 50;
  int _totalCount = 0;
  String _roleFilter = 'all'; // all, server, client
  String _statusFilter = 'all'; // all, enabled, disabled
  String _searchQuery = '';
  final Set<String> _togglingInstances = {};
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    // Register the refresh callback with parent
    widget.onRegisterRefresh?.call(_loadInstances);
    // Load instances after the first frame to ensure context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadInstances();
      }
    });
  }

  Future<void> _loadInstances() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final apiService = context.read<OPNsenseApiService>();
      
      // Convert filter values for API
      final String? enabledParam = _statusFilter == 'all'
          ? null
          : (_statusFilter == 'enabled' ? '1' : '0');
      final String? searchParam = _searchQuery.isEmpty ? null : _searchQuery;
      
      final response = await apiService.searchOpenvpnInstances(
        current: _currentPage,
        rowCount: _rowCount == -1 ? 9999 : _rowCount,
        searchPhrase: searchParam,
        enabled: enabledParam,
      );

      // Apply client-side role filtering
      List<OpenvpnInstanceListItem> filteredInstances = _roleFilter == 'all'
          ? response.rows
          : response.filterByRole(_roleFilter);

      // Apply client-side status filtering
      if (_statusFilter != 'all') {
        filteredInstances = filteredInstances.where((item) =>
          _statusFilter == 'enabled' ? item.enabled : !item.enabled
        ).toList();
      }

      if (mounted) {
        setState(() {
          _instances = filteredInstances;
          _totalCount = filteredInstances.length;
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

  @override
  void dispose() {
    _searchDebounce?.cancel();
    super.dispose();
  }

  Future<void> _toggleInstance(OpenvpnInstanceListItem instance) async {
    if (_togglingInstances.contains(instance.uuid)) return;

    setState(() {
      _togglingInstances.add(instance.uuid);
    });

    try {
      final apiService = context.read<OPNsenseApiService>();
      await apiService.toggleOpenvpnInstance(instance.uuid);

      // Apply the configuration change
      await apiService.reconfigureOpenvpn();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Instance ${instance.enabled ? "disabled" : "enabled"} successfully'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
        await _loadInstances();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to toggle instance: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _togglingInstances.remove(instance.uuid);
        });
      }
    }
  }

  Future<void> _deleteInstance(OpenvpnInstanceListItem instance) async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Instance'),
        content: Text(
          'Are you sure you want to delete instance "${instance.description.isNotEmpty ? instance.description : instance.vpnid}"? This action cannot be undone.',
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
        final apiService = context.read<OPNsenseApiService>();
        print('[OpenVPN] DEBUG: Deleting instance with UUID: ${instance.uuid}');
        await apiService.deleteOpenvpnInstance(instance.uuid);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Instance deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
          await _loadInstances();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to delete instance: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _showInstanceDetails(OpenvpnInstanceListItem instance) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(instance.description.isNotEmpty ? instance.description : 'Instance Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('ID', instance.vpnid),
              _buildDetailRow('Role', instance.role),
              _buildDetailRow('Status', instance.statusText),
              if (instance.protocol != null)
                _buildDetailRow('Protocol', instance.protocol!.toUpperCase()),
              if (instance.port != null)
                _buildDetailRow('Port', instance.port!),
              if (instance.devType != null)
                _buildDetailRow('Device Type', instance.devType!),
              if (instance.local != null && instance.local!.isNotEmpty)
                _buildDetailRow('Local Address', instance.local!),
              if (instance.remote != null && instance.remote!.isNotEmpty)
                _buildDetailRow('Remote Address', instance.remote!),
              if (instance.server != null && instance.server!.isNotEmpty)
                _buildDetailRow('Server Network', instance.server!),
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
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Future<void> _onEditInstance(OpenvpnInstanceListItem instance) async {
    print('[OpenVPN] DEBUG: Editing instance with UUID: ${instance.uuid}');
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => OpenvpnInstanceFormScreen(vpnid: instance.uuid),
      ),
    );
    
    // Refresh list if instance was updated
    if (result == true && mounted) {
      await _loadInstances();
      widget.onRefresh?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
                  hintText: 'Search instances...',
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
                  
                  // Cancel previous timer
                  _searchDebounce?.cancel();
                  
                  // Create new timer for debounced search
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
                      decoration: const InputDecoration(
                        labelText: 'Role',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'all', child: Text('All Roles')),
                        DropdownMenuItem(value: 'server', child: Text('Server')),
                        DropdownMenuItem(value: 'client', child: Text('Client')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _roleFilter = value;
                            _currentPage = 1; // Reset to first page
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
                      decoration: const InputDecoration(
                        labelText: 'Status',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'all', child: Text('All Status')),
                        DropdownMenuItem(value: 'enabled', child: Text('Enabled')),
                        DropdownMenuItem(value: 'disabled', child: Text('Disabled')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _statusFilter = value;
                            _currentPage = 1; // Reset to first page
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
                  const Text('Rows per page:'),
                  const SizedBox(width: 12),
                  DropdownButton<int>(
                    value: _rowCount,
                    items: const [
                      DropdownMenuItem(value: 50, child: Text('50')),
                      DropdownMenuItem(value: 100, child: Text('100')),
                      DropdownMenuItem(value: 200, child: Text('200')),
                      DropdownMenuItem(value: 500, child: Text('500')),
                      DropdownMenuItem(value: 1000, child: Text('1000')),
                      DropdownMenuItem(value: -1, child: Text('All')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _rowCount = value;
                          _currentPage = 1;
                        });
                        _loadInstances();
                      }
                    },
                  ),
                  const Spacer(),
                  Text('Showing ${_instances.length} of $_totalCount'),
                ],
              ),
            ],
          ),
        ),
        // Instances list
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 48,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.error,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(_errorMessage!),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: _loadInstances,
                            icon: const Icon(Icons.refresh),
                            label: Text(l10n.retry),
                          ),
                        ],
                      ),
                    )
                  : _instances.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.vpn_lock,
                                size: 48,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _searchQuery.isNotEmpty || _roleFilter != 'all' || _statusFilter != 'all'
                                    ? 'No instances match your filters'
                                    : 'No OpenVPN instances configured',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              if (_searchQuery.isEmpty && _roleFilter == 'all' && _statusFilter == 'all')
                                const SizedBox(height: 8),
                              if (_searchQuery.isEmpty && _roleFilter == 'all' && _statusFilter == 'all')
                                const Text(
                                  'Tap the + button to create your first instance',
                                  style: TextStyle(color: Colors.grey),
                                ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: () async {
                            await _loadInstances();
                            widget.onRefresh?.call();
                          },
                          child: ListView.builder(
                            itemCount: _instances.length,
                            itemBuilder: (context, index) {
                              final instance = _instances[index];
                              return OpenvpnInstanceCard(
                                instance: instance,
                                isToggling: _togglingInstances.contains(instance.uuid),
                                onTap: () => _showInstanceDetails(instance),
                                onToggle: (value) => _toggleInstance(instance),
                                onEdit: () => _onEditInstance(instance),
                                onDelete: () => _deleteInstance(instance),
                              );
                            },
                          ),
                        ),
        ),
      ],
    );
  }
}


