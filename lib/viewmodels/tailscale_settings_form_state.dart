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
import '../models/tailscale_settings.dart';

/// Manages form state for Tailscale settings
class TailscaleSettingsFormState {
  final TextEditingController loginTimeoutController;
  final TextEditingController listenPortController;
  
  bool enabled;
  bool acceptDNS;
  bool advertiseExitNode;
  bool acceptSubnetRoutes;
  bool enableSSH;
  bool disableSNAT;
  String? selectedExitNode;

  TailscaleSettingsFormState({
    required this.loginTimeoutController,
    required this.listenPortController,
    this.enabled = false,
    this.acceptDNS = false,
    this.advertiseExitNode = false,
    this.acceptSubnetRoutes = false,
    this.enableSSH = false,
    this.disableSNAT = false,
    this.selectedExitNode,
  });

  /// Initialize form fields from settings
  void initializeFromSettings(TailscaleSettings settings) {
    loginTimeoutController.text = settings.loginTimeout ?? '';
    listenPortController.text = settings.listenPort ?? '';
    
    enabled = settings.enabled ?? false;
    acceptDNS = settings.acceptDNS ?? false;
    advertiseExitNode = settings.advertiseExitNode ?? false;
    acceptSubnetRoutes = settings.acceptSubnetRoutes ?? false;
    enableSSH = settings.enableSSH ?? false;
    disableSNAT = settings.disableSNAT ?? false;

    // Find selected exit node
    selectedExitNode = null;
    if (settings.useExitNode != null) {
      for (var entry in settings.useExitNode!.entries) {
        if (entry.value.selected) {
          selectedExitNode = entry.key;
          break;
        }
      }
    }
  }

  /// Convert form state to TailscaleSettings object
  TailscaleSettings toSettings(TailscaleSettings originalSettings) {
    return TailscaleSettings(
      enabled: enabled,
      acceptDNS: acceptDNS,
      advertiseExitNode: advertiseExitNode,
      acceptSubnetRoutes: acceptSubnetRoutes,
      enableSSH: enableSSH,
      disableSNAT: disableSNAT,
      loginTimeout: loginTimeoutController.text.trim().isEmpty
          ? null
          : loginTimeoutController.text.trim(),
      listenPort: listenPortController.text.trim().isEmpty
          ? null
          : listenPortController.text.trim(),
      useExitNode: originalSettings.useExitNode,
      subnets: originalSettings.subnets,
    );
  }

  /// Validate login timeout field
  String? validateLoginTimeout(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final timeout = int.tryParse(value);
    if (timeout == null || timeout < 0) {
      return 'Please enter a valid timeout in minutes';
    }
    return null;
  }

  /// Validate listen port field
  String? validateListenPort(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final port = int.tryParse(value);
    if (port == null || port < 1 || port > 65535) {
      return 'Please enter a valid port (1-65535)';
    }
    return null;
  }

  /// Dispose controllers
  void dispose() {
    loginTimeoutController.dispose();
    listenPortController.dispose();
  }
}


