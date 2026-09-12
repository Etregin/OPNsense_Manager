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

import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../config/flavor_config.dart';
import '../../utils/constants.dart';
import '../storage_service.dart';

/// Singleton that manages Google Mobile Ads initialisation and banner ad
/// creation, gated behind the current distribution flavor and the user's
/// supporter status.
///
/// Call [initialize] once during app startup (after [StorageService] is
/// ready).  All other methods are safe to call synchronously afterwards.
class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  bool _isAdFree = false;

  // ── Android and iOS banner test ad unit IDs ──────────────────────────────
  // TODO: Replace test IDs with production IDs before release.
  static const String _androidBannerTestId =
      'ca-app-pub-3940256099942544/6300978111';
  static const String _iosBannerTestId =
      'ca-app-pub-3940256099942544/2934735716';

  // ── Public getters ────────────────────────────────────────────────────────

  /// Whether the user has an active supporter unlock (ads suppressed).
  ///
  /// Valid synchronously after [initialize] completes.
  bool get isAdFree => _isAdFree;

  /// Whether banner ads should currently be shown.
  ///
  /// `true` only on the `playstore` flavor when the user is *not* a supporter.
  bool get showAds => FlavorConfig().supportsAds && !_isAdFree;

  // ── Initialisation ────────────────────────────────────────────────────────

  /// Initialises the ads SDK.
  ///
  /// Early-returns on non-`playstore` flavors — no SDK calls are made.
  /// Reads the supporter flag directly from [StorageService] so that this
  /// service has no compile-time dependency on [SupporterService] (which is
  /// created in Sub-Task 3).
  Future<void> initialize() async {
    if (!FlavorConfig().supportsAds) return;

    final stored =
        await StorageService().loadBool(AppConstants.keySupporterActive);
    _isAdFree = stored ?? false;

    if (!_isAdFree) {
      await MobileAds.instance.initialize();
    }
  }

  // ── Ad factory ────────────────────────────────────────────────────────────

  /// Creates a [BannerAd] configured with test ad unit IDs.
  ///
  /// Returns `null` when [showAds] is `false`, so callers never need to
  /// check the gate themselves.
  BannerAd? createBannerAd(AdSize size, BannerAdListener listener) {
    if (!showAds) return null;

    final adUnitId =
        Platform.isAndroid ? _androidBannerTestId : _iosBannerTestId;

    return BannerAd(
      adUnitId: adUnitId,
      size: size,
      request: const AdRequest(),
      listener: listener,
    );
  }

  // ── State refresh ─────────────────────────────────────────────────────────

  /// Re-reads the supporter flag from storage and updates [isAdFree].
  ///
  /// Call this after a successful IAP purchase or restore so that the ads
  /// gate is updated without requiring an app restart.
  Future<void> refreshAdFreeStatus() async {
    final stored =
        await StorageService().loadBool(AppConstants.keySupporterActive);
    _isAdFree = stored ?? false;
  }
}
