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

import 'package:json_annotation/json_annotation.dart';

part 'thermal_sensor.g.dart';

/// Represents a thermal sensor reading from OPNsense system
@JsonSerializable()
class ThermalSensor {
  /// Device name/identifier
  final String device;
  
  /// Device sequence number
  final int deviceSeq;
  
  /// Temperature reading as string (e.g., "45.0C")
  final String temperature;
  
  /// Translated sensor type description
  final String typeTranslated;
  
  /// Sensor type identifier
  final String type;

  ThermalSensor({
    required this.device,
    required this.deviceSeq,
    required this.temperature,
    required this.typeTranslated,
    required this.type,
  });

  /// Get temperature value as a double (removes 'C' suffix and parses)
  double get temperatureValue {
    // Remove 'C' suffix and any whitespace, then parse
    final tempStr = temperature.replaceAll(RegExp(r'[^\d.-]'), '');
    return double.tryParse(tempStr) ?? 0.0;
  }

  /// Create from JSON
  factory ThermalSensor.fromJson(Map<String, dynamic> json) =>
      _$ThermalSensorFromJson(json);

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$ThermalSensorToJson(this);

  @override
  String toString() =>
      'ThermalSensor(device: $device, temperature: $temperature, type: $typeTranslated)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ThermalSensor &&
        other.device == device &&
        other.deviceSeq == deviceSeq;
  }

  @override
  int get hashCode => Object.hash(device, deviceSeq);
}

// Made with Bob
