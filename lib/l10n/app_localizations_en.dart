// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'OPNsense Manager';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get firewallRules => 'Firewall Rules';

  @override
  String get firewallLogs => 'Firewall Logs';

  @override
  String get systemInfo => 'System Information';

  @override
  String get vpnConnections => 'VPN Connections';

  @override
  String get settings => 'Settings';

  @override
  String get hostname => 'Hostname';

  @override
  String get versionLabel => 'Version';

  @override
  String get platform => 'Platform';

  @override
  String get uptime => 'Uptime';

  @override
  String get cpuUsage => 'CPU Usage';

  @override
  String get memoryUsage => 'Memory Usage';

  @override
  String get services => 'Services';

  @override
  String get gateways => 'Gateways';

  @override
  String get running => 'Running';

  @override
  String get stopped => 'Stopped';

  @override
  String get online => 'Online';

  @override
  String get offline => 'Offline';

  @override
  String get start => 'Start';

  @override
  String get stop => 'Stop';

  @override
  String get restart => 'Restart';

  @override
  String get enable => 'Enable';

  @override
  String get disable => 'Disable';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get ok => 'OK';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get close => 'Close';

  @override
  String get refresh => 'Refresh';

  @override
  String get apply => 'Apply';

  @override
  String get login => 'Login';

  @override
  String get logout => 'Logout';

  @override
  String get host => 'Host';

  @override
  String get port => 'Port';

  @override
  String get apiKey => 'API Key';

  @override
  String get apiSecret => 'API Secret';

  @override
  String get useHttps => 'Use HTTPS';

  @override
  String get allowSelfSigned => 'Allow Self-Signed Certificate';

  @override
  String get testConnection => 'Test Connection';

  @override
  String get connectionSuccessful => 'Connection Successful';

  @override
  String get connectionFailed =>
      'Connection failed. Check console logs for details.\n\nCommon issues:\n• Device not on same network as OPNsense\n• Wrong IP address or port\n• Firewall blocking connection\n• Invalid API credentials';

  @override
  String get profiles => 'Profiles';

  @override
  String get addProfile => 'Add Profile';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get deleteProfile => 'Delete Profile';

  @override
  String get profileName => 'Profile Name';

  @override
  String get activeProfile => 'Active Profile';

  @override
  String get switchProfile => 'Switch Profile';

  @override
  String get exportProfiles => 'Export Profiles';

  @override
  String get importProfiles => 'Import Profiles';

  @override
  String get security => 'Security';

  @override
  String get pinLock => 'PIN Lock';

  @override
  String get changePIN => 'Change PIN';

  @override
  String get biometricAuth => 'Biometric Authentication';

  @override
  String get sessionTimeout => 'Session Timeout';

  @override
  String get lockApp => 'Lock App';

  @override
  String get appearance => 'Appearance';

  @override
  String get theme => 'Theme';

  @override
  String get language => 'Language';

  @override
  String get lightMode => 'Light Mode';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get systemDefault => 'System Default';

  @override
  String get general => 'General';

  @override
  String get about => 'About';

  @override
  String get licenses => 'Licenses';

  @override
  String get firewallRuleDetails => 'Firewall Rule Details';

  @override
  String get createRule => 'Create Rule';

  @override
  String get editRule => 'Edit Rule';

  @override
  String get deleteRule => 'Delete Rule';

  @override
  String get action => 'Action';

  @override
  String get interface => 'Interface';

  @override
  String get protocol => 'Protocol';

  @override
  String get source => 'Source';

  @override
  String get destination => 'Destination';

  @override
  String get sourcePort => 'Source Port';

  @override
  String get destinationPort => 'Destination Port';

  @override
  String get description => 'Description';

  @override
  String get enabled => 'Enabled';

  @override
  String get disabled => 'Disabled';

  @override
  String get pass => 'Pass';

  @override
  String get block => 'Block';

  @override
  String get reject => 'Reject';

  @override
  String get logs => 'Logs';

  @override
  String get filterByAction => 'Filter by Action';

  @override
  String get showAll => 'Show All';

  @override
  String get autoRefresh => 'Auto Refresh';

  @override
  String get logLimit => 'Log Limit';

  @override
  String get paused => 'Paused';

  @override
  String get live => 'LIVE';

  @override
  String get entries => 'entries';

  @override
  String get selected => 'selected';

  @override
  String get selectAll => 'Select All';

  @override
  String get copy => 'Copy';

  @override
  String get historySize => 'History Size';

  @override
  String get enableAutoScroll => 'Enable Auto-scroll';

  @override
  String get disableAutoScroll => 'Disable Auto-scroll';

  @override
  String get clearLogs => 'Clear Logs';

  @override
  String get pause => 'Pause';

  @override
  String get resume => 'Resume';

  @override
  String copiedLogEntries(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'entries',
      one: 'entry',
    );
    return 'Copied $count log $_temp0';
  }

  @override
  String get pauseLiveViewToSelect => 'Pause live view to select log entries';

  @override
  String get errorLoadingLogs => 'Error loading logs';

  @override
  String get noLogsAvailable => 'No logs available';

  @override
  String get logsWillAppear => 'Logs will appear here as they are generated';

  @override
  String get selectNumberOfEntries =>
      'Select the number of log entries to display:';

  @override
  String get reason => 'Reason';

  @override
  String get newRule => 'New Rule';

  @override
  String get ruleDetails => 'Rule Details';

  @override
  String get type => 'Type';

  @override
  String get sequence => 'Sequence';

  @override
  String get status => 'Status';

  @override
  String get systemGeneratedRule =>
      'This is a system-generated rule and cannot be modified or deleted.';

  @override
  String get systemGeneratedRulesCannotBeModified =>
      'System-generated rules cannot be modified';

  @override
  String get systemGeneratedRulesCannotBeDeleted =>
      'System-generated rules cannot be deleted';

  @override
  String get enableRule => 'Enable Rule';

  @override
  String get disableRule => 'Disable Rule';

  @override
  String get enablingRule => 'Enabling rule...';

  @override
  String get disablingRule => 'Disabling rule...';

  @override
  String get ruleEnabledSuccessfully => 'Rule enabled successfully';

  @override
  String get ruleDisabledSuccessfully => 'Rule disabled successfully';

  @override
  String errorTogglingRule(String error) {
    return 'Error toggling rule: $error';
  }

  @override
  String deleteRuleConfirmation(String description) {
    return 'Are you sure you want to delete the rule \"$description\"?';
  }

  @override
  String get ruleDeleted => 'Rule deleted successfully';

  @override
  String errorDeletingRule(String error) {
    return 'Error deleting rule: $error';
  }

  @override
  String get errorLoadingRules => 'Error loading rules';

  @override
  String get noAutomationRulesFound => 'No automation rules found';

  @override
  String get createFirstAutomationRule =>
      'Create your first automation rule to get started';

  @override
  String get noInterfacesWithAutomationRules =>
      'No interfaces with automation rules';

  @override
  String get selectInterface => 'Select Interface';

  @override
  String get selectInterfaceToViewRules => 'Select an interface to view rules';

  @override
  String noRulesForInterface(String interface) {
    return 'No rules for $interface';
  }

  @override
  String get unnamedRule => 'Unnamed Rule';

  @override
  String get systemInformation => 'System Information';

  @override
  String get firmwareDetails => 'Firmware Details';

  @override
  String get systemType => 'System Type';

  @override
  String get architecture => 'Architecture';

  @override
  String get gitCommit => 'Git Commit';

  @override
  String get packageMirror => 'Package Mirror';

  @override
  String get repository => 'Repository';

  @override
  String get lastUpdate => 'Last Update';

  @override
  String get errorLoadingSystemInfo => 'Error loading system information';

  @override
  String get errorLoadingVPNConnections => 'Error loading VPN connections';

  @override
  String get noVPNConnectionsFound => 'No VPN connections found';

  @override
  String noConnectionsFound(String type) {
    return 'No $type connections found';
  }

  @override
  String get vpnConnectionsWillAppear =>
      'VPN connections will appear here when configured';

  @override
  String get totalVPNs => 'Total VPNs';

  @override
  String get filterByType => 'Filter by type';

  @override
  String get allVPNs => 'All VPNs';

  @override
  String get connectVPN => 'Connect VPN';

  @override
  String get disconnectVPN => 'Disconnect VPN';

  @override
  String connectingVPN(String name) {
    return 'Connecting $name...';
  }

  @override
  String disconnectingVPN(String name) {
    return 'Disconnecting $name...';
  }

  @override
  String successfullyConnected(String name) {
    return 'Successfully connected $name';
  }

  @override
  String successfullyDisconnected(String name) {
    return 'Successfully disconnected $name';
  }

  @override
  String failedToConnect(String name) {
    return 'Failed to connect $name';
  }

  @override
  String failedToDisconnect(String name) {
    return 'Failed to disconnect $name';
  }

  @override
  String get restartVPNService => 'Restart VPN Service';

  @override
  String restartServiceConfirmation(String type) {
    return 'Are you sure you want to restart the $type service?\n\nThis will temporarily disconnect all active connections.';
  }

  @override
  String restartingService(String type) {
    return 'Restarting $type service...';
  }

  @override
  String successfullyRestartedService(String type) {
    return 'Successfully restarted $type service';
  }

  @override
  String failedToRestartService(String type) {
    return 'Failed to restart $type service';
  }

  @override
  String get enterRuleDescription => 'Enter rule description';

  @override
  String get loading => 'Loading...';

  @override
  String get any => 'Any';

  @override
  String get anyIpAddressCidrOrAlias => 'any, IP address, CIDR, or alias';

  @override
  String get examplesAnyIpCidr => 'Examples: any, 192.168.1.0/24, 10.0.0.1';

  @override
  String get sourceIsRequired => 'Source is required';

  @override
  String get invalidSourceFormat => 'Invalid source format';

  @override
  String get sourcePortOptional => 'Source Port (Optional)';

  @override
  String get anyPortNumberRangeOrAlias => 'any, port number, range, or alias';

  @override
  String get examplesAnyPortRange => 'Examples: any, 80, 1024-65535';

  @override
  String get invalidPortFormat => 'Invalid port format';

  @override
  String get destinationIsRequired => 'Destination is required';

  @override
  String get invalidDestinationFormat => 'Invalid destination format';

  @override
  String get destinationPortOptional => 'Destination Port (Optional)';

  @override
  String get examplesAnyPortRangeHttp => 'Examples: any, 80, 80-443, http';

  @override
  String get ruleWillBeActiveWhenEnabled => 'Rule will be active when enabled';

  @override
  String get ruleGuidelines => 'Rule Guidelines';

  @override
  String get ruleGuidelinesText =>
      '• Use \"any\" to match all addresses or ports\n• CIDR notation: 192.168.1.0/24\n• Port ranges: 80-443\n• Rules are processed in sequence order\n• Changes are applied immediately';

  @override
  String get updateRule => 'Update Rule';

  @override
  String get ruleUpdated => 'Rule updated successfully';

  @override
  String get ruleCreated => 'Rule created successfully';

  @override
  String errorSavingRule(String error) {
    return 'Error saving rule: $error';
  }

  @override
  String get connectToYourOPNsenseFirewall =>
      'Connect to your OPNsense firewall';

  @override
  String get profileNameOptional => 'Profile Name (Optional)';

  @override
  String get myOPNsenseRouter => 'My OPNsense Router';

  @override
  String get hostIpAddress => 'Host / IP Address';

  @override
  String get hostPlaceholder => '192.168.1.1 or firewall.example.com';

  @override
  String get portPlaceholder => '443';

  @override
  String get recommendedForSecureConnections =>
      'Recommended for secure connections';

  @override
  String get enterYourApiKey => 'Enter your API key';

  @override
  String get enterYourApiSecret => 'Enter your API secret';

  @override
  String get connect => 'Connect';

  @override
  String apiError(String message) {
    return 'API Error: $message';
  }

  @override
  String get needHelpCheckDocumentation =>
      'Need help? Check the OPNsense documentation for API key generation.';

  @override
  String get selectAProfileOrCreateNewOne =>
      'Select a profile or create a new one';

  @override
  String get createNewProfile => 'Create New Profile';

  @override
  String get noProfilesYet => 'No Profiles Yet';

  @override
  String get createYourFirstProfile =>
      'Create your first OPNsense profile to get started';

  @override
  String lastUsed(String date) {
    return 'Last used: $date';
  }

  @override
  String get justNow => 'Just now';

  @override
  String minutesAgo(String minutes) {
    return '${minutes}m ago';
  }

  @override
  String hoursAgo(String hours) {
    return '${hours}h ago';
  }

  @override
  String daysAgo(String days) {
    return '${days}d ago';
  }

  @override
  String connectionFailedError(String error) {
    return 'Connection failed: $error';
  }

  @override
  String get enterPin => 'Enter PIN';

  @override
  String get unlockOPNsenseManager => 'Unlock OPNsense Manager';

  @override
  String get pleaseEnterYourPin => 'Please enter your PIN';

  @override
  String get incorrectPin => 'Incorrect PIN';

  @override
  String get unlock => 'Unlock';

  @override
  String get useBiometric => 'Use Biometric';

  @override
  String get authenticateToUnlock => 'Authenticate to unlock the app';

  @override
  String version(String version) {
    return 'Version $version';
  }

  @override
  String get remoteAddress => 'Remote Address';

  @override
  String get localAddress => 'Local Address';

  @override
  String get received => 'Received';

  @override
  String get sent => 'Sent';

  @override
  String get vpnStatus => 'VPN Status';

  @override
  String get connected => 'Connected';

  @override
  String get disconnected => 'Disconnected';

  @override
  String get disconnect => 'Disconnect';

  @override
  String get vpnType => 'VPN Type';

  @override
  String get clientAddress => 'Client Address';

  @override
  String get virtualAddress => 'Virtual Address';

  @override
  String get bytesReceived => 'Bytes Received';

  @override
  String get bytesSent => 'Bytes Sent';

  @override
  String get connectedSince => 'Connected Since';

  @override
  String get rebootSystem => 'Reboot System';

  @override
  String get rebootConfirmation =>
      'Are you sure you want to reboot the system?';

  @override
  String get rebootSuccess => 'System reboot initiated';

  @override
  String get rebootFailed => 'Failed to reboot system';

  @override
  String get error => 'Error';

  @override
  String get success => 'Success';

  @override
  String get warning => 'Warning';

  @override
  String get info => 'Information';

  @override
  String get noData => 'No data available';

  @override
  String get retry => 'Retry';

  @override
  String get confirmDelete => 'Confirm Delete';

  @override
  String get deleteConfirmation => 'Are you sure you want to delete this item?';

  @override
  String get cannotBeUndone => 'This action cannot be undone.';

  @override
  String get enterPIN => 'Enter PIN';

  @override
  String get confirmPIN => 'Confirm PIN';

  @override
  String get pinMismatch => 'PINs do not match';

  @override
  String get pinTooShort => 'PIN must be at least 4 digits';

  @override
  String get invalidPIN => 'Invalid PIN';

  @override
  String get minutes => 'minutes';

  @override
  String get seconds => 'seconds';

  @override
  String get hours => 'hours';

  @override
  String get days => 'days';

  @override
  String get required => 'Required';

  @override
  String get optional => 'Optional';

  @override
  String get invalidInput => 'Invalid input';

  @override
  String get fieldRequired => 'This field is required';

  @override
  String get exportSuccess => 'Export successful';

  @override
  String get exportFailed => 'Export failed';

  @override
  String get importSuccess => 'Import successful';

  @override
  String get importFailed => 'Import failed';

  @override
  String importedProfiles(int count) {
    return 'Imported $count profile(s)';
  }

  @override
  String get noProfilesFound => 'No profiles found';

  @override
  String get createFirstProfile => 'Create your first profile to get started';

  @override
  String get serviceStarted => 'Service started successfully';

  @override
  String get serviceStopped => 'Service stopped successfully';

  @override
  String get serviceRestarted => 'Service restarted successfully';

  @override
  String get serviceActionFailed => 'Service action failed';

  @override
  String get ruleActionFailed => 'Rule action failed';

  @override
  String get profileSaved => 'Profile saved successfully';

  @override
  String get profileDeleted => 'Profile deleted successfully';

  @override
  String get profileActivated => 'Profile activated successfully';

  @override
  String get authenticationRequired => 'Authentication Required';

  @override
  String get authenticationFailed => 'Authentication failed';

  @override
  String get networkError => 'Network error occurred';

  @override
  String get serverError => 'Server error occurred';

  @override
  String get unauthorized => 'Unauthorized access';

  @override
  String get forbidden => 'Access forbidden';

  @override
  String get notFound => 'Resource not found';

  @override
  String get timeout => 'Request timeout';

  @override
  String get none => 'None';

  @override
  String get diskUsage => 'Disk Usage';

  @override
  String get pinLockDisabled =>
      'PIN lock disabled. Biometric lock also disabled.';

  @override
  String get setPin => 'Set PIN';

  @override
  String get pinLockTitle => 'PIN Lock';

  @override
  String get requirePinToUnlock => 'Require PIN to unlock app';

  @override
  String get changePinTitle => 'Change PIN';

  @override
  String get updatePinCode => 'Update your PIN code';

  @override
  String get lockTimeoutLabel => 'Lock Timeout';

  @override
  String lockAfterMinutes(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'minutes',
      one: 'minute',
    );
    return 'Lock after $minutes $_temp0 of inactivity';
  }

  @override
  String get minute => 'minute';

  @override
  String get add => 'Add';

  @override
  String get profileAdded => 'Profile added';

  @override
  String get profileUpdated => 'Profile updated';

  @override
  String get exportProfilesTitle => 'Export Profiles';

  @override
  String get chooseExportLocation => 'Choose Export Location';

  @override
  String profilesExportedSuccessfully(String path) {
    return 'Profiles exported successfully!\n$path';
  }

  @override
  String exportFailedError(String error) {
    return 'Export failed: $error';
  }

  @override
  String get importProfilesTitle => 'Import Profiles';

  @override
  String invalidFileError(String error) {
    return 'Invalid file: $error';
  }

  @override
  String get importProfilesDialog =>
      'How should existing profiles be handled?\n\n• Keep Both: Import with new IDs\n• Overwrite: Replace existing profiles';

  @override
  String get keepBoth => 'Keep Both';

  @override
  String get overwrite => 'Overwrite';

  @override
  String successfullyImportedProfiles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 's',
      one: '',
    );
    return 'Successfully imported $count profile$_temp0';
  }

  @override
  String importFailedWithErrors(String errors) {
    return 'Import failed: $errors';
  }

  @override
  String importedWithFailures(int success, int failed) {
    String _temp0 = intl.Intl.pluralLogic(
      success,
      locale: localeName,
      other: 's',
      one: '',
    );
    return 'Imported $success profile$_temp0, $failed failed';
  }

  @override
  String get deleteProfileTitle => 'Delete Profile';

  @override
  String deleteProfileConfirmation(String name) {
    return 'Are you sure you want to delete \"$name\"?';
  }

  @override
  String get applicationLegalese =>
      '© 2026 OPNsense Manager\n\nLicensed under GNU General Public License v3.0\n\nThis program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.';

  @override
  String get aboutDescription =>
      'A professional Flutter mobile application for managing OPNsense firewall routers.';

  @override
  String get featuresTitle => 'Features';

  @override
  String get featuresList =>
      '• System monitoring and management\n• Firewall rule configuration\n• Service control\n• Real-time logs\n• Multi-profile support\n• Secure authentication';

  @override
  String get viewFullLicense => 'View Full License';

  @override
  String get gnuLicenseTitle => 'GNU General Public License v3.0';

  @override
  String get gnuLicenseText =>
      'This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.\n\nThis program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.\n\nYou should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.\n\nWhy GPLv3?\n\n• Ensures the software remains free and open source\n• Any modifications or derivatives must also be open source\n• Users have the freedom to use, study, share, and modify the software\n• The community benefits from improvements and contributions';

  @override
  String get enterPinLabel => 'Enter PIN (4-6 digits)';

  @override
  String get confirmPin => 'Confirm PIN';

  @override
  String get pinLockEnabled => 'PIN lock enabled';

  @override
  String get currentPin => 'Current PIN';

  @override
  String get newPin => 'New PIN (4-6 digits)';

  @override
  String get confirmNewPin => 'Confirm New PIN';

  @override
  String get currentPinIncorrect => 'Current PIN is incorrect';

  @override
  String get pinChangedSuccessfully => 'PIN changed successfully';

  @override
  String get pleaseEnterCurrentPin => 'Please enter your current PIN';

  @override
  String get pleaseEnterNewPin => 'Please enter a new PIN';

  @override
  String get pinMustContainOnlyNumbers => 'PIN must contain only numbers';

  @override
  String get newPinMustBeDifferent =>
      'New PIN must be different from current PIN';

  @override
  String get enablePinLockFirst =>
      'Please enable PIN lock first before using biometric';

  @override
  String get biometricNotAvailable =>
      'Biometric authentication is not available on this device';

  @override
  String get biometricLockEnabled => 'Biometric lock enabled';

  @override
  String get biometricAuthFailed =>
      'Biometric authentication failed or was cancelled';

  @override
  String get biometricLockDisabled => 'Biometric lock disabled';

  @override
  String biometricLockTitle(String biometricType) {
    return '$biometricType Lock';
  }

  @override
  String useBiometricToUnlock(String biometricType) {
    return 'Use $biometricType to unlock app';
  }

  @override
  String get enablePinLockFirstBiometric =>
      'Enable PIN lock first to use biometric';

  @override
  String get oneMin => '1 min';

  @override
  String get twoMin => '2 min';

  @override
  String get fiveMin => '5 min';

  @override
  String get tenMin => '10 min';

  @override
  String get fifteenMin => '15 min';

  @override
  String get thirtyMin => '30 min';

  @override
  String get oneHour => '1 hour';

  @override
  String lockTimeoutSet(int value) {
    String _temp0 = intl.Intl.pluralLogic(
      value,
      locale: localeName,
      other: 'minutes',
      one: 'minute',
    );
    return 'Lock timeout set to $value $_temp0';
  }

  @override
  String get activate => 'Activate';

  @override
  String get import => 'Import';

  @override
  String get export => 'Export';

  @override
  String get activatingProfile => 'Activating profile...';

  @override
  String activatedProfile(String name) {
    return 'Activated profile: $name';
  }

  @override
  String get connectionTestFailed => 'Connection test failed';

  @override
  String get profileNameLabel => 'Profile Name';

  @override
  String get hostIpAddressLabel => 'Host/IP Address';

  @override
  String get portLabel => 'Port';

  @override
  String get useHttpsLabel => 'Use HTTPS';

  @override
  String get apiKeyLabel => 'API Key';

  @override
  String get apiSecretLabel => 'API Secret';

  @override
  String get profileNameRequired => 'Profile name is required';

  @override
  String get exportProfilesContent =>
      'Do you want to include API credentials in the export?\n\nWARNING: Including credentials will store API keys and secrets in plain text. Only include credentials if you will store the file securely.';

  @override
  String get withoutCredentials => 'Without Credentials';

  @override
  String get includeCredentials => 'Include Credentials';

  @override
  String get exportProfile => 'Export Profile';

  @override
  String get exportProfileTitle => 'Export Profile';

  @override
  String get exportProfileContent =>
      'Do you want to include API credentials in the export?\n\nWARNING: Including credentials will store API keys and secrets in plain text. Only include credentials if you will store the file securely.';

  @override
  String get unableToAccessFilePath => 'Unable to access file path';

  @override
  String invalidFileFormat(String error) {
    return 'Invalid file: $error';
  }

  @override
  String get noProfiles => 'No Profiles';

  @override
  String get addProfileToManageInstances =>
      'Add a profile to manage OPNsense instances';

  @override
  String get unknown => 'Unknown';

  @override
  String get http => 'http';

  @override
  String get https => 'https';

  @override
  String errorPrefix(String message) {
    return 'Error: $message';
  }

  @override
  String get switchProfileConfirmation => 'Switch profile?';

  @override
  String rebootFailedWithError(String message, String error) {
    return '$message: $error';
  }

  @override
  String get zeroSeconds => '0 seconds';

  @override
  String get day => 'day';

  @override
  String get hour => 'hour';

  @override
  String get second => 'second';

  @override
  String get hostIsRequired => 'Host is required';

  @override
  String get invalidHostnameOrIp => 'Invalid hostname or IP address';

  @override
  String get portIsRequired => 'Port is required';

  @override
  String get portMustBeBetween => 'Port must be between 1 and 65535';

  @override
  String get apiKeyIsRequired => 'API Key is required';

  @override
  String get invalidApiKeyFormat => 'Invalid API Key format';

  @override
  String get apiSecretIsRequired => 'API Secret is required';

  @override
  String get invalidApiSecretFormat => 'Invalid API Secret format';

  @override
  String fieldIsRequired(String fieldName) {
    return '$fieldName is required';
  }

  @override
  String actionService(String action) {
    return '$action Service';
  }

  @override
  String confirmServiceAction(String action, String name) {
    return '$action \"$name\"?';
  }

  @override
  String actioningService(String action, String name) {
    return '$action $name...';
  }

  @override
  String get notAvailable => 'N/A';

  @override
  String get unitBytes => 'B';

  @override
  String get unitKilobytes => 'KB';

  @override
  String get unitMegabytes => 'MB';

  @override
  String get unitGigabytes => 'GB';

  @override
  String get unitTerabytes => 'TB';

  @override
  String get unitPetabytes => 'PB';

  @override
  String get unitPerSecond => '/s';

  @override
  String get hourAbbrev => 'h';

  @override
  String get minuteAbbrev => 'm';

  @override
  String get secondAbbrev => 's';

  @override
  String get liveNetworkMonitor => 'Live Network Monitor';

  @override
  String get searchHostnameOrIp => 'Search hostname or IP address...';

  @override
  String activeHosts(int count) {
    return '$count active host(s)';
  }

  @override
  String get noHostsFound => 'No hosts found';

  @override
  String get tryDifferentSearch => 'Try a different search term';

  @override
  String get download => 'Download';

  @override
  String get upload => 'Upload';

  @override
  String get totalBandwidth => 'Total Bandwidth';

  @override
  String get of1Gbps => 'of 1 Gbps';

  @override
  String get networkTotals => 'Network Totals';

  @override
  String get totalDownload => 'Total Download';

  @override
  String get totalUpload => 'Total Upload';

  @override
  String get activeDevices => 'Active Devices';

  @override
  String get sortBy => 'Sort By';

  @override
  String get sortByBandwidth => 'Bandwidth';

  @override
  String get sortByHostname => 'Hostname';

  @override
  String get sortByIP => 'IP Address';

  @override
  String get sortByManufacturer => 'Manufacturer';

  @override
  String get bandwidthLimit => 'Bandwidth Limit';

  @override
  String get bandwidthLimitMbps => 'Bandwidth Limit (Mbps)';

  @override
  String get enterBandwidthLimit =>
      'Enter your connection bandwidth limit in Mbps';

  @override
  String get macAddress => 'MAC Address';

  @override
  String get monitorInterface => 'Monitor Interface';

  @override
  String get selectMultipleInterfaces =>
      'Select one or more interfaces to monitor';

  @override
  String get dhcpLeases => 'DHCP Leases';

  @override
  String get searchHostnameIpOrMac => 'Search hostname, IP, or MAC address...';

  @override
  String leasesCount(int filtered, int total) {
    return '$filtered of $total lease(s)';
  }

  @override
  String get noLeasesFound => 'No leases found';

  @override
  String get all => 'All';

  @override
  String get active => 'Active';

  @override
  String get expired => 'Expired';

  @override
  String get expires => 'Expires';

  @override
  String get ipAddress => 'IP Address';

  @override
  String get staticLease => 'Static';

  @override
  String get dynamicLease => 'Dynamic';

  @override
  String get blockHost => 'Block Host';

  @override
  String blockHostConfirmation(String hostname, String ip) {
    return 'Are you sure you want to block $hostname ($ip)?\n\nThis will create a firewall rule to block all traffic from this host.';
  }

  @override
  String get blockingHost => 'Blocking host...';

  @override
  String get hostBlocked => 'Host blocked successfully';

  @override
  String get failedToBlockHost => 'Failed to block host';
}
