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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.serviceStartedSuccessfully),
              backgroundColor: Colors.green,
            ),
          );
          await _loadSessions();
        }
      } else {
        if (!mounted) return;
        throw Exception(AppLocalizations.of(context)!.failedToStartService);
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.errorStartingService(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.serviceStoppedSuccessfully),
              backgroundColor: Colors.green,
            ),
          );
          await _loadSessions();
        }
      } else {
        if (!mounted) return;
        throw Exception(AppLocalizations.of(context)!.failedToStopService);
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.errorStoppingService(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _actionLoading.remove(id);
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.serviceRestartedSuccessfully),
              backgroundColor: Colors.green,
            ),
          );
          await _loadSessions();
        }
      } else {
        throw Exception('Failed to restart service');
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.errorRestartingService(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
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
              'Error loading sessions',
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
              'No sessions found',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'There are no OpenVPN sessions configured',
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
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.category_outlined,
                                  size: 16,
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Type: ${session.type}',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      _buildStatusBadge(session),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (session.canStopOrRestart) ...[
                        OutlinedButton.icon(
                          onPressed: isLoading ? null : () => _restartService(session.id),
                          icon: isLoading
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.restart_alt, size: 18),
                          label: const Text('Restart'),
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
                          label: const Text('Stop'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
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
                          label: const Text('Start'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
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

  Widget _buildStatusBadge(OpenvpnSession session) {
    final Color color;
    final String label;
    final IconData icon;

    if (session.status == 'ok') {
      color = Colors.green;
      label = 'Running';
      icon = Icons.check_circle;
    } else if (session.status == null) {
      color = Colors.grey;
      label = 'Stopped';
      icon = Icons.stop_circle;
    } else {
      color = Colors.orange;
      label = session.status ?? 'Unknown';
      icon = Icons.warning;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
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


