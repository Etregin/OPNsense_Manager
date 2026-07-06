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

// ignore_for_file: deprecated_member_use

import 'package:flutter/widgets.dart';

/// Mixin that calls [onFirstDependency] exactly once — on the first
/// [didChangeDependencies] invocation — removing the need for a manual
/// `bool _isInitialized` guard in every list/detail screen.
///
/// Usage:
/// ```dart
/// class _MyScreenState extends State<MyScreen> with SingleInitMixin {
///   @override
///   void onFirstDependency() {
///     _viewModel = MyViewModel(context.read<DemoApiService>());
///     _viewModel.loadItems();
///   }
/// }
/// ```
///
/// Compatible with [AutoRefreshMixin]:
/// ```dart
/// class _MyState extends State<My> with AutoRefreshMixin, SingleInitMixin {
/// ```
// ignore: invalid_use_of_internal_member
mixin SingleInitMixin<T extends StatefulWidget> on State<T> {
  bool _singleInitDone = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_singleInitDone) {
      _singleInitDone = true;
      onFirstDependency();
    }
  }

  /// Called exactly once after the first [didChangeDependencies] cycle.
  ///
  /// Use [context] freely here — inherited widgets are available.
  void onFirstDependency();
}
