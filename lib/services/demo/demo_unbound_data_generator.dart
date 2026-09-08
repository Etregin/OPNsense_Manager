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

import '../../models/unbound_overview_status.dart';
import '../../models/unbound_query_item.dart';
import '../../models/unbound_rolling.dart';
import '../../models/unbound_settings.dart';
import '../../models/unbound_totals.dart';

/// Generates mock data for Unbound DNS reporting in demo mode.
class DemoUnboundDataGenerator {
  bool _isStatsEnabled = true;

  UnboundOverviewStatus generateOverviewStatus() {
    return UnboundOverviewStatus(isEnabled: _isStatsEnabled);
  }

  void setStatsEnabled(bool enabled) {
    _isStatsEnabled = enabled;
  }

  UnboundSettings generateSettings() {
    return UnboundSettings(
      general: UnboundGeneralSettings(
        enabled: true,
        stats: _isStatsEnabled,
        port: '53',
      ),
    );
  }

  UnboundTotals generateTotals({int limit = 10}) {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final topDomains = [
      const UnboundDomainStat(domain: 'api.themoviedb.org.', total: 84, pcnt: 11.11),
      const UnboundDomainStat(domain: 'api.github.com.', total: 54, pcnt: 7.14),
      const UnboundDomainStat(domain: 'ghcr.io.', total: 46, pcnt: 6.08),
      const UnboundDomainStat(domain: 'auth.docker.io.', total: 30, pcnt: 3.97),
      const UnboundDomainStat(domain: 'registry-1.docker.io.', total: 28, pcnt: 3.70),
      const UnboundDomainStat(domain: 'region1.v2.argotunnel.com.', total: 26, pcnt: 3.44),
      const UnboundDomainStat(domain: 'raw.githubusercontent.com.', total: 21, pcnt: 2.78),
      const UnboundDomainStat(domain: '1.2.16.172.in-addr.arpa.', total: 20, pcnt: 2.65),
      const UnboundDomainStat(domain: 'nyaa.si.', total: 14, pcnt: 1.85),
      const UnboundDomainStat(domain: 'apibay.org.', total: 14, pcnt: 1.85),
      const UnboundDomainStat(domain: 'nyaa.tracker.wf.', total: 13, pcnt: 1.72),
      const UnboundDomainStat(domain: 'www.limetorrents.fun.', total: 8, pcnt: 1.06),
      const UnboundDomainStat(domain: '0.debian.pool.ntp.org.', total: 6, pcnt: 0.79),
      const UnboundDomainStat(domain: 'tracker.opentrackr.org.', total: 6, pcnt: 0.79),
      const UnboundDomainStat(domain: 'services.sonarr.tv.', total: 4, pcnt: 0.53),
    ];

    final topBlocked = [
      const UnboundDomainStat(domain: 'telemetry.microsoft.com.', total: 142, pcnt: 18.5),
      const UnboundDomainStat(domain: 'adservice.google.com.', total: 98, pcnt: 12.8),
      const UnboundDomainStat(domain: 'graph.facebook.com.', total: 45, pcnt: 5.9),
      const UnboundDomainStat(domain: 'metrics.icloud.com.', total: 32, pcnt: 4.2),
      const UnboundDomainStat(domain: 'events.data.msn.com.', total: 22, pcnt: 2.9),
    ];

    return UnboundTotals(
      total: 761,
      blocklistSize: 148520,
      passed: 756,
      resolved: const UnboundTotalCategory(total: 220, pcnt: 28.91),
      blocked: const UnboundTotalCategory(total: 339, pcnt: 44.55),
      local: const UnboundTotalCategory(total: 277, pcnt: 36.40),
      startTime: now - 86400,
      top: topDomains.take(limit).toList(),
      topBlocked: topBlocked.take(limit).toList(),
    );
  }

  List<UnboundRollingPoint> generateRolling(int hours) {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final points = <UnboundRollingPoint>[];
    final intervalSeconds = (hours * 3600) ~/ 24;

    for (int i = 24; i >= 0; i--) {
      final ts = (now - i * intervalSeconds).toDouble();
      final base = (i % 5 == 0) ? 120 : ((i % 2 == 0) ? 60 : 35);
      points.add(UnboundRollingPoint(
        timestamp: ts,
        total: base + 15,
        passed: base + 12,
        blocked: 3,
        dropped: 0,
        resolved: (base * 0.4).round(),
        local: (base * 0.3).round(),
        cached: (base * 0.3).round(),
      ));
    }
    return points;
  }

  List<UnboundRollingClientPoint> generateClientActivity(int hours) {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final points = <UnboundRollingClientPoint>[];
    final intervalSeconds = (hours * 3600) ~/ 24;

    for (int i = 24; i >= 0; i--) {
      final ts = (now - i * intervalSeconds).toDouble();
      points.add(UnboundRollingClientPoint(
        timestamp: ts,
        clients: [
          const UnboundClientHit(ip: '192.168.1.100', count: 57, hostname: 'workstation.lan'),
          const UnboundClientHit(ip: '192.168.1.200', count: 8, hostname: 'nas.lan'),
          const UnboundClientHit(ip: '127.0.0.1', count: 3, hostname: 'localhost'),
        ],
      ));
    }
    return points;
  }

  UnboundQuerySearchResponse generateQueries({
    int current = 1,
    int rowCount = 50,
    String? searchPhrase,
    String? client,
    int? timeStart,
    int? timeEnd,
  }) {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final allSampleQueries = [
      UnboundQueryItem(
        time: now - 5,
        client: 'localhost',
        family: 'ip4',
        type: 'A',
        domain: 'pkg.opnsense.org.',
        action: 'Pass',
        source: 'Cache',
        blocklist: '',
        rcode: 'NOERROR',
        resolveTimeMs: 0,
        dnssecStatus: 'Unchecked',
        ttl: 311,
        policy: '',
        status: 1,
      ),
      UnboundQueryItem(
        time: now - 15,
        client: '192.168.1.100',
        family: 'ip4',
        type: 'AAAA',
        domain: 'api.github.com.',
        action: 'Pass',
        source: 'Cache',
        blocklist: '',
        rcode: 'NOERROR',
        resolveTimeMs: 0,
        dnssecStatus: 'Unchecked',
        ttl: 2696,
        policy: '',
        status: 1,
      ),
      UnboundQueryItem(
        time: now - 20,
        client: '192.168.1.100',
        family: 'ip4',
        type: 'A',
        domain: 'api.github.com.',
        action: 'Pass',
        source: 'Recursion',
        blocklist: '',
        rcode: 'NOERROR',
        resolveTimeMs: 114,
        dnssecStatus: 'Unchecked',
        ttl: 60,
        policy: '',
        status: 0,
      ),
      UnboundQueryItem(
        time: now - 35,
        client: '192.168.1.100',
        family: 'ip4',
        type: 'A',
        domain: 'region1.v2.argotunnel.com.',
        action: 'Pass',
        source: 'Cache',
        blocklist: '',
        rcode: 'NOERROR',
        resolveTimeMs: 0,
        dnssecStatus: 'Unchecked',
        ttl: 27597,
        policy: '',
        status: 1,
      ),
      UnboundQueryItem(
        time: now - 60,
        client: '192.168.1.100',
        family: 'ip4',
        type: 'AAAA',
        domain: 'telemetry.microsoft.com.',
        action: 'Block',
        source: 'Blocklist',
        blocklist: 'easylist',
        rcode: 'REFUSED',
        resolveTimeMs: 0,
        dnssecStatus: 'Unchecked',
        ttl: 0,
        policy: '',
        status: 2,
      ),
      UnboundQueryItem(
        time: now - 85,
        client: '192.168.1.100',
        family: 'ip4',
        type: 'A',
        domain: 'opentracker.i2p.rocks.',
        action: 'Pass',
        source: 'Cache',
        blocklist: '',
        rcode: 'NOERROR',
        resolveTimeMs: 0,
        dnssecStatus: 'Unchecked',
        ttl: 230,
        policy: '',
        status: 1,
      ),
      UnboundQueryItem(
        time: now - 110,
        client: '192.168.1.100',
        family: 'ip4',
        type: 'AAAA',
        domain: 'api.themoviedb.org.',
        action: 'Pass',
        source: 'Recursion',
        blocklist: '',
        rcode: 'NOERROR',
        resolveTimeMs: 202,
        dnssecStatus: 'Unchecked',
        ttl: 60,
        policy: '',
        status: 0,
      ),
      UnboundQueryItem(
        time: now - 140,
        client: '192.168.1.100',
        family: 'ip4',
        type: 'PTR',
        domain: '1.2.16.172.in-addr.arpa.',
        action: 'Pass',
        source: 'Local-data',
        blocklist: '',
        rcode: 'NXDOMAIN',
        resolveTimeMs: 0,
        dnssecStatus: 'Unchecked',
        ttl: 0,
        policy: '',
        status: 1,
      ),
      UnboundQueryItem(
        time: now - 160,
        client: '47.245.117.221',
        family: 'ip4',
        type: 'A',
        domain: 'usage.truenas.com.',
        action: 'Pass',
        source: 'Recursion',
        blocklist: '',
        rcode: 'NOERROR',
        resolveTimeMs: 135,
        dnssecStatus: 'Unchecked',
        ttl: 3600,
        policy: '',
        status: 0,
      ),
      UnboundQueryItem(
        time: now - 200,
        client: '192.168.1.100',
        family: 'ip4',
        type: 'A',
        domain: 'adservice.google.com.',
        action: 'Block',
        source: 'Blocklist',
        blocklist: 'adguard',
        rcode: 'NXDOMAIN',
        resolveTimeMs: 0,
        dnssecStatus: 'Unchecked',
        ttl: 0,
        policy: '',
        status: 2,
      ),
    ];

    var filtered = allSampleQueries;
    if (client != null && client.isNotEmpty) {
      filtered = filtered.where((item) => item.client == client).toList();
    }
    if (timeStart != null) {
      filtered = filtered.where((item) => (item.time ?? 0) >= timeStart).toList();
    }
    if (timeEnd != null) {
      filtered = filtered.where((item) => (item.time ?? 0) <= timeEnd).toList();
    }
    if (searchPhrase != null && searchPhrase.isNotEmpty) {
      final q = searchPhrase.toLowerCase();
      filtered = filtered.where((item) {
        return (item.domain?.toLowerCase().contains(q) ?? false) ||
            (item.client?.toLowerCase().contains(q) ?? false) ||
            (item.type?.toLowerCase().contains(q) ?? false) ||
            (item.action?.toLowerCase().contains(q) ?? false);
      }).toList();
    }

    final total = filtered.length;
    final startIndex = (current - 1) * rowCount;
    final rows = (startIndex < filtered.length)
        ? filtered.skip(startIndex).take(rowCount).toList()
        : <UnboundQueryItem>[];

    return UnboundQuerySearchResponse(
      total: total,
      rowCount: rowCount,
      current: current,
      rows: rows,
    );
  }
}
