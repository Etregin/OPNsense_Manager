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

  /// Translation for about
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// Translation for aboutDescription
  ///
  /// In en, this message translates to:
  /// **'A professional Flutter mobile application for managing OPNsense firewall routers.'**
  String get aboutDescription;

  /// Translation for aboutImportExport
  ///
  /// In en, this message translates to:
  /// **'About Import & Export'**
  String get aboutImportExport;

  /// Translation for acceptDns
  ///
  /// In en, this message translates to:
  /// **'Accept DNS'**
  String get acceptDns;

  /// Translation for acceptDnsDescription
  ///
  /// In en, this message translates to:
  /// **'Use DNS servers provided by Tailscale'**
  String get acceptDnsDescription;

  /// Translation for acceptRoutes
  ///
  /// In en, this message translates to:
  /// **'Accept Routes'**
  String get acceptRoutes;

  /// Translation for acceptSubnetRoutes
  ///
  /// In en, this message translates to:
  /// **'Accept Subnet Routes'**
  String get acceptSubnetRoutes;

  /// Translation for acceptSubnetRoutesDescription
  ///
  /// In en, this message translates to:
  /// **'Accept routes advertised by other nodes'**
  String get acceptSubnetRoutesDescription;

  /// Translation for action
  ///
  /// In en, this message translates to:
  /// **'Action'**
  String get action;

  /// Service action title (e.g., 'Start Service', 'Stop Service')
  ///
  /// In en, this message translates to:
  /// **'{action} Service'**
  String actionService(String action);

  /// Loading message while performing service action
  ///
  /// In en, this message translates to:
  /// **'{action} {name}...'**
  String actioningService(String action, String name);

  /// Translation for activate
  ///
  /// In en, this message translates to:
  /// **'Activate'**
  String get activate;

  /// No description provided for @activatedProfile.
  ///
  /// In en, this message translates to:
  /// **'Activated profile: {name}'**
  String activatedProfile(String name);

  /// Translation for activatingProfile
  ///
  /// In en, this message translates to:
  /// **'Activating profile...'**
  String get activatingProfile;

  /// Translation for activationFailed
  ///
  /// In en, this message translates to:
  /// **'Activation failed'**
  String get activationFailed;

  /// Translation for active
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// Translation for activeDevices
  ///
  /// In en, this message translates to:
  /// **'Active Devices'**
  String get activeDevices;

  /// No description provided for @activeHosts.
  ///
  /// In en, this message translates to:
  /// **'{count} active host(s)'**
  String activeHosts(int count);

  /// Translation for activeProfile
  ///
  /// In en, this message translates to:
  /// **'Active Profile'**
  String get activeProfile;

  /// Translation for add
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// Translation for addButton
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get addButton;

  /// Translation for addClientOverride
  ///
  /// In en, this message translates to:
  /// **'Add Client Override'**
  String get addClientOverride;

  /// Translation for addConnection
  ///
  /// In en, this message translates to:
  /// **'Add Connection'**
  String get addConnection;

  /// Translation for addConnectionEndpoint
  ///
  /// In en, this message translates to:
  /// **'Please add at least one connection endpoint'**
  String get addConnectionEndpoint;

  /// Translation for addDnsServer
  ///
  /// In en, this message translates to:
  /// **'Add DNS Server'**
  String get addDnsServer;

  /// Translation for addHost
  ///
  /// In en, this message translates to:
  /// **'Add Host'**
  String get addHost;

  /// Translation for addHostToGetStarted
  ///
  /// In en, this message translates to:
  /// **'Add a host to get started'**
  String get addHostToGetStarted;

  /// Translation for addInstance
  ///
  /// In en, this message translates to:
  /// **'Add Instance'**
  String get addInstance;

  /// Translation for addOpenVpnInstance
  ///
  /// In en, this message translates to:
  /// **'Add OpenVPN Instance'**
  String get addOpenVpnInstance;

  /// Translation for addOverride
  ///
  /// In en, this message translates to:
  /// **'Add Override'**
  String get addOverride;

  /// Translation for addProfile
  ///
  /// In en, this message translates to:
  /// **'Add Profile'**
  String get addProfile;

  /// Translation for addProfileToManageInstances
  ///
  /// In en, this message translates to:
  /// **'Add a profile to manage OPNsense instances'**
  String get addProfileToManageInstances;

  /// Translation for addStaticKey
  ///
  /// In en, this message translates to:
  /// **'Add Static Key'**
  String get addStaticKey;

  /// Translation for addStaticKeyTooltip
  ///
  /// In en, this message translates to:
  /// **'Add Static Key'**
  String get addStaticKeyTooltip;

  /// Translation for addSubnet
  ///
  /// In en, this message translates to:
  /// **'Add Subnet'**
  String get addSubnet;

  /// Translation for addTunnelAddress
  ///
  /// In en, this message translates to:
  /// **'Add Tunnel Address'**
  String get addTunnelAddress;

  /// Translation for additionalInformation
  ///
  /// In en, this message translates to:
  /// **'Additional Information'**
  String get additionalInformation;

  /// Translation for address
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// Translation for addressIsRequired
  ///
  /// In en, this message translates to:
  /// **'Address is required'**
  String get addressIsRequired;

  /// Translation for advertiseExitNode
  ///
  /// In en, this message translates to:
  /// **'Advertise Exit Node'**
  String get advertiseExitNode;

  /// Translation for advertiseExitNodeDescription
  ///
  /// In en, this message translates to:
  /// **'Allow other devices to route through this node'**
  String get advertiseExitNodeDescription;

  /// Translation for advertiseRoutes
  ///
  /// In en, this message translates to:
  /// **'Advertise Routes'**
  String get advertiseRoutes;

  /// Translation for alert
  ///
  /// In en, this message translates to:
  /// **'Alert'**
  String get alert;

  /// Translation for aliasDeletedSuccessfully
  ///
  /// In en, this message translates to:
  /// **'Alias deleted successfully'**
  String get aliasDeletedSuccessfully;

  /// Translation for aliasDisabledSuccessfully
  ///
  /// In en, this message translates to:
  /// **'Alias disabled successfully'**
  String get aliasDisabledSuccessfully;

  /// Translation for aliasEnabledSuccessfully
  ///
  /// In en, this message translates to:
  /// **'Alias enabled successfully'**
  String get aliasEnabledSuccessfully;

  /// Translation for aliases
  ///
  /// In en, this message translates to:
  /// **'Aliases'**
  String get aliases;

  /// Translation for all
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// Translation for allConnectionsSuccessful
  ///
  /// In en, this message translates to:
  /// **'All connections tested successfully'**
  String get allConnectionsSuccessful;

  /// Translation for allDetailsCopiedToClipboard
  ///
  /// In en, this message translates to:
  /// **'All details copied to clipboard'**
  String get allDetailsCopiedToClipboard;

  /// Translation for allRoles
  ///
  /// In en, this message translates to:
  /// **'All Roles'**
  String get allRoles;

  /// Translation for allSettingsSavedSuccessfully
  ///
  /// In en, this message translates to:
  /// **'All settings saved successfully'**
  String get allSettingsSavedSuccessfully;

  /// Translation for allStatus
  ///
  /// In en, this message translates to:
  /// **'All Status'**
  String get allStatus;

  /// Translation for allTypes
  ///
  /// In en, this message translates to:
  /// **'All Types'**
  String get allTypes;

  /// Translation for allVPNs
  ///
  /// In en, this message translates to:
  /// **'All VPNs'**
  String get allVPNs;

  /// Translation for allowSelfSigned
  ///
  /// In en, this message translates to:
  /// **'Allow Self-Signed Certificate'**
  String get allowSelfSigned;

  /// Translation for allowSelfSignedCertificates
  ///
  /// In en, this message translates to:
  /// **'Allow Self-Signed Certificates'**
  String get allowSelfSignedCertificates;

  /// Translation for allowSelfSignedCertificatesDescription
  ///
  /// In en, this message translates to:
  /// **'Accept self-signed SSL certificates'**
  String get allowSelfSignedCertificatesDescription;

  /// Translation for allowedIps
  ///
  /// In en, this message translates to:
  /// **'Allowed IPs'**
  String get allowedIps;

  /// Translation for allowedIpsLabel
  ///
  /// In en, this message translates to:
  /// **'Allowed IPs'**
  String get allowedIpsLabel;

  /// Translation for any
  ///
  /// In en, this message translates to:
  /// **'Any'**
  String get any;

  /// Translation for anyIpAddressCidrOrAlias
  ///
  /// In en, this message translates to:
  /// **'any, IP address, CIDR, or alias'**
  String get anyIpAddressCidrOrAlias;

  /// Translation for anyPortNumberRangeOrAlias
  ///
  /// In en, this message translates to:
  /// **'any, port number, range, or alias'**
  String get anyPortNumberRangeOrAlias;

  /// No description provided for @apiError.
  ///
  /// In en, this message translates to:
  /// **'API Error: {message}'**
  String apiError(String message);

  /// Translation for apiKey
  ///
  /// In en, this message translates to:
  /// **'API Key'**
  String get apiKey;

  /// Translation for apiKeyIsRequired
  ///
  /// In en, this message translates to:
  /// **'API Key is required'**
  String get apiKeyIsRequired;

  /// Translation for apiKeyLabel
  ///
  /// In en, this message translates to:
  /// **'API Key'**
  String get apiKeyLabel;

  /// Translation for apiSecret
  ///
  /// In en, this message translates to:
  /// **'API Secret'**
  String get apiSecret;

  /// Translation for apiSecretIsRequired
  ///
  /// In en, this message translates to:
  /// **'API Secret is required'**
  String get apiSecretIsRequired;

  /// Translation for apiSecretLabel
  ///
  /// In en, this message translates to:
  /// **'API Secret'**
  String get apiSecretLabel;

  /// The application name
  ///
  /// In en, this message translates to:
  /// **'OPNsense Manager'**
  String get appName;

  /// Translation for appearance
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// Translation for applicationLegalese
  ///
  /// In en, this message translates to:
  /// **'© 2026 OPNsense Manager\n\nLicensed under GNU General Public License v3.0\n\nThis program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.'**
  String get applicationLegalese;

  /// Translation for apply
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// Translation for architecture
  ///
  /// In en, this message translates to:
  /// **'Architecture'**
  String get architecture;

  /// Translation for atLeastOneTunnelAddressRequired
  ///
  /// In en, this message translates to:
  /// **'At least one tunnel address is required'**
  String get atLeastOneTunnelAddressRequired;

  /// Translation for authSettingsSavedSuccessfully
  ///
  /// In en, this message translates to:
  /// **'Authentication settings saved successfully'**
  String get authSettingsSavedSuccessfully;

  /// Translation for authTlsAuthentication
  ///
  /// In en, this message translates to:
  /// **'Auth (TLS Authentication)'**
  String get authTlsAuthentication;

  /// Translation for authTokenGeneratedSuccessfully
  ///
  /// In en, this message translates to:
  /// **'Auth token generated successfully'**
  String get authTokenGeneratedSuccessfully;

  /// Translation for authenticate
  ///
  /// In en, this message translates to:
  /// **'Authenticate'**
  String get authenticate;

  /// Translation for authenticateToUnlock
  ///
  /// In en, this message translates to:
  /// **'Authenticate to unlock the app'**
  String get authenticateToUnlock;

  /// Translation for authentication
  ///
  /// In en, this message translates to:
  /// **'Authentication'**
  String get authentication;

  /// Translation for authenticationFailed
  ///
  /// In en, this message translates to:
  /// **'Authentication failed'**
  String get authenticationFailed;

  /// Translation for authenticationRequired
  ///
  /// In en, this message translates to:
  /// **'Authentication Required'**
  String get authenticationRequired;

  /// Translation for authenticationSettings
  ///
  /// In en, this message translates to:
  /// **'Authentication Settings'**
  String get authenticationSettings;

  /// Translation for authorizedPeers
  ///
  /// In en, this message translates to:
  /// **'Authorized Peers'**
  String get authorizedPeers;

  /// Translation for autoRefresh
  ///
  /// In en, this message translates to:
  /// **'Auto Refresh'**
  String get autoRefresh;

  /// Translation for backendState
  ///
  /// In en, this message translates to:
  /// **'Backend State'**
  String get backendState;

  /// Translation for bandwidthLimit
  ///
  /// In en, this message translates to:
  /// **'Bandwidth Limit'**
  String get bandwidthLimit;

  /// Translation for bandwidthLimitMbps
  ///
  /// In en, this message translates to:
  /// **'Bandwidth Limit (Mbps)'**
  String get bandwidthLimitMbps;

  /// Translation for base64EncodedPrivateKeyKeepSecret
  ///
  /// In en, this message translates to:
  /// **'Base64-encoded private key (keep secret!)'**
  String get base64EncodedPrivateKeyKeepSecret;

  /// Translation for base64EncodedPublicKey
  ///
  /// In en, this message translates to:
  /// **'Base64-encoded public key'**
  String get base64EncodedPublicKey;

  /// Translation for biometricAuth
  ///
  /// In en, this message translates to:
  /// **'Biometric Authentication'**
  String get biometricAuth;

  /// Translation for biometricAuthFailed
  ///
  /// In en, this message translates to:
  /// **'Biometric authentication failed or was cancelled'**
  String get biometricAuthFailed;

  /// Translation for biometricLockDisabled
  ///
  /// In en, this message translates to:
  /// **'Biometric lock disabled'**
  String get biometricLockDisabled;

  /// Translation for biometricLockEnabled
  ///
  /// In en, this message translates to:
  /// **'Biometric lock enabled'**
  String get biometricLockEnabled;

  /// No description provided for @biometricLockTitle.
  ///
  /// In en, this message translates to:
  /// **'{biometricType} Lock'**
  String biometricLockTitle(String biometricType);

  /// Translation for biometricNotAvailable
  ///
  /// In en, this message translates to:
  /// **'Biometric authentication is not available on this device'**
  String get biometricNotAvailable;

  /// Translation for block
  ///
  /// In en, this message translates to:
  /// **'Block'**
  String get block;

  /// Translation for blockHost
  ///
  /// In en, this message translates to:
  /// **'Block Host'**
  String get blockHost;

  /// No description provided for @blockHostConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to block {hostname} ({ip})?\n\nThis will create a firewall rule to block all traffic from this host.'**
  String blockHostConfirmation(String hostname, String ip);

  /// Translation for blockingHost
  ///
  /// In en, this message translates to:
  /// **'Blocking host...'**
  String get blockingHost;

  /// Translation for bytesReceived
  ///
  /// In en, this message translates to:
  /// **'Bytes Received'**
  String get bytesReceived;

  /// Translation for bytesSent
  ///
  /// In en, this message translates to:
  /// **'Bytes Sent'**
  String get bytesSent;

  /// Translation for cancel
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Translation for cancelButton
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButton;

  /// Translation for cannotBeUndone
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get cannotBeUndone;

  /// Translation for cannotDeleteLastConnection
  ///
  /// In en, this message translates to:
  /// **'Cannot delete the last connection endpoint'**
  String get cannotDeleteLastConnection;

  /// Translation for cannotDeleteLastConnectionTooltip
  ///
  /// In en, this message translates to:
  /// **'Cannot delete the last connection endpoint'**
  String get cannotDeleteLastConnectionTooltip;

  /// Translation for carpVhidToDepend
  ///
  /// In en, this message translates to:
  /// **'CARP VHID to depend on'**
  String get carpVhidToDepend;

  /// Translation for categories
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// Translation for changePIN
  ///
  /// In en, this message translates to:
  /// **'Change PIN'**
  String get changePIN;

  /// Translation for changePinTitle
  ///
  /// In en, this message translates to:
  /// **'Change PIN'**
  String get changePinTitle;

  /// Translation for changesDiscarded
  ///
  /// In en, this message translates to:
  /// **'Changes discarded'**
  String get changesDiscarded;

  /// Translation for checkIfWireguardIsConfiguredAndRunning
  ///
  /// In en, this message translates to:
  /// **'Check if WireGuard is configured and running'**
  String get checkIfWireguardIsConfiguredAndRunning;

  /// Translation for chooseExportLocation
  ///
  /// In en, this message translates to:
  /// **'Choose Export Location'**
  String get chooseExportLocation;

  /// Translation for cidrNotationRequired
  ///
  /// In en, this message translates to:
  /// **'CIDR notation is required'**
  String get cidrNotationRequired;

  /// Translation for clearLogs
  ///
  /// In en, this message translates to:
  /// **'Clear Logs'**
  String get clearLogs;

  /// Translation for clearSelection
  ///
  /// In en, this message translates to:
  /// **'Clear selection'**
  String get clearSelection;

  /// Translation for client
  ///
  /// In en, this message translates to:
  /// **'Client'**
  String get client;

  /// Translation for clientAddress
  ///
  /// In en, this message translates to:
  /// **'Client Address'**
  String get clientAddress;

  /// Translation for clientName
  ///
  /// In en, this message translates to:
  /// **'Client name'**
  String get clientName;

  /// Translation for clientOverrides
  ///
  /// In en, this message translates to:
  /// **'Client Overrides'**
  String get clientOverrides;

  /// Translation for clientSettings
  ///
  /// In en, this message translates to:
  /// **'Client Settings'**
  String get clientSettings;

  /// Translation for clientSpecificOverrides
  ///
  /// In en, this message translates to:
  /// **'Client Specific Overrides'**
  String get clientSpecificOverrides;

  /// Translation for clientX509CommonNameHelper
  ///
  /// In en, this message translates to:
  /// **'Enter the client\'s X.509 common name here.'**
  String get clientX509CommonNameHelper;

  /// Translation for close
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Translation for commonName
  ///
  /// In en, this message translates to:
  /// **'Common name'**
  String get commonName;

  /// Translation for commonNameRequired
  ///
  /// In en, this message translates to:
  /// **'Common name is required'**
  String get commonNameRequired;

  /// No description provided for @commonNameWithValue.
  ///
  /// In en, this message translates to:
  /// **'Common Name: {value}'**
  String commonNameWithValue(String value);

  /// Translation for configurationAppliedSuccessfully
  ///
  /// In en, this message translates to:
  /// **'Configuration applied successfully'**
  String get configurationAppliedSuccessfully;

  /// Translation for configurationPreview
  ///
  /// In en, this message translates to:
  /// **'Configuration Preview'**
  String get configurationPreview;

  /// Translation for configureAdvertisedSubnets
  ///
  /// In en, this message translates to:
  /// **'Configure advertised subnets'**
  String get configureAdvertisedSubnets;

  /// Translation for configured
  ///
  /// In en, this message translates to:
  /// **'Configured'**
  String get configured;

  /// Translation for confirmDelete
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get confirmDelete;

  /// No description provided for @confirmDeleteInstance.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete instance \"{name}\"? This action cannot be undone.'**
  String confirmDeleteInstance(String name);

  /// Translation for confirmDeleteOverride
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete override for \"{name}\"? This action cannot be undone.'**
  String confirmDeleteOverride(String name);

  /// No description provided for @confirmDeleteStaticKey.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete static key \"{name}\"? This action cannot be undone.'**
  String confirmDeleteStaticKey(String name);

  /// Translation for confirmNewPin
  ///
  /// In en, this message translates to:
  /// **'Confirm New PIN'**
  String get confirmNewPin;

  /// Translation for confirmPIN
  ///
  /// In en, this message translates to:
  /// **'Confirm PIN'**
  String get confirmPIN;

  /// Translation for confirmPin
  ///
  /// In en, this message translates to:
  /// **'Confirm PIN'**
  String get confirmPin;

  /// Confirmation message for service action
  ///
  /// In en, this message translates to:
  /// **'{action} \"{name}\"?'**
  String confirmServiceAction(String action, String name);

  /// Translation for connect
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get connect;

  /// Translation for connectToYourOPNsenseFirewall
  ///
  /// In en, this message translates to:
  /// **'Connect to your OPNsense firewall'**
  String get connectToYourOPNsenseFirewall;

  /// Translation for connectVPN
  ///
  /// In en, this message translates to:
  /// **'Connect VPN'**
  String get connectVPN;

  /// Translation for connected
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get connected;

  /// Translation for connectedSince
  ///
  /// In en, this message translates to:
  /// **'Connected Since'**
  String get connectedSince;

  /// Message shown when connection is successful
  ///
  /// In en, this message translates to:
  /// **'Connected successfully via: {endpoint}'**
  String connectedSuccessfullyVia(String endpoint);

  /// No description provided for @connectingVPN.
  ///
  /// In en, this message translates to:
  /// **'Connecting {name}...'**
  String connectingVPN(String name);

  /// Translation for connectionBlocking
  ///
  /// In en, this message translates to:
  /// **'Connection blocking'**
  String get connectionBlocking;

  /// Translation for connectionBlockingSubtitle
  ///
  /// In en, this message translates to:
  /// **'Block this client connection based on its common name. Don\'t use this option to permanently disable a client due to a compromised key or password. Use a CRL (certificate revocation list) instead.'**
  String get connectionBlockingSubtitle;

  /// Translation for connectionDetails
  ///
  /// In en, this message translates to:
  /// **'Connection Details'**
  String get connectionDetails;

  /// Translation for connectionEndpoints
  ///
  /// In en, this message translates to:
  /// **'Connection Endpoints'**
  String get connectionEndpoints;

  /// Translation for connectionEndpointsHelp
  ///
  /// In en, this message translates to:
  /// **'Manage multiple connection endpoints for this profile. The app will try each endpoint in order until a successful connection is established.'**
  String get connectionEndpointsHelp;

  /// Translation for connectionFailed
  ///
  /// In en, this message translates to:
  /// **'Connection failed. Check console logs for details.\n\nCommon issues:\n• Device not on same network as OPNsense\n• Wrong IP address or port\n• Firewall blocking connection\n• Invalid API credentials'**
  String get connectionFailed;

  /// No description provided for @connectionFailedError.
  ///
  /// In en, this message translates to:
  /// **'Connection failed: {error}'**
  String connectionFailedError(String error);

  /// Translation for connectionInformation
  ///
  /// In en, this message translates to:
  /// **'Connection Information'**
  String get connectionInformation;

  /// Translation for connectionStatus
  ///
  /// In en, this message translates to:
  /// **'Connection Status'**
  String get connectionStatus;

  /// Translation for connectionSuccessful
  ///
  /// In en, this message translates to:
  /// **'Connection Successful'**
  String get connectionSuccessful;

  /// Translation for connectionTestFailed
  ///
  /// In en, this message translates to:
  /// **'Connection test failed'**
  String get connectionTestFailed;

  /// Translation for connectionTestResults
  ///
  /// In en, this message translates to:
  /// **'Connection Test Results'**
  String get connectionTestResults;

  /// Translation for content
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get content;

  /// No description provided for @copiedLogEntries.
  ///
  /// In en, this message translates to:
  /// **'Copied {count} log {count, plural, =1{entry} other{entries}}'**
  String copiedLogEntries(int count);

  /// Translation for copiedToClipboard
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copiedToClipboard;

  /// Translation for copy
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// Translation for copyAllDetails
  ///
  /// In en, this message translates to:
  /// **'Copy All Details'**
  String get copyAllDetails;

  /// Translation for copyHost
  ///
  /// In en, this message translates to:
  /// **'Copy Host'**
  String get copyHost;

  /// Translation for copyKey
  ///
  /// In en, this message translates to:
  /// **'Copy key'**
  String get copyKey;

  /// Translation for copyKeyTooltip
  ///
  /// In en, this message translates to:
  /// **'Copy key'**
  String get copyKeyTooltip;

  /// Translation for copySelected
  ///
  /// In en, this message translates to:
  /// **'Copy selected'**
  String get copySelected;

  /// Translation for copyTooltip
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copyTooltip;

  /// Translation for cpuUsage
  ///
  /// In en, this message translates to:
  /// **'CPU Usage'**
  String get cpuUsage;

  /// Translation for createAliasComingSoon
  ///
  /// In en, this message translates to:
  /// **'Create Alias (Coming Soon)'**
  String get createAliasComingSoon;

  /// Translation for createFirstAutomationRule
  ///
  /// In en, this message translates to:
  /// **'Create your first automation rule to get started'**
  String get createFirstAutomationRule;

  /// Translation for createFirstProfile
  ///
  /// In en, this message translates to:
  /// **'Create your first profile to get started'**
  String get createFirstProfile;

  /// Translation for createNewProfile
  ///
  /// In en, this message translates to:
  /// **'Create New Profile'**
  String get createNewProfile;

  /// Translation for createOverride
  ///
  /// In en, this message translates to:
  /// **'Create Override'**
  String get createOverride;

  /// Translation for createPeer
  ///
  /// In en, this message translates to:
  /// **'Create Peer'**
  String get createPeer;

  /// Translation for createRule
  ///
  /// In en, this message translates to:
  /// **'Create Rule'**
  String get createRule;

  /// Translation for createServer
  ///
  /// In en, this message translates to:
  /// **'Create Server'**
  String get createServer;

  /// Translation for createStaticKey
  ///
  /// In en, this message translates to:
  /// **'Create Static Key'**
  String get createStaticKey;

  /// Translation for createYourFirstProfile
  ///
  /// In en, this message translates to:
  /// **'Create your first OPNsense profile to get started'**
  String get createYourFirstProfile;

  /// Translation for created
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get created;

  /// Translation for critical
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get critical;

  /// Translation for cryptTlsEncryption
  ///
  /// In en, this message translates to:
  /// **'Crypt (TLS Encryption)'**
  String get cryptTlsEncryption;

  /// Translation for cryptV2TlsEncryption
  ///
  /// In en, this message translates to:
  /// **'Crypt V2 (TLS Encryption)'**
  String get cryptV2TlsEncryption;

  /// Translation for currentPin
  ///
  /// In en, this message translates to:
  /// **'Current PIN'**
  String get currentPin;

  /// Translation for currentPinIncorrect
  ///
  /// In en, this message translates to:
  /// **'Current PIN is incorrect'**
  String get currentPinIncorrect;

  /// Translation for darkMode
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// Translation for dashboard
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// Translation for day
  ///
  /// In en, this message translates to:
  /// **'day'**
  String get day;

  /// Translation for days
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get days;

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{days}d ago'**
  String daysAgo(int days);

  /// Translation for debug
  ///
  /// In en, this message translates to:
  /// **'Debug'**
  String get debug;

  /// Translation for debugDescription
  ///
  /// In en, this message translates to:
  /// **'Enable debug logging'**
  String get debugDescription;

  /// Translation for defineRoleOfInstance
  ///
  /// In en, this message translates to:
  /// **'Define the role of this instance'**
  String get defineRoleOfInstance;

  /// Translation for delete
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Confirmation message when deleting an alias
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the alias \"{aliasName}\"?'**
  String deleteAliasConfirmation(String aliasName);

  /// Translation for deleteConfirmation
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this item?'**
  String get deleteConfirmation;

  /// Translation for deleteConnection
  ///
  /// In en, this message translates to:
  /// **'Delete Connection'**
  String get deleteConnection;

  /// Confirmation message when deleting a connection endpoint
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the connection \"{connectionName}\"?'**
  String deleteConnectionConfirmation(String connectionName);

  /// Translation for deleteHost
  ///
  /// In en, this message translates to:
  /// **'Delete Host'**
  String get deleteHost;

  /// Confirmation message when deleting a WOL host
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{host}\"?'**
  String deleteHostConfirmation(String host);

  /// Translation for deleteInstance
  ///
  /// In en, this message translates to:
  /// **'Delete Instance'**
  String get deleteInstance;

  /// Translation for deleteOverride
  ///
  /// In en, this message translates to:
  /// **'Delete Override'**
  String get deleteOverride;

  /// Translation for deletePeer
  ///
  /// In en, this message translates to:
  /// **'Delete Peer'**
  String get deletePeer;

  /// No description provided for @deletePeerConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete peer \"{name}\"?'**
  String deletePeerConfirmation(String name);

  /// Translation for deleteProfile
  ///
  /// In en, this message translates to:
  /// **'Delete Profile'**
  String get deleteProfile;

  /// No description provided for @deleteProfileConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"?'**
  String deleteProfileConfirmation(String name);

  /// Translation for deleteProfileTitle
  ///
  /// In en, this message translates to:
  /// **'Delete Profile'**
  String get deleteProfileTitle;

  /// Translation for deleteRule
  ///
  /// In en, this message translates to:
  /// **'Delete Rule'**
  String get deleteRule;

  /// No description provided for @deleteRuleConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the rule \"{description}\"?'**
  String deleteRuleConfirmation(String description);

  /// No description provided for @disableRuleConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to disable the rule \"{description}\"?'**
  String disableRuleConfirmation(String description);

  /// No description provided for @enableRuleConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to enable the rule \"{description}\"?'**
  String enableRuleConfirmation(String description);

  /// No description provided for @deleteServerConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete server \"{name}\"? This action cannot be undone.'**
  String deleteServerConfirmation(String name);

  /// Translation for deleteStaticKey
  ///
  /// In en, this message translates to:
  /// **'Delete Static Key'**
  String get deleteStaticKey;

  /// Translation for deleteSubnet
  ///
  /// In en, this message translates to:
  /// **'Delete Subnet'**
  String get deleteSubnet;

  /// No description provided for @deleteSubnetConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete subnet {subnet}?'**
  String deleteSubnetConfirmation(String subnet);

  /// Translation for demo
  ///
  /// In en, this message translates to:
  /// **'Demo'**
  String get demo;

  /// Translation for dependOnCarp
  ///
  /// In en, this message translates to:
  /// **'Depend on (CARP)'**
  String get dependOnCarp;

  /// Translation for description
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// Translation for descriptionHelperText
  ///
  /// In en, this message translates to:
  /// **'A brief description of this instance'**
  String get descriptionHelperText;

  /// Translation for descriptionHelperTextOverride
  ///
  /// In en, this message translates to:
  /// **'You may enter a description here for your reference (not parsed).'**
  String get descriptionHelperTextOverride;

  /// Translation for descriptionHint
  ///
  /// In en, this message translates to:
  /// **'e.g., Living Room PC'**
  String get descriptionHint;

  /// Translation for descriptionOptional
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get descriptionOptional;

  /// Translation for descriptionRequired
  ///
  /// In en, this message translates to:
  /// **'Description is required'**
  String get descriptionRequired;

  /// Translation for descriptiveNameForStaticKey
  ///
  /// In en, this message translates to:
  /// **'A descriptive name for this static key'**
  String get descriptiveNameForStaticKey;

  /// Translation for destination
  ///
  /// In en, this message translates to:
  /// **'Destination'**
  String get destination;

  /// Translation for destinationAddress
  ///
  /// In en, this message translates to:
  /// **'Destination Address'**
  String get destinationAddress;

  /// Translation for destinationIsRequired
  ///
  /// In en, this message translates to:
  /// **'Destination is required'**
  String get destinationIsRequired;

  /// Translation for destinationPort
  ///
  /// In en, this message translates to:
  /// **'Destination Port'**
  String get destinationPort;

  /// Translation for destinationPortOptional
  ///
  /// In en, this message translates to:
  /// **'Destination Port (Optional)'**
  String get destinationPortOptional;

  /// Translation for deviceType
  ///
  /// In en, this message translates to:
  /// **'Device Type'**
  String get deviceType;

  /// Translation for dhcpLeases
  ///
  /// In en, this message translates to:
  /// **'DHCP Leases'**
  String get dhcpLeases;

  /// Label for DHCP server type
  ///
  /// In en, this message translates to:
  /// **'{serverName} Server'**
  String dhcpServerLabel(String serverName);

  /// Translation for dhcpServerType
  ///
  /// In en, this message translates to:
  /// **'DHCP Server Type'**
  String get dhcpServerType;

  /// Translation for direction
  ///
  /// In en, this message translates to:
  /// **'Direction'**
  String get direction;

  /// Translation for disable
  ///
  /// In en, this message translates to:
  /// **'Disable'**
  String get disable;

  /// Translation for disableAutoScroll
  ///
  /// In en, this message translates to:
  /// **'Disable Auto-scroll'**
  String get disableAutoScroll;

  /// Translation for disableRoutes
  ///
  /// In en, this message translates to:
  /// **'Disable Routes'**
  String get disableRoutes;

  /// Translation for disableRoutesDescription
  ///
  /// In en, this message translates to:
  /// **'Prevent automatic route installation'**
  String get disableRoutesDescription;

  /// Translation for disableRule
  ///
  /// In en, this message translates to:
  /// **'Disable Rule'**
  String get disableRule;

  /// Translation for disableSnat
  ///
  /// In en, this message translates to:
  /// **'Disable SNAT'**
  String get disableSnat;

  /// Translation for disableSnatDescription
  ///
  /// In en, this message translates to:
  /// **'Disable source NAT for subnet routes'**
  String get disableSnatDescription;

  /// Translation for disabled
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get disabled;

  /// Translation for disabledStatus
  ///
  /// In en, this message translates to:
  /// **'disabled'**
  String get disabledStatus;

  /// Translation for disablingRule
  ///
  /// In en, this message translates to:
  /// **'Disabling rule...'**
  String get disablingRule;

  /// Translation for discard
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get discard;

  /// Translation for disconnect
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get disconnect;

  /// Translation for disconnectVPN
  ///
  /// In en, this message translates to:
  /// **'Disconnect VPN'**
  String get disconnectVPN;

  /// Translation for disconnected
  ///
  /// In en, this message translates to:
  /// **'Disconnected'**
  String get disconnected;

  /// No description provided for @disconnectingVPN.
  ///
  /// In en, this message translates to:
  /// **'Disconnecting {name}...'**
  String disconnectingVPN(String name);

  /// Translation for diskUsage
  ///
  /// In en, this message translates to:
  /// **'Disk Usage'**
  String get diskUsage;

  /// Translation for dnsDomainList
  ///
  /// In en, this message translates to:
  /// **'DNS Domain List'**
  String get dnsDomainList;

  /// Translation for dnsDomainListHelperText
  ///
  /// In en, this message translates to:
  /// **'Set Connection-specific DNS Suffixes.'**
  String get dnsDomainListHelperText;

  /// Translation for dnsDomainSearchList
  ///
  /// In en, this message translates to:
  /// **'DNS Domain Search List'**
  String get dnsDomainSearchList;

  /// Translation for dnsDomainSearchListHelperText
  ///
  /// In en, this message translates to:
  /// **'Add name to the domain search list. Repeat this option to add more entries. Up to 10 domains are supported.'**
  String get dnsDomainSearchListHelperText;

  /// Translation for dnsEnabled
  ///
  /// In en, this message translates to:
  /// **'DNS Enabled'**
  String get dnsEnabled;

  /// Translation for dnsServerIp
  ///
  /// In en, this message translates to:
  /// **'DNS Server IP'**
  String get dnsServerIp;

  /// Translation for dnsServerIsRequired
  ///
  /// In en, this message translates to:
  /// **'DNS server is required'**
  String get dnsServerIsRequired;

  /// Translation for dnsServerOptional
  ///
  /// In en, this message translates to:
  /// **'DNS Server (Optional)'**
  String get dnsServerOptional;

  /// Translation for dnsServers
  ///
  /// In en, this message translates to:
  /// **'DNS Servers'**
  String get dnsServers;

  /// Translation for dnsServersHelperText
  ///
  /// In en, this message translates to:
  /// **'Set primary domain name server IPv4 or IPv6 address. Repeat this option to set secondary DNS server addresses.'**
  String get dnsServersHelperText;

  /// Translation for dnsServersOptional
  ///
  /// In en, this message translates to:
  /// **'DNS Servers (Optional)'**
  String get dnsServersOptional;

  /// Translation for dnsmasqDescription
  ///
  /// In en, this message translates to:
  /// **'Lightweight DNS and DHCP server'**
  String get dnsmasqDescription;

  /// Translation for dnsmasqServerName
  ///
  /// In en, this message translates to:
  /// **'Dnsmasq'**
  String get dnsmasqServerName;

  /// Translation for done
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// Translation for doneButton
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get doneButton;

  /// Translation for download
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// Translation for dynamicLease
  ///
  /// In en, this message translates to:
  /// **'Dynamic'**
  String get dynamicLease;

  /// Translation for edit
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Translation for editClientOverride
  ///
  /// In en, this message translates to:
  /// **'Edit Client Override'**
  String get editClientOverride;

  /// Translation for editConnection
  ///
  /// In en, this message translates to:
  /// **'Edit Connection'**
  String get editConnection;

  /// Translation for editHost
  ///
  /// In en, this message translates to:
  /// **'Edit Host'**
  String get editHost;

  /// Translation for editProfile
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// Translation for editRule
  ///
  /// In en, this message translates to:
  /// **'Edit Rule'**
  String get editRule;

  /// Translation for editStaticKey
  ///
  /// In en, this message translates to:
  /// **'Edit Static Key'**
  String get editStaticKey;

  /// Translation for editSubnet
  ///
  /// In en, this message translates to:
  /// **'Edit Subnet'**
  String get editSubnet;

  /// Translation for editWireguardPeer
  ///
  /// In en, this message translates to:
  /// **'Edit WireGuard Peer'**
  String get editWireguardPeer;

  /// Translation for editWireguardServer
  ///
  /// In en, this message translates to:
  /// **'Edit WireGuard Server'**
  String get editWireguardServer;

  /// Translation for emergency
  ///
  /// In en, this message translates to:
  /// **'Emergency'**
  String get emergency;

  /// Translation for enable
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get enable;

  /// Translation for enableAutoScroll
  ///
  /// In en, this message translates to:
  /// **'Enable Auto-scroll'**
  String get enableAutoScroll;

  /// Translation for enableClientSpecificOverride
  ///
  /// In en, this message translates to:
  /// **'Enable this client specific override'**
  String get enableClientSpecificOverride;

  /// Translation for enableDebugLogging
  ///
  /// In en, this message translates to:
  /// **'Enable debug logging'**
  String get enableDebugLogging;

  /// Translation for enablePinLockFirst
  ///
  /// In en, this message translates to:
  /// **'Please enable PIN lock first before using biometric'**
  String get enablePinLockFirst;

  /// Translation for enablePinLockFirstBiometric
  ///
  /// In en, this message translates to:
  /// **'Enable PIN lock first to use biometric'**
  String get enablePinLockFirstBiometric;

  /// Translation for enableRule
  ///
  /// In en, this message translates to:
  /// **'Enable Rule'**
  String get enableRule;

  /// Translation for enableSsh
  ///
  /// In en, this message translates to:
  /// **'Enable SSH'**
  String get enableSsh;

  /// Translation for enableSshDescription
  ///
  /// In en, this message translates to:
  /// **'Allow SSH access through Tailscale'**
  String get enableSshDescription;

  /// Translation for enableTailscale
  ///
  /// In en, this message translates to:
  /// **'Enable Tailscale'**
  String get enableTailscale;

  /// Translation for enableTailscaleDescription
  ///
  /// In en, this message translates to:
  /// **'Enable or disable the Tailscale service'**
  String get enableTailscaleDescription;

  /// Translation for enableWireguard
  ///
  /// In en, this message translates to:
  /// **'Enable WireGuard'**
  String get enableWireguard;

  /// Translation for enabled
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get enabled;

  /// Translation for enabledLabel
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get enabledLabel;

  /// Translation for enabledStatus
  ///
  /// In en, this message translates to:
  /// **'enabled'**
  String get enabledStatus;

  /// Translation for enablingRule
  ///
  /// In en, this message translates to:
  /// **'Enabling rule...'**
  String get enablingRule;

  /// Translation for endTime
  ///
  /// In en, this message translates to:
  /// **'End Time'**
  String get endTime;

  /// Translation for endpoint
  ///
  /// In en, this message translates to:
  /// **'Endpoint'**
  String get endpoint;

  /// Translation for endpointAddress
  ///
  /// In en, this message translates to:
  /// **'Endpoint Address'**
  String get endpointAddress;

  /// Translation for endpointPort
  ///
  /// In en, this message translates to:
  /// **'Endpoint Port'**
  String get endpointPort;

  /// Translation for enterBandwidthLimit
  ///
  /// In en, this message translates to:
  /// **'Enter your connection bandwidth limit in Mbps'**
  String get enterBandwidthLimit;

  /// Translation for enterClientCertificateCommonName
  ///
  /// In en, this message translates to:
  /// **'Enter client certificate common name'**
  String get enterClientCertificateCommonName;

  /// Translation for enterDescriptionForOverride
  ///
  /// In en, this message translates to:
  /// **'Enter a description for this override'**
  String get enterDescriptionForOverride;

  /// Translation for enterOrGeneratePresharedKey
  ///
  /// In en, this message translates to:
  /// **'Enter or generate pre-shared key'**
  String get enterOrGeneratePresharedKey;

  /// Translation for enterOrGeneratePrivateKey
  ///
  /// In en, this message translates to:
  /// **'Enter or generate private key'**
  String get enterOrGeneratePrivateKey;

  /// Translation for enterOrGeneratePublicKey
  ///
  /// In en, this message translates to:
  /// **'Enter or generate public key'**
  String get enterOrGeneratePublicKey;

  /// Translation for enterPIN
  ///
  /// In en, this message translates to:
  /// **'Enter PIN'**
  String get enterPIN;

  /// Translation for enterPin
  ///
  /// In en, this message translates to:
  /// **'Enter PIN'**
  String get enterPin;

  /// Translation for enterPinLabel
  ///
  /// In en, this message translates to:
  /// **'Enter PIN (4-6 digits)'**
  String get enterPinLabel;

  /// Translation for enterRuleDescription
  ///
  /// In en, this message translates to:
  /// **'Enter rule description'**
  String get enterRuleDescription;

  /// Translation for enterYourApiKey
  ///
  /// In en, this message translates to:
  /// **'Enter your API key'**
  String get enterYourApiKey;

  /// Translation for enterYourApiSecret
  ///
  /// In en, this message translates to:
  /// **'Enter your API secret'**
  String get enterYourApiSecret;

  /// Translation for entries
  ///
  /// In en, this message translates to:
  /// **'entries'**
  String get entries;

  /// No description provided for @entriesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} entries'**
  String entriesCount(int count);

  /// Translation for error
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @errorAddingSubnet.
  ///
  /// In en, this message translates to:
  /// **'Error adding subnet: {error}'**
  String errorAddingSubnet(String error);

  /// No description provided for @errorDeletingRule.
  ///
  /// In en, this message translates to:
  /// **'Error deleting rule: {error}'**
  String errorDeletingRule(String error);

  /// No description provided for @errorDeletingSubnet.
  ///
  /// In en, this message translates to:
  /// **'Error deleting subnet: {error}'**
  String errorDeletingSubnet(String error);

  /// Translation for errorLoadingData
  ///
  /// In en, this message translates to:
  /// **'Error loading data'**
  String get errorLoadingData;

  /// Translation for errorLoadingInstance
  ///
  /// In en, this message translates to:
  /// **'Error loading instance'**
  String get errorLoadingInstance;

  /// Translation for errorLoadingLogs
  ///
  /// In en, this message translates to:
  /// **'Error loading logs'**
  String get errorLoadingLogs;

  /// Translation for errorLoadingOverride
  ///
  /// In en, this message translates to:
  /// **'Error loading override'**
  String get errorLoadingOverride;

  /// Translation for errorLoadingRoutes
  ///
  /// In en, this message translates to:
  /// **'Error loading routes'**
  String get errorLoadingRoutes;

  /// Translation for errorLoadingRules
  ///
  /// In en, this message translates to:
  /// **'Error loading rules'**
  String get errorLoadingRules;

  /// Translation for errorLoadingSessions
  ///
  /// In en, this message translates to:
  /// **'Error loading sessions'**
  String get errorLoadingSessions;

  /// Translation for errorLoadingSystemInfo
  ///
  /// In en, this message translates to:
  /// **'Error loading system information'**
  String get errorLoadingSystemInfo;

  /// Translation for errorLoadingVPNConnections
  ///
  /// In en, this message translates to:
  /// **'Error loading VPN connections'**
  String get errorLoadingVPNConnections;

  /// No description provided for @errorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String errorPrefix(String message);

  /// No description provided for @errorRestartingService.
  ///
  /// In en, this message translates to:
  /// **'Error restarting service: {error}'**
  String errorRestartingService(String error);

  /// No description provided for @errorSavingRule.
  ///
  /// In en, this message translates to:
  /// **'Error saving rule: {error}'**
  String errorSavingRule(String error);

  /// Error message when starting service fails
  ///
  /// In en, this message translates to:
  /// **'Error starting service: {error}'**
  String errorStartingService(String error);

  /// Error message when stopping service fails
  ///
  /// In en, this message translates to:
  /// **'Error stopping service: {error}'**
  String errorStoppingService(String error);

  /// No description provided for @errorTogglingRule.
  ///
  /// In en, this message translates to:
  /// **'Error toggling rule: {error}'**
  String errorTogglingRule(String error);

  /// No description provided for @errorUpdatingSubnet.
  ///
  /// In en, this message translates to:
  /// **'Error updating subnet: {error}'**
  String errorUpdatingSubnet(String error);

  /// Translation for exampleCidr
  ///
  /// In en, this message translates to:
  /// **'Example: 10.10.10.2/24 or fd00::2/64'**
  String get exampleCidr;

  /// Translation for exampleTunnelAddress
  ///
  /// In en, this message translates to:
  /// **'Example: 10.10.10.1/24 or fd00::1/64'**
  String get exampleTunnelAddress;

  /// Translation for examplesAnyIpCidr
  ///
  /// In en, this message translates to:
  /// **'Examples: any, 192.168.1.0/24, 10.0.0.1'**
  String get examplesAnyIpCidr;

  /// Translation for examplesAnyPortRange
  ///
  /// In en, this message translates to:
  /// **'Examples: any, 80, 1024-65535'**
  String get examplesAnyPortRange;

  /// Translation for examplesAnyPortRangeHttp
  ///
  /// In en, this message translates to:
  /// **'Examples: any, 80, 80-443, http'**
  String get examplesAnyPortRangeHttp;

  /// Translation for exitNode
  ///
  /// In en, this message translates to:
  /// **'Exit Node'**
  String get exitNode;

  /// Translation for expired
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get expired;

  /// Translation for expires
  ///
  /// In en, this message translates to:
  /// **'Expires'**
  String get expires;

  /// Translation for expiryTime
  ///
  /// In en, this message translates to:
  /// **'Expiry Time'**
  String get expiryTime;

  /// Translation for export
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get export;

  /// Translation for exportAllProfiles
  ///
  /// In en, this message translates to:
  /// **'Export All Profiles'**
  String get exportAllProfiles;

  /// Translation for exportAllProfilesSubtitle
  ///
  /// In en, this message translates to:
  /// **'Export all profiles to a JSON file'**
  String get exportAllProfilesSubtitle;

  /// Translation for exportCredentialsWarning
  ///
  /// In en, this message translates to:
  /// **'Exporting with credentials will save API keys and secrets in plain text. Only do this if you will store the file securely.'**
  String get exportCredentialsWarning;

  /// Translation for exportFailed
  ///
  /// In en, this message translates to:
  /// **'Export failed'**
  String get exportFailed;

  /// No description provided for @exportFailedError.
  ///
  /// In en, this message translates to:
  /// **'Export failed: {error}'**
  String exportFailedError(String error);

  /// Translation for exportLogs
  ///
  /// In en, this message translates to:
  /// **'Export Logs'**
  String get exportLogs;

  /// Translation for exportProfiles
  ///
  /// In en, this message translates to:
  /// **'Export Profiles'**
  String get exportProfiles;

  /// Translation for exportProfilesContent
  ///
  /// In en, this message translates to:
  /// **'Do you want to include API credentials in the export?\n\nWARNING: Including credentials will store API keys and secrets in plain text. Only include credentials if you will store the file securely.'**
  String get exportProfilesContent;

  /// Translation for exportProfilesTitle
  ///
  /// In en, this message translates to:
  /// **'Export Profiles'**
  String get exportProfilesTitle;

  /// Translation for exportSuccess
  ///
  /// In en, this message translates to:
  /// **'Export successful'**
  String get exportSuccess;

  /// Translation for exportThisProfile
  ///
  /// In en, this message translates to:
  /// **'Export This Profile'**
  String get exportThisProfile;

  /// Translation for failedDevices
  ///
  /// In en, this message translates to:
  /// **'Failed Devices'**
  String get failedDevices;

  /// No description provided for @failedToActionTailscaleService.
  ///
  /// In en, this message translates to:
  /// **'Failed to {action} Tailscale service'**
  String failedToActionTailscaleService(String action);

  /// Translation for failedToApplyConfiguration
  ///
  /// In en, this message translates to:
  /// **'Failed to apply configuration'**
  String get failedToApplyConfiguration;

  /// Translation for failedToBlockHost
  ///
  /// In en, this message translates to:
  /// **'Failed to block host'**
  String get failedToBlockHost;

  /// No description provided for @failedToConnect.
  ///
  /// In en, this message translates to:
  /// **'Failed to connect {name}'**
  String failedToConnect(String name);

  /// Error message when copying host fails
  ///
  /// In en, this message translates to:
  /// **'Failed to copy host: {error}'**
  String failedToCopyHost(String error);

  /// Error message when deleting alias fails
  ///
  /// In en, this message translates to:
  /// **'Failed to delete alias: {error}'**
  String failedToDeleteAlias(String error);

  /// Error message when deleting host fails
  ///
  /// In en, this message translates to:
  /// **'Failed to delete host: {error}'**
  String failedToDeleteHost(String error);

  /// No description provided for @failedToDeleteInstance.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete instance: {error}'**
  String failedToDeleteInstance(String error);

  /// No description provided for @failedToDeleteOverride.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete override: {error}'**
  String failedToDeleteOverride(String error);

  /// No description provided for @failedToDeletePeer.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete peer: {error}'**
  String failedToDeletePeer(String error);

  /// Translation for failedToDeleteProfile
  ///
  /// In en, this message translates to:
  /// **'Failed to delete profile'**
  String get failedToDeleteProfile;

  /// No description provided for @failedToDeleteServer.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete server: {error}'**
  String failedToDeleteServer(String error);

  /// No description provided for @failedToDeleteStaticKey.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete static key: {error}'**
  String failedToDeleteStaticKey(String error);

  /// No description provided for @failedToDisconnect.
  ///
  /// In en, this message translates to:
  /// **'Failed to disconnect {name}'**
  String failedToDisconnect(String name);

  /// No description provided for @failedToExportLogs.
  ///
  /// In en, this message translates to:
  /// **'Failed to export logs: {error}'**
  String failedToExportLogs(String error);

  /// No description provided for @failedToGenerateKey.
  ///
  /// In en, this message translates to:
  /// **'Failed to generate key: {error}'**
  String failedToGenerateKey(String error);

  /// No description provided for @failedToGenerateToken.
  ///
  /// In en, this message translates to:
  /// **'Failed to generate token: {error}'**
  String failedToGenerateToken(String error);

  /// Error message when loading interfaces fails
  ///
  /// In en, this message translates to:
  /// **'Failed to load interfaces: {error}'**
  String failedToLoadInterfaces(String error);

  /// Translation for failedToLoadOpenvpnLogs
  ///
  /// In en, this message translates to:
  /// **'Failed to load OpenVPN logs'**
  String get failedToLoadOpenvpnLogs;

  /// No description provided for @failedToRestartService.
  ///
  /// In en, this message translates to:
  /// **'Failed to restart {type} service'**
  String failedToRestartService(String type);

  /// Translation for failedToSaveAuthSettings
  ///
  /// In en, this message translates to:
  /// **'Failed to save authentication settings'**
  String get failedToSaveAuthSettings;

  /// Error message when saving host fails
  ///
  /// In en, this message translates to:
  /// **'Failed to save host: {error}'**
  String failedToSaveHost(String error);

  /// No description provided for @failedToSaveInstance.
  ///
  /// In en, this message translates to:
  /// **'Failed to save instance: {error}'**
  String failedToSaveInstance(String error);

  /// No description provided for @failedToSaveOverride.
  ///
  /// In en, this message translates to:
  /// **'Failed to save override: {error}'**
  String failedToSaveOverride(String error);

  /// Translation for failedToSavePeer
  ///
  /// In en, this message translates to:
  /// **'Failed to save peer'**
  String get failedToSavePeer;

  /// Translation for failedToSaveProfile
  ///
  /// In en, this message translates to:
  /// **'Failed to save profile'**
  String get failedToSaveProfile;

  /// Translation for failedToSaveServer
  ///
  /// In en, this message translates to:
  /// **'Failed to save server'**
  String get failedToSaveServer;

  /// Translation for failedToSaveSettings
  ///
  /// In en, this message translates to:
  /// **'Failed to save settings'**
  String get failedToSaveSettings;

  /// No description provided for @failedToSaveStaticKey.
  ///
  /// In en, this message translates to:
  /// **'Failed to save static key: {error}'**
  String failedToSaveStaticKey(String error);

  /// Translation for failedToStartService
  ///
  /// In en, this message translates to:
  /// **'Failed to start service'**
  String get failedToStartService;

  /// Translation for failedToStopService
  ///
  /// In en, this message translates to:
  /// **'Failed to stop service'**
  String get failedToStopService;

  /// Error message when toggling alias fails
  ///
  /// In en, this message translates to:
  /// **'Failed to toggle alias: {error}'**
  String failedToToggleAlias(String error);

  /// No description provided for @failedToToggleInstance.
  ///
  /// In en, this message translates to:
  /// **'Failed to toggle instance: {error}'**
  String failedToToggleInstance(String error);

  /// No description provided for @failedToToggleOverride.
  ///
  /// In en, this message translates to:
  /// **'Failed to toggle override: {error}'**
  String failedToToggleOverride(String error);

  /// No description provided for @failedToTogglePeer.
  ///
  /// In en, this message translates to:
  /// **'Failed to toggle peer: {error}'**
  String failedToTogglePeer(String error);

  /// No description provided for @failedToToggleServer.
  ///
  /// In en, this message translates to:
  /// **'Failed to toggle server: {error}'**
  String failedToToggleServer(String error);

  /// Error message when waking all hosts fails
  ///
  /// In en, this message translates to:
  /// **'Failed to wake all hosts: {error}'**
  String failedToWakeAllHosts(String error);

  /// Error message when waking host fails
  ///
  /// In en, this message translates to:
  /// **'Failed to wake host: {error}'**
  String failedToWakeHost(String error);

  /// No description provided for @featureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'{feature} - Coming soon'**
  String featureComingSoon(String feature);

  /// Translation for featuresList
  ///
  /// In en, this message translates to:
  /// **'• System monitoring and management\n• Firewall rule configuration\n• Service control\n• Real-time logs\n• Multi-profile support\n• Secure authentication'**
  String get featuresList;

  /// Translation for featuresTitle
  ///
  /// In en, this message translates to:
  /// **'Features'**
  String get featuresTitle;

  /// No description provided for @fieldIsRequired.
  ///
  /// In en, this message translates to:
  /// **'{fieldName} is required'**
  String fieldIsRequired(String fieldName);

  /// Translation for fieldRequired
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get fieldRequired;

  /// Translation for fifteenMin
  ///
  /// In en, this message translates to:
  /// **'15 min'**
  String get fifteenMin;

  /// Translation for filterByAction
  ///
  /// In en, this message translates to:
  /// **'Filter by Action'**
  String get filterByAction;

  /// Translation for filterByType
  ///
  /// In en, this message translates to:
  /// **'Filter by type'**
  String get filterByType;

  /// Translation for filterLabel
  ///
  /// In en, this message translates to:
  /// **'Filter: '**
  String get filterLabel;

  /// Translation for filters
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// Translation for filtersLabel
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filtersLabel;

  /// Translation for firewall
  ///
  /// In en, this message translates to:
  /// **'Firewall'**
  String get firewall;

  /// Translation for firewallAliases
  ///
  /// In en, this message translates to:
  /// **'Firewall Aliases'**
  String get firewallAliases;

  /// Translation for firewallLogs
  ///
  /// In en, this message translates to:
  /// **'Firewall Logs'**
  String get firewallLogs;

  /// Translation for firewallRuleDetails
  ///
  /// In en, this message translates to:
  /// **'Firewall Rule Details'**
  String get firewallRuleDetails;

  /// Translation for firewallRules
  ///
  /// In en, this message translates to:
  /// **'Firewall Rules'**
  String get firewallRules;

  /// Translation for firmwareDetails
  ///
  /// In en, this message translates to:
  /// **'Firmware Details'**
  String get firmwareDetails;

  /// Translation for fiveMin
  ///
  /// In en, this message translates to:
  /// **'5 min'**
  String get fiveMin;

  /// Translation for fixFormErrors
  ///
  /// In en, this message translates to:
  /// **'Please fix the errors in the form'**
  String get fixFormErrors;

  /// Translation for forbidden
  ///
  /// In en, this message translates to:
  /// **'Access forbidden'**
  String get forbidden;

  /// Translation for gateway
  ///
  /// In en, this message translates to:
  /// **'Gateway'**
  String get gateway;

  /// Translation for gatewayOptional
  ///
  /// In en, this message translates to:
  /// **'Gateway (Optional)'**
  String get gatewayOptional;

  /// Translation for gateways
  ///
  /// In en, this message translates to:
  /// **'Gateways'**
  String get gateways;

  /// Translation for general
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// Translation for generalSettings
  ///
  /// In en, this message translates to:
  /// **'General Settings'**
  String get generalSettings;

  /// Translation for generateKey
  ///
  /// In en, this message translates to:
  /// **'Generate Key'**
  String get generateKey;

  /// Translation for generateKeyPair
  ///
  /// In en, this message translates to:
  /// **'Generate Key Pair'**
  String get generateKeyPair;

  /// Translation for generateNewKeyPair
  ///
  /// In en, this message translates to:
  /// **'Generate New Key Pair'**
  String get generateNewKeyPair;

  /// Translation for generateOrPasteKeyHere
  ///
  /// In en, this message translates to:
  /// **'Generate or paste key here'**
  String get generateOrPasteKeyHere;

  /// Translation for generatePresharedKey
  ///
  /// In en, this message translates to:
  /// **'Generate pre-shared key'**
  String get generatePresharedKey;

  /// Translation for generated
  ///
  /// In en, this message translates to:
  /// **'Generated'**
  String get generated;

  /// Translation for generating
  ///
  /// In en, this message translates to:
  /// **'Generating...'**
  String get generating;

  /// Translation for gitCommit
  ///
  /// In en, this message translates to:
  /// **'Git Commit'**
  String get gitCommit;

  /// Translation for gnuLicenseText
  ///
  /// In en, this message translates to:
  /// **'This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.\n\nThis program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.\n\nYou should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.\n\nWhy GPLv3?\n\n• Ensures the software remains free and open source\n• Any modifications or derivatives must also be open source\n• Users have the freedom to use, study, share, and modify the software\n• The community benefits from improvements and contributions'**
  String get gnuLicenseText;

  /// Translation for gnuLicenseTitle
  ///
  /// In en, this message translates to:
  /// **'GNU General Public License v3.0'**
  String get gnuLicenseTitle;

  /// Translation for healthStatus
  ///
  /// In en, this message translates to:
  /// **'Health Status'**
  String get healthStatus;

  /// Translation for hideControls
  ///
  /// In en, this message translates to:
  /// **'Hide Controls'**
  String get hideControls;

  /// Translation for hideKey
  ///
  /// In en, this message translates to:
  /// **'Hide key'**
  String get hideKey;

  /// Translation for historySize
  ///
  /// In en, this message translates to:
  /// **'History Size'**
  String get historySize;

  /// Translation for host
  ///
  /// In en, this message translates to:
  /// **'Host'**
  String get host;

  /// Translation for hostAddedSuccessfully
  ///
  /// In en, this message translates to:
  /// **'Host added successfully'**
  String get hostAddedSuccessfully;

  /// Translation for hostBlocked
  ///
  /// In en, this message translates to:
  /// **'Host blocked successfully'**
  String get hostBlocked;

  /// Translation for hostDeletedSuccessfully
  ///
  /// In en, this message translates to:
  /// **'Host deleted successfully'**
  String get hostDeletedSuccessfully;

  /// Translation for hostHint
  ///
  /// In en, this message translates to:
  /// **'e.g., 192.168.1.1 or firewall.example.com'**
  String get hostHint;

  /// Translation for hostIpAddress
  ///
  /// In en, this message translates to:
  /// **'Host / IP Address'**
  String get hostIpAddress;

  /// Translation for hostIpAddressLabel
  ///
  /// In en, this message translates to:
  /// **'Host/IP Address'**
  String get hostIpAddressLabel;

  /// Translation for hostIsRequired
  ///
  /// In en, this message translates to:
  /// **'Host is required'**
  String get hostIsRequired;

  /// Translation for hostPlaceholder
  ///
  /// In en, this message translates to:
  /// **'192.168.1.1 or firewall.example.com'**
  String get hostPlaceholder;

  /// Translation for hostUpdatedSuccessfully
  ///
  /// In en, this message translates to:
  /// **'Host updated successfully'**
  String get hostUpdatedSuccessfully;

  /// Translation for hostname
  ///
  /// In en, this message translates to:
  /// **'Hostname'**
  String get hostname;

  /// Translation for hour
  ///
  /// In en, this message translates to:
  /// **'hour'**
  String get hour;

  /// Translation for hourAbbrev
  ///
  /// In en, this message translates to:
  /// **'h'**
  String get hourAbbrev;

  /// Translation for hours
  ///
  /// In en, this message translates to:
  /// **'hours'**
  String get hours;

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{hours}h ago'**
  String hoursAgo(String hours);

  /// Translation for http
  ///
  /// In en, this message translates to:
  /// **'http'**
  String get http;

  /// Translation for https
  ///
  /// In en, this message translates to:
  /// **'https'**
  String get https;

  /// Translation for id
  ///
  /// In en, this message translates to:
  /// **'ID'**
  String get id;

  /// Translation for import
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get import;

  /// Translation for importAndExport
  ///
  /// In en, this message translates to:
  /// **'Import & Export'**
  String get importAndExport;

  /// Translation for importExport
  ///
  /// In en, this message translates to:
  /// **'Import & Export'**
  String get importExport;

  /// Translation for importExportDescription
  ///
  /// In en, this message translates to:
  /// **'Export your profiles to back them up or transfer them to another device. Import profiles from a previously exported file.\n\nProfiles are saved in JSON format and can include connection endpoints and settings.'**
  String get importExportDescription;

  /// No description provided for @importFailed.
  ///
  /// In en, this message translates to:
  /// **'Import failed: {error}'**
  String importFailed(String error);

  /// No description provided for @importFailedWithErrors.
  ///
  /// In en, this message translates to:
  /// **'Import failed: {errors}'**
  String importFailedWithErrors(String errors);

  /// Translation for importProfiles
  ///
  /// In en, this message translates to:
  /// **'Import Profiles'**
  String get importProfiles;

  /// Translation for importProfilesDialog
  ///
  /// In en, this message translates to:
  /// **'How should existing profiles be handled?\n\n• Keep Both: Import with new IDs\n• Overwrite: Replace existing profiles'**
  String get importProfilesDialog;

  /// Translation for importProfilesSubtitle
  ///
  /// In en, this message translates to:
  /// **'Import profiles from a JSON file'**
  String get importProfilesSubtitle;

  /// Translation for importProfilesTitle
  ///
  /// In en, this message translates to:
  /// **'Import Profiles'**
  String get importProfilesTitle;

  /// Translation for importSuccess
  ///
  /// In en, this message translates to:
  /// **'Import successful'**
  String get importSuccess;

  /// No description provided for @importedProfiles.
  ///
  /// In en, this message translates to:
  /// **'Imported {count} profile(s)'**
  String importedProfiles(int count);

  /// No description provided for @importedWithFailures.
  ///
  /// In en, this message translates to:
  /// **'Imported {success} profile{success, plural, =1{} other{s}}, {failed} failed'**
  String importedWithFailures(int failed, int success);

  /// Time remaining in days
  ///
  /// In en, this message translates to:
  /// **'in {days}d'**
  String inDays(String days);

  /// Time remaining in hours
  ///
  /// In en, this message translates to:
  /// **'in {hours}h'**
  String inHours(String hours);

  /// Time remaining in minutes
  ///
  /// In en, this message translates to:
  /// **'in {minutes}m'**
  String inMinutes(String minutes);

  /// Translation for inbound
  ///
  /// In en, this message translates to:
  /// **'Inbound'**
  String get inbound;

  /// Translation for includeCredentials
  ///
  /// In en, this message translates to:
  /// **'Include Credentials'**
  String get includeCredentials;

  /// Translation for incorrectPin
  ///
  /// In en, this message translates to:
  /// **'Incorrect PIN'**
  String get incorrectPin;

  /// Translation for info
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get info;

  /// Translation for instance
  ///
  /// In en, this message translates to:
  /// **'Instance'**
  String get instance;

  /// Translation for instanceCreatedSuccessfully
  ///
  /// In en, this message translates to:
  /// **'Instance created successfully'**
  String get instanceCreatedSuccessfully;

  /// Translation for instanceDeletedSuccessfully
  ///
  /// In en, this message translates to:
  /// **'Instance deleted successfully'**
  String get instanceDeletedSuccessfully;

  /// Translation for instanceDetails
  ///
  /// In en, this message translates to:
  /// **'Instance Details'**
  String get instanceDetails;

  /// No description provided for @instanceToggledSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Instance {status} successfully'**
  String instanceToggledSuccessfully(String status);

  /// Translation for instanceUpdatedSuccessfully
  ///
  /// In en, this message translates to:
  /// **'Instance updated successfully'**
  String get instanceUpdatedSuccessfully;

  /// Translation for instanceWillBeActiveWhenEnabled
  ///
  /// In en, this message translates to:
  /// **'Instance will be active when enabled'**
  String get instanceWillBeActiveWhenEnabled;

  /// Translation for instances
  ///
  /// In en, this message translates to:
  /// **'Instances'**
  String get instances;

  /// Translation for interface
  ///
  /// In en, this message translates to:
  /// **'Interface'**
  String get interface;

  /// Label for network interface
  ///
  /// In en, this message translates to:
  /// **'{interface}'**
  String interfaceLabel(String interface);

  /// Translation for invalidApiKeyFormat
  ///
  /// In en, this message translates to:
  /// **'Invalid API Key format'**
  String get invalidApiKeyFormat;

  /// Translation for invalidApiSecretFormat
  ///
  /// In en, this message translates to:
  /// **'Invalid API Secret format'**
  String get invalidApiSecretFormat;

  /// Translation for invalidBase64Format
  ///
  /// In en, this message translates to:
  /// **'Invalid Base64 format'**
  String get invalidBase64Format;

  /// Translation for invalidCidrFormat
  ///
  /// In en, this message translates to:
  /// **'Invalid CIDR notation (use format: IP/prefix)'**
  String get invalidCidrFormat;

  /// Translation for invalidCidrNotation
  ///
  /// In en, this message translates to:
  /// **'Invalid CIDR notation (use format: IP/prefix)'**
  String get invalidCidrNotation;

  /// Translation for invalidDestinationFormat
  ///
  /// In en, this message translates to:
  /// **'Invalid destination format'**
  String get invalidDestinationFormat;

  /// No description provided for @invalidFileError.
  ///
  /// In en, this message translates to:
  /// **'Invalid file: {error}'**
  String invalidFileError(String error);

  /// No description provided for @invalidFileFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid file: {error}'**
  String invalidFileFormat(String error);

  /// Translation for invalidHostnameOrIp
  ///
  /// In en, this message translates to:
  /// **'Invalid hostname or IP address'**
  String get invalidHostnameOrIp;

  /// Translation for invalidInput
  ///
  /// In en, this message translates to:
  /// **'Invalid input'**
  String get invalidInput;

  /// Translation for invalidIpAddress
  ///
  /// In en, this message translates to:
  /// **'Invalid IP address'**
  String get invalidIpAddress;

  /// Translation for invalidIpAddressFormat
  ///
  /// In en, this message translates to:
  /// **'Invalid IP address (must be IPv4 or IPv6)'**
  String get invalidIpAddressFormat;

  /// Translation for invalidIpv4Address
  ///
  /// In en, this message translates to:
  /// **'Invalid IPv4 address'**
  String get invalidIpv4Address;

  /// Translation for invalidIpv4CidrNotation
  ///
  /// In en, this message translates to:
  /// **'Invalid IPv4 CIDR notation'**
  String get invalidIpv4CidrNotation;

  /// Translation for invalidIpv4Prefix
  ///
  /// In en, this message translates to:
  /// **'Invalid IPv4 prefix (must be 0-32)'**
  String get invalidIpv4Prefix;

  /// Translation for invalidIpv6Address
  ///
  /// In en, this message translates to:
  /// **'Invalid IPv6 address'**
  String get invalidIpv6Address;

  /// Translation for invalidIpv6CidrNotation
  ///
  /// In en, this message translates to:
  /// **'Invalid IPv6 CIDR notation'**
  String get invalidIpv6CidrNotation;

  /// Translation for invalidIpv6Prefix
  ///
  /// In en, this message translates to:
  /// **'Invalid IPv6 prefix (must be 0-128)'**
  String get invalidIpv6Prefix;

  /// Translation for invalidPIN
  ///
  /// In en, this message translates to:
  /// **'Invalid PIN'**
  String get invalidPIN;

  /// Translation for invalidPortFormat
  ///
  /// In en, this message translates to:
  /// **'Invalid port format'**
  String get invalidPortFormat;

  /// Translation for invalidPrefixLength
  ///
  /// In en, this message translates to:
  /// **'Invalid prefix length'**
  String get invalidPrefixLength;

  /// Translation for invalidSourceFormat
  ///
  /// In en, this message translates to:
  /// **'Invalid source format'**
  String get invalidSourceFormat;

  /// Translation for ipAddress
  ///
  /// In en, this message translates to:
  /// **'IP Address'**
  String get ipAddress;

  /// Translation for ipAddresses
  ///
  /// In en, this message translates to:
  /// **'IP Addresses'**
  String get ipAddresses;

  /// Translation for ipv4CidrHint
  ///
  /// In en, this message translates to:
  /// **'10.8.0.0/24'**
  String get ipv4CidrHint;

  /// Translation for ipv4OrIpv6CidrHint
  ///
  /// In en, this message translates to:
  /// **'10.8.0.0/24 or fd00::/64'**
  String get ipv4OrIpv6CidrHint;

  /// Translation for ipv4TunnelNetwork
  ///
  /// In en, this message translates to:
  /// **'IPv4 Tunnel Network'**
  String get ipv4TunnelNetwork;

  /// Translation for ipv4TunnelNetworkHint
  ///
  /// In en, this message translates to:
  /// **'10.8.0.0/24'**
  String get ipv4TunnelNetworkHint;

  /// Translation for ipv6CidrHint
  ///
  /// In en, this message translates to:
  /// **'fd00::/64'**
  String get ipv6CidrHint;

  /// Translation for ipv6TunnelNetwork
  ///
  /// In en, this message translates to:
  /// **'IPv6 Tunnel Network'**
  String get ipv6TunnelNetwork;

  /// Translation for ipv6TunnelNetworkHint
  ///
  /// In en, this message translates to:
  /// **'fd00::/64'**
  String get ipv6TunnelNetworkHint;

  /// Translation for iscDhcpDescription
  ///
  /// In en, this message translates to:
  /// **'Internet Systems Consortium DHCP server'**
  String get iscDhcpDescription;

  /// Translation for iscDhcpServerName
  ///
  /// In en, this message translates to:
  /// **'ISC DHCP'**
  String get iscDhcpServerName;

  /// Count of items in a list
  ///
  /// In en, this message translates to:
  /// **'{count} item(s)'**
  String itemsCount(int count);

  /// Translation for justNow
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// Translation for keaDhcpDescription
  ///
  /// In en, this message translates to:
  /// **'Modern, high-performance DHCP server'**
  String get keaDhcpDescription;

  /// Translation for keaDhcpServerName
  ///
  /// In en, this message translates to:
  /// **'Kea DHCP'**
  String get keaDhcpServerName;

  /// Translation for keepAliveIntervalOptional
  ///
  /// In en, this message translates to:
  /// **'Keep Alive Interval (Optional)'**
  String get keepAliveIntervalOptional;

  /// Translation for keepBoth
  ///
  /// In en, this message translates to:
  /// **'Keep Both'**
  String get keepBoth;

  /// Translation for keepalive
  ///
  /// In en, this message translates to:
  /// **'Keepalive'**
  String get keepalive;

  /// Translation for keepaliveOptional
  ///
  /// In en, this message translates to:
  /// **'Keepalive (Optional)'**
  String get keepaliveOptional;

  /// Translation for key
  ///
  /// In en, this message translates to:
  /// **'Key'**
  String get key;

  /// Translation for keyCopiedToClipboard
  ///
  /// In en, this message translates to:
  /// **'Key copied to clipboard'**
  String get keyCopiedToClipboard;

  /// Translation for keyGeneratedSuccessfully
  ///
  /// In en, this message translates to:
  /// **'Key generated successfully'**
  String get keyGeneratedSuccessfully;

  /// Translation for keyLabel
  ///
  /// In en, this message translates to:
  /// **'Key {id}'**
  String keyLabel(String id);

  /// No description provided for @keyWithId.
  ///
  /// In en, this message translates to:
  /// **'Key {id}'**
  String keyWithId(String id);

  /// Translation for keysGeneratedSuccessfully
  ///
  /// In en, this message translates to:
  /// **'Keys generated successfully'**
  String get keysGeneratedSuccessfully;

  /// Translation for keysRequired
  ///
  /// In en, this message translates to:
  /// **'Private and public keys are required'**
  String get keysRequired;

  /// Translation for label
  ///
  /// In en, this message translates to:
  /// **'Label'**
  String get label;

  /// Translation for labelHint
  ///
  /// In en, this message translates to:
  /// **'e.g., Home Network, Office VPN'**
  String get labelHint;

  /// Translation for labelOptional
  ///
  /// In en, this message translates to:
  /// **'Label (Optional)'**
  String get labelOptional;

  /// Translation for language
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Translation for lastDay
  ///
  /// In en, this message translates to:
  /// **'Last Day'**
  String get lastDay;

  /// Translation for lastDayShort
  ///
  /// In en, this message translates to:
  /// **'1 Day'**
  String get lastDayShort;

  /// Translation for lastMonth
  ///
  /// In en, this message translates to:
  /// **'Last Month'**
  String get lastMonth;

  /// Translation for lastMonthShort
  ///
  /// In en, this message translates to:
  /// **'1 Month'**
  String get lastMonthShort;

  /// Translation for lastUpdate
  ///
  /// In en, this message translates to:
  /// **'Last Update'**
  String get lastUpdate;

  /// No description provided for @lastUsed.
  ///
  /// In en, this message translates to:
  /// **'Last used: {date}'**
  String lastUsed(String date);

  /// Translation for lastWeek
  ///
  /// In en, this message translates to:
  /// **'Last Week'**
  String get lastWeek;

  /// Translation for lastWeekShort
  ///
  /// In en, this message translates to:
  /// **'1 Week'**
  String get lastWeekShort;

  /// No description provided for @leasesCount.
  ///
  /// In en, this message translates to:
  /// **'{filtered} of {total} lease(s)'**
  String leasesCount(int filtered, int total);

  /// Translation for leaveEmptyOrGenerate
  ///
  /// In en, this message translates to:
  /// **'Leave empty or generate'**
  String get leaveEmptyOrGenerate;

  /// Translation for licenses
  ///
  /// In en, this message translates to:
  /// **'Licenses'**
  String get licenses;

  /// Translation for lightMode
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// Translation for limit
  ///
  /// In en, this message translates to:
  /// **'Limit'**
  String get limit;

  /// Translation for live
  ///
  /// In en, this message translates to:
  /// **'LIVE'**
  String get live;

  /// Translation for liveNetworkMonitor
  ///
  /// In en, this message translates to:
  /// **'Live Network Monitor'**
  String get liveNetworkMonitor;

  /// Translation for loading
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Translation for loadingHostData
  ///
  /// In en, this message translates to:
  /// **'Loading host data...'**
  String get loadingHostData;

  /// Translation for loadingSettings
  ///
  /// In en, this message translates to:
  /// **'Loading settings...'**
  String get loadingSettings;

  /// Translation for localAddress
  ///
  /// In en, this message translates to:
  /// **'Local Address'**
  String get localAddress;

  /// Translation for localNetwork
  ///
  /// In en, this message translates to:
  /// **'Local Network'**
  String get localNetwork;

  /// Translation for localNetworkHelperText
  ///
  /// In en, this message translates to:
  /// **'These are the networks accessible by the client, these are pushed via route(-ipv6) clauses in OpenVPN to the client.'**
  String get localNetworkHelperText;

  /// No description provided for @lockAfterMinutes.
  ///
  /// In en, this message translates to:
  /// **'Lock after {minutes} {minutes, plural, =1{minute} other{minutes}} of inactivity'**
  String lockAfterMinutes(int minutes);

  /// Translation for lockApp
  ///
  /// In en, this message translates to:
  /// **'Lock App'**
  String get lockApp;

  /// Translation for lockTimeoutLabel
  ///
  /// In en, this message translates to:
  /// **'Lock Timeout'**
  String get lockTimeoutLabel;

  /// No description provided for @lockTimeoutSet.
  ///
  /// In en, this message translates to:
  /// **'Lock timeout set to {value} {value, plural, =1{minute} other{minutes}}'**
  String lockTimeoutSet(int value);

  /// Translation for logDetails
  ///
  /// In en, this message translates to:
  /// **'Log Details'**
  String get logDetails;

  /// Translation for logEntriesCopied
  ///
  /// In en, this message translates to:
  /// **'{count} log {entries} copied'**
  String logEntriesCopied(int count, String entries);

  /// Translation for logEntryCopied
  ///
  /// In en, this message translates to:
  /// **'Log entry copied'**
  String get logEntryCopied;

  /// Translation for logEntryDetails
  ///
  /// In en, this message translates to:
  /// **'Log Entry Details'**
  String get logEntryDetails;

  /// Translation for logFile
  ///
  /// In en, this message translates to:
  /// **'Log File'**
  String get logFile;

  /// Translation for logLimit
  ///
  /// In en, this message translates to:
  /// **'Log Limit'**
  String get logLimit;

  /// Translation for login
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Translation for loginServer
  ///
  /// In en, this message translates to:
  /// **'Login Server'**
  String get loginServer;

  /// Translation for loginServerHelperText
  ///
  /// In en, this message translates to:
  /// **'The Tailscale login server URL'**
  String get loginServerHelperText;

  /// Translation for loginServerRequired
  ///
  /// In en, this message translates to:
  /// **'Login server is required'**
  String get loginServerRequired;

  /// Translation for logout
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Translation for logs
  ///
  /// In en, this message translates to:
  /// **'Logs'**
  String get logs;

  /// Translation for logsExportedSuccessfully
  ///
  /// In en, this message translates to:
  /// **'Logs exported successfully'**
  String get logsExportedSuccessfully;

  /// Translation for logsMatchingFiltersWillAppearHere
  ///
  /// In en, this message translates to:
  /// **'Logs matching your filters will appear here'**
  String get logsMatchingFiltersWillAppearHere;

  /// Translation for logsWillAppear
  ///
  /// In en, this message translates to:
  /// **'Logs will appear here as they are generated'**
  String get logsWillAppear;

  /// Translation for macAddress
  ///
  /// In en, this message translates to:
  /// **'MAC Address'**
  String get macAddress;

  /// Translation for macAddressHint
  ///
  /// In en, this message translates to:
  /// **'e.g., 00:11:22:33:44:55'**
  String get macAddressHint;

  /// Translation for magicDns
  ///
  /// In en, this message translates to:
  /// **'Magic DNS'**
  String get magicDns;

  /// Translation for manageProfiles
  ///
  /// In en, this message translates to:
  /// **'Manage Profiles'**
  String get manageProfiles;

  /// Translation for manageSubnets
  ///
  /// In en, this message translates to:
  /// **'Manage Subnets'**
  String get manageSubnets;

  /// Translation for manageWireguard
  ///
  /// In en, this message translates to:
  /// **'Manage WireGuard'**
  String get manageWireguard;

  /// Translation for manufacturer
  ///
  /// In en, this message translates to:
  /// **'Manufacturer'**
  String get manufacturer;

  /// Translation for maximumTransmissionUnit
  ///
  /// In en, this message translates to:
  /// **'Maximum Transmission Unit (576-9000)'**
  String get maximumTransmissionUnit;

  /// Translation for memoryUsage
  ///
  /// In en, this message translates to:
  /// **'Memory Usage'**
  String get memoryUsage;

  /// Translation for minute
  ///
  /// In en, this message translates to:
  /// **'minute'**
  String get minute;

  /// Translation for minuteAbbrev
  ///
  /// In en, this message translates to:
  /// **'m'**
  String get minuteAbbrev;

  /// Translation for minutes
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get minutes;

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{minutes}m ago'**
  String minutesAgo(String minutes);

  /// Translation for mode
  ///
  /// In en, this message translates to:
  /// **'Mode'**
  String get mode;

  /// Translation for modified
  ///
  /// In en, this message translates to:
  /// **'Modified'**
  String get modified;

  /// Translation for monitorInterface
  ///
  /// In en, this message translates to:
  /// **'Monitor Interface'**
  String get monitorInterface;

  /// Translation for mssFix
  ///
  /// In en, this message translates to:
  /// **'MSS Fix'**
  String get mssFix;

  /// Translation for mssFixDescription
  ///
  /// In en, this message translates to:
  /// **'Enable MSS fix for this connection'**
  String get mssFixDescription;

  /// Translation for mtuOptional
  ///
  /// In en, this message translates to:
  /// **'MTU (Optional)'**
  String get mtuOptional;

  /// Translation for mustBeValidUrl
  ///
  /// In en, this message translates to:
  /// **'Must be a valid URL starting with http:// or https://'**
  String get mustBeValidUrl;

  /// Translation for myOPNsenseRouter
  ///
  /// In en, this message translates to:
  /// **'My OPNsense Router'**
  String get myOPNsenseRouter;

  /// Translation for myOpenvpnInstance
  ///
  /// In en, this message translates to:
  /// **'My OpenVPN Instance'**
  String get myOpenvpnInstance;

  /// Translation for myStaticKey
  ///
  /// In en, this message translates to:
  /// **'My Static Key'**
  String get myStaticKey;

  /// Translation for myWireguardPeer
  ///
  /// In en, this message translates to:
  /// **'My WireGuard Peer'**
  String get myWireguardPeer;

  /// Translation for myWireguardServer
  ///
  /// In en, this message translates to:
  /// **'My WireGuard Server'**
  String get myWireguardServer;

  /// Translation for name
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// Translation for needHelpCheckDocumentation
  ///
  /// In en, this message translates to:
  /// **'Need help? Check the OPNsense documentation for API key generation.'**
  String get needHelpCheckDocumentation;

  /// Translation for networkConfiguration
  ///
  /// In en, this message translates to:
  /// **'Network Configuration'**
  String get networkConfiguration;

  /// Translation for networkError
  ///
  /// In en, this message translates to:
  /// **'Network error occurred'**
  String get networkError;

  /// Translation for networkInformation
  ///
  /// In en, this message translates to:
  /// **'Network Information'**
  String get networkInformation;

  /// Translation for networkTotals
  ///
  /// In en, this message translates to:
  /// **'Network Totals'**
  String get networkTotals;

  /// Translation for newPin
  ///
  /// In en, this message translates to:
  /// **'New PIN (4-6 digits)'**
  String get newPin;

  /// Translation for newPinMustBeDifferent
  ///
  /// In en, this message translates to:
  /// **'New PIN must be different from current PIN'**
  String get newPinMustBeDifferent;

  /// Translation for newRule
  ///
  /// In en, this message translates to:
  /// **'New Rule'**
  String get newRule;

  /// Translation for newWireguardPeer
  ///
  /// In en, this message translates to:
  /// **'New WireGuard Peer'**
  String get newWireguardPeer;

  /// Translation for newWireguardServer
  ///
  /// In en, this message translates to:
  /// **'New WireGuard Server'**
  String get newWireguardServer;

  /// Translation for next
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Translation for nextButton
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get nextButton;

  /// Translation for no
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// Translation for noAliasesConfigured
  ///
  /// In en, this message translates to:
  /// **'No aliases configured'**
  String get noAliasesConfigured;

  /// Translation for noAliasesMatchFilters
  ///
  /// In en, this message translates to:
  /// **'No aliases match the current filters'**
  String get noAliasesMatchFilters;

  /// Translation for noAutomationRulesFound
  ///
  /// In en, this message translates to:
  /// **'No automation rules found'**
  String get noAutomationRulesFound;

  /// Translation for noClientSpecificOverridesConfigured
  ///
  /// In en, this message translates to:
  /// **'No client specific overrides configured'**
  String get noClientSpecificOverridesConfigured;

  /// No description provided for @noConnectionsFound.
  ///
  /// In en, this message translates to:
  /// **'No {type} connections found'**
  String noConnectionsFound(String type);

  /// Translation for noData
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noData;

  /// Translation for noDataAvailable
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noDataAvailable;

  /// Translation for noDescription
  ///
  /// In en, this message translates to:
  /// **'No Description'**
  String get noDescription;

  /// Translation for noDnsDomainSearchEntriesConfigured
  ///
  /// In en, this message translates to:
  /// **'No DNS domain search entries configured'**
  String get noDnsDomainSearchEntriesConfigured;

  /// Translation for noDnsDomainsConfigured
  ///
  /// In en, this message translates to:
  /// **'No DNS domains configured'**
  String get noDnsDomainsConfigured;

  /// Translation for noDnsServersConfigured
  ///
  /// In en, this message translates to:
  /// **'No DNS servers configured'**
  String get noDnsServersConfigured;

  /// Translation for noHostsFound
  ///
  /// In en, this message translates to:
  /// **'No hosts found'**
  String get noHostsFound;

  /// Translation for noInstancesMatchFilters
  ///
  /// In en, this message translates to:
  /// **'No instances match your filters'**
  String get noInstancesMatchFilters;

  /// Translation for noInterfacesWithAutomationRules
  ///
  /// In en, this message translates to:
  /// **'No interfaces with automation rules'**
  String get noInterfacesWithAutomationRules;

  /// Translation for noItemsConfigured
  ///
  /// In en, this message translates to:
  /// **'No items configured'**
  String get noItemsConfigured;

  /// Translation for noLeasesFound
  ///
  /// In en, this message translates to:
  /// **'No leases found'**
  String get noLeasesFound;

  /// Translation for noLimit
  ///
  /// In en, this message translates to:
  /// **'No Limit'**
  String get noLimit;

  /// Translation for noLimitShort
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get noLimitShort;

  /// Translation for noLocalNetworksConfigured
  ///
  /// In en, this message translates to:
  /// **'No local networks configured'**
  String get noLocalNetworksConfigured;

  /// Translation for noLogEntriesFound
  ///
  /// In en, this message translates to:
  /// **'No log entries found'**
  String get noLogEntriesFound;

  /// Translation for noLogsAvailable
  ///
  /// In en, this message translates to:
  /// **'No logs available'**
  String get noLogsAvailable;

  /// Translation for noLogsToExport
  ///
  /// In en, this message translates to:
  /// **'No logs to export'**
  String get noLogsToExport;

  /// Translation for noNtpServersConfigured
  ///
  /// In en, this message translates to:
  /// **'No NTP servers configured'**
  String get noNtpServersConfigured;

  /// Translation for noOpenvpnInstancesConfigured
  ///
  /// In en, this message translates to:
  /// **'No OpenVPN instances configured'**
  String get noOpenvpnInstancesConfigured;

  /// Translation for noOpenvpnRoutesConfigured
  ///
  /// In en, this message translates to:
  /// **'No OpenVPN routes configured'**
  String get noOpenvpnRoutesConfigured;

  /// Translation for noOpenvpnSessionsConfigured
  ///
  /// In en, this message translates to:
  /// **'There are no OpenVPN sessions configured'**
  String get noOpenvpnSessionsConfigured;

  /// Translation for noOptionsAvailable
  ///
  /// In en, this message translates to:
  /// **'No options available'**
  String get noOptionsAvailable;

  /// Translation for noOverridesMatchFilter
  ///
  /// In en, this message translates to:
  /// **'No overrides match your filter'**
  String get noOverridesMatchFilter;

  /// Translation for noPeersAvailable
  ///
  /// In en, this message translates to:
  /// **'No peers available'**
  String get noPeersAvailable;

  /// Translation for noPeersMatchSearch
  ///
  /// In en, this message translates to:
  /// **'No peers match your search'**
  String get noPeersMatchSearch;

  /// Translation for noProfiles
  ///
  /// In en, this message translates to:
  /// **'No Profiles'**
  String get noProfiles;

  /// Translation for noProfilesFound
  ///
  /// In en, this message translates to:
  /// **'No profiles found'**
  String get noProfilesFound;

  /// Translation for noProfilesYet
  ///
  /// In en, this message translates to:
  /// **'No Profiles Yet'**
  String get noProfilesYet;

  /// Translation for noRemoteNetworksConfigured
  ///
  /// In en, this message translates to:
  /// **'No remote networks configured'**
  String get noRemoteNetworksConfigured;

  /// Translation for noRoutesConfigured
  ///
  /// In en, this message translates to:
  /// **'No routes configured'**
  String get noRoutesConfigured;

  /// No description provided for @noRulesForInterface.
  ///
  /// In en, this message translates to:
  /// **'No rules for {interface}'**
  String noRulesForInterface(String interface);

  /// Translation for noServersAvailable
  ///
  /// In en, this message translates to:
  /// **'No servers available'**
  String get noServersAvailable;

  /// Translation for noServersMatchSearch
  ///
  /// In en, this message translates to:
  /// **'No servers match your search'**
  String get noServersMatchSearch;

  /// Translation for noServersSelected
  ///
  /// In en, this message translates to:
  /// **'No servers selected'**
  String get noServersSelected;

  /// Translation for noSessionsFound
  ///
  /// In en, this message translates to:
  /// **'No sessions found'**
  String get noSessionsFound;

  /// Translation for noSettingsAvailable
  ///
  /// In en, this message translates to:
  /// **'No settings available'**
  String get noSettingsAvailable;

  /// Translation for noStaticKeysConfigured
  ///
  /// In en, this message translates to:
  /// **'No static keys configured'**
  String get noStaticKeysConfigured;

  /// Translation for noSubnetsConfigured
  ///
  /// In en, this message translates to:
  /// **'No subnets configured'**
  String get noSubnetsConfigured;

  /// Translation for noTunnelAddressesConfigured
  ///
  /// In en, this message translates to:
  /// **'No tunnel addresses configured'**
  String get noTunnelAddressesConfigured;

  /// Translation for noVPNConnectionsFound
  ///
  /// In en, this message translates to:
  /// **'No VPN connections found'**
  String get noVPNConnectionsFound;

  /// Translation for noWinsServersConfigured
  ///
  /// In en, this message translates to:
  /// **'No WINS servers configured'**
  String get noWinsServersConfigured;

  /// Translation for noWireguardPeersConfigured
  ///
  /// In en, this message translates to:
  /// **'No WireGuard peers configured'**
  String get noWireguardPeersConfigured;

  /// Translation for noWireguardServersConfigured
  ///
  /// In en, this message translates to:
  /// **'No WireGuard servers configured'**
  String get noWireguardServersConfigured;

  /// Translation for noWireguardStatusDataAvailable
  ///
  /// In en, this message translates to:
  /// **'No WireGuard status data available'**
  String get noWireguardStatusDataAvailable;

  /// Translation for noWolHostsConfigured
  ///
  /// In en, this message translates to:
  /// **'No Wake on LAN hosts configured'**
  String get noWolHostsConfigured;

  /// Translation for none
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// Not available abbreviation
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get notAvailable;

  /// Translation for notFound
  ///
  /// In en, this message translates to:
  /// **'Resource not found'**
  String get notFound;

  /// Translation for notice
  ///
  /// In en, this message translates to:
  /// **'Notice'**
  String get notice;

  /// Translation for ntpServers
  ///
  /// In en, this message translates to:
  /// **'NTP Servers'**
  String get ntpServers;

  /// Translation for ntpServersHelperText
  ///
  /// In en, this message translates to:
  /// **'Set primary NTP server address (Network Time Protocol). Repeat this option to set secondary NTP server addresses.'**
  String get ntpServersHelperText;

  /// Translation for of1Gbps
  ///
  /// In en, this message translates to:
  /// **'of 1 Gbps'**
  String get of1Gbps;

  /// Translation for offline
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// Translation for ok
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Translation for oneHour
  ///
  /// In en, this message translates to:
  /// **'1 hour'**
  String get oneHour;

  /// Translation for oneMin
  ///
  /// In en, this message translates to:
  /// **'1 min'**
  String get oneMin;

  /// Translation for online
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// Translation for openvpn
  ///
  /// In en, this message translates to:
  /// **'OpenVPN'**
  String get openvpn;

  /// Translation for openvpnConnectionStatus
  ///
  /// In en, this message translates to:
  /// **'OpenVPN Connection Status'**
  String get openvpnConnectionStatus;

  /// Translation for openvpnInstances
  ///
  /// In en, this message translates to:
  /// **'OpenVPN Instances'**
  String get openvpnInstances;

  /// Translation for openvpnLogFile
  ///
  /// In en, this message translates to:
  /// **'OpenVPN Log File'**
  String get openvpnLogFile;

  /// Translation for optional
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// Translation for optionalBase64EncodedPresharedKey
  ///
  /// In en, this message translates to:
  /// **'Optional Base64-encoded preshared key'**
  String get optionalBase64EncodedPresharedKey;

  /// Translation for outbound
  ///
  /// In en, this message translates to:
  /// **'Outbound'**
  String get outbound;

  /// Translation for overrideCreatedSuccessfully
  ///
  /// In en, this message translates to:
  /// **'Override created successfully'**
  String get overrideCreatedSuccessfully;

  /// Translation for overrideDeletedSuccessfully
  ///
  /// In en, this message translates to:
  /// **'Override deleted successfully'**
  String get overrideDeletedSuccessfully;

  /// Translation for overrideDetails
  ///
  /// In en, this message translates to:
  /// **'Override Details'**
  String get overrideDetails;

  /// No description provided for @overrideToggledSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Override {status} successfully'**
  String overrideToggledSuccessfully(String status);

  /// Translation for overrideUpdatedSuccessfully
  ///
  /// In en, this message translates to:
  /// **'Override updated successfully'**
  String get overrideUpdatedSuccessfully;

  /// Translation for overwrite
  ///
  /// In en, this message translates to:
  /// **'Overwrite'**
  String get overwrite;

  /// Translation for packageMirror
  ///
  /// In en, this message translates to:
  /// **'Package Mirror'**
  String get packageMirror;

  /// Translation for packetLength
  ///
  /// In en, this message translates to:
  /// **'Packet Length'**
  String get packetLength;

  /// No description provided for @pageOfPages.
  ///
  /// In en, this message translates to:
  /// **'Page {current} of {total}'**
  String pageOfPages(String current, String total);

  /// Translation for pass
  ///
  /// In en, this message translates to:
  /// **'Pass'**
  String get pass;

  /// Translation for pause
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// Translation for pauseLiveViewToSelect
  ///
  /// In en, this message translates to:
  /// **'Pause live view to select log entries'**
  String get pauseLiveViewToSelect;

  /// Translation for paused
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get paused;

  /// Translation for peerActiveWhenEnabled
  ///
  /// In en, this message translates to:
  /// **'Peer will be active when enabled'**
  String get peerActiveWhenEnabled;

  /// Translation for peerCreatedReadyForNext
  ///
  /// In en, this message translates to:
  /// **'Peer created successfully. Ready for next peer.'**
  String get peerCreatedReadyForNext;

  /// Translation for peerCreatedSuccessfully
  ///
  /// In en, this message translates to:
  /// **'Peer created successfully'**
  String get peerCreatedSuccessfully;

  /// Translation for peerDeletedSuccessfully
  ///
  /// In en, this message translates to:
  /// **'Peer deleted successfully'**
  String get peerDeletedSuccessfully;

  /// Translation for peerDisabledSuccessfully
  ///
  /// In en, this message translates to:
  /// **'Peer disabled successfully'**
  String get peerDisabledSuccessfully;

  /// Translation for peerEnabledSuccessfully
  ///
  /// In en, this message translates to:
  /// **'Peer enabled successfully'**
  String get peerEnabledSuccessfully;

  /// Translation for peerGenerator
  ///
  /// In en, this message translates to:
  /// **'Peer Generator'**
  String get peerGenerator;

  /// Translation for peerUpdatedSuccessfully
  ///
  /// In en, this message translates to:
  /// **'Peer updated successfully'**
  String get peerUpdatedSuccessfully;

  /// Translation for peerWillBeActiveWhenEnabled
  ///
  /// In en, this message translates to:
  /// **'Peer will be active when enabled'**
  String get peerWillBeActiveWhenEnabled;

  /// Translation for peers
  ///
  /// In en, this message translates to:
  /// **'Peers'**
  String get peers;

  /// No description provided for @peersConfigured.
  ///
  /// In en, this message translates to:
  /// **'{count} peer(s) configured'**
  String peersConfigured(int count);

  /// Translation for peersCount
  ///
  /// In en, this message translates to:
  /// **'Peers Count'**
  String get peersCount;

  /// No description provided for @peersSelected.
  ///
  /// In en, this message translates to:
  /// **'{count} peer(s) selected'**
  String peersSelected(int count);

  /// Translation for persistentKeepaliveSeconds
  ///
  /// In en, this message translates to:
  /// **'Persistent keepalive in seconds (recommended: 25)'**
  String get persistentKeepaliveSeconds;

  /// Translation for pinChangedSuccessfully
  ///
  /// In en, this message translates to:
  /// **'PIN changed successfully'**
  String get pinChangedSuccessfully;

  /// Translation for pinLock
  ///
  /// In en, this message translates to:
  /// **'PIN Lock'**
  String get pinLock;

  /// Translation for pinLockDisabled
  ///
  /// In en, this message translates to:
  /// **'PIN lock disabled. Biometric lock also disabled.'**
  String get pinLockDisabled;

  /// Translation for pinLockEnabled
  ///
  /// In en, this message translates to:
  /// **'PIN lock enabled'**
  String get pinLockEnabled;

  /// Translation for pinLockTitle
  ///
  /// In en, this message translates to:
  /// **'PIN Lock'**
  String get pinLockTitle;

  /// Translation for pinMismatch
  ///
  /// In en, this message translates to:
  /// **'PINs do not match'**
  String get pinMismatch;

  /// Translation for pinMustContainOnlyNumbers
  ///
  /// In en, this message translates to:
  /// **'PIN must contain only numbers'**
  String get pinMustContainOnlyNumbers;

  /// Translation for pinTooShort
  ///
  /// In en, this message translates to:
  /// **'PIN must be at least 4 digits'**
  String get pinTooShort;

  /// Translation for platform
  ///
  /// In en, this message translates to:
  /// **'Platform'**
  String get platform;

  /// Translation for pleaseAddConnectionEndpoint
  ///
  /// In en, this message translates to:
  /// **'Please add at least one connection endpoint'**
  String get pleaseAddConnectionEndpoint;

  /// Translation for pleaseEnterCurrentPin
  ///
  /// In en, this message translates to:
  /// **'Please enter your current PIN'**
  String get pleaseEnterCurrentPin;

  /// Translation for pleaseEnterNewPin
  ///
  /// In en, this message translates to:
  /// **'Please enter a new PIN'**
  String get pleaseEnterNewPin;

  /// Translation for pleaseEnterSubnet
  ///
  /// In en, this message translates to:
  /// **'Please enter a subnet'**
  String get pleaseEnterSubnet;

  /// Translation for pleaseEnterYourPin
  ///
  /// In en, this message translates to:
  /// **'Please enter your PIN'**
  String get pleaseEnterYourPin;

  /// Translation for pleaseSelectAnInstance
  ///
  /// In en, this message translates to:
  /// **'Please select an instance'**
  String get pleaseSelectAnInstance;

  /// Translation for pleaseSelectInterface
  ///
  /// In en, this message translates to:
  /// **'Please select an interface'**
  String get pleaseSelectInterface;

  /// Translation for port
  ///
  /// In en, this message translates to:
  /// **'Port'**
  String get port;

  /// Translation for portHint
  ///
  /// In en, this message translates to:
  /// **'e.g., 443'**
  String get portHint;

  /// Translation for portIsRequired
  ///
  /// In en, this message translates to:
  /// **'Port is required'**
  String get portIsRequired;

  /// Translation for portLabel
  ///
  /// In en, this message translates to:
  /// **'Port {port}'**
  String portLabel(String port);

  /// Translation for portMustBeBetween
  ///
  /// In en, this message translates to:
  /// **'Port must be between 1 and 65535'**
  String get portMustBeBetween;

  /// Translation for portPlaceholder
  ///
  /// In en, this message translates to:
  /// **'443'**
  String get portPlaceholder;

  /// Translation for preAuthKey
  ///
  /// In en, this message translates to:
  /// **'Pre-Auth Key'**
  String get preAuthKey;

  /// Translation for preAuthKeyHelperText
  ///
  /// In en, this message translates to:
  /// **'Optional: Pre-authentication key for automatic device registration'**
  String get preAuthKeyHelperText;

  /// Translation for presharedKeyGeneratedSuccessfully
  ///
  /// In en, this message translates to:
  /// **'Pre-shared key generated successfully'**
  String get presharedKeyGeneratedSuccessfully;

  /// Translation for presharedKeyOptional
  ///
  /// In en, this message translates to:
  /// **'Pre-shared Key (Optional)'**
  String get presharedKeyOptional;

  /// Translation for preventAutomaticRouteInstallation
  ///
  /// In en, this message translates to:
  /// **'Prevent automatic route installation'**
  String get preventAutomaticRouteInstallation;

  /// Translation for previous
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// Translation for previousButton
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previousButton;

  /// Translation for privateKey
  ///
  /// In en, this message translates to:
  /// **'Private Key'**
  String get privateKey;

  /// Translation for profileActivated
  ///
  /// In en, this message translates to:
  /// **'Profile activated successfully'**
  String get profileActivated;

  /// Translation for profileAdded
  ///
  /// In en, this message translates to:
  /// **'Profile added'**
  String get profileAdded;

  /// Translation for profileDeleted
  ///
  /// In en, this message translates to:
  /// **'Profile deleted successfully'**
  String get profileDeleted;

  /// Translation for profileHasNoEndpoints
  ///
  /// In en, this message translates to:
  /// **'Profile has no connection endpoints configured'**
  String get profileHasNoEndpoints;

  /// Translation for profileName
  ///
  /// In en, this message translates to:
  /// **'Profile Name'**
  String get profileName;

  /// Translation for profileNameLabel
  ///
  /// In en, this message translates to:
  /// **'Profile Name'**
  String get profileNameLabel;

  /// Translation for profileNameOptional
  ///
  /// In en, this message translates to:
  /// **'Profile Name (Optional)'**
  String get profileNameOptional;

  /// Translation for profileNameRequired
  ///
  /// In en, this message translates to:
  /// **'Profile name is required'**
  String get profileNameRequired;

  /// Translation for profileSaved
  ///
  /// In en, this message translates to:
  /// **'Profile saved successfully'**
  String get profileSaved;

  /// Translation for profileUpdated
  ///
  /// In en, this message translates to:
  /// **'Profile updated'**
  String get profileUpdated;

  /// Translation for profiles
  ///
  /// In en, this message translates to:
  /// **'Profiles'**
  String get profiles;

  /// No description provided for @profilesExportedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Profiles exported successfully!\n{path}'**
  String profilesExportedSuccessfully(String path);

  /// Translation for protocol
  ///
  /// In en, this message translates to:
  /// **'Protocol'**
  String get protocol;

  /// Translation for protocolAh
  ///
  /// In en, this message translates to:
  /// **'AH'**
  String get protocolAh;

  /// Translation for protocolEsp
  ///
  /// In en, this message translates to:
  /// **'ESP'**
  String get protocolEsp;

  /// Translation for protocolGre
  ///
  /// In en, this message translates to:
  /// **'GRE'**
  String get protocolGre;

  /// Translation for protocolIcmp
  ///
  /// In en, this message translates to:
  /// **'ICMP'**
  String get protocolIcmp;

  /// Translation for protocolIcmpv6
  ///
  /// In en, this message translates to:
  /// **'ICMPv6'**
  String get protocolIcmpv6;

  /// Translation for protocolIgmp
  ///
  /// In en, this message translates to:
  /// **'IGMP'**
  String get protocolIgmp;

  /// Translation for protocolIpv6
  ///
  /// In en, this message translates to:
  /// **'IPv6'**
  String get protocolIpv6;

  /// Translation for protocolOspf
  ///
  /// In en, this message translates to:
  /// **'OSPF'**
  String get protocolOspf;

  /// Translation for protocolPim
  ///
  /// In en, this message translates to:
  /// **'PIM'**
  String get protocolPim;

  /// Translation for protocolTcp
  ///
  /// In en, this message translates to:
  /// **'TCP'**
  String get protocolTcp;

  /// Translation for protocolTcpUdp
  ///
  /// In en, this message translates to:
  /// **'TCP/UDP'**
  String get protocolTcpUdp;

  /// Translation for protocolUdp
  ///
  /// In en, this message translates to:
  /// **'UDP'**
  String get protocolUdp;

  /// Translation for publicKey
  ///
  /// In en, this message translates to:
  /// **'Public Key'**
  String get publicKey;

  /// Translation for publicKeyColon
  ///
  /// In en, this message translates to:
  /// **'Public Key:'**
  String get publicKeyColon;

  /// Translation for publicKeyRequired
  ///
  /// In en, this message translates to:
  /// **'Public key is required'**
  String get publicKeyRequired;

  /// No description provided for @publicKeyShort.
  ///
  /// In en, this message translates to:
  /// **'{key}...'**
  String publicKeyShort(String key);

  /// Translation for pushReset
  ///
  /// In en, this message translates to:
  /// **'Push reset'**
  String get pushReset;

  /// Translation for pushResetSubtitle
  ///
  /// In en, this message translates to:
  /// **'Don\'t inherit the global push list for a specific client instance. NOTE: --push-reset is very thorough: it will remove almost all options from the list of to-be-pushed options. In many cases, some of these options will need to be re-configured afterwards - specifically, --topology subnet and --route-gateway will get lost and this will break client configs in many cases.'**
  String get pushResetSubtitle;

  /// Translation for pushVirtualIpEndpoints
  ///
  /// In en, this message translates to:
  /// **'Push virtual IP endpoints for client tunnel, overriding dynamic allocation.'**
  String get pushVirtualIpEndpoints;

  /// Translation for qrCode
  ///
  /// In en, this message translates to:
  /// **'QR Code'**
  String get qrCode;

  /// Translation for reason
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get reason;

  /// Translation for rebootConfirmation
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reboot the system?'**
  String get rebootConfirmation;

  /// Translation for rebootFailed
  ///
  /// In en, this message translates to:
  /// **'Failed to reboot system'**
  String get rebootFailed;

  /// No description provided for @rebootFailedWithError.
  ///
  /// In en, this message translates to:
  /// **'{message}: {error}'**
  String rebootFailedWithError(String message, String error);

  /// Translation for rebootSuccess
  ///
  /// In en, this message translates to:
  /// **'System reboot initiated'**
  String get rebootSuccess;

  /// Translation for rebootSystem
  ///
  /// In en, this message translates to:
  /// **'Reboot System'**
  String get rebootSystem;

  /// Translation for received
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get received;

  /// Translation for recommendedForSecureConnections
  ///
  /// In en, this message translates to:
  /// **'Recommended for secure connections'**
  String get recommendedForSecureConnections;

  /// Translation for redirectGateway
  ///
  /// In en, this message translates to:
  /// **'Redirect gateway'**
  String get redirectGateway;

  /// Translation for redirectGatewayHelperText
  ///
  /// In en, this message translates to:
  /// **'Automatically execute routing commands to cause all outgoing IP traffic to be redirected over the VPN.'**
  String get redirectGatewayHelperText;

  /// Translation for refresh
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// Translation for refreshTooltip
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refreshTooltip;

  /// Translation for registerDNS
  ///
  /// In en, this message translates to:
  /// **'Register DNS'**
  String get registerDns;

  /// Translation for registerDnsSubtitle
  ///
  /// In en, this message translates to:
  /// **'Run ipconfig /flushdns and ipconfig /registerdns on connection initiation. This is known to kick Windows into recognizing pushed DNS servers.'**
  String get registerDnsSubtitle;

  /// Translation for reject
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// Translation for remoteAddress
  ///
  /// In en, this message translates to:
  /// **'Remote Address'**
  String get remoteAddress;

  /// Translation for remoteNetwork
  ///
  /// In en, this message translates to:
  /// **'Remote Network'**
  String get remoteNetwork;

  /// Translation for remoteNetworkHelperText
  ///
  /// In en, this message translates to:
  /// **'Remote networks for the server, these are configured via iroute(-ipv6) clauses in OpenVPN and inform the server to send these networks to this specific client.'**
  String get remoteNetworkHelperText;

  /// Translation for repository
  ///
  /// In en, this message translates to:
  /// **'Repository'**
  String get repository;

  /// Translation for requirePinToUnlock
  ///
  /// In en, this message translates to:
  /// **'Require PIN to unlock app'**
  String get requirePinToUnlock;

  /// Translation for required
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// Translation for restart
  ///
  /// In en, this message translates to:
  /// **'Restart'**
  String get restart;

  /// Translation for restartButton
  ///
  /// In en, this message translates to:
  /// **'Restart'**
  String get restartButton;

  /// Translation for restartService
  ///
  /// In en, this message translates to:
  /// **'Restart Service'**
  String get restartService;

  /// No description provided for @restartServiceConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to restart the {type} service?\n\nThis will temporarily disconnect all active connections.'**
  String restartServiceConfirmation(String type);

  /// Translation for restartVPNService
  ///
  /// In en, this message translates to:
  /// **'Restart VPN Service'**
  String get restartVPNService;

  /// No description provided for @restartingService.
  ///
  /// In en, this message translates to:
  /// **'Restarting {type} service...'**
  String restartingService(String type);

  /// Translation for resume
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resume;

  /// Translation for retry
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Translation for retryButton
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryButton;

  /// Translation for role
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// Translation for routeGateway
  ///
  /// In en, this message translates to:
  /// **'Route gateway'**
  String get routeGateway;

  /// Translation for routeGatewayHelperText
  ///
  /// In en, this message translates to:
  /// **'Specify a default gateway to use for the connected client. Without one set the first address in the netblock is being offered. When segmenting the tunnel (server) network, this one might not be accessible from the client.'**
  String get routeGatewayHelperText;

  /// Translation for routeGatewayHint
  ///
  /// In en, this message translates to:
  /// **'10.8.0.1'**
  String get routeGatewayHint;

  /// Translation for routes
  ///
  /// In en, this message translates to:
  /// **'Routes'**
  String get routes;

  /// Translation for routing
  ///
  /// In en, this message translates to:
  /// **'Routing'**
  String get routing;

  /// Translation for rowsPerPage
  ///
  /// In en, this message translates to:
  /// **'Rows per page'**
  String get rowsPerPage;

  /// Translation for rowsPerPageDropdown
  ///
  /// In en, this message translates to:
  /// **'Rows per page'**
  String get rowsPerPageDropdown;

  /// Translation for rowsPerPageLabel
  ///
  /// In en, this message translates to:
  /// **'Rows per page: '**
  String get rowsPerPageLabel;

  /// Translation for ruleActionFailed
  ///
  /// In en, this message translates to:
  /// **'Rule action failed'**
  String get ruleActionFailed;

  /// Translation for ruleCreated
  ///
  /// In en, this message translates to:
  /// **'Rule created successfully'**
  String get ruleCreated;

  /// Translation for ruleDeleted
  ///
  /// In en, this message translates to:
  /// **'Rule deleted successfully'**
  String get ruleDeleted;

  /// Translation for ruleDescription
  ///
  /// In en, this message translates to:
  /// **'Rule Description'**
  String get ruleDescription;

  /// Translation for ruleDetails
  ///
  /// In en, this message translates to:
  /// **'Rule Details'**
  String get ruleDetails;

  /// Translation for ruleDisabledSuccessfully
  ///
  /// In en, this message translates to:
  /// **'Rule disabled successfully'**
  String get ruleDisabledSuccessfully;

  /// Translation for ruleEnabledSuccessfully
  ///
  /// In en, this message translates to:
  /// **'Rule enabled successfully'**
  String get ruleEnabledSuccessfully;

  /// Translation for ruleGuidelines
  ///
  /// In en, this message translates to:
  /// **'Rule Guidelines'**
  String get ruleGuidelines;

  /// Translation for ruleGuidelinesText
  ///
  /// In en, this message translates to:
  /// **'• Use \"any\" to match all addresses or ports\n• CIDR notation: 192.168.1.0/24\n• Port ranges: 80-443\n• Rules are processed in sequence order\n• Changes are applied immediately'**
  String get ruleGuidelinesText;

  /// Translation for ruleId
  ///
  /// In en, this message translates to:
  /// **'Rule ID'**
  String get ruleId;

  /// Translation for ruleInformation
  ///
  /// In en, this message translates to:
  /// **'Rule Information'**
  String get ruleInformation;

  /// Translation for ruleUpdated
  ///
  /// In en, this message translates to:
  /// **'Rule updated successfully'**
  String get ruleUpdated;

  /// Translation for ruleWillBeActiveWhenEnabled
  ///
  /// In en, this message translates to:
  /// **'Rule will be active when enabled'**
  String get ruleWillBeActiveWhenEnabled;

  /// Translation for running
  ///
  /// In en, this message translates to:
  /// **'Running'**
  String get running;

  /// Translation for runningStatus
  ///
  /// In en, this message translates to:
  /// **'Running'**
  String get runningStatus;

  /// Translation for save
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Translation for saveAndConnect
  ///
  /// In en, this message translates to:
  /// **'Save & Connect'**
  String get saveAndConnect;

  /// Translation for saveSettings
  ///
  /// In en, this message translates to:
  /// **'Save Settings'**
  String get saveSettings;

  /// Translation for saveTooltip
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveTooltip;

  /// Translation for saveWithoutTesting
  ///
  /// In en, this message translates to:
  /// **'Save without testing'**
  String get saveWithoutTesting;

  /// Translation for saving
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saving;

  /// Translation for savingOverride
  ///
  /// In en, this message translates to:
  /// **'Saving override...'**
  String get savingOverride;

  /// Translation for savingProfile
  ///
  /// In en, this message translates to:
  /// **'Saving profile...'**
  String get savingProfile;

  /// Translation for searchAliases
  ///
  /// In en, this message translates to:
  /// **'Search aliases...'**
  String get searchAliases;

  /// Translation for searchHostnameIpOrMac
  ///
  /// In en, this message translates to:
  /// **'Search hostname, IP, or MAC address...'**
  String get searchHostnameIpOrMac;

  /// Translation for searchHostnameOrIp
  ///
  /// In en, this message translates to:
  /// **'Search hostname or IP address...'**
  String get searchHostnameOrIp;

  /// Translation for searchInstances
  ///
  /// In en, this message translates to:
  /// **'Search instances...'**
  String get searchInstances;

  /// Translation for searchOverrides
  ///
  /// In en, this message translates to:
  /// **'Search overrides...'**
  String get searchOverrides;

  /// Translation for searchPeers
  ///
  /// In en, this message translates to:
  /// **'Search peers...'**
  String get searchPeers;

  /// Translation for searchServers
  ///
  /// In en, this message translates to:
  /// **'Search servers...'**
  String get searchServers;

  /// Translation for second
  ///
  /// In en, this message translates to:
  /// **'second'**
  String get second;

  /// Translation for secondAbbrev
  ///
  /// In en, this message translates to:
  /// **'s'**
  String get secondAbbrev;

  /// Translation for seconds
  ///
  /// In en, this message translates to:
  /// **'Seconds'**
  String get seconds;

  /// Translation for security
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// Translation for securityWarning
  ///
  /// In en, this message translates to:
  /// **'Security Warning'**
  String get securityWarning;

  /// Translation for selectAProfileOrCreateNewOne
  ///
  /// In en, this message translates to:
  /// **'Select a profile or create a new one'**
  String get selectAProfileOrCreateNewOne;

  /// Translation for selectAll
  ///
  /// In en, this message translates to:
  /// **'Select All'**
  String get selectAll;

  /// Translation for selectExitNode
  ///
  /// In en, this message translates to:
  /// **'Select exit node'**
  String get selectExitNode;

  /// Translation for selectInterface
  ///
  /// In en, this message translates to:
  /// **'Select Interface'**
  String get selectInterface;

  /// Translation for selectInterfaceToViewRules
  ///
  /// In en, this message translates to:
  /// **'Select an interface to view rules'**
  String get selectInterfaceToViewRules;

  /// Translation for selectKeyModeForAuthOrEncryption
  ///
  /// In en, this message translates to:
  /// **'Select the key mode for authentication or encryption'**
  String get selectKeyModeForAuthOrEncryption;

  /// Translation for selectLabel
  ///
  /// In en, this message translates to:
  /// **'Select {label}'**
  String selectLabel(String label);

  /// Translation for selectMultipleInterfaces
  ///
  /// In en, this message translates to:
  /// **'Select one or more interfaces to monitor'**
  String get selectMultipleInterfaces;

  /// Translation for selectNumberOfEntries
  ///
  /// In en, this message translates to:
  /// **'Select the number of log entries to display:'**
  String get selectNumberOfEntries;

  /// Translation for selectPeers
  ///
  /// In en, this message translates to:
  /// **'Select Peers'**
  String get selectPeers;

  /// Translation for selectServerAndGenerateKeys
  ///
  /// In en, this message translates to:
  /// **'# Select a server and generate keys to preview configuration'**
  String get selectServerAndGenerateKeys;

  /// Translation for selectServerForQrCode
  ///
  /// In en, this message translates to:
  /// **'Select server to generate QR code'**
  String get selectServerForQrCode;

  /// Translation for selectServerInstance
  ///
  /// In en, this message translates to:
  /// **'Please select a server instance'**
  String get selectServerInstance;

  /// Translation for selectServerToGenerateQrCode
  ///
  /// In en, this message translates to:
  /// **'Select server to generate QR code'**
  String get selectServerToGenerateQrCode;

  /// Translation for selectServers
  ///
  /// In en, this message translates to:
  /// **'Select Servers'**
  String get selectServers;

  /// Translation for selectServersHelperText
  ///
  /// In en, this message translates to:
  /// **'Select the OpenVPN servers where this override applies to, leave empty for all'**
  String get selectServersHelperText;

  /// Translation for selectServersTitle
  ///
  /// In en, this message translates to:
  /// **'Select Servers'**
  String get selectServersTitle;

  /// Translation for selectVhid
  ///
  /// In en, this message translates to:
  /// **'Select VHID'**
  String get selectVhid;

  /// Translation for selected
  ///
  /// In en, this message translates to:
  /// **'selected'**
  String get selected;

  /// Translation for selfSignedCertWarning
  ///
  /// In en, this message translates to:
  /// **'Warning: Self-signed certificates are less secure. Only enable this if you trust the server.'**
  String get selfSignedCertWarning;

  /// Translation for selfSignedCertificatesWarning
  ///
  /// In en, this message translates to:
  /// **'Only enable this if you trust the server'**
  String get selfSignedCertificatesWarning;

  /// Translation for sent
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get sent;

  /// Translation for sequence
  ///
  /// In en, this message translates to:
  /// **'Sequence'**
  String get sequence;

  /// Translation for server
  ///
  /// In en, this message translates to:
  /// **'Server'**
  String get server;

  /// Translation for serverActiveWhenEnabled
  ///
  /// In en, this message translates to:
  /// **'Server will be active when enabled'**
  String get serverActiveWhenEnabled;

  /// Translation for serverAddress
  ///
  /// In en, this message translates to:
  /// **'Server Address'**
  String get serverAddress;

  /// Translation for serverCreatedSuccessfully
  ///
  /// In en, this message translates to:
  /// **'Server created successfully'**
  String get serverCreatedSuccessfully;

  /// Translation for serverDeletedSuccessfully
  ///
  /// In en, this message translates to:
  /// **'Server deleted successfully'**
  String get serverDeletedSuccessfully;

  /// Translation for serverDisabledSuccessfully
  ///
  /// In en, this message translates to:
  /// **'Server disabled successfully'**
  String get serverDisabledSuccessfully;

  /// Translation for serverEnabledSuccessfully
  ///
  /// In en, this message translates to:
  /// **'Server enabled successfully'**
  String get serverEnabledSuccessfully;

  /// Translation for serverError
  ///
  /// In en, this message translates to:
  /// **'Server error occurred'**
  String get serverError;

  /// Translation for serverInfoNotLoaded
  ///
  /// In en, this message translates to:
  /// **'Server information not loaded'**
  String get serverInfoNotLoaded;

  /// Translation for serverNetwork
  ///
  /// In en, this message translates to:
  /// **'Server Network'**
  String get serverNetwork;

  /// Translation for serverPort
  ///
  /// In en, this message translates to:
  /// **'Server Port'**
  String get serverPort;

  /// Translation for serverSelectionRequired
  ///
  /// In en, this message translates to:
  /// **'At least one server must be selected'**
  String get serverSelectionRequired;

  /// Translation for serverUpdatedSuccessfully
  ///
  /// In en, this message translates to:
  /// **'Server updated successfully'**
  String get serverUpdatedSuccessfully;

  /// Translation for serverWillBeActiveWhenEnabled
  ///
  /// In en, this message translates to:
  /// **'Server will be active when enabled'**
  String get serverWillBeActiveWhenEnabled;

  /// Translation for servers
  ///
  /// In en, this message translates to:
  /// **'Servers'**
  String get servers;

  /// Translation for serversLabel
  ///
  /// In en, this message translates to:
  /// **'Servers'**
  String get serversLabel;

  /// No description provided for @serversSelected.
  ///
  /// In en, this message translates to:
  /// **'{count} server(s) selected'**
  String serversSelected(int count);

  /// Translation for serviceActionFailed
  ///
  /// In en, this message translates to:
  /// **'Service action failed'**
  String get serviceActionFailed;

  /// Translation for serviceControls
  ///
  /// In en, this message translates to:
  /// **'Service Controls'**
  String get serviceControls;

  /// Translation for serviceRestarted
  ///
  /// In en, this message translates to:
  /// **'Service restarted successfully'**
  String get serviceRestarted;

  /// Translation for serviceRestartedSuccessfully
  ///
  /// In en, this message translates to:
  /// **'Service restarted successfully'**
  String get serviceRestartedSuccessfully;

  /// Translation for serviceRunning
  ///
  /// In en, this message translates to:
  /// **'Service Running'**
  String get serviceRunning;

  /// Translation for serviceStarted
  ///
  /// In en, this message translates to:
  /// **'Service started successfully'**
  String get serviceStarted;

  /// Translation for serviceStartedSuccessfully
  ///
  /// In en, this message translates to:
  /// **'Service started successfully'**
  String get serviceStartedSuccessfully;

  /// Translation for serviceStatus
  ///
  /// In en, this message translates to:
  /// **'Service Status'**
  String get serviceStatus;

  /// Translation for serviceStopped
  ///
  /// In en, this message translates to:
  /// **'Service stopped successfully'**
  String get serviceStopped;

  /// Translation for serviceStoppedSuccessfully
  ///
  /// In en, this message translates to:
  /// **'Service stopped successfully'**
  String get serviceStoppedSuccessfully;

  /// Translation for services
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get services;

  /// Translation for sessionTimeout
  ///
  /// In en, this message translates to:
  /// **'Session Timeout'**
  String get sessionTimeout;

  /// Translation for sessions
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get sessions;

  /// Translation for setAsActive
  ///
  /// In en, this message translates to:
  /// **'Set as Active'**
  String get setAsActive;

  /// Translation for setPin
  ///
  /// In en, this message translates to:
  /// **'Set PIN'**
  String get setPin;

  /// Translation for settings
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Translation for severitiesAndTimeFilter
  ///
  /// In en, this message translates to:
  /// **'{count} severities • {timeFilter}'**
  String severitiesAndTimeFilter(int count, String timeFilter);

  /// Translation for severity
  ///
  /// In en, this message translates to:
  /// **'Severity'**
  String get severity;

  /// Translation for severityAlert
  ///
  /// In en, this message translates to:
  /// **'Alert'**
  String get severityAlert;

  /// Translation for severityCritical
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get severityCritical;

  /// Translation for severityDebug
  ///
  /// In en, this message translates to:
  /// **'Debug'**
  String get severityDebug;

  /// Translation for severityEmergency
  ///
  /// In en, this message translates to:
  /// **'Emergency'**
  String get severityEmergency;

  /// Translation for severityEmergencyShort
  ///
  /// In en, this message translates to:
  /// **'Emerg'**
  String get severityEmergencyShort;

  /// Translation for severityError
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get severityError;

  /// Translation for severityInformational
  ///
  /// In en, this message translates to:
  /// **'Informational'**
  String get severityInformational;

  /// Translation for severityInformationalShort
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get severityInformationalShort;

  /// Translation for severityNotice
  ///
  /// In en, this message translates to:
  /// **'Notice'**
  String get severityNotice;

  /// Translation for severityWarning
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get severityWarning;

  /// Translation for showAdvancedSettings
  ///
  /// In en, this message translates to:
  /// **'Show Advanced Settings'**
  String get showAdvancedSettings;

  /// Translation for showAll
  ///
  /// In en, this message translates to:
  /// **'Show All'**
  String get showAll;

  /// Translation for showKey
  ///
  /// In en, this message translates to:
  /// **'Show key'**
  String get showKey;

  /// No description provided for @showingEntriesCount.
  ///
  /// In en, this message translates to:
  /// **'Showing {start} to {end}'**
  String showingEntriesCount(String start, String end);

  /// No description provided for @showingInstancesCount.
  ///
  /// In en, this message translates to:
  /// **'Showing {count} of {total}'**
  String showingInstancesCount(String count, String total);

  /// Translation for showingZeroEntries
  ///
  /// In en, this message translates to:
  /// **'Showing 0 entries'**
  String get showingZeroEntries;

  /// Translation for someConnectionsFailed
  ///
  /// In en, this message translates to:
  /// **'Some connections failed'**
  String get someConnectionsFailed;

  /// Translation for soon
  ///
  /// In en, this message translates to:
  /// **'soon'**
  String get soon;

  /// Translation for sortBy
  ///
  /// In en, this message translates to:
  /// **'Sort By'**
  String get sortBy;

  /// Translation for sortByBandwidth
  ///
  /// In en, this message translates to:
  /// **'Bandwidth'**
  String get sortByBandwidth;

  /// Translation for sortByHostname
  ///
  /// In en, this message translates to:
  /// **'Hostname'**
  String get sortByHostname;

  /// Translation for sortByIP
  ///
  /// In en, this message translates to:
  /// **'IP Address'**
  String get sortByIP;

  /// Translation for sortByManufacturer
  ///
  /// In en, this message translates to:
  /// **'Manufacturer'**
  String get sortByManufacturer;

  /// Translation for source
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get source;

  /// Translation for sourceAddress
  ///
  /// In en, this message translates to:
  /// **'Source Address'**
  String get sourceAddress;

  /// Translation for sourceIsRequired
  ///
  /// In en, this message translates to:
  /// **'Source is required'**
  String get sourceIsRequired;

  /// Translation for sourcePort
  ///
  /// In en, this message translates to:
  /// **'Source Port'**
  String get sourcePort;

  /// Translation for sourcePortOptional
  ///
  /// In en, this message translates to:
  /// **'Source Port (Optional)'**
  String get sourcePortOptional;

  /// Translation for sshEnabled
  ///
  /// In en, this message translates to:
  /// **'SSH Enabled'**
  String get sshEnabled;

  /// Translation for start
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// Translation for startButton
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get startButton;

  /// Translation for startService
  ///
  /// In en, this message translates to:
  /// **'Start Service'**
  String get startService;

  /// Translation for startTime
  ///
  /// In en, this message translates to:
  /// **'Start Time'**
  String get startTime;

  /// Translation for startWireguardService
  ///
  /// In en, this message translates to:
  /// **'Start WireGuard service'**
  String get startWireguardService;

  /// Translation for staticKeyContentPemFormat
  ///
  /// In en, this message translates to:
  /// **'Static key content in PEM format'**
  String get staticKeyContentPemFormat;

  /// Translation for staticKeyCreatedSuccessfully
  ///
  /// In en, this message translates to:
  /// **'Static key created successfully'**
  String get staticKeyCreatedSuccessfully;

  /// Translation for staticKeyDeletedSuccessfully
  ///
  /// In en, this message translates to:
  /// **'Static key deleted successfully'**
  String get staticKeyDeletedSuccessfully;

  /// Translation for staticKeyDetails
  ///
  /// In en, this message translates to:
  /// **'Static Key Details'**
  String get staticKeyDetails;

  /// Translation for staticKeyInfoHelp
  ///
  /// In en, this message translates to:
  /// **'• Auth: Adds HMAC authentication to control channel\n• Crypt: Encrypts and authenticates all control channel packets\n• Crypt V2: Enhanced encryption with improved security\n\nYou can generate a new key or paste an existing one.'**
  String get staticKeyInfoHelp;

  /// Translation for staticKeyInformation
  ///
  /// In en, this message translates to:
  /// **'Static Key Information'**
  String get staticKeyInformation;

  /// Translation for staticKeyUpdatedSuccessfully
  ///
  /// In en, this message translates to:
  /// **'Static key updated successfully'**
  String get staticKeyUpdatedSuccessfully;

  /// Translation for staticKeys
  ///
  /// In en, this message translates to:
  /// **'Static Keys'**
  String get staticKeys;

  /// Translation for staticLease
  ///
  /// In en, this message translates to:
  /// **'Static'**
  String get staticLease;

  /// Translation for status
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// Translation for stop
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stop;

  /// Translation for stopButton
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stopButton;

  /// Translation for stopService
  ///
  /// In en, this message translates to:
  /// **'Stop Service'**
  String get stopService;

  /// Translation for stopped
  ///
  /// In en, this message translates to:
  /// **'Stopped'**
  String get stopped;

  /// Translation for stoppedStatus
  ///
  /// In en, this message translates to:
  /// **'Stopped'**
  String get stoppedStatus;

  /// Translation for storeAndGenerateNext
  ///
  /// In en, this message translates to:
  /// **'Store and Generate Next'**
  String get storeAndGenerateNext;

  /// Translation for subnetAddedSuccessfully
  ///
  /// In en, this message translates to:
  /// **'Subnet added successfully'**
  String get subnetAddedSuccessfully;

  /// Translation for subnetCidr
  ///
  /// In en, this message translates to:
  /// **'Subnet (CIDR)'**
  String get subnetCidr;

  /// Translation for subnetDeletedSuccessfully
  ///
  /// In en, this message translates to:
  /// **'Subnet deleted successfully'**
  String get subnetDeletedSuccessfully;

  /// Translation for subnetUpdatedSuccessfully
  ///
  /// In en, this message translates to:
  /// **'Subnet updated successfully'**
  String get subnetUpdatedSuccessfully;

  /// Translation for success
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

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

  /// No description provided for @successfullyImportedProfiles.
  ///
  /// In en, this message translates to:
  /// **'Successfully imported {count} profile{count, plural, =1{} other{s}}'**
  String successfullyImportedProfiles(int count);

  /// No description provided for @successfullyRestartedService.
  ///
  /// In en, this message translates to:
  /// **'Successfully restarted {type} service'**
  String successfullyRestartedService(String type);

  /// Success message showing how many devices were woken
  ///
  /// In en, this message translates to:
  /// **'Successfully woken {successCount} of {totalCount} device{plural}'**
  String successfullyWokenDevices(
    int successCount,
    int totalCount,
    String plural,
  );

  /// Translation for switchProfile
  ///
  /// In en, this message translates to:
  /// **'Switch Profile'**
  String get switchProfile;

  /// Translation for switchProfileConfirmation
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to switch profiles? You will be returned to the profile selection screen.'**
  String get switchProfileConfirmation;

  /// Translation for systemDefault
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get systemDefault;

  /// Translation for systemGeneratedRule
  ///
  /// In en, this message translates to:
  /// **'This is a system-generated rule and cannot be modified or deleted.'**
  String get systemGeneratedRule;

  /// Translation for systemGeneratedRulesCannotBeDeleted
  ///
  /// In en, this message translates to:
  /// **'System-generated rules cannot be deleted'**
  String get systemGeneratedRulesCannotBeDeleted;

  /// Translation for systemGeneratedRulesCannotBeModified
  ///
  /// In en, this message translates to:
  /// **'System-generated rules cannot be modified'**
  String get systemGeneratedRulesCannotBeModified;

  /// Translation for systemInfo
  ///
  /// In en, this message translates to:
  /// **'System Information'**
  String get systemInfo;

  /// Translation for systemInformation
  ///
  /// In en, this message translates to:
  /// **'System Information'**
  String get systemInformation;

  /// Translation for systemType
  ///
  /// In en, this message translates to:
  /// **'System Type'**
  String get systemType;

  /// Translation for tags
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get tags;

  /// Translation for tailscale
  ///
  /// In en, this message translates to:
  /// **'Tailscale'**
  String get tailscale;

  /// Translation for tailscaleAuthentication
  ///
  /// In en, this message translates to:
  /// **'Tailscale Authentication'**
  String get tailscaleAuthentication;

  /// No description provided for @tailscaleServiceAction.
  ///
  /// In en, this message translates to:
  /// **'{action} Tailscale Service'**
  String tailscaleServiceAction(String action);

  /// No description provided for @tailscaleServiceActionConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to {action} the Tailscale service?'**
  String tailscaleServiceActionConfirmation(String action);

  /// No description provided for @tailscaleServiceActionSuccess.
  ///
  /// In en, this message translates to:
  /// **'Tailscale service {action}ed successfully'**
  String tailscaleServiceActionSuccess(String action);

  /// No description provided for @tailscaleServiceActioning.
  ///
  /// In en, this message translates to:
  /// **'{action}ing Tailscale service...'**
  String tailscaleServiceActioning(String action);

  /// Translation for tailscaleSettings
  ///
  /// In en, this message translates to:
  /// **'Tailscale Settings'**
  String get tailscaleSettings;

  /// Translation for tailscaleStatus
  ///
  /// In en, this message translates to:
  /// **'Tailscale Status'**
  String get tailscaleStatus;

  /// Translation for tailscaleSubnets
  ///
  /// In en, this message translates to:
  /// **'Tailscale Subnets'**
  String get tailscaleSubnets;

  /// Label for Tailscale version information
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get tailscaleVersion;

  /// Translation for tapPlusButtonToCreateFirstInstance
  ///
  /// In en, this message translates to:
  /// **'Tap the + button to create your first instance'**
  String get tapPlusButtonToCreateFirstInstance;

  /// Translation for tapPlusButtonToCreateFirstOverride
  ///
  /// In en, this message translates to:
  /// **'Tap the + button to create your first override'**
  String get tapPlusButtonToCreateFirstOverride;

  /// Translation for tapPlusButtonToCreateFirstStaticKey
  ///
  /// In en, this message translates to:
  /// **'Tap the + button to create your first static key'**
  String get tapPlusButtonToCreateFirstStaticKey;

  /// Translation for tcpFlags
  ///
  /// In en, this message translates to:
  /// **'TCP Flags'**
  String get tcpFlags;

  /// Translation for tenMin
  ///
  /// In en, this message translates to:
  /// **'10 min'**
  String get tenMin;

  /// Translation for testConnection
  ///
  /// In en, this message translates to:
  /// **'Test Connection'**
  String get testConnection;

  /// Translation for testConnections
  ///
  /// In en, this message translates to:
  /// **'Test Connections'**
  String get testConnections;

  /// Translation for testProfile
  ///
  /// In en, this message translates to:
  /// **'Test Profile'**
  String get testProfile;

  /// Translation for testingAllConnections
  ///
  /// In en, this message translates to:
  /// **'Testing all connection points...'**
  String get testingAllConnections;

  /// Message shown when testing a connection endpoint
  ///
  /// In en, this message translates to:
  /// **'Testing connection {current} of {total}: {endpoint}'**
  String testingConnection(String current, String total, String endpoint);

  /// Translation for theme
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// Translation for thirtyMin
  ///
  /// In en, this message translates to:
  /// **'30 min'**
  String get thirtyMin;

  /// Translation for time
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// Translation for timeRange
  ///
  /// In en, this message translates to:
  /// **'Time range'**
  String get timeRange;

  /// Translation for timeRangeLabel
  ///
  /// In en, this message translates to:
  /// **'Time range'**
  String get timeRangeLabel;

  /// Translation for timeout
  ///
  /// In en, this message translates to:
  /// **'Request timeout'**
  String get timeout;

  /// Translation for timestamp
  ///
  /// In en, this message translates to:
  /// **'Timestamp'**
  String get timestamp;

  /// Translation for today
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// Translation for totalBandwidth
  ///
  /// In en, this message translates to:
  /// **'Total Bandwidth'**
  String get totalBandwidth;

  /// Translation for totalDownload
  ///
  /// In en, this message translates to:
  /// **'Total Download'**
  String get totalDownload;

  /// Translation for totalEntries
  ///
  /// In en, this message translates to:
  /// **'Total Entries'**
  String get totalEntries;

  /// Translation for totalUpload
  ///
  /// In en, this message translates to:
  /// **'Total Upload'**
  String get totalUpload;

  /// Translation for totalVPNs
  ///
  /// In en, this message translates to:
  /// **'Total VPNs'**
  String get totalVPNs;

  /// Translation for tryAdjustingFilters
  ///
  /// In en, this message translates to:
  /// **'Try adjusting the selected severity or date filters.'**
  String get tryAdjustingFilters;

  /// Translation for tryDemoMode
  ///
  /// In en, this message translates to:
  /// **'Try Demo Mode'**
  String get tryDemoMode;

  /// Translation for tryDifferentSearch
  ///
  /// In en, this message translates to:
  /// **'Try a different search term'**
  String get tryDifferentSearch;

  /// Translation for tunnelAddress
  ///
  /// In en, this message translates to:
  /// **'Tunnel Address'**
  String get tunnelAddress;

  /// Translation for tunnelAddressCidr
  ///
  /// In en, this message translates to:
  /// **'Tunnel Address (CIDR)'**
  String get tunnelAddressCidr;

  /// Translation for tunnelAddressRequired
  ///
  /// In en, this message translates to:
  /// **'At least one tunnel address is required'**
  String get tunnelAddressRequired;

  /// Translation for tunnelAddresses
  ///
  /// In en, this message translates to:
  /// **'Tunnel Addresses'**
  String get tunnelAddresses;

  /// No description provided for @tunnelLabel.
  ///
  /// In en, this message translates to:
  /// **'Tunnel: {network}'**
  String tunnelLabel(String network);

  /// Translation for tunnelNetwork
  ///
  /// In en, this message translates to:
  /// **'Tunnel Network'**
  String get tunnelNetwork;

  /// Translation for tunnelSettings
  ///
  /// In en, this message translates to:
  /// **'Tunnel Settings'**
  String get tunnelSettings;

  /// No description provided for @tunnelWithValue.
  ///
  /// In en, this message translates to:
  /// **'Tunnel: {value}'**
  String tunnelWithValue(String value);

  /// Translation for twoMin
  ///
  /// In en, this message translates to:
  /// **'2 min'**
  String get twoMin;

  /// Translation for type
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @typeWithValue.
  ///
  /// In en, this message translates to:
  /// **'Type: {value}'**
  String typeWithValue(String value);

  /// Translation for udpPortDefault51820
  ///
  /// In en, this message translates to:
  /// **'UDP port (default: 51820)'**
  String get udpPortDefault51820;

  /// Translation for unableToAccessFilePath
  ///
  /// In en, this message translates to:
  /// **'Unable to access file path'**
  String get unableToAccessFilePath;

  /// Translation for unableToConnectToAnyEndpoint
  ///
  /// In en, this message translates to:
  /// **'Unable to connect to any configured endpoints. Please check your network settings and try again.'**
  String get unableToConnectToAnyEndpoint;

  /// Translation for unauthorized
  ///
  /// In en, this message translates to:
  /// **'Unauthorized access'**
  String get unauthorized;

  /// Translation for unitBytes
  ///
  /// In en, this message translates to:
  /// **'B'**
  String get unitBytes;

  /// Translation for unitGigabytes
  ///
  /// In en, this message translates to:
  /// **'GB'**
  String get unitGigabytes;

  /// Translation for unitKilobytes
  ///
  /// In en, this message translates to:
  /// **'KB'**
  String get unitKilobytes;

  /// Translation for unitMegabytes
  ///
  /// In en, this message translates to:
  /// **'MB'**
  String get unitMegabytes;

  /// Per second suffix for data rates
  ///
  /// In en, this message translates to:
  /// **'/s'**
  String get unitPerSecond;

  /// Translation for unitPetabytes
  ///
  /// In en, this message translates to:
  /// **'PB'**
  String get unitPetabytes;

  /// Translation for unitTerabytes
  ///
  /// In en, this message translates to:
  /// **'TB'**
  String get unitTerabytes;

  /// Translation for unknown
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// Translation for unknownStatus
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknownStatus;

  /// Translation for unlock
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get unlock;

  /// Translation for unlockOPNsenseManager
  ///
  /// In en, this message translates to:
  /// **'Unlock OPNsense Manager'**
  String get unlockOPNsenseManager;

  /// Translation for unnamedHost
  ///
  /// In en, this message translates to:
  /// **'Unnamed Host'**
  String get unnamedHost;

  /// Translation for unnamedInstance
  ///
  /// In en, this message translates to:
  /// **'Unnamed Instance'**
  String get unnamedInstance;

  /// Translation for unnamedRule
  ///
  /// In en, this message translates to:
  /// **'Unnamed Rule'**
  String get unnamedRule;

  /// Translation for unsavedChanges
  ///
  /// In en, this message translates to:
  /// **'Unsaved Changes'**
  String get unsavedChanges;

  /// Translation for unsavedChangesConfirmation
  ///
  /// In en, this message translates to:
  /// **'You have unsaved changes. Do you want to discard them and continue?'**
  String get unsavedChangesConfirmation;

  /// Translation for update
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// Translation for updateOverride
  ///
  /// In en, this message translates to:
  /// **'Update Override'**
  String get updateOverride;

  /// Translation for updatePeer
  ///
  /// In en, this message translates to:
  /// **'Update Peer'**
  String get updatePeer;

  /// Translation for updatePinCode
  ///
  /// In en, this message translates to:
  /// **'Update your PIN code'**
  String get updatePinCode;

  /// Translation for updateRule
  ///
  /// In en, this message translates to:
  /// **'Update Rule'**
  String get updateRule;

  /// Translation for updateServer
  ///
  /// In en, this message translates to:
  /// **'Update Server'**
  String get updateServer;

  /// Translation for updateStaticKey
  ///
  /// In en, this message translates to:
  /// **'Update Static Key'**
  String get updateStaticKey;

  /// Translation for upload
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get upload;

  /// Translation for uptime
  ///
  /// In en, this message translates to:
  /// **'Uptime'**
  String get uptime;

  /// Translation for useBiometric
  ///
  /// In en, this message translates to:
  /// **'Use Biometric'**
  String get useBiometric;

  /// No description provided for @useBiometricToUnlock.
  ///
  /// In en, this message translates to:
  /// **'Use {biometricType} to unlock app'**
  String useBiometricToUnlock(String biometricType);

  /// Translation for useExitNode
  ///
  /// In en, this message translates to:
  /// **'Use Exit Node'**
  String get useExitNode;

  /// Translation for useHttps
  ///
  /// In en, this message translates to:
  /// **'Use HTTPS'**
  String get useHttps;

  /// Translation for useHttpsDescription
  ///
  /// In en, this message translates to:
  /// **'Use secure HTTPS connection'**
  String get useHttpsDescription;

  /// Translation for useHttpsLabel
  ///
  /// In en, this message translates to:
  /// **'Use HTTPS'**
  String get useHttpsLabel;

  /// Translation for useProtocolForCommunicating
  ///
  /// In en, this message translates to:
  /// **'Use this protocol for communicating'**
  String get useProtocolForCommunicating;

  /// Translation for valid
  ///
  /// In en, this message translates to:
  /// **'Valid'**
  String get valid;

  /// Translation for validFrom
  ///
  /// In en, this message translates to:
  /// **'Valid From'**
  String get validFrom;

  /// Message shown when verifying a connection
  ///
  /// In en, this message translates to:
  /// **'Verifying connection to {endpoint}...'**
  String verifyingConnection(String endpoint);

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String version(String version);

  /// Label for version information
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get versionLabel;

  /// Translation for viewDetails
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// Translation for viewFullLicense
  ///
  /// In en, this message translates to:
  /// **'View Full License'**
  String get viewFullLicense;

  /// Translation for virtualAddress
  ///
  /// In en, this message translates to:
  /// **'Virtual Address'**
  String get virtualAddress;

  /// Translation for vpn
  ///
  /// In en, this message translates to:
  /// **'VPN'**
  String get vpn;

  /// Translation for vpnConnections
  ///
  /// In en, this message translates to:
  /// **'VPN Connections'**
  String get vpnConnections;

  /// Translation for vpnConnectionsWillAppear
  ///
  /// In en, this message translates to:
  /// **'VPN connections will appear here when configured'**
  String get vpnConnectionsWillAppear;

  /// Translation for vpnStatus
  ///
  /// In en, this message translates to:
  /// **'VPN Status'**
  String get vpnStatus;

  /// Translation for vpnType
  ///
  /// In en, this message translates to:
  /// **'VPN Type'**
  String get vpnType;

  /// Translation for wakeAll
  ///
  /// In en, this message translates to:
  /// **'Wake All'**
  String get wakeAll;

  /// Translation for wakeAllDevices
  ///
  /// In en, this message translates to:
  /// **'Wake All Devices'**
  String get wakeAllDevices;

  /// Translation for wakeAllDevicesConfirmation
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to send wake packets to all configured devices?'**
  String get wakeAllDevicesConfirmation;

  /// Translation for wakeAllResults
  ///
  /// In en, this message translates to:
  /// **'Wake All Results'**
  String get wakeAllResults;

  /// Translation for wakeHost
  ///
  /// In en, this message translates to:
  /// **'Wake Host'**
  String get wakeHost;

  /// Translation for wakeOnLan
  ///
  /// In en, this message translates to:
  /// **'Wake on LAN'**
  String get wakeOnLan;

  /// Translation for wakingAllDevices
  ///
  /// In en, this message translates to:
  /// **'Waking all devices...'**
  String get wakingAllDevices;

  /// Translation for warning
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// Translation for winsServers
  ///
  /// In en, this message translates to:
  /// **'WINS Servers'**
  String get winsServers;

  /// Translation for winsServersHelperText
  ///
  /// In en, this message translates to:
  /// **'Set primary WINS server address (NetBIOS over TCP/IP Name Server). Repeat this option to set secondary WINS server addresses.'**
  String get winsServersHelperText;

  /// Translation for wireguard
  ///
  /// In en, this message translates to:
  /// **'WireGuard'**
  String get wireguard;

  /// Translation for wireguardLogs
  ///
  /// In en, this message translates to:
  /// **'WireGuard Logs'**
  String get wireguardLogs;

  /// Translation for wireguardLogsExport
  ///
  /// In en, this message translates to:
  /// **'WireGuard Logs Export'**
  String get wireguardLogsExport;

  /// No description provided for @wireguardLogsExportedOn.
  ///
  /// In en, this message translates to:
  /// **'WireGuard logs exported on {date}'**
  String wireguardLogsExportedOn(String date);

  /// Translation for wireguardPeers
  ///
  /// In en, this message translates to:
  /// **'WireGuard Peers'**
  String get wireguardPeers;

  /// Translation for wireguardServers
  ///
  /// In en, this message translates to:
  /// **'WireGuard Servers'**
  String get wireguardServers;

  /// Translation for wireguardServiceStarted
  ///
  /// In en, this message translates to:
  /// **'WireGuard service started'**
  String get wireguardServiceStarted;

  /// Translation for wireguardServiceStopped
  ///
  /// In en, this message translates to:
  /// **'WireGuard service stopped'**
  String get wireguardServiceStopped;

  /// Translation for wireguardStatus
  ///
  /// In en, this message translates to:
  /// **'WireGuard Status'**
  String get wireguardStatus;

  /// Translation for withoutCredentials
  ///
  /// In en, this message translates to:
  /// **'Without Credentials'**
  String get withoutCredentials;

  /// Success message when WOL packet is sent
  ///
  /// In en, this message translates to:
  /// **'WOL packet sent to {host}'**
  String wolPacketSentTo(String host);

  /// Translation for yes
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// Translation for yesterday
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// Translation for zeroSeconds
  ///
  /// In en, this message translates to:
  /// **'0 seconds'**
  String get zeroSeconds;

  /// Translation for addToList - button to add item to a list
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get addToList;

  /// Translation for allFilterOption - filter option to show all items
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allFilterOption;

  /// Translation for commonNameLabel
  ///
  /// In en, this message translates to:
  /// **'Common Name'**
  String get commonNameLabel;

  /// Translation for connectionBlockingDescription
  ///
  /// In en, this message translates to:
  /// **'Block this client connection based on its common name. Don\'t use this option to permanently disable a client due to a compromised key or password. Use a CRL (certificate revocation list) instead.'**
  String get connectionBlockingDescription;

  /// Translation for deviceLabel
  ///
  /// In en, this message translates to:
  /// **'Device: {type}'**
  String deviceLabel(String type);

  /// Translation for enableThisClientOverride
  ///
  /// In en, this message translates to:
  /// **'Enable this client specific override'**
  String get enableThisClientOverride;

  /// Translation for enterClientX509CommonName
  ///
  /// In en, this message translates to:
  /// **'Enter the client\'s X.509 common name here.'**
  String get enterClientX509CommonName;

  /// Translation for facility
  ///
  /// In en, this message translates to:
  /// **'Facility'**
  String get facility;

  /// Translation for gatewayLabel
  ///
  /// In en, this message translates to:
  /// **'Gateway: {gateway}'**
  String gatewayLabel(String gateway);

  /// Translation for invalidIpAddressMustBeIpv4OrIpv6
  ///
  /// In en, this message translates to:
  /// **'Invalid IP address (must be IPv4 or IPv6)'**
  String get invalidIpAddressMustBeIpv4OrIpv6;

  /// Translation for localLabel
  ///
  /// In en, this message translates to:
  /// **'Local: {address}'**
  String localLabel(String address);

  /// Translation for messageLabel
  ///
  /// In en, this message translates to:
  /// **'Message:'**
  String get messageLabel;

  /// Translation for pageOfTotal
  ///
  /// In en, this message translates to:
  /// **'Page {current} of {total}'**
  String pageOfTotal(int current, int total);

  /// Translation for parser
  ///
  /// In en, this message translates to:
  /// **'Parser'**
  String get parser;

  /// Translation for pidLabel
  ///
  /// In en, this message translates to:
  /// **'PID: {pid}'**
  String pidLabel(String pid);

  /// Translation for processLabel
  ///
  /// In en, this message translates to:
  /// **'Process: {process}'**
  String processLabel(String process);

  /// Translation for pushResetDescription
  ///
  /// In en, this message translates to:
  /// **'Don\'t inherit the global push list for a specific client instance. NOTE: --push-reset is very thorough: it will remove almost all options from the list of to-be-pushed options. In many cases, some of these options will need to be re-configured afterwards - specifically, --topology subnet and --route-gateway will get lost and this will break client configs in many cases.'**
  String get pushResetDescription;

  /// Translation for record
  ///
  /// In en, this message translates to:
  /// **'Record'**
  String get record;

  /// Translation for redirectGatewayDescription
  ///
  /// In en, this message translates to:
  /// **'Automatically execute routing commands to cause all outgoing IP traffic to be redirected over the VPN.'**
  String get redirectGatewayDescription;

  /// Translation for registerDnsDescription
  ///
  /// In en, this message translates to:
  /// **'Run ipconfig /flushdns and ipconfig /registerdns on connection initiation. This is known to kick Windows into recognizing pushed DNS servers.'**
  String get registerDnsDescription;

  /// Translation for remoteLabel
  ///
  /// In en, this message translates to:
  /// **'Remote: {info}'**
  String remoteLabel(String info);

  /// Translation for selectedCount
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String selectedCount(int count);

  /// Translation for serverLabel
  ///
  /// In en, this message translates to:
  /// **'Server: {info}'**
  String serverLabel(String info);

  /// Translation for severityLabel
  ///
  /// In en, this message translates to:
  /// **'Severity: {severity}'**
  String severityLabel(String severity);

  /// Translation for showingEntries
  ///
  /// In en, this message translates to:
  /// **'Showing {start} to {end}'**
  String showingEntries(int start, int end);

  /// Translation for statusLabel
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get statusLabel;

  /// Translation for timestampLabel
  ///
  /// In en, this message translates to:
  /// **'Timestamp: {timestamp}'**
  String timestampLabel(String timestamp);

  /// Translation for typeLabel
  ///
  /// In en, this message translates to:
  /// **'Type: {type}'**
  String typeLabel(String type);

  /// Translation for udp
  ///
  /// In en, this message translates to:
  /// **'UDP'**
  String get udp;

  /// Translation for unknownNetwork
  ///
  /// In en, this message translates to:
  /// **'Unknown Network'**
  String get unknownNetwork;

  /// Translation for youMayEnterDescriptionForReference
  ///
  /// In en, this message translates to:
  /// **'You may enter a description here for your reference (not parsed).'**
  String get youMayEnterDescriptionForReference;
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
