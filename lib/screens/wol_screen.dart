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
import '../models/wol_host.dart';
import '../services/demo_api_service.dart';
import '../utils/validators.dart';
import '../utils/constants.dart';
import '../widgets/app_drawer.dart';
import '../widgets/common/error_display.dart';
import '../widgets/common/confirmation_dialog.dart';

/// Wake-on-LAN screen for managing and waking network hosts
class WolScreen extends StatefulWidget {
  const WolScreen({super.key});

  @override
  State<WolScreen> createState() => _WolScreenState();
}

class _WolScreenState extends State<WolScreen> {
  List<WolHost> _hosts = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadHosts();
  }

  Future<void> _loadHosts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final demoApiService = context.read<DemoApiService>();
      final hosts = await demoApiService.getWolHosts();
      if (mounted) {
        setState(() {
          _hosts = hosts;
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

  Future<void> _wakeHost(WolHost host) async {
    try {
      final demoApiService = context.read<DemoApiService>();
      await demoApiService.wakeHost(host.uuid);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Wake-on-LAN packet sent to ${host.descr.isNotEmpty ? host.descr : host.mac}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to wake host: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _wakeAllHosts() async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: 'Wake All Devices',
        message: 'Are you sure you want to wake all configured devices?',
        confirmText: 'Wake All',
        cancelText: 'Cancel',
      ),
    );

    if (confirmed != true) return;

    // Show loading indicator
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Waking all devices...'),
              ],
            ),
          ),
        ),
      ),
    );

    // Store context references before async operations
    final demoApiService = context.read<DemoApiService>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    try {
      final results = await demoApiService.wakeAllHosts();
      
      if (!mounted) return;
      navigator.pop(); // Close loading dialog

      // Count successful wakes
      final successCount = results.where((r) => r.isSuccess).length;
      final failedResults = results.where((r) => !r.isSuccess).toList();

      // Show results dialog
      showDialog(
        context: navigator.context,
        builder: (context) => AlertDialog(
          title: const Text('Wake All Results'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Successfully woken $successCount of ${results.length} device${results.length != 1 ? 's' : ''}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              if (failedResults.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text(
                  'Failed devices:',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
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
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      navigator.pop(); // Close loading dialog
      
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Failed to wake all hosts: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _deleteHost(WolHost host) async {
    // Store context references before async operations
    final demoApiService = context.read<DemoApiService>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: 'Delete Host',
        message: 'Are you sure you want to delete ${host.descr.isNotEmpty ? host.descr : host.mac}?',
        confirmText: 'Delete',
        cancelText: 'Cancel',
        isDestructive: true,
      ),
    );

    if (confirmed == true) {
      try {
        await demoApiService.deleteWolHost(host.uuid);
        if (mounted) {
          scaffoldMessenger.showSnackBar(
            const SnackBar(
              content: Text('Host deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
          await _loadHosts();
        }
      } catch (e) {
        if (mounted) {
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text('Failed to delete host: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _showAddHostDialog() {
    showDialog(
      context: context,
      builder: (context) => _AddHostDialog(
        onHostAdded: _loadHosts,
      ),
    );
  }

  void _showEditHostDialog(WolHost host) {
    showDialog(
      context: context,
      builder: (context) => _AddHostDialog(
        onHostAdded: _loadHosts,
        existingHost: host,
      ),
    );
  }

  Future<void> _copyHost(WolHost host) async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Loading host data...'),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      final demoApiService = context.read<DemoApiService>();
      final hostData = await demoApiService.copyWolHost(host.uuid);
      
      if (!mounted) return;
      Navigator.of(context).pop(); // Close loading dialog

      // Show the add dialog with copied data
      showDialog(
        context: context,
        builder: (context) => _AddHostDialog(
          onHostAdded: _loadHosts,
          copiedHostData: hostData,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop(); // Close loading dialog
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to copy host: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wake-on-LAN'),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on),
            onPressed: (_isLoading || _hosts.isEmpty) ? null : _wakeAllHosts,
            tooltip: 'Wake All',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _loadHosts,
            tooltip: 'Refresh',
          ),
        ],
      ),
      drawer: const AppDrawer(currentRoute: 'wol'),
      body: _buildBody(theme),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddHostDialog,
        tooltip: 'Add Host',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(ThemeData theme) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return ErrorDisplay(
        message: _errorMessage!,
        onRetry: _loadHosts,
      );
    }

    if (_hosts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.devices_other,
              size: 64,
              color: theme.colorScheme.primary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No WOL hosts configured',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Add a host to get started',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.standardPadding),
      itemCount: _hosts.length,
      itemBuilder: (context, index) {
        final host = _hosts[index];
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
                        host.descr.isNotEmpty ? host.descr : 'Unnamed Host',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        host.mac,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontFamily: 'monospace',
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
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
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 20),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'copy',
                      child: Row(
                        children: [
                          Icon(Icons.content_copy, size: 20),
                          SizedBox(width: 8),
                          Text('Copy'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 20, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete', style: TextStyle(color: Colors.red)),
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
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                const SizedBox(width: 8),
                Text(
                  'Interface: ${host.interfaceDisplay}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
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
                label: const Text('Wake Host'),
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load interfaces: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _saveHost() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedInterface == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an interface'),
          backgroundColor: Colors.red,
        ),
      );
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.existingHost != null ? 'Host updated successfully' : 'Host added successfully'),
            backgroundColor: Colors.green,
          ),
        );
        widget.onHostAdded();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save host: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final String dialogTitle;
    if (widget.existingHost != null) {
      dialogTitle = 'Edit Host';
    } else if (widget.copiedHostData != null) {
      dialogTitle = 'Copy Host';
    } else {
      dialogTitle = 'Add Host';
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
                      decoration: const InputDecoration(
                        labelText: 'Interface',
                        border: OutlineInputBorder(),
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
                          return 'Please select an interface';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _macController,
                      decoration: const InputDecoration(
                        labelText: 'MAC Address',
                        hintText: 'AA:BB:CC:DD:EE:FF',
                        border: OutlineInputBorder(),
                      ),
                      validator: Validators.validateMacAddress,
                      textCapitalization: TextCapitalization.characters,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        hintText: 'e.g., Living Room PC',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Description is required';
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
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isSaving ? null : _saveHost,
          child: _isSaving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(widget.existingHost != null ? 'Update' : 'Add'),
        ),
      ],
    );
  }
}


