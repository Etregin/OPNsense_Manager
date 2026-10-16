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
import '../l10n/app_localizations.dart';
import '../models/openvpn_session.dart';
import '../services/demo_api_service.dart';
import '../utils/app_colors.dart';
import '../utils/formatters.dart';
import '../utils/snackbar_helper.dart';
import '../widgets/common/confirmation_dialog.dart';

/// Tab widget for displaying OpenVPN sessions
class OpenvpnSessionsTab extends StatefulWidget {
  final DemoApiService apiService;
  final void Function(VoidCallback)? onRegisterRefresh;

  const OpenvpnSessionsTab({
    super.key,
    required this.apiService,
    this.onRegisterRefresh,
  });

  @override
  State<OpenvpnSessionsTab> createState() => _OpenvpnSessionsTabState();
}

class _OpenvpnSessionsTabState extends State<OpenvpnSessionsTab> {
  List<OpenvpnSession> _sessions = [];
  bool _isLoading = false;
  String? _error;
  final Map<String, bool> _actionLoading = {};

  @override
  void initState() {
    super.initState();
    widget.onRegisterRefresh?.call(_loadSessions);
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await widget.apiService.searchSessions(
        current: 1,
        rowCount: 50,
      );

      if (mounted) {
        setState(() {
          _sessions = response.rows;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _startService(String id) async {
    setState(() {
      _actionLoading[id] = true;
    });

    try {
      final result = await widget.apiService.startService(id);
      
      if (result['result'] == 'ok') {
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          SnackBarHelper.showSuccess(context, l10n.serviceStartedSuccessfully);
          await _loadSessions();
        }
      } else {
        if (!mounted) return;
        throw Exception(AppLocalizations.of(context)!.failedToStartService);
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        SnackBarHelper.showError(context, l10n.errorStartingService(e.toString()));
      }
    } finally {
      if (mounted) {
        setState(() {
          _actionLoading.remove(id);
        });
      }
    }
  }

  Future<void> _stopService(String id) async {
    setState(() {
      _actionLoading[id] = true;
    });

    try {
      final result = await widget.apiService.stopService(id);
      
      if (result['result'] == 'ok') {
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          SnackBarHelper.showSuccess(context, l10n.serviceStoppedSuccessfully);
          await _loadSessions();
        }
      } else {
        if (!mounted) return;
        throw Exception(AppLocalizations.of(context)!.failedToStopService);
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        SnackBarHelper.showError(context, l10n.errorStoppingService(e.toString()));
      }
    } finally {
      if (mounted) {
        setState(() {
          _actionLoading.remove(id);
        });
      }
    }
  }

  Future<void> _killSession(OpenvpnSession session) async {
    final sessionId = session.killSessionId;
    if (sessionId == null) return;

    final l10n = AppLocalizations.of(context)!;
    final confirmed = await ConfirmationDialog.show(
      context: context,
      title: l10n.killSession,
      message: l10n.confirmKillSession(sessionId),
      confirmText: l10n.killSession,
      cancelText: l10n.cancel,
      isDestructive: true,
    );
    if (!confirmed || !mounted) return;

    setState(() {
      _actionLoading[session.id] = true;
    });

    try {
      await widget.apiService.killSession(session.serverId, sessionId);

      if (mounted) {
        SnackBarHelper.showSuccess(context, l10n.sessionKilledSuccessfully);
        await _loadSessions();
      }
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showError(context, l10n.errorKillingSession(e.toString()));
      }
    } finally {
      if (mounted) {
        setState(() {
          _actionLoading.remove(session.id);
        });
      }
    }
  }

  Future<void> _restartService(String id) async {
    setState(() {
      _actionLoading[id] = true;
    });

    try {
      final result = await widget.apiService.restartService(id);
      
      if (result['result'] == 'ok') {
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          SnackBarHelper.showSuccess(context, l10n.serviceRestartedSuccessfully);
          await _loadSessions();
        }
      } else {
        throw Exception('Failed to restart service');
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        SnackBarHelper.showError(context, l10n.errorRestartingService(e.toString()));
      }
    } finally {
      if (mounted) {
        setState(() {
          _actionLoading.remove(id);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_isLoading && _sessions.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.errorLoadingSessions,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loadSessions,
              icon: const Icon(Icons.refresh),
              label: Text(l10n.retry),
            ),
          ],
        ),
      );
    }

    if (_sessions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.connect_without_contact_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.noSessionsFound,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.noOpenvpnSessionsConfigured,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadSessions,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _sessions.length,
        itemBuilder: (context, index) {
          final session = _sessions[index];
          final isLoading = _actionLoading[session.id] ?? false;

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              session.description,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _buildStatusBadge(session, l10n),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 4),
                  _buildInfoRow(context, l10n.type, session.type),
                  if (session.hasClientInfo) ...[
                    _buildInfoRow(context, l10n.commonName, session.commonName),
                    _buildInfoRow(context, l10n.username, session.username),
                    _buildInfoRow(context, l10n.realAddress, session.realAddress),
                    _buildInfoRow(context, l10n.virtualAddress, session.virtualAddress),
                    _buildInfoRow(context, l10n.connectedSince, session.connectedSince),
                    _buildInfoRow(
                      context,
                      l10n.bytesSent,
                      session.bytesSent == null ? null : Formatters.formatBytes(session.bytesSent!),
                    ),
                    _buildInfoRow(
                      context,
                      l10n.bytesReceived,
                      session.bytesReceived == null ? null : Formatters.formatBytes(session.bytesReceived!),
                    ),
                    _buildInfoRow(context, l10n.dataChannelCipher, session.dataChannelCipher),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (session.hasClientInfo)
                        OutlinedButton.icon(
                          onPressed: isLoading ? null : () => _killSession(session),
                          icon: isLoading
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.link_off, size: 18),
                          label: Text(l10n.killSession),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.error,
                          ),
                        )
                      else if (session.canStopOrRestart) ...[
                        OutlinedButton.icon(
                          onPressed: isLoading ? null : () => _restartService(session.id),
                          icon: isLoading
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.restart_alt, size: 18),
                          label: Text(l10n.restart),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton.icon(
                          onPressed: isLoading ? null : () => _stopService(session.id),
                          icon: isLoading
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.stop, size: 18),
                          label: Text(l10n.stop),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.error,
                          ),
                        ),
                      ] else if (session.canStart) ...[
                        ElevatedButton.icon(
                          onPressed: isLoading ? null : () => _startService(session.id),
                          icon: isLoading
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.play_arrow, size: 18),
                          label: Text(l10n.start),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.success,
                            foregroundColor: AppColors.onPrimary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String? value) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(OpenvpnSession session, AppLocalizations l10n) {
    final Color color;
    final String label;
    final IconData icon;

    if (session.status == 'ok') {
      color = AppColors.success;
      label = l10n.ok;
      icon = Icons.check_circle;
    } else if (session.status == null) {
      color = AppColors.disabled;
      label = l10n.stopped;
      icon = Icons.stop_circle;
    } else {
      color = AppColors.warning;
      label = session.status ?? l10n.unknown;
      icon = Icons.warning;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: AppColors.opacitySubtle),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}


