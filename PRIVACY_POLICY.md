# Privacy Policy for OPNsense Manager

**Last Updated: September 13, 2026**

## Introduction

OPNsense Manager ("we", "our", or "the app") is committed to protecting your privacy. This Privacy Policy explains how we handle your information when you use our mobile application.

## Developer Information

- **App Name**: OPNsense Manager
- **Developer**: Etregin
- **Contact**: Etreginwow@gmail.com
- **License**: GNU General Public License v3.0

## Information We Collect

### Data Stored Locally on Your Device

OPNsense Manager stores the following information **locally on your device only**:

1. **Connection Profiles**
   - OPNsense server hostname/IP address
   - Port number
   - API key and API secret (encrypted)
   - HTTPS/HTTP preference
   - Profile names and metadata

2. **Security Settings**
   - PIN code (if enabled, stored encrypted)
   - Biometric authentication preference
   - Auto-lock timeout settings

3. **App Preferences**
   - Theme preference (light/dark/system)
   - Language preference
   - Auto-refresh settings
   - Last used profile

### Data We Do NOT Collect

- ❌ We do NOT collect any personal information
- ❌ We do NOT transmit your data to our servers (we don't have any servers)
- ❌ We do NOT track your usage or behavior
- ❌ We do NOT use analytics or tracking services
- ❌ We do NOT sell your data to anyone
- ⚠️ We do NOT share your data with third parties, **with one exception**: the Play Store and App Store versions use Google AdMob to display banner ads. AdMob may collect limited device data as described in the [Advertising](#advertising-play-store--app-store-versions-only) section below.

## How We Use Your Information

All data is stored **locally on your device** and is used solely to:

1. Connect to your OPNsense firewall
2. Authenticate API requests
3. Remember your preferences and settings
4. Provide app functionality (firewall management, monitoring, etc.)

## Data Storage and Security

### Local Storage

- **Secure Storage**: API credentials (keys and secrets) are stored using platform-specific secure storage:
  - **iOS**: Keychain (Apple's secure credential storage)
  - **Android**: Keystore (Android's encrypted credential storage)

- **Regular Storage**: Non-sensitive preferences (theme, language) are stored in standard app preferences

- **Encryption**: 
  - API credentials are encrypted by the operating system
  - PIN codes are encrypted before storage
  - All data remains on your device

### Network Communication

- **Direct Connection**: The app communicates **directly** with your OPNsense firewall
- **No Intermediary**: No data passes through our servers (we don't have any)
- **HTTPS**: All API communications use HTTPS encryption (configurable)
- **Local Network**: Typically used on local networks or VPN connections

## Permissions Required

### Android Permissions

- **INTERNET**: Required to communicate with your OPNsense firewall
- **ACCESS_NETWORK_STATE**: To check network connectivity
- **USE_BIOMETRIC**: For fingerprint/face authentication (optional)
- **USE_FINGERPRINT**: For fingerprint authentication on older devices (optional)

### iOS Permissions

- **Face ID**: For biometric authentication (optional, requested when you enable it)
- **Network Access**: To communicate with your OPNsense firewall

**Note**: Biometric permissions are only requested if you choose to enable biometric authentication in settings.

## Data Retention

- **Local Storage**: Data remains on your device until you:
  - Delete a profile
  - Clear app data
  - Uninstall the app
  
- **No Cloud Storage**: We do not store any data in the cloud

## Your Rights and Control

You have complete control over your data:

- ✅ **View**: All stored data is accessible through the app settings
- ✅ **Edit**: Modify profiles and settings at any time
- ✅ **Delete**: Remove profiles or clear all data
- ✅ **Export**: Export profiles as JSON files (credentials included)
- ✅ **Import**: Import profiles from JSON files

## Third-Party Services

OPNsense Manager uses minimal third-party services:

- ❌ No analytics services (Google Analytics, Firebase Analytics, etc.)
- ❌ No crash reporting services
- ❌ No social media integrations
- ❌ No cloud storage services
- ⚠️ **Google AdMob** — used for banner advertising in the Play Store (Android) and App Store (iOS) versions only. See the [Advertising](#advertising-play-store--app-store-versions-only) section for full details.

The F-Droid and GitHub direct builds are completely self-contained and only communicate with your OPNsense firewall.

## Advertising (Play Store & App Store Versions Only)

The Play Store (Android) and App Store (iOS) versions of OPNsense Manager display banner advertisements powered by **Google AdMob**. This section explains how advertising works and what data may be collected.

### Why Ads?

Ads allow OPNsense Manager to be distributed free of charge on the Play Store and App Store while funding continued development and maintenance.

### Where Ads Appear

Banner ads appear only on **informational screens**, including:

- Dashboard
- System Info & System Health
- Settings
- DHCP Leases
- Neighbor Discovery
- Network Insight / NetFlow
- Unbound DNS

Ads **never** appear on critical security or configuration screens such as firewall rule editing, VPN controls, or authentication screens.

### How to Remove Ads

You can permanently remove all ads with a **one-time Supporter purchase** available in the app:

1. Go to **Settings**
2. Tap **Supporter & Ad Removal**
3. Complete the one-time in-app purchase

Your supporter status is tied to your store account and can be restored at any time using the **Restore Purchase** option.

### What AdMob May Collect

When ads are shown, Google AdMob may collect the following data on behalf of Google:

- **Advertising ID** — Android Advertising ID (AAID) or iOS Identifier for Advertisers (IDFA), used to serve relevant ads
- **IP Address** — used for general geographic targeting (country/region level)
- **Device information** — device model, OS version, screen size
- **Ad interaction data** — whether an ad was viewed or tapped

OPNsense Manager itself does **not** receive or store any of this data. It is collected and processed solely by Google under their own privacy policy.

### AdMob Data Processing

Google AdMob processes ad-related data in accordance with:

- [Google Privacy Policy](https://policies.google.com/privacy)
- [Google AdMob & AdSense Policies](https://support.google.com/admob/answer/6128543)

### Opting Out of Personalised Ads

You can limit ad personalisation at the device level:

- **Android**: Settings → Google → Ads → Delete Advertising ID, or opt out of ads personalisation
- **iOS**: Settings → Privacy & Security → Apple Advertising → turn off Personalised Ads (for Apple ads) or use App Tracking Transparency prompts

### Ad-Free Builds

The **F-Droid** and **GitHub direct** builds of OPNsense Manager do not include the AdMob SDK and do not show any advertisements. No ad-related data is collected on these builds.

## Children's Privacy

OPNsense Manager is not directed at children under 13. We do not knowingly collect information from children. The app is designed for network administrators and technical users.

## Open Source

OPNsense Manager is open source software licensed under GPLv3. You can:

- Review the source code: https://github.com/Etregin/OPNsense_Manager
- Verify our privacy claims by examining the code
- Contribute to the project
- Fork and modify the app

## Changes to This Privacy Policy

We may update this Privacy Policy from time to time. We will notify you of any changes by:

- Updating the "Last Updated" date at the top of this policy
- Including the updated policy in app updates
- Posting the updated policy on our GitHub repository

## Data Portability

You can export your connection profiles at any time:

1. Go to **Settings** → **Profile Management**
2. Select a profile
3. Tap **Export Profile**
4. Save the JSON file to your device

**Note**: Exported files contain your API credentials. Keep them secure!

## Data Deletion

To delete your data:

1. **Delete Individual Profiles**: Settings → Profile Management → Delete Profile
2. **Clear All Data**: Uninstall the app from your device
3. **Reset Settings**: Delete and reinstall the app

## Security Measures

We implement security best practices:

- ✅ Encrypted credential storage (Keychain/Keystore)
- ✅ HTTPS for all API communications
- ✅ Optional PIN lock protection
- ✅ Optional biometric authentication
- ✅ Auto-lock on app background
- ✅ No logging of sensitive data in production builds

## Compliance

### GDPR Compliance (European Users)

- **Data Controller**: You are the data controller for all app data (stays on your device)
- **Data Processing**: All app processing happens locally on your device
- **Right to Access**: You can view all stored data in the app
- **Right to Erasure**: You can delete data at any time
- **Right to Portability**: You can export your data as JSON
- **AdMob (store versions only)**: Google acts as a data processor for advertising. Google's data processing is governed by their [Data Processing Addendum](https://privacy.google.com/businesses/processorterms/). You may opt out of personalised ads via your device settings.

### CCPA Compliance (California Users)

- **No Sale of Data**: We do not sell your personal information
- **No Sharing**: We do not share your personal data with third parties, except that AdMob (store versions only) may collect device identifiers for advertising purposes under Google's own CCPA compliance posture
- **No Collection**: We do not collect personal information beyond what's necessary for app functionality
- **AdMob opt-out**: California residents may opt out of the sale/sharing of personal information for advertising via Android or iOS device ad settings

## Contact Us

If you have questions about this Privacy Policy or our privacy practices:

- **Email**: Etreginwow@gmail.com
- **GitHub Issues**: https://github.com/Etregin/OPNsense_Manager/issues
- **GitHub Discussions**: https://github.com/Etregin/OPNsense_Manager/discussions

## Security Vulnerabilities

If you discover a security vulnerability, please email Etreginwow@gmail.com directly instead of using the public issue tracker.

## Acknowledgment

By using OPNsense Manager, you acknowledge that you have read and understood this Privacy Policy.

---

## Summary (TL;DR)

- ✅ All app data stored **locally on your device only**
- ✅ **No servers**, no cloud, no tracking by us
- ✅ **No data collection** by us beyond what's needed for app functionality
- ✅ **Open source** — verify our claims by reviewing the code
- ✅ **You control** all your data
- ✅ **Encrypted storage** for credentials
- ✅ **Direct connection** to your OPNsense firewall only
- ⚠️ **Play Store & App Store versions** show banner ads via Google AdMob — removable with a one-time Supporter purchase. F-Droid and GitHub direct builds have no ads.

**We respect your privacy. Your firewall credentials and network data never leave your device.**

---

*This privacy policy is provided in good faith and is accurate to the best of our knowledge. The open-source nature of this project allows you to verify these claims by reviewing the source code.*