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
import '../utils/constants.dart';
import '../utils/formatters.dart';
import '../utils/single_init_mixin.dart';
import '../viewmodels/system_info_view_model.dart';
import '../widgets/app_drawer.dart';
import '../widgets/common/error_display.dart';
import '../l10n/app_localizations.dart';

/// System information screen showing detailed system data
class SystemInfoScreen extends StatefulWidget {
  const SystemInfoScreen({super.key});

  @override
  State<SystemInfoScreen> createState() => _SystemInfoScreenState();
}

class _SystemInfoScreenState extends State<SystemInfoScreen>
    with SingleInitMixin {
  late SystemInfoViewModel _viewModel;

  @override
  void onFirstDependency() {
    _viewModel = SystemInfoViewModel(context.read<DemoApiService>());
    _viewModel.loadSystemInfo();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.systemInformation),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _viewModel.isLoading ? null : _viewModel.loadSystemInfo,
                tooltip: l10n.refresh,
              ),
            ],
          ),
          drawer: AppDrawer(
            currentRoute: 'system_info',
            systemInfo: _viewModel.systemInfo,
          ),
          body: RefreshIndicator(
            onRefresh: _viewModel.loadSystemInfo,
            child: _buildBody(l10n),
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
      return ErrorDisplay(
          message: _viewModel.errorMessage!, onRetry: _viewModel.loadSystemInfo);
    }

    final systemInfo = _viewModel.systemInfo!;
    return ListView(
      padding: const EdgeInsets.all(AppConstants.standardPadding),
      children: [
        _buildInfoCard(
          l10n.systemInformation,
          [
            _buildInfoRow(Icons.computer, l10n.hostname, systemInfo.hostname),
            _buildInfoRow(Icons.dns, l10n.systemType, systemInfo.type),
            _buildInfoRow(Icons.info_outline, l10n.versionLabel, systemInfo.version),
            _buildInfoRow(
                Icons.architecture, l10n.architecture, systemInfo.architecture),
            _buildInfoRow(Icons.memory, l10n.platform, systemInfo.platform),
            if (systemInfo.commit.isNotEmpty)
              _buildInfoRow(Icons.commit, l10n.gitCommit, systemInfo.commit),
            if (systemInfo.mirror.isNotEmpty)
              _buildInfoRow(
                  Icons.cloud, l10n.packageMirror, systemInfo.mirror),
            if (systemInfo.repositories.isNotEmpty)
              _buildInfoRow(
                  Icons.source, l10n.repository, systemInfo.repositories),
            if (systemInfo.updatedOn != null &&
                systemInfo.updatedOn!.isNotEmpty)
              _buildInfoRow(
                  Icons.update, l10n.lastUpdate, systemInfo.updatedOn!),
            _buildInfoRow(
              Icons.access_time,
              l10n.uptime,
              Formatters.formatUptime(systemInfo.uptime, context),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.standardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            ...children.map((child) {
              final index = children.indexOf(child);
              return Column(
                children: [
                  if (index > 0) const Divider(),
                  child,
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.onSurfaceVariant),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
