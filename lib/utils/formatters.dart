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

/// Utility class for formatting data
class Formatters {
  /// Format bytes to human-readable format (B, KB, MB, GB, TB)
  static String formatBytes(int bytes, {int decimals = 2}) {
    if (bytes <= 0) return '0 B';
    
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB', 'PB'];
    var i = 0;
    double size = bytes.toDouble();
    
    while (size >= 1024 && i < suffixes.length - 1) {
      size /= 1024;
      i++;
    }
    
    return '${size.toStringAsFixed(decimals)} ${suffixes[i]}';
  }
  
  /// Format bytes per second to human-readable format
  static String formatBytesPerSecond(int bytesPerSecond, {int decimals = 2}) {
    return '${formatBytes(bytesPerSecond, decimals: decimals)}/s';
  }
  
  /// Format uptime in seconds to human-readable format
  static String formatUptime(int seconds) {
    if (seconds <= 0) return '0 seconds';
    
    final days = seconds ~/ 86400;
    final hours = (seconds % 86400) ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;
    
    final parts = <String>[];
    
    if (days > 0) {
      parts.add('$days day${days != 1 ? 's' : ''}');
    }
    if (hours > 0) {
      parts.add('$hours hour${hours != 1 ? 's' : ''}');
    }
    if (minutes > 0) {
      parts.add('$minutes minute${minutes != 1 ? 's' : ''}');
    }
    if (secs > 0 && parts.isEmpty) {
      parts.add('$secs second${secs != 1 ? 's' : ''}');
    }
    
    return parts.join(', ');
  }
  
  /// Format percentage
  static String formatPercentage(double percentage, {int decimals = 1}) {
    return '${percentage.toStringAsFixed(decimals)}%';
  }
  
  /// Format memory in bytes to GB
  static String formatMemoryGB(int bytes, {int decimals = 2}) {
    final gb = bytes / (1024 * 1024 * 1024);
    return '${gb.toStringAsFixed(decimals)} GB';
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
  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    
    if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
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
}

