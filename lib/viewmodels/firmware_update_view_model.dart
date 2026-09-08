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

import 'dart:async';

import '../models/firmware_update_status.dart';
import '../services/base/api_exception.dart';
import '../services/demo_api_service.dart';
import 'base/base_form_view_model.dart';

/// ViewModel for the Firmware Update screen.
///
/// Orchestrates the check-for-updates and perform-update flows:
///
/// Check flow:
/// 1. Trigger the check via `/api/core/firmware/check`.
/// 2. Poll `/api/core/firmware/upgradestatus` until `status == "done"`.
///    If `status == "running"` is detected (an upgrade was already in progress),
///    transparently switch into watch mode and wait for it to complete.
/// 3. Fetch the full status and optional changelog.
///
/// Update flow:
/// 1. Trigger the update via `/api/core/firmware/update`.
/// 2. Poll `/api/core/firmware/upgradestatus` every 500 ms until
///    `status == "reboot"` or `"done"`, with a 900-iteration timeout
///    (≈ 7.5 min) to accommodate large updates.
class FirmwareUpdateViewModel extends BaseFormViewModel {
  final DemoApiService _apiService;

  FirmwareUpdateStatus? _firmwareStatus;
  String? _checkLog;
  bool _isChecking = false;
  bool _isUpdating = false;
  bool _isExternalUpdateRunning = false;
  bool _updateRequiresReboot = false;
  bool _isUpdateComplete = false;
  // Set to true after a successful performUpdate(); cleared by checkForUpdates().
  // Suppresses the "Install Updates" button until a fresh check is run.
  bool _updateJustCompleted = false;
  bool _isWaitingForReboot = false;
  bool _isBackOnline = false;
  bool _cancelled = false;

  FirmwareUpdateStatus? get firmwareStatus => _firmwareStatus;
  String? get checkLog => _checkLog;
  bool get isChecking => _isChecking;
  bool get isUpdating => _isUpdating;
  /// True when checkForUpdates() discovered an already-running upgrade and
  /// switched into watch mode. Used to display the correct log title.
  bool get isExternalUpdateRunning => _isExternalUpdateRunning;
  bool get updateRequiresReboot => _updateRequiresReboot;
  bool get isUpdateComplete => _isUpdateComplete;
  bool get updateJustCompleted => _updateJustCompleted;
  /// True while polling for the firewall to come back after a reboot.
  bool get isWaitingForReboot => _isWaitingForReboot;
  /// True once the firewall responds successfully after a reboot.
  bool get isBackOnline => _isBackOnline;

  FirmwareUpdateViewModel(this._apiService);

  Future<void> checkForUpdates() async {
    _cancelled = false;
    _firmwareStatus = null;
    _checkLog = null;
    _isChecking = true;
    _isExternalUpdateRunning = false;
    _updateJustCompleted = false;
    _isUpdateComplete = false;
    _isWaitingForReboot = false;
    _isBackOnline = false;
    setLoading(true);
    clearError();

    try {
      // Step 1: Trigger the firmware check.
      final checkResult = await _apiService.triggerFirmwareCheck();
      if (checkResult['status'] != 'ok') {
        throw Exception('Firmware check failed: ${checkResult['status']}');
      }

      // Step 2: Poll upgradestatus until done.
      //
      // OPNsense status values during a normal check:   running → done  (<10 s)
      // OPNsense status values during an active upgrade: running → reboot
      //
      // A normal check completes well within 15 s. If "running" persists
      // beyond maxCheckPolls (10 × 1.5 s ≈ 15 s) without reaching "done",
      // an upgrade was already in flight — switch to watch mode instead of
      // timing out. A real network failure throws an exception, not a response.
      const maxCheckPolls = 10;
      int polls = 0;
      bool checkExhausted = false;
      while (polls < maxCheckPolls) {
        if (_cancelled) return;
        final statusResult = await _apiService.getFirmwareUpgradeStatus();
        _checkLog = statusResult['log'] as String? ?? '';
        notifyListeners();

        final status = statusResult['status'] as String? ?? '';

        if (status == 'done') break;
        if (status == 'reboot') {
          // Unexpected during a check — treat as external upgrade completing.
          _updateRequiresReboot = true;
          checkExhausted = true;
          break;
        }

        polls++;
        if (polls >= maxCheckPolls) {
          // Still "running" after ~15 s — an upgrade must already be running.
          // Switch to watch mode below.
          checkExhausted = true;
          break;
        }
        await Future.delayed(const Duration(milliseconds: 1500));
      }

      // Still "running" after the check window — watch the active upgrade.
      if (checkExhausted && !_cancelled) {
        _isExternalUpdateRunning = true;
        _isChecking = false;
        _isUpdating = true;
        notifyListeners();

        // Poll until the upgrade reaches a terminal state — no iteration cap.
        while (true) {
          if (_cancelled) return;
          try {
            final statusResult = await _apiService.getFirmwareUpgradeStatus();
            _checkLog = statusResult['log'] as String? ?? '';
            notifyListeners();

            final status = statusResult['status'] as String? ?? '';
            final logIndicatesReboot = _checkLog?.contains('***REBOOT***') ?? false;

            if (status == 'reboot' || logIndicatesReboot) {
              _updateRequiresReboot = true;
              break;
            }
            if (status == 'done') break;
          } on ApiException catch (e) {
            if (e.errorType == ApiErrorType.networkError) {
              // Connection dropped mid-upgrade. Only treat as a reboot if the
              // log already contains the reboot marker — otherwise it is a
              // transient web-server restart during package extraction; retry.
              if (_checkLog?.contains('***REBOOT***') ?? false) {
                _updateRequiresReboot = true;
                break;
              }
              await Future.delayed(const Duration(milliseconds: 1500));
              continue;
            }
            rethrow;
          }
          await Future.delayed(const Duration(milliseconds: 500));
        }
      }

      // Drain final log snapshot so the last lines are never missed.
      // If the system already rebooted, this call may fail with a connection
      // error — ignore it and keep whatever log we already have.
      if (!_cancelled) {
        try {
          final finalStatus = await _apiService.getFirmwareUpgradeStatus();
          _checkLog = finalStatus['log'] as String? ?? _checkLog;
          notifyListeners();
        } on ApiException catch (e) {
          if (e.errorType != ApiErrorType.networkError) rethrow;
        }
      }

      if (_cancelled) return;

      // If we were watching an external update, finish as update-complete.
      if (_isExternalUpdateRunning) {
        _isUpdateComplete = true;
        if (_updateRequiresReboot) {
          unawaited(_waitForFirewallOnline());
        }
        return;
      }

      // Step 3: Fetch the full firmware status.
      final statusData = await _apiService.getFirmwareStatus();
      if (_cancelled) return;

      final product = statusData['product'] as Map<String, dynamic>? ?? {};
      final currentVersion = product['product_version'] as String? ?? '';
      final latestVersion =
          product['product_latest'] as String? ?? currentVersion;

      final rawUpgrade = statusData['upgrade_packages'] as List? ?? [];
      final upgradePackages = rawUpgrade.map((e) {
        final m = e as Map<String, dynamic>;
        return <String, String>{
          'name': m['name'] as String? ?? '',
          'current_version': m['current_version'] as String? ?? '',
          'new_version': m['new_version'] as String? ?? '',
        };
      }).toList();

      final rawNew = statusData['new_packages'] as List? ?? [];
      final newPackages = rawNew.map((e) {
        final m = e as Map<String, dynamic>;
        return <String, String>{
          'name': m['name'] as String? ?? '',
          'version': m['version'] as String? ?? '',
        };
      }).toList();

      final needsReboot = statusData['needs_reboot'] == '1';
      final downloadSize = statusData['download_size'] as String? ?? '';
      final lastCheck = statusData['last_check'] as String? ?? '';

      // Step 4: Fetch changelog when updates are available (optional).
      String? changelogText;
      String? changelogDate;
      if (upgradePackages.isNotEmpty || newPackages.isNotEmpty) {
        if (_cancelled) return;
        try {
          final changelogData =
              await _apiService.getFirmwareChangelog(latestVersion);
          final html = changelogData['html'] as String? ?? '';
          changelogText = html.replaceAll(RegExp(r'<[^>]*>'), '').trim();
          changelogDate = changelogData['date'] as String?;
        } catch (_) {
          // Changelog is optional — ignore failures.
        }
      }

      if (_cancelled) return;

      _firmwareStatus = FirmwareUpdateStatus(
        currentVersion: currentVersion,
        latestVersion: latestVersion,
        updatesAvailable:
            upgradePackages.isNotEmpty || newPackages.isNotEmpty,
        needsReboot: needsReboot,
        downloadSize: downloadSize,
        lastCheck: lastCheck,
        upgradeCount: upgradePackages.length,
        newPackageCount: newPackages.length,
        upgradePackages: upgradePackages,
        newPackages: newPackages,
        changelogText: changelogText,
        changelogDate: changelogDate,
      );
    } catch (e) {
      if (!_cancelled) setError(e.toString());
    } finally {
      if (!_cancelled) {
        _isChecking = false;
        // isUpdating may have been set in watch mode — clear it here too.
        _isUpdating = false;
        setLoading(false);
      }
    }
  }

  /// Perform the actual firmware upgrade.
  ///
  /// Flow:
  /// 1. POST `/api/core/firmware/update` to trigger the upgrade.
  /// 2. Poll `/api/core/firmware/upgradestatus` every 500 ms until
  ///    `status == "reboot"` (or `"done"`), with a 900-iteration timeout
  ///    (≈ 7.5 min) to accommodate large updates.
  Future<void> performUpdate() async {
    _cancelled = false;
    _isUpdating = true;
    _isExternalUpdateRunning = false;
    _updateRequiresReboot = false;
    _isUpdateComplete = false;
    _checkLog = null;
    setLoading(true);
    clearError();

    try {
      // Step 1: Trigger the firmware update.
      await _apiService.triggerFirmwareUpdate();

      // Step 2: Poll upgradestatus until terminal state (max 900 × 500 ms ≈ 7.5 min).
      // Terminal conditions (either is sufficient):
      //   • API status field == "reboot" or "done"
      //   • Log text contains "***REBOOT***" (reliable even if the status
      //     field flips back before the next poll)
      const maxPolls = 900;
      int polls = 0;
      while (polls < maxPolls) {
        if (_cancelled) return;
        try {
          final statusResult = await _apiService.getFirmwareUpgradeStatus();
          _checkLog = statusResult['log'] as String? ?? '';
          notifyListeners();

          final status = statusResult['status'] as String? ?? '';
          final logIndicatesReboot = _checkLog?.contains('***REBOOT***') ?? false;

          if (status == 'reboot' || logIndicatesReboot) {
            _updateRequiresReboot = true;
            break;
          }
          if (status == 'done') break;
        } on ApiException catch (e) {
          if (e.errorType == ApiErrorType.networkError) {
            // Connection dropped mid-upgrade. Only treat as a reboot if the
            // log already contains the reboot marker — otherwise it is a
            // transient web-server restart during package extraction; retry.
            if (_checkLog?.contains('***REBOOT***') ?? false) {
              _updateRequiresReboot = true;
              break;
            }
            await Future.delayed(const Duration(milliseconds: 1500));
            continue;
          }
          rethrow;
        }

        polls++;
        if (polls >= maxPolls) throw Exception('Firmware update timed out');
        await Future.delayed(const Duration(milliseconds: 500));
      }

      // Drain final log snapshot to capture the last lines (e.g. "Rebooting now").
      // Ignore connection errors — the firewall may already be going down.
      if (!_cancelled) {
        try {
          final finalStatus = await _apiService.getFirmwareUpgradeStatus();
          _checkLog = finalStatus['log'] as String? ?? _checkLog;
          notifyListeners();
        } on ApiException catch (e) {
          if (e.errorType != ApiErrorType.networkError) rethrow;
        }
      }

      if (_cancelled) return;
      _isUpdateComplete = true;
      _updateJustCompleted = true;
      // If a reboot was triggered, start polling for the firewall to come back.
      if (_updateRequiresReboot) {
        unawaited(_waitForFirewallOnline());
      }
    } catch (e) {
      if (!_cancelled) setError(e.toString());
    } finally {
      if (!_cancelled) {
        _isUpdating = false;
        setLoading(false);
      }
    }
  }

  /// Polls `getFirmwareStatus` until the firewall responds, indicating it has
  /// come back online after a reboot. Updates [isWaitingForReboot] and
  /// [isBackOnline] so the UI can reflect each phase.
  Future<void> _waitForFirewallOnline() async {
    _isWaitingForReboot = true;
    notifyListeners();

    // Wait a minimum of 15 s before the first probe — the firewall needs time
    // to fully shut down before we start polling.
    await Future.delayed(const Duration(seconds: 15));

    while (!_cancelled) {
      try {
        await _apiService.getFirmwareStatus();
        // Got a valid response — firewall is back.
        if (!_cancelled) {
          _isWaitingForReboot = false;
          _isBackOnline = true;
          notifyListeners();
        }
        return;
      } on ApiException catch (e) {
        // Any network/connection error means still offline — keep polling.
        if (e.errorType != ApiErrorType.networkError &&
            e.errorType != ApiErrorType.timeout) {
          // Unexpected error type — stop waiting silently.
          if (!_cancelled) {
            _isWaitingForReboot = false;
            notifyListeners();
          }
          return;
        }
      } catch (_) {
        // Swallow any other error and keep trying.
      }
      await Future.delayed(const Duration(seconds: 5));
    }
  }

  @override
  void dispose() {
    _cancelled = true;
    super.dispose();
  }
}
