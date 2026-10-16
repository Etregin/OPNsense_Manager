import 'package:flutter_test/flutter_test.dart';
import 'package:opnsense_manager/models/openvpn_route.dart';
import 'package:opnsense_manager/models/openvpn_session.dart';

void main() {
  group('OpenvpnSession', () {
    test('parses a connected client row', () {
      final session = OpenvpnSession.fromJson({
        'socket': '/var/etc/openvpn/instance-45cf863c.sock',
        'status': 'ok',
        'type': 'server',
        'id': '45cf863c-5cdb-42d0-ac56-50f1dc5fccd8_udp4:156.182.253.104:37298',
        'description': 'vpn-server',
        'common_name': 'phone1',
        'real_address': 'udp4:156.182.253.104:37298',
        'virtual_address': '10.8.0.2',
        'virtual_ipv6_address': '',
        'bytes_received': '1852538',
        'bytes_sent': '8371053',
        'connected_since': '2026-10-16 13:38:25',
        'username': 'phone1',
        'client_id': '0',
        'peer_id': '0',
        'data_channel_cipher': 'AES-256-GCM',
        'is_client': true,
      });

      expect(session.hasClientInfo, isTrue);
      expect(session.serverId, '45cf863c-5cdb-42d0-ac56-50f1dc5fccd8');
      expect(session.killSessionId, 'phone1');
      expect(session.bytesSent, 8371053);
      expect(session.bytesReceived, 1852538);
      expect(session.isClient, isTrue);
    });

    test('parses a daemon-only row', () {
      final session = OpenvpnSession.fromJson({
        'socket': '/var/etc/openvpn/instance-45cf863c.sock',
        'status': 'ok',
        'type': 'server',
        'id': '45cf863c-5cdb-42d0-ac56-50f1dc5fccd8',
        'description': 'vpn-server',
        'bytes_sent': null,
      });

      expect(session.hasClientInfo, isFalse);
      expect(session.serverId, '45cf863c-5cdb-42d0-ac56-50f1dc5fccd8');
      expect(session.bytesSent, isNull);
      expect(session.canStopOrRestart, isTrue);
    });
  });

  group('OpenvpnRoute', () {
    test('parses search_routes row', () {
      final route = OpenvpnRoute.fromJson({
        'virtual_address': '10.8.0.2',
        'common_name': 'phone1',
        'real_address': 'udp4:156.182.253.104:37298',
        'last_ref': '2026-10-16 13:38:43',
        'type': 'server',
        'id': '45cf863c-5cdb-42d0-ac56-50f1dc5fccd8',
        'description': 'vpn-server',
      });

      expect(route.virtualAddress, '10.8.0.2');
      expect(route.commonName, 'phone1');
      expect(route.lastRef, '2026-10-16 13:38:43');
      expect(route.toJson()['virtual_address'], '10.8.0.2');
    });
  });
}
