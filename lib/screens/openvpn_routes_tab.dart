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
import '../models/openvpn_route.dart';
import '../services/opnsense_api_service.dart';
import '../l10n/app_localizations.dart';

/// Tab widget for displaying OpenVPN routes
class OpenvpnRoutesTab extends StatefulWidget {
  final OPNsenseApiService apiService;
  final void Function(VoidCallback)? onRegisterRefresh;

  const OpenvpnRoutesTab({
    super.key,
    required this.apiService,
    this.onRegisterRefresh,
  });

  @override
  State<OpenvpnRoutesTab> createState() => _OpenvpnRoutesTabState();
}

class _OpenvpnRoutesTabState extends State<OpenvpnRoutesTab> {
  List<OpenvpnRoute> _routes = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    widget.onRegisterRefresh?.call(_loadRoutes);
    _loadRoutes();
  }

  Future<void> _loadRoutes() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await widget.apiService.searchRoutes(
        current: 1,
        rowCount: 50,
      );

      if (mounted) {
        setState(() {
          _routes = response.rows;
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_isLoading && _routes.isEmpty) {
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
              'Error loading routes',
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
              onPressed: _loadRoutes,
              icon: const Icon(Icons.refresh),
              label: Text(l10n.retry),
            ),
          ],
        ),
      );
    }

    if (_routes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.route_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(height: 16),
            Text(
              'No routes configured',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'There are no OpenVPN routes configured',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadRoutes,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _routes.length,
        itemBuilder: (context, index) {
          final route = _routes[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Icon(
                  Icons.route,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
              title: Text(
                route.network ?? 'Unknown Network',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (route.gateway != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.router,
                          size: 16,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        const SizedBox(width: 4),
                        Text('Gateway: ${route.gateway}'),
                      ],
                    ),
                  ],
                  if (route.description != null && route.description!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.description_outlined,
                          size: 16,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            route.description!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
              isThreeLine: route.gateway != null || 
                          (route.description != null && route.description!.isNotEmpty),
            ),
          );
        },
      ),
    );
  }
}

// Made with Bob
