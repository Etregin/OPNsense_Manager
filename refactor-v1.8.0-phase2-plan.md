# OPNsense Manager — Flutter Code Quality Audit Plan (v1.8.0 Phase 2)

## Overview

This plan is the result of a full codebase audit performed after the v1.8.0 Phase 1 refactor
plan was executed (Phases 1–7 of `refactor-v1.8.0-plan.md` are all marked `[x] done`).

The audit identified five categories of remaining technical debt that were **not addressed** by
the original plan:

1. **Non-base ViewModels** — five ViewModels extend `ChangeNotifier` directly and manually
   duplicate `isLoading`, `errorMessage`, and state management patterns already provided by
   `BaseFormViewModel`.

2. **Async state-management bugs** — eight ViewModels set `_loading = false` in `catch` blocks
   rather than `finally` blocks, and two ViewModels call `notifyListeners()` before and after
   async completions inconsistently, creating a risk of state not being reset on error paths.

3. **Semantic misuse of `errorMessage`** — `login_view_model.dart` uses `setError()` to
   communicate progress status messages ("Testing connection 1/4..."), which conflates error
   state with informational state and causes the UI to render a red error banner for normal
   progress updates.

4. **Form ViewModel inconsistencies** — naming conventions for the "existing item" identifier
   field vary across form ViewModels (`_existingServer`, `_existingPeerUuid`, `_vpnid`, `_uuid`,
   `_keyid`), and the `loadItem()` method signature is inconsistent (some load in constructor,
   some take parameters, one is not auto-triggered).

5. **List ViewModel inconsistencies** — toggle-safety patterns differ (some use a `Set<String>`
   lock, others don't), `rethrow` usage in error handlers is inconsistent, and the
   `openvpn_instances_view_model.dart` introduces a `searchQuery2` property that shadows the
   base class `searchQuery`.

**Scope:** All files under `lib/viewmodels/`, with targeted changes to the affected screens.
**Architecture baseline:** Provider + ChangeNotifier — no architecture changes.
**Approach:** Each sub-task is independently verifiable and scoped to a single concern so
regressions are isolated.

---

## Phase A — ViewModel Base Class Adoption

### Sub-Task A.1 — Migrate `DashboardViewModel` to `BaseFormViewModel`
**Status:** [x] done

**Intent:**
`lib/viewmodels/dashboard_view_model.dart` extends `ChangeNotifier` directly and manually
declares `_isLoading`, `_errorMessage`, `setLoading()`, `clearError()`, and `setError()`
— a complete duplication of the properties and methods already provided by `BaseFormViewModel`.
Extending the base class removes ~40 lines of duplicate boilerplate and ensures future
improvements to the base class propagate automatically.

**Evidence:**
- `dashboard_view_model.dart:26` — `class DashboardViewModel extends ChangeNotifier`
- Manually implements: `_isLoading` (line ~32), `_errorMessage` (line ~33), `setLoading()`,
  `clearError()`, `setError()` — all duplicates of `BaseFormViewModel`

**Expected Outcomes:**
- `DashboardViewModel` extends `BaseFormViewModel` instead of `ChangeNotifier`
- All manually declared `_isLoading`, `_errorMessage`, `setLoading()`, `clearError()`,
  `setError()` definitions removed from the class body
- All existing call sites (`isLoading`, `errorMessage`, `setLoading(...)`) continue to work
  unchanged because `BaseFormViewModel` exposes the same public API
- `flutter analyze` passes with no new errors

**Todo List:**
1. Open `lib/viewmodels/dashboard_view_model.dart`
2. Change `extends ChangeNotifier` to `extends BaseFormViewModel`
3. Add import for `BaseFormViewModel` if not already present
4. Delete the duplicate `_isLoading`, `_errorMessage` field declarations
5. Delete the duplicate `setLoading()`, `clearError()`, `setError()` method bodies
6. Verify all existing usages of `isLoading`, `errorMessage` in `dashboard_screen.dart` still compile
7. Run `flutter analyze`

**Relevant Context:**
- `lib/viewmodels/base/base_form_view_model.dart` — provides `isLoading`, `errorMessage`,
  `hasUnsavedChanges`, `setLoading()`, `setError()`, `clearError()`, `executeWithLoading()`
- `lib/screens/dashboard_screen.dart` — consuming screen that reads ViewModel state

---

### Sub-Task A.2 — Migrate `SystemInfoViewModel` to `BaseFormViewModel`
**Status:** [x] done

**Intent:**
`lib/viewmodels/system_info_view_model.dart` extends `ChangeNotifier` directly with the
same duplicate `_isLoading`/`_errorMessage` boilerplate. Same fix as A.1.

**Evidence:**
- `system_info_view_model.dart:24` — `class SystemInfoViewModel extends ChangeNotifier`
- Manually implements: `_isLoading`, `_errorMessage`, `setLoading()`, `clearError()`, `setError()`

**Expected Outcomes:**
- `SystemInfoViewModel` extends `BaseFormViewModel`
- All duplicate state boilerplate removed
- `lib/screens/system_info_screen.dart` continues to compile unchanged

**Todo List:**
1. Open `lib/viewmodels/system_info_view_model.dart`
2. Change `extends ChangeNotifier` to `extends BaseFormViewModel`
3. Add import for `BaseFormViewModel`
4. Delete the duplicate field declarations and method bodies
5. Verify `system_info_screen.dart` compiles without changes
6. Run `flutter analyze`

**Relevant Context:**
- `lib/viewmodels/base/base_form_view_model.dart`
- `lib/screens/system_info_screen.dart`

---

### Sub-Task A.3 — Migrate `TailscaleStatusViewModel` to `BaseFormViewModel`
**Status:** [x] done

**Intent:**
`lib/viewmodels/tailscale_status_view_model.dart` extends `ChangeNotifier` directly with
duplicate boilerplate. The class also holds a `Future.wait([...])` data-load call that
has no error handling if any individual Future rejects — this should be wrapped with
`executeWithLoading()` after the base class migration.

**Evidence:**
- `tailscale_status_view_model.dart:25` — `class TailscaleStatusViewModel extends ChangeNotifier`
- `tailscale_status_view_model.dart:46` — `Future.wait([...])` with no per-future error handler
- Manually implements: `_isLoading`, `_errorMessage`, `setLoading()`, `clearError()`, `setError()`

**Expected Outcomes:**
- `TailscaleStatusViewModel` extends `BaseFormViewModel`
- Duplicate boilerplate removed
- `Future.wait([...])` data load wrapped with `executeWithLoading()`
- `lib/screens/tailscale_status_screen.dart` continues to compile unchanged

**Todo List:**
1. Open `lib/viewmodels/tailscale_status_view_model.dart`
2. Change `extends ChangeNotifier` to `extends BaseFormViewModel`
3. Add import for `BaseFormViewModel`
4. Delete duplicate field declarations and method bodies
5. Wrap the `Future.wait([...])` data load call inside `executeWithLoading(() async { ... })`
   so that if any future throws, the error is captured in `errorMessage` rather than causing
   an unhandled exception
6. Verify `tailscale_status_screen.dart` compiles without changes
7. Run `flutter analyze`

**Relevant Context:**
- `lib/viewmodels/base/base_form_view_model.dart` — `executeWithLoading<T>()`
- `lib/screens/tailscale_status_screen.dart`

---

### Sub-Task A.4 — Migrate `TailscaleAuthViewModel` to `BaseFormViewModel`
**Status:** [x] done

**Intent:**
`lib/viewmodels/tailscale_auth_view_model.dart` extends `ChangeNotifier` directly and
additionally maintains a separate `_isSaving` boolean flag alongside `_isLoading`. This
indicates two distinct loading states — loading initial data vs. performing a save action.
`BaseFormViewModel.executeWithLoading()` handles the save path; an additional `_isSaving`
field should remain for the separate save-in-progress indicator, but the duplicated base
boilerplate must be removed.

**Evidence:**
- `tailscale_auth_view_model.dart:24` — `class TailscaleAuthViewModel extends ChangeNotifier`
- `tailscale_auth_view_model.dart:28` — `String _loginServer = 'https://login.tailscale.com'`
  (hardcoded URL that should be in `AppConstants`)
- Manually implements: `_isLoading`, `_isSaving`, `_errorMessage`, `setLoading()`, `setError()`

**Expected Outcomes:**
- `TailscaleAuthViewModel` extends `BaseFormViewModel`
- Duplicate base boilerplate removed; `_isSaving` retained as it tracks a distinct second loading state
- `'https://login.tailscale.com'` moved to `AppConstants.tailscaleLoginServer` in `lib/utils/constants.dart`
- `lib/screens/tailscale_authentication_screen.dart` continues to compile

**Todo List:**
1. Open `lib/utils/constants.dart`; add `static const String tailscaleLoginServer = 'https://login.tailscale.com';`
   to `AppConstants`
2. Open `lib/viewmodels/tailscale_auth_view_model.dart`
3. Change `extends ChangeNotifier` to `extends BaseFormViewModel`
4. Add import for `BaseFormViewModel`
5. Delete duplicate `_isLoading`, `_errorMessage`, `setLoading()`, `clearError()`, `setError()` bodies
6. Replace the hardcoded `'https://login.tailscale.com'` with `AppConstants.tailscaleLoginServer`
7. Verify `tailscale_authentication_screen.dart` compiles without changes
8. Run `flutter analyze`

**Relevant Context:**
- `lib/viewmodels/base/base_form_view_model.dart`
- `lib/utils/constants.dart` — `AppConstants` class
- `lib/screens/tailscale_authentication_screen.dart`

---

### Sub-Task A.5 — Migrate `WireGuardStatusViewModel` to `BaseFormViewModel`
**Status:** [x] done

**Intent:**
`lib/viewmodels/wireguard_status_view_model.dart` extends `ChangeNotifier` directly.
It has a `loadStatus()` method and a `refresh()` method that duplicate the
`loadItems()`/`refresh()` pattern already in `BaseListViewModel`. However, since the
WireGuard status screen is a single-data-entity screen (not a list), `BaseFormViewModel`
with `executeWithLoading()` is the correct base class.

**Evidence:**
- `wireguard_status_view_model.dart:26` — `class WireGuardStatusViewModel extends ChangeNotifier`
- Manually implements: `_isLoading`, `_errorMessage`, `loadStatus()`, `refresh()`, `setLoading()`,
  `clearError()`, `setError()`

**Expected Outcomes:**
- `WireGuardStatusViewModel` extends `BaseFormViewModel`
- Duplicate boilerplate removed; `loadStatus()` and `refresh()` retained (they are domain-specific)
- `loadStatus()` internally calls `executeWithLoading(() => _apiService.getWireGuardStatus())`
- `lib/screens/wireguard_status_screen.dart` continues to compile unchanged

**Todo List:**
1. Open `lib/viewmodels/wireguard_status_view_model.dart`
2. Change `extends ChangeNotifier` to `extends BaseFormViewModel`
3. Add import for `BaseFormViewModel`
4. Delete duplicate `_isLoading`, `_errorMessage`, `setLoading()`, `clearError()`, `setError()` bodies
5. Refactor `loadStatus()` to use `executeWithLoading()`
6. Verify `wireguard_status_screen.dart` compiles without changes
7. Run `flutter analyze`

**Relevant Context:**
- `lib/viewmodels/base/base_form_view_model.dart`
- `lib/screens/wireguard_status_screen.dart`

---

## Phase B — Async State Management Hardening

### Sub-Task B.1 — Add `finally` Blocks to Form ViewModels Missing Them
**Status:** [x] done

**Intent:**
Six form ViewModels (`openvpn_instance_form_view_model.dart`,
`openvpn_client_override_form_view_model.dart`, `openvpn_static_key_form_view_model.dart`,
`wireguard_server_form_view_model.dart`, `wireguard_peer_form_view_model.dart`,
`firewall_rule_form_view_model.dart`) call `setLoading(false)` inside both the `try`
success branch and the `catch` error branch. This pattern is safe in principle but is
fragile — if a second `catch` branch or early return is ever added, the loading state can
be orphaned. The correct pattern is a `finally` block that guarantees `setLoading(false)`,
which is already what `BaseFormViewModel.executeWithLoading()` does.

The fix is to audit every form ViewModel that does not route through `executeWithLoading()`
and ensure `setLoading(false)` is in a `finally` block rather than duplicated across
`try` and `catch` branches.

**Evidence:**
- `openvpn_instance_form_view_model.dart` lines 40–49: `setLoading(false)` on line 45 (success)
  and line 47 (catch) — not in `finally`
- `openvpn_client_override_form_view_model.dart` lines 40–48: same pattern
- `openvpn_static_key_form_view_model.dart` lines 45–53: same pattern
- `wireguard_server_form_view_model.dart` lines 51–61: `_loadingPeers = false` in catch, not finally
- `wireguard_peer_form_view_model.dart` lines 51–61: `_loadingServers = false` in catch, not finally

**Expected Outcomes:**
- All `setLoading(false)` / `_loadingXxx = false` calls that appear in both `try` and `catch`
  blocks are moved to a single `finally` block
- `notifyListeners()` called once per async lifecycle (start + finally), not separately in
  success and catch branches
- Behaviour is functionally identical (loading state is always cleared)

**Todo List:**
1. Open `lib/viewmodels/openvpn_instance_form_view_model.dart`; find every load/save method that
   has `setLoading(false)` duplicated across `try` and `catch`; refactor to `try { ... } catch { ... } finally { setLoading(false); }`
2. Repeat step 1 for `openvpn_client_override_form_view_model.dart`
3. Repeat step 1 for `openvpn_static_key_form_view_model.dart`
4. Open `wireguard_server_form_view_model.dart`; find `loadPeers()` and `loadCarpVipOptions()`;
   move `_loadingPeers = false` / `_loadingCarpOptions = false` to `finally` blocks;
   ensure `notifyListeners()` is not called redundantly in both success and catch paths
5. Open `wireguard_peer_form_view_model.dart`; apply the same fix to `loadServers()`
6. Run `flutter analyze`

**Relevant Context:**
- `lib/viewmodels/base/base_form_view_model.dart` lines 56–69 — reference `finally`-based
  `executeWithLoading()` implementation

---

### Sub-Task B.2 — Fix `notifyListeners()` Called Before Async Completes
**Status:** [x] done

**Intent:**
`wireguard_server_form_view_model.dart` and `wireguard_peer_form_view_model.dart` call
`notifyListeners()` immediately after setting `_loadingXxx = true` at the start of an
async method, and again in the `catch` branch after setting it back to `false`. This
causes two separate UI rebuilds when only the final settled state matters. The standard
pattern is: set flag + call `notifyListeners()` once at start, then call
`notifyListeners()` once more in the `finally` block.

**Evidence:**
- `wireguard_server_form_view_model.dart` line 52: `notifyListeners()` immediately after
  `_loadingPeers = true`, then again at line 57 (success path) — two rebuild triggers
  where one would suffice
- `wireguard_peer_form_view_model.dart` line 52: same pattern

**Expected Outcomes:**
- Each async load method calls `notifyListeners()` exactly twice per execution: once at
  the start (loading = true) and once at completion (in `finally`)
- The pattern aligns with `BaseFormViewModel.executeWithLoading()` which does the same
- No behavioural change to the UI; only the number of intermediate rebuilds is reduced

**Todo List:**
1. Open `wireguard_server_form_view_model.dart`
2. In `loadPeers()`: keep `_loadingPeers = true; notifyListeners();` at the top; move
   the `notifyListeners()` from the success path to the `finally` block; remove the
   redundant `notifyListeners()` from the `catch` path
3. Repeat step 2 for `loadCarpVipOptions()` if it has the same pattern
4. Open `wireguard_peer_form_view_model.dart`; apply the same fix to `loadServers()`
5. Run `flutter analyze`

**Relevant Context:**
- `lib/viewmodels/base/base_form_view_model.dart` — single `setLoading(true)`/`notifyListeners()`
  at start, single `setLoading(false)`/`notifyListeners()` in finally

---

## Phase C — ViewModel Semantic & Naming Consistency

### Sub-Task C.1 — Fix Semantic Misuse of `errorMessage` in `LoginViewModel`
**Status:** [x] done

**Intent:**
`lib/viewmodels/login_view_model.dart` calls `setError()` to display progress status
messages such as `'Testing connection 1/4: Profile Name'` (line ~88) and
`'Profile saved successfully'` (line ~182). This misuses the `errorMessage` property,
which is semantically reserved for error states. The UI renders `errorMessage` in a
red error banner, causing a success or progress message to appear as an error to the user.

The fix is to add a separate `_statusMessage` property to `LoginViewModel` that the
screen consumes for progress/informational text, leaving `errorMessage` for genuine
error conditions only.

**Evidence:**
- `login_view_model.dart` line ~88: `setError('Testing connection $currentAttempt/$totalConnections: ...')`
  — progress update, not an error
- `login_view_model.dart` line ~182: `setError('Profile saved successfully')` — success message

**Expected Outcomes:**
- New `String? _statusMessage` property in `LoginViewModel` with getter `statusMessage`
  and `setStatus(String? msg)` method
- All calls to `setError(msg)` where `msg` represents a progress or success state replaced
  with `setStatus(msg)`
- All genuine error calls (`setError(...)`) remain unchanged
- `login_screen.dart` updated to display `viewModel.statusMessage` in an info-styled widget
  and `viewModel.errorMessage` in the existing error banner — separate display paths

**Todo List:**
1. Open `lib/viewmodels/login_view_model.dart`
2. Identify every `setError()` call in the file; classify each as genuine error or
   progress/success message
3. Add `String? _statusMessage` field and `String? get statusMessage` getter and
   `void setStatus(String? msg) { _statusMessage = msg; notifyListeners(); }` method
4. Replace each progress/success `setError(msg)` call with `setStatus(msg)`;
   retain all genuine error `setError(msg)` calls unchanged
5. Open `lib/screens/login_screen.dart`
6. Find where `viewModel.errorMessage` is displayed; add a separate display path for
   `viewModel.statusMessage` using an info-styled `Text` or `Banner` widget
7. Ensure `setStatus(null)` is called at the start of each action method (alongside
   `clearError()`) to reset stale status messages
8. Run `flutter analyze`

**Relevant Context:**
- `lib/viewmodels/login_view_model.dart` — full context needed before editing
- `lib/screens/login_screen.dart` — UI consuming the ViewModel state
- `lib/viewmodels/base/base_form_view_model.dart` — does not need modification

---

### Sub-Task C.2 — Standardise "Existing Item ID" Field Naming in Form ViewModels
**Status:** [x] done

**Intent:**
The field that holds the UUID/ID of an existing item being edited is named differently in
every form ViewModel:

| ViewModel | Field name |
|---|---|
| `wireguard_server_form_view_model.dart` | `_existingServer` |
| `wireguard_peer_form_view_model.dart` | `_existingPeerUuid` |
| `openvpn_instance_form_view_model.dart` | `_vpnid` |
| `openvpn_client_override_form_view_model.dart` | `_uuid` |
| `openvpn_static_key_form_view_model.dart` | `_keyid` |

The convention should be `_existingUuid` (nullable `String?`) across all form ViewModels,
with a single `bool get isEditing => _existingUuid != null;` getter. This is already the
pattern in `wireguard_server_form_view_model.dart` (closest to the target). The `isEditing`
getter exists on most VMs but is computed differently or named differently across them.

**Evidence:**
- `openvpn_instance_form_view_model.dart` line 26: `final String? _vpnid;`
- `openvpn_client_override_form_view_model.dart` line 26: `final String _uuid;` (non-nullable,
  uses `_uuid ?? ''` anti-pattern in `saveOverride()`)
- `openvpn_static_key_form_view_model.dart` line 26: `final String? _keyid;`
- `wireguard_peer_form_view_model.dart` line 28: `String? _existingPeerUuid;`
- `wireguard_server_form_view_model.dart` line 28: `WireGuardServer? _existingServer;`
  (different: stores full object, not just UUID)

**Expected Outcomes:**
- All form ViewModels that store only a UUID/identifier adopt `String? _existingUuid`
- `openvpn_client_override_form_view_model.dart` changes `_uuid` from non-nullable `String`
  to nullable `String?`, removing the `?? ''` anti-pattern in `saveOverride()`
- `isEditing` getter standardised to `bool get isEditing => _existingUuid != null;` on all
  UUID-based form VMs
- `wireguard_server_form_view_model.dart` retains its `WireGuardServer?` pattern since it
  stores the full object (not just a UUID) for pre-population; its `isEditing` getter is
  already correct
- All constructor parameters and screen call sites updated to pass the renamed field

**Todo List:**
1. Open `lib/viewmodels/openvpn_instance_form_view_model.dart`; rename `_vpnid` to
   `_existingUuid`; update constructor parameter name; update all internal usages
2. Open `lib/viewmodels/openvpn_client_override_form_view_model.dart`; change `_uuid` from
   `String` (non-nullable) to `String?`; remove all `?? ''` usages; add null check in
   `saveOverride()` before using the UUID
3. Open `lib/viewmodels/openvpn_static_key_form_view_model.dart`; rename `_keyid` to
   `_existingUuid`; update all internal usages
4. Open `lib/viewmodels/wireguard_peer_form_view_model.dart`; rename `_existingPeerUuid`
   to `_existingUuid`
5. For each changed ViewModel, verify the corresponding form screen still compiles
   (constructor call sites pass the UUID as a named or positional parameter that matches)
6. Run `flutter analyze`

**Relevant Context:**
- `lib/screens/openvpn_instance_form_screen.dart` — creates `OpenvpnInstanceFormViewModel`
- `lib/screens/openvpn_client_override_form_screen.dart`
- `lib/screens/openvpn_static_key_form_screen.dart`
- `lib/screens/wireguard_peer_form_screen.dart`

---

### Sub-Task C.3 — Fix `searchQuery2` Name Collision in `OpenvpnInstancesViewModel`
**Status:** [x] done

**Intent:**
`lib/viewmodels/openvpn_instances_view_model.dart` declares a property named `searchQuery2`
(line ~35) alongside the inherited `searchQuery` from `BaseListViewModel`. The `searchQuery2`
was added to support a secondary search dimension without realising it shadows the base class
property. Having two similarly-named search properties with undocumented semantics is confusing
and increases the risk of bugs where the wrong query is used for filtering.

The correct solution depends on what `searchQuery2` actually filters (verified by reading the
file): if it filters on a different field (e.g. description vs. name), rename it to a
descriptive field-specific name; if it is a duplicate, delete it.

**Evidence:**
- `openvpn_instances_view_model.dart` line ~35: `String searchQuery2` — exists alongside
  base class `searchQuery`
- Both properties appear to filter items in `matchesFilter()` override

**Expected Outcomes:**
- `searchQuery2` renamed to a semantically meaningful name (e.g. `_descriptionFilter` or
  `_roleFilter`) that clearly communicates what dimension it filters
- All internal usages updated; `setSearchQuery2()` method renamed accordingly
- Consuming screen (`openvpn_instances_list_screen.dart`) updated to call the renamed method
- `flutter analyze` passes

**Todo List:**
1. Read `lib/viewmodels/openvpn_instances_view_model.dart` in full to confirm what
   `searchQuery2` filters
2. Choose a descriptive name (e.g. `_descriptionSearchQuery` or keep as `_roleFilter` if
   it mirrors `roleFilter`)
3. Rename the field, getter, and setter throughout the ViewModel
4. Update call sites in `lib/screens/openvpn_instances_list_screen.dart`
5. Run `flutter analyze`

**Relevant Context:**
- `lib/viewmodels/base/base_list_view_model.dart` line 27 — `_searchQuery` is the base field
- `lib/screens/openvpn_instances_list_screen.dart` — consuming screen

---

### Sub-Task C.4 — Standardise Toggle-Safety Pattern Across List ViewModels
**Status:** [x] done

**Intent:**
List ViewModels that support toggling items (enable/disable) use a `Set<String>` to prevent
double-tap race conditions — once a toggle is in-flight, the UUID is added to the Set; when
done, it is removed. This pattern is used in `wireguard_servers_view_model.dart`,
`wireguard_peers_view_model.dart`, and `firewall_aliases_view_model.dart`, but is missing in
`openvpn_instances_view_model.dart` which also supports toggle. Additionally, the `rethrow`
in `wireguard_peers_view_model.dart` toggle catch block is inconsistent with all other
ViewModels that catch and absorb toggle errors silently.

**Evidence:**
- `wireguard_servers_view_model.dart` line 26: `final Set<String> _togglingServers = {};`
  → present ✓
- `wireguard_peers_view_model.dart` line 26: `final Set<String> _togglingPeers = {};`
  → present ✓, but line 75 has `rethrow` which no other VM does
- `firewall_aliases_view_model.dart` line 26: `final Set<String> _togglingAliases = {};`
  → present ✓
- `openvpn_instances_view_model.dart`: no toggle-safety Set found — toggle can be called
  concurrently on the same item

**Expected Outcomes:**
- `openvpn_instances_view_model.dart` gains `final Set<String> _togglingInstances = {};`
  with early-return guard at the start of `toggleInstance()`
- `wireguard_peers_view_model.dart` toggle error path: `rethrow` removed, replaced with
  consistent silent catch pattern matching other ViewModels (the error is already visible
  via SnackBar in the screen)
- All four ViewModels exhibit identical toggle-safety structure

**Todo List:**
1. Open `lib/viewmodels/openvpn_instances_view_model.dart`
2. Add `final Set<String> _togglingInstances = {};`
3. At the start of `toggleInstance(uuid)`: add guard
   `if (_togglingInstances.contains(uuid)) return;`
   `_togglingInstances.add(uuid);`
4. In the `finally` block: add `_togglingInstances.remove(uuid);`
5. Open `lib/viewmodels/wireguard_peers_view_model.dart`
6. Remove the `rethrow` statement from the toggle catch block
7. Run `flutter analyze`

**Relevant Context:**
- `lib/viewmodels/wireguard_servers_view_model.dart` lines 26–59 — reference implementation
- `lib/viewmodels/firewall_aliases_view_model.dart` lines 26–60 — reference implementation

---

## Phase D — Hardcoded Value Extraction

### Sub-Task D.1 — Extract Remaining Hardcoded Domain Constants
**Status:** [x] done

**Intent:**
Several hardcoded values remain in screens and ViewModels that should be in `AppConstants`
or domain-specific constant classes. These are not covered by any prior sub-task:

1. `'https://login.tailscale.com'` in `tailscale_auth_view_model.dart:28` → `AppConstants`
   (partially addressed in A.4 but listed here for completeness if A.4 is not executed first)
2. `'51820'` (default WireGuard port) in `wireguard_server_form_screen.dart:80` and
   `wireguard_peer_form_screen.dart:76` → `AppConstants.defaultWireGuardPort`
3. Alias type string list in `firewall_aliases_screen.dart:42–57` (14 hardcoded alias type
   strings: `'host'`, `'network'`, `'port'`, etc.) → `FirewallConstants` class or `AliasType`
   sealed class / const list

**Evidence:**
- `wireguard_server_form_screen.dart` line 80: `hintText: '51820'`
- `wireguard_peer_form_screen.dart` line 76: `hintText: '51820'`
- `firewall_aliases_screen.dart` lines 42–57: `static const List<String> _allAliasTypes = ['host', 'network', ...]`

**Expected Outcomes:**
- `AppConstants.defaultWireGuardPort = 51820` (int) added to `lib/utils/constants.dart`
- Both screen hintText references updated to `'${AppConstants.defaultWireGuardPort}'`
- `_allAliasTypes` list moved to `lib/constants/firewall_constants.dart` as
  `FirewallConstants.aliasTypes`; `firewall_aliases_screen.dart` references it there
- `AppConstants.tailscaleLoginServer` added (if not already done in A.4)

**Todo List:**
1. Open `lib/utils/constants.dart`; add `static const int defaultWireGuardPort = 51820;`
   and `static const String tailscaleLoginServer = 'https://login.tailscale.com';`
2. Create `lib/constants/firewall_constants.dart` with:
   ```dart
   class FirewallConstants {
     static const List<String> aliasTypes = [
       'host', 'network', 'port', 'url', 'urltable', 'urljson', 'geoip',
       'networkgroup', 'mac', 'asn', 'dynipv6host', 'authgroup', 'internal', 'external',
     ];
   }
   ```
3. In `firewall_aliases_screen.dart`: remove `_allAliasTypes` static const; import
   `firewall_constants.dart`; replace every reference to `_allAliasTypes` with
   `FirewallConstants.aliasTypes`
4. In `wireguard_server_form_screen.dart` and `wireguard_peer_form_screen.dart`:
   replace `'51820'` hintText with `'${AppConstants.defaultWireGuardPort}'`
5. In `tailscale_auth_view_model.dart` (if not already done in A.4):
   replace `'https://login.tailscale.com'` with `AppConstants.tailscaleLoginServer`
6. Run `flutter analyze`

**Relevant Context:**
- `lib/utils/constants.dart` — `AppConstants` class
- `lib/constants/api_endpoints.dart` — existing constants directory reference

---

## Phase E — Final Verification

### Sub-Task E.1 — Final Codebase Analysis Pass (Phase 2)
**Status:** [x] done

**Intent:**
After all Phase A–D sub-tasks complete, run a final full-project analysis to confirm no
regressions, no orphaned imports, and all targeted patterns have been resolved.

**Expected Outcomes:**
- `flutter analyze` reports zero errors and zero warnings
- Zero ViewModels extending `ChangeNotifier` directly while manually reimplementing base
  class properties (grep `extends ChangeNotifier` in `lib/viewmodels/` — all results
  should be `BaseFormViewModel` and `BaseListViewModel` themselves)
- No `_isLoading` or `_errorMessage` field declared outside the base classes
- No `setLoading(false)` inside a `catch` block without a corresponding `finally` block
- `searchQuery2` does not appear anywhere in the codebase
- `_togglingInstances` Set is present in `openvpn_instances_view_model.dart`
- `LoginViewModel` has a `statusMessage` property distinct from `errorMessage`
- `AppConstants.defaultWireGuardPort`, `AppConstants.tailscaleLoginServer` constants exist
- `FirewallConstants.aliasTypes` constant exists

**Todo List:**
1. Run `flutter analyze` — resolve any remaining issues
2. Run: `grep -r "extends ChangeNotifier" lib/viewmodels/` — verify only base classes remain
3. Run: `grep -rn "_isLoading\s*=\s*false" lib/viewmodels/` — verify all occurrences are
   inside `finally` blocks or inside the two base class files
4. Run: `grep -rn "searchQuery2" lib/` — verify zero matches
5. Run: `grep -rn "rethrow" lib/viewmodels/` — verify zero matches in toggle methods
6. Confirm `login_view_model.dart` has `statusMessage` getter
7. Run `flutter test` — confirm all existing tests pass
8. Run `flutter build apk --release` to confirm clean release build

---

## Appendix: Net-New Issue Registry (Phase 2 Audit)

| ID | Sev | Category | Description | File | Sub-Task |
|----|-----|----------|-------------|------|----------|
| A1 | HIGH | Architecture | `DashboardViewModel` extends `ChangeNotifier` directly, duplicates base boilerplate | `dashboard_view_model.dart:26` | A.1 |
| A2 | HIGH | Architecture | `SystemInfoViewModel` extends `ChangeNotifier` directly | `system_info_view_model.dart:24` | A.2 |
| A3 | HIGH | Architecture | `TailscaleStatusViewModel` extends `ChangeNotifier` directly | `tailscale_status_view_model.dart:25` | A.3 |
| A4 | HIGH | Architecture | `TailscaleAuthViewModel` extends `ChangeNotifier` directly | `tailscale_auth_view_model.dart:24` | A.4 |
| A5 | HIGH | Architecture | `WireGuardStatusViewModel` extends `ChangeNotifier` directly | `wireguard_status_view_model.dart:26` | A.5 |
| B1 | MED | Async | `setLoading(false)` in both `try` and `catch` instead of `finally` (6 VMs) | `openvpn_instance_form_view_model.dart`, `openvpn_client_override_form_view_model.dart`, `openvpn_static_key_form_view_model.dart`, `wireguard_server_form_view_model.dart`, `wireguard_peer_form_view_model.dart` | B.1 |
| B2 | MED | Async | `notifyListeners()` called before and after async in same method (2 VMs) | `wireguard_server_form_view_model.dart:52`, `wireguard_peer_form_view_model.dart:52` | B.2 |
| B3 | MED | Async | `Future.wait([...])` with no per-future error handler | `tailscale_status_view_model.dart:46` | A.3 |
| C1 | HIGH | Semantics | `setError()` used for progress/success messages in `LoginViewModel` | `login_view_model.dart:88,182` | C.1 |
| C2 | MED | Naming | `_vpnid` field should be `_existingUuid` | `openvpn_instance_form_view_model.dart:26` | C.2 |
| C3 | MED | Naming | `_uuid` non-nullable with `?? ''` anti-pattern | `openvpn_client_override_form_view_model.dart:26` | C.2 |
| C4 | MED | Naming | `_keyid` should be `_existingUuid` | `openvpn_static_key_form_view_model.dart:26` | C.2 |
| C5 | MED | Naming | `_existingPeerUuid` should be `_existingUuid` | `wireguard_peer_form_view_model.dart:28` | C.2 |
| C6 | MED | Naming | `searchQuery2` shadows base class `searchQuery` | `openvpn_instances_view_model.dart:~35` | C.3 |
| C7 | MED | Consistency | Toggle-safety `Set<String>` missing from `openvpn_instances_view_model.dart` | `openvpn_instances_view_model.dart` | C.4 |
| C8 | LOW | Consistency | `rethrow` in toggle catch block inconsistent with all other toggle VMs | `wireguard_peers_view_model.dart:75` | C.4 |
| D1 | MED | Constants | `'https://login.tailscale.com'` hardcoded | `tailscale_auth_view_model.dart:28` | A.4 / D.1 |
| D2 | MED | Constants | `'51820'` WireGuard default port hardcoded in 2 form screens | `wireguard_server_form_screen.dart:80`, `wireguard_peer_form_screen.dart:76` | D.1 |
| D3 | MED | Constants | Alias type string list hardcoded in screen | `firewall_aliases_screen.dart:42–57` | D.1 |
