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

import '../models/profile.dart';
import '../services/settings/profile_manager_service.dart';
import 'base/base_list_view_model.dart';

/// ViewModel for the Profile Management screen
class ProfileManagementViewModel extends BaseListViewModel<Profile> {
  final ProfileManagerService _profileManager;

  String? _activeProfileId;
  String? get activeProfileId => _activeProfileId;

  ProfileManagementViewModel(this._profileManager);

  @override
  Future<List<Profile>> fetchItems() async {
    final profiles = await _profileManager.loadProfiles();
    _activeProfileId = await _profileManager.getActiveProfileId();
    return profiles;
  }

  @override
  bool matchesFilter(Profile profile, String query) {
    final lower = query.toLowerCase();
    return profile.name.toLowerCase().contains(lower) ||
        profile.connections.any((c) => c.host.toLowerCase().contains(lower));
  }
}
