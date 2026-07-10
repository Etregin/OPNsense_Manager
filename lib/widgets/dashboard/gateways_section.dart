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
import '../../utils/app_colors.dart';

/// Widget for displaying gateways status
class GatewaysSection extends StatefulWidget {
  final List<Map<String, dynamic>> gateways;

  const GatewaysSection({
    super.key,
    required this.gateways,
  });

  @override
  State<GatewaysSection> createState() => _GatewaysSectionState();
}

class _GatewaysSectionState extends State<GatewaysSection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.gateways,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.router),
                title: Text(l10n.gateways),
                subtitle: Text('${widget.gateways.length} ${l10n.gateways}'),
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
                ...widget.gateways.map((gateway) => _buildGatewayTile(gateway)),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGatewayTile(Map<String, dynamic> gateway) {
    final l10n = AppLocalizations.of(context)!;
    // Handle different possible field names from OPNsense API
    final name = (gateway['name'] ??
            gateway['gateway'] ??
            gateway['interface'] ??
            l10n.unknown)
        .toString();
    final address = (gateway['address'] ??
            gateway['gateway_ip'] ??
            gateway['ip'] ??
            l10n.notAvailable)
        .toString();
    final status =
        (gateway['status'] ?? gateway['status_translated'] ?? l10n.unknown)
            .toString()
            .toLowerCase();
    final delay = (gateway['delay'] ??
            gateway['rtt'] ??
            gateway['latency'] ??
            l10n.notAvailable)
        .toString();
    final loss = (gateway['loss'] ??
            gateway['loss_percentage'] ??
            gateway['packet_loss'] ??
            l10n.notAvailable)
        .toString();

    // Check various status indicators
    final isOnline = status.contains('online') ||
        status.contains('up') ||
        status == 'none' ||
        gateway['status_translated']
                ?.toString()
                .toLowerCase()
                .contains('online') ==
            true;

    return ListTile(
      dense: true,
      leading: Icon(
        isOnline ? Icons.check_circle : Icons.error,
        color: isOnline ? AppColors.success : AppColors.error,
        size: 20,
      ),
      title: Text(name),
      subtitle: Text(address),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            delay.toString(),
            style: TextStyle(
              fontSize: 12,
              color: isOnline ? AppColors.success : AppColors.error,
            ),
          ),
          Text(
            loss.toString(),
            style: TextStyle(
              fontSize: 12,
              color: isOnline ? AppColors.success : AppColors.error,
            ),
          ),
        ],
      ),
    );
  }
}


