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

import 'dart:async';
import 'package:flutter/material.dart';

/// Mixin that adds periodic auto-refresh behaviour to a [State].
///
/// Usage:
/// ```dart
/// class _MyScreenState extends State<MyScreen> with AutoRefreshMixin {
///   @override
///   void initState() {
///     super.initState();
///     startAutoRefresh(AppConstants.dashboardRefreshInterval, _viewModel.loadItems);
///   }
/// }
/// ```
///
/// The mixin cancels the timer automatically in [dispose], so screens do not
/// need their own `_refreshTimer?.cancel()` call.
mixin AutoRefreshMixin<T extends StatefulWidget> on State<T> {
  Timer? _autoRefreshTimer;

  /// Start a periodic refresh that calls [onRefresh] every [interval].
  ///
  /// Any previously started timer is cancelled before the new one begins.
  void startAutoRefresh(Duration interval, VoidCallback onRefresh) {
    _autoRefreshTimer?.cancel();
    _autoRefreshTimer = Timer.periodic(interval, (_) {
      if (mounted) onRefresh();
    });
  }

  /// Cancel the periodic refresh without disposing the widget.
  void stopAutoRefresh() => _autoRefreshTimer?.cancel();

  @override
  void dispose() {
    _autoRefreshTimer?.cancel();
    super.dispose();
  }
}
