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
import '../utils/single_init_mixin.dart';
import '../viewmodels/unbound_dns_view_model.dart';
import '../widgets/app_drawer.dart';
import '../widgets/common/error_display.dart';
import '../widgets/unbound/unbound_details_tab.dart';
import '../widgets/unbound/unbound_overview_tab.dart';
import '../widgets/unbound/unbound_settings_tab.dart';

class UnboundDnsScreen extends StatefulWidget {
  const UnboundDnsScreen({super.key});

  @override
  State<UnboundDnsScreen> createState() => _UnboundDnsScreenState();
}

class _UnboundDnsScreenState extends State<UnboundDnsScreen>
    with SingleInitMixin, TickerProviderStateMixin {
  late UnboundDnsViewModel _viewModel;
  TabController? _tabController;
  int _currentTabCount = 0;

  @override
  void onFirstDependency() {
    _viewModel = UnboundDnsViewModel(context.read<DemoApiService>());
    _viewModel.addListener(_onViewModelChanged);
    _viewModel.loadInitial();
  }

  void _onViewModelChanged() {
    if (_viewModel.isLoading && _viewModel.settings == null && _viewModel.totals == null) {
      // Still waiting for initial fetch to determine if enabled
      if (mounted) setState(() {});
      return;
    }

    final expectedTabCount = _viewModel.isOverviewEnabled ? 3 : 1;
    if (_tabController == null || _currentTabCount != expectedTabCount) {
      _tabController?.dispose();
      _currentTabCount = expectedTabCount;
      _tabController = TabController(length: _currentTabCount, vsync: this);
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isEnabled = _viewModel.isOverviewEnabled;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.unboundDns),
        bottom: _tabController != null
            ? TabBar(
                controller: _tabController,
                tabs: isEnabled
                    ? [
                        Tab(text: l10n.unboundOverview),
                        Tab(text: l10n.unboundDetails),
                        Tab(text: l10n.unboundSettings),
                      ]
                    : [
                        Tab(text: l10n.unboundSettings),
                      ],
              )
            : null,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: l10n.refresh,
            onPressed: _viewModel.isLoading ? null : _viewModel.refresh,
          ),
        ],
      ),
      drawer: const AppDrawer(currentRoute: Routes.unboundDns),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          if (_viewModel.isLoading && _viewModel.settings == null && _viewModel.totals == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_viewModel.errorMessage != null && !_viewModel.isActionLoading && _viewModel.totals == null && _viewModel.settings == null) {
            return ErrorDisplay(
              message: _viewModel.errorMessage!,
              onRetry: _viewModel.loadInitial,
            );
          }

          if (_tabController == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return TabBarView(
            controller: _tabController,
            children: isEnabled
                ? [
                    UnboundOverviewTab(
                      viewModel: _viewModel,
                      onClientFilterSelected: (client, timeStart, timeEnd) {
                        _viewModel.filterQueriesByClientTime(
                          client: client,
                          timeStart: timeStart,
                          timeEnd: timeEnd,
                        );
                        _tabController?.animateTo(1);
                      },
                    ),
                    UnboundDetailsTab(viewModel: _viewModel),
                    UnboundSettingsTab(viewModel: _viewModel),
                  ]
                : [
                    UnboundSettingsTab(viewModel: _viewModel),
                  ],
          );
        },
      ),
    );
  }
}
