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


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/profile.dart';
import '../models/connection_endpoint.dart';
import '../models/opnsense_config.dart';
import '../services/profile_service.dart';
import '../services/opnsense_api_service.dart';
import '../services/demo_api_service.dart';
import '../services/connection/connection_manager_service.dart';
import '../utils/constants.dart';
import 'dashboard_screen.dart';
import 'login_screen.dart';
import '../l10n/app_localizations.dart';

/// Profile selection screen - shown after logout or on first launch
class ProfileSelectionScreen extends StatefulWidget {
  const ProfileSelectionScreen({super.key});

  @override
  State<ProfileSelectionScreen> createState() => _ProfileSelectionScreenState();
}

class _ProfileSelectionScreenState extends State<ProfileSelectionScreen> {
  bool _isLoading = false;
  String? _errorMessage;
  String? _connectionStatus;

  @override
  void initState() {
    super.initState();
    _loadProfiles();
  }

  Future<void> _loadProfiles() async {
    setState(() {});
  }

  Future<void> _selectProfile(Profile profile) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _connectionStatus = null;
    });

    try {
      final profileService = context.read<ProfileService>();

      // Handle demo profiles
      if (profile.isDemo) {
        final demoApiService = context.read<DemoApiService>();
        demoApiService.setDemoMode(true);
        await profileService.setActiveProfile(profile.id);
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const DashboardScreen()),
          );
        }
        return;
      }

      // Disable demo mode for real profiles
      final demoApiService = context.read<DemoApiService>();
      demoApiService.setDemoMode(false);

      // Validate that profile has connections
      if (profile.connections.isEmpty) {
        throw Exception('Profile has no connection endpoints configured');
      }

      // Test each connection endpoint with proper progress messages
      final connectionManager = ConnectionManagerService();
      
      // Sort connections by priority (active first, then by last successful connection)
      final sortedConnections = connectionManager.sortConnectionsByPriority(profile.connections);
      final totalConnections = sortedConnections.length;
      
      ConnectionEndpoint? workingConnection;
      
      for (int i = 0; i < sortedConnections.length; i++) {
        final connection = sortedConnections[i];
        final currentAttempt = i + 1;
        
        // Update status with localized progress message
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          setState(() {
            _connectionStatus = l10n.testingConnection(
              currentAttempt.toString(),
              totalConnections.toString(),
              connection.displayName,
            );
          });
        }
        
        // Create config for this specific connection with all profile settings
        final config = OPNsenseConfig(
          host: connection.host,
          port: connection.port,
          apiKey: profile.apiKey,
          apiSecret: profile.apiSecret,
          useHttps: profile.useHttps,
          allowSelfSignedCerts: profile.allowSelfSignedCerts,
          dhcpServerType: profile.dhcpServerType,
        );
        
        // Test this connection
        final testResult = await connectionManager.testConnectionDetailed(connection, config);
        final isWorking = testResult.isSuccess;
        
        if (isWorking) {
          workingConnection = connection.copyWith(
            isActive: true,
            lastSuccessfulConnection: DateTime.now(),
          );
          break;
        }
      }
      
      if (workingConnection == null) {
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          throw Exception(l10n.unableToConnectToAnyEndpoint);
        }
        throw Exception('Unable to connect to any configured endpoints');
      }
      
      // Update profile with working connection
      final updatedConnections = profile.connections.map((conn) {
        if (conn.host == workingConnection!.host && conn.port == workingConnection.port) {
          return workingConnection;
        }
        return conn.copyWith(isActive: false);
      }).toList();
      
      final updatedProfile = profile.copyWith(connections: updatedConnections);
      await profileService.saveProfile(updatedProfile);
      
      // Initialize API service and navigate
      if (mounted) {
        final apiService = context.read<OPNsenseApiService>();
        apiService.init(updatedProfile.toOPNsenseConfig());
      }
      
      await profileService.setActiveProfile(updatedProfile.id);
      
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
        );
      }
      
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Connection failed: ${e.toString()}';
          _isLoading = false;
          _connectionStatus = null;
        });
      }
    }
  }

  Future<void> _createNewProfile() async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
    );

    if (result == true) {
      await _loadProfiles();
    }
  }

  Future<void> _tryDemo() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final profileService = context.read<ProfileService>();
      
      // Create or get demo profile
      final demoProfile = await profileService.createDemoProfile();
      
      // Select the demo profile
      await _selectProfile(demoProfile);
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        setState(() {
          _errorMessage = l10n.errorPrefix(e.toString());
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Profile>>(
      future: context.read<ProfileService>().getAllProfiles(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        
        final profiles = snapshot.data!;
        return _buildContent(profiles);
      },
    );
  }

  Widget _buildContent(List<Profile> profiles) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Theme.of(context).textTheme.bodyLarge?.color ?? Colors.white : Colors.white;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    Theme.of(context).scaffoldBackgroundColor,
                    Theme.of(context).scaffoldBackgroundColor,
                  ]
                : [
                    AppColors.primary,
                    AppColors.primary.withValues(alpha: 0.7),
                  ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.security,
                      size: 80,
                      color: textColor,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppConstants.appName,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.selectAProfileOrCreateNewOne,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: textColor.withValues(alpha: 0.9),
                          ),
                    ),
                  ],
                ),
              ),

              // Error message
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Card(
                    color: Colors.red.shade100,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Icon(Icons.error, color: Colors.red.shade700),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: TextStyle(color: Colors.red.shade700),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              // Connection status
              if (_connectionStatus != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Card(
                    color: Colors.blue.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.blue.shade700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _connectionStatus!,
                              style: TextStyle(
                                color: Colors.blue.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 16),

              // Profile list or empty state
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Theme.of(context).cardColor
                        : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : profiles.isEmpty
                          ? _buildEmptyState(l10n)
                          : _buildProfileList(profiles, l10n),
                ),
              ),

              // Buttons
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    // Try Demo button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _isLoading ? null : _tryDemo,
                        icon: const Icon(Icons.play_circle_outline),
                        label: const Text('Try Demo Mode'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: isDark
                              ? Theme.of(context).primaryColor
                              : Colors.white,
                          side: BorderSide(
                            color: isDark
                                ? Theme.of(context).primaryColor
                                : Colors.white,
                            width: 2,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Create new profile button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : _createNewProfile,
                        icon: const Icon(Icons.add),
                        label: Text(l10n.createNewProfile),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDark
                              ? Theme.of(context).primaryColor
                              : Colors.white,
                          foregroundColor: isDark
                              ? Colors.white
                              : AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.folder_open,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.noProfilesYet,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.createYourFirstProfile,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileList(List<Profile> profiles, AppLocalizations l10n) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: profiles.length,
      itemBuilder: (context, index) {
        final profile = profiles[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: Icon(
                profile.isDemo ? Icons.play_circle_outline : Icons.router,
                color: AppColors.primary,
              ),
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    profile.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (profile.isDemo) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'DEMO',
                      style: TextStyle(
                        color: Colors.orange.shade900,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  '${profile.useHttps ? l10n.https : l10n.http}://${profile.host}:${profile.port}',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
                if (profile.lastUsed != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    l10n.lastUsed(_formatDate(profile.lastUsed!, l10n)),
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Edit button (only for non-demo profiles)
                if (!profile.isDemo)
                  IconButton(
                    icon: const Icon(Icons.edit, size: 20),
                    color: AppColors.primary,
                    onPressed: () => _editProfile(profile),
                    tooltip: l10n.edit,
                  ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.primary,
                  size: 20,
                ),
              ],
            ),
            onTap: () => _selectProfile(profile),
          ),
        );
      },
    );
  }

  Future<void> _editProfile(Profile profile) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => LoginScreen(profile: profile),
      ),
    );

    if (result == true) {
      await _loadProfiles();
    }
  }

  String _formatDate(DateTime date, AppLocalizations l10n) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return l10n.justNow;
    } else if (difference.inHours < 1) {
      return l10n.minutesAgo(difference.inMinutes.toString());
    } else if (difference.inDays < 1) {
      return l10n.hoursAgo(difference.inHours.toString());
    } else {
      return l10n.daysAgo(difference.inDays.toString());
    }
  }
}

