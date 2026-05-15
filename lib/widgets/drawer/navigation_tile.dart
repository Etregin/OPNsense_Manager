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
import '../../services/navigation/navigation_service.dart';

/// Reusable navigation list tile for the app drawer
class NavigationTile extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String currentRoute;
  final String targetRoute;
  final Widget? destination;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? titleStyle;
  final Color? iconColor;
  final Future<bool> Function()? onBeforeNavigate;

  const NavigationTile({
    super.key,
    this.icon,
    required this.title,
    required this.currentRoute,
    required this.targetRoute,
    this.destination,
    this.onTap,
    this.contentPadding,
    this.titleStyle,
    this.iconColor,
    this.onBeforeNavigate,
  }) : assert(
          destination != null || onTap != null,
          'Either destination or onTap must be provided',
        );

  @override
  Widget build(BuildContext context) {
    final isSelected = NavigationService.isRouteActive(currentRoute, targetRoute);

    return ListTile(
      leading: icon != null
          ? Icon(icon, color: iconColor)
          : const SizedBox(width: 16),
      title: Text(
        title,
        style: titleStyle,
      ),
      selected: isSelected,
      contentPadding: contentPadding,
      onTap: () async {
        if (onTap != null) {
          onTap!();
        } else if (destination != null) {
          if (onBeforeNavigate != null) {
            await NavigationService.navigateWithCheck(
              context: context,
              destination: destination!,
              currentRoute: currentRoute,
              targetRoute: targetRoute,
              onBeforeNavigate: onBeforeNavigate,
            );
          } else {
            NavigationService.navigate(
              context: context,
              destination: destination!,
              currentRoute: currentRoute,
              targetRoute: targetRoute,
            );
          }
        }
      },
    );
  }
}


