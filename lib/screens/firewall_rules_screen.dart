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
import '../services/demo_api_service.dart';
import '../services/firewall/firewall_rule_filter.dart';
import '../utils/snackbar_helper.dart';
import '../utils/constants.dart';
import '../widgets/app_drawer.dart';
import '../widgets/common/confirmation_dialog.dart';
import '../widgets/common/error_display.dart';
import '../widgets/common/empty_state_widget.dart';
import '../widgets/firewall/firewall_rule_card.dart';
import '../widgets/firewall/interface_selector.dart';
import '../widgets/firewall/rule_detail_sheet.dart';
import 'firewall_rule_form_screen.dart';
import '../l10n/app_localizations.dart';

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
      final demoApiService = context.read<DemoApiService>();
      final systemInfo = await demoApiService.getSystemInfo();

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
      final demoApiService = context.read<DemoApiService>();
      final allRules = await demoApiService.getFirewallRules();
      
      // Use filter utility to process rules
      final rulesByInterface = FirewallRuleFilter.filterAndGroup(allRules);

      if (mounted) {
        setState(() {
          _rules = FirewallRuleFilter.filterAutomationRules(allRules);
          _rulesByInterface = rulesByInterface;
          // Set default selected interface to the first one if available
          if (_selectedInterface == null && rulesByInterface.isNotEmpty) {
            _selectedInterface = FirewallRuleFilter.getFirstInterface(rulesByInterface);
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
    final l10n = AppLocalizations.of(context)!;
    // Prevent toggling system-generated rules
    if (rule.isSystemGenerated) {
      SnackBarHelper.showWarning(context, l10n.systemGeneratedRulesCannotBeModified);
      return;
    }

    // Show confirmation dialog
    final action = rule.isEnabled ? l10n.disable : l10n.enable;
    final actionTitle = rule.isEnabled ? l10n.disableRule : l10n.enableRule;
    final confirmed = await ConfirmationDialog.show(
      context: context,
      title: actionTitle,
      message: rule.isEnabled
          ? l10n.disableRuleConfirmation(rule.description.isEmpty ? l10n.unnamedRule : rule.description)
          : l10n.enableRuleConfirmation(rule.description.isEmpty ? l10n.unnamedRule : rule.description),
      confirmText: action,
      cancelText: l10n.cancel,
      isDestructive: false,
    );

    if (confirmed != true) return;
    if (!mounted) return;

    try {
      final demoApiService = context.read<DemoApiService>();
      
      // Show loading indicator
      if (mounted) {
        SnackBarHelper.showInfo(context, rule.isEnabled ? l10n.disablingRule : l10n.enablingRule);
      }
      
      await demoApiService.toggleFirewallRule(rule.uuid);

      // Wait a moment for OPNsense to process the change
      await Future.delayed(const Duration(milliseconds: 1500));

      if (mounted) {
        SnackBarHelper.showSuccess(context, rule.isEnabled ? l10n.ruleDisabledSuccessfully : l10n.ruleEnabledSuccessfully);
        // Reload rules to reflect the change
        await _loadRules();
      }
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showError(context, l10n.errorTogglingRule(e.toString()));
      }
    }
  }

  Future<void> _deleteRule(FirewallRule rule) async {
    final l10n = AppLocalizations.of(context)!;
    // Prevent deleting system-generated rules
    if (rule.isSystemGenerated) {
      SnackBarHelper.showWarning(context, l10n.systemGeneratedRulesCannotBeDeleted);
      return;
    }

    final confirmed = await ConfirmationDialog.show(
      context: context,
      title: l10n.deleteRule,
      message: l10n.deleteRuleConfirmation(rule.description),
      confirmText: l10n.delete,
      cancelText: l10n.cancel,
      isDestructive: true,
    );

    if (confirmed == true && mounted) {
      try {
        final demoApiService = context.read<DemoApiService>();
        await demoApiService.deleteFirewallRule(rule.uuid);

        if (mounted) {
          SnackBarHelper.showInfo(context, l10n.ruleDeleted);
          _loadRules();
        }
      } catch (e) {
        if (mounted) {
          SnackBarHelper.showInfo(context, l10n.errorDeletingRule(e.toString()));
        }
      }
    }
  }

  void _showRuleDetails(FirewallRule rule) {
    RuleDetailSheet.show(
      context,
      rule: rule,
      onEdit: () async {
        Navigator.of(context).pop();
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => FirewallRuleFormScreen(
              rule: rule,
            ),
          ),
        );
        if (mounted) _loadRules();
      },
      onDelete: () {
        Navigator.of(context).pop();
        _deleteRule(rule);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.firewallRules),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _loadRules,
            tooltip: l10n.refresh,
          ),
        ],
      ),
      drawer: AppDrawer(
        currentRoute: 'firewall_rules',
        systemInfo: _systemInfo,
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const FirewallRuleFormScreen(),
            ),
          );
          if (mounted) _loadRules();
        },
        icon: const Icon(Icons.add),
        label: Text(l10n.newRule),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return ErrorDisplay(message: _errorMessage!, onRetry: _loadRules);
    }

    if (_rules.isEmpty) {
      final l10n = AppLocalizations.of(context)!;
      return EmptyStateWidget(
        icon: Icons.security,
        title: l10n.noAutomationRulesFound,
        subtitle: l10n.createFirstAutomationRule,
      );
    }

    if (_rulesByInterface.isEmpty) {
      return _buildNoInterfacesState();
    }

    return Column(
      children: [
        // Interface selector
        InterfaceSelector(
          interfaceRuleCounts: _rulesByInterface.map(
            (key, value) => MapEntry(key, value.length),
          ),
          selectedInterface: _selectedInterface,
          onInterfaceSelected: (interface) {
            setState(() {
              _selectedInterface = interface;
            });
          },
        ),
        // Rules list for selected interface
        Expanded(
          child: _buildRulesList(),
        ),
      ],
    );
  }

  Widget _buildNoInterfacesState() {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.security, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            l10n.noInterfacesWithAutomationRules,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildRulesList() {
    final l10n = AppLocalizations.of(context)!;
    if (_selectedInterface == null) {
      return Center(child: Text(l10n.selectInterfaceToViewRules));
    }

    final rules = FirewallRuleFilter.getRulesForInterface(
      _rulesByInterface,
      _selectedInterface,
    );

    if (rules.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.security, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              l10n.noRulesForInterface(_selectedInterface!),
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
          return FirewallRuleCard(
            rule: rule,
            onTap: () => _showRuleDetails(rule),
            onToggle: (_) => _toggleRule(rule),
          );
        },
      ),
    );
  }
}


