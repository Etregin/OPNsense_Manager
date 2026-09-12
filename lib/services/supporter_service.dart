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
import 'dart:io';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../config/flavor_config.dart';
import '../utils/constants.dart';
import 'ads/ad_service.dart';
import 'storage_service.dart';

/// Service managing supporter in-app purchase lifecycle, restore operations,
/// and supporter/migration status storage.
class SupporterService {
  static final SupporterService _instance = SupporterService._internal();
  factory SupporterService() => _instance;
  SupporterService._internal();

  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;

  /// Initializes the in-app purchase stream subscription.
  ///
  /// Early-returns on non-ad flavors (`fdroid`, `github`).
  Future<void> init() async {
    if (!FlavorConfig().supportsAds) return;

    final Stream<List<PurchaseDetails>> purchaseUpdated =
        InAppPurchase.instance.purchaseStream;

    _purchaseSubscription = purchaseUpdated.listen(
      _onPurchaseUpdate,
      onDone: () {
        _purchaseSubscription?.cancel();
      },
      onError: (Object error) {
        // Stream subscription error handling
      },
    );
  }

  Future<void> _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.restored) {
        if (purchaseDetails.productID == StringConstants.supporterProductId) {
          await setSupporter(true);
          await AdService().refreshAdFreeStatus();
        }
        if (Platform.isIOS) {
          await InAppPurchase.instance.completePurchase(purchaseDetails);
        }
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        if (Platform.isIOS) {
          await InAppPurchase.instance.completePurchase(purchaseDetails);
        }
      }
    }
  }

  /// Checks whether the user has active supporter status.
  Future<bool> isSupporterActive() async {
    return await StorageService().loadBool(AppConstants.keySupporterActive) ?? false;
  }

  /// Sets the supporter status in local storage.
  Future<void> setSupporter(bool value) async {
    await StorageService().saveBool(AppConstants.keySupporterActive, value);
  }

  /// Checks whether the migration notice has been dismissed.
  Future<bool> isMigrationDismissed() async {
    return await StorageService().loadBool(AppConstants.keyMigrationNoticeDismissed) ?? false;
  }

  /// Sets the migration notice as dismissed in local storage.
  Future<void> setMigrationDismissed() async {
    await StorageService().saveBool(AppConstants.keyMigrationNoticeDismissed, true);
  }

  /// Initiates purchase flow for the supporter product.
  Future<void> buySupporter() async {
    if (!FlavorConfig().supportsAds) return;

    final ProductDetailsResponse response = await InAppPurchase.instance
        .queryProductDetails({StringConstants.supporterProductId});

    if (response.productDetails.isEmpty) return;

    final PurchaseParam param =
        PurchaseParam(productDetails: response.productDetails.first);
    await InAppPurchase.instance.buyNonConsumable(purchaseParam: param);
  }

  /// Restores previous in-app purchases.
  Future<void> restorePurchases() async {
    if (!FlavorConfig().supportsAds) return;

    await InAppPurchase.instance.restorePurchases();
  }

  /// Cancels purchase subscription stream.
  void dispose() {
    _purchaseSubscription?.cancel();
  }
}
