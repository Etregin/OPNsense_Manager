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
import '../../constants/routes.dart';
import '../../l10n/app_localizations.dart';
import '../../screens/firewall_rules_screen.dart';
import '../../screens/firewall_aliases_screen.dart';
import '../../screens/firewall_logs_screen.dart';
import 'expansion_navigation_tile.dart';
import 'navigation_tile.dart';

/// Firewall navigation section for the app drawer
class FirewallNavigationSection extends StatelessWidget {
  final String currentRoute;
  final bool isExpanded;
  final ValueChanged<bool> onExpansionChanged;

  const FirewallNavigationSection({
    super.key,
    required this.currentRoute,
    required this.isExpanded,
    required this.onExpansionChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ExpansionNavigationTile(
      icon: Icons.security,
      title: Text(l10n.firewall),
      initiallyExpanded: isExpanded,
      onExpansionChanged: onExpansionChanged,
      children: [
        NavigationTile(
          title: l10n.firewallRules,
          currentRoute: currentRoute,
          targetRoute: Routes.firewallRules,
          destination: const FirewallRulesScreen(),
          contentPadding: const EdgeInsets.only(left: 40, right: 16),
        ),
        NavigationTile(
          title: l10n.aliases,
          currentRoute: currentRoute,
          targetRoute: Routes.firewallAliases,
          destination: const FirewallAliasesScreen(),
          contentPadding: const EdgeInsets.only(left: 40, right: 16),
        ),
        NavigationTile(
          title: l10n.firewallLogs,
          currentRoute: currentRoute,
          targetRoute: Routes.firewallLogs,
          destination: const FirewallLogsScreen(),
          contentPadding: const EdgeInsets.only(left: 40, right: 16),
        ),
      ],
    );
  }
}


