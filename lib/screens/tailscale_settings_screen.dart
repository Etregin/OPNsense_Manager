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

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../utils/snackbar_helper.dart';
import '../viewmodels/tailscale_settings_view_model.dart';
import '../viewmodels/tailscale_settings_form_state.dart';
import '../widgets/app_drawer.dart';
import '../widgets/common/loading_overlay.dart';
import '../widgets/common/error_display.dart';
import '../widgets/common/confirmation_dialog.dart';
import '../widgets/tailscale/service_controls_card.dart';
import '../widgets/tailscale/general_settings_card.dart';
import '../widgets/tailscale/routing_settings_card.dart';
import '../widgets/tailscale/dns_settings_card.dart';
import '../widgets/tailscale/other_settings_card.dart';
import 'tailscale_subnets_screen.dart';

/// Refactored screen for managing Tailscale settings
class TailscaleSettingsScreen extends StatefulWidget {
  const TailscaleSettingsScreen({super.key});

  @override
  State<TailscaleSettingsScreen> createState() =>
      _TailscaleSettingsScreenState();
}

class _TailscaleSettingsScreenState extends State<TailscaleSettingsScreen> {
  late TailscaleSettingsViewModel _viewModel;
  late TailscaleSettingsFormState _formState;
  final _formKey = GlobalKey<FormState>();
  Timer? _refreshTimer;
  bool _showServiceControls = false;

  @override
  void initState() {
    super.initState();
    _viewModel = TailscaleSettingsViewModel(
      demoApiService: context.read(),
      opnsenseApiService: context.read(),
    );
    _formState = TailscaleSettingsFormState(
      loginTimeoutController: TextEditingController(),
      listenPortController: TextEditingController(),
    );
    _viewModel.addListener(_onViewModelChanged);
    _loadData();
    _startAutoRefresh();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    _formState.dispose();
    super.dispose();
  }

  void _onViewModelChanged() {
    if (mounted) {
      setState(() {
        // Update form state when settings are loaded
        if (_viewModel.settings != null && !_viewModel.hasUnsavedChanges) {
          _formState.initializeFromSettings(_viewModel.settings!);
        }
      });
    }
  }

  void _startAutoRefresh() {
    _refreshTimer = Timer.periodic(
      const Duration(seconds: 30),
      (timer) {
        if (mounted && !_viewModel.hasUnsavedChanges) {
          _loadData();
        }
      },
    );
  }

  Future<void> _loadData() async {
    await _viewModel.loadData();
  }

  void _onFieldChanged() {
    if (_viewModel.settings == null) return;
    final newSettings = _formState.toSettings(_viewModel.settings!);
    _viewModel.updateSettings(newSettings);
    setState(() {});
  }

  Future<void> _applyAllChanges() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await _viewModel.saveChanges();
    if (mounted) {
      final l10n = AppLocalizations.of(context)!;
      if (success) {
        SnackBarHelper.showSuccess(context, l10n.allSettingsSavedSuccessfully);
      } else {
        SnackBarHelper.showError(context, _viewModel.errorMessage ?? l10n.failedToSaveSettings, duration: const Duration(seconds: 5));
      }
    }
  }

  void _discardChanges() {
    _viewModel.discardChanges();
    if (_viewModel.settings != null) {
      _formState.initializeFromSettings(_viewModel.settings!);
    }
    setState(() {});
    final l10n = AppLocalizations.of(context)!;
    SnackBarHelper.showInfo(context, l10n.changesDiscarded, duration: const Duration(seconds: 1));
  }

  Future<void> _controlService(String action) async {
    final l10n = AppLocalizations.of(context)!;
    final actionTitle = action == 'start'
        ? l10n.start
        : action == 'stop'
            ? l10n.stop
            : l10n.restart;

    final confirmed = await ConfirmationDialog.show(
      context: context,
      title: l10n.tailscaleServiceAction(actionTitle),
      message: l10n.tailscaleServiceActionConfirmation(action),
      confirmText: actionTitle,
      isDestructive: action == 'stop',
    );

    if (!confirmed || !mounted) return;

    SnackBarHelper.showInfo(context, l10n.tailscaleServiceActioning(actionTitle));

    final success = await _viewModel.controlService(action);

    if (mounted) {
      if (success) {
        SnackBarHelper.showSuccess(context, l10n.tailscaleServiceActionSuccess(actionTitle));
      } else {
        SnackBarHelper.showError(context, _viewModel.errorMessage ?? l10n.failedToActionTailscaleService(action));
      }
    }
  }

  Future<void> _navigateToSubnets() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TailscaleSubnetsScreen(),
      ),
    );
    if (mounted && !_viewModel.hasUnsavedChanges) {
      _loadData();
    }
  }

  Future<bool> _handleBackNavigation() async {
    if (!_viewModel.hasUnsavedChanges) return true;

    final l10n = AppLocalizations.of(context)!;
    final shouldPop = await ConfirmationDialog.show(
      context: context,
      title: l10n.unsavedChanges,
      message: l10n.unsavedChangesConfirmation,
      confirmText: l10n.discard,
      isDestructive: true,
    );

    return shouldPop;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_viewModel.hasUnsavedChanges,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) return;
        final shouldPop = await _handleBackNavigation();
        if (shouldPop && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.tailscaleSettings),
          actions: [
            if (_viewModel.settings != null)
              IconButton(
                icon: Icon(_showServiceControls ? Icons.close : Icons.settings),
                onPressed: () => setState(() => _showServiceControls = !_showServiceControls),
                tooltip: _showServiceControls ? AppLocalizations.of(context)!.hideControls : AppLocalizations.of(context)!.serviceControls,
              ),
          ],
        ),
        drawer: AppDrawer(
          currentRoute: 'tailscale_settings',
          systemInfo: _viewModel.systemInfo,
          onBeforeNavigate: () async {
            if (_viewModel.hasUnsavedChanges) {
              return await _handleBackNavigation();
            }
            return true;
          },
        ),
        body: LoadingOverlay(
          isLoading: _viewModel.isLoading,
          message: AppLocalizations.of(context)!.loadingSettings,
          child: _buildBody(),
        ),
        floatingActionButton: _viewModel.hasUnsavedChanges
            ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton.extended(
                    onPressed: _viewModel.isLoading ? null : _discardChanges,
                    backgroundColor: Colors.grey,
                    heroTag: 'discard',
                    icon: const Icon(Icons.close),
                    label: Text(AppLocalizations.of(context)!.discard),
                  ),
                  const SizedBox(width: 16),
                  FloatingActionButton.extended(
                    onPressed: _viewModel.isLoading ? null : _applyAllChanges,
                    heroTag: 'apply',
                    icon: const Icon(Icons.check),
                    label: Text(AppLocalizations.of(context)!.apply),
                  ),
                ],
              )
            : null,
      ),
    );
  }

  Widget _buildBody() {
    if (_viewModel.errorMessage != null && _viewModel.settings == null) {
      return ErrorDisplay(
        message: _viewModel.errorMessage!,
        onRetry: _loadData,
      );
    }

    if (_viewModel.settings == null) {
      return Center(child: Text(AppLocalizations.of(context)!.noSettingsAvailable));
    }

    return Form(
      key: _formKey,
      child: RefreshIndicator(
        onRefresh: _loadData,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (_showServiceControls) ...[
              ServiceControlsCard(
                onStart: () => _controlService('start'),
                onStop: () => _controlService('stop'),
                onRestart: () => _controlService('restart'),
              ),
              const SizedBox(height: 16),
            ],
            GeneralSettingsCard(
              formState: _formState,
              onChanged: _onFieldChanged,
            ),
            const SizedBox(height: 16),
            RoutingSettingsCard(
              formState: _formState,
              settings: _viewModel.modifiedSettings,
              onChanged: _onFieldChanged,
              onManageSubnets: _navigateToSubnets,
              hasUnsavedChanges: _viewModel.hasUnsavedChanges,
            ),
            const SizedBox(height: 16),
            DnsSettingsCard(
              formState: _formState,
              onChanged: _onFieldChanged,
            ),
            const SizedBox(height: 16),
            OtherSettingsCard(
              formState: _formState,
              onChanged: _onFieldChanged,
            ),
            const SizedBox(height: 80), // Space for FAB
          ],
        ),
      ),
    );
  }
}


