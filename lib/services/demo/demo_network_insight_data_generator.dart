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
import '../../models/netflow_status.dart';
import '../../models/network_insight_direction_total.dart';
import '../../models/network_insight_timeserie.dart';
import '../../models/network_insight_top_addr.dart';
import '../../models/network_insight_top_port.dart';

/// Generator for Network Insight demo data.
///
/// Produces plausible static/pseudo-random data for all Network Insight
/// endpoints so the feature is fully exercisable in demo mode.
class DemoNetworkInsightDataGenerator {
  final Random _random = Random(42); // fixed seed → stable UI in demo mode

  // ── NetFlow status ──────────────────────────────────────────────────────────

  /// Always returns enabled so the full Insight UI is reachable in demo mode.
  NetflowStatus generateNetflowStatus() =>
      const NetflowStatus(netflow: 1, local: 1);

  // ── Interfaces ──────────────────────────────────────────────────────────────

  Map<String, String> generateInterfaces() => const {
        'pppoe1': 'wan',
        'vtnet1': 'lan',
        'lo0': 'Loopback',
      };

  // ── Time-series ─────────────────────────────────────────────────────────────

  /// Generates plausible bandwidth time-series for four interface+direction
  /// combinations over the requested time range at [resolution] seconds.
  List<NetworkInsightSeries> generateTimeseries({
    required int startTs,
    required int endTs,
    required int resolution,
  }) {
    final seriesDefs = [
      const _SeriesDef('pppoe1,in',  'wan',      'in',  800000,  200000),
      const _SeriesDef('pppoe1,out', 'wan',      'out', 600000,  150000),
      const _SeriesDef('vtnet1,in',  'lan',      'in',  750000,  180000),
      const _SeriesDef('vtnet1,out', 'lan',      'out', 580000,  140000),
      const _SeriesDef('lo0,in',     'Loopback', 'in',   10000,    5000),
      const _SeriesDef('lo0,out',    'Loopback', 'out',  10000,    5000),
    ];

    return seriesDefs.map((def) {
      final values = <List<double>>[];
      var ts = startTs;
      while (ts <= endTs) {
        final bps = (def.baseBps + _random.nextInt(def.varianceBps)).toDouble();
        values.add([ts * 1000.0, bps]);
        ts += resolution;
      }
      return NetworkInsightSeries(
        key: def.key,
        direction: def.direction,
        interface: def.interfaceLabel,
        values: values,
      );
    }).toList();
  }

  // ── Top ports ───────────────────────────────────────────────────────────────

  List<NetworkInsightTopPort> generateTopPorts() => [
        const NetworkInsightTopPort(
          dstPort: '443', protocol: '17', total: 783360806.0,
          lastSeen: 1788705182, lastSeenStr: '2026-09-06 17:33:02',
          label: 'https (udp)',
        ),
        const NetworkInsightTopPort(
          dstPort: '443', protocol: '6', total: 276228887.0,
          lastSeen: 1788705182, lastSeenStr: '2026-09-06 17:33:02',
          label: 'https (tcp)',
        ),
        const NetworkInsightTopPort(
          dstPort: '80', protocol: '6', total: 1598126.0,
          lastSeen: 1788705119, lastSeenStr: '2026-09-06 17:31:59',
          label: 'http (tcp)',
        ),
        const NetworkInsightTopPort(
          dstPort: '53', protocol: '17', total: 957334.0,
          lastSeen: 1788705183, lastSeenStr: '2026-09-06 17:33:03',
          label: 'domain (udp)',
        ),
        const NetworkInsightTopPort(
          dstPort: '6881', protocol: '6', total: 3140716.0,
          lastSeen: 1788705179, lastSeenStr: '2026-09-06 17:32:59',
          label: '6881 (tcp)',
        ),
        const NetworkInsightTopPort(
          dstPort: '6881', protocol: '17', total: 4519375.0,
          lastSeen: 1788705183, lastSeenStr: '2026-09-06 17:33:03',
          label: '6881 (udp)',
        ),
        const NetworkInsightTopPort(
          dstPort: '4500', protocol: '17', total: 1244678.0,
          lastSeen: 1788705161, lastSeenStr: '2026-09-06 17:32:41',
          label: 'ipsec-nat-t (udp)',
        ),
        const NetworkInsightTopPort(
          dstPort: '1900', protocol: '17', total: 846358.0,
          lastSeen: 1788705176, lastSeenStr: '2026-09-06 17:32:56',
          label: 'ssdp (udp)',
        ),
        const NetworkInsightTopPort(
          dstPort: '5222', protocol: '6', total: 507569.0,
          lastSeen: 1788704350, lastSeenStr: '2026-09-06 17:19:10',
          label: 'xmpp-client (tcp)',
        ),
        const NetworkInsightTopPort(
          dstPort: '0', protocol: '1', total: 1646062.0,
          lastSeen: 1788705181, lastSeenStr: '2026-09-06 17:33:01',
          label: '0 (icmp)',
        ),
        // "Other" aggregate row
        const NetworkInsightTopPort(
          dstPort: '', protocol: '', total: 43335307.0,
          lastSeen: '', lastSeenStr: '', label: '',
        ),
      ];

  // ── Top addresses ───────────────────────────────────────────────────────────

  List<NetworkInsightTopAddr> generateTopAddresses() => [
        const NetworkInsightTopAddr(
          srcAddr: '192.168.1.100', total: 646326804.0, lastSeen: 1788705428),
        const NetworkInsightTopAddr(
          srcAddr: '192.168.1.111', total: 416412007.0, lastSeen: 1788705423),
        const NetworkInsightTopAddr(
          srcAddr: '192.168.1.160', total: 411859651.0, lastSeen: 1788705426),
        const NetworkInsightTopAddr(
          srcAddr: '192.168.1.118', total: 291219648.0, lastSeen: 1788705428),
        const NetworkInsightTopAddr(
          srcAddr: '192.168.1.110', total: 8945607.0,   lastSeen: 1788705427),
        const NetworkInsightTopAddr(
          srcAddr: '192.168.1.228', total: 4223650.0,   lastSeen: 1788705168),
        const NetworkInsightTopAddr(
          srcAddr: '192.168.1.200', total: 1406782.0,   lastSeen: 1788705426),
        const NetworkInsightTopAddr(
          srcAddr: '192.168.1.106', total: 554158.0,    lastSeen: 1788705415),
        // "Other" aggregate row
        const NetworkInsightTopAddr(srcAddr: '', total: 81745.0, lastSeen: ''),
      ];

  // ── Direction totals ────────────────────────────────────────────────────────

  List<NetworkInsightDirectionTotal> generateDirectionOctetTotals() => const [
        NetworkInsightDirectionTotal(
            direction: 'in', total: 931835146.0, lastSeen: 1788705186),
        NetworkInsightDirectionTotal(
            direction: 'out', total: 775527345.0, lastSeen: 1788705184),
      ];

  List<NetworkInsightDirectionTotal> generateDirectionPacketTotals() => const [
        NetworkInsightDirectionTotal(
            direction: 'in', total: 1373688.0, lastSeen: 1788705186),
        NetworkInsightDirectionTotal(
            direction: 'out', total: 1370555.0, lastSeen: 1788705184),
      ];

  // ── CSV Export ─────────────────────────────────────────────────────────────

  /// Generates sample CSV export data for the given [collection].
  String generateExportCsv({
    required String collection,
    required int fromTs,
    required int toTs,
    required int resolution,
  }) {
    switch (collection) {
      case 'FlowSourceAddrTotals':
        return 'src_addr,octets,resolution,start_time,end_time\n'
            '192.168.1.160,411859651,$resolution,$fromTs,$toTs\n'
            '192.168.1.118,291219648,$resolution,$fromTs,$toTs\n'
            '192.168.1.110,8945607,$resolution,$fromTs,$toTs\n'
            '192.168.1.228,4223650,$resolution,$fromTs,$toTs\n'
            '192.168.1.200,1406782,$resolution,$fromTs,$toTs\n';
      case 'FlowDstPortTotals':
        return 'dst_port,protocol,octets,resolution,start_time,end_time\n'
            '443,tcp,1258410294,$resolution,$fromTs,$toTs\n'
            '80,tcp,312450192,$resolution,$fromTs,$toTs\n'
            '53,udp,45892100,$resolution,$fromTs,$toTs\n'
            '853,tcp,12480192,$resolution,$fromTs,$toTs\n'
            '123,udp,1249501,$resolution,$fromTs,$toTs\n';
      case 'FlowInterfaceTotals':
        return 'interface,direction,octets,packets,resolution,start_time,end_time\n'
            'pppoe1,in,931835146,1373688,$resolution,$fromTs,$toTs\n'
            'pppoe1,out,775527345,1370555,$resolution,$fromTs,$toTs\n'
            'vtnet1,in,750431200,1120450,$resolution,$fromTs,$toTs\n'
            'vtnet1,out,580129400,980400,$resolution,$fromTs,$toTs\n';
      case 'FlowSourceAddrDetails':
      default:
        return 'service_port,protocol,if,src_addr,dst_addr,octets,resolution,start_time,end_time\n'
            '443,tcp,pppoe1,192.168.1.160,104.244.42.1,385412900,$resolution,$fromTs,$toTs\n'
            '443,tcp,pppoe1,192.168.1.118,172.217.16.206,254109400,$resolution,$fromTs,$toTs\n'
            '80,tcp,pppoe1,192.168.1.110,93.184.216.34,8450120,$resolution,$fromTs,$toTs\n'
            '53,udp,pppoe1,192.168.1.228,1.1.1.1,4120500,$resolution,$fromTs,$toTs\n'
            '853,tcp,pppoe1,192.168.1.200,1.0.0.1,1390400,$resolution,$fromTs,$toTs\n';
    }
  }
}

// ── Internal helper ──────────────────────────────────────────────────────────

class _SeriesDef {
  final String key;
  final String interfaceLabel;
  final String direction;
  final int baseBps;
  final int varianceBps;

  const _SeriesDef(
    this.key,
    this.interfaceLabel,
    this.direction,
    this.baseBps,
    this.varianceBps,
  );
}
