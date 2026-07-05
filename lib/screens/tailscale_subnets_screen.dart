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
import '../l10n/app_localizations.dart';
import '../models/tailscale_settings.dart';
import '../services/demo_api_service.dart';
import '../services/opnsense_api_service.dart';
import '../utils/app_colors.dart';
import '../utils/snackbar_helper.dart';
import '../viewmodels/tailscale_subnets_view_model.dart';
import '../widgets/common/confirmation_dialog.dart';

class TailscaleSubnetsScreen extends StatefulWidget {
  const TailscaleSubnetsScreen({super.key});

  @override
  State<TailscaleSubnetsScreen> createState() => _TailscaleSubnetsScreenState();
}

class _TailscaleSubnetsScreenState extends State<TailscaleSubnetsScreen> {
  late TailscaleSubnetsViewModel _viewModel;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final demoApiService = context.read<DemoApiService>();
      final opnsenseApiService =
          demoApiService.isDemoMode ? null : context.read<OPNsenseApiService>();
      _viewModel = TailscaleSubnetsViewModel(demoApiService, opnsenseApiService);
      _isInitialized = true;
      _viewModel.loadItems();
    }
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _addSubnet() async {
    final result = await showDialog<TailscaleSubnet>(
      context: context,
      builder: (context) => const _SubnetDialog(),
    );

    if (result != null && mounted) {
      try {
        final response = await _viewModel.addSubnet(result);
        if (response['result'] == 'saved') {
          await _viewModel.loadItems();
          if (mounted) {
            final l10n = AppLocalizations.of(context)!;
            SnackBarHelper.showSuccess(context, l10n.subnetAddedSuccessfully);
          }
        } else {
          throw Exception('Failed to add subnet: ${response['result']}');
        }
      } catch (e) {
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          SnackBarHelper.showError(context, l10n.errorAddingSubnet(e.toString()));
        }
      }
    }
  }

  Future<void> _editSubnet(String uuid, TailscaleSubnet subnet) async {
    final result = await showDialog<TailscaleSubnet>(
      context: context,
      builder: (context) => _SubnetDialog(subnet: subnet),
    );

    if (result != null && mounted) {
      try {
        final response = await _viewModel.updateSubnet(uuid, result);
        if (response['result'] == 'saved') {
          await _viewModel.loadItems();
          if (mounted) {
            final l10n = AppLocalizations.of(context)!;
            SnackBarHelper.showSuccess(context, l10n.subnetUpdatedSuccessfully);
          }
        } else {
          throw Exception('Failed to update subnet: ${response['result']}');
        }
      } catch (e) {
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          SnackBarHelper.showError(
              context, l10n.errorUpdatingSubnet(e.toString()));
        }
      }
    }
  }

  Future<void> _deleteSubnet(String uuid, String subnet) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await ConfirmationDialog.show(
      context: context,
      title: l10n.deleteSubnet,
      message: l10n.deleteSubnetConfirmation(subnet),
      confirmText: l10n.delete,
      cancelText: l10n.cancel,
      isDestructive: true,
    );

    if (confirmed == true && mounted) {
      try {
        final response = await _viewModel.deleteSubnet(uuid);
        if (response['result'] == 'saved' || response['result'] == 'deleted') {
          await _viewModel.loadItems();
          if (mounted) {
            final l10n = AppLocalizations.of(context)!;
            SnackBarHelper.showSuccess(context, l10n.subnetDeletedSuccessfully);
          }
        } else {
          throw Exception('Failed to delete subnet: ${response['result']}');
        }
      } catch (e) {
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          SnackBarHelper.showError(
              context, l10n.errorDeletingSubnet(e.toString()));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        final subnets = _viewModel.items;

        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.tailscaleSubnets),
          ),
          body: _viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : _viewModel.errorMessage != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('${l10n.error}: ${_viewModel.errorMessage}'),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _viewModel.loadItems,
                            child: Text(l10n.retry),
                          ),
                        ],
                      ),
                    )
                  : subnets.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(l10n.noSubnetsConfigured),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: _addSubnet,
                                icon: const Icon(Icons.add),
                                label: Text(l10n.addSubnet),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: subnets.length,
                          itemBuilder: (context, index) {
                            final entry = subnets[index];
                            final uuid = entry.key;
                            final subnet = entry.value;

                            return Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: ListTile(
                                title: Text(subnet.subnet ?? ''),
                                subtitle: subnet.description != null &&
                                        subnet.description!.isNotEmpty
                                    ? Text(subnet.description!)
                                    : null,
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () =>
                                          _editSubnet(uuid, subnet),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      color: AppColors.error,
                                      onPressed: () => _deleteSubnet(
                                          uuid, subnet.subnet ?? ''),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
          floatingActionButton: subnets.isNotEmpty
              ? FloatingActionButton(
                  onPressed: _addSubnet,
                  child: const Icon(Icons.add),
                )
              : null,
        );
      },
    );
  }
}

class _SubnetDialog extends StatefulWidget {
  final TailscaleSubnet? subnet;

  const _SubnetDialog({this.subnet});

  @override
  State<_SubnetDialog> createState() => _SubnetDialogState();
}

class _SubnetDialogState extends State<_SubnetDialog> {
  late final TextEditingController _subnetController;
  late final TextEditingController _descriptionController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _subnetController =
        TextEditingController(text: widget.subnet?.subnet ?? '');
    _descriptionController =
        TextEditingController(text: widget.subnet?.description ?? '');
  }

  @override
  void dispose() {
    _subnetController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(widget.subnet == null ? l10n.addSubnet : l10n.editSubnet),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _subnetController,
              decoration: InputDecoration(
                labelText: l10n.subnetCidr,
                hintText: '192.168.1.0/24',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.pleaseEnterSubnet;
                }
                final cidrRegex = RegExp(
                  r'^(\d{1,3}\.){3}\d{1,3}/\d{1,2}$',
                );
                if (!cidrRegex.hasMatch(value)) {
                  return l10n.invalidCidrNotation;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: l10n.descriptionOptional,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.pop(
                context,
                TailscaleSubnet(
                  uuid: widget.subnet?.uuid ?? '',
                  subnet: _subnetController.text,
                  description: _descriptionController.text.isEmpty
                      ? null
                      : _descriptionController.text,
                ),
              );
            }
          },
          child: Text(widget.subnet == null ? l10n.add : l10n.save),
        ),
      ],
    );
  }
}
