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
import 'package:fl_chart/fl_chart.dart';
import '../../l10n/app_localizations.dart';
import '../../models/network_insight_timeserie.dart';
import '../../utils/app_colors.dart';
import '../../utils/constants.dart';
import '../../utils/formatters.dart';

/// A pair of line charts (In / Out) for `FlowInterfaceTotals` bps data.
///
/// Each distinct interface maps to a unique line colour. The Loopback
/// interface is hidden unless [showLoopback] is `true`.
class InterfaceTotalsChart extends StatefulWidget {
  /// All time-series returned by the timeserie endpoint.
  final List<NetworkInsightSeries> series;

  /// When `true`, include Loopback (`lo0`) series in the charts.
  final bool showLoopback;

  final bool isFullScreen;

  const InterfaceTotalsChart({
    super.key,
    required this.series,
    this.showLoopback = false,
    this.isFullScreen = false,
  });

  @override
  State<InterfaceTotalsChart> createState() => _InterfaceTotalsChartState();
}

class _InterfaceTotalsChartState extends State<InterfaceTotalsChart> {
  double? _visibleMinX;
  double? _visibleMaxX;
  double _baseScaleMinX = 0;
  double _baseScaleMaxX = 0;

  // Fixed colour palette cycling through distinct hues per interface.
  static const List<Color> _palette = [
    Color(0xFF1E88E5), // blue
    Color(0xFF43A047), // green
    Color(0xFFE53935), // red
    Color(0xFFFF8F00), // amber
    AppColors.bandwidth, // purple
    Color(0xFF00ACC1), // cyan
    Color(0xFF6D4C41), // brown
    Color(0xFF757575), // grey
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final filtered = widget.showLoopback
        ? widget.series
        : widget.series.where((s) => !_isLoopback(s)).toList();

    final inSeries = filtered.where((s) => s.direction == 'in').toList();
    final outSeries = filtered.where((s) => s.direction == 'out').toList();

    // Collect distinct interface IDs in stable order for colour assignment.
    final ifaceOrder = <String>[];
    for (final s in filtered) {
      if (!ifaceOrder.contains(s.interfaceId)) {
        ifaceOrder.add(s.interfaceId);
      }
    }

    final globalMinX = filtered.isNotEmpty && filtered.first.values.isNotEmpty
        ? filtered.first.values.first[0]
        : 0.0;
    final globalMaxX = filtered.isNotEmpty && filtered.first.values.isNotEmpty
        ? filtered.first.values.last[0]
        : 0.0;
    final isZoomed = (_visibleMinX != null && _visibleMinX! > globalMinX) ||
        (_visibleMaxX != null && _visibleMaxX! < globalMaxX);

    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.isFullScreen)
          Padding(
            padding: const EdgeInsets.only(bottom: AppConstants.compactPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: _buildLegend(context, ifaceOrder, filtered)),
                IconButton(
                  icon: const Icon(Icons.zoom_in, size: 20),
                  tooltip: l10n.zoomIn,
                  onPressed: () {
                    final currentMin = _visibleMinX ?? globalMinX;
                    final currentMax = _visibleMaxX ?? globalMaxX;
                    final currentRange = currentMax - currentMin;
                    final newRange = (currentRange * 0.7).clamp(60.0, globalMaxX - globalMinX);
                    final center = (currentMin + currentMax) / 2;
                    var newMin = center - (newRange / 2);
                    var newMax = center + (newRange / 2);
                    if (newMin < globalMinX) {
                      newMin = globalMinX;
                      newMax = (newMin + newRange).clamp(globalMinX, globalMaxX);
                    }
                    if (newMax > globalMaxX) {
                      newMax = globalMaxX;
                      newMin = (newMax - newRange).clamp(globalMinX, globalMaxX);
                    }
                    setState(() {
                      _visibleMinX = newMin;
                      _visibleMaxX = newMax;
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.zoom_out, size: 20),
                  tooltip: l10n.zoomOut,
                  onPressed: !isZoomed
                      ? null
                      : () {
                          final currentMin = _visibleMinX ?? globalMinX;
                          final currentMax = _visibleMaxX ?? globalMaxX;
                          final currentRange = currentMax - currentMin;
                          final newRange = (currentRange / 0.7).clamp(60.0, globalMaxX - globalMinX);
                          final center = (currentMin + currentMax) / 2;
                          var newMin = center - (newRange / 2);
                          var newMax = center + (newRange / 2);
                          if (newMin <= globalMinX && newMax >= globalMaxX) {
                            setState(() {
                              _visibleMinX = null;
                              _visibleMaxX = null;
                            });
                            return;
                          }
                          if (newMin < globalMinX) {
                            newMin = globalMinX;
                            newMax = (newMin + newRange).clamp(globalMinX, globalMaxX);
                          }
                          if (newMax > globalMaxX) {
                            newMax = globalMaxX;
                            newMin = (newMax - newRange).clamp(globalMinX, globalMaxX);
                          }
                          setState(() {
                            _visibleMinX = newMin;
                            _visibleMaxX = newMax;
                          });
                        },
                ),
                if (isZoomed)
                  IconButton(
                    icon: const Icon(Icons.zoom_out_map, size: 20),
                    tooltip: l10n.resetZoom,
                    onPressed: () {
                      setState(() {
                        _visibleMinX = null;
                        _visibleMaxX = null;
                      });
                    },
                  ),
              ],
            ),
          ),
        _SectionLabel(label: '↓ ${l10n.timeRangeFrom}'),
        if (widget.isFullScreen)
          Expanded(child: _buildInteractiveChart(context, inSeries, ifaceOrder, globalMinX, globalMaxX))
        else
          _buildInteractiveChart(context, inSeries, ifaceOrder, globalMinX, globalMaxX),
        const SizedBox(height: AppConstants.standardPadding),
        _SectionLabel(label: '↑ ${l10n.timeRangeTo}'),
        if (widget.isFullScreen)
          Expanded(child: _buildInteractiveChart(context, outSeries, ifaceOrder, globalMinX, globalMaxX))
        else
          _buildInteractiveChart(context, outSeries, ifaceOrder, globalMinX, globalMaxX),
        if (!widget.isFullScreen) ...[
          const SizedBox(height: AppConstants.compactPadding),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: _buildLegend(context, ifaceOrder, filtered)),
              IconButton(
                icon: const Icon(Icons.zoom_in, size: 20),
                tooltip: l10n.zoomIn,
                onPressed: () {
                  final currentMin = _visibleMinX ?? globalMinX;
                  final currentMax = _visibleMaxX ?? globalMaxX;
                  final currentRange = currentMax - currentMin;
                  final newRange = (currentRange * 0.7).clamp(60.0, globalMaxX - globalMinX);
                  final center = (currentMin + currentMax) / 2;
                  var newMin = center - (newRange / 2);
                  var newMax = center + (newRange / 2);
                  if (newMin < globalMinX) {
                    newMin = globalMinX;
                    newMax = (newMin + newRange).clamp(globalMinX, globalMaxX);
                  }
                  if (newMax > globalMaxX) {
                    newMax = globalMaxX;
                    newMin = (newMax - newRange).clamp(globalMinX, globalMaxX);
                  }
                  setState(() {
                    _visibleMinX = newMin;
                    _visibleMaxX = newMax;
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.zoom_out, size: 20),
                tooltip: l10n.zoomOut,
                onPressed: !isZoomed
                    ? null
                    : () {
                        final currentMin = _visibleMinX ?? globalMinX;
                        final currentMax = _visibleMaxX ?? globalMaxX;
                        final currentRange = currentMax - currentMin;
                        final newRange = (currentRange / 0.7).clamp(60.0, globalMaxX - globalMinX);
                        final center = (currentMin + currentMax) / 2;
                        var newMin = center - (newRange / 2);
                        var newMax = center + (newRange / 2);
                        if (newMin <= globalMinX && newMax >= globalMaxX) {
                          setState(() {
                            _visibleMinX = null;
                            _visibleMaxX = null;
                          });
                          return;
                        }
                        if (newMin < globalMinX) {
                          newMin = globalMinX;
                          newMax = (newMin + newRange).clamp(globalMinX, globalMaxX);
                        }
                        if (newMax > globalMaxX) {
                          newMax = globalMaxX;
                          newMin = (newMax - newRange).clamp(globalMinX, globalMaxX);
                        }
                        setState(() {
                          _visibleMinX = newMin;
                          _visibleMaxX = newMax;
                        });
                      },
              ),
              if (isZoomed)
                IconButton(
                  icon: const Icon(Icons.zoom_out_map, size: 20),
                  tooltip: l10n.resetZoom,
                  onPressed: () {
                    setState(() {
                      _visibleMinX = null;
                      _visibleMaxX = null;
                    });
                  },
                ),
            ],
          ),
        ],
      ],
    );

    return content;
  }

  Widget _buildInteractiveChart(
    BuildContext context,
    List<NetworkInsightSeries> data,
    List<String> ifaceOrder,
    double globalMinX,
    double globalMaxX,
  ) {
    final minX = _visibleMinX ?? globalMinX;
    final maxX = _visibleMaxX ?? globalMaxX;
    final isZoomed = (_visibleMinX != null && _visibleMinX! > globalMinX) ||
        (_visibleMaxX != null && _visibleMaxX! < globalMaxX);

    return LayoutBuilder(
      builder: (context, constraints) {
        final chartWidth = constraints.maxWidth;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onScaleStart: (details) {
            _baseScaleMinX = _visibleMinX ?? globalMinX;
            _baseScaleMaxX = _visibleMaxX ?? globalMaxX;
          },
          onScaleUpdate: (details) {
            if (details.pointerCount >= 2 && details.scale != 1.0) {
              final baseRange = _baseScaleMaxX - _baseScaleMinX;
              final newRange = (baseRange / details.scale).clamp(
                60.0, // Minimum window of 1 minute
                globalMaxX - globalMinX,
              );
              final focalFraction = chartWidth > 0
                  ? (details.localFocalPoint.dx / chartWidth).clamp(0.0, 1.0)
                  : 0.5;
              final focalTimestamp = _baseScaleMinX + (focalFraction * baseRange);
              var newMin = focalTimestamp - (focalFraction * newRange);
              var newMax = newMin + newRange;

              if (newMin < globalMinX) {
                newMin = globalMinX;
                newMax = (newMin + newRange).clamp(globalMinX, globalMaxX);
              }
              if (newMax > globalMaxX) {
                newMax = globalMaxX;
                newMin = (newMax - newRange).clamp(globalMinX, globalMaxX);
              }
              setState(() {
                _visibleMinX = newMin;
                _visibleMaxX = newMax;
              });
            } else if (details.pointerCount == 1 && details.focalPointDelta.dx != 0 && isZoomed) {
              final range = maxX - minX;
              final deltaFraction = chartWidth > 0
                  ? -details.focalPointDelta.dx / chartWidth
                  : -details.focalPointDelta.dx / 300.0;
              final shift = deltaFraction * range;
              var newMin = (minX + shift).clamp(globalMinX, globalMaxX - range);
              var newMax = newMin + range;
              setState(() {
                _visibleMinX = newMin;
                _visibleMaxX = newMax;
              });
            }
          },
          child: _buildChart(context, data, ifaceOrder, minX, maxX),
        );
      },
    );
  }

  Widget _buildChart(
    BuildContext context,
    List<NetworkInsightSeries> data,
    List<String> ifaceOrder,
    double minX,
    double maxX,
  ) {
    if (data.isEmpty) {
      return const SizedBox(height: 160);
    }

    final lines = data.map((s) {
      final colorIndex = ifaceOrder.indexOf(s.interfaceId) % _palette.length;
      final spots = s.values
          .map((v) => FlSpot(v[0], v[1]))
          .toList();

      return LineChartBarData(
        spots: spots,
        color: _palette[colorIndex],
        barWidth: 1.5,
        isCurved: false,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(
          show: true,
          color: _palette[colorIndex].withValues(alpha: AppColors.opacityBare),
        ),
      );
    }).toList();

    // Find y-axis max for scaling.
    double maxY = 0;
    for (final s in data) {
      for (final v in s.values) {
        if (v[1] > maxY) maxY = v[1];
      }
    }
    // Add 10% headroom; floor at a small positive so the chart isn't flat.
    maxY = (maxY * 1.1).clamp(100.0, double.infinity);

    return SizedBox(
      height: widget.isFullScreen ? null : 160,
      child: LineChart(
        LineChartData(
          minX: minX,
          maxX: maxX,
          minY: 0,
          maxY: maxY,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: maxY / 4,
            getDrawingHorizontalLine: (_) => FlLine(
              color: Theme.of(context)
                  .colorScheme
                  .outline
                  .withValues(alpha: AppColors.opacityDivider),
              strokeWidth: 0.5,
            ),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 60,
                getTitlesWidget: (value, meta) => Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Text(
                    Formatters.formatBitsPerSecond(value),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontSize: 9,
                        ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: widget.isFullScreen,
                reservedSize: 22,
                getTitlesWidget: (val, meta) {
                  if (val == meta.max || val == meta.min) return const SizedBox.shrink();
                  final dt = DateTime.fromMillisecondsSinceEpoch((val * 1000).toInt());
                  return Text(
                    Formatters.formatTime(dt),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontSize: 9,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  );
                },
              ),
            ),
          ),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (spots) => spots
                  .map((s) => LineTooltipItem(
                        Formatters.formatBitsPerSecond(s.y),
                        TextStyle(
                          color: s.bar.color ?? AppColors.primary,
                          fontSize: 11,
                        ),
                      ))
                  .toList(),
            ),
          ),
          lineBarsData: lines,
        ),
      ),
    );
  }

  Widget _buildLegend(
    BuildContext context,
    List<String> ifaceOrder,
    List<NetworkInsightSeries> filtered,
  ) {
    // Build one legend entry per unique interface.
    final entries = <Widget>[];
    for (final ifaceId in ifaceOrder) {
      final colorIndex = ifaceOrder.indexOf(ifaceId) % _palette.length;
      final label = filtered
          .firstWhere((s) => s.interfaceId == ifaceId)
          .interface ?? ifaceId;
      entries.add(_LegendEntry(
        color: _palette[colorIndex],
        label: label,
      ));
    }
    return Wrap(
      spacing: AppConstants.standardPadding,
      runSpacing: AppConstants.compactPadding / 2,
      children: entries,
    );
  }

  static bool _isLoopback(NetworkInsightSeries s) =>
      s.interfaceId == 'lo0' ||
      (s.interface?.toLowerCase().contains('loopback') ?? false);
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
      ),
    );
  }
}

class _LegendEntry extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendEntry({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 3,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ],
    );
  }
}
