import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../models/tailscale_settings.dart';
import '../services/demo_api_service.dart';
import '../services/opnsense_api_service.dart';
import '../utils/snackbar_helper.dart';

class TailscaleSubnetsScreen extends StatefulWidget {
  const TailscaleSubnetsScreen({super.key});

  @override
  State<TailscaleSubnetsScreen> createState() => _TailscaleSubnetsScreenState();
}

class _TailscaleSubnetsScreenState extends State<TailscaleSubnetsScreen> {
  List<MapEntry<String, TailscaleSubnet>> _subnets = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadSubnets();
  }

  Future<void> _loadSubnets() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final demoApiService = context.read<DemoApiService>();
      final bool isDemoMode = demoApiService.isDemoMode;
      final opnsenseApiService = isDemoMode ? null : context.read<OPNsenseApiService>();

      final response = isDemoMode
          ? await demoApiService.getTailscaleSettings()
          : await opnsenseApiService!.getTailscaleSettings();

      setState(() {
        _subnets = response.settings.subnets?.entries.toList() ?? [];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _addSubnet() async {
    // Get services before async gap
    final demoApiService = context.read<DemoApiService>();
    final bool isDemoMode = demoApiService.isDemoMode;
    final opnsenseApiService = isDemoMode ? null : context.read<OPNsenseApiService>();

    final result = await showDialog<TailscaleSubnet>(
      context: context,
      builder: (context) => const _SubnetDialog(),
    );

    if (result != null) {
      try {

        final response = isDemoMode
            ? await demoApiService.addTailscaleSubnet(result)
            : await opnsenseApiService!.addTailscaleSubnet(result);

        if (response['result'] == 'saved') {
          await _loadSubnets();
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
    // Get services before async gap
    final demoApiService = context.read<DemoApiService>();
    final bool isDemoMode = demoApiService.isDemoMode;
    final opnsenseApiService = isDemoMode ? null : context.read<OPNsenseApiService>();

    final result = await showDialog<TailscaleSubnet>(
      context: context,
      builder: (context) => _SubnetDialog(subnet: subnet),
    );

    if (result != null) {
      try {

        final response = isDemoMode
            ? await demoApiService.setTailscaleSubnet(uuid, result)
            : await opnsenseApiService!.setTailscaleSubnet(uuid, result);

        if (response['result'] == 'saved') {
          await _loadSubnets();
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
          SnackBarHelper.showError(context, l10n.errorUpdatingSubnet(e.toString()));
        }
      }
    }
  }

  Future<void> _deleteSubnet(String uuid, String subnet) async {
    // Get services before async gap
    final demoApiService = context.read<DemoApiService>();
    final bool isDemoMode = demoApiService.isDemoMode;
    final opnsenseApiService = isDemoMode ? null : context.read<OPNsenseApiService>();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(l10n.deleteSubnet),
          content: Text(l10n.deleteSubnetConfirmation(subnet)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text(l10n.delete),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      try {

        final response = isDemoMode
            ? await demoApiService.deleteTailscaleSubnet(uuid)
            : await opnsenseApiService!.deleteTailscaleSubnet(uuid);

        if (response['result'] == 'saved' || response['result'] == 'deleted') {
          await _loadSubnets();
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
          SnackBarHelper.showError(context, l10n.errorDeletingSubnet(e.toString()));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tailscaleSubnets),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${l10n.error}: $_error'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadSubnets,
                        child: Text(l10n.retry),
                      ),
                    ],
                  ),
                )
              : _subnets.isEmpty
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
                      itemCount: _subnets.length,
                      itemBuilder: (context, index) {
                        final entry = _subnets[index];
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
                                  onPressed: () => _editSubnet(uuid, subnet),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  color: Colors.red,
                                  onPressed: () =>
                                      _deleteSubnet(uuid, subnet.subnet ?? ''),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
      floatingActionButton: _subnets.isNotEmpty
          ? FloatingActionButton(
              onPressed: _addSubnet,
              child: const Icon(Icons.add),
            )
          : null,
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
    _subnetController = TextEditingController(text: widget.subnet?.subnet ?? '');
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
                // Basic CIDR validation
                final cidrRegex = RegExp(
                  r'^(\d{1,3}\.){3}\d{1,3}/\d{1,2}$',
                );
                if (!cidrRegex.hasMatch(value)) {
                  return l10n.invalidCidrFormat;
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


