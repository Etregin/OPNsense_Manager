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
import '../../utils/constants.dart';

/// Widget for displaying VPN connection summary statistics
class VPNSummaryCards extends StatelessWidget {
  final int connectedCount;
  final int totalCount;

  const VPNSummaryCards({
    super.key,
    required this.connectedCount,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(AppConstants.standardPadding),
      child: Row(
        children: [
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(
                      Icons.vpn_lock,
                      size: 32,
                      color: connectedCount > 0 ? Colors.green : Colors.grey,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$connectedCount / $totalCount',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: connectedCount > 0 ? Colors.green : Colors.grey,
                      ),
                    ),
                    Text(l10n.connected),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Icon(
                      Icons.router,
                      size: 32,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$totalCount',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    Text(l10n.totalVPNs),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


