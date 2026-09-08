import 'package:flutter_test/flutter_test.dart';
import 'package:opnsense_manager/constants/api_endpoints.dart';
import 'package:opnsense_manager/services/demo/demo_network_insight_data_generator.dart';

void main() {
  group('Network Insight CSV Export', () {
    test('ApiEndpoints.networkInsightExport creates correct path format', () {
      final endpoint = ApiEndpoints.networkInsightExport(
        collection: 'FlowSourceAddrDetails',
        fromTs: 1788739200,
        toTs: 1788825599,
        resolution: 86400,
      );

      expect(
        endpoint,
        '/diagnostics/networkinsight/export/FlowSourceAddrDetails/1788739200/1788825599/86400',
      );
    });

    test('DemoNetworkInsightDataGenerator generates CSV for all collections', () {
      final generator = DemoNetworkInsightDataGenerator();
      const fromTs = 1788739200;
      const toTs = 1788825599;
      const resolution = 86400;

      final collections = [
        'FlowSourceAddrDetails',
        'FlowSourceAddrTotals',
        'FlowDstPortTotals',
        'FlowInterfaceTotals',
      ];

      for (final collection in collections) {
        final csv = generator.generateExportCsv(
          collection: collection,
          fromTs: fromTs,
          toTs: toTs,
          resolution: resolution,
        );

        expect(csv, isNotEmpty);
        expect(csv.contains('$resolution'), isTrue);
        expect(csv.contains('$fromTs'), isTrue);
        expect(csv.contains('$toTs'), isTrue);
      }
    });

    test('DemoNetworkInsightDataGenerator generates expected columns for FlowSourceAddrDetails', () {
      final generator = DemoNetworkInsightDataGenerator();
      final csv = generator.generateExportCsv(
        collection: 'FlowSourceAddrDetails',
        fromTs: 1000,
        toTs: 2000,
        resolution: 86400,
      );

      expect(
        csv.startsWith('service_port,protocol,if,src_addr,dst_addr,octets,resolution,start_time,end_time'),
        isTrue,
      );
    });
  });
}
