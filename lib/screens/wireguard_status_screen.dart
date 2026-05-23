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

// TODO: Implement WireGuard service status display

import 'package:flutter/material.dart';

/// Screen for displaying WireGuard service status
class WireGuardStatusScreen extends StatefulWidget {
  const WireGuardStatusScreen({super.key});

  @override
  State<WireGuardStatusScreen> createState() => _WireGuardStatusScreenState();
}

class _WireGuardStatusScreenState extends State<WireGuardStatusScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WireGuard Status'),
      ),
      body: const Center(
        child: Text('Status screen - to be implemented'),
      ),
    );
  }
}


