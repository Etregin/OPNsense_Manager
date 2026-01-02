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
import '../models/firewall_rule.dart';
import '../services/opnsense_api_service.dart';
import '../utils/constants.dart';
import '../utils/validators.dart';

/// Form screen for creating or editing firewall rules
class FirewallRuleFormScreen extends StatefulWidget {
  final FirewallRule? rule;

  const FirewallRuleFormScreen({super.key, this.rule});

  bool get isEditing => rule != null;

  @override
  State<FirewallRuleFormScreen> createState() => _FirewallRuleFormScreenState();
}

class _FirewallRuleFormScreenState extends State<FirewallRuleFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _sourceController = TextEditingController();
  final _sourcePortController = TextEditingController();
  final _destinationController = TextEditingController();
  final _destinationPortController = TextEditingController();

  String _selectedType = 'pass';
  String _selectedInterface = 'lan';
  String _selectedProtocol = 'any';
  bool _enabled = true;
  bool _isLoading = false;
  Map<String, String> _availableInterfaces = {};
  bool _loadingInterfaces = true;

  @override
  void initState() {
    super.initState();
    _loadInterfaces();
    if (widget.isEditing) {
      _loadRuleData();
    } else {
      _sourceController.text = 'any';
      _sourcePortController.text = 'any';
      _destinationController.text = 'any';
      _destinationPortController.text = 'any';
    }
  }

  Future<void> _loadInterfaces() async {
    try {
      final apiService = context.read<OPNsenseApiService>();
      final interfaces = await apiService.getAvailableInterfaces();
      
      if (mounted) {
        setState(() {
          _availableInterfaces = interfaces;
          _loadingInterfaces = false;
          // Set default interface to first available if current selection is not in the list
          if (!_availableInterfaces.containsKey(_selectedInterface) && _availableInterfaces.isNotEmpty) {
            _selectedInterface = _availableInterfaces.keys.first;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          // Fallback to default interfaces
          _availableInterfaces = {
            'lan': 'LAN',
            'wan': 'WAN',
            'opt1': 'OPT1',
            'opt2': 'OPT2',
          };
          _loadingInterfaces = false;
        });
      }
    }
  }

  void _loadRuleData() {
    final rule = widget.rule!;
    _descriptionController.text = rule.description;
    _sourceController.text = rule.source;
    _sourcePortController.text = 'any';
    _destinationController.text = rule.destination;
    _destinationPortController.text = rule.destinationPort;
    _selectedType = rule.type;
    _selectedInterface = rule.interfaceName;
    _selectedProtocol = rule.protocol;
    _enabled = rule.isEnabled;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _sourceController.dispose();
    _sourcePortController.dispose();
    _destinationController.dispose();
    _destinationPortController.dispose();
    super.dispose();
  }

  Future<void> _saveRule() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final apiService = context.read<OPNsenseApiService>();
      
      final request = FirewallRuleRequest(
        type: _selectedType,
        interfaceName: _selectedInterface,
        protocol: _selectedProtocol,
        source: _sourceController.text.trim(),
        destination: _destinationController.text.trim(),
        destinationPort: _destinationPortController.text.trim(),
        description: _descriptionController.text.trim(),
        enabled: _enabled ? '1' : '0',
        sourcePort: _sourcePortController.text.trim(),
      );

      if (widget.isEditing) {
        await apiService.updateFirewallRule(widget.rule!.uuid, request);
      } else {
        await apiService.createFirewallRule(request);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.isEditing ? 'Rule updated' : 'Rule created',
            ),
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving rule: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit Rule' : 'New Rule'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppConstants.standardPadding * 2),
          children: [
            // Description
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Enter rule description',
                prefixIcon: Icon(Icons.description),
              ),
              validator: (value) =>
                  Validators.validateRequired(value, 'Description'),
              enabled: !_isLoading,
            ),
            const SizedBox(height: 16),

            // Action Type
            DropdownButtonFormField<String>(
              initialValue: _selectedType,
              decoration: const InputDecoration(
                labelText: 'Action',
                prefixIcon: Icon(Icons.rule),
              ),
              items: const [
                DropdownMenuItem(value: 'pass', child: Text('Pass')),
                DropdownMenuItem(value: 'block', child: Text('Block')),
                DropdownMenuItem(value: 'reject', child: Text('Reject')),
              ],
              onChanged: _isLoading
                  ? null
                  : (value) {
                      if (value != null) {
                        setState(() {
                          _selectedType = value;
                        });
                      }
                    },
            ),
            const SizedBox(height: 16),

            // Interface
            DropdownButtonFormField<String>(
              initialValue: _availableInterfaces.containsKey(_selectedInterface) ? _selectedInterface : null,
              decoration: const InputDecoration(
                labelText: 'Interface',
                prefixIcon: Icon(Icons.network_check),
              ),
              items: _loadingInterfaces
                  ? [const DropdownMenuItem(value: 'loading', child: Text('Loading...'))]
                  : _availableInterfaces.entries.map((entry) {
                      return DropdownMenuItem(
                        value: entry.key,
                        child: Text(entry.value),
                      );
                    }).toList(),
              onChanged: _isLoading || _loadingInterfaces
                  ? null
                  : (value) {
                      if (value != null && value != 'loading') {
                        setState(() {
                          _selectedInterface = value;
                        });
                      }
                    },
            ),
            const SizedBox(height: 16),

            // Protocol
            DropdownButtonFormField<String>(
              initialValue: _selectedProtocol,
              decoration: const InputDecoration(
                labelText: 'Protocol',
                prefixIcon: Icon(Icons.settings_ethernet),
              ),
              items: const [
                DropdownMenuItem(value: 'any', child: Text('Any')),
                DropdownMenuItem(value: 'tcp', child: Text('TCP')),
                DropdownMenuItem(value: 'udp', child: Text('UDP')),
                DropdownMenuItem(value: 'tcp/udp', child: Text('TCP/UDP')),
                DropdownMenuItem(value: 'icmp', child: Text('ICMP')),
                DropdownMenuItem(value: 'icmpv6', child: Text('ICMPv6')),
                DropdownMenuItem(value: 'esp', child: Text('ESP')),
                DropdownMenuItem(value: 'ah', child: Text('AH')),
                DropdownMenuItem(value: 'gre', child: Text('GRE')),
                DropdownMenuItem(value: 'ipv6', child: Text('IPv6')),
                DropdownMenuItem(value: 'igmp', child: Text('IGMP')),
                DropdownMenuItem(value: 'pim', child: Text('PIM')),
                DropdownMenuItem(value: 'ospf', child: Text('OSPF')),
              ],
              onChanged: _isLoading
                  ? null
                  : (value) {
                      if (value != null) {
                        setState(() {
                          _selectedProtocol = value;
                        });
                      }
                    },
            ),
            const SizedBox(height: 16),

            // Source
            TextFormField(
              controller: _sourceController,
              decoration: const InputDecoration(
                labelText: 'Source',
                hintText: 'any, IP address, CIDR, or alias',
                prefixIcon: Icon(Icons.arrow_forward),
                helperText: 'Examples: any, 192.168.1.0/24, 10.0.0.1',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Source is required';
                }
                if (!Validators.isValidSourceDestination(value)) {
                  return 'Invalid source format';
                }
                return null;
              },
              enabled: !_isLoading,
            ),
            const SizedBox(height: 16),

            // Source Port (only for TCP/UDP/TCP/UDP)
            if (_selectedProtocol.toLowerCase() == 'tcp' ||
                _selectedProtocol.toLowerCase() == 'udp' ||
                _selectedProtocol.toLowerCase() == 'tcp/udp') ...[
              TextFormField(
                controller: _sourcePortController,
                decoration: const InputDecoration(
                  labelText: 'Source Port (Optional)',
                  hintText: 'any, port number, range, or alias',
                  prefixIcon: Icon(Icons.input),
                  helperText: 'Examples: any, 80, 1024-65535',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return null; // Optional field
                  }
                  if (!Validators.isValidDestinationPort(value)) {
                    return 'Invalid port format';
                  }
                  return null;
                },
                enabled: !_isLoading,
              ),
              const SizedBox(height: 16),
            ],

            // Destination
            TextFormField(
              controller: _destinationController,
              decoration: const InputDecoration(
                labelText: 'Destination',
                hintText: 'any, IP address, CIDR, or alias',
                prefixIcon: Icon(Icons.location_on),
                helperText: 'Examples: any, 192.168.1.0/24, 10.0.0.1',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Destination is required';
                }
                if (!Validators.isValidSourceDestination(value)) {
                  return 'Invalid destination format';
                }
                return null;
              },
              enabled: !_isLoading,
            ),
            const SizedBox(height: 16),

            // Destination Port (only for TCP/UDP/TCP/UDP)
            if (_selectedProtocol.toLowerCase() == 'tcp' ||
                _selectedProtocol.toLowerCase() == 'udp' ||
                _selectedProtocol.toLowerCase() == 'tcp/udp') ...[
              TextFormField(
                controller: _destinationPortController,
                decoration: const InputDecoration(
                  labelText: 'Destination Port (Optional)',
                  hintText: 'any, port number, range, or alias',
                  prefixIcon: Icon(Icons.settings_input_component),
                  helperText: 'Examples: any, 80, 80-443, http',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return null; // Optional field
                  }
                  if (!Validators.isValidDestinationPort(value)) {
                    return 'Invalid port format';
                  }
                  return null;
                },
                enabled: !_isLoading,
              ),
              const SizedBox(height: 16),
            ],

            // Enabled Switch
            SwitchListTile(
              title: const Text('Enabled'),
              subtitle: const Text('Rule will be active when enabled'),
              value: _enabled,
              onChanged: _isLoading
                  ? null
                  : (value) {
                      setState(() {
                        _enabled = value;
                      });
                    },
            ),
            const SizedBox(height: 32),

            // Help Card
            Card(
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue[700]),
                        const SizedBox(width: 8),
                        Text(
                          'Rule Guidelines',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '• Use "any" to match all addresses or ports\n'
                      '• CIDR notation: 192.168.1.0/24\n'
                      '• Port ranges: 80-443\n'
                      '• Rules are processed in sequence order\n'
                      '• Changes are applied immediately',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue[900],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Save Button
            ElevatedButton(
              onPressed: _isLoading ? null : _saveRule,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      widget.isEditing ? 'Update Rule' : 'Create Rule',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

