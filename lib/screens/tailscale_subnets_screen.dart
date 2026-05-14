import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/tailscale_settings.dart';
import '../services/demo_api_service.dart';
import '../services/opnsense_api_service.dart';

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
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Subnet added successfully'),
                backgroundColor: Colors.green,
              ),
            );
          }
        } else {
          throw Exception('Failed to add subnet: ${response['result']}');
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error adding subnet: $e'),
              backgroundColor: Colors.red,
            ),
          );
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
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Subnet updated successfully'),
                backgroundColor: Colors.green,
              ),
            );
          }
        } else {
          throw Exception('Failed to update subnet: ${response['result']}');
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error updating subnet: $e'),
              backgroundColor: Colors.red,
            ),
          );
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
      builder: (context) => AlertDialog(
        title: const Text('Delete Subnet'),
        content: Text('Are you sure you want to delete subnet $subnet?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {

        final response = isDemoMode
            ? await demoApiService.deleteTailscaleSubnet(uuid)
            : await opnsenseApiService!.deleteTailscaleSubnet(uuid);

        if (response['result'] == 'saved' || response['result'] == 'deleted') {
          await _loadSubnets();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Subnet deleted successfully'),
                backgroundColor: Colors.green,
              ),
            );
          }
        } else {
          throw Exception('Failed to delete subnet: ${response['result']}');
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error deleting subnet: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tailscale Subnets'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Error: $_error'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadSubnets,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _subnets.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('No subnets configured'),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: _addSubnet,
                            icon: const Icon(Icons.add),
                            label: const Text('Add Subnet'),
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
    return AlertDialog(
      title: Text(widget.subnet == null ? 'Add Subnet' : 'Edit Subnet'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _subnetController,
              decoration: const InputDecoration(
                labelText: 'Subnet (CIDR)',
                hintText: '192.168.1.0/24',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a subnet';
                }
                // Basic CIDR validation
                final cidrRegex = RegExp(
                  r'^(\d{1,3}\.){3}\d{1,3}/\d{1,2}$',
                );
                if (!cidrRegex.hasMatch(value)) {
                  return 'Invalid CIDR format';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
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
          child: Text(widget.subnet == null ? 'Add' : 'Save'),
        ),
      ],
    );
  }
}


