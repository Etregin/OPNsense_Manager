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

/// Holds all dynamic dropdown option maps for the firewall rule form.
/// Each map is key → display label (e.g. {'': 'None', 'WAN_PPPOE': 'WAN_PPPOE - 10.45.3.134'}).
class FirewallFormOptions {
  final Map<String, String> gateways;
  final Map<String, String> replyTo;
  final Map<String, String> divertTo;
  final Map<String, String> overload;
  final Map<String, String> schedules;
  final Map<String, String> shapers;
  final Map<String, String> prio;
  final Map<String, String> setPrio;
  final Map<String, String> tos;
  /// Firewall rule categories: uuid/name → display name
  final Map<String, String> categories;
  /// Port select options from list_port_select_options.
  /// Key = API value sent (e.g. 'http', '80', ''), value = display label.
  /// Entry with key '' represents "any". Entry with key 'single' represents
  /// the free-text "Single port or range" option.
  final Map<String, String> portOptions;

  const FirewallFormOptions({
    required this.gateways,
    required this.replyTo,
    required this.divertTo,
    required this.overload,
    required this.schedules,
    required this.shapers,
    required this.prio,
    required this.setPrio,
    required this.tos,
    required this.categories,
    this.portOptions = const {},
  });

  /// Empty / fallback options used before data loads or on error.
  factory FirewallFormOptions.defaults() => const FirewallFormOptions(
        gateways:   {'': 'None'},
        replyTo:    {'': 'None'},
        divertTo:   {'': 'None'},
        overload:   {'': 'None'},
        schedules:  {'': 'None'},
        shapers:    {'': 'None'},
        prio:       {'': 'Any priority'},
        setPrio:    {'': 'Keep current priority'},
        tos:        {'': 'Any'},
        categories: {},
        portOptions: {},
      );
}
