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

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../models/system_health_graph.dart';
import '../../utils/app_colors.dart';
import '../../utils/constants.dart';

/// Multi-series line chart for a single [SystemHealthGraphResponse].
///
/// Each series in [response.set.data] is rendered as a distinct coloured line.
/// Null/NaN points are skipped so fl_chart gaps form naturally.
/// A legend row below the chart labels each series by its [SystemHealthSeries.key].
class SystemHealthChart extends StatelessWidget {
  final SystemHealthGraphResponse response;

  const SystemHealthChart({super.key, required this.response});

  // Fixed colour palette — cycles when series count exceeds palette length.
  static const List<Color> _palette = [
    AppColors.primary,
    AppColors.success,
    AppColors.error,
    AppColors.warning,
    AppColors.bandwidth,
    AppColors.secondary,
    AppColors.info,
    AppColors.disabled,
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final seriesList = response.set.data;

    if (seriesList.isEmpty) {
      return Center(child: Text(l10n.healthNoSeries));
    }

    // Build fl_chart spots for each series (skip null values).
    final lineBarsData = <LineChartBarData>[];
    for (var i = 0; i < seriesList.length; i++) {
      final series = seriesList[i];
      final color = _palette[i % _palette.length];
      final spots = <FlSpot>[];
      for (final p in series.values) {
        if (p.value != null) {
          // Use seconds since epoch for X axis (fl_chart uses double).
          spots.add(FlSpot(p.timestampMs / 1000.0, p.value!));
        }
      }
      if (spots.isEmpty) continue;
      lineBarsData.add(
        LineChartBarData(
          spots: spots,
          color: color,
          barWidth: 1.5,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            color: color.withValues(alpha: AppColors.opacityBare),
          ),
        ),
      );
    }

    if (lineBarsData.isEmpty) {
      return Center(child: Text(l10n.noDataAvailable));
    }

    // Compute axis range from all spots.
    double minX = double.infinity;
    double maxX = double.negativeInfinity;
    double maxY = 0;
    for (final bar in lineBarsData) {
      for (final spot in bar.spots) {
        if (spot.x < minX) minX = spot.x;
        if (spot.x > maxX) maxX = spot.x;
        if (spot.y > maxY) maxY = spot.y;
      }
    }
    if (maxY == 0) maxY = 1;

    final gridColor = theme.colorScheme.outlineVariant.withValues(
      alpha: AppColors.opacityDivider,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 220,
          child: LineChart(
            LineChartData(
              minX: minX,
              maxX: maxX,
              minY: 0,
              maxY: maxY * 1.1,
              lineBarsData: lineBarsData,
              clipData: const FlClipData.all(),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                getDrawingHorizontalLine: (_) =>
                    FlLine(color: gridColor, strokeWidth: 0.8),
                getDrawingVerticalLine: (_) =>
                    FlLine(color: gridColor, strokeWidth: 0.8),
              ),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 28,
                    interval: (maxX - minX) / 4,
                    getTitlesWidget: (value, meta) {
                      final dt = DateTime.fromMillisecondsSinceEpoch(
                        (value * 1000).toInt(),
                        isUtc: true,
                      ).toLocal();
                      final label =
                          '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
                      return SideTitleWidget(
                        meta: meta,
                        child: Text(
                          label,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  axisNameWidget: response.yAxisLabel.isEmpty
                      ? null
                      : Text(
                          response.yAxisLabel,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 48,
                    getTitlesWidget: (value, meta) {
                      if (value == meta.min || value == meta.max) {
                        return const SizedBox.shrink();
                      }
                      final label = _formatAxisValue(value);
                      return SideTitleWidget(
                        meta: meta,
                        child: Text(
                          label,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: gridColor),
              ),
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipColor: (_) =>
                      theme.colorScheme.surfaceContainerHighest,
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((spot) {
                      final seriesIndex = lineBarsData.indexOf(spot.bar);
                      final label =
                          seriesIndex >= 0 && seriesIndex < seriesList.length
                          ? seriesList[seriesIndex].key
                          : '?';
                      return LineTooltipItem(
                        '$label: ${_formatAxisValue(spot.y)}',
                        TextStyle(
                          color: spot.bar.color ?? theme.colorScheme.onSurface,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    }).toList();
                  },
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppConstants.compactPadding),
        _Legend(series: seriesList, palette: _palette),
      ],
    );
  }

  /// Compact number formatter for Y-axis labels.
  static String _formatAxisValue(double value) {
    if (value >= 1e9) return '${(value / 1e9).toStringAsFixed(1)}G';
    if (value >= 1e6) return '${(value / 1e6).toStringAsFixed(1)}M';
    if (value >= 1e3) return '${(value / 1e3).toStringAsFixed(1)}K';
    return value.toStringAsFixed(value == value.roundToDouble() ? 0 : 2);
  }
}

// ── Legend ────────────────────────────────────────────────────────────────────

class _Legend extends StatelessWidget {
  final List<SystemHealthSeries> series;
  final List<Color> palette;

  const _Legend({required this.series, required this.palette});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Wrap(
      spacing: AppConstants.standardPadding,
      runSpacing: AppConstants.compactPadding / 2,
      children: [
        for (var i = 0; i < series.length; i++)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12,
                height: 3,
                color: palette[i % palette.length],
              ),
              const SizedBox(width: 4),
              Text(
                series[i].key,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
