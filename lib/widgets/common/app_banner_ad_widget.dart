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
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import '../../services/ads/ad_service.dart';

/// A reusable banner ad widget that fully manages its own [BannerAd] lifecycle.
///
/// Renders an anchored banner on `playstore` builds where the user has not
/// purchased the supporter unlock. Collapses to [SizedBox.shrink] on all other
/// configurations (non-`playstore` flavor, supporter active, or ad load
/// failure) — no SDK calls are made in those cases.
class AppBannerAdWidget extends StatefulWidget {
  const AppBannerAdWidget({super.key});

  @override
  State<AppBannerAdWidget> createState() => _AppBannerAdWidgetState();
}

class _AppBannerAdWidgetState extends State<AppBannerAdWidget> {
  BannerAd? _bannerAd;
  bool _showAd = false;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;

    final adService = context.read<AdService>();
    if (!adService.showAds) return;

    final ad = adService.createBannerAd(AdSize.banner, _createListener());
    if (ad == null) return;

    _bannerAd = ad;
    _bannerAd!.load();
  }

  BannerAdListener _createListener() {
    return BannerAdListener(
      onAdLoaded: (_) => setState(() => _showAd = true),
      onAdFailedToLoad: (ad, _) {
        setState(() => _showAd = false);
        _bannerAd?.dispose();
        _bannerAd = null;
      },
    );
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_showAd || _bannerAd == null) return const SizedBox.shrink();
    return SizedBox(
      height: _bannerAd!.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }
}
