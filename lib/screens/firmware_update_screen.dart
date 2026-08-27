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
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/firmware_update_status.dart';
import '../screens/dashboard_screen.dart';
import '../services/demo_api_service.dart';
import '../utils/single_init_mixin.dart';
import '../utils/snackbar_helper.dart';
import '../viewmodels/firmware_update_view_model.dart';
import '../widgets/common/confirmation_dialog.dart';
import '../widgets/common/error_display.dart';
import '../l10n/app_localizations.dart';

/// Dedicated screen for checking firmware updates and installing them.
///
/// Navigated to from [SystemInfoScreen] via [Navigator.push].
/// Owns its own [FirmwareUpdateViewModel] and starts the check automatically.
class FirmwareUpdateScreen extends StatefulWidget {
  const FirmwareUpdateScreen({super.key});

  @override
  State<FirmwareUpdateScreen> createState() => _FirmwareUpdateScreenState();
}

class _FirmwareUpdateScreenState extends State<FirmwareUpdateScreen>
    with SingleInitMixin {
  late FirmwareUpdateViewModel _viewModel;

  // Auto-scroll controller for the log terminal.
  final ScrollController _logScrollController = ScrollController();

  @override
  void onFirstDependency() {
    _viewModel = FirmwareUpdateViewModel(context.read<DemoApiService>());
    _viewModel.addListener(_scrollToBottom);
    _viewModel.checkForUpdates();
  }

  @override
  void dispose() {
    _viewModel.removeListener(_scrollToBottom);
    _viewModel.dispose();
    _logScrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_logScrollController.hasClients) {
        _logScrollController.animateTo(
          _logScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        final busy = _viewModel.isChecking || _viewModel.isUpdating;
        final hasLog = _viewModel.checkLog?.isNotEmpty == true;

        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.checkForUpdates),
            actions: [
              // Copy log to clipboard — visible whenever there is log content.
              if (hasLog)
                IconButton(
                  icon: const Icon(Icons.copy_outlined),
                  tooltip: 'Copy output',
                  onPressed: () => _copyLog(context),
                ),
              // Re-check button — only shown when idle.
              if (!busy)
                IconButton(
                  icon: const Icon(Icons.refresh),
                  tooltip: l10n.refresh,
                  onPressed: _viewModel.checkForUpdates,
                ),
            ],
          ),
          body: _buildBody(l10n),
        );
      },
    );
  }

  // ── Body dispatcher ────────────────────────────────────────────────────────

  Widget _buildBody(AppLocalizations l10n) {
    // Update complete — reboot prompt
    if (_viewModel.isUpdateComplete) {
      return _buildUpdateComplete(l10n);
    }

    // Checking or installing — show live log terminal
    if (_viewModel.isChecking || _viewModel.isUpdating) {
      return _buildLogView(
        title: _viewModel.isUpdating
            ? l10n.installingUpdate
            : l10n.checkingForUpdates,
        isRunning: true,
      );
    }

    // Error with no results
    if (_viewModel.errorMessage != null && _viewModel.firmwareStatus == null) {
      // If we have log output from the failed run, show it below the error.
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: ErrorDisplay(
              message: _viewModel.errorMessage!,
              onRetry: _viewModel.checkForUpdates,
            ),
          ),
          if (_viewModel.checkLog?.isNotEmpty == true)
            Expanded(child: _buildLogView(title: 'Output', isRunning: false)),
        ],
      );
    }

    final status = _viewModel.firmwareStatus;
    if (status == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // Results — show summary + optional full log below
    return _buildResultsView(l10n, status);
  }

  // ── Log terminal view ──────────────────────────────────────────────────────

  Widget _buildLogView({required String title, required bool isRunning}) {
    final theme = Theme.of(context);
    final log = _viewModel.checkLog ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header bar
        Container(
          color: theme.colorScheme.surfaceContainerHighest,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              if (isRunning) ...[
                SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Text(title,
                  style: theme.textTheme.labelMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        // Scrollable monospace terminal
        Expanded(
          child: Container(
            color: const Color(0xFF1E1E1E),
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
              controller: _logScrollController,
              child: SelectableText(
                log,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  color: Color(0xFFD4D4D4),
                  height: 1.5,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Results view ───────────────────────────────────────────────────────────

  Widget _buildResultsView(AppLocalizations l10n, FirmwareUpdateStatus status) {
    final theme = Theme.of(context);
    final upToDate = !status.updatesAvailable;

    return Column(
      children: [
        // Summary card (fixed height content)
        Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Version row
                  Row(
                    children: [
                      Icon(
                        upToDate
                            ? Icons.check_circle_outline
                            : Icons.system_update_outlined,
                        color: upToDate
                            ? theme.colorScheme.primary
                            : theme.colorScheme.error,
                      ),
                      const SizedBox(width: 8),
                      if (upToDate)
                        Text('Up to date',
                            style: theme.textTheme.titleMedium)
                      else ...[
                        Text(status.currentVersion,
                            style: theme.textTheme.titleMedium),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          status.latestVersion,
                          style: theme.textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ],
                  ),
                  if (status.updatesAvailable) ...[
                    const SizedBox(height: 6),
                    Text('${status.totalPackageCount} package(s) to update',
                        style: theme.textTheme.bodySmall),
                    if (status.downloadSize.isNotEmpty)
                      Text('Download: ${status.downloadSize}',
                          style: theme.textTheme.bodySmall),
                    if (status.needsReboot) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.warning_amber_outlined,
                              size: 16, color: theme.colorScheme.error),
                          const SizedBox(width: 4),
                          Text(
                            'Reboot required after update',
                            style: theme.textTheme.bodySmall
                                ?.copyWith(color: theme.colorScheme.error),
                          ),
                        ],
                      ),
                    ],
                  ],
                  if (status.lastCheck.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text('Last checked: ${status.lastCheck}',
                        style: theme.textTheme.bodySmall),
                  ],
                  // Changelog
                  if (status.changelogText != null) ...[
                    const SizedBox(height: 8),
                    ExpansionTile(
                      tilePadding: EdgeInsets.zero,
                      title: const Text("What's New"),
                      subtitle: status.changelogDate != null
                          ? Text(status.changelogDate!)
                          : null,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child:
                              Text(status.changelogText!, softWrap: true),
                        ),
                      ],
                    ),
                  ],
                  // Package lists
                  if (status.upgradeCount > 0) ...[
                    const SizedBox(height: 4),
                    ExpansionTile(
                      tilePadding: EdgeInsets.zero,
                      title: Text(
                          'Packages to Upgrade (${status.upgradeCount})'),
                      children: status.upgradePackages
                          .map((pkg) => ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(pkg['name']!),
                                subtitle: Text(
                                    '${pkg['current_version']} → ${pkg['new_version']}'),
                                dense: true,
                              ))
                          .toList(),
                    ),
                  ],
                  if (status.newPackageCount > 0) ...[
                    const SizedBox(height: 4),
                    ExpansionTile(
                      tilePadding: EdgeInsets.zero,
                      title:
                          Text('New Packages (${status.newPackageCount})'),
                      children: status.newPackages
                          .map((pkg) => ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(pkg['name']!),
                                subtitle: Text('NEW · ${pkg['version']}'),
                                dense: true,
                              ))
                          .toList(),
                    ),
                  ],
                  // Install Update button
                  if (status.updatesAvailable) ...[
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.error,
                          foregroundColor: theme.colorScheme.onError,
                        ),
                        icon: const Icon(Icons.system_update_alt),
                        label: Text(
                            '${l10n.installUpdate} (${status.totalPackageCount} packages)'),
                        onPressed: () => _confirmAndUpdate(l10n, status),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        // Full check log below the summary card
        if (_viewModel.checkLog?.isNotEmpty == true)
          Expanded(
            child: _buildLogView(title: 'Check output', isRunning: false),
          ),
      ],
    );
  }

  // ── Update complete ────────────────────────────────────────────────────────

  Widget _buildUpdateComplete(AppLocalizations l10n) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Icon(Icons.check_circle_outline,
                      size: 48, color: theme.colorScheme.primary),
                  const SizedBox(height: 12),
                  Text(
                    l10n.updateComplete,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  if (_viewModel.updateRequiresReboot) ...[
                    const SizedBox(height: 8),
                    Text(l10n.rebootRequired,
                        style: theme.textTheme.bodyMedium,
                        textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.error,
                          foregroundColor: theme.colorScheme.onError,
                        ),
                        icon: const Icon(Icons.restart_alt),
                        label: Text(l10n.rebootNow),
                        onPressed: _rebootFirewall,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        // Install log remains visible after completion
        if (_viewModel.checkLog?.isNotEmpty == true)
          Expanded(
            child: _buildLogView(title: 'Install output', isRunning: false),
          ),
      ],
    );
  }

  // ── Actions ────────────────────────────────────────────────────────────────

  Future<void> _copyLog(BuildContext context) async {
    final log = _viewModel.checkLog ?? '';
    await Clipboard.setData(ClipboardData(text: log));
    if (context.mounted) {
      SnackBarHelper.showInfo(context, 'Output copied to clipboard');
    }
  }

  Future<void> _confirmAndUpdate(
      AppLocalizations l10n, FirmwareUpdateStatus status) async {
    final confirmed = await ConfirmationDialog.show(
      context: context,
      title: l10n.installUpdateConfirmTitle,
      message: l10n.installUpdateConfirmMessage(status.totalPackageCount),
      confirmText: l10n.installUpdate,
      cancelText: l10n.cancel,
      isDestructive: true,
    );
    if (confirmed == true && mounted) {
      unawaited(_viewModel.performUpdate());
    }
  }

  Future<void> _rebootFirewall() async {
    final apiService = context.read<DemoApiService>();
    try {
      await apiService.rebootSystem();
    } catch (_) {
      // Ignore — the firewall goes offline during reboot.
    }
    if (mounted) {
      SnackBarHelper.showInfo(context, 'Rebooting firewall…');
      unawaited(
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
        ),
      );
    }
  }
}
