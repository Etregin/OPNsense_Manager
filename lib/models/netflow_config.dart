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

/// Represents the netflow capture configuration returned by
/// `GET /api/diagnostics/netflow/getconfig`.
class NetflowConfig {
  /// All available listening interface options: key → display label.
  final Map<String, String> listeningInterfaceOptions;

  /// Keys of currently selected listening interfaces.
  final List<String> listeningInterfaces;

  /// All interface options available for WAN (egress-only) capture.
  final Map<String, String> wanInterfaceOptions;

  /// Keys of interfaces where only egress (outbound) flows are captured.
  final List<String> wanInterfaces;

  /// Available NetFlow version options: key → display label (e.g. v5 / v9).
  final Map<String, String> versionOptions;

  /// Currently selected NetFlow version key (e.g. "v9").
  final String version;

  /// Editable list of collector destinations (e.g. "127.0.0.1:2056").
  ///
  /// Unlike interfaces, destinations are a free-form list the user can
  /// add to, edit, or remove entries from.
  final List<String> targets;

  /// Whether local data capture is enabled.
  final bool captureLocal;

  /// Active flow timeout in seconds.
  final String activeTimeout;

  /// Inactive flow timeout in seconds.
  final String inactiveTimeout;

  const NetflowConfig({
    required this.listeningInterfaceOptions,
    required this.listeningInterfaces,
    required this.wanInterfaceOptions,
    required this.wanInterfaces,
    required this.versionOptions,
    required this.version,
    required this.targets,
    required this.captureLocal,
    required this.activeTimeout,
    required this.inactiveTimeout,
  });

  /// Parses the full `{"netflow": {...}}` response envelope.
  factory NetflowConfig.fromJson(Map<String, dynamic> json) {
    final nf = json['netflow'] as Map<String, dynamic>;
    final cap = nf['capture'] as Map<String, dynamic>;
    final collect = nf['collect'] as Map<String, dynamic>;

    // Targets: extract all keys (selected or not) as the editable list,
    // filtering to only those that were selected.
    final selectedTargets = _extractSelected(cap['targets']);

    return NetflowConfig(
      listeningInterfaceOptions: _extractOptions(cap['interfaces']),
      listeningInterfaces: _extractSelected(cap['interfaces']),
      wanInterfaceOptions: _extractOptions(cap['egress_only']),
      wanInterfaces: _extractSelected(cap['egress_only']),
      versionOptions: _extractOptions(cap['version']),
      version: _extractSelected(cap['version']).firstOrNull ?? '',
      // Use selected targets as the initial editable list; if none selected,
      // fall back to all available keys so the user can see what exists.
      targets: selectedTargets.isNotEmpty
          ? selectedTargets
          : _extractOptions(cap['targets']).keys.toList(),
      captureLocal: (collect['enable'] as String?) == '1',
      activeTimeout: (nf['activeTimeout'] as String?) ?? '',
      inactiveTimeout: (nf['inactiveTimeout'] as String?) ?? '',
    );
  }

  /// Builds the POST payload accepted by `setconfig`.
  Map<String, dynamic> toSetConfigPayload() {
    return {
      'netflow': {
        'capture': {
          'interfaces': listeningInterfaces.join(','),
          'egress_only': wanInterfaces.join(','),
          'version': version,
          'targets': targets.join(','),
        },
        'collect': {
          'enable': captureLocal ? '1' : '0',
        },
        'activeTimeout': activeTimeout,
        'inactiveTimeout': inactiveTimeout,
      },
    };
  }

  /// Returns a copy with the given fields replaced.
  NetflowConfig copyWith({
    List<String>? listeningInterfaces,
    List<String>? wanInterfaces,
    String? version,
    List<String>? targets,
    bool? captureLocal,
    String? activeTimeout,
    String? inactiveTimeout,
  }) {
    return NetflowConfig(
      listeningInterfaceOptions: listeningInterfaceOptions,
      listeningInterfaces: listeningInterfaces ?? this.listeningInterfaces,
      wanInterfaceOptions: wanInterfaceOptions,
      wanInterfaces: wanInterfaces ?? this.wanInterfaces,
      versionOptions: versionOptions,
      version: version ?? this.version,
      targets: targets ?? this.targets,
      captureLocal: captureLocal ?? this.captureLocal,
      activeTimeout: activeTimeout ?? this.activeTimeout,
      inactiveTimeout: inactiveTimeout ?? this.inactiveTimeout,
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  static Map<String, String> _extractOptions(dynamic field) {
    if (field is! Map) return {};
    return {
      for (final e in (field as Map<String, dynamic>).entries)
        e.key: (e.value as Map<String, dynamic>)['value'] as String? ?? e.key,
    };
  }

  static List<String> _extractSelected(dynamic field) {
    if (field is! Map) return [];
    return [
      for (final e in (field as Map<String, dynamic>).entries)
        if ((e.value as Map<String, dynamic>)['selected'] == 1) e.key,
    ];
  }
}
