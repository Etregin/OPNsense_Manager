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
import 'package:flutter/services.dart';
import '../../l10n/app_localizations.dart';
import '../../models/connection_endpoint.dart';
import '../../utils/constants.dart';
import '../../utils/validators.dart';
import '../../utils/snackbar_helper.dart';

/// Widget for managing multiple connection endpoints in a profile
/// 
/// Allows users to add, edit, delete, and set active connection endpoints.
/// Ensures at least one connection exists at all times.
class ConnectionEndpointsManager extends StatefulWidget {
  /// Current list of connection endpoints
  final List<ConnectionEndpoint> connections;
  
  /// Callback when connections list changes
  final ValueChanged<List<ConnectionEndpoint>> onConnectionsChanged;
  
  /// Whether the widget is enabled for editing
  final bool enabled;

  const ConnectionEndpointsManager({
    super.key,
    required this.connections,
    required this.onConnectionsChanged,
    this.enabled = true,
  });

  @override
  State<ConnectionEndpointsManager> createState() => _ConnectionEndpointsManagerState();
}

class _ConnectionEndpointsManagerState extends State<ConnectionEndpointsManager> {
  /// Show the add/edit connection dialog
  Future<void> _showConnectionDialog({ConnectionEndpoint? connection, int? index}) async {
    final isEditing = connection != null;
    
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => _ConnectionDialog(
        endpoint: connection,
        enabled: widget.enabled,
      ),
    );

    if (result != null) {
      final updatedConnections = List<ConnectionEndpoint>.from(widget.connections);
      
      if (isEditing && index != null) {
        // Update existing connection
        updatedConnections[index] = connection.copyWith(
          host: result['host'],
          port: result['port'],
          label: result['label'],
        );
      } else {
        // Add new connection
        updatedConnections.add(ConnectionEndpoint(
          host: result['host'],
          port: result['port'],
          label: result['label'],
          isActive: updatedConnections.isEmpty, // First connection is active by default
        ));
      }
      
      widget.onConnectionsChanged(updatedConnections);
    }
  }

  /// Show delete confirmation dialog
  Future<void> _showDeleteConfirmation(int index) async {
    final l10n = AppLocalizations.of(context)!;
    
    if (widget.connections.length <= 1) {
      // Show error - cannot delete last connection
      SnackBarHelper.showError(context, l10n.cannotDeleteLastConnection);
      return;
    }

    final connection = widget.connections[index];
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteConnection),
        content: Text(
          l10n.deleteConnectionConfirmation(connection.displayName),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final updatedConnections = List<ConnectionEndpoint>.from(widget.connections);
      final wasActive = updatedConnections[index].isActive;
      updatedConnections.removeAt(index);
      
      // If we deleted the active connection, make the first one active
      if (wasActive && updatedConnections.isNotEmpty) {
        updatedConnections[0] = updatedConnections[0].copyWith(isActive: true);
      }
      
      widget.onConnectionsChanged(updatedConnections);
    }
  }

  /// Set a connection as active
  void _setActiveConnection(int index) {
    final updatedConnections = widget.connections.asMap().entries.map((entry) {
      return entry.value.copyWith(isActive: entry.key == index);
    }).toList();
    
    widget.onConnectionsChanged(updatedConnections);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Icon(Icons.computer, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.connectionEndpoints,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filledTonal(
                onPressed: widget.enabled ? () => _showConnectionDialog() : null,
                icon: const Icon(Icons.add),
                tooltip: l10n.addConnection,
              ),
            ],
          ),
        ),
        
        // Connections list
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.connections.length,
          itemBuilder: (context, index) {
            final connection = widget.connections[index];
            final isOnlyConnection = widget.connections.length == 1;
            
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Leading icon with fixed size
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: connection.isActive
                            ? theme.colorScheme.primaryContainer
                            : theme.colorScheme.surfaceContainerHighest,
                        child: Icon(
                          connection.isActive ? Icons.check_circle : Icons.computer,
                          color: connection.isActive
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      
                      // Connection info with flexible width
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Title with ellipsis
                            Text(
                              connection.label ?? '${connection.host}:${connection.port}',
                              style: TextStyle(
                                fontWeight: connection.isActive ? FontWeight.bold : FontWeight.normal,
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            // Subtitle with ellipsis (only if label exists)
                            if (connection.label != null) ...[
                              const SizedBox(height: 2),
                              Text(
                                '${connection.host}:${connection.port}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          ],
                        ),
                      ),
                      
                      const SizedBox(width: 8),
                      
                      // Action buttons with constrained width
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 144),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Set as active button (or spacer to maintain consistent width)
                            if (!connection.isActive)
                              IconButton(
                                icon: const Icon(Icons.radio_button_unchecked, size: 20),
                                tooltip: l10n.setAsActive,
                                onPressed: widget.enabled ? () => _setActiveConnection(index) : null,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                              )
                            else
                              const SizedBox(width: 40),
                            
                            // Edit button
                            IconButton(
                              icon: const Icon(Icons.edit, size: 20),
                              tooltip: l10n.edit,
                              onPressed: widget.enabled
                                  ? () => _showConnectionDialog(connection: connection, index: index)
                                  : null,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                            ),
                            
                            // Delete button
                            IconButton(
                              icon: const Icon(Icons.delete, size: 20),
                              tooltip: isOnlyConnection ? l10n.cannotDeleteLastConnection : l10n.delete,
                              onPressed: widget.enabled && !isOnlyConnection
                                  ? () => _showDeleteConfirmation(index)
                                  : null,
                              color: isOnlyConnection ? theme.disabledColor : AppColors.error,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        
        // Help text
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            l10n.connectionEndpointsHelp,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}


/// Private StatefulWidget for the connection dialog
/// 
/// Manages TextEditingController lifecycle properly to avoid disposal issues
class _ConnectionDialog extends StatefulWidget {
  final ConnectionEndpoint? endpoint;
  final bool enabled;
  
  const _ConnectionDialog({
    this.endpoint,
    required this.enabled,
  });
  
  @override
  State<_ConnectionDialog> createState() => _ConnectionDialogState();
}

class _ConnectionDialogState extends State<_ConnectionDialog> {
  late final TextEditingController _hostController;
  late final TextEditingController _portController;
  late final TextEditingController _labelController;
  final _formKey = GlobalKey<FormState>();
  
  @override
  void initState() {
    super.initState();
    _hostController = TextEditingController(text: widget.endpoint?.host ?? '');
    _portController = TextEditingController(text: widget.endpoint?.port.toString() ?? '443');
    _labelController = TextEditingController(text: widget.endpoint?.label ?? '');
  }
  
  @override
  void dispose() {
    _hostController.dispose();
    _portController.dispose();
    _labelController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final isEditing = widget.endpoint != null;
    final l10n = AppLocalizations.of(context)!;
    
    return AlertDialog(
      title: Text(isEditing ? l10n.editConnection : l10n.addConnection),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Host field
              TextFormField(
                controller: _hostController,
                decoration: InputDecoration(
                  labelText: l10n.host,
                  hintText: l10n.hostHint,
                  prefixIcon: const Icon(Icons.dns),
                ),
                keyboardType: TextInputType.url,
                validator: (value) => Validators.combine([
                  (v) => Validators.required(v, fieldName: 'Host'),
                ], value),
                enabled: widget.enabled,
              ),
              const SizedBox(height: 16),
              
              // Port field
              TextFormField(
                controller: _portController,
                decoration: InputDecoration(
                  labelText: l10n.port,
                  hintText: l10n.portHint,
                  prefixIcon: const Icon(Icons.settings_ethernet),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) => Validators.combine([
                  (v) => Validators.required(v, fieldName: 'Port'),
                  Validators.port,
                ], value),
                enabled: widget.enabled,
              ),
              const SizedBox(height: 16),
              
              // Label field (optional)
              TextFormField(
                controller: _labelController,
                decoration: InputDecoration(
                  labelText: l10n.labelOptional,
                  hintText: l10n.labelHint,
                  prefixIcon: const Icon(Icons.label),
                ),
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    return Validators.maxLength(value, 50, fieldName: 'Label');
                  }
                  return null;
                },
                enabled: widget.enabled,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.of(context).pop({
                'host': _hostController.text.trim(),
                'port': int.parse(_portController.text.trim()),
                'label': _labelController.text.trim().isEmpty
                    ? null
                    : _labelController.text.trim(),
              });
            }
          },
          child: Text(isEditing ? l10n.save : l10n.add),
        ),
      ],
    );
  }
}
