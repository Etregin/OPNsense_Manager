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
import '../screens/firewall_aliases_screen.dart';
import '../screens/firewall_logs_screen.dart';
import '../screens/vpn_connections_screen.dart';
import '../screens/live_network_monitor_screen.dart';
import '../screens/dhcp_leases_screen.dart';
import '../screens/wireguard_servers_screen.dart';
import '../screens/wireguard_clients_screen.dart';
import '../screens/wireguard_peers_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/pin_lock_screen.dart';
import '../l10n/app_localizations.dart';

/// Reusable app drawer for navigation
class AppDrawer extends StatefulWidget {
  final String currentRoute;
  final SystemInfo? systemInfo;

  const AppDrawer({
    super.key,
    required this.currentRoute,
    this.systemInfo,
  });

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool _firewallExpanded = false;
  bool _vpnExpanded = false;
  bool _wireguardExpanded = false;
  bool _ipsecExpanded = false;
  bool _openvpnExpanded = false;
  bool _tailscaleExpanded = false;

  @override
  void initState() {
    super.initState();
    // Auto-expand firewall section if on a firewall-related route
    _firewallExpanded = widget.currentRoute.startsWith('firewall_');
    // Auto-expand VPN section if on a VPN-related or WireGuard-related route
    _vpnExpanded = widget.currentRoute.startsWith('vpn_') ||
                   widget.currentRoute.startsWith('wireguard_') ||
                   widget.currentRoute.startsWith('ipsec_') ||
                   widget.currentRoute.startsWith('openvpn_') ||
                   widget.currentRoute.startsWith('tailscale_');
    // Auto-expand WireGuard section if on a WireGuard-related route
    _wireguardExpanded = widget.currentRoute.startsWith('wireguard_');
    // Auto-expand IPsec section if on an IPsec-related route
    _ipsecExpanded = widget.currentRoute.startsWith('ipsec_');
    // Auto-expand OpenVPN section if on an OpenVPN-related route
    _openvpnExpanded = widget.currentRoute.startsWith('openvpn_');
    // Auto-expand Tailscale section if on a Tailscale-related route
    _tailscaleExpanded = widget.currentRoute.startsWith('tailscale_');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
                if (widget.systemInfo != null)
                  Text(
                    widget.systemInfo!.hostname,
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
            title: Text(l10n.dashboard),
            selected: widget.currentRoute == 'dashboard',
            onTap: () {
              if (widget.currentRoute != 'dashboard') {
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
            title: Text(l10n.systemInformation),
            selected: widget.currentRoute == 'system_info',
            onTap: () {
              if (widget.currentRoute != 'system_info') {
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
          // Firewall expandable section
          ExpansionTile(
            leading: const Icon(Icons.security),
            title: const Text('Firewall'),
            initiallyExpanded: _firewallExpanded,
            onExpansionChanged: (expanded) {
              setState(() {
                _firewallExpanded = expanded;
              });
            },
            children: [
              ListTile(
                leading: const SizedBox(width: 16),
                title: Text(l10n.firewallRules),
                selected: widget.currentRoute == 'firewall_rules',
                contentPadding: const EdgeInsets.only(left: 72, right: 16),
                onTap: () {
                  if (widget.currentRoute != 'firewall_rules') {
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
                leading: const SizedBox(width: 16),
                title: const Text('Aliases'),
                selected: widget.currentRoute == 'firewall_aliases',
                contentPadding: const EdgeInsets.only(left: 72, right: 16),
                onTap: () {
                  if (widget.currentRoute != 'firewall_aliases') {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const FirewallAliasesScreen(),
                      ),
                    );
                  } else {
                    Navigator.pop(context);
                  }
                },
              ),
              ListTile(
                leading: const SizedBox(width: 16),
                title: Text(l10n.firewallLogs),
                selected: widget.currentRoute == 'firewall_logs',
                contentPadding: const EdgeInsets.only(left: 72, right: 16),
                onTap: () {
                  if (widget.currentRoute != 'firewall_logs') {
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
            ],
          ),
          ListTile(
            leading: const Icon(Icons.network_check),
            title: Text(l10n.liveNetworkMonitor),
            selected: widget.currentRoute == 'live_network_monitor',
            onTap: () {
              if (widget.currentRoute != 'live_network_monitor') {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const LiveNetworkMonitorScreen(),
                  ),
                );
              } else {
                Navigator.pop(context);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.dns),
            title: Text(l10n.dhcpLeases),
            selected: widget.currentRoute == 'dhcp_leases',
            onTap: () {
              if (widget.currentRoute != 'dhcp_leases') {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const DhcpLeasesScreen(),
                  ),
                );
              } else {
                Navigator.pop(context);
              }
            },
          ),
          // VPN expandable section with nested WireGuard submenu
          ExpansionTile(
            leading: const Icon(Icons.vpn_lock),
            title: const Text('VPN'),
            initiallyExpanded: _vpnExpanded,
            onExpansionChanged: (expanded) {
              setState(() {
                _vpnExpanded = expanded;
              });
            },
            children: [
              // VPN Connections overview (non-collapsible item)
              ListTile(
                leading: const SizedBox(width: 16),
                title: Text(l10n.vpnConnections),
                selected: widget.currentRoute == 'vpn_connections',
                contentPadding: const EdgeInsets.only(left: 72, right: 16),
                onTap: () {
                  if (widget.currentRoute != 'vpn_connections') {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const VPNConnectionsScreen(),
                      ),
                    );
                  } else {
                    Navigator.pop(context);
                  }
                },
              ),
              // WireGuard nested expandable section
              ExpansionTile(
                leading: const Icon(Icons.vpn_key, size: 20),
                title: const Text('WireGuard'),
                initiallyExpanded: _wireguardExpanded,
                tilePadding: const EdgeInsets.only(left: 56, right: 16),
                onExpansionChanged: (expanded) {
                  setState(() {
                    _wireguardExpanded = expanded;
                  });
                },
                children: [
                  ListTile(
                    leading: const SizedBox(width: 16),
                    title: const Text('Servers'),
                    selected: widget.currentRoute == 'wireguard_servers',
                    contentPadding: const EdgeInsets.only(left: 96, right: 16),
                    onTap: () {
                      if (widget.currentRoute != 'wireguard_servers') {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const WireGuardServersScreen(),
                          ),
                        );
                      } else {
                        Navigator.pop(context);
                      }
                    },
                  ),
                  ListTile(
                    leading: const SizedBox(width: 16),
                    title: const Text('Clients'),
                    selected: widget.currentRoute == 'wireguard_clients',
                    contentPadding: const EdgeInsets.only(left: 96, right: 16),
                    onTap: () {
                      if (widget.currentRoute != 'wireguard_clients') {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const WireGuardClientsScreen(),
                          ),
                        );
                      } else {
                        Navigator.pop(context);
                      }
                    },
                  ),
                  ListTile(
                    leading: const SizedBox(width: 16),
                    title: const Text('Peers'),
                    selected: widget.currentRoute == 'wireguard_peers',
                    contentPadding: const EdgeInsets.only(left: 96, right: 16),
                    onTap: () {
                      if (widget.currentRoute != 'wireguard_peers') {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const WireGuardPeersScreen(),
                          ),
                        );
                      } else {
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              ),
              // IPsec nested expandable section
              ExpansionTile(
                leading: const Icon(Icons.security, size: 20),
                title: const Text('IPsec'),
                initiallyExpanded: _ipsecExpanded,
                tilePadding: const EdgeInsets.only(left: 56, right: 16),
                onExpansionChanged: (expanded) {
                  setState(() {
                    _ipsecExpanded = expanded;
                  });
                },
                children: [
                  ListTile(
                    leading: const SizedBox(width: 16),
                    title: const Text('Tunnels'),
                    selected: widget.currentRoute == 'ipsec_tunnels',
                    contentPadding: const EdgeInsets.only(left: 96, right: 16),
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('IPsec Tunnels - Coming soon'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const SizedBox(width: 16),
                    title: const Text('Phase 1'),
                    selected: widget.currentRoute == 'ipsec_phase1',
                    contentPadding: const EdgeInsets.only(left: 96, right: 16),
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('IPsec Phase 1 - Coming soon'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const SizedBox(width: 16),
                    title: const Text('Phase 2'),
                    selected: widget.currentRoute == 'ipsec_phase2',
                    contentPadding: const EdgeInsets.only(left: 96, right: 16),
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('IPsec Phase 2 - Coming soon'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                ],
              ),
              // OpenVPN nested expandable section
              ExpansionTile(
                leading: const Icon(Icons.vpn_lock_outlined, size: 20),
                title: const Text('OpenVPN'),
                initiallyExpanded: _openvpnExpanded,
                tilePadding: const EdgeInsets.only(left: 56, right: 16),
                onExpansionChanged: (expanded) {
                  setState(() {
                    _openvpnExpanded = expanded;
                  });
                },
                children: [
                  ListTile(
                    leading: const SizedBox(width: 16),
                    title: const Text('Servers'),
                    selected: widget.currentRoute == 'openvpn_servers',
                    contentPadding: const EdgeInsets.only(left: 96, right: 16),
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('OpenVPN Servers - Coming soon'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const SizedBox(width: 16),
                    title: const Text('Clients'),
                    selected: widget.currentRoute == 'openvpn_clients',
                    contentPadding: const EdgeInsets.only(left: 96, right: 16),
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('OpenVPN Clients - Coming soon'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const SizedBox(width: 16),
                    title: const Text('Client Overrides'),
                    selected: widget.currentRoute == 'openvpn_client_overrides',
                    contentPadding: const EdgeInsets.only(left: 96, right: 16),
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('OpenVPN Client Overrides - Coming soon'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                ],
              ),
              // Tailscale nested expandable section
              ExpansionTile(
                leading: const Icon(Icons.cloud, size: 20),
                title: const Text('Tailscale'),
                initiallyExpanded: _tailscaleExpanded,
                tilePadding: const EdgeInsets.only(left: 56, right: 16),
                onExpansionChanged: (expanded) {
                  setState(() {
                    _tailscaleExpanded = expanded;
                  });
                },
                children: [
                  ListTile(
                    leading: const SizedBox(width: 16),
                    title: const Text('Status'),
                    selected: widget.currentRoute == 'tailscale_status',
                    contentPadding: const EdgeInsets.only(left: 96, right: 16),
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Tailscale Status - Coming soon'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const SizedBox(width: 16),
                    title: const Text('Settings'),
                    selected: widget.currentRoute == 'tailscale_settings',
                    contentPadding: const EdgeInsets.only(left: 96, right: 16),
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Tailscale Settings - Coming soon'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(l10n.settings),
            selected: widget.currentRoute == 'settings',
            onTap: () {
              if (widget.currentRoute != 'settings') {
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
            title: Text(l10n.rebootSystem, style: const TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
              _rebootFirewall(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: Text(l10n.about),
            onTap: () {
              Navigator.pop(context);
              _showAboutDialog(context);
            },
          ),
          const Divider(),
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
      ),
    );
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
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.rebootSuccess),
              duration: const Duration(seconds: 5),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          Navigator.of(context).pop(); // Close loading dialog
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.rebootFailedWithError(l10n.rebootFailed, e.toString())),
              backgroundColor: Colors.red,
            ),
          );
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

