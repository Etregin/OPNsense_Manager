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

/// Model representing an OpenVPN session
class OpenvpnSession {
  final String id;
  final String? serviceId;
  final String type;
  final String description;
  final String? socket;
  final String? status;

  OpenvpnSession({
    required this.id,
    this.serviceId,
    required this.type,
    required this.description,
    this.socket,
    this.status,
  });

  factory OpenvpnSession.fromJson(Map<String, dynamic> json) {
    return OpenvpnSession(
      id: json['id'] as String,
      serviceId: json['service_id'] as String?,
      type: json['type'] as String,
      description: json['description'] as String,
      socket: json['socket'] as String?,
      status: json['status'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'service_id': serviceId,
      'type': type,
      'description': description,
      'socket': socket,
      'status': status,
    };
  }

  /// Check if the session is running (status is "ok")
  bool get isRunning => status == 'ok';

  /// Check if the session can be started
  bool get canStart => !isRunning;

  /// Check if the session can be stopped or restarted
  bool get canStopOrRestart => isRunning;
}


