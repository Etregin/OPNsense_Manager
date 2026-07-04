# OPNsense Manager — Flutter Code Quality Audit Plan (v1.8.0 Phase 3)

## Overview

This plan is the result of a full codebase audit performed after the v1.8.0 Phase 1 and
Phase 2 refactor plans were both fully executed (all tasks marked `[x] done`).

The audit performed a direct read of all Dart files across `lib/`, `pubspec.yaml`, and
`analysis_options.yaml` and identified **net-new technical debt** not covered by any prior
plan. The five prior plans addressed: dead dependencies, SnackBar consolidation, BaseViewModel
adoption, async hardening, naming conventions, validator consolidation, and hardcoded strings.

This phase targets the **remaining issues**:

1. **Duplicate screen implementations** — two files implement the same Tailscale status screen
   with different approaches; the old implementation is dead code.

2. **Validator redundancy** — `Validators` (l10n-aware) and `CommonValidators` (no l10n) are
   parallel hierarchies both delegating to `NetworkValidators`. `CommonValidators` has no
   call sites that cannot be replaced by `Validators`. It is dead code.

3. **`dynamic` parameter types in service layer** — `BaseOPNsenseService.extractSelectedValue`
   and several methods in `demo_api_service.dart` / `dhcp_lease_adapter.dart` accept `dynamic`
   where `Object?` or a typed union is correct Dart practice.

4. **`ApiException` is under-typed** — it carries only `message` and `statusCode`. Error
   discrimination at the screen layer requires matching on message strings. An `errorType`
   enum would allow type-safe branching.

5. **`AppConstants.appVersion` manual sync** — the version string in `lib/utils/constants.dart`
   must be manually updated to match `pubspec.yaml`. There is a risk of drift. A `dart-define`
   or package_info_plus pattern would eliminate the manual step.

6. **Inline `Colors.X` usages in `screens/vpn/tailscale_status_screen.dart`** — this file
   (the old dead screen) uses `Colors.green`, `Colors.orange`, `Colors.grey`, `Colors.red[300]`
   directly, which violates the `AppColors` convention established in Phase 1.

7. **`refreshPeers()` dead method in `WireGuardPeersViewModel`** — a single-line wrapper
   `Future<void> refreshPeers() => refresh();` with no call sites; it is dead code.

8. **`_systemInfo` loaded-but-not-used pattern in list screens** — multiple screens
   (`firewall_rules_screen.dart`, `wireguard_servers_screen.dart`, etc.) declare a
   `SystemInfo? _systemInfo` field, load it via a separate async call, and only pass it
   to `AppDrawer`. This duplicated "load system info for drawer" boilerplate across 10+
   screens should be lifted into `AppDrawer` itself.

9. **`analysis_options.yaml` missing `prefer_single_quotes`** — commented out, never enabled.
   The entire codebase uses double quotes inconsistently. This lint rule should be enabled.

10. **`BaseFormViewModel.executeWithLoading` swallows all exceptions as strings** — `catch (e)`
    at line 64 calls `setError(e.toString())`, losing the original exception type. If the
    caller rethrows or uses the error message to discriminate errors, type information is lost.

**Scope:** Targeted files only — no architecture changes, no new patterns introduced.
**Approach:** Each sub-task is independently verifiable, scoped to one concern, and has
explicit file + line-level evidence.

---

## Phase A — Dead Code Elimination

### Sub-Task A.1 — Delete Dead `lib/screens/vpn/tailscale_status_screen.dart`
**Status:** [ ] pending

**Intent:**
Two files export a class named `TailscaleStatusScreen`:
- `lib/screens/tailscale_status_screen.dart` — the canonical, ViewModel-backed screen that
  uses `TailscaleStatusViewModel`, `AppDrawer`, `ConfirmationDialog`, and full l10n coverage.
- `lib/screens/vpn/tailscale_status_screen.dart` — an older implementation that manages state
  inline with `setState`, uses `VPNConnectionManager` directly, has hardcoded English strings
  (`'Authentication'`, `'Not Authenticated'`, `'Service State'`, etc.), and uses raw
  `Colors.green`, `Colors.orange`, `Colors.grey`, `Colors.red[300]` instead of `AppColors`.

The root-level file is the actively maintained version. The `vpn/` version is never imported
by any routing file or screen — it is dead code. Keeping it causes a class-name collision
that would break if both are ever imported in the same compilation unit.

**Evidence (verified by direct read):**
- `lib/screens/vpn/tailscale_status_screen.dart:32` — `class TailscaleStatusScreen` (duplicate name)
- `lib/screens/vpn/tailscale_status_screen.dart:46,55,77,83` — raw `Colors.*` instead of `AppColors`
- `lib/screens/vpn/tailscale_status_screen.dart:171,175,187` — hardcoded English strings
- `lib/screens/vpn/tailscale_status_screen.dart:49` — `context.read<DemoApiService>()` in `initState`
  (BuildContext captured before widget is mounted — flagged anti-pattern)
- No import of `vpn/tailscale_status_screen.dart` found in any routing or navigation file
- `lib/constants/routes.dart` and `lib/screens/` navigation points all reference
  `screens/tailscale_status_screen.dart` (the root-level canonical version)

**Expected Outcomes:**
- `lib/screens/vpn/tailscale_status_screen.dart` deleted
- `lib/screens/vpn/` directory deleted if it becomes empty
- `flutter analyze` passes with no new errors

**Todo List:**
1. Confirm zero import references to `vpn/tailscale_status_screen.dart`:
   `grep -rn "vpn/tailscale_status_screen" lib/`
2. Delete `lib/screens/vpn/tailscale_status_screen.dart`
3. Check if `lib/screens/vpn/` is now empty; if so, delete the directory
4. Run `flutter analyze`

**Relevant Context:**
- `lib/screens/tailscale_status_screen.dart` — canonical replacement
- `lib/constants/routes.dart` — routing definitions

---

### Sub-Task A.2 — Delete Dead `refreshPeers()` Wrapper in `WireGuardPeersViewModel`
**Status:** [ ] pending

**Intent:**
`lib/viewmodels/wireguard_peers_view_model.dart` line 83 declares:
```dart
/// Refresh the peers list
Future<void> refreshPeers() => refresh();
```
This method is a single-line wrapper that calls the base class `refresh()` method. It has
zero call sites — every screen that refreshes peers calls `_viewModel.refresh()` or
`_viewModel.loadItems()` directly. The wrapper is misleading (implies a distinct operation)
and is dead code.

**Evidence:**
- `wireguard_peers_view_model.dart:83` — the method body
- `grep -rn "refreshPeers" lib/` — zero matches outside the declaration itself

**Expected Outcomes:**
- Lines 82–83 removed from `wireguard_peers_view_model.dart`
- `flutter analyze` passes

**Todo List:**
1. Confirm zero call sites: `grep -rn "refreshPeers" lib/`
2. Open `lib/viewmodels/wireguard_peers_view_model.dart`
3. Delete the `/// Refresh the peers list` doc comment (line 82) and `refreshPeers()` method (line 83)
4. Run `flutter analyze`

**Relevant Context:**
- `lib/viewmodels/wireguard_peers_view_model.dart:83`
- `lib/viewmodels/base/base_list_view_model.dart:90` — `refresh()` base method

---

### Sub-Task A.3 — Delete `CommonValidators` (Superseded by `Validators`)
**Status:** [ ] pending

**Intent:**
`lib/utils/common_validators.dart` provides: `required()`, `ipAddress()`, `cidr()`, `port()`,
`url()`, `minLength()`, `maxLength()`, `combine()`. Every method either wraps `NetworkValidators`
or implements standalone logic.

`lib/utils/validators.dart` already provides: `isValidIPv4()`, `isValidCIDR()`, `isValidPort()`,
`validateHost()`, `validatePort()`, `validateRequired()`, `validateMacAddress()` — all
with full l10n support via `AppLocalizations`.

`CommonValidators` uses hardcoded English error strings (`'Invalid IP address'`, `'Invalid CIDR
notation (use format: IP/prefix)'`, `'Invalid port (must be 1-65535)'`, etc.) with no
localisation. Since the project has full l10n (5 languages), these non-localised validators
are unsuitable for any production form field. Any call site that uses `CommonValidators`
should be migrated to the l10n-aware `Validators` equivalents.

**Evidence:**
- `lib/utils/common_validators.dart:11-16` — `ipAddress()` returns hardcoded `'Invalid IP address'`
- `lib/utils/common_validators.dart:27-33` — `port()` returns hardcoded `'Invalid port (must be 1-65535)'`
- `lib/utils/common_validators.dart:48-54` — `minLength()` returns hardcoded `'$fieldName must be at least $min characters'`
- Call sites of `CommonValidators`: perform `grep -rn "CommonValidators" lib/` to enumerate

**Expected Outcomes:**
- Every call site of `CommonValidators` migrated to equivalent `Validators` or `WireGuardValidators` methods
- `lib/utils/common_validators.dart` deleted
- Any remaining unique logic in `CommonValidators` not covered by `Validators` (e.g. `url()`,
  `minLength()`, `maxLength()`, `combine()`) moved to `Validators` with l10n-aware error
  messages added to all `.arb` files
- `flutter analyze` passes

**Todo List:**
1. Run `grep -rn "CommonValidators" lib/` — enumerate all call sites
2. For each call site, identify the equivalent `Validators` method:
   - `CommonValidators.required(v)` → `Validators.validateRequired(v, fieldName, context)`
   - `CommonValidators.ipAddress(v)` → `NetworkValidators.isValidIPv4(v)` + inline message
   - `CommonValidators.cidr(v)` → `NetworkValidators.isValidCIDR(v)` + inline message
   - `CommonValidators.port(v)` → `Validators.validatePort(v, context)` (if context available)
   - `CommonValidators.url(v)` → move `url()` logic into `Validators` with l10n message
   - `CommonValidators.minLength(v, n)` → move into `Validators` with l10n message
   - `CommonValidators.maxLength(v, n)` → move into `Validators` with l10n message
   - `CommonValidators.combine([...], v)` → move `combine()` into `Validators`
3. Add any missing l10n keys to all 5 `.arb` files under `lib/l10n/`
4. Migrate each call site
5. Delete `lib/utils/common_validators.dart`
6. Run `flutter analyze`

**Relevant Context:**
- `lib/utils/validators.dart` — target for migration
- `lib/utils/network_validators.dart` — raw boolean primitives
- `lib/l10n/app_en.arb`, `app_ar.arb`, `app_de.arb`, `app_es.arb`, `app_fr.arb`

---

## Phase B — Type Safety Improvements

### Sub-Task B.1 — Replace `dynamic` with `Object?` in `BaseOPNsenseService`
**Status:** [ ] pending

**Intent:**
`lib/services/base/base_opnsense_service.dart:117` declares:
```dart
String extractSelectedValue(dynamic field, {bool returnDisplayValue = false})
```
The parameter type `dynamic` disables all static type checking on `field`. The method handles
three cases: `String`, `List`, and `Map<String, dynamic>`. The correct Dart type for an
unknown-type parameter that will be checked with `is` tests is `Object?`, not `dynamic`.
Using `Object?` preserves type safety — the compiler will enforce that the caller passes
a non-null-checked value, and `is` tests still work exactly the same.

**Evidence:**
- `base_opnsense_service.dart:117` — `dynamic field`
- The method body already uses `if (field is String)`, `if (field is List)`,
  `if (field is Map<String, dynamic>)` — no operation that requires `dynamic` semantics

**Expected Outcomes:**
- Parameter type changed from `dynamic` to `Object?`
- `field is String` / `field is List` / `field is Map` checks remain unchanged
- `flutter analyze` passes (no call sites need updating — the change is a strict widening)

**Todo List:**
1. Open `lib/services/base/base_opnsense_service.dart`
2. Change line 117: `String extractSelectedValue(dynamic field, ...)`
   → `String extractSelectedValue(Object? field, ...)`
3. Run `flutter analyze` — confirm all call sites still compile

**Relevant Context:**
- `lib/services/base/base_opnsense_service.dart:117-138`

---

### Sub-Task B.2 — Replace `dynamic` in `DhcpLeaseAdapter`
**Status:** [ ] pending

**Intent:**
`lib/services/dhcp_lease_adapter.dart` uses `dynamic` in multiple private parsing methods:
- `_parseDnsmasqLeases(dynamic data)`
- `_parseIscLeases(dynamic data)`
- `_parseKeaLeases(dynamic data)`

In each case, the method immediately tests `if (data is! List)` or `if (data is! Map)`.
The parameter should be `Object?` since that is the actual semantic intent — "unknown
deserialized JSON value". Using `dynamic` here suppresses the Dart analyzer's ability to
catch accidental misuse.

**Evidence (direct read required — read the file during implementation to confirm line numbers):**
- `lib/services/dhcp_lease_adapter.dart` — multiple `dynamic data` parameters

**Expected Outcomes:**
- All `dynamic data` parameters in `dhcp_lease_adapter.dart` changed to `Object?`
- All `dynamic` return type annotations changed to their actual types where known
- `flutter analyze` passes

**Todo List:**
1. Open `lib/services/dhcp_lease_adapter.dart`
2. Identify every `dynamic` usage
3. Replace each `dynamic` parameter with `Object?`
4. Replace any `dynamic` return types with their known types (`List<DhcpLease>`, etc.)
5. Run `flutter analyze`

**Relevant Context:**
- `lib/services/dhcp_lease_adapter.dart`
- `lib/models/dhcp_lease.dart`

---

### Sub-Task B.3 — Add `ApiErrorType` Enum to `ApiException`
**Status:** [ ] pending

**Intent:**
`lib/services/base/api_exception.dart` defines `ApiException` with only `message` and
`statusCode`. In `BaseOPNsenseService.handleDioError()`, error discrimination is performed
by switch on `DioExceptionType` and produces distinct `ApiException` messages. At the
screen/ViewModel layer, code that needs to react differently to auth errors (401) vs.
network errors vs. timeout errors must parse `message` strings — fragile string matching.

Adding an `ApiErrorType` enum to `ApiException` allows type-safe branching:
```dart
enum ApiErrorType { timeout, authFailure, permissionDenied, notFound, serverError,
                   certificateError, networkError, cancelled, unknown }
```
`handleDioError()` sets the appropriate `errorType` when creating each `ApiException`.
Screens and ViewModels can then do `if (e.errorType == ApiErrorType.authFailure)` instead
of `e.message.contains('credentials')`.

**Evidence:**
- `api_exception.dart:20-33` — only `message` and `statusCode`, no type discrimination
- `base_opnsense_service.dart:62-113` — seven distinct error cases mapped to string messages
- `login_view_model.dart:207-215` — catches generic `Exception`, calls `e.toString()`

**Expected Outcomes:**
- `ApiErrorType` enum defined in `api_exception.dart` (or a new `lib/services/base/api_error_type.dart`)
- `ApiException` gains `final ApiErrorType errorType` field
- `ApiException` constructor signature: `ApiException(this.message, this.statusCode, this.errorType)`
- `handleDioError()` updated to pass the correct `errorType` for each case
- All existing `ApiException(msg, code)` call sites updated to include `errorType`
- No screen or ViewModel is forced to change — adding the field is backward-compatible

**Todo List:**
1. Create or extend `lib/services/base/api_exception.dart`:
   - Add `enum ApiErrorType { timeout, authFailure, permissionDenied, notFound, serverError, certificateError, networkError, cancelled, unknown }`
   - Add `final ApiErrorType errorType` to `ApiException`
   - Update the constructor
2. Open `lib/services/base/base_opnsense_service.dart`
3. In `handleDioError()`, pass the matching `ApiErrorType` for each case:
   - Timeout cases → `ApiErrorType.timeout`
   - `statusCode == 401` → `ApiErrorType.authFailure`
   - `statusCode == 403` → `ApiErrorType.permissionDenied`
   - `statusCode == 404` → `ApiErrorType.notFound`
   - Other bad response → `ApiErrorType.serverError`
   - Certificate error → `ApiErrorType.certificateError`
   - Socket/network error → `ApiErrorType.networkError`
   - Cancel → `ApiErrorType.cancelled`
   - Default → `ApiErrorType.unknown`
4. Find all other `ApiException(...)` constructor call sites in the codebase
   (`grep -rn "ApiException(" lib/`) and add the appropriate `errorType` argument
5. Run `flutter analyze`

**Relevant Context:**
- `lib/services/base/api_exception.dart`
- `lib/services/base/base_opnsense_service.dart:62-113`
- `lib/viewmodels/login_view_model.dart`

---

## Phase C — Screen Architecture Cleanup

### Sub-Task C.1 — Lift `_loadSystemInfo()` into `AppDrawer`
**Status:** [ ] pending

**Intent:**
At least ten screens share an identical pattern:
1. Declare `SystemInfo? _systemInfo` field
2. In `didChangeDependencies()` or `initState()`, call `_loadSystemInfo()` concurrently
3. `_loadSystemInfo()` calls `context.read<DemoApiService>().getSystemInfo()` and on success
   calls `setState(() { _systemInfo = result; })`
4. Pass `_systemInfo` to `AppDrawer(currentRoute: '...', systemInfo: _systemInfo)`

This is ~15 lines of boilerplate per screen for a concern (`AppDrawer`'s header data) that
belongs to `AppDrawer` itself. Moving the data fetch inside `AppDrawer` eliminates the
duplicate pattern entirely. `AppDrawer` already receives `DemoApiService` via `context.read`
(it has access to the Provider tree), so it can load `SystemInfo` internally using a
`FutureBuilder` or `initState` on its own `StatefulWidget`.

**Evidence (all screens with this pattern — verify by grep during implementation):**
- `lib/screens/firewall_rules_screen.dart:49,76-87` — `SystemInfo? _systemInfo`, `_loadSystemInfo()`
- `lib/screens/wireguard_servers_screen.dart` — same pattern
- `lib/screens/wireguard_peers_screen.dart` — same pattern
- `lib/screens/firewall_aliases_screen.dart` — same pattern
- `lib/screens/dhcp_leases_screen.dart` — same pattern
- `lib/screens/neighbor_discovery_screen.dart` — same pattern
- `lib/screens/wol_screen.dart` — same pattern
- `lib/screens/system_info_screen.dart` — same pattern
- `lib/screens/wireguard_status_screen.dart` — same pattern
- `lib/screens/tailscale_status_screen.dart` — passes `_viewModel.systemInfo` (already internal to VM)

**Expected Outcomes:**
- `AppDrawer` modified to accept `SystemInfo?` as an optional parameter (preserve backward
  compat) **and** internally fetch `SystemInfo` when `systemInfo` param is null, using
  a `FutureBuilder` inside the drawer header
- All screens that declare `SystemInfo? _systemInfo` solely for the drawer have that field
  removed, `_loadSystemInfo()` removed, and `AppDrawer(systemInfo: _systemInfo)` simplified
  to `AppDrawer(currentRoute: '...')` — systemInfo param omitted
- `AppDrawer` constructor signature remains backward-compatible (existing `systemInfo` param
  is kept but now truly optional with a sensible default)
- `flutter analyze` passes

**Todo List:**
1. Run `grep -rn "_systemInfo\|_loadSystemInfo\|SystemInfo" lib/screens/` to enumerate
   all affected screens
2. Open `lib/widgets/app_drawer.dart`; confirm current `systemInfo` parameter handling
3. Convert `AppDrawer` to a `StatefulWidget` if it is currently `StatelessWidget`
4. In `AppDrawer.initState()`, call `context.read<DemoApiService>().getSystemInfo()` and
   store result in `_systemInfo` state; use `FutureBuilder` or `setState` pattern
5. For each affected screen:
   a. Remove the `SystemInfo? _systemInfo` field declaration
   b. Remove `_loadSystemInfo()` method
   c. Remove `_systemInfo` argument from `AppDrawer(...)` call
   d. Remove `Future.wait([..., _loadSystemInfo()])` or equivalent concurrent call from `_loadData()`
6. Run `flutter analyze`

**Relevant Context:**
- `lib/widgets/app_drawer.dart`
- `lib/screens/firewall_rules_screen.dart:49,69-88` — canonical example to work from

---

### Sub-Task C.2 — Fix `BuildContext` Captured in `initState` in Dead Screen
**Status:** [ ] pending (this is resolved by completing A.1 — delete the dead screen)

**Note:** This issue exists only in `lib/screens/vpn/tailscale_status_screen.dart:54`:
```dart
final demoApiService = context.read<DemoApiService>();  // in initState — incorrect
```
This anti-pattern (using `context` in `initState` before `didChangeDependencies`) is resolved
when Sub-Task A.1 deletes the file. No separate action required if A.1 is completed first.

---

## Phase D — Lint & Code Style Hardening

### Sub-Task D.1 — Enable `prefer_single_quotes` in `analysis_options.yaml`
**Status:** [ ] pending

**Intent:**
`lib/analysis_options.yaml:27` has a commented-out rule:
```yaml
# prefer_single_quotes: true  # Uncomment to enable the `prefer_single_quotes` rule
```
The entire codebase uses double-quoted strings inconsistently. Some files use single quotes
(e.g., `lib/services/base/`), others use double (most screen and ViewModel files). Enabling
this rule with `dart fix --apply` will normalise all string literals to single quotes in
one automated pass.

**Evidence:**
- `analysis_options.yaml:27` — rule commented out
- `grep -c '"' lib/screens/firewall_rules_screen.dart` yields ~80 double-quoted literals

**Expected Outcomes:**
- `analysis_options.yaml` line 27 uncommented: `prefer_single_quotes: true`
- `dart fix --apply` run to auto-convert all affected string literals to single quotes
- `flutter analyze` passes with zero new `prefer_single_quotes` warnings

**Todo List:**
1. Open `analysis_options.yaml`
2. Uncomment line 27: `prefer_single_quotes: true`
3. Run `dart fix --apply` from the project root to apply the automated fix across all files
4. Review the diff to confirm only string literal quote characters were changed (no logic changes)
5. Run `flutter analyze` — confirm zero new errors

**Relevant Context:**
- `analysis_options.yaml:27`

---

### Sub-Task D.2 — Replace `appVersion` Manual Sync with `package_info_plus`
**Status:** [ ] pending

**Intent:**
`lib/utils/constants.dart:27` declares:
```dart
// IMPORTANT: Must be manually updated to match pubspec.yaml version on every release
static const String appVersion = '1.7.2';
```
This constant requires manual synchronisation with `pubspec.yaml` on every release. If a
developer bumps `pubspec.yaml` and forgets to update `AppConstants.appVersion`, the displayed
version in Settings is wrong. The `package_info_plus` package reads the native-compiled
version at runtime, eliminating the synchronisation burden.

**pubspec.yaml** already imports no version-reading package. This is an additive dependency.

**Expected Outcomes:**
- `package_info_plus: ^8.0.0` (or latest stable) added to `dependencies` in `pubspec.yaml`
- A `AppInfo` service or extension created that exposes `Future<String> get appVersion`
  using `PackageInfo.fromPlatform().version`
- `AppConstants.appVersion` constant and its manual-sync comment removed
- All call sites of `AppConstants.appVersion` updated to read from the new async source
  (typically via a FutureBuilder in the Settings screen, or cached at app startup)
- `flutter pub get` runs cleanly
- `flutter analyze` passes

**Todo List:**
1. Add `package_info_plus: ^8.0.0` to `pubspec.yaml` under dependencies
2. Run `flutter pub get`
3. Find all usages of `AppConstants.appVersion`:
   `grep -rn "AppConstants.appVersion\|appVersion" lib/`
4. Create a singleton or initialisation call in `main.dart` or `app_info_service.dart` that
   loads `PackageInfo.fromPlatform()` at startup and stores `version` in a static field
5. Replace each `AppConstants.appVersion` call site with the cached version string
6. Remove `static const String appVersion = '1.7.2';` and its comment from `constants.dart`
7. Run `flutter analyze`

**Relevant Context:**
- `lib/utils/constants.dart:27`
- `lib/main.dart`
- Settings screen that displays the app version

---

## Phase E — `BaseFormViewModel.executeWithLoading` Error Preservation
**Status:** [ ] pending

### Sub-Task E.1 — Preserve Exception Type in `executeWithLoading`
**Status:** [ ] pending

**Intent:**
`lib/viewmodels/base/base_form_view_model.dart:64`:
```dart
} catch (e) {
  setLoading(false);
  setError(e.toString());
  return null;
}
```
`e.toString()` converts any exception to a plain string, discarding:
- Whether it was an `ApiException` (with structured `message`, `statusCode`, `errorType`)
- Whether it was a Dart `FormatException`, `StateError`, etc.

ViewModels that call `executeWithLoading()` and then inspect `errorMessage` cannot
distinguish a 401 auth failure from a timeout or a programming error — all become
identical strings. The fix is to:
1. Catch `ApiException` specifically and set `errorMessage` to `e.message` (not `e.toString()`)
2. Re-expose the `ApiException` (or at least its `errorType`) on the ViewModel so screens
   can react with different UX (e.g. prompt re-login on `authFailure`)
3. For non-`ApiException` exceptions, keep the current `setError(e.toString())` behaviour

**Evidence:**
- `base_form_view_model.dart:64` — bare `catch (e)` swallows all exception types
- `login_view_model.dart:207-215` — downstream catch cannot distinguish error types

**Expected Outcomes:**
- `executeWithLoading()` catch block updated:
  ```dart
  } on ApiException catch (e) {
    setLoading(false);
    setError(e.message);
    return null;
  } catch (e) {
    setLoading(false);
    setError(e.toString());
    return null;
  }
  ```
- `BaseFormViewModel` gains `ApiException? get lastApiException` getter (nullable, reset on
  each `executeWithLoading` call) so screens can inspect the structured exception if needed
- No change to existing screen behaviour — `errorMessage` still receives the human-readable text
- `flutter analyze` passes

**Todo List:**
1. Open `lib/viewmodels/base/base_form_view_model.dart`
2. Add import for `ApiException`
3. Add `ApiException? _lastApiException` field and `ApiException? get lastApiException` getter
4. In `executeWithLoading()`:
   a. At the start, reset `_lastApiException = null`
   b. Add specific `on ApiException catch (e)` block: store `_lastApiException = e`; call
      `setError(e.message)`
   c. Keep the generic `catch (e)` as fallback
5. Run `flutter analyze`

**Relevant Context:**
- `lib/viewmodels/base/base_form_view_model.dart:56-69`
- `lib/services/base/api_exception.dart`
- Phase B Sub-Task B.3 (must be completed before this, to ensure `ApiException` has `errorType`)

---

## Phase F — Final Verification

### Sub-Task F.1 — Final Codebase Analysis Pass (Phase 3)
**Status:** [ ] pending

**Intent:**
After all Phase A–E sub-tasks are complete, run a final full-project analysis to confirm
all targeted patterns have been resolved and no regressions introduced.

**Expected Outcomes:**
- `flutter analyze` reports zero errors and zero warnings
- `grep -rn "vpn/tailscale_status_screen" lib/` — zero matches
- `grep -rn "refreshPeers" lib/` — zero matches
- `grep -rn "CommonValidators" lib/` — zero matches
- `grep -rn "common_validators" lib/` — zero matches
- `grep -rn "dynamic field\|dynamic data" lib/services/` — zero matches
- `ApiException` has `errorType` field
- `AppDrawer` fetches `SystemInfo` internally; no screen declares `_systemInfo` solely
  for the drawer
- `AppConstants.appVersion` does not exist; version read from `package_info_plus`
- `prefer_single_quotes: true` enabled in `analysis_options.yaml`
- `flutter test` — all existing tests pass
- `flutter build apk --release` — clean release build

**Todo List:**
1. Run `flutter analyze` — resolve any remaining issues
2. Run each grep check listed in Expected Outcomes above
3. Manually verify `AppDrawer` no longer requires `systemInfo` parameter in callers
4. Run `flutter test`
5. Run `flutter build apk --release`

---

## Appendix: Net-New Issue Registry (Phase 3 Audit)

All items below were identified by direct code read after Phase 1 and Phase 2 were fully
executed. None of these items appear in `refactor-v1.8.0-plan.md` or
`refactor-v1.8.0-phase2-plan.md`.

| ID | Sev | Category | Description | File | Sub-Task |
|----|-----|----------|-------------|------|----------|
| A1 | HIGH | Dead Code | `lib/screens/vpn/tailscale_status_screen.dart` is a dead duplicate of the root-level canonical screen; contains hardcoded strings, raw `Colors.*` usages, and `BuildContext` in `initState` | `screens/vpn/tailscale_status_screen.dart:32` | A.1 |
| A2 | LOW | Dead Code | `refreshPeers()` is a single-line wrapper with zero call sites | `wireguard_peers_view_model.dart:83` | A.2 |
| A3 | MED | Dead Code | `CommonValidators` is superseded by `Validators`; has no l10n and duplicate coverage of `NetworkValidators` | `utils/common_validators.dart` | A.3 |
| B1 | MED | Type Safety | `extractSelectedValue(dynamic field)` should use `Object?` | `base_opnsense_service.dart:117` | B.1 |
| B2 | MED | Type Safety | `_parseDnsmasqLeases(dynamic data)` and siblings should use `Object?` | `dhcp_lease_adapter.dart` | B.2 |
| B3 | MED | Architecture | `ApiException` lacks error type discrimination; callers must match strings | `api_exception.dart:20-33` | B.3 |
| C1 | MED | Duplication | `_loadSystemInfo()` + `SystemInfo? _systemInfo` duplicated across 10+ screens solely to pass to `AppDrawer` | `firewall_rules_screen.dart:49,76` + 9 others | C.1 |
| C2 | MED | Anti-Pattern | `context.read()` in `initState` (before `didChangeDependencies`) | `screens/vpn/tailscale_status_screen.dart:54` | Resolved by A.1 |
| D1 | LOW | Lint | `prefer_single_quotes` lint rule commented out; codebase uses mixed quote styles | `analysis_options.yaml:27` | D.1 |
| D2 | MED | Reliability | `AppConstants.appVersion` requires manual sync with `pubspec.yaml` on every release | `utils/constants.dart:27` | D.2 |
| E1 | MED | Architecture | `executeWithLoading` catch swallows `ApiException` type info; all errors become plain strings | `base_form_view_model.dart:64` | E.1 |
