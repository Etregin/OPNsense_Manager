# OPNsense Manager — Flutter Code Quality Audit Plan (v1.8.0 Phase 4)

## Overview

This plan is produced by a full codebase audit performed after Phases 1, 2, and 3 were
all fully executed (all sub-tasks in all three prior plans marked `[x] done`).

The audit performed a direct read of all Dart files in `lib/`, `pubspec.yaml`, and
`analysis_options.yaml` and identified **net-new technical debt** not addressed by any
prior plan. The prior three phases covered: dead dependencies, SnackBar consolidation,
BaseViewModel adoption, async hardening, naming conventions, validator consolidation,
hardcoded strings and colours, API endpoint extraction, service layer typing, route
extraction, lint hardening, AppDrawer SystemInfo lift, ApiException typing, and
BaseFormViewModel error preservation.

This phase targets the **remaining issues** grouped into five themes:

1. **Duplicate inline `showDialog` / `AlertDialog` implementations** — Screens that
   bypass `ConfirmationDialog` and construct raw `AlertDialog` widgets inline, despite
   the shared widget being available. Also, `ConfirmationDialog` itself has hardcoded
   default strings (`'Confirm'`, `'Cancel'`) instead of l10n-resolved values.

2. **Inline `Colors.*` usages that bypass `AppColors`** — Despite `AppColors` existing,
   dozens of widgets and screens use `Colors.green`, `Colors.red`, `Colors.grey[X]`,
   `Colors.orange`, `Colors.blue`, etc. directly. The `ServiceControlsCard` and
   `StatusCard` are egregious examples; the pattern spans 30+ files.

3. **Hardcoded English UI strings in widget files** — `ServiceControlsCard` uses
   `'Start'`, `'Stop'`, `'Restart'`, `'Service Controls'`; `StatusCard` uses `'Status'`,
   `'Device'`, `'Name'`, `'Listen Port'`, `'Endpoint'`, `'FW Mark'`, `'Peer Status'`,
   `'Handshake Age'`, `'Public Key'`, `'Handshake'`; `WireGuardLogDetailSheet` uses
   `'Severity'`, `'Facility'`, `'Message'`, `'Timestamp'`, `'Raw Timestamp'`, `'Host'`,
   `'Process Name'`, `'Process ID'`, `'Log Message'`, `'Timestamp Information'`;
   `OpenvpnStaticKeyCard` uses `'Today'`, `'Yesterday'`; `RoutingSettingsCard` uses
   `'None'`.

4. **Silent `catch (_)` blocks** — 11 locations in models, services, and ViewModels
   swallow exceptions without logging or propagating useful information. The blocks in
   `firewall_service.dart`, `system_service.dart`, and `wireguard_server_form_view_model.dart`
   are the most impactful; the ones in `openvpn_instance.dart` (JSON parsing), `profile.dart`
   (iterator failure), and `openvpn_client_override.dart` are defensive patterns that can
   be improved with targeted handling.

5. **Magic numbers and inline delays** — `rowCount: 1000` in `WireGuardPeersViewModel`,
   `rowCount == -1 ? 9999 : rowCount` in OpenVPN ViewModels, `9999` dropdown sentinel
   in `neighbor_discovery_screen.dart` and `openvpn_client_overrides_list_screen.dart`,
   and `Future.delayed(const Duration(milliseconds: 1500))` in `firewall_rules_screen.dart`
   should all be named constants with documentation of intent.

**Scope:** Targeted files only — no architecture changes beyond what is required to
resolve each specific issue.
**Approach:** Each sub-task is independently verifiable, scoped to one concern, and
has explicit file + line-level evidence grounded in direct code reads.

---

## Phase A — `ConfirmationDialog` Hardening & Inline Dialog Consolidation

### Sub-Task A.1 — Remove Hardcoded Defaults from `ConfirmationDialog`
**Status:** [x] done

**Intent:**
`lib/widgets/common/confirmation_dialog.dart:14-15` declares default parameter values:
```dart
this.confirmText = 'Confirm',
this.cancelText = 'Cancel',
```
And the static `show()` method at lines 23-24 mirrors these same hardcoded defaults.

Because every call site that relies on these defaults will display un-localised English
text in Arabic, German, Spanish, and French locales, these defaults must be removed. The
correct fix is to make `confirmText` and `cancelText` required parameters on `show()`,
which forces every call site to pass l10n-resolved strings. The widget constructor may
keep them as required fields too, or accept `null` and render nothing (callers already
always pass explicit values in the codebase).

**Evidence (direct code read):**
- `confirmation_dialog.dart:14` — `this.confirmText = 'Confirm'`
- `confirmation_dialog.dart:15` — `this.cancelText = 'Cancel'`
- `confirmation_dialog.dart:23-24` — same defaults on `show()`
- All 20+ call sites in the codebase already pass explicit `confirmText` and `cancelText`
  resolved from `AppLocalizations`, so making these required introduces zero breaking
  changes at call sites.

**Expected Outcomes:**
- `confirmText` and `cancelText` are required parameters on both the constructor and `show()`
- No call site passes hardcoded English strings (all existing call sites already provide l10n values)
- `flutter analyze` passes

**Todo List:**
1. Open `lib/widgets/common/confirmation_dialog.dart`
2. In the constructor, change `this.confirmText = 'Confirm'` to `required this.confirmText`
   and `this.cancelText = 'Cancel'` to `required this.cancelText`
3. In the `show()` static method, change `String confirmText = 'Confirm'` to
   `required String confirmText` and `String cancelText = 'Cancel'` to
   `required String cancelText`
4. Run `flutter analyze` — confirm zero call-site errors (all existing callers already
   supply explicit values)

**Relevant Context:**
- `lib/widgets/common/confirmation_dialog.dart:10-38`
- All call sites: `grep -rn "ConfirmationDialog.show" lib/`

---

### Sub-Task A.2 — Migrate Remaining Inline `AlertDialog` Confirmations to `ConfirmationDialog`
**Status:** [x] done

**Intent:**
Despite `ConfirmationDialog` being available, these files construct raw `AlertDialog`
widgets inline for confirmation flows that follow the exact yes/no pattern that
`ConfirmationDialog` is designed for:

- `lib/screens/openvpn_static_keys_list_screen.dart:92-112` — delete static key confirmation
- `lib/screens/wireguard_peers_screen.dart:85-103` — delete peer confirmation
- `lib/screens/openvpn_client_overrides_list_screen.dart:105-125` — delete override confirmation
- `lib/screens/openvpn_instances_list_screen.dart:119-139` — delete instance confirmation
- `lib/screens/login_screen.dart:290-310` — overwrite profile confirmation

Note: Complex dialogs with stateful content (`StatefulBuilder`, form inputs, multi-select)
are **not** in scope — only simple yes/no destructive confirmations.

**Evidence:**
- `openvpn_static_keys_list_screen.dart:92` — `showDialog<bool>` + inline `AlertDialog`
- `wireguard_peers_screen.dart:85` — `showDialog<bool>` + inline `AlertDialog`
- `openvpn_client_overrides_list_screen.dart:105` — same pattern
- `openvpn_instances_list_screen.dart:119` — same pattern
- `login_screen.dart:290` — same pattern

**Expected Outcomes:**
- Each of the five identified inline delete/overwrite dialogs replaced with
  `ConfirmationDialog.show(...)` using the equivalent l10n strings
- Inline `AlertDialog` constructor and `showDialog<bool>` calls removed from those sites
- `flutter analyze` passes

**Todo List:**
1. Open `lib/screens/openvpn_static_keys_list_screen.dart` — replace lines 92-112 with
   `ConfirmationDialog.show(context: context, title: l10n..., message: l10n..., confirmText: l10n.delete, cancelText: l10n.cancel, isDestructive: true)`
2. Open `lib/screens/wireguard_peers_screen.dart` — replace lines 85-103 with
   `ConfirmationDialog.show(...)` equivalent
3. Open `lib/screens/openvpn_client_overrides_list_screen.dart` — replace lines 105-125
4. Open `lib/screens/openvpn_instances_list_screen.dart` — replace lines 119-139
5. ~~Open `lib/screens/login_screen.dart` — replace lines 290-310~~ **SKIPPED** — the dialog
   at lines 290-310 has three distinct outcomes (`null` / `false` / `true` mapped to cancel /
   keep-both / overwrite). `ConfirmationDialog` only models a yes/no (bool), so a replacement
   would silently drop the "keep both" branch and change behaviour. This dialog is out of scope
   per the plan's own rule: "Do NOT touch complex stateful dialogs".
6. Run `flutter analyze`

**Relevant Context:**
- `lib/widgets/common/confirmation_dialog.dart` — the shared widget

---

## Phase B — Inline `Colors.*` Consolidation

### Sub-Task B.1 — Extend `AppColors` with Semantic Colour Constants
**Status:** [x] done

**Intent:**
`lib/utils/constants.dart` defines `AppColors` with only 8 constants: `primary`,
`secondary`, `success`, `warning`, `error`, `infoBackground`, `infoText`, `disabled`.
The codebase uses `Colors.grey[X]` (X = 200, 300, 400, 500, 600, 700, 800, 850),
`Colors.green`, `Colors.red`, `Colors.orange`, `Colors.blue`, and their shade/withValues
variants in 30+ widget and screen files, all bypassing `AppColors`.

Before any call site can be migrated (Phase B.2–B.3), the required semantic constants
must exist. The new constants cover every recurring inline colour found during the audit.

**Evidence (recurring patterns identified by grep):**
- `Colors.grey[400]` / `Colors.grey[600]` — icon and secondary text in 15+ widgets
- `Colors.green` / `Colors.red` — status indicators in `StatusCard`, `FirewallRuleCard`,
  `GatewaysSection`, `VPNConnectionCard`, `TailscalePeerCard`, `ServiceControlsCard`
- `Colors.orange` — warning / demo banner in `AppDrawer`, `DashboardScreen`,
  `VPNNavigationSection`, `RuleDetailSheet`
- `Colors.blue` — informational badges in `StatusCard`, `VPNSummaryCards`,
  `ProfileSelectionScreen`
- `Colors.grey[200]` / `Colors.grey[300]` — inactive track in `StatCard`,
  `InterfaceSelector`

**Expected Outcomes:**
- `AppColors` in `lib/utils/constants.dart` gains the following new constants (values
  taken directly from Material `Colors` class to ensure pixel-identical output):
  ```dart
  // Status colours
  static const Color online  = Color(0xFF4CAF50);   // Colors.green
  static const Color offline = Color(0xFF9E9E9E);   // Colors.grey
  static const Color danger  = Color(0xFFF44336);   // Colors.red

  // Text & icon tones (Material grey scale)
  static const Color textSecondary = Color(0xFF757575);  // Colors.grey[600]
  static const Color iconMuted     = Color(0xFFBDBDBD);  // Colors.grey[400]
  static const Color surfaceMid    = Color(0xFFE0E0E0);  // Colors.grey[300]
  static const Color surfaceLight  = Color(0xFFEEEEEE);  // Colors.grey[200]

  // Informational
  static const Color info       = Color(0xFF2196F3);  // Colors.blue
  static const Color infoBadge  = Color(0xFF1565C0);  // Colors.blue[900] / already infoText

  // Already-named aliases  (these already exist — do NOT duplicate them)
  // success = 0xFF4CAF50  (= Colors.green)
  // warning = 0xFFFF9800  (= Colors.orange)
  // error   = 0xFFF44336  (= Colors.red)
  // disabled = 0xFF9E9E9E (= Colors.grey)
  ```
- `flutter analyze` passes after adding constants

**Todo List:**
1. Open `lib/utils/constants.dart`
2. Add the new colour constants listed above to the `AppColors` class; keep them
   adjacent to the existing set with inline comments mapping back to `Colors.*`
3. Run `flutter analyze` — confirm no errors

**Relevant Context:**
- `lib/utils/constants.dart:74-84`
- `lib/widgets/wireguard/status_card.dart` — main consumer
- `lib/widgets/tailscale/service_controls_card.dart` — main consumer

---

### Sub-Task B.2 — Replace Inline `Colors.*` in Widget Files
**Status:** [x] done

**Intent:**
After B.1 adds the required constants, replace inline `Colors.*` usages in **widget**
files (under `lib/widgets/`) with the corresponding `AppColors.*` constants.

**Exact substitutions (evidence from grep):**

| File | Line(s) | Current | Replace With |
|------|---------|---------|-------------|
| `widgets/wireguard/status_card.dart` | 50, 90 | `Colors.green` / `Colors.red` (isUp indicator) | `AppColors.success` / `AppColors.danger` |
| `widgets/wireguard/status_card.dart` | 68, 74 | `Colors.blue` / `Colors.orange` (type badge) | `AppColors.info` / `AppColors.warning` |
| `widgets/wireguard/status_card.dart` | 143 | `Colors.green` / `Colors.grey` (peerStatus) | `AppColors.success` / `AppColors.disabled` |
| `widgets/wireguard/status_card.dart` | 197, 206 | `Colors.grey[600]` | `AppColors.textSecondary` |
| `widgets/tailscale/service_controls_card.dart` | 58, 69 | `Colors.green` / `Colors.red` | `AppColors.success` / `AppColors.danger` |
| `widgets/firewall/firewall_rule_card.dart` | 40, 42, 44, 46 | `Colors.green` / `Colors.red` / `Colors.orange` / `Colors.grey` | `AppColors.success` / `AppColors.danger` / `AppColors.warning` / `AppColors.disabled` |
| `widgets/firewall/firewall_rule_card.dart` | 110, 119 | `Colors.grey[600]` / `Colors.green` (track) | `AppColors.textSecondary` / `AppColors.success` |
| `widgets/firewall/firewall_rule_card.dart` | 127, 143, 172, 183, 191 | `Colors.grey[800/400/600/200]` | `AppColors.surfaceMid` / `AppColors.iconMuted` / `AppColors.textSecondary` etc. |
| `widgets/firewall/rule_detail_sheet.dart` | 155, 157, 161, 167 | `Colors.orange.withValues` / `Colors.orange[700]` | `AppColors.warning.withValues(...)` / `AppColors.warning` |
| `widgets/firewall/rule_detail_sheet.dart` | 137 | `Colors.grey` | `AppColors.disabled` |
| `widgets/firewall/rule_detail_sheet.dart` | 196 | `Colors.red` | `AppColors.danger` |
| `widgets/firewall/interface_selector.dart` | 45-62 | `Colors.grey[850/100/700/300/600]` | theme-aware or `AppColors.*` equivalents |
| `widgets/common/empty_state_widget.dart` | 43, 50 | `Colors.grey[400/600]` | `AppColors.iconMuted` / `AppColors.textSecondary` |
| `widgets/vpn/vpn_connection_card.dart` | 46, 62, 68, 82 | `Colors.green/grey/red` | `AppColors.success/disabled/danger` |
| `widgets/vpn/tailscale_peer_card.dart` | 42, 57 | `Colors.green/grey` | `AppColors.success/disabled` |
| `widgets/vpn/vpn_summary_cards.dart` | 51, 58, 77, 84 | `Colors.green/grey/blue` | `AppColors.success/disabled/info` |
| `widgets/vpn/vpn_detail_section.dart` | 105 | `Colors.grey` | `AppColors.disabled` |
| `widgets/dashboard/gateways_section.dart` | 121, 134, 141 | `Colors.green/red` | `AppColors.success/danger` |
| `widgets/stat_card.dart` | 78, 93, 176, 191, 201, 307, 328, 374, 389, 421, 436, 452, 521 | `Colors.grey[600/500/200]` | `AppColors.textSecondary/iconMuted/surfaceLight` |
| `widgets/settings/profile_card.dart` | 54, 123, 125 | `Colors.grey[400]/red` | `AppColors.iconMuted/danger` |
| `widgets/settings/settings_tile.dart` | 67 | `Colors.grey[600]` | `AppColors.textSecondary` |
| `widgets/login/connection_endpoints_manager.dart` | 114, 285 | `Colors.red` | `AppColors.danger` |
| `widgets/login/dhcp_server_selector.dart` | 70 | `Colors.grey[600]` | `AppColors.textSecondary` |
| `widgets/openvpn/openvpn_form_field_widgets.dart` | 250, 337, 512, 535 | `Colors.grey/red` | `AppColors.disabled/danger` |
| `widgets/tailscale/routing_settings_card.dart` | 130 | `Colors.red` | `AppColors.danger` |
| `widgets/drawer/vpn_navigation_section.dart` | 344-382 | `Colors.green/grey/orange` shades | `AppColors.success/disabled/warning` with equivalent opacity |
| `widgets/app_drawer.dart` | 186, 189, 270, 283 | `Colors.red/orange` | `AppColors.danger/warning` |
| `widgets/drawer/system_navigation_section.dart` | 56, 59, 85, 98 | `Colors.red/orange` | `AppColors.danger/warning` |

**Expected Outcomes:**
- Zero `Colors.red`, `Colors.green`, `Colors.orange`, `Colors.blue`, `Colors.grey[X]`
  references remain in `lib/widgets/`
- All imports of `package:flutter/material.dart` in widget files still resolve (the
  `Colors` class is still available for any non-colour uses such as `Color`)
- `flutter analyze` passes

**Todo List:**
1. Apply substitutions listed in the table above, file by file
2. For `Colors.grey[X]` with shade subscripts, map as follows:
   - `[200]` → `AppColors.surfaceLight`
   - `[300]` → `AppColors.surfaceMid`
   - `[400]` → `AppColors.iconMuted`
   - `[500/600]` → `AppColors.textSecondary`
   - `[700/800/850]` → use `Theme.of(context).colorScheme.onSurfaceVariant` where
     appropriate, or add new constants if a static colour is required
3. For `Colors.*.withValues(alpha: x)` calls, replace as `AppColors.success.withValues(alpha: x)`
4. Run `flutter analyze` after each file

**Relevant Context:**
- `lib/utils/constants.dart` — `AppColors` class extended in B.1

---

### Sub-Task B.3 — Replace Inline `Colors.*` in Screen Files
**Status:** [x] done

**Intent:**
Screen files under `lib/screens/` also contain direct `Colors.*` usages. These are
addressed separately from widget files to keep each sub-task reviewable independently.

**Exact files and lines (evidence from grep):**

| File | Line(s) | Current | Replace With |
|------|---------|---------|-------------|
| `screens/dashboard_screen.dart` | 185, 186 | `Colors.orange.shade400/600` | `AppColors.warning` / lighter shade constant |
| `screens/dashboard_screen.dart` | 260 | `Colors.red[300]` | `AppColors.danger` |
| `screens/dashboard_screen.dart` | 269 | `Colors.grey[600]` | `AppColors.textSecondary` |
| `screens/firewall_rules_screen.dart` | 265, 295 | `Colors.grey[400]` | `AppColors.iconMuted` |
| `screens/firewall_logs_screen.dart` | 242, 244, 246, 248 | `Colors.green/red/orange/grey` | `AppColors.success/danger/warning/disabled` |
| `screens/firewall_logs_screen.dart` | 387, 388, 394, 401 | `Colors.orange/green` | `AppColors.warning/success` |
| `screens/firewall_logs_screen.dart` | 432, 464 | `Colors.red[300]/grey[400]` | `AppColors.danger/iconMuted` |
| `screens/firewall_aliases_screen.dart` | 388, 427, 428, 459, 481, 512 | `Colors.grey/green` | `AppColors.textSecondary/success/disabled` |
| `screens/wireguard_servers_screen.dart` | 270, 271, 296, 317, 361 | `Colors.green/grey/red` | `AppColors.success/disabled/danger` |
| `screens/wireguard_peers_screen.dart` | 98, 269, 295 | `Colors.red/grey` | `AppColors.danger/disabled` |
| `screens/wireguard_peer_generator_screen.dart` | 287 | `Colors.red` | `AppColors.danger` |
| `screens/openvpn_log_file_screen.dart` | 223, 225 | `Colors.orange/amber` | `AppColors.warning` |
| `screens/openvpn_static_keys_list_screen.dart` | 107, 156 | `Colors.red/grey[100]` | `AppColors.danger/surfaceLight` |
| `screens/openvpn_client_overrides_list_screen.dart` | 119 | `Colors.red` | `AppColors.danger` |
| `screens/openvpn_instances_list_screen.dart` | 134 | `Colors.red` | `AppColors.danger` |
| `screens/openvpn_instance_form_screen.dart` | 597 | `Colors.red` | `AppColors.danger` |
| `screens/openvpn_static_key_form_screen.dart` | 196, 198, 202, 207 | `Colors.red[50]/red` | `AppColors.danger` |
| `screens/openvpn_client_override_form_screen.dart` | 332 | `Colors.red` | `AppColors.danger` |
| `screens/settings_screen.dart` | 131 | `Colors.grey` | `AppColors.disabled` |
| `screens/settings/profile_management_screen.dart` | 226, 366, 462, 468, 474 | `Colors.grey/orange` | `AppColors.textSecondary/warning` |
| `screens/login_screen.dart` | 174, 188, 196, 507 | `Colors.green/orange/red/grey[600]` | `AppColors.success/warning/danger/textSecondary` |
| `screens/profile_selection_screen.dart` | 295-534 | Various `Colors.red/blue/grey/orange` shades | Corresponding `AppColors.*` |
| `screens/live_network_monitor_screen.dart` | 336, 344, 456, 465, 478, 487, 598, 640, 649, 752-765 | Various | Corresponding `AppColors.*` |
| `screens/wol_screen.dart` | 142, 437, 439 | `Colors.red` | `AppColors.danger` |
| `screens/dhcp_leases_screen.dart` | 425-689 | Various `Colors.grey/blue/orange/green` | Corresponding `AppColors.*` |
| `screens/system_info_screen.dart` | 170, 178 | `Colors.grey[600]` | `AppColors.textSecondary` |
| `screens/neighbor_discovery_screen.dart` | 144-153 | `Colors.green/orange/grey` shades | `AppColors.success/warning/disabled` |

**Expected Outcomes:**
- Zero `Colors.*` references remain in `lib/screens/` for status/decoration colours
- Exception: `Theme.of(context).colorScheme.*` usages remain unchanged — these are
  correct Material theming
- `flutter analyze` passes

**Todo List:**
1. Apply substitutions listed in the table above, screen file by screen file
2. For shade variants (`Colors.orange.shade400`, `Colors.blue.shade50`, etc.) use the
   closest `AppColors` constant; where a lighter tint is needed, use
   `AppColors.warning.withValues(alpha: 0.15)` or similar
3. Run `flutter analyze` after each file change

**Relevant Context:**
- `lib/utils/constants.dart` — `AppColors` extended in B.1

---

## Phase C — Hardcoded English UI Strings in Widget Files

### Sub-Task C.1 — Localise `ServiceControlsCard` Strings
**Status:** [x] done

**Intent:**
`lib/widgets/tailscale/service_controls_card.dart` has five hardcoded English strings:
- Line 43: `'Service Controls'` (card title)
- Line 56: `'Start'` (button label)
- Line 67: `'Stop'` (button label)
- Line 78: `'Restart'` (button label)

The widget accepts callbacks but no `BuildContext`-derived l10n. It must import
`AppLocalizations` and resolve the strings via `context`.

**Evidence (direct code read):**
- `service_controls_card.dart:42-78` — all five strings confirmed hardcoded

**Expected Outcomes:**
- `service_controls_card.dart` imports `AppLocalizations`
- `build()` resolves `l10n = AppLocalizations.of(context)!`
- `'Service Controls'` replaced with `l10n.serviceControls` (or equivalent key)
- `'Start'` / `'Stop'` / `'Restart'` replaced with corresponding l10n keys
- Required l10n keys added to all five `.arb` files (`app_en.arb`, `app_ar.arb`,
  `app_de.arb`, `app_es.arb`, `app_fr.arb`)
- `flutter analyze` passes

**Todo List:**
1. Identify which l10n keys already exist for `start`, `stop`, `restart`:
   `grep -n "start\|stop\|restart\|serviceControl" lib/l10n/app_en.arb`
2. Add any missing keys to all five `.arb` files
3. Run `flutter gen-l10n` (or `flutter pub run build_runner build`) to regenerate
4. Open `service_controls_card.dart` — add `AppLocalizations` import
5. In `build()`, add `final l10n = AppLocalizations.of(context)!;`
6. Replace each hardcoded string with the l10n key
7. Run `flutter analyze`

**Relevant Context:**
- `lib/widgets/tailscale/service_controls_card.dart:22-88`
- `lib/l10n/app_en.arb` — existing keys

---

### Sub-Task C.2 — Localise `StatusCard` (WireGuard) Strings
**Status:** [x] done

**Intent:**
`lib/widgets/wireguard/status_card.dart` uses hardcoded English strings as row labels:
- Line 87: `'Status'`
- Line 96: `'Device'`
- Line 105: `'Name'`
- Line 113: `'Listen Port'`
- Line 122: `'Endpoint'`
- Line 130: `'FW Mark'`
- Line 140: `'Peer Status'`
- Line 150: `'Handshake Age'` (with `'seconds ago'` suffix — line 151)
- Line 158: `'Public Key'`
- Line 168: `'Handshake'`

**Expected Outcomes:**
- All ten label strings replaced with l10n keys
- `'X seconds ago'` formatted via an l10n parametric string
- New keys added to all five `.arb` files where missing
- `flutter analyze` passes

**Todo List:**
1. Audit existing `.arb` keys for any matches (`status`, `device`, `name`, `port`,
   `endpoint`, `handshake`, `publicKey`)
2. Add missing keys to all five `.arb` files
3. Regenerate l10n
4. Open `status_card.dart` — add l10n import and resolve in `build()`
5. Replace all ten label strings with l10n keys
6. Replace `'${item.latestHandshakeAge!} seconds ago'` with `l10n.secondsAgo(item.latestHandshakeAge!)`
   (parametric key)
7. Run `flutter analyze`

**Relevant Context:**
- `lib/widgets/wireguard/status_card.dart:85-174`
- `lib/l10n/app_en.arb`

---

### Sub-Task C.3 — Localise `WireGuardLogDetailSheet` Strings
**Status:** [x] done

**Intent:**
`lib/widgets/wireguard/wireguard_log_detail_sheet.dart` has these hardcoded labels
used as section headers and row labels:
- Line 124: `'Process Name'`
- Line 132: `'Process ID'`
- Line 138: `'Severity'`
- Line 146: `'Facility'`
- Line 155: `'Log Message'` (section header)
- Line 161: `'Message'`
- Line 172: `'Timestamp Information'` (section header)
- Line 178: `'Timestamp'`
- Line 185: `'Raw Timestamp'`
- Line 193: `'Host'`

**Expected Outcomes:**
- All ten strings replaced with l10n keys
- Keys added to all five `.arb` files
- `flutter analyze` passes

**Todo List:**
1. Check existing arb files for overlapping keys
2. Add missing keys
3. Regenerate l10n
4. Apply substitutions in `wireguard_log_detail_sheet.dart`
5. Run `flutter analyze`

**Relevant Context:**
- `lib/widgets/wireguard/wireguard_log_detail_sheet.dart:120-200`

---

### Sub-Task C.4 — Localise Remaining Widget Hardcoded Strings
**Status:** [x] done

**Intent:**
Consolidates the remaining widget-file hardcoded strings not covered by C.1–C.3:

- `lib/widgets/openvpn/openvpn_static_key_card.dart:164,166` — `'Today'`, `'Yesterday'`
- `lib/widgets/tailscale/routing_settings_card.dart:79` — `'None'` (exit node dropdown sentinel)

**Expected Outcomes:**
- `'Today'` / `'Yesterday'` in `openvpn_static_key_card.dart` resolved via `l10n.today` /
  `l10n.yesterday` (keys added to all `.arb` files if missing)
- `'None'` in `routing_settings_card.dart` resolved via `l10n.none` (already present in
  most arb files — verify first)
- `flutter analyze` passes

**Todo List:**
1. Check arb files for `today`, `yesterday`, `none` keys
2. Add any missing keys to all five `.arb` files
3. Regenerate l10n
4. Open each file — add l10n import if missing, resolve in `build()`
5. Replace hardcoded strings
6. Run `flutter analyze`

**Relevant Context:**
- `lib/widgets/openvpn/openvpn_static_key_card.dart:159-172`
- `lib/widgets/tailscale/routing_settings_card.dart:76-80`

---

## Phase D — Silent `catch (_)` Block Remediation

### Sub-Task D.1 — Remediate `catch (_)` Blocks in Service & ViewModel Files
**Status:** [x] done

**Intent:**
These files contain `catch (_) {}` or `catch (_) { // comment }` blocks that silently
discard exceptions in production code paths where the failure is observable or
actionable:

1. **`lib/services/firewall/firewall_service.dart:52,65`** — `_parseFirewallRule()` throws
   on malformed data; the catch discards the error. Replace with a `debugPrint` guard or
   log the malformed entry so developers can identify API response issues.

2. **`lib/services/system/system_service.dart:375`** — `catch (_) { rethrow; }` is a
   no-op catch-and-rethrow. The `try/catch` adds no value. Remove the wrapping
   `try/catch` entirely.

3. **`lib/viewmodels/wireguard_server_form_view_model.dart:72`** — `loadCarpVipOptions()`
   silently swallows all errors. Since CARP VIP is optional, this is intentional, but the
   comment should reflect this explicitly and the blank `catch` should at minimum use
   `catch (e)` for documentation purposes.

**Evidence:**
- `firewall_service.dart:52` — `} catch (_) { // Silently handle error }`
- `firewall_service.dart:65` — same
- `system_service.dart:375` — `} catch (_) { // Silently handle error \n rethrow; }`
- `wireguard_server_form_view_model.dart:72` — `} catch (_) { // Don't set error for CARP options as it's optional }`

**Expected Outcomes:**
- `firewall_service.dart:52,65` — replace `catch (_)` with `catch (e)` and add
  `assert(() { debugPrint('FirewallService: failed to parse rule: $e'); return true; }())`
  so the error surfaces only in debug builds without affecting release performance
- `system_service.dart:375-378` — remove the wrapping `try { ... } catch (_) { rethrow; }`
  leaving just the inner code block
- `wireguard_server_form_view_model.dart:72` — change `catch (_)` to `catch (e)` with
  the existing comment retained; no debugPrint needed (CARP is truly optional)
- `flutter analyze` passes

**Todo List:**
1. Open `lib/services/firewall/firewall_service.dart`; locate lines 50-70; replace both
   `catch (_)` blocks with `catch (e)` + `assert`-guarded `debugPrint`
2. Open `lib/services/system/system_service.dart`; locate lines 373-378; delete the
   outer `try/catch` wrapper, leaving the code body intact
3. Open `lib/viewmodels/wireguard_server_form_view_model.dart`; change `catch (_)` to
   `catch (e)` on line 72
4. Run `flutter analyze`

**Relevant Context:**
- `lib/services/firewall/firewall_service.dart:40-80`
- `lib/services/system/system_service.dart:373-379`
- `lib/viewmodels/wireguard_server_form_view_model.dart:65-78`

---

### Sub-Task D.2 — Remediate `catch (_)` in Model JSON Parsing and Formatting
**Status:** [x] done

**Intent:**
Three distinct situations apply across these files — each requires a different fix:

**Situation 1 — JSON dropdown parsing (skip-and-continue, debug visibility only):**
`lib/models/openvpn_instance.dart:571,591` and `lib/models/openvpn_client_override.dart:183`
iterate over API response entries and skip any entry that fails `OpenvpnDropdownOption.fromJson`.
The skip-and-continue behaviour is **correct** — a malformed entry means one fewer
dropdown option, not a broken form. No change to runtime behaviour is needed.

The only improvement is debug-mode visibility: in debug builds, a developer seeing a
form with fewer options than expected can check the console. In release builds, the
`assert` block is stripped entirely by the Dart compiler — zero overhead, identical
behaviour.

Fix: `catch (_) {}` → `catch (e) { assert(() { debugPrint('...: $e'); return true; }()); }`

**Situation 2 — Timestamp format fallback (value fallback, debug visibility only):**
`lib/screens/wireguard_log_file_screen.dart:276` — at this point both ISO and Unix epoch
parse strategies have already failed; the `catch (_)` returns the raw timestamp string
as a last resort. This is correct. No snackbar or user notification is appropriate here
since this is a pure display-formatting helper, not a user-triggered action.

Fix: `catch (_)` → `catch (e)` + assert-guarded `debugPrint`. The `return timestamp`
fallback is unchanged.

**Situation 3 — `firstWhere` fallback (targeted exception type):**
`lib/models/profile.dart:64,125` — `catch (_)` is used to catch the `StateError` thrown
by `firstWhere` when no matching element exists, falling back to `connections.first`.
The logic is correct, but `catch (_)` is too broad: it would also silently swallow any
genuinely unexpected exception. Replace with `on StateError catch (_)` to make the
intent explicit; any other exception will propagate normally.

**Expected Outcomes:**
- `openvpn_instance.dart:571,591` — `catch (_) {}` → `catch (e) { assert(() { debugPrint('OpenvpnInstance: failed to parse dropdown option: $e'); return true; }()); }`
- `openvpn_client_override.dart:183` — same pattern with message `'OpenvpnClientOverride: failed to parse dropdown option: $e'`
- `wireguard_log_file_screen.dart:276` — `catch (_)` → `catch (e)` + assert-debugPrint `'WireGuardLogFileScreen: failed to parse timestamp: $e'`; `return timestamp` unchanged
- `profile.dart:64` — `catch (_)` → `on StateError catch (_)`
- `profile.dart:125` — same
- `flutter analyze` passes

**Todo List:**
1. Open `lib/models/openvpn_instance.dart`; at lines 571 and 591 replace `catch (_) {}`
   with:
   ```dart
   catch (e) {
     assert(() {
       debugPrint('OpenvpnInstance: failed to parse dropdown option: $e');
       return true;
     }());
   }
   ```
2. Open `lib/models/openvpn_client_override.dart`; at line 183 apply the same pattern
   with message `'OpenvpnClientOverride: failed to parse dropdown option: $e'`
3. Open `lib/screens/wireguard_log_file_screen.dart`; at line 276 change `catch (_)` to
   `catch (e)` and add the assert-debugPrint block; keep `return timestamp` as-is
4. Open `lib/models/profile.dart`; at lines 64 and 125 replace `catch (_)` with
   `on StateError catch (_)`
5. Run `flutter analyze`

**Relevant Context:**
- `lib/models/openvpn_instance.dart:566-596` — Situation 1
- `lib/models/openvpn_client_override.dart:178-188` — Situation 1
- `lib/screens/wireguard_log_file_screen.dart:265-280` — Situation 2
- `lib/models/profile.dart:61-67`, `122-128` — Situation 3

---

### Sub-Task D.3 — Remediate Remaining `catch (_)` Blocks
**Status:** [x] done

**Intent:**
Two remaining `catch (_)` blocks not covered by D.1–D.2:

1. **`lib/widgets/app_drawer.dart:99`** — `_fetchSystemInfo()` swallows all errors.
   The comment says "System info is optional — silently ignore failures." This is correct
   for the UX, but using `catch (_)` is broader than necessary. Change to `catch (e)`
   with an `assert`-guarded `debugPrint` for debug visibility.

2. **`lib/services/demo_api_service.dart` (multiple)** — The `getFirewallRule` helper at
   line 115 uses a bare `catch (e)` (not `catch (_)`) already — this is acceptable.
   No action needed.

**Expected Outcomes:**
- `app_drawer.dart:99` — `catch (_)` → `catch (e)` + assert-guarded `debugPrint`
- `flutter analyze` passes

**Todo List:**
1. Open `lib/widgets/app_drawer.dart`
2. At line 99 change `catch (_)` to `catch (e)` and add:
   ```dart
   assert(() {
     debugPrint('AppDrawer: failed to fetch system info: $e');
     return true;
   }());
   ```
3. Run `flutter analyze`

**Relevant Context:**
- `lib/widgets/app_drawer.dart:91-102`

---

## Phase E — Magic Numbers & Inline Delay Constants

### Sub-Task E.1 — Extract Magic Numbers into Named Constants
**Status:** [x] done

**Intent:**
These magic numbers are used without explanation in the code and should be named
constants in `AppConstants`:

1. **`lib/viewmodels/wireguard_peers_view_model.dart:37`** — `rowCount: 1000`:
   the maximum peers to fetch. Add `AppConstants.maxPeerRowCount = 1000`.

2. **`lib/viewmodels/openvpn_instances_view_model.dart:56`** — `rowCount: rowCount == -1 ? 9999 : rowCount`:
   the sentinel value `9999` means "all rows". Add `AppConstants.allRowsSentinel = 9999`.

3. **`lib/viewmodels/openvpn_static_keys_view_model.dart:40`** — same `9999` pattern.
   Use `AppConstants.allRowsSentinel`.

4. **`lib/screens/neighbor_discovery_screen.dart:228`** — `DropdownMenuItem(value: 9999, child: Text('All'))`:
   use `AppConstants.allRowsSentinel`.

5. **`lib/screens/openvpn_client_overrides_list_screen.dart:289`** — same.

6. **`lib/screens/firewall_rules_screen.dart:98`** — `await Future.delayed(const Duration(milliseconds: 1500))`:
   a debounce delay before confirming a toggle. Add
   `AppConstants.toggleDebounceDelay = Duration(milliseconds: 1500)` and use it.

7. **`lib/widgets/app_drawer.dart:222`** — `await Future.delayed(const Duration(milliseconds: 150))`:
   drawer close animation grace period. Add
   `AppConstants.drawerCloseDelay = Duration(milliseconds: 150)` and use it.

**Evidence:**
- `wireguard_peers_view_model.dart:37` — `rowCount: 1000 // Get all peers`
- `openvpn_instances_view_model.dart:56` — `rowCount == -1 ? 9999 : rowCount`
- `openvpn_static_keys_view_model.dart:40` — same pattern
- `neighbor_discovery_screen.dart:228` — `value: 9999`
- `openvpn_client_overrides_list_screen.dart:289` — `value: 9999`
- `firewall_rules_screen.dart:98` — `Duration(milliseconds: 1500)`
- `app_drawer.dart:222` — `Duration(milliseconds: 150)`

**Expected Outcomes:**
- `AppConstants` gains:
  ```dart
  static const int maxPeerRowCount   = 1000;
  static const int allRowsSentinel   = 9999;
  static const Duration toggleDebounceDelay = Duration(milliseconds: 1500);
  static const Duration drawerCloseDelay    = Duration(milliseconds: 150);
  ```
- All seven call sites updated to reference the named constants
- `flutter analyze` passes

**Todo List:**
1. Open `lib/utils/constants.dart`; add the four new constants to `AppConstants`
2. Open `lib/viewmodels/wireguard_peers_view_model.dart`; replace `1000` with
   `AppConstants.maxPeerRowCount`
3. Open `lib/viewmodels/openvpn_instances_view_model.dart`; replace `9999` with
   `AppConstants.allRowsSentinel`
4. Open `lib/viewmodels/openvpn_static_keys_view_model.dart`; replace `9999`
5. Open `lib/screens/neighbor_discovery_screen.dart`; replace `9999`
6. Open `lib/screens/openvpn_client_overrides_list_screen.dart`; replace `9999`
7. Open `lib/screens/firewall_rules_screen.dart`; replace `Duration(milliseconds: 1500)`
   with `AppConstants.toggleDebounceDelay`
8. Open `lib/widgets/app_drawer.dart`; replace `Duration(milliseconds: 150)` with
   `AppConstants.drawerCloseDelay`
9. Run `flutter analyze`

**Relevant Context:**
- `lib/utils/constants.dart:22-71`
- All seven files listed above

---

## Phase F — Final Verification

### Sub-Task F.1 — Final Codebase Analysis Pass (Phase 4)
**Status:** [ ] pending

**Intent:**
After all Phase A–E sub-tasks are complete, run a full-project analysis to confirm
all targeted patterns have been resolved and no regressions introduced.

**Expected Outcomes:**
- `flutter analyze` reports zero errors and zero warnings
- `grep -rn "Colors\.\(red\|green\|orange\|grey\|blue\)\b" lib/widgets/` — zero matches
  (except theme-aware uses such as `Colors.red` in `TextStyle.color` passed to
  `Theme.of(context)` — these are permissible if they are genuinely dynamic)
- `grep -rn "= 'Confirm'\|= 'Cancel'" lib/` — zero matches
- `grep -rn "catch (_)" lib/` — zero matches (all replaced with typed or named catches)
- `grep -rn "9999\|rowCount: 1000" lib/viewmodels/` — zero matches
- `grep -rn "Duration(milliseconds: 1500)\|Duration(milliseconds: 150)" lib/` — zero matches
- All hardcoded English widget strings identified in Phase C replaced with l10n keys
- `flutter test` — all existing tests pass
- `flutter build apk --release` — clean release build

**Todo List:**
1. Run `flutter analyze` — resolve any remaining issues
2. Run each grep check listed in Expected Outcomes above
3. Run `flutter test`
4. Run `flutter build apk --release`

---

## Appendix: Net-New Issue Registry (Phase 4 Audit)

All items were identified by direct code read after Phases 1, 2, and 3 were fully
executed. None appear in any prior plan.

| ID | Sev | Category | Description | File | Sub-Task |
|----|-----|----------|-------------|------|----------|
| A1 | MED | Code Quality | `ConfirmationDialog` has hardcoded default strings `'Confirm'` / `'Cancel'` breaking l10n | `confirmation_dialog.dart:14-15` | A.1 |
| A2 | MED | Duplication | 5 screens construct raw inline `AlertDialog` for yes/no confirmations that should use `ConfirmationDialog` | Multiple screens | A.2 |
| B1 | LOW | Code Quality | `AppColors` missing semantic constants for grey scale, online/offline, info blue | `constants.dart:74-84` | B.1 |
| B2 | MED | Code Quality | 25+ inline `Colors.*` usages in widget files bypass `AppColors` convention | `lib/widgets/` (multiple) | B.2 |
| B3 | MED | Code Quality | 30+ inline `Colors.*` usages in screen files bypass `AppColors` convention | `lib/screens/` (multiple) | B.3 |
| C1 | HIGH | i18n | `ServiceControlsCard` has 4 hardcoded English UI strings with no l10n | `service_controls_card.dart:43-78` | C.1 |
| C2 | HIGH | i18n | `StatusCard` has 10 hardcoded English row labels with no l10n | `status_card.dart:87-168` | C.2 |
| C3 | HIGH | i18n | `WireGuardLogDetailSheet` has 10 hardcoded English row/section labels | `wireguard_log_detail_sheet.dart:124-193` | C.3 |
| C4 | MED | i18n | 2 widget files use `'Today'`, `'Yesterday'`, `'None'` hardcoded | `openvpn_static_key_card.dart:164,166`; `routing_settings_card.dart:79` | C.4 |
| D1 | MED | Error Handling | 3 service/VM `catch (_)` blocks discard actionable exceptions silently | `firewall_service.dart:52,65`; `system_service.dart:375`; `wireguard_server_form_view_model.dart:72` | D.1 |
| D2 | MED | Error Handling | 5 model/screen `catch (_)` blocks too broad; should use targeted exception types | `openvpn_instance.dart:571,591`; `profile.dart:64,125`; `wireguard_log_file_screen.dart:276`; `openvpn_client_override.dart:183` | D.2 |
| D3 | LOW | Error Handling | `AppDrawer._fetchSystemInfo()` `catch (_)` swallows errors with no debug visibility | `app_drawer.dart:99` | D.3 |
| E1 | LOW | Code Quality | 7 magic numbers and inline delays need named constants | Multiple files | E.1 |
