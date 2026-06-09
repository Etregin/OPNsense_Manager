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
import '../../l10n/app_localizations.dart';

/// Callback for service control actions
typedef ServiceControlCallback = Future<void> Function(
  String serviceId,
  String action,
  String serviceName,
);

/// Widget for displaying services status
class ServicesSection extends StatefulWidget {
  final Map<String, dynamic> servicesData;
  final ServiceControlCallback onServiceControl;

  const ServicesSection({
    super.key,
    required this.servicesData,
    required this.onServiceControl,
  });

  @override
  State<ServicesSection> createState() => _ServicesSectionState();
}

class _ServicesSectionState extends State<ServicesSection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final services = widget.servicesData['services'] as List<dynamic>? ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.services,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.apps),
                title: Text(l10n.services),
                subtitle: Text('${services.length} ${l10n.services}'),
                trailing: Icon(
                  _isExpanded ? Icons.expand_less : Icons.expand_more,
                ),
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
              ),
              if (_isExpanded) ...[
                const Divider(height: 1),
                ...services.map((service) => _buildServiceTile(service)),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildServiceTile(Map<String, dynamic> service) {
    final l10n = AppLocalizations.of(context)!;
    // Handle different possible field names from OPNsense API
    // Prioritize description field for display
    final name = (service['description'] ??
            service['name'] ??
            service['id'] ??
            l10n.unknown)
        .toString();
    final serviceId = (service['id'] ?? service['name'] ?? name).toString();
    final status = (service['status'] ?? service['running'] ?? 'unknown').toString();
    final isRunning = status.toLowerCase() == 'running' ||
        status == '1' ||
        service['running'] == '1' ||
        service['running'] == true;

    return ListTile(
      dense: true,
      leading: Icon(
        isRunning ? Icons.check_circle : Icons.cancel,
        color: isRunning ? Colors.green : Colors.red,
        size: 20,
      ),
      title: Text(name),
      subtitle: Text(isRunning ? l10n.running : l10n.stopped),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(
              isRunning ? Icons.stop : Icons.play_arrow,
              size: 20,
            ),
            onPressed: () => widget.onServiceControl(
              serviceId,
              isRunning ? 'stop' : 'start',
              name,
            ),
            tooltip: isRunning ? l10n.stop : l10n.start,
          ),
          IconButton(
            icon: const Icon(Icons.refresh, size: 20),
            onPressed: () => widget.onServiceControl(serviceId, 'restart', name),
            tooltip: l10n.restart,
          ),
        ],
      ),
    );
  }
}


