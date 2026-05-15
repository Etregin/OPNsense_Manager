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

import 'package:uuid/uuid.dart';
import '../models/opnsense_config.dart';
import '../models/profile.dart';
import '../models/dhcp_server_type.dart';
import '../services/profile_service.dart';
import '../services/demo_api_service.dart';
import '../services/opnsense_api_service.dart';
import 'base/base_form_view_model.dart';

/// ViewModel for login/profile management screen
class LoginViewModel extends BaseFormViewModel {
  final ProfileService _profileService;
  final DemoApiService _demoApiService;
  final OPNsenseApiService _opnsenseApiService;
  final Profile? _existingProfile;

  bool get isEditing => _existingProfile != null;
  Profile? get existingProfile => _existingProfile;

  LoginViewModel({
    required ProfileService profileService,
    required DemoApiService demoApiService,
    required OPNsenseApiService opnsenseApiService,
    Profile? existingProfile,
  })  : _profileService = profileService,
        _demoApiService = demoApiService,
        _opnsenseApiService = opnsenseApiService,
        _existingProfile = existingProfile;

  /// Test connection and save profile
  Future<bool> testAndSaveConnection({
    required String name,
    required String host,
    required int port,
    required String apiKey,
    required String apiSecret,
    required bool useHttps,
    required bool allowSelfSignedCerts,
    required DhcpServerType dhcpServerType,
  }) async {
    final result = await executeWithLoading(() async {
      final config = OPNsenseConfig(
        host: host,
        port: port,
        apiKey: apiKey,
        apiSecret: apiSecret,
        useHttps: useHttps,
        allowSelfSignedCerts: allowSelfSignedCerts,
      );

      // Initialize API service
      _demoApiService.setDemoMode(false);
      _opnsenseApiService.init(config);

      // Test connection
      final isConnected = await _demoApiService.testConnection();

      if (!isConnected) {
        setError('Connection failed');
        return false;
      }

      // Create or update profile
      final profile = _existingProfile != null
          ? _existingProfile.copyWith(
              name: name.isEmpty ? '$host:$port' : name,
              host: host,
              port: port,
              apiKey: apiKey,
              apiSecret: apiSecret,
              useHttps: useHttps,
              allowSelfSignedCerts: allowSelfSignedCerts,
              dhcpServerType: dhcpServerType,
              lastUsed: DateTime.now(),
            )
          : Profile(
              id: const Uuid().v4(),
              name: name.isEmpty ? '$host:$port' : name,
              host: host,
              port: port,
              apiKey: apiKey,
              apiSecret: apiSecret,
              useHttps: useHttps,
              allowSelfSignedCerts: allowSelfSignedCerts,
              dhcpServerType: dhcpServerType,
              createdAt: DateTime.now(),
              lastUsed: DateTime.now(),
            );

      await _profileService.saveProfile(profile);
      await _profileService.setActiveProfile(profile.id);

      return true;
    });
    
    return result ?? false;
  }
}

// Made with Bob
