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
import 'package:provider/provider.dart';
import '../../constants/routes.dart';
import '../../l10n/app_localizations.dart';
import '../../screens/settings_screen.dart';
import '../../screens/profile_selection_screen.dart';
import '../../screens/pin_lock_screen.dart';
import '../../screens/dashboard_screen.dart';
import '../../services/auth_service.dart';
import '../../services/profile_service.dart';
import '../../services/opnsense_api_service.dart';
import 'navigation_tile.dart';

/// Settings navigation section for the app drawer
class SettingsNavigationSection extends StatelessWidget {
  final String currentRoute;

  const SettingsNavigationSection({
    super.key,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        NavigationTile(
          icon: Icons.settings,
          title: l10n.settings,
          currentRoute: currentRoute,
          targetRoute: Routes.settings,
          destination: const SettingsScreen(),
        ),
        ListTile(
          leading: const Icon(Icons.swap_horiz),
          title: Text(l10n.switchProfile),
          onTap: () {
            Navigator.pop(context);
            _changeProfile(context);
          },
        ),
        FutureBuilder<bool>(
          future: context.read<AuthService>().isPinEnabled(),
          builder: (context, snapshot) {
            if (snapshot.data == true) {
              return ListTile(
                leading: const Icon(Icons.lock),
                title: Text(l10n.lockApp),
                onTap: () {
                  Navigator.pop(context);
                  _lockApp(context);
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Future<void> _changeProfile(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    // Get services BEFORE showing dialog (while context is still active)
    final profileService = context.read<ProfileService>();
    final apiService = context.read<OPNsenseApiService>();
    final navigator = Navigator.of(context);
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.switchProfile),
        content: Text(l10n.switchProfileConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      // Clear active profile (but don't clear auth session)
      await profileService.clearActiveProfile();

      // Clear API service
      apiService.clear();

      // Navigate to profile selection
      unawaited(navigator.pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const ProfileSelectionScreen(),
        ),
        (route) => false,
      ));
    }
  }

  Future<void> _lockApp(BuildContext context) async {
    final authService = context.read<AuthService>();
    final profileService = context.read<ProfileService>();
    final apiService = context.read<OPNsenseApiService>();
    final navigator = Navigator.of(context);
    
    // Mark session as expired to trigger PIN lock
    await authService.clearSession();
    
    // Navigate to PIN lock screen
    unawaited(navigator.pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => PinLockScreen(
          onAuthenticated: (ctx) async {
            final activeProfile = await profileService.getActiveProfile();
            
            if (context.mounted) {
              if (activeProfile != null) {
                // Re-initialize API service
                apiService.init(activeProfile.toOPNsenseConfig());
                
                // Navigate back to dashboard
                unawaited(Navigator.of(ctx).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const DashboardScreen(),
                  ),
                  (route) => false,
                ));
              } else {
                // No active profile, go to profile selection
                unawaited(Navigator.of(ctx).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const ProfileSelectionScreen(),
                  ),
                  (route) => false,
                ));
              }
            }
          },
        ),
      ),
      (route) => false,
    ));
  }
}


