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
import '../l10n/app_localizations.dart';
import '../models/openvpn_log_search_response.dart';
import '../services/demo_api_service.dart';
import '../constants/routes.dart';
import 'log_file_screen.dart';

/// WireGuard Log File screen — thin wrapper around the shared [LogFileScreen].
class WireGuardLogFileScreen extends StatelessWidget {
  const WireGuardLogFileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final apiService = context.read<DemoApiService>();

    // Adapt the WireGuard-specific signature to the shared LogFetcher typedef.
    // getWireGuardLogs does not support `current`/`sort` — pagination is handled
    // by `rowCount` only, which maps to the same parameter.
    Future<OpenvpnLogSearchResponse> fetcher({
      int current = 1,
      int rowCount = 50,
      Map<String, dynamic>? sort,
      List<String>? severity,
      double? validFrom,
    }) =>
        apiService.getWireGuardLogs(
          rowCount: rowCount,
          severity: severity,
          validFrom: validFrom,
        );

    return LogFileScreen(
      title: l10n.wireguardLogs,
      currentRoute: Routes.wireguardLogs,
      fetcher: fetcher,
      defaultSeverities: const [
        'Emergency',
        'Alert',
        'Critical',
        'Error',
        'Warning',
      ],
    );
  }
}
