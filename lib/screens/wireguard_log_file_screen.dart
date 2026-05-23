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

// TODO: Implement log file viewer

import 'package:flutter/material.dart';

/// Screen for viewing WireGuard log files
class WireGuardLogFileScreen extends StatefulWidget {
  const WireGuardLogFileScreen({super.key});

  @override
  State<WireGuardLogFileScreen> createState() => _WireGuardLogFileScreenState();
}

class _WireGuardLogFileScreenState extends State<WireGuardLogFileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WireGuard Logs'),
      ),
      body: const Center(
        child: Text('Log file viewer - to be implemented'),
      ),
    );
  }
}

// Made with Bob
