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

/// Reusable expansion tile for navigation sections in the app drawer
class ExpansionNavigationTile extends StatelessWidget {
  final IconData icon;
  final Widget title;
  final bool initiallyExpanded;
  final ValueChanged<bool> onExpansionChanged;
  final List<Widget> children;
  final EdgeInsetsGeometry? tilePadding;

  const ExpansionNavigationTile({
    super.key,
    required this.icon,
    required this.title,
    required this.initiallyExpanded,
    required this.onExpansionChanged,
    required this.children,
    this.tilePadding,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: Icon(icon),
      title: title,
      initiallyExpanded: initiallyExpanded,
      tilePadding: tilePadding,
      onExpansionChanged: onExpansionChanged,
      children: children,
    );
  }
}


