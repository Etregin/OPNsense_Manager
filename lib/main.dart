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
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'screens/openvpn_client_overrides_list_screen.dart';
import 'screens/openvpn_client_override_form_screen.dart';
import 'screens/openvpn_connection_status_screen.dart';
import 'screens/openvpn_log_file_screen.dart';
import 'services/app_version_service.dart';
import 'services/storage_service.dart';
import 'services/opnsense_api_service.dart';
import 'services/demo_api_service.dart';
import 'services/auth_service.dart';
import 'services/profile_service.dart';
import 'utils/constants.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Enable edge-to-edge display for proper Android 15+ support
  // This makes the app draw behind system bars (status bar and navigation bar)
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
  );
  
  // Set system UI overlay style to be transparent
  // This removes the deprecated status bar and navigation bar colors
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: AppColors.transparent,
      systemNavigationBarColor: AppColors.transparent,
      systemNavigationBarDividerColor: AppColors.transparent,
    ),
  );
  
  // Initialize services in parallel for faster startup
  await Future.wait([
    StorageService().init(),
    AuthService().init(),
    ProfileService().init(),
    AppVersionService().init(),
  ]);
  
  // Migrate from old storage to profile-based storage (non-blocking)
  ProfileService().migrateFromOldStorage();
  
  runApp(const OPNsenseManagerApp());
}

class OPNsenseManagerApp extends StatefulWidget {
  const OPNsenseManagerApp({super.key});

  @override
  State<OPNsenseManagerApp> createState() => _OPNsenseManagerAppState();
}

class _OPNsenseManagerAppState extends State<OPNsenseManagerApp> {
  ThemeMode _themeMode = ThemeMode.system;
  Locale? _locale;
  bool _isUpdatingLocale = false;
  bool _isUpdatingThemeMode = false;

  @override
  void initState() {
    super.initState();
    // Load theme mode and locale asynchronously without blocking UI
    _loadThemeMode();
    _loadLocale();
  }

  Future<void> _loadThemeMode() async {
    final themeModeString = await StorageService().loadString('theme_mode') ?? 'system';
    if (mounted) {
      setState(() {
        _themeMode = _getThemeModeFromString(themeModeString);
      });
    }
  }

  Future<void> _loadLocale() async {
    final localeString = await StorageService().loadString('locale');
    if (mounted && localeString != null) {
      // Validate locale against supported languages
      final supportedLanguages = AppConstants.supportedLanguages.keys.toList();
      if (supportedLanguages.contains(localeString)) {
        setState(() {
          _locale = Locale(localeString);
        });
      }
      // If invalid, fall back to null (system default)
    }
  }

  ThemeMode _getThemeModeFromString(String mode) {
    switch (mode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  Future<void> _updateThemeMode(String mode) async {
    // Prevent race conditions from rapid theme changes
    if (_isUpdatingThemeMode) return;
    
    _isUpdatingThemeMode = true;
    try {
      setState(() {
        _themeMode = _getThemeModeFromString(mode);
      });
      await StorageService().saveString('theme_mode', mode);
    } finally {
      if (mounted) {
        _isUpdatingThemeMode = false;
      }
    }
  }

  Future<void> _updateLocale(String? localeCode) async {
    // Prevent race conditions from rapid locale changes
    if (_isUpdatingLocale) return;
    
    _isUpdatingLocale = true;
    try {
      setState(() {
        _locale = localeCode != null ? Locale(localeCode) : null;
      });
      if (localeCode != null) {
        await StorageService().saveString('locale', localeCode);
      } else {
        await StorageService().remove('locale');
      }
    } finally {
      if (mounted) {
        _isUpdatingLocale = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<StorageService>(
          create: (_) => StorageService(),
        ),
        Provider<OPNsenseApiService>(
          create: (_) => OPNsenseApiService(),
        ),
        ProxyProvider<OPNsenseApiService, DemoApiService>(
          update: (_, apiService, previous) => previous ?? DemoApiService(apiService),
        ),
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
        Provider<ProfileService>(
          create: (_) => ProfileService(),
        ),
        Provider<AppVersionService>(
          create: (_) => AppVersionService(),
        ),
        Provider<Function(String)>(
          create: (_) => _updateThemeMode,
        ),
        Provider<Function(String?)>(
          create: (_) => _updateLocale,
        ),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        themeMode: _themeMode,
        locale: _locale,
        routes: {
          '/openvpn/client-overrides': (context) => const OpenvpnClientOverridesListScreen(),
          '/openvpn/client-overrides/form': (context) {
            final uuid = ModalRoute.of(context)?.settings.arguments as String?;
            return OpenvpnClientOverrideFormScreen(uuid: uuid);
          },
          '/openvpn/connection-status': (context) => const OpenvpnConnectionStatusScreen(),
          '/openvpn/log-file': (context) => const OpenvpnLogFileScreen(),
        },
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'), // English
          Locale('ar'), // Arabic
          Locale('es'), // Spanish
          Locale('fr'), // French
          Locale('de'), // German
        ],
        theme: ThemeData(
          primaryColor: AppColors.primary,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            secondary: AppColors.secondary,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          cardTheme: CardThemeData(
            elevation: AppConstants.cardElevation,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.buttonBorderRadius),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.buttonBorderRadius),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
        darkTheme: ThemeData(
          primaryColor: AppColors.primary,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            secondary: AppColors.secondary,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
          cardTheme: CardThemeData(
            elevation: AppConstants.cardElevation,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.buttonBorderRadius),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.buttonBorderRadius),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}

