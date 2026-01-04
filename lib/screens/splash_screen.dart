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
import '../services/opnsense_api_service.dart';
import '../services/auth_service.dart';
import '../services/profile_service.dart';
import '../utils/constants.dart';
import 'profile_selection_screen.dart';
import 'dashboard_screen.dart';
import 'pin_lock_screen.dart';

/// Splash screen with initial loading and authentication check
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    if (!mounted) return;

    final authService = context.read<AuthService>();
    final profileService = context.read<ProfileService>();
    final apiService = context.read<OPNsenseApiService>();

    // Check if authentication is required
    final authRequired = await authService.isAuthenticationRequired();

    if (authRequired) {
      // Show PIN lock screen
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => PinLockScreen(
            onAuthenticated: (ctx) async {
              // Navigate from the PIN lock screen context
              await _proceedToAppWithContext(ctx, profileService, apiService);
            },
          ),
        ),
      );
    } else {
      // Proceed to app
      await _proceedToApp(profileService, apiService);
    }
  }

  Future<void> _proceedToApp(
    ProfileService profileService,
    OPNsenseApiService apiService,
  ) async {
    await _proceedToAppWithContext(context, profileService, apiService);
  }

  Future<void> _proceedToAppWithContext(
    BuildContext ctx,
    ProfileService profileService,
    OPNsenseApiService apiService,
  ) async {
    // Check if there's an active profile
    final activeProfile = await profileService.getActiveProfile();

    if (activeProfile != null) {
      // Initialize API service with active profile
      apiService.init(activeProfile.toOPNsenseConfig());

      // Test connection with timeout for faster startup
      bool isConnected = false;
      try {
        isConnected = await apiService.testConnection().timeout(
          const Duration(seconds: 3),
          onTimeout: () => false,
        );
      } catch (e) {
        isConnected = false;
      }

      if (!ctx.mounted) return;

      if (isConnected) {
        // Navigate to dashboard
        Navigator.of(ctx).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const DashboardScreen(),
          ),
        );
      } else {
        // Connection failed, go to profile selection
        Navigator.of(ctx).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const ProfileSelectionScreen(),
          ),
        );
      }
    } else {
      // No active profile, go to profile selection
      if (!ctx.mounted) return;
      Navigator.of(ctx).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ProfileSelectionScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(AppConstants.primaryColorValue),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.asset(
                  'assets/images/opnsense_manager.png',
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 32),
            // App Name
            const Text(
              AppConstants.appName,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            // Version
            Text(
              'Version ${AppConstants.appVersion}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: 48),
            // Loading Indicator
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

