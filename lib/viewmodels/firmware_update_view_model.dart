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

import '../models/firmware_update_status.dart';
import '../services/demo_api_service.dart';
import 'base/base_form_view_model.dart';

/// ViewModel for the Firmware Update screen.
///
/// Orchestrates the check-for-updates and perform-update flows:
///
/// Check flow:
/// 1. Trigger the check via `/api/core/firmware/check`.
/// 2. Poll `/api/core/firmware/upgradestatus` until `status == "done"`.
/// 3. Fetch the full status and optional changelog.
///
/// Update flow:
/// 1. Trigger the update via `/api/core/firmware/update`.
/// 2. Poll `/api/core/firmware/upgradestatus` until `status == "reboot"`.
class FirmwareUpdateViewModel extends BaseFormViewModel {
  final DemoApiService _apiService;

  FirmwareUpdateStatus? _firmwareStatus;
  String? _checkLog;
  bool _isChecking = false;
  bool _isUpdating = false;
  bool _updateRequiresReboot = false;
  bool _isUpdateComplete = false;
  bool _cancelled = false;

  FirmwareUpdateStatus? get firmwareStatus => _firmwareStatus;
  String? get checkLog => _checkLog;
  bool get isChecking => _isChecking;
  bool get isUpdating => _isUpdating;
  bool get updateRequiresReboot => _updateRequiresReboot;
  bool get isUpdateComplete => _isUpdateComplete;

  FirmwareUpdateViewModel(this._apiService);

  Future<void> checkForUpdates() async {
    _cancelled = false;
    _firmwareStatus = null;
    _checkLog = null;
    _isChecking = true;
    setLoading(true);
    clearError();

    try {
      // Step 1: Trigger the firmware check.
      final checkResult = await _apiService.triggerFirmwareCheck();
      if (checkResult['status'] != 'ok') {
        throw Exception('Firmware check failed: ${checkResult['status']}');
      }

      // Step 2: Poll upgradestatus until done (max 30 iterations ≈ 45 s).
      const maxPolls = 30;
      int polls = 0;
      while (polls < maxPolls) {
        if (_cancelled) return;
        final statusResult = await _apiService.getFirmwareUpgradeStatus();
        _checkLog = statusResult['log'] as String? ?? '';
        notifyListeners();
        if (statusResult['status'] == 'done') break;
        polls++;
        if (polls >= maxPolls) throw Exception('Firmware check timed out');
        await Future.delayed(const Duration(milliseconds: 1500));
      }

      if (_cancelled) return;

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
        setLoading(false);
      }
    }
  }

  /// Perform the actual firmware upgrade.
  ///
  /// Flow:
  /// 1. POST `/api/core/firmware/update` to trigger the upgrade.
  /// 2. Poll `/api/core/firmware/upgradestatus` every 1.5 s until
  ///    `status == "reboot"` (or `"done"`), with a 300-iteration timeout
  ///    (≈ 7.5 min) to accommodate large updates.
  Future<void> performUpdate() async {
    _cancelled = false;
    _isUpdating = true;
    _updateRequiresReboot = false;
    _isUpdateComplete = false;
    _checkLog = null;
    setLoading(true);
    clearError();

    try {
      // Step 1: Trigger the firmware update.
      await _apiService.triggerFirmwareUpdate();

      // Step 2: Poll upgradestatus until terminal state (max 300 ≈ 7.5 min).
      const maxPolls = 300;
      int polls = 0;
      while (polls < maxPolls) {
        if (_cancelled) return;
        final statusResult = await _apiService.getFirmwareUpgradeStatus();
        _checkLog = statusResult['log'] as String? ?? '';
        notifyListeners();

        final status = statusResult['status'] as String? ?? '';
        if (status == 'reboot') {
          if (!_cancelled) _updateRequiresReboot = true;
          break;
        }
        if (status == 'done') break;

        polls++;
        if (polls >= maxPolls) throw Exception('Firmware update timed out');
        await Future.delayed(const Duration(milliseconds: 1500));
      }

      if (_cancelled) return;
      _isUpdateComplete = true;
    } catch (e) {
      if (!_cancelled) setError(e.toString());
    } finally {
      if (!_cancelled) {
        _isUpdating = false;
        setLoading(false);
      }
    }
  }

  @override
  void dispose() {
    _cancelled = true;
    super.dispose();
  }
}
