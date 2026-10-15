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
import '../utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/dashboard_layout.dart';
import '../screens/live_network_monitor_screen.dart';
import '../services/dashboard/dashboard_layout_service.dart';
import '../services/demo_api_service.dart';
import '../services/opnsense_api_service.dart';
import '../utils/auto_refresh_mixin.dart';
import '../utils/single_init_mixin.dart';
import '../services/profile_service.dart';
import '../utils/constants.dart';
import '../utils/snackbar_helper.dart';
import '../viewmodels/dashboard_layout_view_model.dart';
import '../viewmodels/dashboard_view_model.dart';
import '../widgets/app_drawer.dart';
import '../widgets/common/confirmation_dialog.dart';
import '../widgets/common/demo_mode_banner.dart';
import '../widgets/dashboard/resource_usage_section.dart'
    show CpuUsageCard, MemoryUsageCard, DiskUsageCard;
import '../widgets/dashboard/services_section.dart';
import '../widgets/dashboard/gateways_section.dart';
import '../widgets/dashboard/thermal_sensors_section.dart';
import '../widgets/dashboard/network_cards.dart';
import '../l10n/app_localizations.dart';
import '../widgets/common/app_banner_ad_widget.dart';

/// Main dashboard screen showing system overview
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with AutoRefreshMixin, SingleInitMixin {
  late DashboardViewModel _viewModel;
  late DashboardLayoutViewModel _layoutViewModel;

  @override
  void onFirstDependency() {
    _viewModel = DashboardViewModel(context.read<DemoApiService>());
    _layoutViewModel = DashboardLayoutViewModel(
      context.read<DashboardLayoutService>(),
      context.read<ProfileService>(),
    );
    _initializeAndLoad();
    startAutoRefresh(AppConstants.dashboardRefreshInterval, _refreshWithLayout);
  }

  Future<void> _initializeAndLoad() async {
    final profileService = context.read<ProfileService>();
    final apiService = context.read<OPNsenseApiService>();

    final activeProfile = await profileService.getActiveProfile();
    if (activeProfile != null && !activeProfile.isDemo) {
      apiService.init(activeProfile.toOPNsenseConfig());
    }

    await _layoutViewModel.loadLayout();
    await _loadDataWithLayout();
  }

  /// Refresh data using the currently selected interfaces from the layout.
  Future<void> _refreshWithLayout() => _loadDataWithLayout();

  Future<void> _loadDataWithLayout() async {
    final requestedInterfaces = _layoutViewModel.allCards
        .where((c) =>
            c.type == DashboardCardType.networkTotals ||
            c.type == DashboardCardType.topDevices)
        .map((c) => c.selectedInterface ?? 'lan')
        .toSet();
    await _viewModel.loadDashboardData(
      requestedInterfaces: requestedInterfaces.isEmpty
          ? const {'lan'}
          : requestedInterfaces,
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _layoutViewModel.dispose();
    super.dispose();
  }

  Future<void> _controlService(
      String serviceId, String action, String serviceName) async {
    final l10n = AppLocalizations.of(context)!;

    final actionText = switch (action) {
      'start' => l10n.start,
      'stop'  => l10n.stop,
      _       => l10n.restart,
    };

    final confirmed = await ConfirmationDialog.show(
      context: context,
      title: l10n.actionService(actionText),
      message: l10n.confirmServiceAction(actionText, serviceName),
      confirmText: actionText,
      cancelText: l10n.cancel,
      isDestructive: action == 'stop',
    );

    if (confirmed != true) return;
    if (!mounted) return;

    try {
      final demoApiService = context.read<DemoApiService>();
      SnackBarHelper.showInfo(context, l10n.actioningService(actionText, serviceName));

      final success = await demoApiService.controlService(serviceId, action);

      if (mounted) {
        if (success) {
          final successMsg = switch (action) {
            'start' => l10n.serviceStartedSuccessfully,
            'stop'  => l10n.serviceStoppedSuccessfully,
            _       => l10n.serviceRestartedSuccessfully,
          };
          SnackBarHelper.showSuccess(context, successMsg);
          await Future.delayed(AppConstants.postActionRefreshDelay);
          if (mounted) {
            unawaited(_loadDataWithLayout());
          }
        } else {
          SnackBarHelper.showError(context, l10n.serviceActionFailed);
        }
      }
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showError(context, '${l10n.error}: ${e.toString()}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final demoApiService = context.watch<DemoApiService>();
    final isDemoMode = demoApiService.isDemoMode;

    return ListenableBuilder(
      listenable: Listenable.merge([_viewModel, _layoutViewModel]),
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(AppConstants.appName),
            actions: [
              // Edit / Done toggle
              IconButton(
                icon: Icon(
                  _layoutViewModel.isEditMode
                      ? Icons.check
                      : Icons.edit_outlined,
                ),
                tooltip: _layoutViewModel.isEditMode
                    ? l10n.done
                    : l10n.editDashboard,
                onPressed: _layoutViewModel.toggleEditMode,
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _viewModel.isLoading
                    ? null
                    : _loadDataWithLayout,
                tooltip: l10n.refresh,
              ),
            ],
          ),
          drawer: AppDrawer(
            currentRoute: 'dashboard',
            systemInfo: _viewModel.systemInfo,
          ),
          body: Column(
            children: [
              if (isDemoMode) const DemoModeBanner(),
              if (_layoutViewModel.isEditMode)
                _EditModeBanner(l10n: l10n),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _loadDataWithLayout,
                  child: _buildBody(l10n),
                ),
              ),
              const AppBannerAdWidget(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    if (_viewModel.isLoading && _viewModel.systemInfo == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_viewModel.errorMessage != null && _viewModel.systemInfo == null) {
      return _buildErrorState(l10n);
    }

    final cards = _layoutViewModel.isEditMode
        ? _layoutViewModel.allCards
        : _layoutViewModel.visibleCards;

    if (_layoutViewModel.isEditMode) {
      return ReorderableListView.builder(
        padding: const EdgeInsets.all(AppConstants.standardPadding),
        buildDefaultDragHandles: false,
        itemCount: cards.length,
        itemBuilder: (context, index) {
          final card = cards[index];
          return _EditModeCardWrapper(
            key: ValueKey(card.type),
            index: index,
            config: card,
            onVisibilityToggle: (visible) =>
                _layoutViewModel.setCardVisible(card.type, visible),
            child: _buildCardContent(card, l10n),
          );
        },
        onReorderItem: _layoutViewModel.reorderCards,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.standardPadding),
      itemCount: cards.length,
      itemBuilder: (context, index) {
        final card = cards[index];
        return Padding(
          key: ValueKey(card.type),
          padding: const EdgeInsets.only(bottom: 24),
          child: _buildCardContent(card, l10n),
        );
      },
    );
  }

  /// Maps a [DashboardCardConfig] to its corresponding section widget.
  Widget _buildCardContent(DashboardCardConfig card, AppLocalizations l10n) {
    switch (card.type) {
      case DashboardCardType.cpuUsage:
        if (_viewModel.systemInfo == null) return const SizedBox.shrink();
        return CpuUsageCard(systemInfo: _viewModel.systemInfo!);

      case DashboardCardType.memoryUsage:
        if (_viewModel.systemInfo == null) return const SizedBox.shrink();
        return MemoryUsageCard(systemInfo: _viewModel.systemInfo!);

      case DashboardCardType.diskUsage:
        if (_viewModel.systemInfo == null) return const SizedBox.shrink();
        return DiskUsageCard(systemInfo: _viewModel.systemInfo!);

      case DashboardCardType.thermalSensors:
        return ThermalSensorsSection(sensors: _viewModel.thermalSensors);

      case DashboardCardType.services:
        return ServicesSection(
          servicesData: _viewModel.servicesData,
          onServiceControl: _controlService,
        );

      case DashboardCardType.gateways:
        return GatewaysSection(gateways: _viewModel.gateways);

      case DashboardCardType.networkTotals:
        final iface = card.selectedInterface ?? 'lan';
        return NetworkTotalsCard(
          hosts: _viewModel.getHostsForInterface(iface),
          isLoading: _viewModel.isLoading,
          availableInterfaces: _viewModel.availableInterfaces,
          selectedInterface: iface,
          onInterfaceChanged: (newIface) async {
            await _layoutViewModel.setCardInterface(card.type, newIface);
            await _loadDataWithLayout();
          },
          onViewAll: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const LiveNetworkMonitorScreen(),
            ),
          ),
        );

      case DashboardCardType.topDevices:
        final iface = card.selectedInterface ?? 'lan';
        return TopDevicesCard(
          hosts: _viewModel.getHostsForInterface(iface),
          isLoading: _viewModel.isLoading,
          availableInterfaces: _viewModel.availableInterfaces,
          selectedInterface: iface,
          onInterfaceChanged: (newIface) async {
            await _layoutViewModel.setCardInterface(card.type, newIface);
            await _loadDataWithLayout();
          },
          onViewAll: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const LiveNetworkMonitorScreen(),
            ),
          ),
        );
    }
  }

  Widget _buildErrorState(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: AppColors.error),
          const SizedBox(height: 16),
          Text(l10n.error, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              _viewModel.errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _loadDataWithLayout,
            icon: const Icon(Icons.refresh),
            label: Text(l10n.retry),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Edit mode UI helpers
// ---------------------------------------------------------------------------

/// Subtle informational banner shown at the top of the screen during edit mode.
class _EditModeBanner extends StatelessWidget {
  final AppLocalizations l10n;

  const _EditModeBanner({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Theme.of(context).colorScheme.primaryContainer,
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.standardPadding,
        vertical: AppConstants.compactPadding,
      ),
      child: Text(
        l10n.editDashboard,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w600,
            ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

/// Wraps a card in edit mode, adding a drag handle and visibility toggle.
class _EditModeCardWrapper extends StatelessWidget {
  final int index;
  final DashboardCardConfig config;
  final ValueChanged<bool> onVisibilityToggle;
  final Widget child;

  const _EditModeCardWrapper({
    super.key,
    required this.index,
    required this.config,
    required this.onVisibilityToggle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Visibility toggle
          Padding(
            padding: const EdgeInsets.only(top: 4, right: 4),
            child: IconButton(
              icon: Icon(
                config.isVisible
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: config.isVisible
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              onPressed: () => onVisibilityToggle(!config.isVisible),
              tooltip: config.isVisible ? 'Hide' : 'Show',
            ),
          ),
          // Card content
          Expanded(
            child: Opacity(
              opacity: config.isVisible ? 1.0 : AppColors.opacityStrong,
              child: child,
            ),
          ),
          // Drag handle
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: ReorderableDragStartListener(
              index: index,
              child: const Icon(Icons.drag_handle),
            ),
          ),
        ],
      ),
    );
  }
}
