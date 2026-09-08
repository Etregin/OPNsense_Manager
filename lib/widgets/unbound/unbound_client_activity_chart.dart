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

import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../models/unbound_rolling.dart';
import '../../utils/app_colors.dart';
import '../../utils/constants.dart';
import '../../utils/formatters.dart';

class UnboundClientActivityChart extends StatefulWidget {
  final List<UnboundRollingClientPoint> points;
  final int selectedDurationHours;
  final bool isLogarithmic;
  final ValueChanged<int> onDurationChanged;
  final ValueChanged<bool> onLogarithmicChanged;
  final void Function(String client, int timeStart, int timeEnd)? onClientSpotTapped;
  final bool isFullScreen;
  final Listenable? notifier;

  const UnboundClientActivityChart({
    super.key,
    required this.points,
    required this.selectedDurationHours,
    required this.isLogarithmic,
    required this.onDurationChanged,
    required this.onLogarithmicChanged,
    this.onClientSpotTapped,
    this.isFullScreen = false,
    this.notifier,
  });

  @override
  State<UnboundClientActivityChart> createState() => _UnboundClientActivityChartState();
}

class _UnboundClientActivityChartState extends State<UnboundClientActivityChart> {
  double? _visibleMinX;
  double? _visibleMaxX;
  double _baseScaleMinX = 0;
  double _baseScaleMaxX = 0;
  Offset _lastFocalPoint = Offset.zero;
  int _activePointerCount = 0;

  static const List<Color> _clientColors = [
    AppColors.primary,
    AppColors.secondary,
    AppColors.warning,
    AppColors.bandwidth,
    AppColors.success,
    AppColors.info,
    Colors.teal,
    Colors.indigo,
    Colors.amber,
    Colors.pink,
  ];

  double _transformY(double value) {
    if (!widget.isLogarithmic) return value;
    if (value <= 0) return 0;
    return log(value + 1) / ln10;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    if (widget.points.isEmpty) {
      return Card(
        elevation: AppConstants.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.standardPadding),
          child: Center(child: Text(l10n.noDataAvailable)),
        ),
      );
    }

    final globalMinX = widget.points.first.timestamp;
    final globalMaxX = widget.points.last.timestamp;
    final minX = _visibleMinX ?? globalMinX;
    final maxX = _visibleMaxX ?? globalMaxX;
    final isZoomed = (_visibleMinX != null && _visibleMinX! > globalMinX) ||
        (_visibleMaxX != null && _visibleMaxX! < globalMaxX);

    final clientIpTotals = <String, int>{};
    for (final p in widget.points) {
      for (final c in p.clients) {
        clientIpTotals[c.ip] = (clientIpTotals[c.ip] ?? 0) + c.count;
      }
    }
    final sortedClients = clientIpTotals.keys.toList()
      ..sort((a, b) => (clientIpTotals[b] ?? 0).compareTo(clientIpTotals[a] ?? 0));
    final top10Ips = sortedClients.take(10).toList();

    double maxVal = 0;
    for (final p in widget.points) {
      for (final c in p.clients) {
        if (c.count > maxVal) maxVal = c.count.toDouble();
      }
    }
    if (maxVal == 0) maxVal = 10;
    final maxY = _transformY(maxVal) * 1.15;

    final lineBars = <LineChartBarData>[];
    for (int i = 0; i < top10Ips.length; i++) {
      final ip = top10Ips[i];
      final color = _clientColors[i % _clientColors.length];
      final spots = <FlSpot>[];

      for (final p in widget.points) {
        final hit = p.clients.firstWhere(
          (c) => c.ip == ip,
          orElse: () => const UnboundClientHit(ip: '', count: 0, hostname: ''),
        );
        spots.add(FlSpot(p.timestamp, _transformY(hit.count.toDouble())));
      }

      lineBars.add(
        LineChartBarData(
          spots: spots,
          color: color,
          show: true,
          barWidth: 0,
          isCurved: false,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
              radius: 3,
              color: color,
              strokeWidth: 0,
            ),
          ),
        ),
      );
    }

    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.topClientActivityOverTheLast,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DropdownButton<int>(
              value: widget.selectedDurationHours,
              underline: const SizedBox.shrink(),
              items: [
                DropdownMenuItem(value: 24, child: Text(l10n.hoursDuration(24))),
                DropdownMenuItem(value: 12, child: Text(l10n.hoursDuration(12))),
                DropdownMenuItem(value: 1, child: Text(l10n.oneHourDuration)),
              ],
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _visibleMinX = null;
                    _visibleMaxX = null;
                  });
                  widget.onDurationChanged(val);
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.zoom_in, size: 20),
              tooltip: l10n.zoomIn,
              onPressed: () {
                final currentMin = minX;
                final currentMax = maxX;
                final currentRange = currentMax - currentMin;
                final newRange = (currentRange * 0.7).clamp(300.0, globalMaxX - globalMinX);
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
                      final currentMin = minX;
                      final currentMax = maxX;
                      final currentRange = currentMax - currentMin;
                      final newRange = (currentRange / 0.7).clamp(300.0, globalMaxX - globalMinX);
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
            if (isZoomed) ...[
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
            if (!widget.isFullScreen) ...[
              const SizedBox(width: AppConstants.compactPadding),
              IconButton(
                icon: const Icon(Icons.fullscreen, size: 20),
                tooltip: l10n.fullScreen,
                onPressed: () {
                  bool localIsLogarithmic = widget.isLogarithmic;
                  int localDuration = widget.selectedDurationHours;
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (ctx) {
                        return ListenableBuilder(
                          listenable: widget.notifier ?? ValueNotifier(null),
                          builder: (context, _) {
                            return StatefulBuilder(
                              builder: (context, setDialogState) {
                                return Scaffold(
                                  appBar: AppBar(
                                    title: Text(l10n.topClientActivityOverTheLast),
                                  ),
                                  body: SafeArea(
                                    child: Padding(
                                      padding: const EdgeInsets.all(AppConstants.standardPadding),
                                      child: UnboundClientActivityChart(
                                        points: widget.points,
                                        selectedDurationHours: localDuration,
                                        isLogarithmic: localIsLogarithmic,
                                        onDurationChanged: (val) {
                                          widget.onDurationChanged(val);
                                          setDialogState(() {
                                            localDuration = val;
                                          });
                                        },
                                        onLogarithmicChanged: (val) {
                                          widget.onLogarithmicChanged(val);
                                          setDialogState(() {
                                            localIsLogarithmic = val;
                                          });
                                        },
                                        onClientSpotTapped: (client, start, end) {
                                          Navigator.of(ctx).pop();
                                          widget.onClientSpotTapped?.call(client, start, end);
                                        },
                                        isFullScreen: true,
                                        notifier: widget.notifier,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Wrap(
                spacing: AppConstants.compactPadding,
                runSpacing: 4,
                children: [
                  for (int i = 0; i < top10Ips.length; i++)
                    _LegendDot(
                      color: _clientColors[i % _clientColors.length],
                      label: top10Ips[i],
                    ),
                ],
              ),
            ),
            Row(
              children: [
                Text(l10n.logarithmic, style: theme.textTheme.bodySmall),
                Switch(
                  value: widget.isLogarithmic,
                  onChanged: widget.onLogarithmicChanged,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: AppConstants.standardPadding),
        Expanded(
          flex: widget.isFullScreen ? 1 : 0,
          child: SizedBox(
            height: widget.isFullScreen ? null : 200,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final chartWidth = constraints.maxWidth;
                return Listener(
                  onPointerDown: (event) {
                    _activePointerCount++;
                    _lastFocalPoint = event.localPosition;
                  },
                  onPointerUp: (event) {
                    _activePointerCount = (_activePointerCount - 1).clamp(0, 5);
                  },
                  onPointerCancel: (event) {
                    _activePointerCount = (_activePointerCount - 1).clamp(0, 5);
                  },
                  onPointerMove: (event) {
                    if (isZoomed && _activePointerCount == 1) {
                      final deltaDx = event.localPosition.dx - _lastFocalPoint.dx;
                      if (deltaDx != 0) {
                        final range = maxX - minX;
                        final deltaFraction = chartWidth > 0
                            ? -deltaDx / chartWidth
                            : -deltaDx / 300.0;
                        final shift = deltaFraction * range;
                        var newMin = (minX + shift).clamp(globalMinX, globalMaxX - range);
                        var newMax = newMin + range;
                        setState(() {
                          _visibleMinX = newMin;
                          _visibleMaxX = newMax;
                        });
                      }
                    }
                    _lastFocalPoint = event.localPosition;
                  },
                  child: GestureDetector(
                    onVerticalDragStart: isZoomed ? (_) {} : null,
                    onVerticalDragUpdate: isZoomed ? (_) {} : null,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onScaleStart: (details) {
                        _baseScaleMinX = _visibleMinX ?? globalMinX;
                        _baseScaleMaxX = _visibleMaxX ?? globalMaxX;
                        _lastFocalPoint = details.localFocalPoint;
                      },
                      onScaleUpdate: (details) {
                        if (details.pointerCount >= 2 && details.scale != 1.0) {
                          final baseRange = _baseScaleMaxX - _baseScaleMinX;
                          final newRange = (baseRange / details.scale).clamp(
                            300.0, // Minimum window of 5 minutes
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
                        }
                        _lastFocalPoint = details.localFocalPoint;
                      },
                      child: LineChart(
                LineChartData(
                  minX: minX,
                  maxX: maxX,
                  minY: 0,
                  maxY: maxY > 0 ? maxY : 10,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: theme.colorScheme.outlineVariant.withValues(
                        alpha: AppColors.opacityDivider,
                      ),
                      strokeWidth: 1,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (val, meta) {
                          if (val == meta.max || val == meta.min) return const SizedBox.shrink();
                          final display = widget.isLogarithmic ? pow(10, val).round() : val.round();
                          return Text(
                            Formatters.formatNumber(display),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 24,
                        getTitlesWidget: (val, meta) {
                          if (val == meta.max || val == meta.min) return const SizedBox.shrink();
                          final dt = DateTime.fromMillisecondsSinceEpoch((val * 1000).toInt());
                          return Text(
                            Formatters.formatTime(dt),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: lineBars,
                  lineTouchData: LineTouchData(
                    touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {
                      if (event is FlTapUpEvent && touchResponse?.lineBarSpots != null && touchResponse!.lineBarSpots!.isNotEmpty) {
                        final spot = touchResponse.lineBarSpots!.first;
                        final ip = spot.barIndex < top10Ips.length ? top10Ips[spot.barIndex] : '';
                        if (ip.isNotEmpty && widget.onClientSpotTapped != null) {
                          final intervalSeconds = widget.selectedDurationHours == 1 ? 60 : 600;
                          final timeEnd = spot.x.toInt();
                          final timeStart = timeEnd - intervalSeconds;
                          widget.onClientSpotTapped!(ip, timeStart, timeEnd);
                        }
                      }
                    },
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((touchedSpot) {
                          if (touchedSpot.y <= 0) return null;

                          final originalY = widget.isLogarithmic
                              ? (touchedSpot.y == 0 ? 0 : (pow(10, touchedSpot.y) - 1).round())
                              : touchedSpot.y.round();

                          final ip = touchedSpot.barIndex < top10Ips.length
                              ? top10Ips[touchedSpot.barIndex]
                              : '';

                          return LineTooltipItem(
                            '$ip: ${Formatters.formatNumber(originalY)}',
                            TextStyle(
                              color: touchedSpot.bar.color ?? theme.colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                  ),
                ),
              )));
            },
          ),
      ),
    ),
      ],
    );

    if (widget.isFullScreen) {
      return content;
    }

    return Card(
      elevation: AppConstants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.standardPadding),
        child: content,
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
