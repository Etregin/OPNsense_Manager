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
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/flavor_config.dart';
import '../../l10n/app_localizations.dart';
import '../../services/supporter_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/constants.dart';
import '../../utils/snackbar_helper.dart';
import 'settings_section.dart';

/// Settings section that surfaces supporter status, IAP purchase/restore
/// (playstore only), and legacy access claim on all flavors.
class SupporterSettingsSection extends StatefulWidget {
  const SupporterSettingsSection({super.key});

  @override
  State<SupporterSettingsSection> createState() => _SupporterSettingsSectionState();
}

class _SupporterSettingsSectionState extends State<SupporterSettingsSection> {
  bool _isSupporter = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSupporterStatus();
  }

  Future<void> _loadSupporterStatus() async {
    final service = context.read<SupporterService>();
    final status = await service.isSupporterActive();
    if (mounted) setState(() => _isSupporter = status);
  }

  Future<void> _handleBuy() async {
    final service = context.read<SupporterService>();
    final l10n = AppLocalizations.of(context)!;
    setState(() => _isLoading = true);
    try {
      await service.buySupporter();
      // Purchase result comes via SupporterService stream listener.
      // Re-check status after a brief delay to allow stream processing.
      await Future.delayed(const Duration(seconds: 2));
      await _loadSupporterStatus();
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showError(context, l10n.supporterPurchaseFailed);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleRestore() async {
    final service = context.read<SupporterService>();
    final l10n = AppLocalizations.of(context)!;
    setState(() => _isLoading = true);
    try {
      await service.restorePurchases();
      // Give the stream a moment to process.
      await Future.delayed(const Duration(seconds: 2));
      await _loadSupporterStatus();
      if (mounted) {
        if (_isSupporter) {
          SnackBarHelper.showSuccess(context, l10n.supporterRestoreSuccess);
        } else {
          SnackBarHelper.showInfo(context, l10n.supporterRestoreNotFound);
        }
      }
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showError(context, l10n.supporterPurchaseFailed);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleClaimLegacy() async {
    await launchUrl(
      Uri.parse(StringConstants.legacyClaimMailtoUri),
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  Widget build(BuildContext context) {
    // This section is only relevant on the Play Store / App Store flavor,
    // where ads exist and IAP is available. Hide it entirely on fdroid/github.
    if (!FlavorConfig().supportsAds) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context)!;

    final Widget? loadingIndicator = _isLoading
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : null;

    final children = <Widget>[];

    if (_isSupporter) {
      children.add(
        ListTile(
          leading: const Icon(Icons.verified, color: AppColors.success),
          title: Text(l10n.supporterActiveStatus),
        ),
      );
    } else {
      children.addAll([
        ListTile(
          leading: const Icon(Icons.star_outline),
          title: Text(l10n.becomeSupporter),
          subtitle: Text(l10n.becomeSupporterSubtitle),
          trailing: loadingIndicator,
          onTap: _isLoading ? null : _handleBuy,
        ),
        ListTile(
          leading: const Icon(Icons.restore),
          title: Text(l10n.restorePurchase),
          subtitle: Text(l10n.restorePurchaseSubtitle),
          trailing: loadingIndicator,
          onTap: _isLoading ? null : _handleRestore,
        ),
        ListTile(
          leading: const Icon(Icons.redeem_outlined),
          title: Text(l10n.claimLegacyAccess),
          subtitle: Text(l10n.claimLegacyAccessSubtitle),
          onTap: _handleClaimLegacy,
        ),
      ]);
    }

    return SettingsSection(
      title: l10n.supporterAndAdRemoval,
      icon: Icons.star_outline,
      children: children,
    );
  }
}
