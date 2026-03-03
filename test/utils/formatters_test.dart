import 'package:flutter_test/flutter_test.dart';
import 'package:opnsense_manager/utils/formatters.dart';

void main() {
  group('Formatters', () {
    group('formatTimestampForFilename', () {
      test('should format timestamp without milliseconds', () {
        final dateTime = DateTime(2026, 3, 3, 16, 33, 49, 123, 456);
        final result = Formatters.formatTimestampForFilename(dateTime);
        
        // Should not contain milliseconds or microseconds
        expect(result, isNot(contains('.')));
        // Should have colons replaced with hyphens
        expect(result, contains('-'));
        // Should match expected format: YYYY-MM-DDTHH-MM-SS
        expect(result, matches(RegExp(r'^\d{4}-\d{2}-\d{2}T\d{2}-\d{2}-\d{2}$')));
      });
      
      test('should produce filename-safe string', () {
        final dateTime = DateTime.now();
        final result = Formatters.formatTimestampForFilename(dateTime);
        
        // Should not contain characters that are problematic in filenames
        expect(result, isNot(contains(':')));
        expect(result, isNot(contains('.')));
      });
      
      test('should produce consistent format', () {
        final dateTime = DateTime(2026, 1, 15, 9, 5, 3);
        final result = Formatters.formatTimestampForFilename(dateTime);
        
        expect(result, equals('2026-01-15T09-05-03'));
      });
    });
  });
}
