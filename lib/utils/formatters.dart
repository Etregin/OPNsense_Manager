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


import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

/// Utility class for formatting data
class Formatters {
  /// Format bytes to human-readable format (B, KB, MB, GB, TB)
  static String formatBytes(int bytes, BuildContext context, {int decimals = 2}) {
    final l10n = AppLocalizations.of(context)!;
    if (bytes <= 0) return '0 ${l10n.unitBytes}';
    
    final suffixes = [
      l10n.unitBytes,
      l10n.unitKilobytes,
      l10n.unitMegabytes,
      l10n.unitGigabytes,
      l10n.unitTerabytes,
      l10n.unitPetabytes,
    ];
    var i = 0;
    double size = bytes.toDouble();
    
    while (size >= 1024 && i < suffixes.length - 1) {
      size /= 1024;
      i++;
    }
    
    return '${size.toStringAsFixed(decimals)} ${suffixes[i]}';
  }
  
  /// Format bytes per second to human-readable format
  static String formatBytesPerSecond(int bytesPerSecond, BuildContext context, {int decimals = 2}) {
    final l10n = AppLocalizations.of(context)!;
    return '${formatBytes(bytesPerSecond, context, decimals: decimals)}${l10n.unitPerSecond}';
  }
  
  /// Format uptime in seconds to human-readable format
  static String formatUptime(int seconds, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (seconds <= 0) return l10n.zeroSeconds;
    
    final days = seconds ~/ 86400;
    final hours = (seconds % 86400) ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;
    
    final parts = <String>[];
    
    if (days > 0) {
      parts.add('$days ${days != 1 ? l10n.days : l10n.day}');
    }
    if (hours > 0) {
      parts.add('$hours ${hours != 1 ? l10n.hours : l10n.hour}');
    }
    if (minutes > 0) {
      parts.add('$minutes ${minutes != 1 ? l10n.minutes : l10n.minute}');
    }
    if (secs > 0 && parts.isEmpty) {
      parts.add('$secs ${secs != 1 ? l10n.seconds : l10n.second}');
    }
    
    return parts.join(', ');
  }
  
  /// Format percentage
  static String formatPercentage(double percentage, {int decimals = 1}) {
    return '${percentage.toStringAsFixed(decimals)}%';
  }
  
  /// Format memory in bytes to GB
  static String formatMemoryGB(int bytes, BuildContext context, {int decimals = 2}) {
    final l10n = AppLocalizations.of(context)!;
    final gb = bytes / (1024 * 1024 * 1024);
    return '${gb.toStringAsFixed(decimals)} ${l10n.unitGigabytes}';
  }
  
  /// Format date and time
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('MMM dd, yyyy HH:mm:ss').format(dateTime);
  }
  
  /// Format date only
  static String formatDate(DateTime dateTime) {
    return DateFormat('MMM dd, yyyy').format(dateTime);
  }
  
  /// Format time only
  static String formatTime(DateTime dateTime) {
    return DateFormat('HH:mm:ss').format(dateTime);
  }
  
  /// Format number with thousand separators
  static String formatNumber(int number) {
    return NumberFormat('#,###').format(number);
  }
  
  /// Format duration
  static String formatDuration(Duration duration, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    
    if (hours > 0) {
      return '$hours${l10n.hourAbbrev} $minutes${l10n.minuteAbbrev} $seconds${l10n.secondAbbrev}';
    } else if (minutes > 0) {
      return '$minutes${l10n.minuteAbbrev} $seconds${l10n.secondAbbrev}';
    } else {
      return '$seconds${l10n.secondAbbrev}';
    }
  }
  
  /// Truncate string with ellipsis
  static String truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }
  
  /// Format IP address with port
  static String formatHostPort(String host, int port) {
    return '$host:$port';
  }
  
  /// Format timestamp for use in filenames
  ///
  /// Converts a DateTime to a filename-safe format by:
  /// 1. Converting to local time (if UTC)
  /// 2. Converting to ISO 8601 string (e.g., "2026-03-03T16:33:49.123456")
  /// 3. Replacing colons with hyphens (for Windows compatibility)
  /// 4. Removing milliseconds/microseconds by splitting at the decimal point
  ///
  /// Example: "2026-03-03T16-33-49"
  static String formatTimestampForFilename(DateTime dateTime) {
    final localTime = dateTime.isUtc ? dateTime.toLocal() : dateTime;
    return localTime.toIso8601String().replaceAll(':', '-').split('.')[0];
  }
}

