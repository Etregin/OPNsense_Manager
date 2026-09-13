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
import '../constants/routes.dart';
import '../l10n/app_localizations.dart';
import '../services/demo_api_service.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../utils/single_init_mixin.dart';
import '../viewmodels/system_health_view_model.dart'
    show HealthGranularity, SystemHealthViewModel;
import '../widgets/app_drawer.dart';
import '../widgets/common/confirmation_dialog.dart';
import '../widgets/common/error_display.dart';
import '../widgets/health/system_health_chart.dart';
import '../widgets/common/app_banner_ad_widget.dart';

/// Reporting → Health screen.
///
/// Two tabs — Health (interactive RRD graph) and Settings (placeholder).
class SystemHealthScreen extends StatefulWidget {
  const SystemHealthScreen({super.key});

  @override
  State<SystemHealthScreen> createState() => _SystemHealthScreenState();
}

class _SystemHealthScreenState extends State<SystemHealthScreen>
    with SingleInitMixin, TickerProviderStateMixin {
  late SystemHealthViewModel _vm;
  late TabController _tabController;

  @override
  void onFirstDependency() {
    _tabController = TabController(length: 2, vsync: this);
    _vm = SystemHealthViewModel(context.read<DemoApiService>());
    _vm.loadInitial();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.reportingHealth),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: l10n.refresh,
            onPressed: _vm.refresh,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: l10n.reportingHealth),
            Tab(text: l10n.settings),
          ],
        ),
      ),
      drawer: const AppDrawer(currentRoute: Routes.reportingHealth),
      body: Column(
        children: [
          Expanded(
            child: ListenableBuilder(
              listenable: _vm,
              builder: (context, _) => TabBarView(
                controller: _tabController,
                children: [
                  _HealthTab(vm: _vm),
                  _SettingsTab(vm: _vm),
                ],
              ),
            ),
          ),
          const AppBannerAdWidget(),
        ],
      ),
    );
  }
}

// ── Health Tab ────────────────────────────────────────────────────────────────

class _HealthTab extends StatelessWidget {
  final SystemHealthViewModel vm;

  const _HealthTab({required this.vm});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Top-level loading: status + metadata not yet fetched.
    if (vm.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Top-level error: status or metadata call failed.
    if (vm.errorMessage != null) {
      return ErrorDisplay(message: vm.errorMessage!, onRetry: vm.refresh);
    }

    // Health is disabled on the firewall.
    if (!vm.isEnabled) {
      return const _DisabledNotice();
    }

    // No categories in the RRD list (empty metadata response).
    if (vm.categories.isEmpty) {
      return Center(child: Text(l10n.noDataAvailable));
    }

    return RefreshIndicator(
      onRefresh: vm.refresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppConstants.standardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SelectionCard(vm: vm),
            const SizedBox(height: AppConstants.standardPadding),
            _GraphCard(vm: vm),
          ],
        ),
      ),
    );
  }
}

// ── Disabled notice ───────────────────────────────────────────────────────────

class _DisabledNotice extends StatelessWidget {
  const _DisabledNotice();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.standardPadding * 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.bar_chart_outlined,
              size: AppConstants.featureIconSize,
              color: AppColors.disabled,
            ),
            const SizedBox(height: AppConstants.standardPadding),
            Text(
              l10n.healthDisabledNotice,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Selection card (category + subject + granularity dropdowns) ───────────────

class _SelectionCard extends StatelessWidget {
  final SystemHealthViewModel vm;

  const _SelectionCard({required this.vm});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      elevation: AppConstants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.standardPadding,
          vertical: AppConstants.compactPadding,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _DropdownColumn<String>(
                    label: l10n.healthCategory,
                    value: vm.selectedCategory,
                    items: vm.categories,
                    labelFor: (c) => c,
                    onChanged: vm.selectCategory,
                  ),
                ),
                const SizedBox(width: AppConstants.standardPadding),
                Expanded(
                  child: _DropdownColumn<String>(
                    label: l10n.healthSubject,
                    value: vm.selectedSubject,
                    items: vm.subjectsForSelectedCategory,
                    labelFor: (s) => s,
                    onChanged: vm.selectSubject,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.compactPadding),
            Row(
              children: [
                Expanded(
                  child: _DropdownColumn<HealthGranularity>(
                    label: l10n.healthGranularity,
                    value: vm.selectedGranularity,
                    items: HealthGranularity.values,
                    labelFor: (g) => _granularityLabel(g, l10n),
                    onChanged: vm.selectGranularity,
                  ),
                ),
                const Expanded(child: SizedBox()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Reusable dropdown column ──────────────────────────────────────────────────

class _DropdownColumn<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<T> items;
  final String Function(T) labelFor;
  final void Function(T) onChanged;

  const _DropdownColumn({
    required this.label,
    required this.value,
    required this.items,
    required this.labelFor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        DropdownButtonHideUnderline(
          child: DropdownButton<T>(
            value: value,
            isExpanded: true,
            items: items
                .map(
                  (item) => DropdownMenuItem<T>(
                    value: item,
                    child: Text(
                      labelFor(item),
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                )
                .toList(),
            onChanged: (v) {
              if (v != null) onChanged(v);
            },
          ),
        ),
      ],
    );
  }
}

String _granularityLabel(HealthGranularity g, AppLocalizations l10n) {
  switch (g) {
    case HealthGranularity.oneMinute:
      return l10n.healthGranularity1Min;
    case HealthGranularity.fiveMinutes:
      return l10n.healthGranularity5Min;
    case HealthGranularity.oneHour:
      return l10n.healthGranularity1Hour;
    case HealthGranularity.twentyFourHours:
      return l10n.healthGranularity24Hours;
  }
}

// ── Graph card ────────────────────────────────────────────────────────────────

class _GraphCard extends StatelessWidget {
  final SystemHealthViewModel vm;

  const _GraphCard({required this.vm});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    Widget body;

    if (vm.isGraphLoading) {
      body = const SizedBox(
        height: 240,
        child: Center(child: CircularProgressIndicator()),
      );
    } else if (vm.graphErrorMessage != null) {
      body = Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppConstants.standardPadding,
        ),
        child: ErrorDisplay(
          message: vm.graphErrorMessage!,
          onRetry: vm.loadGraph,
        ),
      );
    } else if (!vm.hasGraphData) {
      body = SizedBox(
        height: 120,
        child: Center(child: Text(l10n.noDataAvailable)),
      );
    } else {
      body = SystemHealthChart(response: vm.graphResponse!);
    }

    return Card(
      elevation: AppConstants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.standardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (vm.graphResponse?.title.isNotEmpty ?? false)
              Text(
                vm.graphResponse!.title,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            const SizedBox(height: AppConstants.compactPadding),
            body,
          ],
        ),
      ),
    );
  }
}

// ── Settings Tab (placeholder) ────────────────────────────────────────────────

class _SettingsTab extends StatelessWidget {
  final SystemHealthViewModel vm;

  const _SettingsTab({required this.vm});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return RefreshIndicator(
      onRefresh: vm.refresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppConstants.standardPadding),
        children: [
          // ── Enable / Disable toggle ─────────────────────────────────────
          _SettingsSection(
            child: SwitchListTile(
              title: Text(l10n.healthEnableReporting),
              value: vm.isEnabled,
              onChanged: vm.setEnabled,
            ),
          ),
          const SizedBox(height: AppConstants.standardPadding),

          // ── Collected Reports ───────────────────────────────────────────
          _SettingsSection(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text(l10n.healthCollectedReports),
                  trailing: vm.rrdFiles.isEmpty
                      ? null
                      : Text(
                          '${vm.rrdFiles.length}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                ),
                if (vm.rrdFiles.isEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppConstants.standardPadding,
                      0,
                      AppConstants.standardPadding,
                      AppConstants.standardPadding,
                    ),
                    child: Text(
                      l10n.healthNoReports,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  )
                else
                  ...vm.rrdFiles.map(
                    (f) => ListTile(
                      dense: true,
                      title: Text(
                        f.filename,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        tooltip: l10n.delete,
                        color: Theme.of(context).colorScheme.error,
                        onPressed: () async {
                          final confirmed = await ConfirmationDialog.show(
                            context: context,
                            title: l10n.confirmDelete,
                            message: l10n.healthDeleteReportConfirmMessage,
                            confirmText: l10n.delete,
                            cancelText: l10n.cancel,
                            isDestructive: true,
                          );
                          if (confirmed) await vm.deleteRrdFile(f.filename);
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.standardPadding),

          // ── Reset RRD Data ──────────────────────────────────────────────
          _SettingsSection(
            child: ListTile(
              title: Text(
                l10n.healthResetRrdData,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              trailing: Icon(
                Icons.delete_forever_outlined,
                color: Theme.of(context).colorScheme.error,
              ),
              onTap: () async {
                final confirmed = await ConfirmationDialog.show(
                  context: context,
                  title: l10n.healthResetConfirmTitle,
                  message: l10n.healthResetConfirmMessage,
                  confirmText: l10n.yes,
                  cancelText: l10n.cancel,
                  isDestructive: true,
                );
                if (confirmed) await vm.deleteAllRrd();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final Widget child;

  const _SettingsSection({required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppConstants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
      ),
      child: child,
    );
  }
}
