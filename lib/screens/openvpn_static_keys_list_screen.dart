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
import '../models/openvpn_static_key.dart';
import '../utils/constants.dart';
import '../services/demo_api_service.dart';
import '../utils/snackbar_helper.dart';
import '../viewmodels/openvpn_static_keys_view_model.dart';
import '../widgets/openvpn/openvpn_static_key_card.dart';
import '../screens/openvpn_static_key_form_screen.dart';
import '../widgets/common/error_display.dart';
import '../widgets/common/empty_state_widget.dart';
import '../l10n/app_localizations.dart';
import '../widgets/common/confirmation_dialog.dart';


/// Screen for displaying OpenVPN static keys list with pagination
class OpenvpnStaticKeysListScreen extends StatefulWidget {
  final DemoApiService apiService;
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
  late OpenvpnStaticKeysViewModel _viewModel;
  int _currentPage = 1;
  int _rowCount = 50;
  int _totalCount = 0;

  @override
  void initState() {
    super.initState();
    _viewModel = OpenvpnStaticKeysViewModel(
      widget.apiService,
      currentPage: _currentPage,
      rowCount: _rowCount,
    );
    // Register the refresh callback with parent
    widget.onRegisterRefresh?.call(_loadStaticKeys);
    // Load static keys after the first frame to ensure context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadStaticKeys();
      }
    });
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _loadStaticKeys() async {
    _viewModel.currentPage = _currentPage;
    _viewModel.rowCount = _rowCount;
    await _viewModel.loadItems();
    if (mounted) {
      setState(() {
        _totalCount = _viewModel.items.length;
      });
    }
  }

  Future<void> _deleteStaticKey(OpenvpnStaticKey key) async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await ConfirmationDialog.show(
      context: context,
      title: l10n.deleteStaticKey,
      message: l10n.confirmDeleteStaticKey(
          key.description.isNotEmpty ? key.description : key.keyid ?? 'N/A'),
      confirmText: l10n.delete,
      cancelText: l10n.cancel,
      isDestructive: true,
    );

    if (confirmed == true && mounted && key.keyid != null) {
      try {
        await _viewModel.deleteStaticKey(key.keyid!);
        if (mounted) {
          SnackBarHelper.showSuccess(context, l10n.staticKeyDeletedSuccessfully);
        }
      } catch (e) {
        if (mounted) {
          SnackBarHelper.showError(context, l10n.failedToDeleteStaticKey(e.toString()));
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
              if (key.keyid != null) _buildDetailRow(l10n.id, key.keyid!),
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
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SelectableText(
                  key.key,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () {
                  final l10n = AppLocalizations.of(context)!;
                  Clipboard.setData(ClipboardData(text: key.key));
                  SnackBarHelper.showSuccess(context, l10n.keyCopiedToClipboard);
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
          Expanded(child: Text(value)),
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

    if (result == true && mounted) {
      await _loadStaticKeys();
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
        final staticKeys = _viewModel.items;

        return Column(
          children: [
            // Pagination controls
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Text(l10n.rowsPerPageLabel),
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
                  Text('${staticKeys.length} / $_totalCount'),
                ],
              ),
            ),
            // Static keys list
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : errorMessage != null
                      ? ErrorDisplay(
                          message: errorMessage, onRetry: _loadStaticKeys)
                      : staticKeys.isEmpty
                          ? EmptyStateWidget(
                              icon: Icons.vpn_key,
                              title: l10n.noStaticKeysConfigured,
                              subtitle: l10n.tapPlusButtonToCreateFirstStaticKey,
                            )
                          : RefreshIndicator(
                              onRefresh: () async {
                                await _loadStaticKeys();
                                widget.onRefresh?.call();
                              },
                              child: ListView.builder(
                                itemCount: staticKeys.length,
                                itemBuilder: (context, index) {
                                  final key = staticKeys[index];
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
      },
    );
  }
}
