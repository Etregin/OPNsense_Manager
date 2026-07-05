# Localization Audit & Refactor Plan

## Top-Level Overview

**Goal:** Audit and optimize all 5 ARB localization files (`app_en.arb`, `app_fr.arb`, `app_de.arb`, `app_es.arb`, `app_ar.arb`) for:
1. Duplicate keys that share identical English values → merge into the survivor key.
2. Redundant near-duplicate keys that serve the same purpose but are wired to different call-sites → consolidate.
3. Translatable strings that contain un-translated brand names, which are acceptable because those proper nouns never change across locales but the surrounding sentence does (these are **kept** — they are translated).
4. Hint/placeholder text that is truly locale-invariant example values (form field hints containing raw IP addresses, port numbers, etc.) — these are candidates to become `StringConstants` but are **low priority** because translators can legitimately adapt them (e.g. to use local IP notation conventions).
5. Casing and metadata consistency fixes.

**Scope:** `lib/l10n/app_en.arb` (template) plus all translation files. `lib/utils/constants.dart` (`StringConstants`) already exists and is well-structured — no changes needed there.

**Non-goals:** Rewriting translations; changing `StringConstants`; touching generated `.dart` files; altering application logic.

---

## Confirmed Issues (from codebase investigation)

### Group A — Exact-value duplicates (same English string, different keys, both used in code)

| Survivor key | Dead key | English value | Code references to dead key |
|---|---|---|---|
| `addStaticKey` | `addStaticKeyTooltip` | `"Add Static Key"` | `openvpn_instances_screen.dart:159` |
| `cannotDeleteLastConnection` | `cannotDeleteLastConnectionTooltip` | `"Cannot delete the last connection endpoint"` | `connection_endpoints_manager.dart:282` |
| `selectServerForQrCode` | `selectServerToGenerateQrCode` | `"Select server to generate QR code"` | `wireguard_peer_generator_screen.dart:567` |
| `atLeastOneTunnelAddressRequired` | `tunnelAddressRequired` | `"At least one tunnel address is required"` | `wireguard_peer_form_screen.dart:145` |
| `systemInformation` | `systemInfo` | `"System Information"` | `system_info_screen.dart:68,105`, `app_drawer.dart:130` |
| `serverWillBeActiveWhenEnabled` | `serverActiveWhenEnabled` | `"Server will be active when enabled"` | wireguard_server_form_screen.dart:404 |
| `myStaticKey` | `myStaticKeyHint` | `"My Static Key"` | `openvpn_static_key_form_screen.dart:219` |

### Group B — Status label redundancy (capitalized vs lower-case variants both exist)

These pairs exist because `running`/`stopped` are used as chip/badge labels and `runningStatus`/`stoppedStatus` were added later — but the code only ever uses the lower-cased "Status" variants for display (confirmed: `runningStatus` / `stoppedStatus` are **not used in any dart file**). Same for `enabledStatus` / `disabledStatus` / `unknownStatus`.

| Survivor key | Dead key | English value |
|---|---|---|
| `running` | `runningStatus` | `"Running"` |
| `stopped` | `stoppedStatus` | `"Stopped"` |
| `enabled` | `enabledStatus` | `"enabled"` |
| `disabled` | `disabledStatus` | `"disabled"` |
| `unknown` | `unknownStatus` | `"Unknown"` |

> **Note:** `enabled`/`disabled` are capitalised "Enabled"/"Disabled" while `enabledStatus`/`disabledStatus` are lower-case "enabled"/"disabled". These are semantically distinct. Sub-task 2 must confirm actual call sites before merging.

### Group C — Severity label duplicates

`alert`, `critical`, `debug`, `notice`, `warning` exist as generic words AND as `severityAlert`, `severityCritical`, `severityDebug`, `severityNotice`, `severityWarning`. The code in `wireguard_log_file_screen.dart` and `openvpn_log_file_screen.dart` uses the **generic** keys (`l10n.alert`, `l10n.critical`, etc.) for the severity filter list — the `severity*` keys are **not referenced in any dart file**.

| Survivor key | Dead key | English value |
|---|---|---|
| `alert` | `severityAlert` | `"Alert"` |
| `critical` | `severityCritical` | `"Critical"` |
| `debug` | `severityDebug` | `"Debug"` |
| `notice` | `severityNotice` | `"Notice"` |
| `warning` | `severityWarning` | `"Warning"` |

### Group D — Near-duplicate pairs (slightly different values, both used in code)

These need targeted code fixes (change the call-site to use the survivor) rather than just deleting the dead key.

| Survivor key | Dead key | Action |
|---|---|---|
| `allowSelfSignedCertificates` | `allowSelfSigned` | `connection_fields_section.dart:91` uses dead key — update to survivor |
| `systemInformation` | `systemInfo` | Both used. See Group A. |
| `importFailedWithErrors` | `importFailed` | Both used for different cases. **Keep both** — they have different placeholder patterns (`{errors}` vs `{error}`) |
| `enablePinLockFirstBiometric` | `enablePinLockFirst` | Both used at different call-sites — **Keep both** (slightly different phrasing, both valid) |
| `hostIpAddress` | `hostIpAddressLabel` | `hostIpAddressLabel` is **not referenced** — remove |
| `logEntriesCopied` | — | Uses a raw `{entries}` String placeholder (anti-pattern: the plural word is passed as a String parameter). Should be replaced by `copiedLogEntries` which uses proper ICU plural. **`logEntriesCopied` call-site:** not found in dart files → safe to remove |

### Group E — Hint/placeholder default values that belong in StringConstants

These form-field default hint strings contain raw technical values (IP addresses, port numbers) that are invariant across locales. They exist in the ARB but ideally live in `StringConstants`.

| Key | English value | Reason |
|---|---|---|
| `hostHint` | `"e.g., 192.168.1.1 or firewall.example.com"` | Example IP — locale-invariant |
| `hostPlaceholder` | `"192.168.1.1 or firewall.example.com"` | Same as above, **both used** (`hostHint` → `login_screen`, `hostPlaceholder` → separate widget) |
| `portHint` | `"e.g., 443"` | Raw port number |
| `macAddressHint` | `"e.g., 00:11:22:33:44:55"` | MAC format — invariant |

> Recommendation: Leave these in the ARB for now. Translators can legitimately localise the "e.g." prefix. Flag for future StringConstants migration only.

---

## Sub-Tasks

---

### Sub-Task 1: Remove dead severity-label keys (Group C)

**Status:** [ ] pending

**Intent:** Remove 5 unused `severity*` keys that duplicate the generic severity word keys. No code changes needed because the generic keys are the ones wired to call sites.

**Expected Outcomes:**
- `severityAlert`, `severityCritical`, `severityDebug`, `severityNotice`, `severityWarning` are deleted from all 5 ARB files.
- No dart file is broken (confirmed: no code references these keys).
- Total key count reduced by 5 across all language files.

**Todo List:**
1. Verify with a final grep that none of the 5 `severity*` keys appear in any `.dart` file.
2. Delete the 5 key+metadata pairs from `app_en.arb`.
3. Delete the same 5 key+metadata pairs from `app_fr.arb`, `app_de.arb`, `app_es.arb`, `app_ar.arb`.

**Relevant Context:**
- `lib/l10n/app_en.arb` lines 2376–2394
- Dart usage confirmed at: `lib/screens/wireguard_log_file_screen.dart` and `lib/screens/openvpn_log_file_screen.dart` (these use the generic keys, not the severity-prefixed ones)

---

### Sub-Task 2: Remove dead status-label keys (Group B)

**Status:** [ ] pending

**Intent:** Remove 5 `*Status` keys that duplicate capitalized/lowercase versions of the same words. Confirmed no Dart file references `runningStatus`, `stoppedStatus`, `enabledStatus`, `disabledStatus`, or `unknownStatus`.

**Note on `enabled`/`disabled` case difference:** `enabled` = `"Enabled"` (capital) and `enabledStatus` = `"enabled"` (lower). These are effectively the same word in most languages. The lower-case usage in English would be handled by the widget using the survivor key in a lower-case context if needed. Since no code references the dead keys, deletion is safe.

**Expected Outcomes:**
- `runningStatus`, `stoppedStatus`, `enabledStatus`, `disabledStatus`, `unknownStatus` are deleted from all 5 ARB files.
- No dart file is broken.
- Total key count reduced by 5 across all language files.

**Todo List:**
1. Final grep to confirm zero code references to the 5 dead keys.
2. Delete the 5 key+metadata pairs from `app_en.arb`.
3. Delete the same 5 key+metadata pairs from all translation files.

**Relevant Context:**
- `lib/l10n/app_en.arb` lines 2213, 2473, 2467–2474, 2713–2715

---

### Sub-Task 3: Merge Group A exact-value duplicate pairs — code + ARB

**Status:** [ ] pending

**Intent:** For each of the 7 exact-duplicate pairs in Group A, update the call-site in Dart to use the survivor key, then delete the dead key from all ARB files.

**Expected Outcomes:**
- 7 dead keys removed from all 5 ARB files.
- 7 Dart call-sites updated to reference the survivor key.
- App behaviour unchanged — strings are identical.

**Todo List:**

For each pair:
1. **`addStaticKeyTooltip` → `addStaticKey`**
   - Update `lib/screens/openvpn_instances_screen.dart:159` → `l10n.addStaticKey`
   - Delete `addStaticKeyTooltip` from all 5 ARB files.

2. **`cannotDeleteLastConnectionTooltip` → `cannotDeleteLastConnection`**
   - Update `lib/widgets/login/connection_endpoints_manager.dart:282` → `l10n.cannotDeleteLastConnection`
   - Delete `cannotDeleteLastConnectionTooltip` from all 5 ARB files.

3. **`selectServerToGenerateQrCode` → `selectServerForQrCode`**
   - Update `lib/screens/wireguard_peer_generator_screen.dart:567` → `l10n.selectServerForQrCode`
   - Delete `selectServerToGenerateQrCode` from all 5 ARB files.

4. **`tunnelAddressRequired` → `atLeastOneTunnelAddressRequired`**
   - Update `lib/screens/wireguard_peer_form_screen.dart:145` → `l10n.atLeastOneTunnelAddressRequired`
   - Delete `tunnelAddressRequired` from all 5 ARB files.

5. **`systemInfo` → `systemInformation`**
   - `systemInfo` is used only in route names/identifiers (non-l10n). The l10n key `l10n.systemInfo` is referenced in `system_info_screen.dart:68,105` and `app_drawer.dart:130` — grep showed both use `l10n.systemInformation`. Confirm no uses of `l10n.systemInfo` remain, then delete `systemInfo` key from all ARB files.

6. **`serverActiveWhenEnabled` → `serverWillBeActiveWhenEnabled`**
   - Update `lib/screens/wireguard_server_form_screen.dart:404` — already using `l10n.serverWillBeActiveWhenEnabled`. Confirm `serverActiveWhenEnabled` has no references, then delete.

7. **`myStaticKeyHint` → `myStaticKey`**
   - Update `lib/screens/openvpn_static_key_form_screen.dart:219` → `l10n.myStaticKey`
   - Delete `myStaticKeyHint` from all 5 ARB files.

**Relevant Context:**
- Survivor/dead key list in Group A table above
- All call-site line numbers documented above

---

### Sub-Task 4: Remove Group D orphaned keys (no code references)

**Status:** [ ] pending

**Intent:** Remove keys confirmed to have zero Dart call-site references.

**Keys to remove:**
| Key | Reason |
|---|---|
| `hostIpAddressLabel` | `hostIpAddress` is used; `hostIpAddressLabel` has no references |
| `logEntriesCopied` | Anti-pattern (passes plural word as String); replaced by `copiedLogEntries` with proper ICU plural. No code reference found. |
| `allowSelfSigned` | `allowSelfSignedCertificates` is used in `profile_management_screen.dart`. `allowSelfSigned` (singular) is used in `connection_fields_section.dart:91` — these are different UI contexts with different strings ("Allow Self-Signed Certificate" vs "Allow Self-Signed Certificates"). **Keep both.** Remove only `logEntriesCopied` and `hostIpAddressLabel` in this sub-task. |

**Expected Outcomes:**
- 2 dead keys removed from all 5 ARB files.
- No code broken.

**Todo List:**
1. Final grep confirming `hostIpAddressLabel` and `logEntriesCopied` have zero dart call-sites.
2. Delete `hostIpAddressLabel` from all 5 ARB files.
3. Delete `logEntriesCopied` from all 5 ARB files.

**Relevant Context:**
- `lib/l10n/app_en.arb` lines 1313, 1655–1665

---

### Sub-Task 5: Metadata and casing consistency audit

**Status:** [ ] pending

**Intent:** Ensure all keys follow `camelCase`, all parameterized keys have proper `@key` metadata blocks with `placeholders`, and all ICU plural expressions are syntactically valid. Fix any inconsistencies.

**Checks to perform:**
1. Scan all keys for non-`camelCase` names (e.g. keys starting with uppercase).
2. Verify every key with `{placeholder}` in the value has a corresponding `@key` block with a `placeholders` map and a `type` field.
3. Confirm ICU plural expressions (`{count, plural, ...}`) are well-formed.
4. Check `@@locale` is present and correct in each file.

**Known issues found:**
- `selectServerAndGenerateKeys` value starts with `#` — this is a Markdown heading that was accidentally placed in a translatable string. Evaluate whether it should be hardcoded.
- `live` key value is `"LIVE"` (all-caps) — this is a UI badge label that arguably should be hardcoded. However since it may legitimately differ (e.g. Arabic transliteration), keep it.

**Expected Outcomes:**
- No key names in non-camelCase.
- All placeholder keys have complete `@key` metadata.
- No broken ICU plural syntax.
- Document any remaining cosmetic issues in a note at the bottom of this plan.

**Todo List:**
1. Grep for keys with uppercase first characters (except `@@locale`).
2. Grep for `{` in values where the corresponding `@key` block has no `placeholders`.
3. Review `selectServerAndGenerateKeys` and determine if its `#` prefix is intentional.
4. Apply targeted fixes to any metadata issues found.

**Relevant Context:**
- `lib/l10n/app_en.arb` line 2275: `"selectServerAndGenerateKeys": "# Select a server and generate keys to preview configuration"`

---

### Sub-Task 6: Verify and document non-translatable strings still in ARB

**Status:** [ ] pending

**Intent:** Produce a final audit list of strings that contain brand names / technical invariants but are **correctly** kept in the ARB because the surrounding sentence is translated. This sub-task is documentation-only — it produces a "Non-Translatable Items Reference" section below.

**Items to evaluate:**
- Keys like `wireguardLogs`, `wireguardStatus`, `tailscaleSettings` — these contain `WireGuard`/`Tailscale` as part of a compound translated noun. ✅ Correct to keep.
- Keys like `checkIfWireguardIsConfiguredAndRunning` — sentence is translated even though the brand name stays fixed. ✅ Correct to keep.
- Keys like `dnsmasqDescription` (`"Lightweight DNS and DHCP server"`) — contains no brand name. ✅ Correct.
- `aboutDescription` — contains `"OPNsense"` brand name inside a translated sentence. ✅ Correct.

**Expected Outcomes:**
- Confirmation that no purely-brand-name-only strings (like `"WireGuard"` alone) remain in ARB.
- A documented reference list for the developer.

**Todo List:**
1. Grep ARB for keys whose value is **only** a brand name with no other translatable words.
2. Document findings here as a reference.

---

## Non-Translatable Items Reference

The following items are already correctly handled in `StringConstants` (`lib/utils/constants.dart`):

| Constant | Value | Category |
|---|---|---|
| `StringConstants.wireguard` | `'WireGuard'` | Product name |
| `StringConstants.openvpn` | `'OpenVPN'` | Product name |
| `StringConstants.tailscale` | `'Tailscale'` | Product name |
| `StringConstants.dnsmasq` | `'Dnsmasq'` | Product name |
| `StringConstants.iscDhcp` | `'ISC DHCP'` | Product name |
| `StringConstants.keaDhcp` | `'Kea DHCP'` | Product name |
| `StringConstants.magicDns` | `'Magic DNS'` | Product name |
| `StringConstants.tcp` | `'TCP'` | Protocol acronym |
| `StringConstants.udp` | `'UDP'` | Protocol acronym |
| `StringConstants.icmp` | `'ICMP'` | Protocol acronym |
| `StringConstants.unitMB` | `'MB'` | SI unit symbol |
| `StringConstants.gnuLicenseTitle` | `'GNU General Public License v3.0'` | Legal text |
| *(and all other entries in `StringConstants`)* | | |

**No changes needed to `StringConstants`** — it is complete and correct.

---

## Summary of Keys to Be Removed

Total dead keys to remove: **19** (across all 5 language files)

| # | Key | Reason |
|---|---|---|
| 1 | `severityAlert` | Duplicate of `alert` |
| 2 | `severityCritical` | Duplicate of `critical` |
| 3 | `severityDebug` | Duplicate of `debug` |
| 4 | `severityNotice` | Duplicate of `notice` |
| 5 | `severityWarning` | Duplicate of `warning` |
| 6 | `runningStatus` | Duplicate of `running` |
| 7 | `stoppedStatus` | Duplicate of `stopped` |
| 8 | `enabledStatus` | Duplicate of `enabled` (lower-case variant, no call-site) |
| 9 | `disabledStatus` | Duplicate of `disabled` (lower-case variant, no call-site) |
| 10 | `unknownStatus` | Duplicate of `unknown` |
| 11 | `addStaticKeyTooltip` | Exact duplicate of `addStaticKey` |
| 12 | `cannotDeleteLastConnectionTooltip` | Exact duplicate of `cannotDeleteLastConnection` |
| 13 | `selectServerToGenerateQrCode` | Exact duplicate of `selectServerForQrCode` |
| 14 | `tunnelAddressRequired` | Exact duplicate of `atLeastOneTunnelAddressRequired` |
| 15 | `systemInfo` (ARB key only) | Exact duplicate of `systemInformation` |
| 16 | `serverActiveWhenEnabled` | Exact duplicate of `serverWillBeActiveWhenEnabled` |
| 17 | `myStaticKeyHint` | Exact duplicate of `myStaticKey` |
| 18 | `hostIpAddressLabel` | Orphan — no dart call-site |
| 19 | `logEntriesCopied` | Anti-pattern replaced by `copiedLogEntries`; no call-site |

**Dart files requiring call-site updates:** 6 files, 7 locations (see Sub-Task 3 detail).
