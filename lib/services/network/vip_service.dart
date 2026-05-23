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

import 'package:dio/dio.dart';
import '../base/base_opnsense_service.dart';
import '../base/api_exception.dart';

/// Model for CARP VIP option
class CarpVipOption {
  final String vhid;
  final String displayName;

  CarpVipOption({
    required this.vhid,
    required this.displayName,
  });

  @override
  String toString() => displayName;
}

/// Service for Virtual IP (VIP) operations
class VipService extends BaseOPNsenseService {
  /// Get CARP VIP options from the VIP settings API
  /// Endpoint: GET /interfaces/vip_settings/get_item/
  /// Returns: List of CARP VIP options with VHID and display names
  Future<List<CarpVipOption>> getCarpVipOptions() async {
    ensureInitialized();

    try {
      final response = await dio.get('/interfaces/vip_settings/get_item/');
      
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final List<CarpVipOption> carpOptions = [];
        
        // The response contains a 'vip' object with form metadata
        if (data.containsKey('vip') && data['vip'] is Map<String, dynamic>) {
          final vipData = data['vip'] as Map<String, dynamic>;
          
          // Look for the 'vhid' field which contains CARP VHID options
          if (vipData.containsKey('vhid') && vipData['vhid'] is Map<String, dynamic>) {
            final vhidField = vipData['vhid'] as Map<String, dynamic>;
            
            // Iterate through the vhid options
            for (var entry in vhidField.entries) {
              final key = entry.key;
              final value = entry.value;
              
              // Each option is a map with 'value' (display name) and optionally 'selected'
              if (value is Map<String, dynamic> && value.containsKey('value')) {
                final displayName = value['value'].toString();
                
                // Only add if this is a valid VHID entry (numeric key)
                if (int.tryParse(key) != null) {
                  carpOptions.add(CarpVipOption(
                    vhid: key,
                    displayName: displayName,
                  ));
                }
              }
            }
          }
          
          // Alternative: Check if there's a 'mode' field to filter CARP entries
          // Some APIs might structure data differently with mode information
          if (vipData.containsKey('mode') && vipData['mode'] is Map<String, dynamic>) {
            final modeField = vipData['mode'] as Map<String, dynamic>;
            
            // Look for 'carp' mode entries
            for (var entry in modeField.entries) {
              if (entry.value is Map<String, dynamic>) {
                final modeData = entry.value as Map<String, dynamic>;
                if (modeData['value']?.toString().toLowerCase() == 'carp') {
                  // This confirms CARP mode is available
                  break;
                }
              }
            }
          }
        }
        
        return carpOptions;
      } else {
        throw ApiException('Failed to get VIP settings', response.statusCode);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }
}


