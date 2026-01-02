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
import '../services/opnsense_api_service.dart';
import '../services/profile_service.dart';
import '../services/auth_service.dart';
import '../utils/constants.dart';
import '../screens/profile_selection_screen.dart';
import '../screens/system_info_screen.dart';
import '../screens/firewall_rules_screen.dart';
import '../screens/firewall_logs_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/pin_lock_screen.dart';

/// Reusable app drawer for navigation
class AppDrawer extends StatelessWidget {
  final String currentRoute;
  final SystemInfo? systemInfo;

  const AppDrawer({
    super.key,
    required this.currentRoute,
    this.systemInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(
                  Icons.router,
                  size: 48,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                const Text(
                  AppConstants.appName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (systemInfo != null)
                  Text(
                    systemInfo!.hostname,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            selected: currentRoute == 'dashboard',
            onTap: () {
              if (currentRoute != 'dashboard') {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const DashboardScreen(),
                  ),
                );
              } else {
                Navigator.pop(context);
              }
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('System Information'),
            selected: currentRoute == 'system_info',
            onTap: () {
              if (currentRoute != 'system_info') {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const SystemInfoScreen(),
                  ),
                );
              } else {
                Navigator.pop(context);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text('Firewall Rules'),
            selected: currentRoute == 'firewall_rules',
            onTap: () {
              if (currentRoute != 'firewall_rules') {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const FirewallRulesScreen(),
                  ),
                );
              } else {
                Navigator.pop(context);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.article),
            title: const Text('Firewall Logs'),
            selected: currentRoute == 'firewall_logs',
            onTap: () {
              if (currentRoute != 'firewall_logs') {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const FirewallLogsScreen(),
                  ),
                );
              } else {
                Navigator.pop(context);
              }
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            selected: currentRoute == 'settings',
            onTap: () {
              if (currentRoute != 'settings') {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              } else {
                Navigator.pop(context);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.restart_alt, color: Colors.red),
            title: const Text('Reboot Firewall', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
              _rebootFirewall(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('About'),
            onTap: () {
              Navigator.pop(context);
              _showAboutDialog(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.swap_horiz),
            title: const Text('Change Profile'),
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
                  title: const Text('Lock App'),
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
      ),
    );
  }

  Future<void> _rebootFirewall(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.orange),
            SizedBox(width: 8),
            Text('Reboot Firewall'),
          ],
        ),
        content: const Text(
          'Are you sure you want to reboot the firewall?\n\n'
          'This will temporarily interrupt network connectivity and all active connections will be lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Reboot'),
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
          builder: (context) => const AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Rebooting firewall...'),
              ],
            ),
          ),
        );

        final apiService = context.read<OPNsenseApiService>();
        await apiService.rebootSystem();

        if (context.mounted) {
          Navigator.of(context).pop(); // Close loading dialog
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Firewall reboot initiated. The system will be back online shortly.'),
              duration: Duration(seconds: 5),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          Navigator.of(context).pop(); // Close loading dialog
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error rebooting firewall: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: AppConstants.appName,
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.router, size: 48),
      applicationLegalese: '© 2026 OPNsense Manager\n\n'
          'Licensed under GNU General Public License v3.0\n\n'
          'This program is free software: you can redistribute it and/or modify '
          'it under the terms of the GNU General Public License as published by '
          'the Free Software Foundation, either version 3 of the License, or '
          '(at your option) any later version.',
      children: [
        const SizedBox(height: 16),
        const Text(
          'A professional Flutter mobile application for managing OPNsense firewall routers.',
          style: TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 16),
        const Text(
          'Features:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const Text(
          '• System monitoring and management\n'
          '• Firewall rule configuration\n'
          '• Service control\n'
          '• Real-time logs\n'
          '• Multi-profile support\n'
          '• Secure authentication',
          style: TextStyle(fontSize: 13),
        ),
        const SizedBox(height: 16),
        Builder(
          builder: (builderContext) => TextButton.icon(
            onPressed: () {
              showDialog(
                context: builderContext,
                builder: (dialogContext) => AlertDialog(
                  title: const Text('GNU General Public License v3.0'),
                  content: const SingleChildScrollView(
                    child: Text(
                      'This program is free software: you can redistribute it and/or modify '
                      'it under the terms of the GNU General Public License as published by '
                      'the Free Software Foundation, either version 3 of the License, or '
                      '(at your option) any later version.\n\n'
                      'This program is distributed in the hope that it will be useful, '
                      'but WITHOUT ANY WARRANTY; without even the implied warranty of '
                      'MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the '
                      'GNU General Public License for more details.\n\n'
                      'You should have received a copy of the GNU General Public License '
                      'along with this program. If not, see <https://www.gnu.org/licenses/>.\n\n'
                      'Why GPLv3?\n\n'
                      '• Ensures the software remains free and open source\n'
                      '• Any modifications or derivatives must also be open source\n'
                      '• Users have the freedom to use, study, share, and modify the software\n'
                      '• The community benefits from improvements and contributions',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.gavel),
            label: const Text('View Full License'),
          ),
        ),
      ],
    );
  }

  Future<void> _changeProfile(BuildContext context) async {
    // Get services BEFORE showing dialog (while context is still active)
    final profileService = context.read<ProfileService>();
    final apiService = context.read<OPNsenseApiService>();
    final navigator = Navigator.of(context);
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Profile'),
        content: const Text('Switch to a different OPNsense instance?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Change'),
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
      navigator.pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const ProfileSelectionScreen(),
        ),
        (route) => false,
      );
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
    navigator.pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => PinLockScreen(
          onAuthenticated: (ctx) async {
            // After successful authentication, check if we still have an active profile
            final activeProfile = await profileService.getActiveProfile();
            
            if (context.mounted) {
              if (activeProfile != null) {
                // Re-initialize API service
                apiService.init(activeProfile.toOPNsenseConfig());
                
                // Navigate back to dashboard
                Navigator.of(ctx).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const DashboardScreen(),
                  ),
                  (route) => false,
                );
              } else {
                // No active profile, go to profile selection
                Navigator.of(ctx).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const ProfileSelectionScreen(),
                  ),
                  (route) => false,
                );
              }
            }
          },
        ),
      ),
      (route) => false,
    );
  }
}

