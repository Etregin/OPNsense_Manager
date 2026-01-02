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
import '../models/system_info.dart';
import '../services/opnsense_api_service.dart';
import '../utils/constants.dart';
import '../widgets/app_drawer.dart';
import 'firewall_rule_form_screen.dart';

/// Firewall rules management screen
class FirewallRulesScreen extends StatefulWidget {
  const FirewallRulesScreen({super.key});

  @override
  State<FirewallRulesScreen> createState() => _FirewallRulesScreenState();
}

class _FirewallRulesScreenState extends State<FirewallRulesScreen> {
  List<FirewallRule> _rules = [];
  SystemInfo? _systemInfo;
  bool _isLoading = true;
  String? _errorMessage;
  String? _selectedInterface;
  Map<String, List<FirewallRule>> _rulesByInterface = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.wait([
      _loadRules(),
      _loadSystemInfo(),
    ]);
  }

  Future<void> _loadSystemInfo() async {
    try {
      final apiService = context.read<OPNsenseApiService>();
      final systemInfo = await apiService.getSystemInfo();

      if (mounted) {
        setState(() {
          _systemInfo = systemInfo;
        });
      }
    } catch (e) {
      // Silently fail - system info is optional for drawer
    }
  }

  Future<void> _loadRules() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final apiService = context.read<OPNsenseApiService>();
      final allRules = await apiService.getFirewallRules();
      
      // Filter to show only automation rules (non-system-generated)
      final automationRules = allRules.where((rule) => !rule.isSystemGenerated).toList();
      
      // Group rules by interface
      final Map<String, List<FirewallRule>> rulesByInterface = {};
      for (var rule in automationRules) {
        if (!rulesByInterface.containsKey(rule.interfaceName)) {
          rulesByInterface[rule.interfaceName] = [];
        }
        rulesByInterface[rule.interfaceName]!.add(rule);
      }

      if (mounted) {
        setState(() {
          _rules = automationRules;
          _rulesByInterface = rulesByInterface;
          // Set default selected interface to the first one if available
          if (_selectedInterface == null && rulesByInterface.isNotEmpty) {
            _selectedInterface = rulesByInterface.keys.first;
          }
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

  Future<void> _toggleRule(FirewallRule rule) async {
    // Prevent toggling system-generated rules
    if (rule.isSystemGenerated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('System-generated rules cannot be modified'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Show confirmation dialog
    final action = rule.isEnabled ? 'disable' : 'enable';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${action[0].toUpperCase()}${action.substring(1)} Rule'),
        content: Text(
          'Are you sure you want to $action the rule "${rule.description.isEmpty ? 'Unnamed Rule' : rule.description}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: rule.isEnabled ? Colors.orange : Colors.green,
            ),
            child: Text(action[0].toUpperCase() + action.substring(1)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    if (!mounted) return;

    try {
      final apiService = context.read<OPNsenseApiService>();
      
      // Show loading indicator
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${action[0].toUpperCase()}${action.substring(1)}ing rule...'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
      
      await apiService.toggleFirewallRule(rule.uuid);

      // Wait a moment for OPNsense to process the change
      await Future.delayed(const Duration(milliseconds: 1500));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              rule.isEnabled ? 'Rule disabled successfully' : 'Rule enabled successfully',
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
        // Reload rules to reflect the change
        await _loadRules();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error toggling rule: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _deleteRule(FirewallRule rule) async {
    // Prevent deleting system-generated rules
    if (rule.isSystemGenerated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('System-generated rules cannot be deleted'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Rule'),
        content: Text(
          'Are you sure you want to delete the rule "${rule.description}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        final apiService = context.read<OPNsenseApiService>();
        await apiService.deleteFirewallRule(rule.uuid);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Rule deleted')),
          );
          _loadRules();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting rule: $e')),
          );
        }
      }
    }
  }

  void _showRuleDetails(FirewallRule rule) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.all(AppConstants.standardPadding * 2),
            child: ListView(
              controller: scrollController,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Rule Details',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildDetailRow('Description', rule.description),
                _buildDetailRow('Type', rule.typeDisplayName),
                _buildDetailRow('Interface', rule.interfaceName),
                _buildDetailRow('Protocol', rule.protocolDisplayName),
                _buildDetailRow('Source', '${rule.source}${rule.sourcePort != 'any' && rule.sourcePort.isNotEmpty ? ':${rule.sourcePort}' : ''}'),
                _buildDetailRow('Destination', '${rule.destination}${rule.destinationPort != 'any' && rule.destinationPort.isNotEmpty ? ':${rule.destinationPort}' : ''}'),
                if (rule.sourcePort != 'any' && rule.sourcePort.isNotEmpty)
                  _buildDetailRow('Source Port', rule.sourcePort),
                if (rule.destinationPort != 'any' && rule.destinationPort.isNotEmpty)
                  _buildDetailRow('Destination Port', rule.destinationPort),
                _buildDetailRow('Status', rule.isEnabled ? 'Enabled' : 'Disabled'),
                _buildDetailRow('Sequence', rule.sequence.toString()),
                const SizedBox(height: 24),
                if (rule.isSystemGenerated)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.orange[700], size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'This is a system-generated rule and cannot be modified or deleted.',
                            style: TextStyle(
                              color: Colors.orange[700],
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => FirewallRuleFormScreen(
                                  rule: rule,
                                ),
                              ),
                            ).then((_) => _loadRules());
                          },
                          icon: const Icon(Icons.edit),
                          label: const Text('Edit'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _deleteRule(rule);
                          },
                          icon: const Icon(Icons.delete),
                          label: const Text('Delete'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firewall Rules'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _loadRules,
            tooltip: 'Refresh',
          ),
        ],
      ),
      drawer: AppDrawer(
        currentRoute: 'firewall_rules',
        systemInfo: _systemInfo,
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const FirewallRuleFormScreen(),
            ),
          ).then((_) => _loadRules());
        },
        icon: const Icon(Icons.add),
        label: const Text('New Rule'),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text('Error loading rules',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(_errorMessage!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600])),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadRules,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_rules.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.security, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No automation rules found',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Create your first automation rule to get started',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    if (_rulesByInterface.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.security, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No interfaces with automation rules',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Interface selector
        Container(
          padding: const EdgeInsets.all(AppConstants.standardPadding),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[850]
                : Colors.grey[100],
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[700]!
                    : Colors.grey[300]!,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Interface',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _rulesByInterface.keys.map((interface) {
                    final isSelected = interface == _selectedInterface;
                    final ruleCount = _rulesByInterface[interface]!.length;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text('$interface ($ruleCount)'),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedInterface = interface;
                          });
                        },
                        selectedColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                        checkmarkColor: Theme.of(context).primaryColor,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        // Rules list for selected interface
        Expanded(
          child: _buildRulesList(),
        ),
      ],
    );
  }

  Widget _buildRulesList() {
    if (_selectedInterface == null) {
      return const Center(child: Text('Select an interface to view rules'));
    }

    final rules = _rulesByInterface[_selectedInterface] ?? [];

    if (rules.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.security, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No rules for $_selectedInterface',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadRules,
      child: ListView.separated(
        padding: const EdgeInsets.all(AppConstants.standardPadding),
        itemCount: rules.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final rule = rules[index];
          return _buildRuleCard(rule);
        },
      ),
    );
  }

  Widget _buildRuleCard(FirewallRule rule) {
    Color getTypeColor() {
      switch (rule.type.toLowerCase()) {
        case 'pass':
          return Colors.green;
        case 'block':
          return Colors.red;
        case 'reject':
          return Colors.orange;
        default:
          return Colors.grey;
      }
    }

    IconData getTypeIcon() {
      switch (rule.type.toLowerCase()) {
        case 'pass':
          return Icons.check_circle;
        case 'block':
          return Icons.block;
        case 'reject':
          return Icons.cancel;
        default:
          return Icons.help;
      }
    }

    return Card(
      child: InkWell(
        onTap: () => _showRuleDetails(rule),
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.standardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: getTypeColor().withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      getTypeIcon(),
                      color: getTypeColor(),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          rule.description.isEmpty
                              ? 'Unnamed Rule'
                              : rule.description,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${rule.typeDisplayName} • ${rule.interfaceName} • ${rule.protocolDisplayName}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: rule.isEnabled,
                    onChanged: rule.isSystemGenerated ? null : (_) => _toggleRule(rule),
                    activeTrackColor: Colors.green,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[800]
                      : Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildRuleInfo(
                            'Source',
                            '${rule.source}${rule.sourcePort != 'any' && rule.sourcePort.isNotEmpty ? ':${rule.sourcePort}' : ''}',
                            Icons.arrow_forward,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward,
                          size: 16,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey[400]
                              : Colors.grey[600],
                        ),
                        Expanded(
                          child: _buildRuleInfo(
                            'Destination',
                            '${rule.destination}${rule.destinationPort != 'any' && rule.destinationPort.isNotEmpty ? ':${rule.destinationPort}' : ''}',
                            Icons.location_on,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRuleInfo(String label, String value, IconData icon) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: isDark ? Colors.grey[400] : Colors.grey[600],
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.grey[200] : Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

