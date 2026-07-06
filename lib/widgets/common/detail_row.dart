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

/// A label-value row used in detail dialogs and bottom sheets.
///
/// Renders [label] in a fixed-width column followed by [value] in a flexible
/// expanded column.  Defaults match the most common pattern in the codebase:
/// 120 px label column, bold label text, 8 px bottom padding.
class DetailRow extends StatelessWidget {
  const DetailRow({
    super.key,
    required this.label,
    required this.value,
    this.labelWidth = 120.0,
    this.topPadding = 0.0,
    this.bottomPadding = 8.0,
    this.labelWeight = FontWeight.bold,
    this.labelColor,
    this.appendColon = true,
  });

  final String label;
  final String value;
  final double labelWidth;
  final double topPadding;
  final double bottomPadding;
  final FontWeight labelWeight;

  /// Override the label text color. Defaults to the theme's body color.
  final Color? labelColor;

  /// When true (default) a colon is appended to [label].
  final bool appendColon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding, bottom: bottomPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: labelWidth,
            child: Text(
              appendColon ? '$label:' : label,
              style: TextStyle(fontWeight: labelWeight, color: labelColor),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
