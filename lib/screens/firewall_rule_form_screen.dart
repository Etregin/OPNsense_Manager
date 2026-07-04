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
import '../services/demo_api_service.dart';
import '../utils/constants.dart';
import '../utils/snackbar_helper.dart';
import '../utils/validators.dart';
import '../l10n/app_localizations.dart';

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
  Map<String, dynamic> _availableInterfaces = {};
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
      final demoApiService = context.read<DemoApiService>();
      final interfaces = await demoApiService.getAvailableInterfaces();
      
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
      final demoApiService = context.read<DemoApiService>();
      
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
        await demoApiService.updateFirewallRule(widget.rule!.uuid, request);
      } else {
        await demoApiService.createFirewallRule(request);
      }

      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        SnackBarHelper.showInfo(context, widget.isEditing ? l10n.ruleUpdated : l10n.ruleCreated);
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        setState(() {
          _isLoading = false;
        });
        SnackBarHelper.showInfo(context, l10n.errorSavingRule(e.toString()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? l10n.editRule : l10n.newRule),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppConstants.standardPadding * 2),
          children: [
            // Description
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: l10n.description,
                hintText: l10n.enterRuleDescription,
                prefixIcon: const Icon(Icons.description),
              ),
              validator: (value) =>
                  Validators.validateRequired(value, l10n.description),
              enabled: !_isLoading,
            ),
            const SizedBox(height: 16),

            // Action Type
            DropdownButtonFormField<String>(
              initialValue: _selectedType,
              decoration: InputDecoration(
                labelText: l10n.action,
                prefixIcon: const Icon(Icons.rule),
              ),
              items: [
                DropdownMenuItem(value: 'pass', child: Text(l10n.pass)),
                DropdownMenuItem(value: 'block', child: Text(l10n.block)),
                DropdownMenuItem(value: 'reject', child: Text(l10n.reject)),
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
              decoration: InputDecoration(
                labelText: l10n.interface,
                prefixIcon: const Icon(Icons.network_check),
              ),
              items: _loadingInterfaces
                  ? [DropdownMenuItem(value: 'loading', child: Text(l10n.loading))]
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
              decoration: InputDecoration(
                labelText: l10n.protocol,
                prefixIcon: const Icon(Icons.settings_ethernet),
              ),
              items: [
                DropdownMenuItem(value: 'any', child: Text(l10n.any)),
                DropdownMenuItem(value: 'tcp', child: Text(l10n.protocolTcp)),
                DropdownMenuItem(value: 'udp', child: Text(l10n.protocolUdp)),
                DropdownMenuItem(value: 'tcp/udp', child: Text(l10n.protocolTcpUdp)),
                DropdownMenuItem(value: 'icmp', child: Text(l10n.protocolIcmp)),
                DropdownMenuItem(value: 'icmpv6', child: Text(l10n.protocolIcmpv6)),
                DropdownMenuItem(value: 'esp', child: Text(l10n.protocolEsp)),
                DropdownMenuItem(value: 'ah', child: Text(l10n.protocolAh)),
                DropdownMenuItem(value: 'gre', child: Text(l10n.protocolGre)),
                DropdownMenuItem(value: 'ipv6', child: Text(l10n.protocolIpv6)),
                DropdownMenuItem(value: 'igmp', child: Text(l10n.protocolIgmp)),
                DropdownMenuItem(value: 'pim', child: Text(l10n.protocolPim)),
                DropdownMenuItem(value: 'ospf', child: Text(l10n.protocolOspf)),
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
              decoration: InputDecoration(
                labelText: l10n.source,
                hintText: l10n.anyIpAddressCidrOrAlias,
                prefixIcon: const Icon(Icons.arrow_forward),
                helperText: l10n.examplesAnyIpCidr,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.sourceIsRequired;
                }
                if (!Validators.isValidSourceDestination(value)) {
                  return l10n.invalidSourceFormat;
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
                decoration: InputDecoration(
                  labelText: l10n.sourcePortOptional,
                  hintText: l10n.anyPortNumberRangeOrAlias,
                  prefixIcon: const Icon(Icons.input),
                  helperText: l10n.examplesAnyPortRange,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return null; // Optional field
                  }
                  if (!Validators.isValidDestinationPort(value)) {
                    return l10n.invalidPortFormat;
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
              decoration: InputDecoration(
                labelText: l10n.destination,
                hintText: l10n.anyIpAddressCidrOrAlias,
                prefixIcon: const Icon(Icons.location_on),
                helperText: l10n.examplesAnyIpCidr,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.destinationIsRequired;
                }
                if (!Validators.isValidSourceDestination(value)) {
                  return l10n.invalidDestinationFormat;
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
                decoration: InputDecoration(
                  labelText: l10n.destinationPortOptional,
                  hintText: l10n.anyPortNumberRangeOrAlias,
                  prefixIcon: const Icon(Icons.settings_input_component),
                  helperText: l10n.examplesAnyPortRangeHttp,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return null; // Optional field
                  }
                  if (!Validators.isValidDestinationPort(value)) {
                    return l10n.invalidPortFormat;
                  }
                  return null;
                },
                enabled: !_isLoading,
              ),
              const SizedBox(height: 16),
            ],

            // Enabled Switch
            SwitchListTile(
              title: Text(l10n.enabled),
              subtitle: Text(l10n.ruleWillBeActiveWhenEnabled),
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
                          l10n.ruleGuidelines,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.ruleGuidelinesText,
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
                      widget.isEditing ? l10n.updateRule : l10n.createRule,
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

