# Demo Mode Implementation

## Overview
Demo mode has been successfully added to the OPNsense Manager app, allowing users to explore the app's features without connecting to a real OPNsense firewall.

## Features Implemented

### 1. **Profile Model Enhancement**
- Added `isDemo` boolean flag to [`Profile`](lib/models/profile.dart) model
- Demo profiles are clearly identified throughout the app

### 2. **Demo Data Service**
- Created [`DemoDataService`](lib/services/demo_data_service.dart) that generates realistic mock data:
  - System information (CPU, memory, disk usage, uptime)
  - Firewall rules (4 sample rules with different actions)
  - VPN connections (3 sample connections: OpenVPN, WireGuard)
  - Services status (DNS, NTP, SSH, DHCP, OpenVPN)
  - Gateways status
  - Firewall logs (up to 100 entries)
- Maintains stateful data (toggle states for rules, VPN connections, services)

### 3. **Demo API Service Wrapper**
- Created [`DemoApiService`](lib/services/demo_api_service.dart) that wraps [`OPNsenseApiService`](lib/services/opnsense_api_service.dart)
- Automatically routes API calls to demo data when demo mode is active
- Simulates network delays for realistic experience (200-800ms)
- Prevents destructive operations in demo mode (e.g., system reboot)

### 4. **Profile Service Updates**
- Added [`createDemoProfile()`](lib/services/profile_service.dart:210) method
- Demo profile uses placeholder credentials and hostname
- Demo profile is automatically created when user clicks "Try Demo"

### 5. **UI Enhancements**

#### Profile Selection Screen
- Added "Try Demo Mode" button with play icon
- Demo profiles show "DEMO" badge in orange
- Demo profiles use play icon instead of router icon

#### Dashboard Screen
- Orange gradient banner at top when in demo mode
- Banner displays: "Demo Mode - Showing sample data"
- Banner includes play and info icons for visual clarity

### 6. **App Flow Integration**
- [`main.dart`](lib/main.dart): Integrated [`DemoApiService`](lib/services/demo_api_service.dart) into Provider tree
- [`SplashScreen`](lib/screens/splash_screen.dart): Detects demo profiles and enables demo mode
- [`ProfileSelectionScreen`](lib/screens/profile_selection_screen.dart): Handles demo profile selection
- [`DashboardScreen`](lib/screens/dashboard_screen.dart): Uses [`DemoApiService`](lib/services/demo_api_service.dart) and displays demo banner

## How to Use Demo Mode

### For Users:
1. Launch the app
2. On the profile selection screen, click "Try Demo Mode"
3. The app will automatically create a demo profile and navigate to the dashboard
4. Explore all features with realistic sample data
5. The orange banner reminds you that you're in demo mode

### For Developers:
```dart
// Check if demo mode is active
final demoApiService = context.read<DemoApiService>();
if (demoApiService.isDemoMode) {
  // Demo mode specific logic
}

// Enable/disable demo mode
demoApiService.setDemoMode(true);  // Enable
demoApiService.setDemoMode(false); // Disable
```

## Demo Data Details

### System Info
- Hostname: `demo-opnsense`
- Version: `24.7.1`
- Uptime: ~15 days (randomized)
- CPU Usage: 15-45% (randomized)
- Memory: 8GB total, 40-60% used (randomized)
- Disk: 100GB total, 25-55% used (randomized)

### Firewall Rules
1. **Allow HTTPS from WAN** (enabled, TCP port 443)
2. **Allow LAN to any** (enabled, all protocols)
3. **Block SSH from WAN** (disabled, TCP port 22)
4. **Allow HTTP from WAN** (enabled, TCP port 80)

### VPN Connections
1. **Office VPN** (OpenVPN, connected, 150MB received)
2. **Remote Site** (WireGuard, connected, 320MB received)
3. **Mobile Users** (OpenVPN, disconnected)

### Services
- DNS Resolver (unbound) - Running
- NTP Service (ntpd) - Running
- SSH Service (sshd) - Running
- DHCP Service (dhcpd) - Running
- OpenVPN Service - Running

## Files Modified/Created

### New Files:
- [`lib/services/demo_data_service.dart`](lib/services/demo_data_service.dart) - Mock data generator
- [`lib/services/demo_api_service.dart`](lib/services/demo_api_service.dart) - API wrapper for demo mode
- `DEMO_MODE.md` - This documentation

### Modified Files:
- [`lib/models/profile.dart`](lib/models/profile.dart) - Added `isDemo` field
- [`lib/services/profile_service.dart`](lib/services/profile_service.dart) - Added demo profile creation
- [`lib/main.dart`](lib/main.dart) - Integrated [`DemoApiService`](lib/services/demo_api_service.dart)
- [`lib/screens/splash_screen.dart`](lib/screens/splash_screen.dart) - Demo mode detection
- [`lib/screens/profile_selection_screen.dart`](lib/screens/profile_selection_screen.dart) - "Try Demo" button
- [`lib/screens/dashboard_screen.dart`](lib/screens/dashboard_screen.dart) - Demo banner and API integration

## Benefits

1. **User Onboarding**: New users can explore the app without setup
2. **Testing**: Developers can test UI without a real OPNsense instance
3. **Demonstrations**: Perfect for showcasing the app's capabilities
4. **Development**: Faster iteration without network dependencies
5. **Documentation**: Screenshots and videos can use consistent demo data

## Future Enhancements

Potential improvements for demo mode:
- Add more diverse firewall rules and scenarios
- Simulate time-based changes (e.g., increasing uptime, changing metrics)
- Add demo data for additional screens (if any are added)
- Allow customization of demo data through settings
- Add tutorial/walkthrough mode on top of demo mode

## Technical Notes

- Demo mode is completely client-side - no network requests are made
- State is maintained in memory and resets when demo mode is disabled
- All API methods are supported in demo mode
- Demo mode prevents destructive operations (reboot, etc.)
- Network delays are simulated for realistic UX