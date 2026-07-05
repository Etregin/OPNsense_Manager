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
import '../services/demo_api_service.dart';
import '../services/opnsense_api_service.dart';
import '../services/profile_service.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../utils/snackbar_helper.dart';
import '../viewmodels/dashboard_view_model.dart';
import '../widgets/app_drawer.dart';
import '../widgets/common/confirmation_dialog.dart';
import '../widgets/dashboard/resource_usage_section.dart';
import '../widgets/dashboard/services_section.dart';
import '../widgets/dashboard/gateways_section.dart';
import '../widgets/dashboard/thermal_sensors_section.dart';
import '../l10n/app_localizations.dart';

/// Main dashboard screen showing system overview
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late DashboardViewModel _viewModel;
  bool _isInitialized = false;
  Timer? _refreshTimer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final apiService = context.read<DemoApiService>();
      _viewModel = DashboardViewModel(apiService);
      _isInitialized = true;
      _initializeAndLoad();
      _startAutoRefresh();
    }
  }

  Future<void> _initializeAndLoad() async {
    // Ensure API service is initialized with active profile
    final profileService = context.read<ProfileService>();
    final apiService = context.read<OPNsenseApiService>();

    final activeProfile = await profileService.getActiveProfile();
    if (activeProfile != null && !activeProfile.isDemo) {
      apiService.init(activeProfile.toOPNsenseConfig());
    }

    await _viewModel.loadDashboardData();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _viewModel.dispose();
    super.dispose();
  }

  void _startAutoRefresh() {
    _refreshTimer = Timer.periodic(
      const Duration(seconds: 30),
      (timer) {
        if (mounted) {
          _viewModel.loadDashboardData();
        }
      },
    );
  }

  Future<void> _controlService(
      String serviceId, String action, String serviceName) async {
    final l10n = AppLocalizations.of(context)!;
    final actionText = action == 'start'
        ? l10n.start
        : action == 'stop'
            ? l10n.stop
            : l10n.restart;

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
      SnackBarHelper.showInfo(
          context, l10n.actioningService(actionText, serviceName));

      final success = await demoApiService.controlService(serviceId, action);

      if (mounted) {
        if (success) {
          final successMsg = action == 'start'
              ? l10n.serviceStartedSuccessfully
              : action == 'stop'
                  ? l10n.serviceStoppedSuccessfully
                  : l10n.serviceRestartedSuccessfully;
          SnackBarHelper.showSuccess(context, successMsg);
          await Future.delayed(const Duration(seconds: 1));
          if (mounted) {
            _viewModel.loadDashboardData();
          }
        } else {
          SnackBarHelper.showError(context, l10n.serviceActionFailed);
        }
      }
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showError(
            context, '${l10n.error}: ${e.toString()}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final demoApiService = context.watch<DemoApiService>();
    final isDemoMode = demoApiService.isDemoMode;

    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(AppConstants.appName),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _viewModel.isLoading
                    ? null
                    : _viewModel.loadDashboardData,
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
              // Demo mode banner
              if (isDemoMode)
                Builder(
                  builder: (context) {
                    final l10n = AppLocalizations.of(context)!;
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.warning,
                            AppColors.warning,
                          ],
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.play_circle_outline,
                              color: AppColors.onPrimary),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              l10n.demoModeIndicator,
                              style: const TextStyle(
                                color: AppColors.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Icon(Icons.info_outline,
                              color: AppColors.onPrimary.withValues(alpha: 0.8),
                              size: 20),
                        ],
                      ),
                    );
                  },
                ),
              // Main content
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _viewModel.loadDashboardData,
                  child: _buildBody(l10n),
                ),
              ),
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

    return ListView(
      padding: const EdgeInsets.all(AppConstants.standardPadding),
      children: [
        if (_viewModel.systemInfo != null)
          ResourceUsageSection(systemInfo: _viewModel.systemInfo!),
        const SizedBox(height: 24),
        if (_viewModel.thermalSensors != null)
          ThermalSensorsSection(sensors: _viewModel.thermalSensors!),
        if (_viewModel.thermalSensors != null) const SizedBox(height: 24),
        ServicesSection(
          servicesData: _viewModel.servicesData,
          onServiceControl: _controlService,
        ),
        const SizedBox(height: 24),
        GatewaysSection(gateways: _viewModel.gateways),
        const SizedBox(height: 24),
      ],
    );
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
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _viewModel.loadDashboardData,
            icon: const Icon(Icons.refresh),
            label: Text(l10n.retry),
          ),
        ],
      ),
    );
  }
}
