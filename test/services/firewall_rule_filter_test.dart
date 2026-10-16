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

import 'package:flutter_test/flutter_test.dart';
import 'package:opnsense_manager/models/firewall_form_options.dart';
import 'package:opnsense_manager/models/firewall_rule.dart';
import 'package:opnsense_manager/services/firewall/firewall_rule_filter.dart';

FirewallRule _rule(
  String description,
  String sortOrder, {
  String interfaceName = '',
  bool automatic = false,
}) {
  return FirewallRule(
    uuid: '$description-$sortOrder',
    type: 'pass',
    interfaceName: interfaceName,
    protocol: 'any',
    source: 'any',
    destination: 'any',
    destinationPort: '',
    description: description,
    enabled: '1',
    sequence: 0,
    sortOrder: sortOrder,
    origin: automatic ? 'automatic' : '',
  );
}

List<String> _names(List<FirewallRule> rules) =>
    rules.map((r) => r.description).toList();

void main() {
  // Rules taken from a real search_rule payload, deliberately NOT in
  // sort_order so the tests prove the filter does the ordering.
  final userRules = <FirewallRule>[
    _rule('hello', '200000.0000211'),
    _rule('hana', '400000.0000811', interfaceName: 'lan'),
    _rule('noosh', '200000.0000001'),
    _rule('Test Rule', '200000.0000001'), // ties with 'noosh', API order kept
    _rule('11', '400000.0000511', interfaceName: 'lan'),
    _rule('Test Rule 3', '400000.0000001', interfaceName: 'lan'),
    _rule('Default allow LAN to any rule', '400000.0000001',
        interfaceName: 'lan'), // ties with 'Test Rule 3'
    _rule('testing1', '200000.0000111'),
    _rule('Default allow LAN IPv6 to any rule', '400000.0000011',
        interfaceName: 'LAN'),
    _rule('2134', '200000.0000411'),
    _rule('123', '400000.0000311', interfaceName: 'lan'),
    _rule('hisham new', '200000.0000711'),
    _rule('noosh new', '200000.0000611'),
  ];

  final automatic = <FirewallRule>[
    _rule('let out anything from firewall host itself', '000005.1000022',
        automatic: true),
    _rule('Default deny / state violation rule', '000001.1000001',
        automatic: true),
    _rule('anti-lockout rule', '000005.1000023',
        interfaceName: 'LAN', automatic: true),
    _rule('sshlockout', '000001.1000009', automatic: true),
    _rule('IPv6 RFC4890 requirements (ICMP)', '000001.1000002',
        automatic: true),
  ];

  group('FirewallRuleFilter.groupByInterface', () {
    final grouped = FirewallRuleFilter.groupByInterface([
      ...automatic,
      ...userRules,
    ]);

    test('orders floating rules by sort_order, ties in API order', () {
      expect(_names(grouped[kFloatingInterfaceKey]!), [
        'noosh',
        'Test Rule',
        'testing1',
        'hello',
        '2134',
        'noosh new',
        'hisham new',
      ]);
    });

    test('orders LAN rules by sort_order, ties in API order', () {
      expect(_names(grouped['lan']!), [
        'Test Rule 3',
        'Default allow LAN to any rule',
        'Default allow LAN IPv6 to any rule',
        '123',
        '11',
        'hana',
      ]);
    });

    test('keeps automatic rules out of every interface bucket', () {
      final all = grouped.values.expand((r) => r).toList();
      expect(all.any((r) => r.isSystemGenerated), isFalse);
      expect(all.length, userRules.length);
    });

    test('lowercases interface keys and sorts them alphabetically', () {
      expect(grouped.keys.toList(), ['(floating)', 'lan']);
    });

    test('rules with empty or unparseable sort_order go last, in API order',
        () {
      final result = FirewallRuleFilter.groupByInterface([
        _rule('no order a', '', interfaceName: 'lan'),
        _rule('bad', 'abc', interfaceName: 'lan'),
        _rule('late', '400000.0000900', interfaceName: 'lan'),
        _rule('early', '400000.0000100', interfaceName: 'lan'),
        _rule('no order b', '', interfaceName: 'lan'),
      ]);
      expect(_names(result['lan']!),
          ['early', 'late', 'no order a', 'bad', 'no order b']);
    });

    test('keeps original order when no rule has a sort_order (demo data)', () {
      final result = FirewallRuleFilter.groupByInterface([
        _rule('b', '', interfaceName: 'lan'),
        _rule('a', '', interfaceName: 'lan'),
        _rule('c', '', interfaceName: 'lan'),
      ]);
      expect(_names(result['lan']!), ['b', 'a', 'c']);
    });
  });

  group('FirewallRuleFilter.automaticRules', () {
    test('returns only automatic rules in sort_order', () {
      final result =
          FirewallRuleFilter.automaticRules([...userRules, ...automatic]);
      expect(_names(result), [
        'Default deny / state violation rule',
        'IPv6 RFC4890 requirements (ICMP)',
        'sshlockout',
        'let out anything from firewall host itself',
        'anti-lockout rule',
      ]);
    });

    test('returns an empty list when there are no automatic rules', () {
      expect(FirewallRuleFilter.automaticRules(userRules), isEmpty);
    });
  });

  group('FirewallFormOptions', () {
    test('defaults have no proposed sequence', () {
      expect(FirewallFormOptions.defaults().defaultSequence, '');
    });
  });
}
