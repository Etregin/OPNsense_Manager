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
import '../../l10n/app_localizations.dart';
import '../../models/thermal_sensor.dart';
import '../../utils/app_colors.dart';
import '../../utils/color_helpers.dart';

/// Widget for displaying thermal sensor readings in a compact format.
class ThermalSensorsSection extends StatelessWidget {
  final List<ThermalSensor> sensors;

  const ThermalSensorsSection({
    super.key,
    required this.sensors,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.thermalSensors,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            if (sensors.isEmpty)
              Text(
                l10n.noThermalSensorsAvailable,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: AppColors.opacityMuted),
                    ),
              )
            else
              _buildCompactSensorList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactSensorList(BuildContext context) {
    final groupedSensors = _groupSensors(sensors);
    final orderedSensors = [
      ...groupedSensors['cpu'] ?? const <ThermalSensor>[],
      ...groupedSensors['zone'] ?? const <ThermalSensor>[],
      ...groupedSensors.entries
          .where((entry) => entry.key != 'cpu' && entry.key != 'zone')
          .expand((entry) => entry.value),
    ];

    return Column(
      children: orderedSensors.asMap().entries.map((entry) {
        final index = entry.key;
        final sensor = entry.value;
        final isLast = index == orderedSensors.length - 1;
        
        return Column(
          children: [
            _CompactSensorRow(sensor: sensor),
            if (!isLast)
              const Divider(
                height: 1,
                thickness: 1,
              ),
          ],
        );
      }).toList(),
    );
  }

  Map<String, List<ThermalSensor>> _groupSensors(List<ThermalSensor> sensors) {
    final grouped = <String, List<ThermalSensor>>{};

    for (final sensor in sensors) {
      final key = sensor.type.trim().toLowerCase();
      grouped.putIfAbsent(key, () => []).add(sensor);
    }

    for (final entry in grouped.entries) {
      entry.value.sort((a, b) {
        final seqCompare = a.deviceSeq.compareTo(b.deviceSeq);
        if (seqCompare != 0) {
          return seqCompare;
        }

        return a.device.compareTo(b.device);
      });
    }

    return grouped;
  }
}

/// Compact row widget for displaying a single thermal sensor.
class _CompactSensorRow extends StatelessWidget {
  final ThermalSensor sensor;

  const _CompactSensorRow({required this.sensor});

  @override
  Widget build(BuildContext context) {
    final temperature = sensor.temperatureValue;
    final color = thermalColor(temperature);
    final sensorName = _safeText(sensor.typeTranslated, fallback: 'Unknown');
    final deviceName = _safeText(sensor.device, fallback: 'Unknown device');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      child: Row(
        children: [
          // Icon with color background
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: AppColors.opacitySubtle),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.thermostat,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          // Sensor name and device
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sensorName,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  deviceName,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: AppColors.opacityMuted),
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Temperature value
          Text(
            '${temperature.toStringAsFixed(1)}°C',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
          const SizedBox(width: 8),
          // Color indicator dot
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }

  String _safeText(String value, {required String fallback}) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? fallback : trimmed;
  }
}


