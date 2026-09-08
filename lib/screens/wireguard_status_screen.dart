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
import '../services/demo_api_service.dart';
import '../utils/app_colors.dart';
import '../viewmodels/wireguard_status_view_model.dart';
import '../widgets/app_drawer.dart';
import '../widgets/wireguard/status_card.dart';
import '../l10n/app_localizations.dart';

/// Screen for displaying WireGuard service status
class WireGuardStatusScreen extends StatefulWidget {
  const WireGuardStatusScreen({super.key});

  @override
  State<WireGuardStatusScreen> createState() => _WireGuardStatusScreenState();
}

class _WireGuardStatusScreenState extends State<WireGuardStatusScreen> {
  WireGuardStatusViewModel? _viewModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_viewModel == null) {
      final apiService = context.read<DemoApiService>();
      _viewModel = WireGuardStatusViewModel(apiService);
    }
  }

  @override
  void dispose() {
    _viewModel?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    // Return loading indicator if view model is not yet initialized
    if (_viewModel == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(l10n.wireguardStatus),
        ),
        drawer: const AppDrawer(currentRoute: 'wireguard_status'),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return ListenableBuilder(
      listenable: _viewModel!,
      builder: (context, _) {
        final statusItems = _viewModel!.statusItems;
        final isLoading = _viewModel!.isLoading;
        final errorMessage = _viewModel!.errorMessage;
        final hasData = _viewModel!.hasData;

        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.wireguardStatus),
            actions: [
              // Refresh button
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: isLoading ? null : _viewModel!.refresh,
                tooltip: l10n.refresh,
              ),
            ],
          ),
          drawer: const AppDrawer(currentRoute: 'wireguard_status'),
          body: isLoading && !hasData
              ? const Center(child: CircularProgressIndicator())
              : errorMessage != null && !hasData
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 48,
                            color: AppColors.error,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.error,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Text(
                              errorMessage,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: _viewModel!.refresh,
                            icon: const Icon(Icons.refresh),
                            label: Text(l10n.retry),
                          ),
                        ],
                      ),
                    )
                  : !hasData
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.vpn_lock,
                                size: 48,
                                color: AppColors.disabled,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                l10n.noWireguardStatusDataAvailable,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                l10n.checkIfWireguardIsConfiguredAndRunning,
                                 style: const TextStyle(color: AppColors.disabled),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _viewModel!.refresh,
                          child: Column(
                            children: [
                              // Show loading indicator at top if refreshing
                              if (isLoading) const LinearProgressIndicator(),
                              
                              // Card-based list
                              Expanded(
                                child: ListView.builder(
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  itemCount: statusItems.length,
                                  itemBuilder: (context, index) {
                                    final item = statusItems[index];
                                    return StatusCard(
                                      item: item,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
        );
      },
    );
  }
}


