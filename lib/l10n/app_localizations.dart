import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
  ];

  /// The application name
  ///
  /// In en, this message translates to:
  /// **'OPNsense Manager'**
  String get appName;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @firewallRules.
  ///
  /// In en, this message translates to:
  /// **'Firewall Rules'**
  String get firewallRules;

  /// No description provided for @firewallLogs.
  ///
  /// In en, this message translates to:
  /// **'Firewall Logs'**
  String get firewallLogs;

  /// No description provided for @systemInfo.
  ///
  /// In en, this message translates to:
  /// **'System Information'**
  String get systemInfo;

  /// No description provided for @vpnConnections.
  ///
  /// In en, this message translates to:
  /// **'VPN Connections'**
  String get vpnConnections;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @hostname.
  ///
  /// In en, this message translates to:
  /// **'Hostname'**
  String get hostname;

  /// No description provided for @versionLabel.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get versionLabel;

  /// No description provided for @platform.
  ///
  /// In en, this message translates to:
  /// **'Platform'**
  String get platform;

  /// No description provided for @uptime.
  ///
  /// In en, this message translates to:
  /// **'Uptime'**
  String get uptime;

  /// No description provided for @cpuUsage.
  ///
  /// In en, this message translates to:
  /// **'CPU Usage'**
  String get cpuUsage;

  /// No description provided for @memoryUsage.
  ///
  /// In en, this message translates to:
  /// **'Memory Usage'**
  String get memoryUsage;

  /// No description provided for @services.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get services;

  /// No description provided for @gateways.
  ///
  /// In en, this message translates to:
  /// **'Gateways'**
  String get gateways;

  /// No description provided for @running.
  ///
  /// In en, this message translates to:
  /// **'Running'**
  String get running;

  /// No description provided for @stopped.
  ///
  /// In en, this message translates to:
  /// **'Stopped'**
  String get stopped;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @stop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stop;

  /// No description provided for @restart.
  ///
  /// In en, this message translates to:
  /// **'Restart'**
  String get restart;

  /// No description provided for @enable.
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get enable;

  /// No description provided for @disable.
  ///
  /// In en, this message translates to:
  /// **'Disable'**
  String get disable;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @host.
  ///
  /// In en, this message translates to:
  /// **'Host'**
  String get host;

  /// No description provided for @port.
  ///
  /// In en, this message translates to:
  /// **'Port'**
  String get port;

  /// No description provided for @apiKey.
  ///
  /// In en, this message translates to:
  /// **'API Key'**
  String get apiKey;

  /// No description provided for @apiSecret.
  ///
  /// In en, this message translates to:
  /// **'API Secret'**
  String get apiSecret;

  /// No description provided for @useHttps.
  ///
  /// In en, this message translates to:
  /// **'Use HTTPS'**
  String get useHttps;

  /// No description provided for @allowSelfSigned.
  ///
  /// In en, this message translates to:
  /// **'Allow Self-Signed Certificate'**
  String get allowSelfSigned;

  /// No description provided for @testConnection.
  ///
  /// In en, this message translates to:
  /// **'Test Connection'**
  String get testConnection;

  /// No description provided for @connectionSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Connection Successful'**
  String get connectionSuccessful;

  /// No description provided for @connectionFailed.
  ///
  /// In en, this message translates to:
  /// **'Connection failed. Check console logs for details.\n\nCommon issues:\n• Device not on same network as OPNsense\n• Wrong IP address or port\n• Firewall blocking connection\n• Invalid API credentials'**
  String get connectionFailed;

  /// No description provided for @profiles.
  ///
  /// In en, this message translates to:
  /// **'Profiles'**
  String get profiles;

  /// No description provided for @addProfile.
  ///
  /// In en, this message translates to:
  /// **'Add Profile'**
  String get addProfile;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @deleteProfile.
  ///
  /// In en, this message translates to:
  /// **'Delete Profile'**
  String get deleteProfile;

  /// No description provided for @profileName.
  ///
  /// In en, this message translates to:
  /// **'Profile Name'**
  String get profileName;

  /// No description provided for @activeProfile.
  ///
  /// In en, this message translates to:
  /// **'Active Profile'**
  String get activeProfile;

  /// No description provided for @switchProfile.
  ///
  /// In en, this message translates to:
  /// **'Switch Profile'**
  String get switchProfile;

  /// No description provided for @exportProfiles.
  ///
  /// In en, this message translates to:
  /// **'Export Profiles'**
  String get exportProfiles;

  /// No description provided for @importProfiles.
  ///
  /// In en, this message translates to:
  /// **'Import Profiles'**
  String get importProfiles;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @pinLock.
  ///
  /// In en, this message translates to:
  /// **'PIN Lock'**
  String get pinLock;

  /// No description provided for @changePIN.
  ///
  /// In en, this message translates to:
  /// **'Change PIN'**
  String get changePIN;

  /// No description provided for @biometricAuth.
  ///
  /// In en, this message translates to:
  /// **'Biometric Authentication'**
  String get biometricAuth;

  /// No description provided for @sessionTimeout.
  ///
  /// In en, this message translates to:
  /// **'Session Timeout'**
  String get sessionTimeout;

  /// No description provided for @lockApp.
  ///
  /// In en, this message translates to:
  /// **'Lock App'**
  String get lockApp;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @systemDefault.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get systemDefault;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @licenses.
  ///
  /// In en, this message translates to:
  /// **'Licenses'**
  String get licenses;

  /// No description provided for @firewallRuleDetails.
  ///
  /// In en, this message translates to:
  /// **'Firewall Rule Details'**
  String get firewallRuleDetails;

  /// No description provided for @createRule.
  ///
  /// In en, this message translates to:
  /// **'Create Rule'**
  String get createRule;

  /// No description provided for @editRule.
  ///
  /// In en, this message translates to:
  /// **'Edit Rule'**
  String get editRule;

  /// No description provided for @deleteRule.
  ///
  /// In en, this message translates to:
  /// **'Delete Rule'**
  String get deleteRule;

  /// No description provided for @action.
  ///
  /// In en, this message translates to:
  /// **'Action'**
  String get action;

  /// No description provided for @interface.
  ///
  /// In en, this message translates to:
  /// **'Interface'**
  String get interface;

  /// No description provided for @protocol.
  ///
  /// In en, this message translates to:
  /// **'Protocol'**
  String get protocol;

  /// No description provided for @source.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get source;

  /// No description provided for @destination.
  ///
  /// In en, this message translates to:
  /// **'Destination'**
  String get destination;

  /// No description provided for @sourcePort.
  ///
  /// In en, this message translates to:
  /// **'Source Port'**
  String get sourcePort;

  /// No description provided for @destinationPort.
  ///
  /// In en, this message translates to:
  /// **'Destination Port'**
  String get destinationPort;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @enabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get enabled;

  /// No description provided for @disabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get disabled;

  /// No description provided for @pass.
  ///
  /// In en, this message translates to:
  /// **'Pass'**
  String get pass;

  /// No description provided for @block.
  ///
  /// In en, this message translates to:
  /// **'Block'**
  String get block;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @logs.
  ///
  /// In en, this message translates to:
  /// **'Logs'**
  String get logs;

  /// No description provided for @filterByAction.
  ///
  /// In en, this message translates to:
  /// **'Filter by Action'**
  String get filterByAction;

  /// No description provided for @showAll.
  ///
  /// In en, this message translates to:
  /// **'Show All'**
  String get showAll;

  /// No description provided for @autoRefresh.
  ///
  /// In en, this message translates to:
  /// **'Auto Refresh'**
  String get autoRefresh;

  /// No description provided for @logLimit.
  ///
  /// In en, this message translates to:
  /// **'Log Limit'**
  String get logLimit;

  /// No description provided for @paused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get paused;

  /// No description provided for @live.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get live;

  /// No description provided for @entries.
  ///
  /// In en, this message translates to:
  /// **'entries'**
  String get entries;

  /// No description provided for @selected.
  ///
  /// In en, this message translates to:
  /// **'selected'**
  String get selected;

  /// No description provided for @selectAll.
  ///
  /// In en, this message translates to:
  /// **'Select All'**
  String get selectAll;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @historySize.
  ///
  /// In en, this message translates to:
  /// **'History Size'**
  String get historySize;

  /// No description provided for @enableAutoScroll.
  ///
  /// In en, this message translates to:
  /// **'Enable Auto-scroll'**
  String get enableAutoScroll;

  /// No description provided for @disableAutoScroll.
  ///
  /// In en, this message translates to:
  /// **'Disable Auto-scroll'**
  String get disableAutoScroll;

  /// No description provided for @clearLogs.
  ///
  /// In en, this message translates to:
  /// **'Clear Logs'**
  String get clearLogs;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @resume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resume;

  /// No description provided for @copiedLogEntries.
  ///
  /// In en, this message translates to:
  /// **'Copied {count} log {count, plural, =1{entry} other{entries}}'**
  String copiedLogEntries(int count);

  /// No description provided for @pauseLiveViewToSelect.
  ///
  /// In en, this message translates to:
  /// **'Pause live view to select log entries'**
  String get pauseLiveViewToSelect;

  /// No description provided for @errorLoadingLogs.
  ///
  /// In en, this message translates to:
  /// **'Error loading logs'**
  String get errorLoadingLogs;

  /// No description provided for @noLogsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No logs available'**
  String get noLogsAvailable;

  /// No description provided for @logsWillAppear.
  ///
  /// In en, this message translates to:
  /// **'Logs will appear here as they are generated'**
  String get logsWillAppear;

  /// No description provided for @selectNumberOfEntries.
  ///
  /// In en, this message translates to:
  /// **'Select the number of log entries to display:'**
  String get selectNumberOfEntries;

  /// No description provided for @reason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get reason;

  /// No description provided for @newRule.
  ///
  /// In en, this message translates to:
  /// **'New Rule'**
  String get newRule;

  /// No description provided for @ruleDetails.
  ///
  /// In en, this message translates to:
  /// **'Rule Details'**
  String get ruleDetails;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @sequence.
  ///
  /// In en, this message translates to:
  /// **'Sequence'**
  String get sequence;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @systemGeneratedRule.
  ///
  /// In en, this message translates to:
  /// **'This is a system-generated rule and cannot be modified or deleted.'**
  String get systemGeneratedRule;

  /// No description provided for @systemGeneratedRulesCannotBeModified.
  ///
  /// In en, this message translates to:
  /// **'System-generated rules cannot be modified'**
  String get systemGeneratedRulesCannotBeModified;

  /// No description provided for @systemGeneratedRulesCannotBeDeleted.
  ///
  /// In en, this message translates to:
  /// **'System-generated rules cannot be deleted'**
  String get systemGeneratedRulesCannotBeDeleted;

  /// No description provided for @enableRule.
  ///
  /// In en, this message translates to:
  /// **'Enable Rule'**
  String get enableRule;

  /// No description provided for @disableRule.
  ///
  /// In en, this message translates to:
  /// **'Disable Rule'**
  String get disableRule;

  /// No description provided for @enablingRule.
  ///
  /// In en, this message translates to:
  /// **'Enabling rule...'**
  String get enablingRule;

  /// No description provided for @disablingRule.
  ///
  /// In en, this message translates to:
  /// **'Disabling rule...'**
  String get disablingRule;

  /// No description provided for @ruleEnabledSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Rule enabled successfully'**
  String get ruleEnabledSuccessfully;

  /// No description provided for @ruleDisabledSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Rule disabled successfully'**
  String get ruleDisabledSuccessfully;

  /// No description provided for @errorTogglingRule.
  ///
  /// In en, this message translates to:
  /// **'Error toggling rule: {error}'**
  String errorTogglingRule(String error);

  /// No description provided for @deleteRuleConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the rule \"{description}\"?'**
  String deleteRuleConfirmation(String description);

  /// No description provided for @ruleDeleted.
  ///
  /// In en, this message translates to:
  /// **'Rule deleted successfully'**
  String get ruleDeleted;

  /// No description provided for @errorDeletingRule.
  ///
  /// In en, this message translates to:
  /// **'Error deleting rule: {error}'**
  String errorDeletingRule(String error);

  /// No description provided for @errorLoadingRules.
  ///
  /// In en, this message translates to:
  /// **'Error loading rules'**
  String get errorLoadingRules;

  /// No description provided for @noAutomationRulesFound.
  ///
  /// In en, this message translates to:
  /// **'No automation rules found'**
  String get noAutomationRulesFound;

  /// No description provided for @createFirstAutomationRule.
  ///
  /// In en, this message translates to:
  /// **'Create your first automation rule to get started'**
  String get createFirstAutomationRule;

  /// No description provided for @noInterfacesWithAutomationRules.
  ///
  /// In en, this message translates to:
  /// **'No interfaces with automation rules'**
  String get noInterfacesWithAutomationRules;

  /// No description provided for @selectInterface.
  ///
  /// In en, this message translates to:
  /// **'Select Interface'**
  String get selectInterface;

  /// No description provided for @selectInterfaceToViewRules.
  ///
  /// In en, this message translates to:
  /// **'Select an interface to view rules'**
  String get selectInterfaceToViewRules;

  /// No description provided for @noRulesForInterface.
  ///
  /// In en, this message translates to:
  /// **'No rules for {interface}'**
  String noRulesForInterface(String interface);

  /// No description provided for @unnamedRule.
  ///
  /// In en, this message translates to:
  /// **'Unnamed Rule'**
  String get unnamedRule;

  /// No description provided for @systemInformation.
  ///
  /// In en, this message translates to:
  /// **'System Information'**
  String get systemInformation;

  /// No description provided for @firmwareDetails.
  ///
  /// In en, this message translates to:
  /// **'Firmware Details'**
  String get firmwareDetails;

  /// No description provided for @systemType.
  ///
  /// In en, this message translates to:
  /// **'System Type'**
  String get systemType;

  /// No description provided for @architecture.
  ///
  /// In en, this message translates to:
  /// **'Architecture'**
  String get architecture;

  /// No description provided for @gitCommit.
  ///
  /// In en, this message translates to:
  /// **'Git Commit'**
  String get gitCommit;

  /// No description provided for @packageMirror.
  ///
  /// In en, this message translates to:
  /// **'Package Mirror'**
  String get packageMirror;

  /// No description provided for @repository.
  ///
  /// In en, this message translates to:
  /// **'Repository'**
  String get repository;

  /// No description provided for @lastUpdate.
  ///
  /// In en, this message translates to:
  /// **'Last Update'**
  String get lastUpdate;

  /// No description provided for @errorLoadingSystemInfo.
  ///
  /// In en, this message translates to:
  /// **'Error loading system information'**
  String get errorLoadingSystemInfo;

  /// No description provided for @errorLoadingVPNConnections.
  ///
  /// In en, this message translates to:
  /// **'Error loading VPN connections'**
  String get errorLoadingVPNConnections;

  /// No description provided for @noVPNConnectionsFound.
  ///
  /// In en, this message translates to:
  /// **'No VPN connections found'**
  String get noVPNConnectionsFound;

  /// No description provided for @noConnectionsFound.
  ///
  /// In en, this message translates to:
  /// **'No {type} connections found'**
  String noConnectionsFound(String type);

  /// No description provided for @vpnConnectionsWillAppear.
  ///
  /// In en, this message translates to:
  /// **'VPN connections will appear here when configured'**
  String get vpnConnectionsWillAppear;

  /// No description provided for @totalVPNs.
  ///
  /// In en, this message translates to:
  /// **'Total VPNs'**
  String get totalVPNs;

  /// No description provided for @filterByType.
  ///
  /// In en, this message translates to:
  /// **'Filter by type'**
  String get filterByType;

  /// No description provided for @allVPNs.
  ///
  /// In en, this message translates to:
  /// **'All VPNs'**
  String get allVPNs;

  /// No description provided for @connectVPN.
  ///
  /// In en, this message translates to:
  /// **'Connect VPN'**
  String get connectVPN;

  /// No description provided for @disconnectVPN.
  ///
  /// In en, this message translates to:
  /// **'Disconnect VPN'**
  String get disconnectVPN;

  /// No description provided for @connectingVPN.
  ///
  /// In en, this message translates to:
  /// **'Connecting {name}...'**
  String connectingVPN(String name);

  /// No description provided for @disconnectingVPN.
  ///
  /// In en, this message translates to:
  /// **'Disconnecting {name}...'**
  String disconnectingVPN(String name);

  /// No description provided for @successfullyConnected.
  ///
  /// In en, this message translates to:
  /// **'Successfully connected {name}'**
  String successfullyConnected(String name);

  /// No description provided for @successfullyDisconnected.
  ///
  /// In en, this message translates to:
  /// **'Successfully disconnected {name}'**
  String successfullyDisconnected(String name);

  /// No description provided for @failedToConnect.
  ///
  /// In en, this message translates to:
  /// **'Failed to connect {name}'**
  String failedToConnect(String name);

  /// No description provided for @failedToDisconnect.
  ///
  /// In en, this message translates to:
  /// **'Failed to disconnect {name}'**
  String failedToDisconnect(String name);

  /// No description provided for @restartVPNService.
  ///
  /// In en, this message translates to:
  /// **'Restart VPN Service'**
  String get restartVPNService;

  /// No description provided for @restartServiceConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to restart the {type} service?\n\nThis will temporarily disconnect all active connections.'**
  String restartServiceConfirmation(String type);

  /// No description provided for @restartingService.
  ///
  /// In en, this message translates to:
  /// **'Restarting {type} service...'**
  String restartingService(String type);

  /// No description provided for @successfullyRestartedService.
  ///
  /// In en, this message translates to:
  /// **'Successfully restarted {type} service'**
  String successfullyRestartedService(String type);

  /// No description provided for @failedToRestartService.
  ///
  /// In en, this message translates to:
  /// **'Failed to restart {type} service'**
  String failedToRestartService(String type);

  /// No description provided for @enterRuleDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter rule description'**
  String get enterRuleDescription;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @any.
  ///
  /// In en, this message translates to:
  /// **'Any'**
  String get any;

  /// No description provided for @anyIpAddressCidrOrAlias.
  ///
  /// In en, this message translates to:
  /// **'any, IP address, CIDR, or alias'**
  String get anyIpAddressCidrOrAlias;

  /// No description provided for @examplesAnyIpCidr.
  ///
  /// In en, this message translates to:
  /// **'Examples: any, 192.168.1.0/24, 10.0.0.1'**
  String get examplesAnyIpCidr;

  /// No description provided for @sourceIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Source is required'**
  String get sourceIsRequired;

  /// No description provided for @invalidSourceFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid source format'**
  String get invalidSourceFormat;

  /// No description provided for @sourcePortOptional.
  ///
  /// In en, this message translates to:
  /// **'Source Port (Optional)'**
  String get sourcePortOptional;

  /// No description provided for @anyPortNumberRangeOrAlias.
  ///
  /// In en, this message translates to:
  /// **'any, port number, range, or alias'**
  String get anyPortNumberRangeOrAlias;

  /// No description provided for @examplesAnyPortRange.
  ///
  /// In en, this message translates to:
  /// **'Examples: any, 80, 1024-65535'**
  String get examplesAnyPortRange;

  /// No description provided for @invalidPortFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid port format'**
  String get invalidPortFormat;

  /// No description provided for @destinationIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Destination is required'**
  String get destinationIsRequired;

  /// No description provided for @invalidDestinationFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid destination format'**
  String get invalidDestinationFormat;

  /// No description provided for @destinationPortOptional.
  ///
  /// In en, this message translates to:
  /// **'Destination Port (Optional)'**
  String get destinationPortOptional;

  /// No description provided for @examplesAnyPortRangeHttp.
  ///
  /// In en, this message translates to:
  /// **'Examples: any, 80, 80-443, http'**
  String get examplesAnyPortRangeHttp;

  /// No description provided for @ruleWillBeActiveWhenEnabled.
  ///
  /// In en, this message translates to:
  /// **'Rule will be active when enabled'**
  String get ruleWillBeActiveWhenEnabled;

  /// No description provided for @ruleGuidelines.
  ///
  /// In en, this message translates to:
  /// **'Rule Guidelines'**
  String get ruleGuidelines;

  /// No description provided for @ruleGuidelinesText.
  ///
  /// In en, this message translates to:
  /// **'• Use \"any\" to match all addresses or ports\n• CIDR notation: 192.168.1.0/24\n• Port ranges: 80-443\n• Rules are processed in sequence order\n• Changes are applied immediately'**
  String get ruleGuidelinesText;

  /// No description provided for @updateRule.
  ///
  /// In en, this message translates to:
  /// **'Update Rule'**
  String get updateRule;

  /// No description provided for @ruleUpdated.
  ///
  /// In en, this message translates to:
  /// **'Rule updated successfully'**
  String get ruleUpdated;

  /// No description provided for @ruleCreated.
  ///
  /// In en, this message translates to:
  /// **'Rule created successfully'**
  String get ruleCreated;

  /// No description provided for @errorSavingRule.
  ///
  /// In en, this message translates to:
  /// **'Error saving rule: {error}'**
  String errorSavingRule(String error);

  /// No description provided for @connectToYourOPNsenseFirewall.
  ///
  /// In en, this message translates to:
  /// **'Connect to your OPNsense firewall'**
  String get connectToYourOPNsenseFirewall;

  /// No description provided for @profileNameOptional.
  ///
  /// In en, this message translates to:
  /// **'Profile Name (Optional)'**
  String get profileNameOptional;

  /// No description provided for @myOPNsenseRouter.
  ///
  /// In en, this message translates to:
  /// **'My OPNsense Router'**
  String get myOPNsenseRouter;

  /// No description provided for @hostIpAddress.
  ///
  /// In en, this message translates to:
  /// **'Host / IP Address'**
  String get hostIpAddress;

  /// No description provided for @hostPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'192.168.1.1 or firewall.example.com'**
  String get hostPlaceholder;

  /// No description provided for @portPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'443'**
  String get portPlaceholder;

  /// No description provided for @recommendedForSecureConnections.
  ///
  /// In en, this message translates to:
  /// **'Recommended for secure connections'**
  String get recommendedForSecureConnections;

  /// No description provided for @enterYourApiKey.
  ///
  /// In en, this message translates to:
  /// **'Enter your API key'**
  String get enterYourApiKey;

  /// No description provided for @enterYourApiSecret.
  ///
  /// In en, this message translates to:
  /// **'Enter your API secret'**
  String get enterYourApiSecret;

  /// No description provided for @connect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get connect;

  /// No description provided for @apiError.
  ///
  /// In en, this message translates to:
  /// **'API Error: {message}'**
  String apiError(String message);

  /// No description provided for @needHelpCheckDocumentation.
  ///
  /// In en, this message translates to:
  /// **'Need help? Check the OPNsense documentation for API key generation.'**
  String get needHelpCheckDocumentation;

  /// No description provided for @selectAProfileOrCreateNewOne.
  ///
  /// In en, this message translates to:
  /// **'Select a profile or create a new one'**
  String get selectAProfileOrCreateNewOne;

  /// No description provided for @createNewProfile.
  ///
  /// In en, this message translates to:
  /// **'Create New Profile'**
  String get createNewProfile;

  /// No description provided for @noProfilesYet.
  ///
  /// In en, this message translates to:
  /// **'No Profiles Yet'**
  String get noProfilesYet;

  /// No description provided for @createYourFirstProfile.
  ///
  /// In en, this message translates to:
  /// **'Create your first OPNsense profile to get started'**
  String get createYourFirstProfile;

  /// No description provided for @lastUsed.
  ///
  /// In en, this message translates to:
  /// **'Last used: {date}'**
  String lastUsed(String date);

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{minutes}m ago'**
  String minutesAgo(String minutes);

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{hours}h ago'**
  String hoursAgo(String hours);

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{days}d ago'**
  String daysAgo(String days);

  /// No description provided for @connectionFailedError.
  ///
  /// In en, this message translates to:
  /// **'Connection failed: {error}'**
  String connectionFailedError(String error);

  /// No description provided for @enterPin.
  ///
  /// In en, this message translates to:
  /// **'Enter PIN'**
  String get enterPin;

  /// No description provided for @unlockOPNsenseManager.
  ///
  /// In en, this message translates to:
  /// **'Unlock OPNsense Manager'**
  String get unlockOPNsenseManager;

  /// No description provided for @pleaseEnterYourPin.
  ///
  /// In en, this message translates to:
  /// **'Please enter your PIN'**
  String get pleaseEnterYourPin;

  /// No description provided for @incorrectPin.
  ///
  /// In en, this message translates to:
  /// **'Incorrect PIN'**
  String get incorrectPin;

  /// No description provided for @unlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get unlock;

  /// No description provided for @useBiometric.
  ///
  /// In en, this message translates to:
  /// **'Use Biometric'**
  String get useBiometric;

  /// No description provided for @authenticateToUnlock.
  ///
  /// In en, this message translates to:
  /// **'Authenticate to unlock the app'**
  String get authenticateToUnlock;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String version(String version);

  /// No description provided for @remoteAddress.
  ///
  /// In en, this message translates to:
  /// **'Remote Address'**
  String get remoteAddress;

  /// No description provided for @localAddress.
  ///
  /// In en, this message translates to:
  /// **'Local Address'**
  String get localAddress;

  /// No description provided for @received.
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get received;

  /// No description provided for @sent.
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get sent;

  /// No description provided for @vpnStatus.
  ///
  /// In en, this message translates to:
  /// **'VPN Status'**
  String get vpnStatus;

  /// No description provided for @connected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get connected;

  /// No description provided for @disconnected.
  ///
  /// In en, this message translates to:
  /// **'Disconnected'**
  String get disconnected;

  /// No description provided for @disconnect.
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get disconnect;

  /// No description provided for @vpnType.
  ///
  /// In en, this message translates to:
  /// **'VPN Type'**
  String get vpnType;

  /// No description provided for @clientAddress.
  ///
  /// In en, this message translates to:
  /// **'Client Address'**
  String get clientAddress;

  /// No description provided for @virtualAddress.
  ///
  /// In en, this message translates to:
  /// **'Virtual Address'**
  String get virtualAddress;

  /// No description provided for @bytesReceived.
  ///
  /// In en, this message translates to:
  /// **'Bytes Received'**
  String get bytesReceived;

  /// No description provided for @bytesSent.
  ///
  /// In en, this message translates to:
  /// **'Bytes Sent'**
  String get bytesSent;

  /// No description provided for @connectedSince.
  ///
  /// In en, this message translates to:
  /// **'Connected Since'**
  String get connectedSince;

  /// No description provided for @rebootSystem.
  ///
  /// In en, this message translates to:
  /// **'Reboot System'**
  String get rebootSystem;

  /// No description provided for @rebootConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reboot the system?'**
  String get rebootConfirmation;

  /// No description provided for @rebootSuccess.
  ///
  /// In en, this message translates to:
  /// **'System reboot initiated'**
  String get rebootSuccess;

  /// No description provided for @rebootFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to reboot system'**
  String get rebootFailed;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get info;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noData;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get confirmDelete;

  /// No description provided for @deleteConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this item?'**
  String get deleteConfirmation;

  /// No description provided for @cannotBeUndone.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get cannotBeUndone;

  /// No description provided for @enterPIN.
  ///
  /// In en, this message translates to:
  /// **'Enter PIN'**
  String get enterPIN;

  /// No description provided for @confirmPIN.
  ///
  /// In en, this message translates to:
  /// **'Confirm PIN'**
  String get confirmPIN;

  /// No description provided for @pinMismatch.
  ///
  /// In en, this message translates to:
  /// **'PINs do not match'**
  String get pinMismatch;

  /// No description provided for @pinTooShort.
  ///
  /// In en, this message translates to:
  /// **'PIN must be at least 4 digits'**
  String get pinTooShort;

  /// No description provided for @invalidPIN.
  ///
  /// In en, this message translates to:
  /// **'Invalid PIN'**
  String get invalidPIN;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get minutes;

  /// No description provided for @seconds.
  ///
  /// In en, this message translates to:
  /// **'seconds'**
  String get seconds;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'hours'**
  String get hours;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get days;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// No description provided for @invalidInput.
  ///
  /// In en, this message translates to:
  /// **'Invalid input'**
  String get invalidInput;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get fieldRequired;

  /// No description provided for @exportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Export successful'**
  String get exportSuccess;

  /// No description provided for @exportFailed.
  ///
  /// In en, this message translates to:
  /// **'Export failed'**
  String get exportFailed;

  /// No description provided for @importSuccess.
  ///
  /// In en, this message translates to:
  /// **'Import successful'**
  String get importSuccess;

  /// No description provided for @importFailed.
  ///
  /// In en, this message translates to:
  /// **'Import failed'**
  String get importFailed;

  /// No description provided for @importedProfiles.
  ///
  /// In en, this message translates to:
  /// **'Imported {count} profile(s)'**
  String importedProfiles(int count);

  /// No description provided for @noProfilesFound.
  ///
  /// In en, this message translates to:
  /// **'No profiles found'**
  String get noProfilesFound;

  /// No description provided for @createFirstProfile.
  ///
  /// In en, this message translates to:
  /// **'Create your first profile to get started'**
  String get createFirstProfile;

  /// No description provided for @serviceStarted.
  ///
  /// In en, this message translates to:
  /// **'Service started successfully'**
  String get serviceStarted;

  /// No description provided for @serviceStopped.
  ///
  /// In en, this message translates to:
  /// **'Service stopped successfully'**
  String get serviceStopped;

  /// No description provided for @serviceRestarted.
  ///
  /// In en, this message translates to:
  /// **'Service restarted successfully'**
  String get serviceRestarted;

  /// No description provided for @serviceActionFailed.
  ///
  /// In en, this message translates to:
  /// **'Service action failed'**
  String get serviceActionFailed;

  /// No description provided for @ruleActionFailed.
  ///
  /// In en, this message translates to:
  /// **'Rule action failed'**
  String get ruleActionFailed;

  /// No description provided for @profileSaved.
  ///
  /// In en, this message translates to:
  /// **'Profile saved successfully'**
  String get profileSaved;

  /// No description provided for @profileDeleted.
  ///
  /// In en, this message translates to:
  /// **'Profile deleted successfully'**
  String get profileDeleted;

  /// No description provided for @profileActivated.
  ///
  /// In en, this message translates to:
  /// **'Profile activated successfully'**
  String get profileActivated;

  /// No description provided for @authenticationRequired.
  ///
  /// In en, this message translates to:
  /// **'Authentication Required'**
  String get authenticationRequired;

  /// No description provided for @authenticationFailed.
  ///
  /// In en, this message translates to:
  /// **'Authentication failed'**
  String get authenticationFailed;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Network error occurred'**
  String get networkError;

  /// No description provided for @serverError.
  ///
  /// In en, this message translates to:
  /// **'Server error occurred'**
  String get serverError;

  /// No description provided for @unauthorized.
  ///
  /// In en, this message translates to:
  /// **'Unauthorized access'**
  String get unauthorized;

  /// No description provided for @forbidden.
  ///
  /// In en, this message translates to:
  /// **'Access forbidden'**
  String get forbidden;

  /// No description provided for @notFound.
  ///
  /// In en, this message translates to:
  /// **'Resource not found'**
  String get notFound;

  /// No description provided for @timeout.
  ///
  /// In en, this message translates to:
  /// **'Request timeout'**
  String get timeout;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @diskUsage.
  ///
  /// In en, this message translates to:
  /// **'Disk Usage'**
  String get diskUsage;

  /// No description provided for @pinLockDisabled.
  ///
  /// In en, this message translates to:
  /// **'PIN lock disabled. Biometric lock also disabled.'**
  String get pinLockDisabled;

  /// No description provided for @setPin.
  ///
  /// In en, this message translates to:
  /// **'Set PIN'**
  String get setPin;

  /// No description provided for @pinLockTitle.
  ///
  /// In en, this message translates to:
  /// **'PIN Lock'**
  String get pinLockTitle;

  /// No description provided for @requirePinToUnlock.
  ///
  /// In en, this message translates to:
  /// **'Require PIN to unlock app'**
  String get requirePinToUnlock;

  /// No description provided for @changePinTitle.
  ///
  /// In en, this message translates to:
  /// **'Change PIN'**
  String get changePinTitle;

  /// No description provided for @updatePinCode.
  ///
  /// In en, this message translates to:
  /// **'Update your PIN code'**
  String get updatePinCode;

  /// No description provided for @lockTimeoutLabel.
  ///
  /// In en, this message translates to:
  /// **'Lock Timeout'**
  String get lockTimeoutLabel;

  /// No description provided for @lockAfterMinutes.
  ///
  /// In en, this message translates to:
  /// **'Lock after {minutes} {minutes, plural, =1{minute} other{minutes}} of inactivity'**
  String lockAfterMinutes(int minutes);

  /// No description provided for @minute.
  ///
  /// In en, this message translates to:
  /// **'minute'**
  String get minute;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @profileAdded.
  ///
  /// In en, this message translates to:
  /// **'Profile added'**
  String get profileAdded;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated'**
  String get profileUpdated;

  /// No description provided for @exportProfilesTitle.
  ///
  /// In en, this message translates to:
  /// **'Export Profiles'**
  String get exportProfilesTitle;

  /// No description provided for @chooseExportLocation.
  ///
  /// In en, this message translates to:
  /// **'Choose Export Location'**
  String get chooseExportLocation;

  /// No description provided for @profilesExportedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Profiles exported successfully!\n{path}'**
  String profilesExportedSuccessfully(String path);

  /// No description provided for @exportFailedError.
  ///
  /// In en, this message translates to:
  /// **'Export failed: {error}'**
  String exportFailedError(String error);

  /// No description provided for @importProfilesTitle.
  ///
  /// In en, this message translates to:
  /// **'Import Profiles'**
  String get importProfilesTitle;

  /// No description provided for @invalidFileError.
  ///
  /// In en, this message translates to:
  /// **'Invalid file: {error}'**
  String invalidFileError(String error);

  /// No description provided for @importProfilesDialog.
  ///
  /// In en, this message translates to:
  /// **'How should existing profiles be handled?\n\n• Keep Both: Import with new IDs\n• Overwrite: Replace existing profiles'**
  String get importProfilesDialog;

  /// No description provided for @keepBoth.
  ///
  /// In en, this message translates to:
  /// **'Keep Both'**
  String get keepBoth;

  /// No description provided for @overwrite.
  ///
  /// In en, this message translates to:
  /// **'Overwrite'**
  String get overwrite;

  /// No description provided for @successfullyImportedProfiles.
  ///
  /// In en, this message translates to:
  /// **'Successfully imported {count} profile{count, plural, =1{} other{s}}'**
  String successfullyImportedProfiles(int count);

  /// No description provided for @importFailedWithErrors.
  ///
  /// In en, this message translates to:
  /// **'Import failed: {errors}'**
  String importFailedWithErrors(String errors);

  /// No description provided for @importedWithFailures.
  ///
  /// In en, this message translates to:
  /// **'Imported {success} profile{success, plural, =1{} other{s}}, {failed} failed'**
  String importedWithFailures(int success, int failed);

  /// No description provided for @deleteProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Profile'**
  String get deleteProfileTitle;

  /// No description provided for @deleteProfileConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"?'**
  String deleteProfileConfirmation(String name);

  /// No description provided for @applicationLegalese.
  ///
  /// In en, this message translates to:
  /// **'© 2026 OPNsense Manager\n\nLicensed under GNU General Public License v3.0\n\nThis program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.'**
  String get applicationLegalese;

  /// No description provided for @aboutDescription.
  ///
  /// In en, this message translates to:
  /// **'A professional Flutter mobile application for managing OPNsense firewall routers.'**
  String get aboutDescription;

  /// No description provided for @featuresTitle.
  ///
  /// In en, this message translates to:
  /// **'Features'**
  String get featuresTitle;

  /// No description provided for @featuresList.
  ///
  /// In en, this message translates to:
  /// **'• System monitoring and management\n• Firewall rule configuration\n• Service control\n• Real-time logs\n• Multi-profile support\n• Secure authentication'**
  String get featuresList;

  /// No description provided for @viewFullLicense.
  ///
  /// In en, this message translates to:
  /// **'View Full License'**
  String get viewFullLicense;

  /// No description provided for @gnuLicenseTitle.
  ///
  /// In en, this message translates to:
  /// **'GNU General Public License v3.0'**
  String get gnuLicenseTitle;

  /// No description provided for @gnuLicenseText.
  ///
  /// In en, this message translates to:
  /// **'This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.\n\nThis program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.\n\nYou should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.\n\nWhy GPLv3?\n\n• Ensures the software remains free and open source\n• Any modifications or derivatives must also be open source\n• Users have the freedom to use, study, share, and modify the software\n• The community benefits from improvements and contributions'**
  String get gnuLicenseText;

  /// No description provided for @enterPinLabel.
  ///
  /// In en, this message translates to:
  /// **'Enter PIN (4-6 digits)'**
  String get enterPinLabel;

  /// No description provided for @confirmPin.
  ///
  /// In en, this message translates to:
  /// **'Confirm PIN'**
  String get confirmPin;

  /// No description provided for @pinLockEnabled.
  ///
  /// In en, this message translates to:
  /// **'PIN lock enabled'**
  String get pinLockEnabled;

  /// No description provided for @currentPin.
  ///
  /// In en, this message translates to:
  /// **'Current PIN'**
  String get currentPin;

  /// No description provided for @newPin.
  ///
  /// In en, this message translates to:
  /// **'New PIN (4-6 digits)'**
  String get newPin;

  /// No description provided for @confirmNewPin.
  ///
  /// In en, this message translates to:
  /// **'Confirm New PIN'**
  String get confirmNewPin;

  /// No description provided for @currentPinIncorrect.
  ///
  /// In en, this message translates to:
  /// **'Current PIN is incorrect'**
  String get currentPinIncorrect;

  /// No description provided for @pinChangedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'PIN changed successfully'**
  String get pinChangedSuccessfully;

  /// No description provided for @pleaseEnterCurrentPin.
  ///
  /// In en, this message translates to:
  /// **'Please enter your current PIN'**
  String get pleaseEnterCurrentPin;

  /// No description provided for @pleaseEnterNewPin.
  ///
  /// In en, this message translates to:
  /// **'Please enter a new PIN'**
  String get pleaseEnterNewPin;

  /// No description provided for @pinMustContainOnlyNumbers.
  ///
  /// In en, this message translates to:
  /// **'PIN must contain only numbers'**
  String get pinMustContainOnlyNumbers;

  /// No description provided for @newPinMustBeDifferent.
  ///
  /// In en, this message translates to:
  /// **'New PIN must be different from current PIN'**
  String get newPinMustBeDifferent;

  /// No description provided for @enablePinLockFirst.
  ///
  /// In en, this message translates to:
  /// **'Please enable PIN lock first before using biometric'**
  String get enablePinLockFirst;

  /// No description provided for @biometricNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Biometric authentication is not available on this device'**
  String get biometricNotAvailable;

  /// No description provided for @biometricLockEnabled.
  ///
  /// In en, this message translates to:
  /// **'Biometric lock enabled'**
  String get biometricLockEnabled;

  /// No description provided for @biometricAuthFailed.
  ///
  /// In en, this message translates to:
  /// **'Biometric authentication failed or was cancelled'**
  String get biometricAuthFailed;

  /// No description provided for @biometricLockDisabled.
  ///
  /// In en, this message translates to:
  /// **'Biometric lock disabled'**
  String get biometricLockDisabled;

  /// No description provided for @biometricLockTitle.
  ///
  /// In en, this message translates to:
  /// **'{biometricType} Lock'**
  String biometricLockTitle(String biometricType);

  /// No description provided for @useBiometricToUnlock.
  ///
  /// In en, this message translates to:
  /// **'Use {biometricType} to unlock app'**
  String useBiometricToUnlock(String biometricType);

  /// No description provided for @enablePinLockFirstBiometric.
  ///
  /// In en, this message translates to:
  /// **'Enable PIN lock first to use biometric'**
  String get enablePinLockFirstBiometric;

  /// No description provided for @oneMin.
  ///
  /// In en, this message translates to:
  /// **'1 min'**
  String get oneMin;

  /// No description provided for @twoMin.
  ///
  /// In en, this message translates to:
  /// **'2 min'**
  String get twoMin;

  /// No description provided for @fiveMin.
  ///
  /// In en, this message translates to:
  /// **'5 min'**
  String get fiveMin;

  /// No description provided for @tenMin.
  ///
  /// In en, this message translates to:
  /// **'10 min'**
  String get tenMin;

  /// No description provided for @fifteenMin.
  ///
  /// In en, this message translates to:
  /// **'15 min'**
  String get fifteenMin;

  /// No description provided for @thirtyMin.
  ///
  /// In en, this message translates to:
  /// **'30 min'**
  String get thirtyMin;

  /// No description provided for @oneHour.
  ///
  /// In en, this message translates to:
  /// **'1 hour'**
  String get oneHour;

  /// No description provided for @lockTimeoutSet.
  ///
  /// In en, this message translates to:
  /// **'Lock timeout set to {value} {value, plural, =1{minute} other{minutes}}'**
  String lockTimeoutSet(int value);

  /// No description provided for @activate.
  ///
  /// In en, this message translates to:
  /// **'Activate'**
  String get activate;

  /// No description provided for @import.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get import;

  /// No description provided for @export.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get export;

  /// No description provided for @activatingProfile.
  ///
  /// In en, this message translates to:
  /// **'Activating profile...'**
  String get activatingProfile;

  /// No description provided for @activatedProfile.
  ///
  /// In en, this message translates to:
  /// **'Activated profile: {name}'**
  String activatedProfile(String name);

  /// No description provided for @connectionTestFailed.
  ///
  /// In en, this message translates to:
  /// **'Connection test failed'**
  String get connectionTestFailed;

  /// No description provided for @profileNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Profile Name'**
  String get profileNameLabel;

  /// No description provided for @hostIpAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Host/IP Address'**
  String get hostIpAddressLabel;

  /// No description provided for @portLabel.
  ///
  /// In en, this message translates to:
  /// **'Port'**
  String get portLabel;

  /// No description provided for @useHttpsLabel.
  ///
  /// In en, this message translates to:
  /// **'Use HTTPS'**
  String get useHttpsLabel;

  /// No description provided for @apiKeyLabel.
  ///
  /// In en, this message translates to:
  /// **'API Key'**
  String get apiKeyLabel;

  /// No description provided for @apiSecretLabel.
  ///
  /// In en, this message translates to:
  /// **'API Secret'**
  String get apiSecretLabel;

  /// No description provided for @profileNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Profile name is required'**
  String get profileNameRequired;

  /// No description provided for @exportProfilesContent.
  ///
  /// In en, this message translates to:
  /// **'Do you want to include API credentials in the export?\n\nWARNING: Including credentials will store API keys and secrets in plain text. Only include credentials if you will store the file securely.'**
  String get exportProfilesContent;

  /// No description provided for @withoutCredentials.
  ///
  /// In en, this message translates to:
  /// **'Without Credentials'**
  String get withoutCredentials;

  /// No description provided for @includeCredentials.
  ///
  /// In en, this message translates to:
  /// **'Include Credentials'**
  String get includeCredentials;

  /// No description provided for @unableToAccessFilePath.
  ///
  /// In en, this message translates to:
  /// **'Unable to access file path'**
  String get unableToAccessFilePath;

  /// No description provided for @invalidFileFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid file: {error}'**
  String invalidFileFormat(String error);

  /// No description provided for @noProfiles.
  ///
  /// In en, this message translates to:
  /// **'No Profiles'**
  String get noProfiles;

  /// No description provided for @addProfileToManageInstances.
  ///
  /// In en, this message translates to:
  /// **'Add a profile to manage OPNsense instances'**
  String get addProfileToManageInstances;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @http.
  ///
  /// In en, this message translates to:
  /// **'http'**
  String get http;

  /// No description provided for @https.
  ///
  /// In en, this message translates to:
  /// **'https'**
  String get https;

  /// No description provided for @errorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String errorPrefix(String message);

  /// No description provided for @switchProfileConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Switch profile?'**
  String get switchProfileConfirmation;

  /// No description provided for @rebootFailedWithError.
  ///
  /// In en, this message translates to:
  /// **'{message}: {error}'**
  String rebootFailedWithError(String message, String error);

  /// No description provided for @zeroSeconds.
  ///
  /// In en, this message translates to:
  /// **'0 seconds'**
  String get zeroSeconds;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'day'**
  String get day;

  /// No description provided for @hour.
  ///
  /// In en, this message translates to:
  /// **'hour'**
  String get hour;

  /// No description provided for @second.
  ///
  /// In en, this message translates to:
  /// **'second'**
  String get second;

  /// No description provided for @hostIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Host is required'**
  String get hostIsRequired;

  /// No description provided for @invalidHostnameOrIp.
  ///
  /// In en, this message translates to:
  /// **'Invalid hostname or IP address'**
  String get invalidHostnameOrIp;

  /// No description provided for @portIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Port is required'**
  String get portIsRequired;

  /// No description provided for @portMustBeBetween.
  ///
  /// In en, this message translates to:
  /// **'Port must be between 1 and 65535'**
  String get portMustBeBetween;

  /// No description provided for @apiKeyIsRequired.
  ///
  /// In en, this message translates to:
  /// **'API Key is required'**
  String get apiKeyIsRequired;

  /// No description provided for @invalidApiKeyFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid API Key format'**
  String get invalidApiKeyFormat;

  /// No description provided for @apiSecretIsRequired.
  ///
  /// In en, this message translates to:
  /// **'API Secret is required'**
  String get apiSecretIsRequired;

  /// No description provided for @invalidApiSecretFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid API Secret format'**
  String get invalidApiSecretFormat;

  /// No description provided for @fieldIsRequired.
  ///
  /// In en, this message translates to:
  /// **'{fieldName} is required'**
  String fieldIsRequired(String fieldName);

  /// Service action title (e.g., 'Start Service', 'Stop Service')
  ///
  /// In en, this message translates to:
  /// **'{action} Service'**
  String actionService(String action);

  /// Confirmation message for service action
  ///
  /// In en, this message translates to:
  /// **'{action} \"{name}\"?'**
  String confirmServiceAction(String action, String name);

  /// Loading message while performing service action
  ///
  /// In en, this message translates to:
  /// **'{action} {name}...'**
  String actioningService(String action, String name);

  /// Not available abbreviation
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get notAvailable;

  /// No description provided for @unitBytes.
  ///
  /// In en, this message translates to:
  /// **'B'**
  String get unitBytes;

  /// No description provided for @unitKilobytes.
  ///
  /// In en, this message translates to:
  /// **'KB'**
  String get unitKilobytes;

  /// No description provided for @unitMegabytes.
  ///
  /// In en, this message translates to:
  /// **'MB'**
  String get unitMegabytes;

  /// No description provided for @unitGigabytes.
  ///
  /// In en, this message translates to:
  /// **'GB'**
  String get unitGigabytes;

  /// No description provided for @unitTerabytes.
  ///
  /// In en, this message translates to:
  /// **'TB'**
  String get unitTerabytes;

  /// No description provided for @unitPetabytes.
  ///
  /// In en, this message translates to:
  /// **'PB'**
  String get unitPetabytes;

  /// Per second suffix for data rates
  ///
  /// In en, this message translates to:
  /// **'/s'**
  String get unitPerSecond;

  /// No description provided for @hourAbbrev.
  ///
  /// In en, this message translates to:
  /// **'h'**
  String get hourAbbrev;

  /// No description provided for @minuteAbbrev.
  ///
  /// In en, this message translates to:
  /// **'m'**
  String get minuteAbbrev;

  /// No description provided for @secondAbbrev.
  ///
  /// In en, this message translates to:
  /// **'s'**
  String get secondAbbrev;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'de', 'en', 'es', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
