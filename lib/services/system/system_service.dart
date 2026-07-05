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
import 'package:dio/dio.dart';
import '../base/base_opnsense_service.dart';
import '../base/api_exception.dart';
import '../../models/system_info.dart';
import '../../models/thermal_sensor.dart';
import '../../constants/api_endpoints.dart';

/// Service for system-related operations
class SystemService extends BaseOPNsenseService {
  Future<Map<String, dynamic>> getSystemStatus() async {
    ensureInitialized();

    try {
      final response = await dio.get(ApiEndpoints.systemStatus);
      
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw ApiException('Failed to get system status', response.statusCode, ApiErrorType.unknown);
      }
    } on DioException catch (e) {
      if (e.response != null) {
      }
      throw handleDioError(e);
    }
  }

  /// Get system information (hostname, version, etc.)
  Future<Map<String, dynamic>> getSystemInformation() async {
    ensureInitialized();

    try {
      final response = await dio.get(ApiEndpoints.firmwareInfo);
      
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
    } catch (e) {
      debugPrint('[SystemService] Endpoint fallback: $e');
    }

    // Try alternative endpoints
    try {
      final response = await dio.get(ApiEndpoints.firmwareStatus);
      
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
    } catch (e) {
      debugPrint('[SystemService] Endpoint fallback: $e');
    }

    try {
      final response = await dio.get(ApiEndpoints.systemInfo);
      
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
    } catch (e) {
      debugPrint('[SystemService] Endpoint fallback: $e');
    }

    return {};
  }

  /// Get system activity (CPU, uptime)
  Future<Map<String, dynamic>> getSystemActivity() async {
    ensureInitialized();

    try {
      final response = await dio.get(ApiEndpoints.diagnosticsActivity);
      
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
    } catch (e) {
      debugPrint('[SystemService] Endpoint fallback: $e');
    }

    return {};
  }

  /// Get filesystem information
  Future<Map<String, dynamic>> getFilesystemInfo() async {
    ensureInitialized();

    // Try multiple endpoints for disk information
    try {
      final response = await dio.get(ApiEndpoints.diagnosticsSystemDisk);
      
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
    } catch (e) {
      debugPrint('[SystemService] Endpoint fallback: $e');
    }

    // Try alternative endpoint
    try {
      final response = await dio.get(ApiEndpoints.systemDisk);
      
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
    } catch (e) {
      debugPrint('[SystemService] Endpoint fallback: $e');
    }

    return {};
  }

  /// Get system resources (CPU, memory, uptime)
  Future<Map<String, dynamic>> getSystemResources() async {
    ensureInitialized();

    try {
      final response = await dio.get(ApiEndpoints.diagnosticsSystemResources);
      
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw ApiException('Failed to get system resources', response.statusCode, ApiErrorType.unknown);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Get complete system information
  Future<SystemInfo> getSystemInfo() async {
    final resourcesData = await getSystemResources();
    final systemInfoData = await getSystemInformation();
    final activityData = await getSystemActivity();
    final diskData = await getFilesystemInfo();

    // Extract firmware/system details from /api/core/firmware/info
    String type = 'opnsense';
    String version = 'Unknown';
    String architecture = 'amd64';
    String commit = '';
    String mirror = '';
    String repositories = '';
    String? updatedOn;
    
    // Extract from product map (from /core/firmware/status)
    if (systemInfoData.containsKey('product')) {
      final product = systemInfoData['product'] as Map<String, dynamic>?;
      if (product != null) {
        // Version from CORE_VERSION or product_version
        version = product['CORE_VERSION'] as String? ??
                 product['product_version'] as String? ??
                 'Unknown';
        
        // Type from CORE_PRODUCT or CORE_NAME
        type = product['CORE_PRODUCT'] as String? ??
               product['CORE_NAME'] as String? ??
               'opnsense';
        
        // Architecture from CORE_ARCH or product_arch
        architecture = product['CORE_ARCH'] as String? ??
                      product['product_arch'] as String? ??
                      'amd64';
        
        // Commit from CORE_HASH or product_hash
        commit = product['CORE_HASH'] as String? ??
                product['product_hash'] as String? ??
                '';
        
        // Mirror from product_mirror (from /core/firmware/info)
        mirror = product['product_mirror'] as String? ??
                product['CORE_PACKAGESITE'] as String? ?? '';
        
        // Repository from product_repos (from /core/firmware/info)
        repositories = product['product_repos'] as String? ?? '';
        if (repositories.isEmpty) {
          final repo = product['CORE_REPOSITORY'] as String? ?? '';
          if (repo.isNotEmpty) {
            repositories = 'OPNsense ($repo)';
          }
        }
        
        // Updated on from product_time (from /core/firmware/info)
        updatedOn = product['product_time'] as String?;
      }
    }
    
    // Fallback checks for updated time
    if (updatedOn == null || updatedOn.isEmpty) {
      if (systemInfoData.containsKey('product_time')) {
        updatedOn = systemInfoData['product_time'] as String?;
      } else if (systemInfoData.containsKey('status_msg')) {
        updatedOn = systemInfoData['status_msg'] as String?;
      } else if (systemInfoData.containsKey('last_check')) {
        updatedOn = systemInfoData['last_check'] as String?;
      }
    }
    
    // Fallback checks for mirror
    if (mirror.isEmpty && systemInfoData.containsKey('product_mirror')) {
      mirror = systemInfoData['product_mirror'] as String? ?? '';
    }
    
    // Fallback checks for repositories
    if (repositories.isEmpty && systemInfoData.containsKey('product_repos')) {
      repositories = systemInfoData['product_repos'] as String? ?? '';
    }
    
    String hostname = 'OPNsense Router';
    String platform = 'FreeBSD';
    
    // Try to get hostname from system info
    if (systemInfoData.containsKey('hostname')) {
      hostname = systemInfoData['hostname'] as String? ?? hostname;
    }
    
    // Try to get platform details
    if (systemInfoData.containsKey('os')) {
      final os = systemInfoData['os'] as Map<String, dynamic>?;
      if (os != null) {
        platform = '${os['name'] ?? 'FreeBSD'} ${os['version'] ?? ''}';
      }
    } else if (systemInfoData.containsKey('os_version')) {
      platform = 'FreeBSD ${systemInfoData['os_version']}';
    }
    
    
    // Parse uptime and CPU from activity headers
    // Headers format: "last pid: 31779;  load averages:  0.86,  1.02,  0.89  up 0+07:16:41    19:59:35"
    // and "CPU:  2.7% user,  0.0% nice,  1.5% system,  0.7% interrupt, 95.0% idle"
    int uptime = 0;
    double cpuUsage = 0.0;
    
    if (activityData.containsKey('headers')) {
      final headers = activityData['headers'] as List?;
      if (headers != null && headers.isNotEmpty) {
        
        // Parse uptime from first header line
        final firstHeader = headers[0] as String;
        
        // Parse uptime: "up 0+07:16:41" means 0 days, 7 hours, 16 minutes, 41 seconds
        final uptimeMatch = RegExp(r'up (\d+)\+(\d+):(\d+):(\d+)').firstMatch(firstHeader);
        if (uptimeMatch != null) {
          final days = int.parse(uptimeMatch.group(1)!);
          final hours = int.parse(uptimeMatch.group(2)!);
          final minutes = int.parse(uptimeMatch.group(3)!);
          final seconds = int.parse(uptimeMatch.group(4)!);
          uptime = (days * 86400) + (hours * 3600) + (minutes * 60) + seconds;
        }
        
        // Parse CPU - check all header lines for CPU info
        for (int i = 0; i < headers.length; i++) {
          final headerLine = headers[i] as String;
          
          // "CPU:  2.0% user,  0.0% nice,  1.4% system,  0.5% interrupt, 96.0% idle"
          if (headerLine.contains('CPU:')) {
            final idleMatch = RegExp(r'(\d+\.?\d*)% idle').firstMatch(headerLine);
            if (idleMatch != null) {
              final idle = double.parse(idleMatch.group(1)!);
              cpuUsage = 100.0 - idle;
              break;
            }
          }
        }
        
        if (cpuUsage == 0.0) {
        }
      }
    }
    
    // Parse memory from nested structure - handle both int and string types
    final memoryData = resourcesData['memory'] as Map<String, dynamic>?;
    
    // Memory values might be int or string, parse safely
    int memoryUsed = 0;
    int memoryTotal = 0;
    int memoryArc = 0;
    
    if (memoryData != null) {
      final usedValue = memoryData['used'];
      final totalValue = memoryData['total'];
      final arcValue = memoryData['arc'];
      
      if (usedValue is int) {
        memoryUsed = usedValue;
      } else if (usedValue is String) {
        memoryUsed = int.tryParse(usedValue) ?? 0;
      }
      
      if (totalValue is int) {
        memoryTotal = totalValue;
      } else if (totalValue is String) {
        memoryTotal = int.tryParse(totalValue) ?? 0;
      }
      
      if (arcValue is int) {
        memoryArc = arcValue;
      } else if (arcValue is String) {
        memoryArc = int.tryParse(arcValue) ?? 0;
      }
    }

    // Parse disk usage from disk data
    // Data format: {device: /dev/gpt/rootfs, blocks: 40G, used: 8.0G, ...}
    int diskUsed = 0;
    int diskTotal = 0;
    
    if (diskData.isNotEmpty) {
      if (diskData.containsKey('devices')) {
        final devices = diskData['devices'] as List?;
        if (devices != null && devices.isNotEmpty) {
          // Find root filesystem (usually mounted on /)
          for (var device in devices) {
            if (device is Map<String, dynamic>) {
              final mountpoint = device['mountpoint'] as String?;
              if (mountpoint == '/') {
                final usedStr = device['used'] as String?;
                final totalStr = device['blocks'] as String?;
                
                
                // Parse strings like "8.0G" or "40G" to bytes
                if (usedStr != null) {
                  diskUsed = parseStorageString(usedStr);
                }
                if (totalStr != null) {
                  diskTotal = parseStorageString(totalStr);
                }
                
                break;
              }
            }
          }
        }
      }
    }
    

    return SystemInfo(
      hostname: hostname,
      version: version,
      platform: platform,
      uptime: uptime,
      cpuUsage: cpuUsage,
      memoryUsed: memoryUsed,
      memoryArc: memoryArc,
      diskUsed: diskUsed,
      diskTotal: diskTotal,
      memoryTotal: memoryTotal,
      type: type,
      architecture: architecture,
      commit: commit,
      mirror: mirror,
      repositories: repositories,
      updatedOn: updatedOn,
    );
  }

  /// Get system temperature sensors
  /// Returns a list of thermal sensors or an empty list for VM systems
  Future<List<ThermalSensor>> getSystemTemperature() async {
    ensureInitialized();

    try {
      final response = await dio.get(ApiEndpoints.diagnosticsSystemTemperature);
      
      if (response.statusCode == 200) {
        final data = response.data;
        
        // Handle empty array response (common for VM systems without thermal sensors)
        if (data is List) {
          if (data.isEmpty) {
            return [];
          }
          
          // Parse list of thermal sensors
          try {
            return data
                .map((json) => ThermalSensor.fromJson(json as Map<String, dynamic>))
                .toList();
          } catch (e) {
            rethrow;
          }
        }
        
        // If response is not a list, return empty list
        return [];
      } else {
        throw ApiException('Failed to get system temperature', response.statusCode, ApiErrorType.unknown);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  Future<void> rebootSystem() async {
    ensureInitialized();

    try {
      
      final response = await dio.post(ApiEndpoints.systemReboot);
      
      if (response.statusCode == 200) {
      } else {
        throw ApiException('Failed to reboot system', response.statusCode, ApiErrorType.unknown);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }
}


