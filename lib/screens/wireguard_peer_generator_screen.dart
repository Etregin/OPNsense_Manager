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

// TODO: Implement peer configuration generator

import 'package:flutter/material.dart';

/// Screen for generating WireGuard peer configurations
class WireGuardPeerGeneratorScreen extends StatefulWidget {
  const WireGuardPeerGeneratorScreen({super.key});

  @override
  State<WireGuardPeerGeneratorScreen> createState() => _WireGuardPeerGeneratorScreenState();
}

class _WireGuardPeerGeneratorScreenState extends State<WireGuardPeerGeneratorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Peer Generator'),
      ),
      body: const Center(
        child: Text('Peer Generator - to be implemented'),
      ),
    );
  }
}


