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

// F-Droid stub — no google_mobile_ads dependency.
// Copied over ad_service.dart by the F-Droid prebuild step.
// All public members match the real AdService so the rest of the app compiles unchanged.

import 'package:flutter/foundation.dart';
import '../../utils/constants.dart';
import '../storage_service.dart';

class AdService extends ChangeNotifier {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  bool get isAdFree => true;
  bool get showAds => false;

  Future<void> initialize() async {
    await StorageService().loadBool(AppConstants.keySupporterActive);
  }

  Future<void> refreshAdFreeStatus() async {}
}
