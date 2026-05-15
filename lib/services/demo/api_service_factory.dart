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

import '../demo_api_service.dart';
import '../opnsense_api_service.dart';

/// Factory for creating API service instances
class ApiServiceFactory {
  /// Create a DemoApiService instance
  /// 
  /// This factory method ensures consistent creation of the service
  /// with proper initialization of dependencies.
  static DemoApiService createDemoApiService(OPNsenseApiService realApiService) {
    return DemoApiService(realApiService);
  }

  /// Create an OPNsenseApiService instance
  /// 
  /// This factory method can be extended to add initialization logic
  /// or dependency injection as needed.
  static OPNsenseApiService createOPNsenseApiService() {
    return OPNsenseApiService();
  }

  /// Create a complete API service stack
  /// 
  /// Creates both the real API service and the demo wrapper,
  /// returning the demo service which can switch between modes.
  static DemoApiService createApiServiceStack() {
    final realService = createOPNsenseApiService();
    return createDemoApiService(realService);
  }
}


