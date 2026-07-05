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
import 'app_colors.dart';

/// Returns the appropriate colour for a firewall action string.
///
/// Maps: `pass` → [AppColors.success], `block` → [AppColors.error],
///       `reject` → [AppColors.warning], default → [AppColors.disabled].
///
/// Used by firewall log entries and firewall rule cards to indicate action state.
Color firewallActionColor(String action) {
  switch (action.toLowerCase()) {
    case 'pass':
      return AppColors.success;
    case 'block':
      return AppColors.error;
    case 'reject':
      return AppColors.warning;
    default:
      return AppColors.disabled;
  }
}

/// Returns a colour representing resource usage at a given [progress] fraction.
///
/// Thresholds (higher fraction = more used = more critical):
/// - ≥ 90 % → [AppColors.error]
/// - ≥ 70 % → [AppColors.warning]
/// - < 70 % → [AppColors.success]
///
/// Used by [ProgressStatCard] (CPU, storage, etc.) and
/// [ThermalSensorsSection] analog helpers.
Color resourceUsageColor(double progress) {
  if (progress >= 0.9) return AppColors.error;
  if (progress >= 0.7) return AppColors.warning;
  return AppColors.success;
}

/// Returns a colour representing available bandwidth at a given [progress]
/// fill fraction (lower fill = more available = better).
///
/// Thresholds (higher fraction = less available = more critical):
/// - ≥ 75 % → [AppColors.error]
/// - ≥ 50 % → [AppColors.warning]
/// - < 50 % → [AppColors.success]
///
/// Used by [LiveNetworkMonitorScreen] bandwidth progress bars.
Color bandwidthProgressColor(double progress) {
  if (progress < 0.5) return AppColors.success;
  if (progress < 0.75) return AppColors.warning;
  return AppColors.error;
}

/// Returns a colour for a CPU/GPU/system [temperature] in °C.
///
/// Thresholds:
/// - > 80 °C → [AppColors.error]
/// - ≥ 60 °C → [AppColors.warning]
/// - < 60 °C → [AppColors.success]
///
/// Used by [ThermalSensorsSection].
Color thermalColor(double temperature) {
  if (temperature > 80) return AppColors.error;
  if (temperature >= 60) return AppColors.warning;
  return AppColors.success;
}

/// Returns the appropriate colour for a syslog severity level.
Color logLevelColor(String level, {required BuildContext context}) {
  switch (level.toLowerCase()) {
    case 'error':
    case 'crit':
    case 'alert':
    case 'emerg':
      return AppColors.error;
    case 'warn':
    case 'warning':
      return AppColors.warning;
    case 'notice':
    case 'info':
      return Theme.of(context).colorScheme.primary;
    default:
      return Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38);
  }
}

/// Maps a WireGuard/syslog severity label to a colour by delegating to
/// [logLevelColor].
///
/// Accepts long-form syslog names (`emergency`, `alert`, `critical`,
/// `informational`) in addition to the short names accepted by [logLevelColor].
///
/// Used by [WireGuardLogCard] and [WireGuardLogDetailSheet].
Color wireguardSeverityColor(String severity, {required BuildContext context}) {
  switch (severity.toLowerCase()) {
    case 'emergency':
    case 'alert':
    case 'critical':
    case 'error':
      return logLevelColor('error', context: context);
    case 'warning':
      return logLevelColor('warning', context: context);
    case 'notice':
    case 'informational':
      return logLevelColor('info', context: context);
    case 'debug':
    default:
      return logLevelColor('debug', context: context);
  }
}

/// Maps a capitalised severity label (as returned by the log-file API) to a
/// colour using the current [ColorScheme].
///
/// Accepts: `Emergency`, `Alert`, `Critical`, `Error`, `Warning`, `Notice`,
/// `Info`, `Informational`, `Debug`.
///
/// Used by [WireguardLogFileScreen] and [OpenvpnLogFileScreen].
Color logFileSeverityColor(BuildContext context, String severity) {
  final colorScheme = Theme.of(context).colorScheme;

  switch (severity) {
    case 'Emergency':
    case 'Alert':
    case 'Critical':
    case 'Error':
      return colorScheme.error;
    case 'Warning':
    case 'Notice':
      return AppColors.warning;
    case 'Info':
    case 'Informational':
      return colorScheme.primary;
    case 'Debug':
    default:
      return colorScheme.outline;
  }
}
