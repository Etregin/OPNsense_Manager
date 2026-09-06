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
import '../services/demo_api_service.dart';
import '../constants/routes.dart';
import 'log_file_screen.dart';

/// OpenVPN Log File screen — thin wrapper around the shared [LogFileScreen].
class OpenvpnLogFileScreen extends StatelessWidget {
  const OpenvpnLogFileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final apiService = context.read<DemoApiService>();
    return LogFileScreen(
      title: l10n.openvpnLogFile,
      currentRoute: Routes.openvpnLogs,
      fetcher: apiService.searchOpenvpnLogs,
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
