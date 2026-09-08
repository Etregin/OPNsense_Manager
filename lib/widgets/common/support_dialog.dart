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
import 'package:qr_flutter/qr_flutter.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/app_colors.dart';
import '../../utils/constants.dart';
import '../../utils/snackbar_helper.dart';

/// Dialog displaying project support and donation details
class SupportDialog extends StatelessWidget {
  const SupportDialog({super.key});

  /// Displays the SupportDialog as an adaptive alert dialog
  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => const SupportDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.favorite, color: colorScheme.primary),
          const SizedBox(width: AppConstants.compactPadding),
          Expanded(
            child: Text(
              l10n.supportProject,
              style: theme.textTheme.titleLarge,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.supportDescription,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: AppConstants.standardPadding),

              // ── Crypto Section (USDT / USDC) ───────────────────────────
              Text(
                '${StringConstants.donationCryptoTokens} (${l10n.cryptoDonation})',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppConstants.compactPadding),

              Center(
                child: Container(
                  padding: const EdgeInsets.all(AppConstants.compactPadding),
                  decoration: BoxDecoration(
                    color: AppColors.onPrimary,
                    borderRadius: BorderRadius.circular(AppConstants.buttonBorderRadius),
                    border: Border.all(
                      color: colorScheme.outlineVariant.withValues(alpha: AppColors.opacityDivider),
                    ),
                  ),
                  child: QrImageView(
                    data: StringConstants.donationCryptoAddress,
                    version: QrVersions.auto,
                    size: 160.0,
                    backgroundColor: AppColors.onPrimary,
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.compactPadding),

              // Address card with copy button
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.compactPadding,
                  vertical: 6.0,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withValues(alpha: AppColors.opacitySubtle),
                  borderRadius: BorderRadius.circular(AppConstants.buttonBorderRadius),
                  border: Border.all(
                    color: colorScheme.outlineVariant.withValues(alpha: AppColors.opacityDivider),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: SelectableText(
                        StringConstants.donationCryptoAddress,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy, size: 20),
                      tooltip: l10n.copy,
                      onPressed: () {
                        SnackBarHelper.copyToClipboard(
                          context,
                          StringConstants.donationCryptoAddress,
                          successMessage: l10n.addressCopied,
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.compactPadding),

              Text(
                '${l10n.supportedNetworks}: ${StringConstants.donationCryptoNetworks}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.textTheme.bodySmall?.color?.withValues(alpha: AppColors.opacitySubdued),
                ),
              ),
              const SizedBox(height: AppConstants.standardPadding),

              const Divider(),
              const SizedBox(height: AppConstants.compactPadding),

              // ── Binance Gift Card Section ─────────────────────────────
              Text(
                l10n.binanceGiftCard,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                l10n.binanceGiftCardDescription,
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: AppConstants.compactPadding),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.compactPadding,
                  vertical: 6.0,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withValues(alpha: AppColors.opacitySubtle),
                  borderRadius: BorderRadius.circular(AppConstants.buttonBorderRadius),
                  border: Border.all(
                    color: colorScheme.outlineVariant.withValues(alpha: AppColors.opacityDivider),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: SelectableText(
                        StringConstants.donationBinanceEmail,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy, size: 20),
                      tooltip: l10n.copy,
                      onPressed: () {
                        SnackBarHelper.copyToClipboard(
                          context,
                          StringConstants.donationBinanceEmail,
                          successMessage: l10n.emailCopied,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.close),
        ),
      ],
    );
  }
}
