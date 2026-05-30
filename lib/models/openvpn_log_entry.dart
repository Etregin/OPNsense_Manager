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

/// Model representing a single OpenVPN log entry.
class OpenvpnLogEntry {
  final String timestamp;
  final String? parser;
  final int? facility;
  final String severity;
  final String? processName;
  final String? pid;
  final int? rnum;
  final String line;

  const OpenvpnLogEntry({
    required this.timestamp,
    this.parser,
    this.facility,
    required this.severity,
    this.processName,
    this.pid,
    this.rnum,
    required this.line,
  });

  factory OpenvpnLogEntry.fromJson(Map<String, dynamic> json) {
    return OpenvpnLogEntry(
      timestamp: json['timestamp'] as String? ?? '',
      parser: json['parser'] as String?,
      facility: json['facility'] as int?,
      severity: json['severity'] as String? ?? 'Info',
      processName: json['process_name'] as String?,
      pid: json['pid'] as String?,
      rnum: json['rnum'] as int?,
      line: json['line'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp,
      'parser': parser,
      'facility': facility,
      'severity': severity,
      'process_name': processName,
      'pid': pid,
      'rnum': rnum,
      'line': line,
    };
  }

  DateTime? get parsedTimestamp {
    if (timestamp.isEmpty) {
      return null;
    }

    return DateTime.tryParse(timestamp);
  }

  String get trimmedLine => line.trim();
}

// Made with Bob