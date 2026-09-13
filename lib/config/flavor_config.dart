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

/// Distribution flavors for OPNsense Manager.
enum Flavor {
  /// Google Play Store / App Store build — supports ads and IAP.
  playstore,

  /// F-Droid build — no ads, no IAP, no tracking.
  fdroid,

  /// GitHub direct-download build — no ads, no IAP.
  github,
}

/// Singleton that exposes the compile-time distribution flavor and
/// flavor-gated feature flags.
///
/// Flavor is resolved in priority order:
///   1. [setFlavor] called explicitly from a per-flavor entry point
///      (`main_fdroid.dart`, `main_github.dart`, `main_playstore.dart`).
///   2. [initialize] reads `FLUTTER_APP_FLAVOR`, which the Flutter CLI
///      **automatically** injects when `--flavor <name>` is passed to
///      `flutter run` / `flutter build`.  No manual `--dart-define` needed.
///   3. Falls back to [Flavor.playstore] when neither is set.
class FlavorConfig {
  static final FlavorConfig _instance = FlavorConfig._internal();
  factory FlavorConfig() => _instance;
  FlavorConfig._internal();

  Flavor? _flavor;

  /// The flavor this binary was built for.
  ///
  /// Defaults to [Flavor.playstore] when no flavor was injected.
  Flavor get flavor => _flavor ?? Flavor.playstore;

  /// Whether this build supports Google Mobile Ads.
  ///
  /// Returns `true` only on the [Flavor.playstore] flavor.
  bool get supportsAds => flavor == Flavor.playstore;

  /// Sets the flavor explicitly from a per-flavor entry point.
  ///
  /// Call this **before** [app.main].  Once set, [initialize] is a no-op.
  static void setFlavor(Flavor flavor) {
    FlavorConfig()._flavor = flavor;
  }

  /// Reads the flavor from the `FLUTTER_APP_FLAVOR` compile-time define,
  /// which the Flutter CLI injects automatically when `--flavor <name>` is
  /// used.  No-op if [setFlavor] was already called.
  ///
  /// Defaults to [Flavor.playstore] when the define is absent (e.g. plain
  /// `flutter run` without `--flavor`).
  static void initialize() {
    if (FlavorConfig()._flavor != null) return; // already set by setFlavor()
    const raw = String.fromEnvironment(
      'FLUTTER_APP_FLAVOR',
      defaultValue: 'playstore',
    );
    FlavorConfig()._flavor = switch (raw) {
      'fdroid'  => Flavor.fdroid,
      'github'  => Flavor.github,
      _         => Flavor.playstore,
    };
  }
}
