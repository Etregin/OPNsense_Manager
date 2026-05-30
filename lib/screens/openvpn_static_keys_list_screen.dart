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
import 'package:provider/provider.dart';
import '../models/openvpn_static_key.dart';
import '../services/opnsense_api_service.dart';
import '../widgets/openvpn/openvpn_static_key_card.dart';
import '../screens/openvpn_static_key_form_screen.dart';
import '../l10n/app_localizations.dart';

/// Screen for displaying OpenVPN static keys list with pagination
class OpenvpnStaticKeysListScreen extends StatefulWidget {
  final OPNsenseApiService apiService;
  final VoidCallback? onRefresh;
  final void Function(VoidCallback)? onRegisterRefresh;

  const OpenvpnStaticKeysListScreen({
    super.key,
    required this.apiService,
    this.onRefresh,
    this.onRegisterRefresh,
  });

  @override
  State<OpenvpnStaticKeysListScreen> createState() => _OpenvpnStaticKeysListScreenState();
}

class _OpenvpnStaticKeysListScreenState extends State<OpenvpnStaticKeysListScreen> {
  List<OpenvpnStaticKey> _staticKeys = [];
  bool _isLoading = false;
  String? _errorMessage;
  int _currentPage = 1;
  int _rowCount = 50;
  int _totalCount = 0;

  @override
  void initState() {
    super.initState();
    // Register the refresh callback with parent
    widget.onRegisterRefresh?.call(_loadStaticKeys);
    // Load static keys after the first frame to ensure context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadStaticKeys();
      }
    });
  }

  Future<void> _loadStaticKeys() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final apiService = context.read<OPNsenseApiService>();
      final response = await apiService.searchOpenvpnStaticKeys(
        current: _currentPage,
        rowCount: _rowCount == -1 ? 9999 : _rowCount,
      );

      if (mounted) {
        setState(() {
          _staticKeys = response.rows;
          _totalCount = response.total;
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

  Future<void> _deleteStaticKey(OpenvpnStaticKey key) async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteStaticKey),
        content: Text(
          l10n.confirmDeleteStaticKey(key.description.isNotEmpty ? key.description : key.keyid ?? "N/A"),
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

    if (confirmed == true && mounted && key.keyid != null) {
      try {
        final apiService = context.read<OPNsenseApiService>();
        await apiService.deleteOpenvpnStaticKey(key.keyid!);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.staticKeyDeletedSuccessfully),
              backgroundColor: Colors.green,
            ),
          );
          await _loadStaticKeys();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.failedToDeleteStaticKey(e.toString())),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _showStaticKeyDetails(OpenvpnStaticKey key) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(key.description.isNotEmpty ? key.description : l10n.staticKeyDetails),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (key.keyid != null)
                _buildDetailRow(l10n.id, key.keyid!),
              _buildDetailRow(l10n.mode, key.modeDescription),
              _buildDetailRow(l10n.valid, key.isValid ? l10n.yes : l10n.no),
              if (key.createdAt != null)
                _buildDetailRow(l10n.created, key.createdAt!.toString()),
              if (key.modifiedAt != null)
                _buildDetailRow(l10n.modified, key.modifiedAt!.toString()),
              const Divider(),
              Text(
                '${l10n.key}:',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SelectableText(
                  key.key,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 11,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () {
                  final l10n = AppLocalizations.of(context)!;
                  Clipboard.setData(ClipboardData(text: key.key));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.keyCopiedToClipboard),
                      duration: const Duration(seconds: 2),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                icon: const Icon(Icons.copy),
                label: Text(l10n.copyKey),
              ),
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

  Future<void> _onEditStaticKey(OpenvpnStaticKey key) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => OpenvpnStaticKeyFormScreen(keyid: key.keyid),
      ),
    );

    // Reload the list if the form returned true (indicating a successful save)
    if (result == true && mounted) {
      await _loadStaticKeys();
      widget.onRefresh?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        // Pagination controls
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
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
                      _currentPage = 1;
                    });
                    _loadStaticKeys();
                  }
                },
              ),
              const Spacer(),
              Text('${_staticKeys.length} / $_totalCount'),
            ],
          ),
        ),
        // Static keys list
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
                            onPressed: _loadStaticKeys,
                            icon: const Icon(Icons.refresh),
                            label: Text(l10n.retry),
                          ),
                        ],
                      ),
                    )
                  : _staticKeys.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.vpn_key,
                                size: 48,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                l10n.noStaticKeysConfigured,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                l10n.tapPlusButtonToCreateFirstStaticKey,
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: () async {
                            await _loadStaticKeys();
                            widget.onRefresh?.call();
                          },
                          child: ListView.builder(
                            itemCount: _staticKeys.length,
                            itemBuilder: (context, index) {
                              final key = _staticKeys[index];
                              return OpenvpnStaticKeyCard(
                                staticKey: key,
                                onTap: () => _showStaticKeyDetails(key),
                                onEdit: () => _onEditStaticKey(key),
                                onDelete: () => _deleteStaticKey(key),
                              );
                            },
                          ),
                        ),
        ),
      ],
    );
  }
}


