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

/// Centralised OPNsense API endpoint strings.
///
/// Every path used by the service layer lives here. Static paths are
/// `const String` fields; paths with URL segments are factory methods.
class ApiEndpoints {
  ApiEndpoints._();

  // ── System ──────────────────────────────────────────────────────────────────
  static const String systemStatus = '/core/system/status';
  static const String firmwareInfo = '/core/firmware/info';
  static const String firmwareStatus = '/core/firmware/status';
  static const String firmwareCheck = '/core/firmware/check';
  static const String firmwareUpdate = '/core/firmware/update';
  static const String firmwareUpgradeStatus = '/core/firmware/upgradestatus';
  static String firmwareChangelog(String version) => '/core/firmware/changelog/$version';
  static const String systemInfo = '/core/system/info';
  static const String systemDisk = '/core/system/systemDisk';
  static const String systemReboot = '/core/system/reboot';

  // ── Diagnostics ─────────────────────────────────────────────────────────────
  static const String diagnosticsActivity = '/diagnostics/activity/getActivity';
  static const String diagnosticsSystemDisk = '/diagnostics/system/systemDisk';
  static const String diagnosticsSystemResources = '/diagnostics/system/systemResources';
  static const String diagnosticsSystemTemperature = '/diagnostics/system/system_temperature';
  static const String diagnosticsFirewallLog = '/diagnostics/firewall/log';
  static const String diagnosticsTrafficTop = '/diagnostics/traffic/top';
  static const String diagnosticsLogOpenvpn = '/diagnostics/log/core/openvpn';
  static const String diagnosticsLogWireguard = '/diagnostics/log/core/wireguard';
  static const String diagnosticsLogAudit   = '/diagnostics/log/core/audit';
  static const String diagnosticsLogBackend = '/diagnostics/log/core/configd';
  static const String diagnosticsLogBoot    = '/diagnostics/log/core/boot';
  static const String diagnosticsLogGeneral = '/diagnostics/log/core/system';
  static const String diagnosticsLogWebGui  = '/diagnostics/log/core/lighttpd';

  // ── Core service control ─────────────────────────────────────────────────────
  static const String coreServiceSearch = '/core/service/search';
  static String coreServiceAction(String action, String id) =>
      '/core/service/$action/$id';

  // ── Firewall ─────────────────────────────────────────────────────────────────
  static const String firewallRulesSearch = '/firewall/filter/search_rule';
  static const String firewallPortSelectOptions = '/firewall/filter/list_port_select_options';
  static const String firewallRuleAdd = '/firewall/filter/add_rule';
  static const String firewallRulesApply = '/firewall/filter/apply';
  static String firewallRuleGetOne(String uuid) =>
      '/firewall/filter/getRule/$uuid';
  static String firewallRuleSet(String uuid) =>
      '/firewall/filter/set_rule/$uuid';
  static String firewallRuleToggle(String uuid) =>
      '/firewall/filter/toggleRule/$uuid';
  static String firewallRuleDelete(String uuid) =>
      '/firewall/filter/delRule/$uuid';

  // ── Tailscale ────────────────────────────────────────────────────────────────
  static const String tailscaleServiceStatus = '/tailscale/service/status';
  static const String tailscaleServiceRestart = '/tailscale/service/restart';
  static const String tailscaleStatusGet = '/tailscale/status/status';
  static const String tailscaleSettingsGet = '/tailscale/settings/get';
  static const String tailscaleAuthGet = '/tailscale/authentication/get';

  // ── OpenVPN ──────────────────────────────────────────────────────────────────
  static const String openvpnInstancesSearch = '/openvpn/instances/search/';
  static const String openvpnInstancesAdd = '/openvpn/instances/add/';
  static const String openvpnInstancesGetNew = '/openvpn/instances/get/';
  static const String openvpnServiceReconfigure = '/openvpn/service/reconfigure';
  static const String openvpnServiceSearchSessions = '/openvpn/service/searchSessions';
  static const String openvpnInstancesSearchSessions = '/openvpn/service/search_sessions';
  static const String openvpnInstancesSearchRoutes = '/openvpn/service/search_routes';
  static const String openvpnStaticKeySearch = '/openvpn/instances/search_static_key/';
  static const String openvpnStaticKeyGetNew = '/openvpn/instances/get_static_key/';
  static const String openvpnStaticKeyAdd = '/openvpn/instances/add_static_key/';
  static const String openvpnAuthTokenGenerate = '/openvpn/instances/gen_key/auth-token';
  static const String openvpnClientOverridesSearch = '/openvpn/client_overwrites/search/';
  static const String openvpnClientOverrideGetNew = '/openvpn/client_overwrites/get/';
  static const String openvpnClientOverrideAdd = '/openvpn/client_overwrites/add/';
  static String openvpnInstanceGet(String vpnid) =>
      '/openvpn/instances/get/$vpnid';
  static String openvpnInstanceSet(String vpnid) =>
      '/openvpn/instances/set/$vpnid';
  static String openvpnInstanceDelete(String vpnid) =>
      '/openvpn/instances/del/$vpnid';
  static String openvpnInstanceToggle(String vpnid) =>
      '/openvpn/instances/toggle/$vpnid';
  static String openvpnStaticKeyGet(String keyid) =>
      '/openvpn/instances/get_static_key/$keyid';
  static String openvpnStaticKeySet(String keyid) =>
      '/openvpn/instances/set_static_key/$keyid';
  static String openvpnStaticKeyDelete(String keyid) =>
      '/openvpn/instances/del_static_key/$keyid';
  static String openvpnStaticKeyGenerate(String mode) =>
      '/openvpn/instances/gen_key/$mode';
  static String openvpnClientOverrideGet(String uuid) =>
      '/openvpn/client_overwrites/get/$uuid';
  static String openvpnClientOverrideSet(String uuid) =>
      '/openvpn/client_overwrites/set/$uuid';
  static String openvpnClientOverrideDelete(String uuid) =>
      '/openvpn/client_overwrites/del/$uuid';
  static String openvpnClientOverrideToggle(String uuid) =>
      '/openvpn/client_overwrites/toggle/$uuid';
  static String openvpnServiceStart(String id) =>
      '/openvpn/service/start_service/$id';
  static String openvpnServiceStop(String id) =>
      '/openvpn/service/stop_service/$id';
  static String openvpnServiceRestart(String id) =>
      '/openvpn/service/restart_service/$id';

  // ── WireGuard ────────────────────────────────────────────────────────────────
  static const String wireguardServerSearch = '/wireguard/server/search_server';
  static const String wireguardServerAdd = '/wireguard/server/add_server';
  static const String wireguardServerPeerSearch = '/wireguard/server/search_peer';
  static const String wireguardServerKeyPair = '/wireguard/server/key_pair';
  static const String wireguardClientSearch = '/wireguard/client/search_client';
  static const String wireguardClientAdd = '/wireguard/client/add_client';
  static const String wireguardClientPsk = '/wireguard/client/psk';
  static const String wireguardClientBuilderGet = '/wireguard/client/get_client_builder';
  static const String wireguardClientBuilderAdd = '/wireguard/client/add_client_builder';
  static const String wireguardServiceShow = '/wireguard/service/show';
  static const String wireguardServiceStart = '/wireguard/service/start';
  static const String wireguardServiceStop = '/wireguard/service/stop';
  static const String wireguardServiceRestart = '/wireguard/service/restart';
  static const String wireguardServiceReconfigure = '/wireguard/service/reconfigure';
  static String wireguardServerGet(String uuid) =>
      '/wireguard/server/get_server/$uuid';
  static String wireguardServerSet(String uuid) =>
      '/wireguard/server/set_server/$uuid';
  static String wireguardServerDelete(String uuid) =>
      '/wireguard/server/del_server/$uuid';
  static String wireguardServerToggle(String uuid) =>
      '/wireguard/server/toggle_server/$uuid';
  static String wireguardClientGet(String uuid) =>
      '/wireguard/client/get_client/$uuid';
  static String wireguardClientSet(String uuid) =>
      '/wireguard/client/set_client/$uuid';
  static String wireguardClientDelete(String uuid) =>
      '/wireguard/client/del_client/$uuid';
  static String wireguardClientToggle(String uuid) =>
      '/wireguard/client/toggle_client/$uuid';
  static String wireguardPeerGet(String uuid) =>
      '/wireguard/server/get_peer/$uuid';
  static String wireguardServiceInstanceStart(String uuid) =>
      '/wireguard/service/start/$uuid';
  static String wireguardServiceInstanceStop(String uuid) =>
      '/wireguard/service/stop/$uuid';
  static String wireguardServiceInstanceRestart(String uuid) =>
      '/wireguard/service/restart/$uuid';
  static String wireguardServerInfoGet(String uuid) =>
      '/wireguard/client/get_server_info/$uuid';

  // ── Network / Traffic ────────────────────────────────────────────────────────
  static String diagnosticsTrafficTopInterface(String interface) =>
      '/diagnostics/traffic/top/$interface';

  // ── NetFlow / Network Insight ────────────────────────────────────────────────
  static const String netflowIsEnabled =
      '/diagnostics/netflow/is_enabled';
  static const String netflowGetConfig = '/diagnostics/netflow/getconfig';
  static const String netflowSetConfig = '/diagnostics/netflow/setconfig';
  static const String netflowReconfigure = '/diagnostics/netflow/reconfigure';
  static const String netflowReset = '/diagnostics/netflow/reset';
  static const String netflowCacheStats = '/diagnostics/netflow/cache_stats';
  static const String diagnosticsDnsReverseLookup =
      '/diagnostics/dns/reverse_lookup';
  static const String networkInsightGetInterfaces =
      '/diagnostics/networkinsight/get_interfaces';
  static const String networkInsightGetMetadata =
      '/diagnostics/networkinsight/get_metadata';

  /// Time-series bandwidth data endpoint.
  ///
  /// Example: `/diagnostics/networkinsight/timeserie/FlowInterfaceTotals/bps/{start}/{end}/{resolution}/if,direction`
  static String networkInsightTimeserie({
    required String aggregator,
    required String measure,
    required int startTs,
    required int endTs,
    required int resolution,
    required String dimensions,
  }) =>
      '/diagnostics/networkinsight/timeserie/$aggregator/$measure/$startTs/$endTs/$resolution/$dimensions';

  /// Top-N ranked breakdown endpoint.
  ///
  /// Filter parameters (`filter_field`, `filter_value`) must be passed via
  /// Dio `queryParameters` — not appended to this path string.
  ///
  /// Example: `/diagnostics/networkinsight/top/FlowDstPortTotals/{start}/{end}/dst_port,protocol/octets/25/`
  static String networkInsightTop({
    required String aggregator,
    required int startTs,
    required int endTs,
    required String dimensions,
    required String measure,
    required int limit,
  }) =>
      '/diagnostics/networkinsight/top/$aggregator/$startTs/$endTs/$dimensions/$measure/$limit/';

  /// Network Insight CSV export endpoint.
  ///
  /// Example: `/diagnostics/networkinsight/export/FlowSourceAddrDetails/1788739200/1788825599/86400`
  static String networkInsightExport({
    required String collection,
    required int fromTs,
    required int toTs,
    required int resolution,
  }) =>
      '/diagnostics/networkinsight/export/$collection/$fromTs/$toTs/$resolution';

  // ── Unbound DNS Reporting ───────────────────────────────────────────────────
  static const String unboundOverviewIsEnabled = '/unbound/overview/is_enabled';
  static const String unboundOverviewReset = '/unbound/overview/reset';
  static const String unboundOverviewGetPolicies = '/unbound/overview/get_policies';
  static const String unboundOverviewSearchQueries = '/unbound/overview/search_queries/';
  static const String unboundSettingsGet = '/unbound/settings/get';
  static const String unboundSettingsSet = '/unbound/settings/set';
  static const String unboundServiceReconfigureGeneral = '/unbound/service/reconfigure_general';
  static const String unboundServiceStatus = '/unbound/service/status';

  /// Unbound DNS rolling queries endpoint.
  /// [hours] is typically 24, 12, or 1.
  /// When [clientActivity] is true (passes `/1` suffix), returns top client activity time series.
  static String unboundOverviewRolling(int hours, {bool clientActivity = false}) =>
      clientActivity
          ? '/unbound/overview/rolling/$hours/1'
          : '/unbound/overview/rolling/$hours';

  /// Unbound DNS totals endpoint with domain limit.
  /// [limit] is typically 10, 25, 50, 75, 100.
  static String unboundOverviewTotals(int limit) =>
      '/unbound/overview/totals/$limit';
}
