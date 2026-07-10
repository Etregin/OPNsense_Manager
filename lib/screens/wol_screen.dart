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
import '../l10n/app_localizations.dart';
import '../models/wol_host.dart';
import '../services/demo_api_service.dart';
import '../utils/single_init_mixin.dart';
import '../utils/snackbar_helper.dart';
import '../utils/validators.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../viewmodels/wol_view_model.dart';
import '../widgets/app_drawer.dart';
import '../widgets/common/error_display.dart';
import '../widgets/common/empty_state_widget.dart';
import '../widgets/common/confirmation_dialog.dart';

/// Wake-on-LAN screen for managing and waking network hosts
class WolScreen extends StatefulWidget {
  const WolScreen({super.key});

  @override
  State<WolScreen> createState() => _WolScreenState();
}

class _WolScreenState extends State<WolScreen>
    with SingleInitMixin {
  late WolViewModel _viewModel;

  @override
  void onFirstDependency() {
    _viewModel = WolViewModel(context.read<DemoApiService>());
    _viewModel.loadItems();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _wakeHost(WolHost host) async {
    try {
      final demoApiService = context.read<DemoApiService>();
      await demoApiService.wakeHost(host.uuid);
      if (mounted) {
        SnackBarHelper.showSuccess(context, 'Wake-on-LAN packet sent to ${host.descr.isNotEmpty ? host.descr : host.mac}');
      }
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showError(context, 'Failed to wake host: ${e.toString()}');
      }
    }
  }

  Future<void> _wakeAllHosts() async {
    final l10n = AppLocalizations.of(context)!;
    // Show confirmation dialog
    final confirmed = await ConfirmationDialog.show(
      context: context,
      title: l10n.wakeAllDevices,
      message: l10n.wakeAllDevicesConfirmation,
      confirmText: l10n.wakeAll,
      cancelText: l10n.cancel,
    );

    if (confirmed != true) return;

    // Show loading indicator
    if (!mounted) return;
    unawaited(showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(AppLocalizations.of(context)!.wakingAllDevices),
              ],
            ),
          ),
        ),
      ),
    ));

    // Store context references before async operations
    final demoApiService = context.read<DemoApiService>();
    final navigator = Navigator.of(context);

    try {
      final results = await demoApiService.wakeAllHosts();
      
      if (!mounted) return;
      navigator.pop(); // Close loading dialog

      // Count successful wakes
      final successCount = results.where((r) => r.isSuccess).length;
      final failedResults = results.where((r) => !r.isSuccess).toList();

      // Show results dialog
      unawaited(showDialog(
        context: navigator.context,
        builder: (context) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.wakeAllResults),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.successfullyWokenDevices(successCount, results.length),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              if (failedResults.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context)!.failedDevices,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.error),
                ),
                const SizedBox(height: 8),
                ...failedResults.map((result) => Text(
                  '• ${result.mac}: ${result.status}',
                  style: const TextStyle(fontFamily: 'monospace'),
                )),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.of(context)!.ok),
            ),
          ],
        ),
      ));
    } catch (e) {
      if (!mounted) return;
      navigator.pop(); // Close loading dialog
      
      SnackBarHelper.showError(context, '${AppLocalizations.of(context)!.failedToWakeAllHosts}: ${e.toString()}');
    }
  }

  Future<void> _deleteHost(WolHost host) async {
    // Store context references before async operations
    final demoApiService = context.read<DemoApiService>();

    final l10n = AppLocalizations.of(context)!;
    final confirmed = await ConfirmationDialog.show(
      context: context,
      title: l10n.deleteHost,
      message: l10n.deleteHostConfirmation(
          host.descr.isNotEmpty ? host.descr : host.mac),
      confirmText: l10n.delete,
      cancelText: l10n.cancel,
      isDestructive: true,
    );

    if (confirmed == true) {
      try {
        await demoApiService.deleteWolHost(host.uuid);
        if (mounted) {
          SnackBarHelper.showSuccess(
              context, AppLocalizations.of(context)!.hostDeletedSuccessfully);
          await _viewModel.loadItems();
        }
      } catch (e) {
        if (mounted) {
          SnackBarHelper.showError(context,
              '${AppLocalizations.of(context)!.failedToDeleteHost}: ${e.toString()}');
        }
      }
    }
  }

  void _showAddHostDialog() {
    showDialog(
      context: context,
      builder: (context) => _AddHostDialog(
        onHostAdded: _viewModel.loadItems,
      ),
    );
  }

  void _showEditHostDialog(WolHost host) {
    showDialog(
      context: context,
      builder: (context) => _AddHostDialog(
        onHostAdded: _viewModel.loadItems,
        existingHost: host,
      ),
    );
  }

  Future<void> _copyHost(WolHost host) async {
    unawaited(showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(AppLocalizations.of(context)!.loadingHostData),
              ],
            ),
          ),
        ),
      ),
    ));

    try {
      final demoApiService = context.read<DemoApiService>();
      final hostData = await demoApiService.copyWolHost(host.uuid);

      if (!mounted) return;
      Navigator.of(context).pop();

      unawaited(showDialog(
        context: context,
        builder: (context) => _AddHostDialog(
          onHostAdded: _viewModel.loadItems,
          copiedHostData: hostData,
        ),
      ));
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop();

      SnackBarHelper.showError(context,
          '${AppLocalizations.of(context)!.failedToCopyHost}: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        final theme = Theme.of(context);
        final hosts = _viewModel.items;

        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.wakeOnLan),
            actions: [
              IconButton(
                icon: const Icon(Icons.flash_on),
                onPressed: (_viewModel.isLoading || hosts.isEmpty)
                    ? null
                    : _wakeAllHosts,
                tooltip: l10n.wakeAll,
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed:
                    _viewModel.isLoading ? null : _viewModel.loadItems,
                tooltip: l10n.refresh,
              ),
            ],
          ),
          drawer: const AppDrawer(currentRoute: 'wol'),
          body: _buildBody(theme, l10n, hosts),
          floatingActionButton: FloatingActionButton(
            onPressed: _showAddHostDialog,
            tooltip: l10n.addHost,
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  Widget _buildBody(
      ThemeData theme, AppLocalizations l10n, List<WolHost> hosts) {
    if (_viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_viewModel.errorMessage != null) {
      return ErrorDisplay(
        message: _viewModel.errorMessage!,
        onRetry: _viewModel.loadItems,
      );
    }

    if (hosts.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.devices_other,
        title: l10n.noWolHostsConfigured,
        subtitle: l10n.addHostToGetStarted,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.standardPadding),
      itemCount: hosts.length,
      itemBuilder: (context, index) {
        final host = hosts[index];
        return _WolHostCard(
          host: host,
          onWake: () => _wakeHost(host),
          onEdit: () => _showEditHostDialog(host),
          onCopy: () => _copyHost(host),
          onDelete: () => _deleteHost(host),
        );
      },
    );
  }
}

/// Card widget for displaying a WOL host
class _WolHostCard extends StatelessWidget {
  final WolHost host;
  final VoidCallback onWake;
  final VoidCallback onEdit;
  final VoidCallback onCopy;
  final VoidCallback onDelete;

  const _WolHostCard({
    required this.host,
    required this.onWake,
    required this.onEdit,
    required this.onCopy,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.standardPadding),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.standardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.computer,
                  color: theme.colorScheme.primary,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        host.descr.isNotEmpty ? host.descr : AppLocalizations.of(context)!.unnamedHost,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        host.mac,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontFamily: 'monospace',
                          color: theme.colorScheme.onSurface.withValues(alpha: AppColors.opacityStrong),
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'edit':
                        onEdit();
                        break;
                      case 'copy':
                        onCopy();
                        break;
                      case 'delete':
                        onDelete();
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          const Icon(Icons.edit, size: 20),
                          const SizedBox(width: 8),
                          Text(AppLocalizations.of(context)!.edit),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'copy',
                      child: Row(
                        children: [
                          const Icon(Icons.content_copy, size: 20),
                          const SizedBox(width: 8),
                          Text(AppLocalizations.of(context)!.copy),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          const Icon(Icons.delete, size: 20, color: AppColors.error),
                          const SizedBox(width: 8),
                          Text(AppLocalizations.of(context)!.delete, style: const TextStyle(color: AppColors.error)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.network_check,
                  size: 16,
                  color: theme.colorScheme.onSurface.withValues(alpha: AppColors.opacitySubdued),
                ),
                const SizedBox(width: 8),
                Text(
                  'Interface: ${host.interfaceDisplay}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: AppColors.opacitySubdued),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onWake,
                icon: const Icon(Icons.power_settings_new),
                label: Text(AppLocalizations.of(context)!.wakeHost),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Dialog for adding or editing a WOL host
class _AddHostDialog extends StatefulWidget {
  final VoidCallback onHostAdded;
  final WolHost? existingHost;
  final Map<String, dynamic>? copiedHostData;

  const _AddHostDialog({
    required this.onHostAdded,
    this.existingHost,
    this.copiedHostData,
  });

  @override
  State<_AddHostDialog> createState() => _AddHostDialogState();
}

class _AddHostDialogState extends State<_AddHostDialog> {
  final _formKey = GlobalKey<FormState>();
  final _macController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedInterface;
  Map<String, WolInterfaceOption> _interfaceOptions = {};
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.existingHost != null) {
      _macController.text = widget.existingHost!.mac;
      _descriptionController.text = widget.existingHost!.descr;
      _selectedInterface = widget.existingHost!.interface;
    } else if (widget.copiedHostData != null) {
      // Pre-fill with copied data
      _macController.text = widget.copiedHostData!['mac'] ?? '';
      _descriptionController.text = widget.copiedHostData!['descr'] ?? '';
      // Find the selected interface from the copied data
      if (widget.copiedHostData!.containsKey('interface')) {
        final interfaceData = widget.copiedHostData!['interface'] as Map<String, dynamic>;
        for (var entry in interfaceData.entries) {
          if (entry.value is Map<String, dynamic>) {
            final selected = entry.value['selected'] as int?;
            if (selected == 1) {
              _selectedInterface = entry.key;
              break;
            }
          }
        }
      }
    }
    _loadInterfaceOptions();
  }

  @override
  void dispose() {
    _macController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadInterfaceOptions() async {
    try {
      final demoApiService = context.read<DemoApiService>();
      final options = await demoApiService.getWolInterfaceOptions();
      if (mounted) {
        setState(() {
          _interfaceOptions = options;
          _isLoading = false;
          // Set default interface if not editing
          if (widget.existingHost == null && _selectedInterface == null && options.isNotEmpty) {
            _selectedInterface = options.keys.first;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        SnackBarHelper.showError(context, '${AppLocalizations.of(context)!.failedToLoadInterfaces}: ${e.toString()}');
      }
    }
  }

  Future<void> _saveHost() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedInterface == null) {
      SnackBarHelper.showError(context, AppLocalizations.of(context)!.pleaseSelectInterface);
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final demoApiService = context.read<DemoApiService>();
      
      if (widget.existingHost != null) {
        await demoApiService.updateWolHost(
          widget.existingHost!.uuid,
          _selectedInterface!,
          _macController.text.trim(),
          _descriptionController.text.trim(),
        );
      } else {
        await demoApiService.addWolHost(
          _selectedInterface!,
          _macController.text.trim(),
          _descriptionController.text.trim(),
        );
      }

      if (mounted) {
        Navigator.of(context).pop();
        SnackBarHelper.showSuccess(context, widget.existingHost != null ? AppLocalizations.of(context)!.hostUpdatedSuccessfully : AppLocalizations.of(context)!.hostAddedSuccessfully);
        widget.onHostAdded();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
        SnackBarHelper.showError(context, '${AppLocalizations.of(context)!.failedToSaveHost}: ${e.toString()}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final String dialogTitle;
    if (widget.existingHost != null) {
      dialogTitle = l10n.editHost;
    } else if (widget.copiedHostData != null) {
      dialogTitle = l10n.copyHost;
    } else {
      dialogTitle = l10n.addHost;
    }
    
    return AlertDialog(
      title: Text(dialogTitle),
      content: _isLoading
          ? const SizedBox(
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            )
          : SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButtonFormField<String>(
                      initialValue: _selectedInterface,
                      decoration: InputDecoration(
                        labelText: l10n.interface,
                        border: const OutlineInputBorder(),
                      ),
                      items: _interfaceOptions.entries.map((entry) {
                        return DropdownMenuItem(
                          value: entry.key,
                          child: Text(entry.value.value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedInterface = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return l10n.pleaseSelectInterface;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _macController,
                      decoration: InputDecoration(
                        labelText: l10n.macAddress,
                        hintText: l10n.macAddressHint,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (v) => Validators.validateMacAddress(v, context),
                      textCapitalization: TextCapitalization.characters,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: l10n.description,
                        hintText: l10n.descriptionHint,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return l10n.descriptionRequired;
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: _isSaving ? null : _saveHost,
          child: _isSaving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(widget.existingHost != null ? l10n.update : l10n.add),
        ),
      ],
    );
  }
}


