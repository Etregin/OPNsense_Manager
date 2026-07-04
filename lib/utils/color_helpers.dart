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
import 'constants.dart';

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
      return Theme.of(context).disabledColor;
  }
}
