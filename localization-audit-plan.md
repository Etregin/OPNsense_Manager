# Localization Audit & Refactor Plan

## Overview

Audit and refine the Flutter localization ARB files (`lib/l10n/app_*.arb`) across all 5 supported
languages (en, de, es, fr, ar). The goal is to eliminate duplicate keys, remove non-translatable
strings, fix key naming, and correct placeholder types — without breaking any existing
`AppLocalizations.of(context)!.<key>` call sites.

**Template file:** `lib/l10n/app_en.arb` (~580 keys, 5330 lines)  
**Other locales:** `app_de.arb`, `app_es.arb`, `app_fr.arb`, `app_ar.arb`  
**Generated files** (never hand-edit): `app_localizations*.dart` — regenerated via `flutter gen-l10n`

**Confirmed decisions:**
- Non-translatable strings → new `StringConstants` class added to [`lib/utils/constants.dart`](lib/utils/constants.dart)
- Brand names (WireGuard, OpenVPN, Tailscale, etc.) are **not translated in any locale** — remove from all ARB files
- All ARB edits + Dart call-site updates happen in a **single implementation sub-task** (Sub-Task 5)

---

## Sub-Task 1 — Merge Duplicate Keys

**Status:** `[x] done`

### Intent
Remove every key that is a redundant alias of another key carrying the same text. The surviving
(canonical) key absorbs all call sites. This eliminates ~45 keys and removes a class of
maintenance bugs where two keys drift out of sync across locales.

### Expected Outcomes
- All duplicate-value key pairs resolved: one key retired, one kept.
- `app_en.arb` has no two keys sharing identical English text (except where semantic context
  genuinely differs — see "keep both" rows below).

### Todo List
1. Remove each "retire" key from `app_en.arb` (and all 4 other ARB files).
2. Leave the canonical key untouched in all ARB files.
3. Note all retired keys in the plan for Sub-Task 5 call-site replacement.

### Relevant Context — Full Merge Table

| English value | Retire | Keep (canonical) |
|---|---|---|
| `"Add"` | `addButton`, `addToList` | `add` |
| `"Cancel"` | `cancelButton` | `cancel` |
| `"Done"` | `doneButton` | `done` |
| `"Next"` | `nextButton` | `next` |
| `"Previous"` | `previousButton` | `previous` |
| `"Restart"` | `restartButton` | `restart` |
| `"Retry"` | `retryButton` | `retry` |
| `"Save"` | `saveTooltip` | `save` |
| `"Start"` | `startButton` | `start` |
| `"Stop"` | `stopButton` | `stop` |
| `"Copy"` | `copyTooltip` | `copy` |
| `"Refresh"` | `refreshTooltip` | `refresh` |
| `"Copy key"` | `copyKeyTooltip` | `copyKey` |
| `"API Key"` | `apiKeyLabel` | `apiKey` |
| `"API Secret"` | `apiSecretLabel` | `apiSecret` |
| `"Allowed IPs"` | `allowedIpsLabel` | `allowedIps` |
| `"Enabled"` | `enabledLabel` | `enabled` |
| `"Filters"` | `filtersLabel` | `filters` |
| `"Servers"` | `serversLabel` | `servers` |
| `"All"` (filter chip) | `allFilterOption` | `all` |
| `"Profile Name"` | `profileNameLabel` | `profileName` |
| `"Use HTTPS"` | `useHttpsLabel` | `useHttps` |
| `"No data available"` | `noData` | `noDataAvailable` |
| `"Rows per page"` | `rowsPerPageDropdown` | `rowsPerPage` (`rowsPerPageLabel` has trailing `: ` — keep separately or update) |
| `"Time range"` | `timeRangeLabel` | `timeRange` |
| `"Select Servers"` | `selectServersTitle` | `selectServers` |
| `"Service restarted successfully"` | `serviceRestarted` | `serviceRestartedSuccessfully` |
| `"Service started successfully"` | `serviceStarted` | `serviceStartedSuccessfully` |
| `"Service stopped successfully"` | `serviceStopped` | `serviceStoppedSuccessfully` |
| `"Status"` | `statusLabel` | `status` |
| `"Please add at least one connection endpoint"` | `pleaseAddConnectionEndpoint` | `addConnectionEndpoint` |
| `"Enable this client specific override"` | `enableThisClientOverride` | `enableClientSpecificOverride` |
| `"Enter the client's X.509 common name here."` | `enterClientX509CommonName` | `clientX509CommonNameHelper` |
| `"Page {x} of {y}"` (String params — broken) | `pageOfPages` | `pageOfTotal` (int params — correct) |
| `"Showing {start} to {end}"` (String params — broken) | `showingEntriesCount` | `showingEntries` (int params — correct) |
| `"A descriptive name for this static key"` | `descriptiveNameForStaticKey` | `staticKeyDescriptionHelper` |
| `"Select the key mode for auth or encryption"` | `selectKeyModeForAuthOrEncryption` | `selectKeyModeHelper` |
| Static key multi-line help text | `staticKeyInfoHelp` | `staticKeyHelpText` |
| `"You may enter a description here…"` | `youMayEnterDescriptionForReference` | `descriptionHelperTextOverride` |
| Connection blocking long text | `connectionBlockingSubtitle` | `connectionBlockingDescription` |
| Push reset long text | `pushResetSubtitle` | `pushResetDescription` |
| Redirect gateway long text | `redirectGatewayHelperText` | `redirectGatewayDescription` |
| Register DNS long text | `registerDnsSubtitle` | `registerDnsDescription` |
| `"Invalid IP address (must be IPv4 or IPv6)"` | `invalidIpAddressMustBeIpv4OrIpv6` | `invalidIpAddressFormat` |
| `"Invalid CIDR notation (use format: IP/prefix)"` | `invalidCidrFormat` | `invalidCidrNotation` |
| `"Import & Export"` | `importExport` | `importAndExport` |
| `"Import Profiles"` | `importProfilesTitle` | `importProfiles` |
| `"Export Profiles"` | `exportProfilesTitle` | `exportProfiles` |
| `"Delete Profile"` | `deleteProfileTitle` | `deleteProfile` |
| `"Change PIN"` | `changePinTitle` | `changePIN` → renamed to `changePin` in Sub-Task 3 |
| `"PIN Lock"` | `pinLockTitle` | `pinLock` |
| `"Confirm PIN"` | `confirmPIN` | `confirmPin` (camelCase wins; resolved with Sub-Task 3) |
| `"Enter PIN"` | `enterPIN` | `enterPin` (camelCase wins; resolved with Sub-Task 3) |
| `"Peer will be active when enabled"` | `peerActiveWhenEnabled` | `peerWillBeActiveWhenEnabled` |
| `"Common Name"` | `commonNameLabel` | `commonName` |
| `"Key {id}"` | `keyLabel` | `keyWithId` |
| `"Import Profiles"` subtitle vs title (same value) | `importProfilesTitle` | `importProfiles` |

**Keep both (genuine semantic difference):**
| Keys | Reason |
|---|---|
| `running` / `runningStatus` | Generic verb vs. status badge chip |
| `tailscaleVersion` / `versionLabel` | Tailscale-specific label vs. generic version label |
| `debug` / `severityDebug` | General debug toggle vs. syslog severity level |
| `error` / `severityError` | Generic error state vs. syslog severity level |
| `warning` / `severityWarning` | Generic warning vs. syslog severity level |
| `alert` / `severityAlert` | Generic alert vs. syslog severity level |
| `critical` / `severityCritical` | Generic state vs. syslog severity level |
| `notice` / `severityNotice` | Generic notice vs. syslog severity level |

---

## Sub-Task 2 — Remove Non-Translatable Strings

**Status:** `[x] done`

### Intent
Remove every key whose value is identical in all 5 locales and will never need translation —
brand names, technical acronyms, unit symbols, hint text, and legal boilerplate. These move into a
new `StringConstants` class added to [`lib/utils/constants.dart`](lib/utils/constants.dart).

### Expected Outcomes
- ~30 keys removed from all ARB files.
- `StringConstants` class created in [`lib/utils/constants.dart`](lib/utils/constants.dart) with
  every removed value as a named constant.
- `AppConstants.appName` (already `'OPNsense Manager'`) reused — no duplicate.

### Todo List
1. Add `StringConstants` to the bottom of [`lib/utils/constants.dart`](lib/utils/constants.dart).
2. Remove all listed keys from `app_en.arb` and all 4 other ARB files.
3. Note removed keys for Sub-Task 5 call-site replacement.

### Relevant Context — Keys to Remove & Their Replacements

**Brand / product names**
| ARB key | Value | `StringConstants` member |
|---|---|---|
| `appName` | `'OPNsense Manager'` | use `AppConstants.appName` (already exists) |
| `wireguard` | `'WireGuard'` | `StringConstants.wireguard` |
| `openvpn` | `'OpenVPN'` | `StringConstants.openvpn` |
| `tailscale` | `'Tailscale'` | `StringConstants.tailscale` |
| `dnsmasqServerName` | `'Dnsmasq'` | `StringConstants.dnsmasq` |
| `iscDhcpServerName` | `'ISC DHCP'` | `StringConstants.iscDhcp` |
| `keaDhcpServerName` | `'Kea DHCP'` | `StringConstants.keaDhcp` |
| `magicDns` | `'Magic DNS'` | `StringConstants.magicDns` |

**Network protocol acronyms (never translated)**
| ARB key | Value | `StringConstants` member |
|---|---|---|
| `protocolTcp` | `'TCP'` | `StringConstants.tcp` |
| `protocolUdp` | `'UDP'` | `StringConstants.udp` |
| `udp` | `'UDP'` | retired as duplicate of `protocolUdp` in Sub-Task 1; remove |
| `protocolTcpUdp` | `'TCP/UDP'` | `StringConstants.tcpUdp` |
| `protocolIcmp` | `'ICMP'` | `StringConstants.icmp` |
| `protocolIcmpv6` | `'ICMPv6'` | `StringConstants.icmpv6` |
| `protocolIgmp` | `'IGMP'` | `StringConstants.igmp` |
| `protocolIpv6` | `'IPv6'` | `StringConstants.ipv6Protocol` |
| `protocolOspf` | `'OSPF'` | `StringConstants.ospf` |
| `protocolAh` | `'AH'` | `StringConstants.ah` |
| `protocolEsp` | `'ESP'` | `StringConstants.esp` |
| `protocolGre` | `'GRE'` | `StringConstants.gre` |
| `protocolPim` | `'PIM'` | `StringConstants.pim` |
| `http` | `'http'` | `StringConstants.http` |
| `https` | `'https'` | `StringConstants.https` |

**Data unit symbols**
| ARB key | `StringConstants` member |
|---|---|
| `unitBytes` | `StringConstants.unitB` |
| `unitKilobytes` | `StringConstants.unitKB` |
| `unitMegabytes` | `StringConstants.unitMB` |
| `unitGigabytes` | `StringConstants.unitGB` |
| `unitTerabytes` | `StringConstants.unitTB` |
| `unitPetabytes` | `StringConstants.unitPB` |
| `unitPerSecond` | `StringConstants.unitPerSec` |
| `hourAbbrev` | `StringConstants.hourAbbrev` |
| `minuteAbbrev` | `StringConstants.minuteAbbrev` |
| `secondAbbrev` | `StringConstants.secondAbbrev` |
| `of1Gbps` | `StringConstants.of1Gbps` |

**Technical hint text (form field hints/examples)**
| ARB key | `StringConstants` member |
|---|---|
| `ipv4CidrHint` | `StringConstants.ipv4CidrHint` |
| `ipv4TunnelNetworkHint` | `StringConstants.ipv4CidrHint` (same value — share) |
| `ipv6CidrHint` | `StringConstants.ipv6CidrHint` |
| `ipv6TunnelNetworkHint` | `StringConstants.ipv6CidrHint` (same value — share) |
| `ipv4OrIpv6CidrHint` | `StringConstants.ipv4OrIpv6CidrHint` |
| `routeGatewayHint` | `StringConstants.routeGatewayHint` |
| `portPlaceholder` | `StringConstants.defaultPortHint` |

**Legal / license text (verbatim — must never be translated)**
| ARB key | Replacement |
|---|---|
| `gnuLicenseTitle` | `StringConstants.gnuLicenseTitle` |
| `gnuLicenseText` | Dart `const` string at call site (too long for a constant; keep inline) |
| `applicationLegalese` | Dart `const` string at call site |

**`StringConstants` class to add at bottom of `constants.dart`:**
```dart
/// Non-translatable display strings — brand names, technical acronyms,
/// unit symbols, and other values that are identical in every locale.
class StringConstants {
  StringConstants._();

  // App / product names
  static const String wireguard    = 'WireGuard';
  static const String openvpn      = 'OpenVPN';
  static const String tailscale    = 'Tailscale';
  static const String dnsmasq      = 'Dnsmasq';
  static const String iscDhcp      = 'ISC DHCP';
  static const String keaDhcp      = 'Kea DHCP';
  static const String magicDns     = 'Magic DNS';

  // Network protocol acronyms
  static const String tcp          = 'TCP';
  static const String udp          = 'UDP';
  static const String tcpUdp       = 'TCP/UDP';
  static const String icmp         = 'ICMP';
  static const String icmpv6       = 'ICMPv6';
  static const String igmp         = 'IGMP';
  static const String ipv6Protocol = 'IPv6';
  static const String ospf         = 'OSPF';
  static const String ah           = 'AH';
  static const String esp          = 'ESP';
  static const String gre          = 'GRE';
  static const String pim          = 'PIM';
  static const String http         = 'http';
  static const String https        = 'https';

  // Data unit symbols (SI / IEC — language-invariant)
  static const String unitB        = 'B';
  static const String unitKB       = 'KB';
  static const String unitMB       = 'MB';
  static const String unitGB       = 'GB';
  static const String unitTB       = 'TB';
  static const String unitPB       = 'PB';
  static const String unitPerSec   = '/s';
  static const String of1Gbps      = 'of 1 Gbps';
  static const String hourAbbrev   = 'h';
  static const String minuteAbbrev = 'm';
  static const String secondAbbrev = 's';

  // Technical hint / example text for form fields
  static const String ipv4CidrHint       = '10.8.0.0/24';
  static const String ipv6CidrHint       = 'fd00::/64';
  static const String ipv4OrIpv6CidrHint = '10.8.0.0/24 or fd00::/64';
  static const String routeGatewayHint   = '10.8.0.1';
  static const String defaultPortHint    = '443';

  // Legal / license metadata (verbatim — must not be translated)
  static const String gnuLicenseTitle = 'GNU General Public License v3.0';
}
```

---

## Sub-Task 3 — Fix Key Naming Convention

**Status:** `[x] done`

### Intent
Enforce strict `camelCase` on all remaining keys. Several keys use mid-word `ALL_CAPS` segments
(`PIN`, `VPN`, `DNS`) which is non-standard for Flutter ARB keys and generates non-idiomatic Dart
accessor names.

### Expected Outcomes
All keys in all ARB files use `camelCase`. No key contains uppercase-only word segments.

### Todo List
1. Rename each key in `app_en.arb` and all 4 other ARB files.
2. Note old → new names for Sub-Task 5 call-site replacement.

### Relevant Context — Rename Table

| Old key | New key | Notes |
|---|---|---|
| `changePIN` | `changePin` | Sub-Task 1 already retired `changePinTitle`; this is the survivor |
| `invalidPIN` | `invalidPin` | |
| `allVPNs` | `allVpns` | |
| `connectVPN` | `connectVpn` | |
| `disconnectVPN` | `disconnectVpn` | |
| `restartVPNService` | `restartVpnService` | |
| `noVPNConnectionsFound` | `noVpnConnectionsFound` | |
| `totalVPNs` | `totalVpns` | |
| `errorLoadingVPNConnections` | `errorLoadingVpnConnections` | |
| `unlockOPNsenseManager` | `unlockOpnsenseManager` | brand name portion lowercased |
| `connectToYourOPNsenseFirewall` | `connectToYourOpnsenseFirewall` | |

> `confirmPIN`/`enterPIN` are already resolved in Sub-Task 1 (retired in favour of `confirmPin`/`enterPin`).

---

## Sub-Task 4 — Fix Placeholder Type Inconsistencies

**Status:** `[x] done`

### Intent
Correct placeholder types from `String` to `int` where the value is always numeric. Using `String`
for numeric placeholders bypasses ICU plural formatting and produces less type-safe generated code.

### Expected Outcomes
All numeric time-offset and count placeholders use `int`, matching the ICU plural infrastructure
already used correctly by keys like `copiedLogEntries`, `lockAfterMinutes`, etc.

### Todo List
1. Update `type` field for each listed placeholder in `app_en.arb`.
2. Apply the same fix to all 4 other ARB files.
3. Update Dart call sites where the argument type changes (int vs String).

### Relevant Context — Type Fix Table

| Key | Placeholder | Current type | Correct type |
|---|---|---|---|
| `hoursAgo` | `hours` | `String` | `int` |
| `minutesAgo` | `minutes` | `String` | `int` |
| `inDays` | `days` | `String` | `int` |
| `inHours` | `hours` | `String` | `int` |
| `inMinutes` | `minutes` | `String` | `int` |

> `pageOfPages` and `showingEntriesCount` have String-typed placeholders but are **retired** in Sub-Task 1 — no fix needed.

---

## Sub-Task 5 — Apply All Changes: ARB Files + StringConstants + Call Sites + Regenerate

**Status:** `[x] done`

### Intent
Execute all decisions from Sub-Tasks 1–4 in a single coordinated pass:
1. Create `StringConstants` in [`lib/utils/constants.dart`](lib/utils/constants.dart)
2. Rewrite all 5 ARB files with merged, pruned, renamed, and type-fixed keys
3. Update every Dart call site that references a retired, removed, or renamed key
4. Regenerate localization code and verify the project compiles cleanly

### Expected Outcomes
- [`lib/utils/constants.dart`](lib/utils/constants.dart) contains the new `StringConstants` class.
- All 5 ARB files have identical key sets (same ~495 keys), clean of duplicates and non-translatables.
- `flutter gen-l10n` runs with no errors.
- `flutter analyze` reports zero new issues.
- The `untranslated.json` file (from `l10n.yaml`) is empty or absent.

### Todo List
1. **Add `StringConstants`** to the bottom of [`lib/utils/constants.dart`](lib/utils/constants.dart).
2. **Rewrite `app_en.arb`** applying all Sub-Task 1–4 changes atomically.
3. **Update `app_de.arb`, `app_es.arb`, `app_fr.arb`, `app_ar.arb`:**
   - Remove all retired/removed keys.
   - Rename all renamed keys.
   - Fix placeholder types.
   - Keep all surviving translation values unchanged.
4. **Run `flutter gen-l10n`** to regenerate `app_localizations*.dart`.
5. **Fix Dart call sites** — for each category below, grep and replace across `lib/`:

   **Retired aliases → canonical key:**
   ```
   l10n.addButton          → l10n.add
   l10n.cancelButton       → l10n.cancel
   l10n.doneButton         → l10n.done
   l10n.nextButton         → l10n.next
   l10n.previousButton     → l10n.previous
   l10n.restartButton      → l10n.restart
   l10n.retryButton        → l10n.retry
   l10n.saveTooltip        → l10n.save
   l10n.startButton        → l10n.start
   l10n.stopButton         → l10n.stop
   l10n.copyTooltip        → l10n.copy
   l10n.refreshTooltip     → l10n.refresh
   l10n.copyKeyTooltip     → l10n.copyKey
   l10n.apiKeyLabel        → l10n.apiKey
   l10n.apiSecretLabel     → l10n.apiSecret
   l10n.allowedIpsLabel    → l10n.allowedIps
   l10n.enabledLabel       → l10n.enabled
   l10n.filtersLabel       → l10n.filters
   l10n.serversLabel       → l10n.servers
   l10n.allFilterOption    → l10n.all
   l10n.profileNameLabel   → l10n.profileName
   l10n.useHttpsLabel      → l10n.useHttps
   l10n.noData             → l10n.noDataAvailable
   l10n.rowsPerPageDropdown→ l10n.rowsPerPage
   l10n.timeRangeLabel     → l10n.timeRange
   l10n.selectServersTitle → l10n.selectServers
   l10n.serviceRestarted   → l10n.serviceRestartedSuccessfully
   l10n.serviceStarted     → l10n.serviceStartedSuccessfully
   l10n.serviceStopped     → l10n.serviceStoppedSuccessfully
   l10n.statusLabel        → l10n.status
   l10n.pleaseAddConnectionEndpoint → l10n.addConnectionEndpoint
   l10n.enableThisClientOverride    → l10n.enableClientSpecificOverride
   l10n.enterClientX509CommonName   → l10n.clientX509CommonNameHelper
   l10n.pageOfPages(...)   → l10n.pageOfTotal(...) [update arg types to int]
   l10n.showingEntriesCount(...) → l10n.showingEntries(...) [update arg types to int]
   l10n.descriptiveNameForStaticKey → l10n.staticKeyDescriptionHelper
   l10n.selectKeyModeForAuthOrEncryption → l10n.selectKeyModeHelper
   l10n.staticKeyInfoHelp  → l10n.staticKeyHelpText
   l10n.youMayEnterDescriptionForReference → l10n.descriptionHelperTextOverride
   l10n.connectionBlockingSubtitle → l10n.connectionBlockingDescription
   l10n.pushResetSubtitle  → l10n.pushResetDescription
   l10n.redirectGatewayHelperText → l10n.redirectGatewayDescription
   l10n.registerDnsSubtitle → l10n.registerDnsDescription
   l10n.invalidIpAddressMustBeIpv4OrIpv6 → l10n.invalidIpAddressFormat
   l10n.invalidCidrFormat  → l10n.invalidCidrNotation
   l10n.importExport       → l10n.importAndExport
   l10n.importProfilesTitle → l10n.importProfiles
   l10n.exportProfilesTitle → l10n.exportProfiles
   l10n.deleteProfileTitle → l10n.deleteProfile
   l10n.changePinTitle     → l10n.changePin   (also rename changePIN)
   l10n.pinLockTitle       → l10n.pinLock
   l10n.confirmPIN(...)    → l10n.confirmPin
   l10n.enterPIN(...)      → l10n.enterPin
   l10n.peerActiveWhenEnabled → l10n.peerWillBeActiveWhenEnabled
   l10n.commonNameLabel    → l10n.commonName
   l10n.keyLabel(...)      → l10n.keyWithId(...)
   l10n.addToList          → l10n.add
   l10n.importProfilesTitle → l10n.importProfiles
   ```

   **Removed non-translatables → `StringConstants.*` or `AppConstants.appName`:**
   ```
   l10n.appName               → AppConstants.appName
   l10n.wireguard             → StringConstants.wireguard
   l10n.openvpn               → StringConstants.openvpn
   l10n.tailscale             → StringConstants.tailscale
   l10n.dnsmasqServerName     → StringConstants.dnsmasq
   l10n.iscDhcpServerName     → StringConstants.iscDhcp
   l10n.keaDhcpServerName     → StringConstants.keaDhcp
   l10n.magicDns              → StringConstants.magicDns
   l10n.protocolTcp           → StringConstants.tcp
   l10n.protocolUdp / l10n.udp → StringConstants.udp
   l10n.protocolTcpUdp        → StringConstants.tcpUdp
   l10n.protocolIcmp          → StringConstants.icmp
   l10n.protocolIcmpv6        → StringConstants.icmpv6
   l10n.protocolIgmp          → StringConstants.igmp
   l10n.protocolIpv6          → StringConstants.ipv6Protocol
   l10n.protocolOspf          → StringConstants.ospf
   l10n.protocolAh            → StringConstants.ah
   l10n.protocolEsp           → StringConstants.esp
   l10n.protocolGre           → StringConstants.gre
   l10n.protocolPim           → StringConstants.pim
   l10n.http                  → StringConstants.http
   l10n.https                 → StringConstants.https
   l10n.unitBytes             → StringConstants.unitB
   l10n.unitKilobytes         → StringConstants.unitKB
   l10n.unitMegabytes         → StringConstants.unitMB
   l10n.unitGigabytes         → StringConstants.unitGB
   l10n.unitTerabytes         → StringConstants.unitTB
   l10n.unitPetabytes         → StringConstants.unitPB
   l10n.unitPerSecond         → StringConstants.unitPerSec
   l10n.of1Gbps               → StringConstants.of1Gbps
   l10n.hourAbbrev            → StringConstants.hourAbbrev
   l10n.minuteAbbrev          → StringConstants.minuteAbbrev
   l10n.secondAbbrev          → StringConstants.secondAbbrev
   l10n.ipv4CidrHint          → StringConstants.ipv4CidrHint
   l10n.ipv4TunnelNetworkHint → StringConstants.ipv4CidrHint
   l10n.ipv6CidrHint          → StringConstants.ipv6CidrHint
   l10n.ipv6TunnelNetworkHint → StringConstants.ipv6CidrHint
   l10n.ipv4OrIpv6CidrHint    → StringConstants.ipv4OrIpv6CidrHint
   l10n.routeGatewayHint      → StringConstants.routeGatewayHint
   l10n.portPlaceholder       → StringConstants.defaultPortHint
   l10n.gnuLicenseTitle       → StringConstants.gnuLicenseTitle
   l10n.gnuLicenseText        → inline Dart const string at call site
   l10n.applicationLegalese   → inline Dart const string at call site
   ```

   **Renamed keys:**
   ```
   l10n.changePIN             → l10n.changePin
   l10n.invalidPIN            → l10n.invalidPin
   l10n.allVPNs               → l10n.allVpns
   l10n.connectVPN            → l10n.connectVpn
   l10n.disconnectVPN         → l10n.disconnectVpn
   l10n.restartVPNService     → l10n.restartVpnService
   l10n.noVPNConnectionsFound → l10n.noVpnConnectionsFound
   l10n.totalVPNs             → l10n.totalVpns
   l10n.errorLoadingVPNConnections → l10n.errorLoadingVpnConnections
   l10n.unlockOPNsenseManager → l10n.unlockOpnsenseManager
   l10n.connectToYourOPNsenseFirewall → l10n.connectToYourOpnsenseFirewall
   ```

   **Type-changed placeholders (int args now required):**
   ```
   l10n.hoursAgo(hours)    — ensure `hours` is passed as int (not String)
   l10n.minutesAgo(minutes) — ensure `minutes` is int
   l10n.inDays(days)       — ensure `days` is int
   l10n.inHours(hours)     — ensure `hours` is int
   l10n.inMinutes(minutes) — ensure `minutes` is int
   ```

6. **Run `flutter gen-l10n`** after all ARB edits are complete.
7. **Run `flutter analyze`** — fix any remaining type or reference errors.
8. **Check `untranslated.json`** — should be empty after cleanup.

### Relevant Context
- Generated files (`app_localizations*.dart`) must never be hand-edited — only ARB files.
- The 4 non-English ARB files must have **exactly the same key set** as `app_en.arb` after this task.
- Each surviving translation value in de/es/fr/ar must be preserved verbatim.
- `flutter gen-l10n` is the sole source of truth for whether the ARB files are valid.

---

## Summary of Changes

| Category | Count |
|---|---|
| Duplicate keys retired (aliases merged) | ~48 |
| Non-translatable keys removed from ARB | ~33 |
| Keys renamed for camelCase compliance | ~11 |
| Placeholder types corrected | 5 |
| **Total keys removed / retired from template** | **~85** |
| **Keys remaining after audit** | **~495** |
| New `StringConstants` members added to `constants.dart` | ~33 |
