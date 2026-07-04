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
import '../models/system_info.dart';
import '../screens/dashboard_screen.dart';
import '../screens/system_info_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/profile_selection_screen.dart';
import '../l10n/app_localizations.dart';
import '../services/navigation/navigation_service.dart';
import '../services/opnsense_api_service.dart';
import '../services/profile_service.dart';
import '../services/auth_service.dart';
import '../utils/snackbar_helper.dart';
import '../utils/constants.dart';
import 'drawer/drawer_header_widget.dart';
import 'drawer/navigation_tile.dart';
import 'drawer/firewall_navigation_section.dart';
import 'drawer/network_navigation_section.dart';
import 'drawer/vpn_navigation_section.dart';
import 'common/confirmation_dialog.dart';

/// Reusable app drawer for navigation
class AppDrawer extends StatefulWidget {
  final String currentRoute;
  final SystemInfo? systemInfo;
  final Future<bool> Function()? onBeforeNavigate;

  const AppDrawer({
    super.key,
    required this.currentRoute,
    this.systemInfo,
    this.onBeforeNavigate,
  });

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool _firewallExpanded = false;
  bool _vpnExpanded = false;

  @override
  void initState() {
    super.initState();
    // Auto-expand sections based on current route
    _firewallExpanded = NavigationService.isRouteInSection(widget.currentRoute, 'firewall_');
    _vpnExpanded = NavigationService.isRouteInSection(widget.currentRoute, 'vpn_') ||
                   NavigationService.isRouteInSection(widget.currentRoute, 'wireguard_') ||
                   NavigationService.isRouteInSection(widget.currentRoute, 'openvpn_') ||
                   NavigationService.isRouteInSection(widget.currentRoute, 'tailscale_');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Drawer header with app branding
          DrawerHeaderWidget(systemInfo: widget.systemInfo),
          
          // 1. Dashboard navigation
          NavigationTile(
            icon: Icons.dashboard,
            title: l10n.dashboard,
            currentRoute: widget.currentRoute,
            targetRoute: 'dashboard',
            destination: const DashboardScreen(),
          ),
          
          // 2. System Information (individual tile)
          NavigationTile(
            icon: Icons.info_outline,
            title: l10n.systemInformation,
            currentRoute: widget.currentRoute,
            targetRoute: 'system_info',
            destination: const SystemInfoScreen(),
            onBeforeNavigate: widget.onBeforeNavigate,
          ),
          
          const Divider(),
          
          // 3. Network navigation section
          NetworkNavigationSection(
            currentRoute: widget.currentRoute,
          ),
          
          // 4. Firewall navigation section
          FirewallNavigationSection(
            currentRoute: widget.currentRoute,
            isExpanded: _firewallExpanded,
            onExpansionChanged: (expanded) {
              setState(() {
                _firewallExpanded = expanded;
              });
            },
          ),
          
          // 4. VPN navigation section
          VPNNavigationSection(
            currentRoute: widget.currentRoute,
            isExpanded: _vpnExpanded,
            onExpansionChanged: (expanded) {
              setState(() {
                _vpnExpanded = expanded;
              });
            },
            onBeforeNavigate: widget.onBeforeNavigate,
          ),
          
          // 5. Settings (individual tile)
          NavigationTile(
            icon: Icons.settings,
            title: l10n.settings,
            currentRoute: widget.currentRoute,
            targetRoute: 'settings',
            destination: const SettingsScreen(),
          ),
          
          const Divider(),

          // 6. Switch Profile
          NavigationTile(
            icon: Icons.swap_horiz,
            title: l10n.switchProfile,
            currentRoute: widget.currentRoute,
            targetRoute: 'switch_profile',
            onTap: () => _handleSwitchProfile(context),
          ),
          
          // 7. Reboot System (individual tile)
          ListTile(
            leading: const Icon(Icons.restart_alt, color: Colors.red),
            title: Text(
              l10n.rebootSystem,
              style: const TextStyle(color: Colors.red),
            ),
            onTap: () {
              Navigator.pop(context);
              _rebootFirewall(context);
            },
          ),
          
          // 8. About (individual tile)
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: Text(l10n.about),
            onTap: () {
              Navigator.pop(context);
              _showAboutDialog(context);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _handleSwitchProfile(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    
    // CRITICAL FIX: Capture the navigator BEFORE closing drawer or showing dialog
    // The context becomes unmounted after dialogs, so we need to get the navigator early
    final navigator = Navigator.of(context, rootNavigator: true);
    
    // Close the drawer first
    Navigator.pop(context);
    
    // Wait a bit for drawer to close
    await Future.delayed(const Duration(milliseconds: 150));
    
    if (!context.mounted) {
      return;
    }
    
    // Show confirmation dialog
    final confirmed = await ConfirmationDialog.show(
      context: context,
      title: l10n.switchProfile,
      message: l10n.switchProfileConfirmation,
      confirmText: l10n.switchProfile,
      cancelText: l10n.cancel,
      isDestructive: false,
    );

    if (confirmed == true) {
      try {
        // Clear the active profile
        await ProfileService().clearActiveProfile();
        
        // Clear auth session
        await AuthService().clearSession();
        
        // Navigate to profile selection screen and clear the navigation stack
        // Use the navigator we captured earlier (before context became unmounted)
        await navigator.pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const ProfileSelectionScreen(),
          ),
          (route) => false, // Remove all previous routes
        );
      } catch (e) {
        // Try to show error message if context is still valid
        if (context.mounted) {
          SnackBarHelper.showError(context, 'Failed to switch profile: ${e.toString()}', duration: const Duration(seconds: 5));
        }
      }
    }
  }

  Future<void> _rebootFirewall(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.warning, color: Colors.orange),
            const SizedBox(width: 8),
            Text(l10n.rebootSystem),
          ],
        ),
        content: Text(l10n.rebootConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.restart),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        // Show loading indicator
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(l10n.loading),
              ],
            ),
          ),
        );

        final apiService = context.read<OPNsenseApiService>();
        await apiService.rebootSystem();

        if (context.mounted) {
          Navigator.of(context).pop(); // Close loading dialog
          
          SnackBarHelper.showError(context, l10n.rebootSuccess, duration: const Duration(seconds: 5));
        }
      } catch (e) {
        if (context.mounted) {
          Navigator.of(context).pop(); // Close loading dialog
          
          SnackBarHelper.showError(context, l10n.rebootFailedWithError(l10n.rebootFailed, e.toString()));
        }
      }
    }
  }

  void _showAboutDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showAboutDialog(
      context: context,
      applicationName: AppConstants.appName,
      applicationVersion: AppConstants.appVersion,
      applicationIcon: const Icon(Icons.router, size: 48),
      applicationLegalese: l10n.applicationLegalese,
      children: [
        const SizedBox(height: 16),
        Text(
          l10n.aboutDescription,
          style: const TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 16),
        Text(
          l10n.featuresTitle,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        Text(
          l10n.featuresList,
          style: const TextStyle(fontSize: 13),
        ),
        const SizedBox(height: 16),
        Builder(
          builder: (builderContext) {
            final l10n = AppLocalizations.of(builderContext)!;
            return TextButton.icon(
              onPressed: () {
                showDialog(
                  context: builderContext,
                  builder: (dialogContext) {
                    final l10n = AppLocalizations.of(dialogContext)!;
                    return AlertDialog(
                      title: Text(l10n.gnuLicenseTitle),
                      content: SingleChildScrollView(
                        child: Text(
                          l10n.gnuLicenseText,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(dialogContext).pop(),
                          child: Text(l10n.close),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.gavel),
              label: Text(l10n.viewFullLicense),
            );
          },
        ),
      ],
    );
  }
}


