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

/// Navigation route name constants used throughout the app drawer and screens.
class Routes {
  Routes._();

  // ── Main routes ─────────────────────────────────────────────────────────────
  static const String dashboard = 'dashboard';
  static const String systemInfo = 'system_info';
  static const String settings = 'settings';
  static const String switchProfile = 'switch_profile';

  // ── System log file routes ───────────────────────────────────────────────────
  static const String systemLogAudit   = 'system_log_audit';
  static const String systemLogBackend = 'system_log_backend';
  static const String systemLogBoot    = 'system_log_boot';
  static const String systemLogGeneral = 'system_log_general';
  static const String systemLogWebGui  = 'system_log_web_gui';

  // ── Network routes ───────────────────────────────────────────────────────────
  static const String liveNetworkMonitor = 'live_network_monitor';
  static const String dhcpLeases = 'dhcp_leases';
  static const String neighborDiscovery = 'neighbor_discovery';
  static const String wol = 'wol';

  // ── Firewall routes ──────────────────────────────────────────────────────────
  static const String firewallRules = 'firewall_rules';
  static const String firewallAliases = 'firewall_aliases';
  static const String firewallLogs = 'firewall_logs';

  // ── WireGuard routes ─────────────────────────────────────────────────────────
  static const String wireguardServers = 'wireguard_servers';
  static const String wireguardPeers = 'wireguard_peers';
  static const String wireguardPeerGenerator = 'wireguard_peer_generator';
  static const String wireguardStatus = 'wireguard_status';
  static const String wireguardLogs = 'wireguard_logs';

  // ── OpenVPN routes ───────────────────────────────────────────────────────────
  static const String openvpnInstances = 'openvpn_instances';
  static const String openvpnClientOverrides = 'openvpn_client_overrides';
  static const String openvpnClientOverrideForm = 'openvpn_client_override_form';
  static const String openvpnConnectionStatus = 'openvpn_connection_status';
  static const String openvpnLogs = 'openvpn_logs';

  // ── Tailscale routes ─────────────────────────────────────────────────────────
  static const String tailscaleAuthentication = 'tailscale_authentication';
  static const String tailscaleSettings = 'tailscale_settings';
  static const String tailscaleStatus = 'tailscale_status';

  // ── Reporting routes ─────────────────────────────────────────────────────────
  static const String networkInsight = 'reporting_network_insight';
  static const String netflow = 'reporting_netflow';
  static const String unboundDns = 'reporting_unbound_dns';

  // ── Section prefix strings (used with NavigationService.isRouteInSection) ───
  static const String firewallPrefix = 'firewall_';
  static const String vpnPrefix = 'vpn_';
  static const String wireguardPrefix = 'wireguard_';
  static const String openvpnPrefix = 'openvpn_';
  static const String tailscalePrefix = 'tailscale_';
  static const String networkPrefix = 'network_';
  static const String systemLogPrefix = 'system_log_';
  static const String reportingPrefix = 'reporting_';
}
