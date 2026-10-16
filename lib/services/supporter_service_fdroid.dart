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

// F-Droid stub — no in_app_purchase dependency.
// Copied over supporter_service.dart by the F-Droid prebuild step.
// All public members match the real SupporterService so the rest of the app compiles unchanged.

import 'package:flutter/foundation.dart';
import '../utils/constants.dart';
import 'storage_service.dart';

class SupporterService extends ChangeNotifier {
  static final SupporterService _instance = SupporterService._internal();
  factory SupporterService() => _instance;
  SupporterService._internal();

  bool _isSupporter = false;
  bool _isInitialized = false;

  bool get isSupporter => _isSupporter;

  Future<void> init() async {
    final stored = await StorageService().loadBool(AppConstants.keySupporterActive);
    _isSupporter = stored ?? false;
    _isInitialized = true;
  }

  Future<bool> isSupporterActive() async {
    if (!_isInitialized) {
      _isSupporter = await StorageService().loadBool(AppConstants.keySupporterActive) ?? false;
      _isInitialized = true;
    }
    return _isSupporter;
  }

  Future<void> setSupporter(bool value) async {
    _isSupporter = value;
    await StorageService().saveBool(AppConstants.keySupporterActive, value);
    notifyListeners();
  }

  Future<bool> isMigrationDismissed() async {
    return await StorageService().loadBool(AppConstants.keyMigrationNoticeDismissed) ?? false;
  }

  Future<void> setMigrationDismissed() async {
    await StorageService().saveBool(AppConstants.keyMigrationNoticeDismissed, true);
  }

  /// No-op on F-Droid — IAP is not available.
  Future<void> buySupporter() async {}

  /// No-op on F-Droid — IAP is not available.
  Future<void> restorePurchases() async {}
}
