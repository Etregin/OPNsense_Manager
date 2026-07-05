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
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../utils/snackbar_helper.dart';
import '../utils/validators.dart';
import '../l10n/app_localizations.dart';
import '../viewmodels/firewall_rule_form_view_model.dart';
import '../widgets/common/loading_overlay.dart';

/// Form screen for creating or editing firewall rules
class FirewallRuleFormScreen extends StatefulWidget {
  final FirewallRule? rule;

  const FirewallRuleFormScreen({super.key, this.rule});

  bool get isEditing => rule != null;

  @override
  State<FirewallRuleFormScreen> createState() => _FirewallRuleFormScreenState();
}

class _FirewallRuleFormScreenState extends State<FirewallRuleFormScreen> {
  late FirewallRuleFormViewModel _viewModel;
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

  @override
  void initState() {
    super.initState();
    _viewModel = FirewallRuleFormViewModel(
      apiService: context.read(),
      existingRule: widget.rule,
    );
    _viewModel.addListener(_onViewModelChanged);
    _viewModel.loadInterfaces();

    if (widget.isEditing) {
      _loadRuleData();
    } else {
      _sourceController.text = 'any';
      _sourcePortController.text = 'any';
      _destinationController.text = 'any';
      _destinationPortController.text = 'any';
    }
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    _descriptionController.dispose();
    _sourceController.dispose();
    _sourcePortController.dispose();
    _destinationController.dispose();
    _destinationPortController.dispose();
    super.dispose();
  }

  void _onViewModelChanged() {
    if (mounted) setState(() {});
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

  Future<void> _saveRule() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;

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

    final success = await _viewModel.saveRule(request);

    if (mounted) {
      if (success) {
        SnackBarHelper.showInfo(context, widget.isEditing ? l10n.ruleUpdated : l10n.ruleCreated);
        Navigator.of(context).pop();
      } else {
        SnackBarHelper.showInfo(context, _viewModel.errorMessage ?? l10n.errorSavingRule(''));
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
      body: LoadingOverlay(
        isLoading: _viewModel.isLoading,
        child: Form(
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
                    Validators.validateRequired(value, l10n.description, context),
                enabled: !_viewModel.isLoading,
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
                onChanged: _viewModel.isLoading
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
                initialValue: _viewModel.availableInterfaces.containsKey(_selectedInterface) ? _selectedInterface : null,
                decoration: InputDecoration(
                  labelText: l10n.interface,
                  prefixIcon: const Icon(Icons.network_check),
                ),
                items: _viewModel.loadingInterfaces
                    ? [DropdownMenuItem(value: 'loading', child: Text(l10n.loading))]
                    : _viewModel.availableInterfaces.entries.map((entry) {
                        return DropdownMenuItem(
                          value: entry.key,
                          child: Text(entry.value),
                        );
                      }).toList(),
                onChanged: _viewModel.isLoading || _viewModel.loadingInterfaces
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
                  const DropdownMenuItem(value: 'tcp', child: Text(StringConstants.tcp)),
                  const DropdownMenuItem(value: 'udp', child: Text(StringConstants.udp)),
                  const DropdownMenuItem(value: 'tcp/udp', child: Text(StringConstants.tcpUdp)),
                  const DropdownMenuItem(value: 'icmp', child: Text(StringConstants.icmp)),
                  const DropdownMenuItem(value: 'icmpv6', child: Text(StringConstants.icmpv6)),
                  const DropdownMenuItem(value: 'esp', child: Text(StringConstants.esp)),
                  const DropdownMenuItem(value: 'ah', child: Text(StringConstants.ah)),
                  const DropdownMenuItem(value: 'gre', child: Text(StringConstants.gre)),
                  const DropdownMenuItem(value: 'ipv6', child: Text(StringConstants.ipv6Protocol)),
                  const DropdownMenuItem(value: 'igmp', child: Text(StringConstants.igmp)),
                  const DropdownMenuItem(value: 'pim', child: Text(StringConstants.pim)),
                  const DropdownMenuItem(value: 'ospf', child: Text(StringConstants.ospf)),
                ],
                onChanged: _viewModel.isLoading
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
                enabled: !_viewModel.isLoading,
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
                  enabled: !_viewModel.isLoading,
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
                enabled: !_viewModel.isLoading,
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
                  enabled: !_viewModel.isLoading,
                ),
                const SizedBox(height: 16),
              ],

              // Enabled Switch
              SwitchListTile(
                title: Text(l10n.enabled),
                subtitle: Text(l10n.ruleWillBeActiveWhenEnabled),
                value: _enabled,
                onChanged: _viewModel.isLoading
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
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline, color: Theme.of(context).colorScheme.onPrimaryContainer),
                          const SizedBox(width: 8),
                          Text(
                            l10n.ruleGuidelines,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.ruleGuidelinesText,
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Save Button
              ElevatedButton(
                onPressed: _viewModel.isLoading ? null : _saveRule,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: AppColors.onPrimary,
                ),
                child: Text(
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
      ),
    );
  }
}
