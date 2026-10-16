import 'package:flutter_test/flutter_test.dart';
import 'package:opnsense_manager/services/changelog_service.dart';

void main() {
  const sample = '''
# Changelog

Intro text that is not part of any version.

## [new_version]

### Added

- Added thing one.

### Fixed

- Fixed thing two.
- Fixed thing three.

## [1.8.0] -

### Changed

- Changed thing four.

## [1.7.0] - 2026-01-01

### Known Issues

- Something known.
''';

  group('ChangelogService.parse', () {
    final entries = ChangelogService.parse(sample);

    test('parses versions in file order, tolerating trailing dash and date', () {
      expect(entries.map((e) => e.version), ['new_version', '1.8.0', '1.7.0']);
    });

    test('flags the placeholder block as unreleased', () {
      expect(entries[0].isUnreleased, isTrue);
      expect(entries[1].isUnreleased, isFalse);
    });

    test('groups bullets by section in order', () {
      expect(entries[0].sections.keys, ['Added', 'Fixed']);
      expect(entries[0].sections['Fixed'], ['Fixed thing two.', 'Fixed thing three.']);
      expect(entries[2].sections['Known Issues'], ['Something known.']);
    });

    test('ignores text before the first version heading', () {
      expect(entries.expand((e) => e.sections.values).expand((b) => b),
          isNot(contains('Intro text that is not part of any version.')));
    });
  });
}
