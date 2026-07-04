# OPNsense Manager — Flutter Refactor Plan (v1.8.0)

## Overview

A systematic, incremental refactoring of the OPNsense Manager Flutter codebase
targeting four outcomes: (1) eliminate all identified duplicate/boilerplate patterns,
(2) remove dead dependencies and unused code, (3) raise the codebase to a consistently
idiomatic Flutter/Dart standard, and (4) consolidate all validator duplication and
harden widget-layer localisation coverage.

**Scope:** All Dart files under `lib/`, `pubspec.yaml`, and `analysis_options.yaml`.
**State management baseline:** Provider + ChangeNotifier (keep existing architecture).
**Approach:** Each sub-task is independently verifiable and scoped to a single concern
so regressions are isolated. Sub-tasks within the same phase may be executed in parallel
but phases must be completed in order.

---

## Phase 1 — Dead Code & Dependency Elimination

### Sub-Task 1.1 — Remove Unused pubspec.yaml Dependencies
**Status:** [x] done

**Intent:**
Five packages are declared in `pubspec.yaml` but have zero import statements anywhere
in `lib/`. Removing them reduces binary size, eliminates future upgrade noise, and
removes false signals about what the app uses.

**Evidence (verified by grep across all lib/ files — zero matches for each):**
- `fl_chart: ^1.1.1` — declared under `# Charts`, never imported
- `path: ^1.9.0` — declared under `# Utilities`, never imported
- `path_provider: ^2.1.5` — declared under `# Path Provider`, never imported
- `share_plus: ^13.1.0` — declared under `# Share files`, never imported
- `url_launcher: ^6.2.2` — declared under `# URL Launcher`, never imported

**Expected Outcomes:**
- `pubspec.yaml` has exactly five fewer entries under `dependencies`
- `flutter pub get` runs cleanly after removal
- `flutter analyze` reports no new errors

**Todo List:**
1. Open `pubspec.yaml`
2. Delete the line `fl_chart: ^1.1.1` and its comment `# Charts`
3. Delete the line `path: ^1.9.0` (part of `# Utilities` block)
4. Delete the line `path_provider: ^2.1.5` and its comment `# Path Provider for file operations`
5. Delete the line `share_plus: ^13.1.0` and its comment `# Share files for WireGuard config export`
6. Delete the line `url_launcher: ^6.2.2` and its comment `# URL Launcher for opening authentication URLs`
7. Run `flutter pub get` to regenerate `pubspec.lock`
8. Run `flutter analyze` to confirm clean analysis

**Relevant Context:**
- `pubspec.yaml` lines 30, 41, 50, 56, 59

---

### Sub-Task 1.2 — Remove Unused Assets
**Status:** [x] done

**Intent:**
Two SVG files under `assets/getiton/` are present in the repository but are never
referenced anywhere in `lib/`. They add unnecessary repo weight and are not declared
in the `flutter.assets` section of `pubspec.yaml`. Safe to delete.

**Evidence (verified by grep across all lib/ files — zero matches):**
- `assets/getiton/F-Droid.svg` — no reference found in any Dart file
- `assets/getiton/GooglePlayStore.svg` — no reference found in any Dart file

**Expected Outcomes:**
- Both SVG files deleted from the repository
- `assets/getiton/` directory removed
- `flutter analyze` and `flutter build` continue to pass

**Todo List:**
1. Delete `assets/getiton/F-Droid.svg`
2. Delete `assets/getiton/GooglePlayStore.svg`
3. Remove the now-empty `assets/getiton/` directory
4. Confirm `pubspec.yaml` does not reference `assets/getiton/` (it currently only declares `assets/images/`)
5. Run `flutter analyze` to confirm no breakage

---

### Sub-Task 1.3 — Remove Unused Import in `firewall_logs_screen.dart`
**Status:** [x] done (skipped — import is not unused)

**Intent:**
`lib/screens/firewall_logs_screen.dart` line 22 imports `package:flutter/services.dart`
but no symbol from that package is referenced in the file body. Dead imports increase
compile noise and mislead readers about file dependencies.

**Evidence:**
- `lib/screens/firewall_logs_screen.dart:22` — `import 'package:flutter/services.dart';`
- Grep for `SystemChannels`, `Clipboard`, `HapticFeedback`, `RawKeyboard` in the file body: zero matches

**Investigation Result (executed):**
The plan's evidence was incorrect. `Clipboard.setData(ClipboardData(...))` is used at
line 230 inside `_copySelectedLogs()`. The import is **required** — removing it would
break compilation. No change was made to the source file. The debt entry D8 in the
tracker table should be removed.

**Expected Outcomes:**
- Line 22 deleted from `firewall_logs_screen.dart`
- `flutter analyze` reports no new errors

**Todo List:**
1. Open `lib/screens/firewall_logs_screen.dart`
2. Delete line 22: `import 'package:flutter/services.dart';`
3. Run `flutter analyze`

---

### Sub-Task 1.4 — Replace Inline Error/Empty State Widget Builders with Shared Widgets
**Status:** [x] done

**Intent:**
Every list screen contains two private builder methods — `_buildErrorState()` and
`_buildEmptyState()` — that manually construct identical widget layouts. Shared widgets
already exist in `lib/widgets/common/` for both cases but are currently unused in screens.
Replacing all private methods with these shared widgets eliminates ~700 lines of repeated
widget code and guarantees visual consistency.

**`_buildErrorState()` pattern (verified in 15 screens):**
`Center > Column > [Icon(error_outline, 64px, red), SizedBox(16), Text title, SizedBox(8), Text message, SizedBox(24), ElevatedButton.icon(Retry)]`
Already implemented by `lib/widgets/common/error_display.dart` — accepts `message` + `onRetry`.

**`_buildEmptyState()` pattern (verified in 11 screens):**
`Center > Column > [Icon(64px, grey[400]), SizedBox(16), Text title, SizedBox(8), Text subtitle]`
No shared widget exists yet — must be created as `lib/widgets/common/empty_state_widget.dart`.

**Screens with `_buildErrorState()` (15 total):**
`firewall_rules_screen.dart` (lines 350–376), `wireguard_servers_screen.dart`,
`firewall_aliases_screen.dart`, `dhcp_leases_screen.dart`, `neighbor_discovery_screen.dart`,
`live_network_monitor_screen.dart`, `openvpn_instances_list_screen.dart`,
`openvpn_client_overrides_list_screen.dart`, `openvpn_static_keys_list_screen.dart`,
`tailscale_status_screen.dart`, `vpn_connections_screen.dart`, `wol_screen.dart`,
`system_info_screen.dart`, `wireguard_log_file_screen.dart`, `openvpn_log_file_screen.dart`

**Screens with `_buildEmptyState()` (11 total):**
`wireguard_servers_screen.dart`, `firewall_aliases_screen.dart`, `dhcp_leases_screen.dart`,
`neighbor_discovery_screen.dart`, `openvpn_instances_list_screen.dart`,
`openvpn_client_overrides_list_screen.dart`, `openvpn_static_keys_list_screen.dart`,
`wol_screen.dart`, `live_network_monitor_screen.dart`, `vpn_connections_screen.dart`,
`tailscale_status_screen.dart`

**Expected Outcomes:**
- `lib/widgets/common/empty_state_widget.dart` created with signature:
  `const EmptyStateWidget({required IconData icon, required String title, String? subtitle, Widget? action})`
- All 15 `_buildErrorState()` methods removed; call-sites replaced with `ErrorDisplay(message: _errorMessage!, onRetry: _loadXxx)`
- All 11 `_buildEmptyState()` methods removed; call-sites replaced with `EmptyStateWidget(icon: ..., title: ..., subtitle: ...)`
- Import `'../widgets/common/error_display.dart'` and `'../widgets/common/empty_state_widget.dart'` added where needed

**Todo List:**
1. Create `lib/widgets/common/empty_state_widget.dart`
2. For each of the 15 screens with `_buildErrorState()`:
   a. Add import for `ErrorDisplay`
   b. Replace `_buildErrorState()` call-site with `ErrorDisplay(message: _errorMessage!, onRetry: _loadXxx)`
   c. Delete the `_buildErrorState()` method body
3. For each of the 11 screens with `_buildEmptyState()`:
   a. Add import for `EmptyStateWidget`
   b. Replace `_buildEmptyState()` call-site with `EmptyStateWidget(icon: ..., title: ..., subtitle: ...)`
   c. Delete the `_buildEmptyState()` method body
4. Run `flutter analyze`

**Relevant Context:**
- `lib/widgets/common/error_display.dart` — `message` (required String), `onRetry` (optional VoidCallback)
- `firewall_rules_screen.dart` lines 350–398 — canonical example of both patterns

---

## Phase 2 — Consolidation of Boilerplate Patterns

### Sub-Task 2.1 — Introduce `SnackBarHelper` Utility
**Status:** [x] done

**Intent:**
`ScaffoldMessenger.of(context).showSnackBar(SnackBar(...))` is written verbatim across
32 screen files (175+ call sites). The variants are: success (green, 2s), error (red, 3s),
warning (orange, 2s), and neutral (no color, 2s). A small static utility class removes
~300 lines of repetition, centralises SnackBar durations, and makes future theming changes
a single-point edit.

**Evidence:**
- `ScaffoldMessenger.of(context).showSnackBar` found in 32 files (grep confirmed)
- Inline color patterns: `backgroundColor: Colors.green`, `Colors.red`, `Colors.orange`, no color

**Expected Outcomes:**
- New file `lib/utils/snackbar_helper.dart` with `SnackBarHelper` static class
- Four static methods:
  - `showSuccess(BuildContext context, String message, {Duration duration = const Duration(seconds: 2)})`
  - `showError(BuildContext context, String message, {Duration duration = const Duration(seconds: 3)})`
  - `showWarning(BuildContext context, String message, {Duration duration = const Duration(seconds: 2)})`
  - `showInfo(BuildContext context, String message, {Duration duration = const Duration(seconds: 2)})`
- All 32 screen files updated to call `SnackBarHelper` instead of inline construction
- Colors sourced from `AppColors` constants — not inline `Colors.X`
- Duration defaults match the existing ad-hoc durations in the codebase

**Todo List:**
1. Create `lib/utils/snackbar_helper.dart` with the `SnackBarHelper` class
2. Implement four static methods using `AppColors.success`, `AppColors.error`, `AppColors.warning`
3. For each of the 32 screen files:
   a. Add import `'../utils/snackbar_helper.dart'`
   b. Replace each green SnackBar with `SnackBarHelper.showSuccess(context, message)`
   c. Replace each red SnackBar with `SnackBarHelper.showError(context, message)`
   d. Replace each orange SnackBar with `SnackBarHelper.showWarning(context, message)`
   e. Replace each colorless SnackBar with `SnackBarHelper.showInfo(context, message)`
4. Run `flutter analyze`

**Relevant Context:**
- `lib/utils/constants.dart` — `AppColors.success`, `AppColors.error`, `AppColors.warning` already defined
- Highest-density files: `firewall_rules_screen.dart` (6 calls), `wireguard_servers_screen.dart` (4 calls)
- Also covers widget files that show SnackBars: `connection_endpoints_manager.dart`,
  `system_navigation_section.dart`

---

### Sub-Task 2.2 — Migrate Inline AlertDialog Confirmations to `ConfirmationDialog.show()`
**Status:** [x] done

**Intent:**
19 screen files contain raw `showDialog<bool>(builder: (ctx) => AlertDialog(...))` blocks
for delete/toggle confirmations. `ConfirmationDialog.show()` already exists in
`lib/widgets/common/confirmation_dialog.dart` with `isDestructive` styling support but
zero screens currently use it. Migrating all confirmation dialogs eliminates ~400 lines of
duplicate AlertDialog boilerplate and standardises confirmation UX.

**Evidence — 19 files with raw AlertDialog confirmations (grep confirmed):**
`wireguard_servers_screen.dart`, `tailscale_subnets_screen.dart`, `openvpn_log_file_screen.dart`,
`dhcp_leases_screen.dart`, `system_info_screen.dart`, `firewall_logs_screen.dart`,
`tailscale_authentication_screen.dart`, `neighbor_discovery_screen.dart`,
`live_network_monitor_screen.dart`, `firewall_rules_screen.dart`, `tailscale_status_screen.dart`,
`wireguard_log_file_screen.dart`, `dashboard_screen.dart`, `vpn/vpn_connections_list_screen.dart`,
`vpn/tailscale_status_screen.dart`, `wol_screen.dart`, `firewall_aliases_screen.dart`,
`vpn_connections_screen.dart`, `settings/profile_management_screen.dart`

**Expected Outcomes:**
- All inline `showDialog(builder: (ctx) => AlertDialog(...))` confirmation patterns replaced with
  `await ConfirmationDialog.show(context: context, title: ..., message: ..., confirmText: ..., isDestructive: ...)`
- Import `'../widgets/common/confirmation_dialog.dart'` added to each migrated screen
- Destructive actions (delete, stop, disconnect) pass `isDestructive: true`
- Non-destructive (enable/disable/restart) pass `isDestructive: false`

**Todo List:**
1. For each of the 19 screens:
   a. Add import for `ConfirmationDialog`
   b. Identify every `showDialog<bool>(...AlertDialog...)` block in the file
   c. Replace with `await ConfirmationDialog.show(context: context, title: ..., message: ..., confirmText: ..., cancelText: ..., isDestructive: ...)`
   d. Remove the inlined AlertDialog builder entirely
2. `firewall_rules_screen.dart` toggle dialog uses orange/green styling — map to `isDestructive: false`
3. Run `flutter analyze`

**Relevant Context:**
- `lib/widgets/common/confirmation_dialog.dart` lines 19–38 — `ConfirmationDialog.show()` returns
  `Future<bool>` (defaults to `false` on dismiss, never null)
- `isDestructive: true` applies `Theme.of(context).colorScheme.error` on the confirm button

---

## Phase 3 — Screens Not Yet Using BaseListViewModel

### Sub-Task 3.1 — Migrate All Remaining List Screens to `BaseListViewModel`
**Status:** [ ] pending

**Intent:**
`BaseListViewModel<T>` fully encapsulates `_isLoading`, `_errorMessage`, `_items`,
`_filteredItems`, search filtering, and the `loadItems()` try/catch lifecycle. Only the
WireGuard peers/status screens currently use it. The remaining 22 list screens duplicate
this entire pattern via raw `StatefulWidget` state. Migrating them eliminates the largest
single source of duplication in the project.

**Screens NOT yet using BaseListViewModel (identified from `bool _isLoading` grep — 22 screens):**
`wireguard_servers_screen.dart`, `wireguard_log_file_screen.dart`, `vpn_connections_screen.dart`,
`vpn/vpn_connections_list_screen.dart`, `vpn/tailscale_status_screen.dart`,
`tailscale_subnets_screen.dart`, `tailscale_status_screen.dart`, `tailscale_authentication_screen.dart`,
`openvpn_static_keys_list_screen.dart`, `openvpn_log_file_screen.dart`,
`openvpn_instances_list_screen.dart`, `openvpn_client_overrides_list_screen.dart`,
`neighbor_discovery_screen.dart`, `wol_screen.dart`, `system_info_screen.dart`,
`settings/profile_management_screen.dart`, `live_network_monitor_screen.dart`,
`firewall_rules_screen.dart`, `firewall_logs_screen.dart`, `firewall_aliases_screen.dart`,
`dhcp_leases_screen.dart`, `dashboard_screen.dart`

**Approach:** Migrate in groups of related screens so each group is independently testable.

**Expected Outcomes:**
- Each migrated screen has a ViewModel class in `lib/viewmodels/` extending `BaseListViewModel<T>`
- Screens remove `bool _isLoading`, `String? _errorMessage`, and the `_loadXxx()` boilerplate
- `_buildBody()` reads `viewModel.isLoading`, `viewModel.errorMessage`, `viewModel.items`
- `_loadSystemInfo()` duplication (12 screens) resolved via a shared `SystemInfoProvider`

**Todo List:**

**Group A — Firewall screens (3 screens):**
1. Create `lib/viewmodels/firewall_rules_view_model.dart` extending `BaseListViewModel<FirewallRule>`
2. Implement `fetchItems()` calling `demoApiService.getFirewallRules()`
3. Move interface-grouping logic (`FirewallRuleFilter`) into the ViewModel
4. Refactor `FirewallRulesScreen` to consume `FirewallRulesViewModel`
5. Create `FirewallAliasesViewModel` → refactor `firewall_aliases_screen.dart`
6. Create `FirewallLogsViewModel` → refactor `firewall_logs_screen.dart`

**Group B — WireGuard screens (2 screens):**
7. Create `lib/viewmodels/wireguard_servers_view_model.dart` extending `BaseListViewModel<WireGuardServer>`
8. Move `_togglingServers` Set and `toggleServer()` / `deleteServer()` into the ViewModel
9. Refactor `WireGuardServersScreen` to consume the ViewModel
10. Create `WireGuardLogViewModel` → refactor `wireguard_log_file_screen.dart`

**Group C — OpenVPN screens (4 screens):**
11. Create `OpenVpnInstancesViewModel`, `OpenVpnClientOverridesViewModel`,
    `OpenVpnStaticKeysViewModel`, `OpenVpnLogViewModel`
12. Refactor the four corresponding screens

**Group D — VPN/Tailscale screens (4 screens):**
13. Create `VpnConnectionsViewModel`, `TailscaleStatusViewModel`,
    `TailscaleSubnetsViewModel`, `TailscaleAuthViewModel`
14. Refactor the four corresponding screens

**Group E — Network/System screens (5 screens):**
15. Create `NeighborDiscoveryViewModel`, `DhcpLeasesViewModel`,
    `LiveNetworkMonitorViewModel`, `SystemInfoViewModel`, `WolViewModel`
16. Refactor the five corresponding screens

**Group F — Dashboard & Settings (2 screens):**
17. Create `DashboardViewModel`, `ProfileManagementViewModel`
18. Refactor `dashboard_screen.dart` and `settings/profile_management_screen.dart`

**Resolve `_loadSystemInfo()` duplication (12 screens affected):**
19. Remove `_loadSystemInfo()` from all migrated screens
20. Create `lib/services/system/system_info_provider.dart` — a `ChangeNotifier` that holds
    `SystemInfo?` and fetches it once on init
21. Register `SystemInfoProvider` via `ChangeNotifierProvider` in `main.dart`
22. Update `AppDrawer` to read `SystemInfo?` from the Provider instead of receiving it as a parameter

**Relevant Context:**
- `lib/viewmodels/base/base_list_view_model.dart` — canonical base class
- `lib/viewmodels/wireguard_peers_view_model.dart` — reference ViewModel implementation
- `lib/screens/wireguard_peers_screen.dart` — reference screen implementation using a ViewModel

---

### Sub-Task 3.2 — Migrate Form Screens to `BaseFormViewModel`
**Status:** [ ] pending

**Intent:**
`BaseFormViewModel` provides `isLoading`, `errorMessage`, `hasUnsavedChanges`, and
`executeWithLoading()`. Four form screens duplicate all save/submit try-catch boilerplate
manually. Migrating them removes this duplication.

**Form screens not yet using BaseFormViewModel:**
`firewall_rule_form_screen.dart`, `openvpn_instance_form_screen.dart`,
`openvpn_client_override_form_screen.dart`, `openvpn_static_key_form_screen.dart`

**Expected Outcomes:**
- Each form screen has a ViewModel extending `BaseFormViewModel`
- Save/submit calls `viewModel.executeWithLoading(() => apiService.save(...))`
- Loading spinner and error message driven from ViewModel state, not raw `setState`

**Todo List:**
1. Create `lib/viewmodels/firewall_rule_form_view_model.dart` extending `BaseFormViewModel`
2. Move form initialisation, validation, and submit logic into the ViewModel
3. Refactor `FirewallRuleFormScreen` to consume the ViewModel
4. Create `OpenVpnInstanceFormViewModel` → refactor `openvpn_instance_form_screen.dart`
5. Create `OpenVpnClientOverrideFormViewModel` → refactor `openvpn_client_override_form_screen.dart`
6. Create `OpenVpnStaticKeyFormViewModel` → refactor `openvpn_static_key_form_screen.dart`

**Relevant Context:**
- `lib/viewmodels/base/base_form_view_model.dart` — `executeWithLoading<T>()`
- `lib/viewmodels/wireguard_server_form_view_model.dart` — reference form ViewModel

---

## Phase 4 — Validator Consolidation

### Sub-Task 4.1 — Consolidate Duplicate Validator Logic into a Unified Module
**Status:** [ ] pending

**Intent:**
IP/CIDR/port validation logic is independently implemented in three separate files:
`validators.dart`, `common_validators.dart`, and `wireguard_validators.dart`. Each uses
a different regex pattern or different error message conventions, making them inconsistent
and a maintenance burden. A single `NetworkValidators` utility consolidates all low-level
network validation primitives that all three files can then delegate to.

**Evidence of duplication (all three files read and verified):**

| Logic | `validators.dart` | `common_validators.dart` | `wireguard_validators.dart` |
|---|---|---|---|
| `isValidIPv4` | line 26 — manual octet parsing | line 9 — regex `25[0-5]\|2[0-4]...` | line 98 — manual octet parsing |
| `isValidCIDR` | line 64 — IPv4 only | line 22 — IPv4 only, delegates to `ipAddress()` | line 65 — IPv4 + IPv6 |
| Port range | line 57 (bool) | line 41 (String? validator) | line 144 (in `validateEndpoint`) |

`common_validators.dart` — entirely hardcoded English error strings with no localisation.
`wireguard_validators.dart` — entirely hardcoded English error strings with no localisation.
`validators.dart` — localised via `AppLocalizations` but has optional `BuildContext` fallback
anti-pattern (lines 188–298) that allows silent non-localised errors to surface in production.

**Expected Outcomes:**
- New file `lib/utils/network_validators.dart` created with `NetworkValidators` class
- `NetworkValidators` contains the canonical implementations:
  - `static bool isValidIPv4(String ip)` — manual octet parsing (most accurate, no regex)
  - `static bool isValidIPv6(String ip)` — from `wireguard_validators.dart:112`
  - `static bool isValidCIDR(String cidr, {bool allowIPv6 = false})` — unified, handles both families
  - `static bool isValidIPOrCIDR(String value)` — from `wireguard_validators.dart:87`
  - `static bool isValidPort(String port)` — from `validators.dart:58`
  - `static bool isValidPortRange(String portRange)` — from `validators.dart:84`
  - `static bool isValidHostname(String hostname)` — from `validators.dart:43`
  - `static bool isValidMacAddress(String mac)` — from `validators.dart:164`
- `validators.dart` static bool methods delegate to `NetworkValidators`
- `common_validators.dart` static bool methods delegate to `NetworkValidators`
- `wireguard_validators.dart` static bool methods delegate to `NetworkValidators`
- Optional `BuildContext` parameters removed from `validators.dart` — `BuildContext` made required
  on all `validateXxx()` methods so localisation is never silently bypassed
- `validateMacAddress()` in `validators.dart` (lines 283–298) updated to use `AppLocalizations`
  instead of hardcoded English strings

**Todo List:**
1. Create `lib/utils/network_validators.dart` with the `NetworkValidators` class
2. Implement `isValidIPv4`, `isValidIPv6`, `isValidCIDR`, `isValidIPOrCIDR`, `isValidPort`,
   `isValidPortRange`, `isValidHostname`, `isValidMacAddress` using the most correct
   implementation from the three existing files
3. In `lib/utils/validators.dart`:
   a. Replace `isValidIPv4`, `isValidCIDR`, `isValidPort`, `isValidPortRange`, `isValidHostname`,
      `isValidMacAddress` bodies with delegating calls to `NetworkValidators`
   b. Remove the `[BuildContext? context]` optional parameter from `validateHost`, `validatePort`,
      `validateApiKey`, `validateApiSecret`, `validateRequired`, `validateMacAddress` — make
      `BuildContext context` a required positional parameter
   c. Delete the `if (context == null) { return 'Required'; }` fallback branches (lines 190–193,
      210–213, 231–234, 251–254, 270–272, 285–288)
   d. Add `AppLocalizations` usage to `validateMacAddress` (currently returns hardcoded English
      strings even when context is provided — lines 291–296)
4. In `lib/utils/common_validators.dart`:
   a. Replace `ipAddress()`, `cidr()`, `port()` bodies with delegating calls to `NetworkValidators`
   b. Keep the `String?` return signature unchanged (these are form field validators)
5. In `lib/utils/wireguard_validators.dart`:
   a. Replace `isValidIPv4`, `isValidIPv6`, `isValidCIDR`, `isValidIPOrCIDR` bodies with
      delegating calls to `NetworkValidators`
   b. Keep WireGuard-specific validators (`validateKey`, `validateOptionalKey`, `validateAllowedIPs`,
      `validateEndpoint`, `validateKeepalive`, `validateMTU`) unchanged — these are not duplicated
6. Update all call sites of `Validators.validateHost(value)` (no context) to pass context:
   - `lib/widgets/login/connection_fields_section.dart`
   - `lib/widgets/login/credentials_fields_section.dart`
   - `lib/widgets/login/connection_endpoints_manager.dart`
   - `lib/screens/wireguard_server_form_screen.dart`
   - `lib/screens/wireguard_peer_form_screen.dart`
   - `lib/screens/firewall_rule_form_screen.dart`
   - `lib/screens/wol_screen.dart`
   - `lib/screens/settings/profile_management_screen.dart`
7. Run `flutter analyze` — no errors expected

**Relevant Context:**
- `lib/utils/validators.dart` — primary validator file, 300 lines, uses `AppLocalizations`
- `lib/utils/common_validators.dart` — 90 lines, no localisation, used by 6 files
- `lib/utils/wireguard_validators.dart` — 165 lines, no localisation, used by 3 files

---

## Phase 5 — Hardcoded Strings & Inline Color Remediation

### Sub-Task 5.1 — Localise Hardcoded English Strings in Widget Files
**Status:** [ ] pending

**Intent:**
Multiple widget files contain hardcoded English strings in `Text()` widgets that bypass
`AppLocalizations`. Since the app supports 6 languages (en, ar, es, fr, de), every
user-visible string must go through the localisation system. The strings fall into two
categories: repeated action labels ('Delete', 'Cancel', 'Done') and domain-specific labels
('Server', 'Client', 'Actual Used', 'ARC Cache').

**Evidence — exact locations of hardcoded strings (verified by file reads):**

Action labels in widget PopupMenuItems:
- `lib/widgets/wireguard/peer_card.dart:129` — `Text('Delete', style: TextStyle(color: Colors.red))`
- `lib/widgets/openvpn/openvpn_instance_card.dart:147` — `Text('Delete', style: TextStyle(color: Colors.red))`
- `lib/widgets/openvpn/openvpn_client_override_card.dart:154` — `Text('Delete', style: TextStyle(color: Colors.red))`
- `lib/widgets/openvpn/openvpn_static_key_card.dart:120` — `Text('Delete', style: TextStyle(color: Colors.red))`
- `lib/widgets/wireguard/list_manager_card.dart:131` — `const Text('Cancel')`
- `lib/widgets/wireguard/list_manager_card.dart:149` — `const Text('Add')`
- `lib/widgets/wireguard/peer_selector_dialog.dart:98` — `const Text('Cancel')`
- `lib/widgets/wireguard/peer_selector_dialog.dart:102` — `const Text('Done')`
- `lib/widgets/tailscale/routing_settings_card.dart:126` — `const Text('Cancel')`
- `lib/widgets/openvpn/openvpn_form_field_widgets.dart:387` — `const Text('Cancel')`
- `lib/widgets/openvpn/openvpn_form_field_widgets.dart:394` — `const Text('Done')`
- `lib/widgets/openvpn/openvpn_form_field_widgets.dart:490` — `const Text('Add')`
- `lib/widgets/common/error_display.dart:37` — `const Text('Retry')`

Domain labels in widgets:
- `lib/widgets/openvpn/openvpn_instance_card.dart:163` — `final label = isServer ? 'Server' : 'Client'`
- `lib/widgets/dashboard/resource_usage_section.dart:77` — `primaryLabel: 'Actual Used'`
- `lib/widgets/dashboard/resource_usage_section.dart:80` — `secondaryLabel: ... 'ARC Cache'`

Hardcoded strings in screens:
- `lib/screens/dashboard_screen.dart:248` — `'Demo Mode - Showing sample data'`

**Expected Outcomes:**
- All hardcoded English strings in widget files replaced with `AppLocalizations.of(context)!` lookups
- `AppLocalizations` import added to each affected widget file
- New ARB keys added to `lib/l10n/app_en.arb` for any strings not already covered:
  `delete`, `cancel`, `done`, `add`, `retry`, `server`, `client`, `actualUsed`, `arcCache`, `demoModeIndicator`
- All five language ARB files updated with the new keys

**Todo List:**
1. Check `lib/l10n/app_en.arb` — identify which of the target keys already exist
2. Add any missing keys to all six ARB files (`app_en.arb`, `app_ar.arb`, `app_es.arb`, `app_fr.arb`, `app_de.arb`)
3. Run `flutter gen-l10n` (or `flutter pub run build_runner build`) to regenerate localisation classes
4. For each widget file listed in Evidence:
   a. Add `import '../../l10n/app_localizations.dart';` (adjust path depth as needed)
   b. Inside `build()`, resolve `final l10n = AppLocalizations.of(context)!;`
   c. Replace each hardcoded string with the corresponding `l10n.xxx` call
5. For `error_display.dart`: replace `const Text('Retry')` with `Text(l10n.retry)` (removes `const`)
6. For `openvpn_instance_card.dart`: replace `'Server'` and `'Client'` with `l10n.server` and `l10n.client`
7. For `resource_usage_section.dart`: replace `'Actual Used'` and `'ARC Cache'` with localised equivalents
8. For `dashboard_screen.dart:248`: replace hardcoded demo mode string with `l10n.demoModeIndicator`
9. Run `flutter analyze`

**Relevant Context:**
- `lib/l10n/app_en.arb` — primary ARB file; all keys must be added here first
- `lib/l10n/app_localizations.dart` — generated, do not edit manually
- Widgets that receive `BuildContext` in their `build()` method already have access to `AppLocalizations`

---

### Sub-Task 5.2 — Replace Inline `Colors.X` References with `AppColors` and Theme Constants
**Status:** [ ] pending

**Intent:**
300+ inline `Colors.red`, `Colors.green`, `Colors.orange`, `Colors.grey`, `Colors.blue`
references are scattered across 32 screen files and 20+ widget files. These bypass the
app's theme system and `AppColors` constants, making future theme changes (e.g. dark mode
color tuning) require hunting through every file. The fix has two parts: (a) semantic
status colours (enabled/disabled, error/success, warning) must use `AppColors` or
`Theme.of(context).colorScheme`, and (b) SnackBar colours are already resolved by
Sub-Task 2.1 (`SnackBarHelper`).

**Scope — after Sub-Task 2.1 removes SnackBar inline colours, remaining patterns are:**

**Semantic status indicators (enabled = green, disabled = grey):**
- Multiple card widgets: `backgroundColor: peer.isEnabled ? Colors.green : Colors.grey`
  → Replace with `backgroundColor: peer.isEnabled ? AppColors.success : Theme.of(context).disabledColor`
- Files: `peer_card.dart:49`, `openvpn_instance_card.dart:49`, `openvpn_client_override_card.dart:49`,
  `openvpn_static_key_card.dart:47`, `wireguard_servers_screen.dart:389`

**Delete/destructive action colour:**
- PopupMenuItem delete rows: `Colors.red` used for icon and text
  → Replace with `Theme.of(context).colorScheme.error`
- Files: `peer_card.dart:127,129`, `openvpn_instance_card.dart:145,147`,
  `openvpn_client_override_card.dart:152,154`, `openvpn_static_key_card.dart:118,120`,
  `list_manager_card.dart:60`

**Service health indicator (running = green, stopped = red):**
- `lib/widgets/dashboard/services_section.dart:109` — `color: isRunning ? Colors.green : Colors.red`
  → Replace with `AppColors.success` / `AppColors.error`

**Thermal sensor severity colours:**
- `lib/widgets/dashboard/thermal_sensors_section.dart:196–201` — switch returning `Colors.red/orange/green`
  → Replace with `AppColors.error`, `AppColors.warning`, `AppColors.success`

**Log severity colours (repeated in two places):**
- `lib/widgets/wireguard/wireguard_log_card.dart:76–86` — switch returning `Colors.red/orange/blue/grey`
- `lib/widgets/wireguard/wireguard_log_detail_sheet.dart:367–377` — identical switch
  → Extract to a single `_logLevelColor(String level)` free function in a shared location,
    replace both usages with a call to that function

**Firewall log action colour:**
- `lib/widgets/firewall/log_detail_sheet.dart:425–431` — switch returning `Colors.green/red/orange/grey`
  → Replace with `AppColors` semantic constants

**VPN connection status colours (scattered in `tailscale_status_screen.dart`):**
- Lines 294–296: inline conditional `Colors.green` / `Colors.red` / `Colors.grey`
  → Replace with `AppColors.success`, `AppColors.error`, `Theme.of(context).disabledColor`

**Firewall rule form info box (blue tones):**
- `lib/screens/firewall_rule_form_screen.dart:402,410,416,426` and
  `lib/screens/openvpn_static_key_form_screen.dart:386,394,400` — `Colors.blue[50/700/900]`
  → Define `AppColors.infoBackground` and `AppColors.infoText` in `constants.dart`

**Expected Outcomes:**
- `AppColors` in `lib/utils/constants.dart` extended with:
  `static const infoBackground`, `static const infoText`, `static const disabled`
- All semantic status colour uses in card widgets reference `AppColors` or `colorScheme`
- All delete/destructive colour uses reference `Theme.of(context).colorScheme.error`
- Duplicate log-level colour switch extracted to `lib/utils/color_helpers.dart`
- No remaining `Colors.red`, `Colors.green`, `Colors.orange` literals in widget or screen files
  (exception: `Colors.transparent` in `main.dart` system bar config — acceptable)
- `Colors.grey` uses replaced with `Theme.of(context).disabledColor` or appropriate shade from theme

**Todo List:**
1. Extend `AppColors` in `lib/utils/constants.dart` with `infoBackground`, `infoText`, `disabled`
2. Create `lib/utils/color_helpers.dart` with `Color logLevelColor(String level, {required BuildContext context})`
   function consolidating the repeated log-severity switch
3. For each card widget with `Colors.green`/`Colors.grey` enabled/disabled badge:
   replace with `AppColors.success` / `Theme.of(context).disabledColor`
4. For each PopupMenuItem delete row:
   replace `Colors.red` icon and text colour with `Theme.of(context).colorScheme.error`
5. Update `services_section.dart`, `thermal_sensors_section.dart`, `log_detail_sheet.dart`
   to use `AppColors` semantic constants
6. Replace duplicate log-level switches in `wireguard_log_card.dart` and
   `wireguard_log_detail_sheet.dart` with calls to `logLevelColor()`
7. Replace `Colors.blue[50/700/900]` info box colours in `firewall_rule_form_screen.dart`
   and `openvpn_static_key_form_screen.dart` with `AppColors.infoBackground`/`AppColors.infoText`
8. Replace remaining `Colors.green`/`Colors.red`/`Colors.orange`/`Colors.grey` conditionals
   in `tailscale_status_screen.dart`, `vpn/tailscale_status_screen.dart`, `vpn_summary_cards.dart`
9. Run `flutter analyze`

---

## Phase 6 — Service Layer & Form Screen Quality

### Sub-Task 6.1 — Extract API Endpoint Strings into a Constants Class
**Status:** [x] done

**Intent:**
53+ API path strings are hardcoded inline across service files. String literals like
`'/firewall/filter/get'`, `'/core/system/status'`, `'/diagnostics/activity/getActivity'`
are scattered directly in `dio.get()` and `dio.post()` calls. Centralising them in a
single file makes endpoint names searchable, prevents typos, and makes API migration
(e.g. OPNsense version bumps that change an endpoint) a single-file change.

**Evidence — confirmed inline endpoint strings (verified by file reads):**

`lib/services/system/system_service.dart`:
- line 31: `'/core/system/status'`
- line 50: `'/core/firmware/info'`
- line 61: `'/core/firmware/status'`
- line 71: `'/core/system/info'`
- line 88: `'/diagnostics/activity/getActivity'`
- line 106: `'/diagnostics/system/systemDisk'`
- line 117: `'/core/system/systemDisk'`
- line 134: `'/diagnostics/system/systemResources'`
- line 385: `'/diagnostics/system/system_temperature'`
- line 421: `'/core/system/reboot'`

`lib/services/firewall/firewall_service.dart`:
- line 33: `'/firewall/filter/get'`
- line 86: `'/firewall/filter/get'` (duplicate of line 33)
- line 152: `'/firewall/filter/addRule'`
- line 270: `'/firewall/filter/getRule/$uuid'`
- line 332: `'/firewall/filter/setRule/$uuid'`
- line 353: `'/firewall/filter/toggleRule/$uuid'`
- line 371: `'/firewall/filter/delRule/$uuid'`
- line 389: `'/firewall/filter/apply'`
- line 404: `'/diagnostics/firewall/log'`

`lib/services/vpn/vpn_service.dart`:
- line 39: `'/core/service/search'`
- line 97: `'/core/service/search'` (duplicate of line 39)
- line 137: `'/tailscale/service/status'`
- line 294: `'/openvpn/service/searchSessions'`
- line 405: `'/core/service/$action/$id'`
- line 432: `'/tailscale/service/restart'`

And 27+ additional inline strings across `wireguard_service.dart`, `openvpn_service.dart`,
`network_service.dart`, `dhcp_service.dart`, `tailscale_service.dart`.

**Expected Outcomes:**
- New file `lib/constants/api_endpoints.dart` containing `ApiEndpoints` class with
  `static const String` fields for every unique endpoint path
- All service files updated to reference `ApiEndpoints.xxx` instead of inline strings
- Duplicated endpoint strings (e.g. `/core/service/search` appears on lines 39 and 97 of
  `vpn_service.dart`) reduced to a single constant reference
- `flutter analyze` passes with no errors

**Todo List:**
1. Create `lib/constants/api_endpoints.dart` with `ApiEndpoints` static class
2. Enumerate every unique endpoint string found across all service files
3. Name each constant descriptively (e.g. `ApiEndpoints.systemStatus`, `ApiEndpoints.firewallRulesGet`)
4. Replace every inline string in `system_service.dart`, `firewall_service.dart`,
   `vpn_service.dart`, `wireguard_service.dart`, `openvpn_service.dart`,
   `network_service.dart`, `dhcp_service.dart`, `tailscale_service.dart`
5. Run `flutter analyze`

---

### Sub-Task 6.2 — Remove Empty `catch (_)` Blocks in `system_service.dart`
**Status:** [x] done

**Intent:**
`lib/services/system/system_service.dart` contains 5 consecutive empty `catch (_)` blocks
(verified at lines 55–56, 66–67, 76–77, 93–94, 111–112). These silently swallow all
exceptions including network errors, authentication failures, and unexpected API responses.
The intent — trying multiple fallback endpoints — is valid, but silent swallowing makes
debugging impossible and hides real errors from crash reporting. Each catch block should
log the error at debug level before continuing to the next fallback.

**Evidence (verified by file read):**
- `system_service.dart:55` — `catch (_) { // Silently handle error }`
- `system_service.dart:66` — identical
- `system_service.dart:76` — identical
- `system_service.dart:93` — identical
- `system_service.dart:111` — identical

**Expected Outcomes:**
- All 5 empty `catch (_)` blocks replaced with `catch (e) { debugPrint('SystemService fallback: $e'); }`
- The fallback logic (trying multiple endpoints) is preserved unchanged
- `flutter analyze` with `avoid_print: true` does not flag `debugPrint` (it is not `print`)

**Todo List:**
1. Open `lib/services/system/system_service.dart`
2. Replace each `catch (_) { // Silently handle error }` with
   `catch (e) { debugPrint('[SystemService] Endpoint fallback: $e'); }`
3. Run `flutter analyze`

---

### Sub-Task 6.3 — Remove Dead `ApiResponseParser` Utility Class
**Status:** [x] done

**Intent:**
`lib/utils/api_response_parser.dart` defines a 65-line `ApiResponseParser` class with 6
static parsing methods (`parseField`, `parseString`, `parseInt`, `parseBool`, `parseList`,
`parseMap`). A grep across the entire `lib/` directory confirms **zero files import or
reference this class**. It is entirely dead code. The methods it contains are duplicated
by the manually-written `fromJson()` logic in model files. Removing it reduces noise in
`lib/utils/` and eliminates the false impression that a central parsing utility exists.

**Evidence:**
- `grep 'api_response_parser' lib/` — zero matches
- `grep 'ApiResponseParser' lib/` — zero matches (verified)
- `lib/utils/api_response_parser.dart` — 65 lines, standalone file, no dependents

**Expected Outcomes:**
- `lib/utils/api_response_parser.dart` deleted
- No other files modified (nothing imports it)
- `flutter analyze` passes with no errors

**Todo List:**
1. Delete `lib/utils/api_response_parser.dart`
2. Run `flutter analyze` to confirm no breakage

---

### Sub-Task 6.4 — Extract Login Screen Duplicate Validation Logic
**Status:** [x] done

**Intent:**
`lib/screens/login_screen.dart` has a connection-validation block that is copy-pasted
into three separate methods: `_handleTestProfile()`, `_handleSaveProfile()`, and
`_handleSaveAndConnect()`. Each copy checks `_formKey.currentState!.validate()` and
validates that `_connections` is non-empty. Extracting this to a single private method
eliminates the duplication and ensures all three actions apply identical validation.

**Evidence (verified by grep):**
- `login_screen.dart` — same `_formKey.currentState!.validate()` + `_connections.isEmpty`
  check appears in 3 separate methods

**Expected Outcomes:**
- New private method `bool _validateForm()` extracts the shared validation logic
- All three handler methods replaced with a `if (!_validateForm()) return;` guard
- Behaviour identical to current — no logic changed

**Todo List:**
1. Open `lib/screens/login_screen.dart`
2. Identify the exact lines of duplicated validation in all three methods
3. Extract into `bool _validateForm()` that returns `false` (and shows the SnackBar) if invalid
4. Replace the three inline validation blocks with `if (!_validateForm()) return;`
5. Run `flutter analyze`

---

### Sub-Task 6.5 — Localise Remaining Hardcoded Strings in Form Screens
**Status:** [ ] pending

**Intent:**
`lib/screens/openvpn_static_key_form_screen.dart` and
`lib/screens/openvpn_instance_form_screen.dart` contain hardcoded English strings in
`Text()`, `tooltip:`, `message:`, and `validator:` parameters. Both screens import
`AppLocalizations` but leave several UI strings un-localised. These are the last
significant pockets of hardcoded UI strings in screen files (widget file strings are
addressed in Sub-Task 5.1).

**Evidence — exact locations (verified by file read):**

`lib/screens/openvpn_static_key_form_screen.dart`:
- line 249: `'Edit Static Key'` / `'Add Static Key'` — AppBar title
- line 287: `labelText: 'Description'` — form field label
- line 288: `hintText: 'My Static Key'` — form field hint
- line 290: `helperText: 'A descriptive name for this static key'`
- line 302: `labelText: 'Mode'` — dropdown label
- line 304: `helperText: 'Select the key mode...'`
- line 350: `'Generating...'` / `'Generate Key'` — button labels
- line 375: `'Hide key'` / `'Show key'` — icon button tooltips
- line 397: `'Static Key Information'` — info card title
- lines 407–410: Multi-line help text paragraph

`lib/screens/openvpn_instance_form_screen.dart`:
- line 632: `tooltip: _allExpanded ? 'Collapse All' : 'Expand All'` — icon button tooltips
- line 637: `tooltip: 'Save'` — save button tooltip
- line 643: `message: 'Saving instance...'` — loading overlay message
- line 653: `Text('Error loading instance')` — inline error title
- line 659: `const Text('Retry')` — retry button label

**Expected Outcomes:**
- All hardcoded strings replaced with `l10n.xxx` lookups
- New ARB keys added to all 6 language files for any strings not already present
- `AppLocalizations` already imported in both files — no new import needed

**Todo List:**
1. Check `lib/l10n/app_en.arb` for existing keys matching the target strings
2. Add any missing keys to all 6 ARB files, run `flutter gen-l10n`
3. In `openvpn_static_key_form_screen.dart`: replace all 10 hardcoded strings with `l10n.xxx`
4. In `openvpn_instance_form_screen.dart`: replace all 5 hardcoded strings with `l10n.xxx`
5. Also fix `log_detail_sheet.dart:184` (`'Interface'`) and `log_detail_sheet.dart:228`
   (`'Reason'`) — two more hardcoded strings confirmed in widget file reads
6. Run `flutter analyze`

**Relevant Context:**
- `lib/screens/openvpn_static_key_form_screen.dart:244` — `final l10n = AppLocalizations.of(context)!;` already present
- `lib/screens/openvpn_instance_form_screen.dart:619` — `final l10n = AppLocalizations.of(context)!;` already present

---

### Sub-Task 6.6 — Extract Route Name Strings into a `Routes` Constants Class
**Status:** [ ] pending

**Intent:**
Navigation route names (`'dashboard'`, `'system_info'`, `'settings'`, `'firewall_rules'`,
`'switch_profile'`, etc.) are hardcoded string literals passed to `NavigationTile`
`targetRoute:` parameters throughout `app_drawer.dart` and its section widgets. If a route
name changes, every occurrence must be found and updated manually. A `Routes` class with
`static const String` fields makes route names refactorable and searchable.

**Evidence (verified by file read):**
- `lib/widgets/app_drawer.dart:87` — `targetRoute: 'dashboard'`
- `lib/widgets/app_drawer.dart:96` — `targetRoute: 'system_info'`
- `lib/widgets/app_drawer.dart:136` — `targetRoute: 'settings'`
- `lib/widgets/app_drawer.dart:147` — `targetRoute: 'switch_profile'`
- `lib/widgets/app_drawer.dart:64–68` — route prefix strings `'firewall_'`, `'vpn_'`,
  `'wireguard_'`, `'openvpn_'`, `'tailscale_'`
- Additional route strings in drawer section widgets:
  `firewall_navigation_section.dart`, `vpn_navigation_section.dart`,
  `network_navigation_section.dart`, `settings_navigation_section.dart`

**Expected Outcomes:**
- New file `lib/constants/routes.dart` with `Routes` class containing all route name constants
- `app_drawer.dart` and all drawer section widgets updated to use `Routes.dashboard`,
  `Routes.systemInfo`, `Routes.settings`, `Routes.firewallRules`, etc.
- `NavigationService.isRouteInSection()` call sites updated to use `Routes.firewallPrefix`,
  `Routes.vpnPrefix`, etc.

**Todo List:**
1. Read all drawer section files to collect every route name string used:
   `firewall_navigation_section.dart`, `vpn_navigation_section.dart`,
   `network_navigation_section.dart`, `system_navigation_section.dart`,
   `settings_navigation_section.dart`
2. Create `lib/constants/routes.dart` with `Routes` class
3. Define one `static const String` per route name and one per route prefix
4. Replace all inline route strings in `app_drawer.dart` and all drawer section widgets
5. Run `flutter analyze`

---

## Phase 7 — Code Quality & Idiomatic Improvements

### Sub-Task 7.1 — Replace `.then()` Navigation Callbacks with `await`
**Status:** [ ] pending

**Intent:**
Two screen files use `.then((_) => _loadXxx())` on `Navigator.push()` instead of `await`.
The `await` form is more readable, correct for error propagation, and idiomatic Dart async.
Note: after Phase 3 migrations, most occurrences will already be eliminated by ViewModel
refactors. This sub-task handles any remaining cases.

**Evidence (grep confirmed — 2 files before Phase 3):**
- `lib/screens/wireguard_servers_screen.dart` — `.then((_) => _loadServers())`
- `lib/screens/firewall_rules_screen.dart` lines 269, 303 — `.then((_) => _loadRules())`

**Expected Outcomes:**
- All `.then((_) => _loadXxx())` navigation callbacks converted to
  `await Navigator.push(...); if (mounted) _loadXxx();`

**Todo List:**
1. Verify whether Phase 3 already resolved these (screens may be fully migrated to ViewModels)
2. For any remaining occurrences: convert to `await` pattern
3. Run `flutter analyze`

---

### Sub-Task 7.2 — Harden `ErrorDisplay` with Localised Retry Label
**Status:** [ ] pending

**Intent:**
`lib/widgets/common/error_display.dart` line 37 contains the only hardcoded English string
remaining in a shared widget after Sub-Task 5.1 (`const Text('Retry')`). This sub-task is
a dependency of Sub-Task 5.1 — it must be completed as part of that task, but is listed
separately for traceability.

**Note:** This is resolved by Sub-Task 5.1 step 5. Mark this task done when 5.1 is done.

**Expected Outcomes:**
- `ErrorDisplay` uses `AppLocalizations.of(context)!.retry` on the retry button
- No hardcoded English strings remain in any file under `lib/widgets/common/`

**Todo List:**
1. Confirm Sub-Task 5.1 step 5 replaced `const Text('Retry')` with `Text(l10n.retry)`
2. Run `flutter analyze`

---

### Sub-Task 7.3 — Strengthen `analysis_options.yaml` Lint Rules
**Status:** [x] done

**Intent:**
The current `analysis_options.yaml` only inherits `flutter_lints` defaults and has both
meaningful rules commented out. Enabling additional lint rules will catch future violations
automatically — missing const constructors, debug print statements, and inconsistent
trailing commas that introduce unnecessary widget rebuilds.

**Evidence (`analysis_options.yaml` read and verified — current state):**
- Line 24: `# avoid_print: false` — commented out, no value set
- No `prefer_const_constructors` rule
- No `prefer_const_declarations` rule
- No `require_trailing_commas` rule

**Expected Outcomes:**
- `avoid_print: true` enabled — catches any future `print()` statements
- `prefer_const_constructors: true` enabled — catches widgets that could be `const`
- `require_trailing_commas: true` enabled — improves diff readability and reduces rebuilds
- Zero new lint violations from enabling these rules (the codebase currently has no `print()`
  calls in `lib/`, and const-constructors are already used consistently in new code)

**Todo List:**
1. Open `analysis_options.yaml`
2. Under the `rules:` section, add:
   ```yaml
   avoid_print: true
   prefer_const_constructors: true
   require_trailing_commas: true
   ```
3. Run `flutter analyze` — address any violations surfaced by the new rules
4. For any `prefer_const_constructors` violations: add `const` keyword to the widget constructor calls
5. For any `require_trailing_commas` violations: add trailing commas to all multi-line argument lists

---

### Sub-Task 7.4 — Synchronise `AppConstants.appVersion` with `pubspec.yaml`
**Status:** [x] done

**Intent:**
`lib/utils/constants.dart:27` declares `static const String appVersion = '1.7.2'` as a
hardcoded string. This will silently fall out of sync with `pubspec.yaml` on every release.

**Expected Outcomes (minimal path — no new dependency):**
- A prominent sync-warning comment added above the constant
- Value confirmed to match current `pubspec.yaml` version

**Todo List:**
1. Open `lib/utils/constants.dart`
2. Add comment: `// IMPORTANT: Must be manually updated to match pubspec.yaml version on every release`
3. Confirm `'1.7.2'` matches `pubspec.yaml version: 1.7.2+14` (already in sync)

---

## Phase 8 — Final Verification & Cleanup

### Sub-Task 8.1 — Final Codebase Analysis Pass
**Status:** [ ] pending

**Intent:**
After all previous sub-tasks complete, run a final full-project analysis to confirm no
regressions were introduced, no new lint violations appear, and no orphaned imports remain.

**Expected Outcomes:**
- `flutter analyze` reports zero errors and zero warnings
- `flutter test` passes all 4 existing test files
- No new `// ignore:` suppression comments were introduced during refactoring
- No inline `Colors.red/green/orange/grey/blue` remain in screen or widget files
- No hardcoded English strings remain in any file under `lib/widgets/`
- `flutter build apk --release` completes successfully

**Todo List:**
1. Run `flutter analyze` — resolve any remaining issues
2. Run `flutter test` — confirm all existing tests pass
3. Grep `lib/` for `Colors\.(red|green|orange|grey|blue)\b` — verify zero matches in screens/widgets
4. Grep `lib/widgets/` for `Text\('` — verify no hardcoded English strings remain
5. Grep `lib/` for `print(` — verify no debug statements
6. Grep `lib/services/` for string literals matching `'\/` — verify no remaining inline API paths
7. Grep `lib/widgets/app_drawer.dart` and drawer sections for bare string route literals — verify all replaced by `Routes.xxx`
8. Run `flutter build apk --release` to confirm clean release build

---

## Appendix: Complete Issue Registry

| ID | Sev | Category | Description | File:Line | Sub-Task |
|----|-----|----------|-------------|-----------|----------|
| D1 | HIGH | Dead dep | `fl_chart` declared, never imported | `pubspec.yaml:30` | 1.1 |
| D2 | HIGH | Dead dep | `path` declared, never imported | `pubspec.yaml:41` | 1.1 |
| D3 | HIGH | Dead dep | `path_provider` declared, never imported | `pubspec.yaml:50` | 1.1 |
| D4 | HIGH | Dead dep | `share_plus` declared, never imported | `pubspec.yaml:56` | 1.1 |
| D5 | HIGH | Dead dep | `url_launcher` declared, never imported | `pubspec.yaml:59` | 1.1 |
| D6 | LOW | Dead asset | `F-Droid.svg` unreferenced | `assets/getiton/` | 1.2 |
| D7 | LOW | Dead asset | `GooglePlayStore.svg` unreferenced | `assets/getiton/` | 1.2 |
| D8 | LOW | Dead import | `flutter/services.dart` unused | `firewall_logs_screen.dart:22` | 1.3 |
| D9 | MED | Dead code | `ApiResponseParser` class — 65 lines, zero usages across entire codebase | `api_response_parser.dart` | 6.3 |
| P1 | HIGH | Duplication | `_buildErrorState()` in 15 screens | 15 screen files | 1.4 |
| P2 | HIGH | Duplication | `_buildEmptyState()` in 11 screens | 11 screen files | 1.4 |
| P3 | HIGH | Duplication | `ScaffoldMessenger.showSnackBar` inline in 32 files | 32 screen files | 2.1 |
| P4 | HIGH | Duplication | Inline `AlertDialog` in 19 files | 19 screen files | 2.2 |
| P5 | HIGH | Duplication | `bool _isLoading + _errorMessage` in 22 screens | 22 screen files | 3.1 |
| P6 | MED | Duplication | `_loadSystemInfo()` in 12 screens | 12 screen files | 3.1 |
| P7 | MED | Duplication | Form save boilerplate in 4 form screens | 4 form screens | 3.2 |
| P8 | MED | Duplication | API endpoint path strings duplicated in service files (53+ inline strings) | 8 service files | 6.1 |
| P9 | MED | Duplication | Route name strings hardcoded in drawer widgets (8+ bare string literals) | `app_drawer.dart:87,96,136,147` + 4 section files | 6.6 |
| P10 | MED | Duplication | Login form validation block copy-pasted into 3 methods | `login_screen.dart` | 6.4 |
| V1 | HIGH | Validation | `isValidIPv4` duplicated in 2 files (different logic) | `validators.dart:26`, `wireguard_validators.dart:98` | 4.1 |
| V2 | HIGH | Validation | `isValidCIDR` in 3 files — inconsistent (IPv4-only vs IPv4+IPv6) | `validators.dart:64`, `common_validators.dart:22`, `wireguard_validators.dart:65` | 4.1 |
| V3 | HIGH | Validation | IP regex in `common_validators.dart` differs from manual parse in `validators.dart` | `common_validators.dart:9`, `validators.dart:26` | 4.1 |
| V4 | MED | Validation | Optional `BuildContext` on 6 `validateXxx()` methods allows silent non-localised errors | `validators.dart:188–298` | 4.1 |
| V5 | MED | Validation | `validateMacAddress()` uses hardcoded English even when context provided | `validators.dart:291–296` | 4.1 |
| V6 | MED | Validation | All strings in `common_validators.dart` hardcoded English, no localisation | `common_validators.dart` | 4.1 |
| V7 | MED | Validation | All strings in `wireguard_validators.dart` hardcoded English, no localisation | `wireguard_validators.dart` | 4.1 |
| L1 | HIGH | i18n | `Text('Delete')` hardcoded in 4 card widgets | `peer_card.dart:129`, `openvpn_instance_card.dart:147`, `openvpn_client_override_card.dart:154`, `openvpn_static_key_card.dart:120` | 5.1 |
| L2 | MED | i18n | `Text('Cancel')` hardcoded in 4 widget files | `list_manager_card.dart:131`, `peer_selector_dialog.dart:98`, `routing_settings_card.dart:126`, `openvpn_form_field_widgets.dart:387` | 5.1 |
| L3 | MED | i18n | `Text('Done')` hardcoded in 2 widget files | `peer_selector_dialog.dart:102`, `openvpn_form_field_widgets.dart:394` | 5.1 |
| L4 | MED | i18n | `Text('Add')` hardcoded in 2 widget files | `list_manager_card.dart:149`, `openvpn_form_field_widgets.dart:490` | 5.1 |
| L5 | MED | i18n | `Text('Retry')` hardcoded in shared widget | `error_display.dart:37` | 5.1 / 7.2 |
| L6 | MED | i18n | `'Server'`/`'Client'` label hardcoded | `openvpn_instance_card.dart:163` | 5.1 |
| L7 | MED | i18n | `'Actual Used'`/`'ARC Cache'` labels hardcoded | `resource_usage_section.dart:77,80` | 5.1 |
| L8 | MED | i18n | Demo mode indicator string hardcoded | `dashboard_screen.dart:248` | 5.1 |
| L9 | HIGH | i18n | 10 hardcoded English strings in form labels, tooltips, help text | `openvpn_static_key_form_screen.dart:249,287,288,290,302,304,350,375,397,407` | 6.5 |
| L10 | MED | i18n | 5 hardcoded strings in tooltips and messages | `openvpn_instance_form_screen.dart:632,637,643,653,659` | 6.5 |
| L11 | MED | i18n | `'Interface'` and `'Reason'` hardcoded in firewall log widget | `log_detail_sheet.dart:184,228` | 6.5 |
| L12 | MED | i18n | `'Thermal Sensors'` and `'No thermal sensors available'` hardcoded | `thermal_sensors_section.dart:41,49` | 5.1 |
| C1 | MED | Style | 300+ `Colors.X` inline colour literals in screens/widgets | 32+ files | 5.2 |
| C2 | MED | Style | Duplicate log-level colour switch in 2 widget files | `wireguard_log_card.dart:76`, `wireguard_log_detail_sheet.dart:367` | 5.2 |
| C3 | MED | Style | `Colors.blue[50/700/900]` info box colours inline | `firewall_rule_form_screen.dart:402`, `openvpn_static_key_form_screen.dart:386` | 5.2 |
| S1 | MED | Service | 5 empty `catch (_)` blocks that silently swallow all exceptions | `system_service.dart:55,66,76,93,111` | 6.2 |
| S2 | LOW | Service | `'/firewall/filter/get'` endpoint string duplicated on two lines in same file | `firewall_service.dart:33,86` | 6.1 |
| S3 | LOW | Service | `'/core/service/search'` endpoint string duplicated on two lines in same file | `vpn_service.dart:39,97` | 6.1 |
| Q1 | MED | Quality | `.then((_))` navigation callbacks | `wireguard_servers_screen.dart`, `firewall_rules_screen.dart:269,303` | 7.1 |
| Q2 | LOW | Quality | Hardcoded `appVersion` string constant | `constants.dart:27` | 7.4 |
| Q3 | LOW | Config | `avoid_print` rule not enabled in linter | `analysis_options.yaml:24` | 7.3 |
| Q4 | LOW | Config | `prefer_const_constructors` not enabled | `analysis_options.yaml` | 7.3 |
| Q5 | LOW | Config | `require_trailing_commas` not enabled | `analysis_options.yaml` | 7.3 |
