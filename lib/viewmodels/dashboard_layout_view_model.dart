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

import 'package:flutter/foundation.dart';

import '../models/dashboard_layout.dart';
import '../services/dashboard/dashboard_layout_service.dart';
import '../services/profile_service.dart';

/// Manages dashboard layout state — card order, visibility, and interface
/// selection — independently of data-loading concerns in [DashboardViewModel].
class DashboardLayoutViewModel extends ChangeNotifier {
  final DashboardLayoutService _layoutService;
  final ProfileService _profileService;

  DashboardLayout _layout = DashboardLayout.defaults();
  bool _isEditMode = false;
  String? _profileId;

  DashboardLayoutViewModel(this._layoutService, this._profileService);

  DashboardLayout get layout => _layout;
  bool get isEditMode => _isEditMode;

  /// All cards, including hidden ones (for edit mode).
  List<DashboardCardConfig> get allCards => _layout.cards;

  /// Only visible cards (for normal display mode).
  List<DashboardCardConfig> get visibleCards => _layout.visibleCards;

  /// Loads the layout for the active profile.
  Future<void> loadLayout() async {
    _profileId = await _profileService.getActiveProfileId();
    final id = _profileId ?? 'default';
    _layout = await _layoutService.loadLayout(id);
    notifyListeners();
  }

  /// Toggles between edit and normal mode.
  void toggleEditMode() {
    _isEditMode = !_isEditMode;
    notifyListeners();
  }

  /// Shows or hides the card identified by [type].
  Future<void> setCardVisible(DashboardCardType type, bool visible) async {
    final card = _layout.cards.firstWhere((c) => c.type == type);
    _layout = _layout.copyWithUpdatedCard(card.copyWith(isVisible: visible));
    notifyListeners();
    await _persist();
  }

  /// Changes the monitored interface for a network card.
  Future<void> setCardInterface(DashboardCardType type, String interface) async {
    final card = _layout.cards.firstWhere((c) => c.type == type);
    _layout = _layout.copyWithUpdatedCard(
      card.copyWith(selectedInterface: interface),
    );
    notifyListeners();
    await _persist();
  }

  /// Reorders cards — called by [ReorderableListView.onReorder].
  Future<void> reorderCards(int oldIndex, int newIndex) async {
    _layout = _layout.copyWithReorder(oldIndex, newIndex);
    notifyListeners();
    await _persist();
  }

  Future<void> _persist() async {
    final id = _profileId ?? 'default';
    await _layoutService.saveLayout(id, _layout);
  }
}
