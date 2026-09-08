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
import '../utils/snackbar_helper.dart';
import '../utils/constants.dart';
import '../viewmodels/netflow_view_model.dart';
import '../widgets/app_drawer.dart';
import '../widgets/common/confirmation_dialog.dart';
import '../widgets/common/error_display.dart';
import '../utils/single_init_mixin.dart';

/// NetFlow configuration screen with two tabs: Capture and Cache.
class NetflowScreen extends StatefulWidget {
  const NetflowScreen({super.key});

  @override
  State<NetflowScreen> createState() => _NetflowScreenState();
}

class _NetflowScreenState extends State<NetflowScreen>
    with TickerProviderStateMixin, SingleInitMixin {
  late NetflowViewModel _viewModel;
  late TabController _tabController;

  @override
  void onFirstDependency() {
    _viewModel = NetflowViewModel(context.read<DemoApiService>());
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);
    _viewModel.loadConfig();
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) return;
    if (_tabController.index == 1) {
      _viewModel.loadCacheStats();
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.netflowConfig),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: l10n.netflowCaptureTab),
            Tab(text: l10n.netflowCacheTab),
          ],
        ),
      ),
      drawer: const AppDrawer(currentRoute: Routes.netflow),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) => TabBarView(
          controller: _tabController,
          children: [
            _CaptureTab(viewModel: _viewModel),
            _CacheTab(viewModel: _viewModel),
          ],
        ),
      ),
    );
  }
}

// ── Capture Tab ──────────────────────────────────────────────────────────────

class _CaptureTab extends StatelessWidget {
  final NetflowViewModel viewModel;

  const _CaptureTab({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.errorMessage != null && viewModel.config == null) {
      return ErrorDisplay(
        message: viewModel.errorMessage!,
        onRetry: viewModel.loadConfig,
      );
    }

    final config = viewModel.config;
    if (config == null) return const SizedBox.shrink();

    return ListView(
      padding: const EdgeInsets.all(AppConstants.standardPadding),
      children: [
        // ── Listening Interfaces ─────────────────────────────────────────
        _SectionCard(
          title: l10n.netflowListeningInterfaces,
          hint: l10n.netflowListeningInterfacesHint,
          child: _MultiSelectField(
            options: config.listeningInterfaceOptions,
            selected: config.listeningInterfaces,
            onChanged: (selected) => viewModel.updateConfig(
              config.copyWith(listeningInterfaces: selected),
            ),
          ),
        ),
        const SizedBox(height: AppConstants.standardPadding),

        // ── WAN Interfaces ───────────────────────────────────────────────
        _SectionCard(
          title: l10n.netflowWanInterfaces,
          hint: l10n.netflowWanInterfacesHint,
          child: _MultiSelectField(
            options: config.wanInterfaceOptions,
            selected: config.wanInterfaces,
            onChanged: (selected) => viewModel.updateConfig(
              config.copyWith(wanInterfaces: selected),
            ),
          ),
        ),
        const SizedBox(height: AppConstants.standardPadding),

        // ── Capture Local ────────────────────────────────────────────────
        _SectionCard(
          title: l10n.netflowCaptureLocal,
          hint: l10n.netflowCaptureLocalHint,
          child: Switch(
            value: config.captureLocal,
            onChanged: (val) => viewModel.updateConfig(
              config.copyWith(captureLocal: val),
            ),
          ),
        ),
        const SizedBox(height: AppConstants.standardPadding),

        // ── Version (dropdown) ───────────────────────────────────────────
        _SectionCard(
          title: l10n.versionLabel,
          child: DropdownButtonFormField<String>(
            initialValue: config.version.isEmpty
                ? null
                : config.version,
            decoration: const InputDecoration(
              isDense: true,
              border: OutlineInputBorder(),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            items: config.versionOptions.entries
                .map((e) => DropdownMenuItem(
                      value: e.key,
                      child: Text(e.value),
                    ))
                .toList(),
            onChanged: (val) {
              if (val != null) {
                viewModel.updateConfig(
                  config.copyWith(version: val),
                );
              }
            },
          ),
        ),
        const SizedBox(height: AppConstants.standardPadding),

        // ── Destinations (editable list) ─────────────────────────────────
        _SectionCard(
          title: l10n.netflowDestinations,
          hint: l10n.netflowDestinationsHint,
          child: _DestinationsField(
            targets: config.targets,
            onChanged: (targets) => viewModel.updateConfig(
              config.copyWith(targets: targets),
            ),
          ),
        ),
        const SizedBox(height: AppConstants.standardPadding),

        // ── Active Timeout ───────────────────────────────────────────────
        _SectionCard(
          title: l10n.netflowActiveTimeout,
          hint: l10n.netflowActiveTimeoutHint,
          child: TextFormField(
            key: ValueKey('active_${config.activeTimeout}'),
            initialValue: config.activeTimeout,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              isDense: true,
              border: OutlineInputBorder(),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            onChanged: (val) => viewModel.updateConfig(
              config.copyWith(activeTimeout: val),
            ),
          ),
        ),
        const SizedBox(height: AppConstants.standardPadding),

        // ── Inactive Timeout ─────────────────────────────────────────────
        _SectionCard(
          title: l10n.netflowInactiveTimeout,
          hint: l10n.netflowInactiveTimeoutHint,
          child: TextFormField(
            key: ValueKey('inactive_${config.inactiveTimeout}'),
            initialValue: config.inactiveTimeout,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              isDense: true,
              border: OutlineInputBorder(),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            onChanged: (val) => viewModel.updateConfig(
              config.copyWith(inactiveTimeout: val),
            ),
          ),
        ),
        const SizedBox(height: AppConstants.standardPadding * 2),

        // ── Save button ──────────────────────────────────────────────────
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: viewModel.isSaving ? null : () => _save(context, l10n),
            child: viewModel.isSaving
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(l10n.save),
          ),
        ),
        const SizedBox(height: AppConstants.compactPadding),

        // ── Reset NetFlow Data ───────────────────────────────────────────
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
              side: BorderSide(color: Theme.of(context).colorScheme.error),
            ),
            onPressed:
                viewModel.isSaving ? null : () => _confirmReset(context, l10n),
            child: Text(l10n.netflowResetData),
          ),
        ),

        if (viewModel.errorMessage != null) ...[
          const SizedBox(height: AppConstants.standardPadding),
          Text(
            viewModel.errorMessage!,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ],
      ],
    );
  }

  Future<void> _save(BuildContext context, AppLocalizations l10n) async {
    final ok = await viewModel.saveConfig();
    if (!context.mounted) return;
    if (ok) {
      SnackBarHelper.showSuccess(context, l10n.netflowSaved);
    } else if (viewModel.errorMessage != null) {
      SnackBarHelper.showError(context, viewModel.errorMessage!);
    }
  }

  Future<void> _confirmReset(
      BuildContext context, AppLocalizations l10n) async {
    final confirmed = await ConfirmationDialog.show(
      context: context,
      title: l10n.netflowResetData,
      message: l10n.netflowResetWarning,
      confirmText: l10n.confirmDelete,
      cancelText: l10n.cancel,
      isDestructive: true,
    );
    if (confirmed != true || !context.mounted) return;

    final ok = await viewModel.resetData();
    if (!context.mounted) return;
    if (ok) {
      SnackBarHelper.showSuccess(context, l10n.netflowSaved);
    } else if (viewModel.errorMessage != null) {
      SnackBarHelper.showError(context, viewModel.errorMessage!);
    }
  }
}

// ── Cache Tab ────────────────────────────────────────────────────────────────

class _CacheTab extends StatelessWidget {
  final NetflowViewModel viewModel;

  const _CacheTab({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (viewModel.isCacheLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.cacheErrorMessage != null) {
      return ErrorDisplay(
        message: viewModel.cacheErrorMessage!,
        onRetry: viewModel.loadCacheStats,
      );
    }

    final stats = viewModel.cacheStats;
    if (stats.isEmpty) {
      return Center(child: Text(l10n.noItemsConfigured));
    }

    return RefreshIndicator(
      onRefresh: viewModel.refreshCacheStats,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.standardPadding),
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              // Give the DataTable an unconstrained horizontal axis so it can
              // measure its own column widths without fighting the Card's width.
              child: IntrinsicWidth(
                child: DataTable(
                  columnSpacing: 20,
                  headingRowColor: WidgetStateProperty.all(
                    Theme.of(context).colorScheme.surfaceContainerHighest,
                  ),
                  columns: [
                    DataColumn(label: Text(l10n.netflowCacheFlow)),
                    DataColumn(label: Text(l10n.interface)),
                    DataColumn(
                        label: Text(l10n.netflowDestinations), numeric: true),
                    DataColumn(
                        label: Text(l10n.netflowCacheSrcIps), numeric: true),
                    DataColumn(
                        label: Text(l10n.netflowCachePackets), numeric: true),
                  ],
                  rows: stats
                      .map(
                        (s) => DataRow(cells: [
                          DataCell(Text(s.name,
                              style: Theme.of(context).textTheme.bodySmall)),
                          DataCell(Text(s.interface)),
                          DataCell(Text(_fmt(s.dstIpAddresses))),
                          DataCell(Text(_fmt(s.srcIpAddresses))),
                          DataCell(Text(_fmt(s.packets))),
                        ]),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _fmt(int n) => n.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]},',
      );
}

// ── Shared helper widgets ────────────────────────────────────────────────────

/// A section card with a bold title, optional hint text below the title,
/// and a child widget.
class _SectionCard extends StatelessWidget {
  final String title;
  final String? hint;
  final Widget child;

  const _SectionCard({required this.title, this.hint, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.standardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            if (hint != null) ...[
              const SizedBox(height: 4),
              Text(
                hint!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
            const SizedBox(height: AppConstants.compactPadding),
            child,
          ],
        ),
      ),
    );
  }
}

/// Multi-select checkboxes with Clear All / Select All action buttons.
class _MultiSelectField extends StatelessWidget {
  final Map<String, String> options;
  final List<String> selected;
  final ValueChanged<List<String>> onChanged;

  const _MultiSelectField({
    required this.options,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Checkboxes
        ...options.entries.map((e) {
          final checked = selected.contains(e.key);
          return CheckboxListTile(
            title: Text(e.value),
            value: checked,
            dense: true,
            contentPadding: EdgeInsets.zero,
            onChanged: (val) {
              final next = List<String>.from(selected);
              if (val == true) {
                next.add(e.key);
              } else {
                next.remove(e.key);
              }
              onChanged(next);
            },
          );
        }),
        const SizedBox(height: 4),
        // Clear All / Select All
        Row(
          children: [
            TextButton(
              onPressed: () => onChanged([]),
              style: TextButton.styleFrom(
                visualDensity: VisualDensity.compact,
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
              child: Text(l10n.clearAll),
            ),
            const SizedBox(width: 4),
            TextButton(
              onPressed: () => onChanged(options.keys.toList()),
              style: TextButton.styleFrom(
                visualDensity: VisualDensity.compact,
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
              child: Text(l10n.selectAll),
            ),
          ],
        ),
      ],
    );
  }
}

/// Editable list of destination strings (ip:port) with add / remove controls.
class _DestinationsField extends StatefulWidget {
  final List<String> targets;
  final ValueChanged<List<String>> onChanged;

  const _DestinationsField({
    required this.targets,
    required this.onChanged,
  });

  @override
  State<_DestinationsField> createState() => _DestinationsFieldState();
}

class _DestinationsFieldState extends State<_DestinationsField> {
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = widget.targets
        .map((t) => TextEditingController(text: t))
        .toList();
  }

  @override
  void didUpdateWidget(_DestinationsField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Rebuild controllers only when the list length changes (add/remove).
    if (oldWidget.targets.length != widget.targets.length) {
      for (final c in _controllers) {
        c.dispose();
      }
      _controllers = widget.targets
          .map((t) => TextEditingController(text: t))
          .toList();
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _notifyChanged() {
    widget.onChanged(_controllers.map((c) => c.text).toList());
  }

  void _addRow() {
    setState(() {
      _controllers.add(TextEditingController());
    });
    _notifyChanged();
  }

  void _removeRow(int index) {
    setState(() {
      _controllers[index].dispose();
      _controllers.removeAt(index);
    });
    _notifyChanged();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ..._controllers.asMap().entries.map((entry) {
          final i = entry.key;
          final ctrl = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: AppConstants.compactPadding),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: ctrl,
                    decoration: const InputDecoration(
                      isDense: true,
                      border: OutlineInputBorder(),
                      hintText: '192.168.0.1:2550',
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    onChanged: (_) => _notifyChanged(),
                  ),
                ),
                const SizedBox(width: AppConstants.compactPadding),
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  color: Theme.of(context).colorScheme.error,
                  tooltip: l10n.remove,
                  onPressed: () => _removeRow(i),
                ),
              ],
            ),
          );
        }),
        TextButton.icon(
          onPressed: _addRow,
          icon: const Icon(Icons.add),
          label: Text(l10n.netflowAddDestination),
          style: TextButton.styleFrom(
            visualDensity: VisualDensity.compact,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          ),
        ),
      ],
    );
  }
}
