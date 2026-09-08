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
import '../../utils/constants.dart';
import '../../viewmodels/unbound_dns_view_model.dart';
import 'unbound_client_activity_chart.dart';
import 'unbound_domains_section.dart';
import 'unbound_metrics_header.dart';
import 'unbound_rolling_chart.dart';

class UnboundOverviewTab extends StatelessWidget {
  final UnboundDnsViewModel viewModel;
  final void Function(String client, int timeStart, int timeEnd)? onClientFilterSelected;

  const UnboundOverviewTab({
    super.key,
    required this.viewModel,
    this.onClientFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.standardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UnboundMetricsHeader(totals: viewModel.totals),
          const SizedBox(height: AppConstants.standardPadding),
          UnboundRollingChart(
            points: viewModel.rollingPoints,
            selectedDurationHours: viewModel.selectedRollingDurationHours,
            isLogarithmic: viewModel.isRollingLogarithmic,
            onDurationChanged: viewModel.setRollingDurationHours,
            onLogarithmicChanged: viewModel.toggleRollingLogarithmic,
          ),
          const SizedBox(height: AppConstants.standardPadding),
          UnboundClientActivityChart(
            points: viewModel.clientActivityPoints,
            selectedDurationHours: viewModel.selectedClientDurationHours,
            isLogarithmic: viewModel.isClientLogarithmic,
            onDurationChanged: viewModel.setClientDurationHours,
            onLogarithmicChanged: viewModel.toggleClientLogarithmic,
            onClientSpotTapped: onClientFilterSelected,
          ),
          const SizedBox(height: AppConstants.standardPadding),
          UnboundDomainsSection(
            topPassed: viewModel.totals?.top ?? [],
            topBlocked: viewModel.totals?.topBlocked ?? [],
            selectedLimit: viewModel.selectedDomainLimit,
            onLimitChanged: viewModel.setDomainLimit,
          ),
        ],
      ),
    );
  }
}
