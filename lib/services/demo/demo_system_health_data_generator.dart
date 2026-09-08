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

import 'dart:math' as math;

import '../../models/system_health_graph.dart';
import '../../models/system_health_rrd_list.dart';
import '../../models/system_health_status.dart';

/// Generates stable, plausible mock data for the system-health (RRD) reporting
/// feature in demo mode.
///
/// The generated metadata mirrors the category/subject/file/interface layout
/// from the documented API response. Graph series are generated with realistic
/// sinusoidal + noise profiles so charts render meaningfully.
class DemoSystemHealthDataGenerator {
  // ---------------------------------------------------------------------------
  // Status
  // ---------------------------------------------------------------------------

  SystemHealthStatus generateStatus() => SystemHealthStatus.fromJson(const {
    'systemhealth': {'enabled': '1'},
  });

  // ---------------------------------------------------------------------------
  // RRD list metadata
  // ---------------------------------------------------------------------------

  SystemHealthRrdList generateRrdList() => const SystemHealthRrdList(
    data: {
      'packets': ['ipsec', 'lan', 'wan', 'opt1'],
      'services': ['ntpd'],
      'system': ['mbuf', 'memory', 'processor', 'states'],
      'traffic': ['ipsec', 'lan', 'wan', 'opt1'],
    },
    files: [
      SystemHealthRrdFile(key: 'ipsec-packets', filename: 'ipsec-packets.rrd'),
      SystemHealthRrdFile(key: 'ipsec-traffic', filename: 'ipsec-traffic.rrd'),
      SystemHealthRrdFile(key: 'lan-packets', filename: 'lan-packets.rrd'),
      SystemHealthRrdFile(key: 'lan-traffic', filename: 'lan-traffic.rrd'),
      SystemHealthRrdFile(key: 'ntpd', filename: 'ntpd.rrd'),
      SystemHealthRrdFile(key: 'opt1-packets', filename: 'opt1-packets.rrd'),
      SystemHealthRrdFile(key: 'opt1-traffic', filename: 'opt1-traffic.rrd'),
      SystemHealthRrdFile(key: 'system-mbuf', filename: 'system-mbuf.rrd'),
      SystemHealthRrdFile(key: 'system-memory', filename: 'system-memory.rrd'),
      SystemHealthRrdFile(
        key: 'system-processor',
        filename: 'system-processor.rrd',
      ),
      SystemHealthRrdFile(key: 'system-states', filename: 'system-states.rrd'),
      SystemHealthRrdFile(key: 'wan-packets', filename: 'wan-packets.rrd'),
      SystemHealthRrdFile(key: 'wan-traffic', filename: 'wan-traffic.rrd'),
    ],
    interfaces: {
      'wan': SystemHealthInterface(descr: 'wan'),
      'lan': SystemHealthInterface(descr: 'lan'),
      'lo0': SystemHealthInterface(descr: 'Loopback'),
      'opt1': SystemHealthInterface(descr: 'WAN2_MIFI'),
    },
  );

  // ---------------------------------------------------------------------------
  // Graph data — category-aware plausible series
  // ---------------------------------------------------------------------------

  /// Returns plausible graph data for the given RRD file [key].
  ///
  /// Series names and value ranges are selected based on the category embedded
  /// in the key:
  ///   - `*-packets` → byte/packet counters (inpass, outpass, inblock, outblock)
  ///   - `*-traffic` → throughput in bytes/s (in, out)
  ///   - `system-*`  → system resource utilisation (category-specific series)
  ///   - service keys (e.g. `ntpd`) → offset metrics (offset, frequency)
  SystemHealthGraphResponse generateGraph(String key) {
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    // Align to last minute boundary so points are at clean intervals.
    final alignedNowMs = (nowMs ~/ 60000) * 60000;

    if (key.endsWith('-packets')) {
      return _buildGraph(
        alignedNowMs: alignedNowMs,
        title: key,
        yAxisLabel: 'Packets/Second',
        seriesSpecs: const [
          _SeriesSpec('inpass', baseValue: 250, amplitude: 180, periodMin: 40),
          _SeriesSpec('outpass', baseValue: 180, amplitude: 120, periodMin: 40),
          _SeriesSpec('inblock', baseValue: 8, amplitude: 5, periodMin: 20),
          _SeriesSpec('outblock', baseValue: 3, amplitude: 2, periodMin: 20),
        ],
      );
    }

    if (key.endsWith('-traffic')) {
      return _buildGraph(
        alignedNowMs: alignedNowMs,
        title: key,
        yAxisLabel: 'Bytes/Second',
        seriesSpecs: const [
          _SeriesSpec(
            'in',
            baseValue: 180000,
            amplitude: 120000,
            periodMin: 45,
          ),
          _SeriesSpec('out', baseValue: 45000, amplitude: 30000, periodMin: 45),
        ],
      );
    }

    if (key == 'processor-system') {
      return _buildGraph(
        alignedNowMs: alignedNowMs,
        title: key,
        yAxisLabel: '[U]tilization, [#]Number',
        seriesSpecs: const [
          _SeriesSpec('user', baseValue: 18, amplitude: 14, periodMin: 30),
          _SeriesSpec('system', baseValue: 6, amplitude: 4, periodMin: 25),
          _SeriesSpec('interrupt', baseValue: 2, amplitude: 1.5, periodMin: 15),
          _SeriesSpec('nice', baseValue: 0.5, amplitude: 0.3, periodMin: 60),
        ],
      );
    }

    if (key == 'memory-system') {
      return _buildGraph(
        alignedNowMs: alignedNowMs,
        title: key,
        seriesSpecs: const [
          _SeriesSpec(
            'active',
            baseValue: 680000000,
            amplitude: 60000000,
            periodMin: 60,
          ),
          _SeriesSpec(
            'inactive',
            baseValue: 220000000,
            amplitude: 40000000,
            periodMin: 80,
          ),
          _SeriesSpec(
            'wired',
            baseValue: 350000000,
            amplitude: 20000000,
            periodMin: 120,
          ),
          _SeriesSpec(
            'free',
            baseValue: 140000000,
            amplitude: 50000000,
            periodMin: 60,
          ),
        ],
      );
    }

    if (key == 'mbuf-system') {
      return _buildGraph(
        alignedNowMs: alignedNowMs,
        title: key,
        seriesSpecs: const [
          _SeriesSpec(
            'current',
            baseValue: 3200,
            amplitude: 800,
            periodMin: 35,
          ),
          _SeriesSpec('cache', baseValue: 1600, amplitude: 400, periodMin: 40),
          _SeriesSpec('total', baseValue: 5000, amplitude: 600, periodMin: 50),
          _SeriesSpec('max', baseValue: 25600, amplitude: 0, periodMin: 60),
        ],
      );
    }

    if (key == 'states-system') {
      return _buildGraph(
        alignedNowMs: alignedNowMs,
        title: key,
        seriesSpecs: const [
          _SeriesSpec(
            'current',
            baseValue: 12000,
            amplitude: 5000,
            periodMin: 45,
          ),
          _SeriesSpec('max', baseValue: 100000, amplitude: 0, periodMin: 60),
        ],
      );
    }

    // Service key (e.g. ntpd-services) — NTP clock offset + frequency
    return _buildGraph(
      alignedNowMs: alignedNowMs,
      title: key,
      seriesSpecs: const [
        _SeriesSpec(
          'offset',
          baseValue: 0.003,
          amplitude: 0.002,
          periodMin: 30,
        ),
        _SeriesSpec('frequency', baseValue: 0.0, amplitude: 5.0, periodMin: 60),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  /// Build a 24-hour graph at 60-second resolution (1440 points per series).
  SystemHealthGraphResponse _buildGraph({
    required int alignedNowMs,
    required String title,
    String yAxisLabel = '',
    required List<_SeriesSpec> seriesSpecs,
  }) {
    const stepMs = 60 * 1000; // 60-second RRD step
    const pointCount = 24 * 60; // 1440 points = 24 h
    final startMs = alignedNowMs - (pointCount - 1) * stepMs;

    // Seed from the key text so graphs are consistent across calls.
    final seed = seriesSpecs.fold<int>(0, (acc, s) => acc ^ s.key.hashCode);
    final rng = math.Random(seed);

    final seriesList = seriesSpecs.map((spec) {
      final values = <SystemHealthPoint>[];
      for (int i = 0; i < pointCount; i++) {
        final tsMs = startMs + i * stepMs;
        final phase = (i / pointCount) * 2 * math.pi * (60 / spec.periodMin);
        final signal = spec.amplitude * math.sin(phase);
        final noise = (rng.nextDouble() - 0.5) * spec.amplitude * 0.15;
        final v = (spec.baseValue + signal + noise).clamp(0.0, double.infinity);
        values.add(SystemHealthPoint(timestampMs: tsMs, value: v));
      }
      return SystemHealthSeries(key: spec.key, values: values);
    }).toList();

    return SystemHealthGraphResponse(
      step: 60,
      lastupdate: alignedNowMs ~/ 1000,
      title: title,
      yAxisLabel: yAxisLabel,
      set: SystemHealthDataSet(count: seriesList.length, data: seriesList),
    );
  }
}

/// Value-object describing how to generate one demo series.
///
/// All fields are final so instances can be used as `const`.
class _SeriesSpec {
  final String key;
  final double baseValue;
  final double amplitude;

  /// How many minutes one full sine period covers.
  final double periodMin;

  const _SeriesSpec(
    this.key, {
    required this.baseValue,
    required this.amplitude,
    required this.periodMin,
  });
}
