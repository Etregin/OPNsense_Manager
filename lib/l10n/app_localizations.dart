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

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @aboutDescription.
  ///
  /// In en, this message translates to:
  /// **'A professional Flutter mobile application for managing OPNsense firewall routers.'**
  String get aboutDescription;

  /// No description provided for @aboutImportExport.
  ///
  /// In en, this message translates to:
  /// **'About Import & Export'**
  String get aboutImportExport;

  /// No description provided for @acceptDns.
  ///
  /// In en, this message translates to:
  /// **'Accept DNS'**
  String get acceptDns;

  /// No description provided for @acceptDnsDescription.
  ///
  /// In en, this message translates to:
  /// **'Use DNS servers provided by Tailscale'**
  String get acceptDnsDescription;

  /// No description provided for @acceptRoutes.
  ///
  /// In en, this message translates to:
  /// **'Accept Routes'**
  String get acceptRoutes;

  /// No description provided for @acceptSubnetRoutes.
  ///
  /// In en, this message translates to:
  /// **'Accept Subnet Routes'**
  String get acceptSubnetRoutes;

  /// No description provided for @acceptSubnetRoutesDescription.
  ///
  /// In en, this message translates to:
  /// **'Accept routes advertised by other nodes'**
  String get acceptSubnetRoutesDescription;

  /// No description provided for @action.
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

  /// No description provided for @activate.
  ///
  /// In en, this message translates to:
  /// **'Activate'**
  String get activate;

  /// No description provided for @activatedProfile.
  ///
  /// In en, this message translates to:
  /// **'Activated profile: {name}'**
  String activatedProfile(String name);

  /// No description provided for @activatingProfile.
  ///
  /// In en, this message translates to:
  /// **'Activating profile...'**
  String get activatingProfile;

  /// No description provided for @activationFailed.
  ///
  /// In en, this message translates to:
  /// **'Activation failed'**
  String get activationFailed;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @activeDevices.
  ///
  /// In en, this message translates to:
  /// **'Active Devices'**
  String get activeDevices;

  /// No description provided for @activeHosts.
  ///
  /// In en, this message translates to:
  /// **'{count} active host(s)'**
  String activeHosts(int count);

  /// No description provided for @activeProfile.
  ///
  /// In en, this message translates to:
  /// **'Active Profile'**
  String get activeProfile;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @addClientOverride.
  ///
  /// In en, this message translates to:
  /// **'Add Client Override'**
  String get addClientOverride;

  /// No description provided for @addConnection.
  ///
  /// In en, this message translates to:
  /// **'Add Connection'**
  String get addConnection;

  /// No description provided for @addConnectionEndpoint.
  ///
  /// In en, this message translates to:
  /// **'Please add at least one connection endpoint'**
  String get addConnectionEndpoint;

  /// No description provided for @addDnsServer.
  ///
  /// In en, this message translates to:
  /// **'Add DNS Server'**
  String get addDnsServer;

  /// No description provided for @addHost.
  ///
  /// In en, this message translates to:
  /// **'Add Host'**
  String get addHost;

  /// No description provided for @addHostToGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Add a host to get started'**
  String get addHostToGetStarted;

  /// No description provided for @addInstance.
  ///
  /// In en, this message translates to:
  /// **'Add Instance'**
  String get addInstance;

  /// No description provided for @addOpenVpnInstance.
  ///
  /// In en, this message translates to:
  /// **'Add OpenVPN Instance'**
  String get addOpenVpnInstance;

  /// No description provided for @addOverride.
  ///
  /// In en, this message translates to:
  /// **'Add Override'**
  String get addOverride;

  /// No description provided for @addProfile.
  ///
  /// In en, this message translates to:
  /// **'Add Profile'**
  String get addProfile;

  /// No description provided for @addProfileToManageInstances.
  ///
  /// In en, this message translates to:
  /// **'Add a profile to manage OPNsense instances'**
  String get addProfileToManageInstances;

  /// No description provided for @addStaticKey.
  ///
  /// In en, this message translates to:
  /// **'Add Static Key'**
  String get addStaticKey;

  /// No description provided for @addSubnet.
  ///
  /// In en, this message translates to:
  /// **'Add Subnet'**
  String get addSubnet;

  /// No description provided for @addTunnelAddress.
  ///
  /// In en, this message translates to:
  /// **'Add Tunnel Address'**
  String get addTunnelAddress;

  /// No description provided for @additionalInformation.
  ///
  /// In en, this message translates to:
  /// **'Additional Information'**
  String get additionalInformation;

  /// No description provided for @advancedOptions.
  ///
  /// In en, this message translates to:
  /// **'Advanced Options'**
  String get advancedOptions;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @addressIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Address is required'**
  String get addressIsRequired;

  /// No description provided for @advertiseExitNode.
  ///
  /// In en, this message translates to:
  /// **'Advertise Exit Node'**
  String get advertiseExitNode;

  /// No description provided for @advertiseExitNodeDescription.
  ///
  /// In en, this message translates to:
  /// **'Allow other devices to route through this node'**
  String get advertiseExitNodeDescription;

  /// No description provided for @advertiseRoutes.
  ///
  /// In en, this message translates to:
  /// **'Advertise Routes'**
  String get advertiseRoutes;

  /// No description provided for @alert.
  ///
  /// In en, this message translates to:
  /// **'Alert'**
  String get alert;

  /// No description provided for @aliasDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Alias deleted successfully'**
  String get aliasDeletedSuccessfully;

  /// No description provided for @aliasDisabledSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Alias disabled successfully'**
  String get aliasDisabledSuccessfully;

  /// No description provided for @aliasEnabledSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Alias enabled successfully'**
  String get aliasEnabledSuccessfully;

  /// No description provided for @aliases.
  ///
  /// In en, this message translates to:
  /// **'Aliases'**
  String get aliases;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @allConnectionsSuccessful.
  ///
  /// In en, this message translates to:
  /// **'All connections tested successfully'**
  String get allConnectionsSuccessful;

  /// No description provided for @allDetailsCopiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'All details copied to clipboard'**
  String get allDetailsCopiedToClipboard;

  /// No description provided for @allRoles.
  ///
  /// In en, this message translates to:
  /// **'All Roles'**
  String get allRoles;

  /// No description provided for @allSettingsSavedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'All settings saved successfully'**
  String get allSettingsSavedSuccessfully;

  /// No description provided for @allStatus.
  ///
  /// In en, this message translates to:
  /// **'All Status'**
  String get allStatus;

  /// No description provided for @allTypes.
  ///
  /// In en, this message translates to:
  /// **'All Types'**
  String get allTypes;

  /// No description provided for @allVpns.
  ///
  /// In en, this message translates to:
  /// **'All VPNs'**
  String get allVpns;

  /// No description provided for @allowSelfSignedCertificates.
  ///
  /// In en, this message translates to:
  /// **'Allow Self-Signed Certificates'**
  String get allowSelfSignedCertificates;

  /// No description provided for @allowSelfSignedCertificatesDescription.
  ///
  /// In en, this message translates to:
  /// **'Accept self-signed SSL certificates'**
  String get allowSelfSignedCertificatesDescription;

  /// No description provided for @allowedIps.
  ///
  /// In en, this message translates to:
  /// **'Allowed IPs'**
  String get allowedIps;

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

  /// No description provided for @anyPortNumberRangeOrAlias.
  ///
  /// In en, this message translates to:
  /// **'any, port number, range, or alias'**
  String get anyPortNumberRangeOrAlias;

  /// No description provided for @apiError.
  ///
  /// In en, this message translates to:
  /// **'API Error: {message}'**
  String apiError(String message);

  /// No description provided for @apiKey.
  ///
  /// In en, this message translates to:
  /// **'API Key'**
  String get apiKey;

  /// No description provided for @apiKeyIsRequired.
  ///
  /// In en, this message translates to:
  /// **'API Key is required'**
  String get apiKeyIsRequired;

  /// No description provided for @apiSecret.
  ///
  /// In en, this message translates to:
  /// **'API Secret'**
  String get apiSecret;

  /// No description provided for @apiSecretIsRequired.
  ///
  /// In en, this message translates to:
  /// **'API Secret is required'**
  String get apiSecretIsRequired;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @architecture.
  ///
  /// In en, this message translates to:
  /// **'Architecture'**
  String get architecture;

  /// No description provided for @atLeastOneTunnelAddressRequired.
  ///
  /// In en, this message translates to:
  /// **'At least one tunnel address is required'**
  String get atLeastOneTunnelAddressRequired;

  /// No description provided for @authSettingsSavedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Authentication settings saved successfully'**
  String get authSettingsSavedSuccessfully;

  /// No description provided for @authTlsAuthentication.
  ///
  /// In en, this message translates to:
  /// **'Auth (TLS Authentication)'**
  String get authTlsAuthentication;

  /// No description provided for @authTokenGeneratedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Auth token generated successfully'**
  String get authTokenGeneratedSuccessfully;

  /// No description provided for @authenticate.
  ///
  /// In en, this message translates to:
  /// **'Authenticate'**
  String get authenticate;

  /// No description provided for @authenticateToUnlock.
  ///
  /// In en, this message translates to:
  /// **'Authenticate to unlock the app'**
  String get authenticateToUnlock;

  /// No description provided for @authentication.
  ///
  /// In en, this message translates to:
  /// **'Authentication'**
  String get authentication;

  /// No description provided for @authenticationFailed.
  ///
  /// In en, this message translates to:
  /// **'Authentication failed'**
  String get authenticationFailed;

  /// No description provided for @authenticationRequired.
  ///
  /// In en, this message translates to:
  /// **'Authentication Required'**
  String get authenticationRequired;

  /// No description provided for @authenticationSettings.
  ///
  /// In en, this message translates to:
  /// **'Authentication Settings'**
  String get authenticationSettings;

  /// No description provided for @authenticated.
  ///
  /// In en, this message translates to:
  /// **'Authenticated'**
  String get authenticated;

  /// No description provided for @notAuthenticated.
  ///
  /// In en, this message translates to:
  /// **'Not Authenticated'**
  String get notAuthenticated;

  /// No description provided for @tailnet.
  ///
  /// In en, this message translates to:
  /// **'Tailnet'**
  String get tailnet;

  /// No description provided for @deviceName.
  ///
  /// In en, this message translates to:
  /// **'Device Name'**
  String get deviceName;

  /// No description provided for @authUrl.
  ///
  /// In en, this message translates to:
  /// **'Auth URL'**
  String get authUrl;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @authorizedPeers.
  ///
  /// In en, this message translates to:
  /// **'Authorized Peers'**
  String get authorizedPeers;

  /// No description provided for @autoRefresh.
  ///
  /// In en, this message translates to:
  /// **'Auto Refresh'**
  String get autoRefresh;

  /// No description provided for @backendState.
  ///
  /// In en, this message translates to:
  /// **'Backend State'**
  String get backendState;

  /// No description provided for @bandwidthLimit.
  ///
  /// In en, this message translates to:
  /// **'Bandwidth Limit'**
  String get bandwidthLimit;

  /// No description provided for @bandwidthLimitMbps.
  ///
  /// In en, this message translates to:
  /// **'Bandwidth Limit (Mbps)'**
  String get bandwidthLimitMbps;

  /// No description provided for @bandwidthHistory.
  ///
  /// In en, this message translates to:
  /// **'Bandwidth History'**
  String get bandwidthHistory;

  /// No description provided for @base64EncodedPrivateKeyKeepSecret.
  ///
  /// In en, this message translates to:
  /// **'Base64-encoded private key (keep secret!)'**
  String get base64EncodedPrivateKeyKeepSecret;

  /// No description provided for @base64EncodedPublicKey.
  ///
  /// In en, this message translates to:
  /// **'Base64-encoded public key'**
  String get base64EncodedPublicKey;

  /// No description provided for @biometricAuth.
  ///
  /// In en, this message translates to:
  /// **'Biometric Authentication'**
  String get biometricAuth;

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

  /// No description provided for @biometricLockEnabled.
  ///
  /// In en, this message translates to:
  /// **'Biometric lock enabled'**
  String get biometricLockEnabled;

  /// No description provided for @biometricLockTitle.
  ///
  /// In en, this message translates to:
  /// **'{biometricType} Lock'**
  String biometricLockTitle(String biometricType);

  /// No description provided for @biometricNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Biometric authentication is not available on this device'**
  String get biometricNotAvailable;

  /// No description provided for @block.
  ///
  /// In en, this message translates to:
  /// **'Block'**
  String get block;

  /// No description provided for @blockHost.
  ///
  /// In en, this message translates to:
  /// **'Block Host'**
  String get blockHost;

  /// No description provided for @blockHostConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to block {hostname} ({ip})?\n\nThis will create a firewall rule to block all traffic from this host.'**
  String blockHostConfirmation(String hostname, String ip);

  /// No description provided for @blockingHost.
  ///
  /// In en, this message translates to:
  /// **'Blocking host...'**
  String get blockingHost;

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

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @cannotBeUndone.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get cannotBeUndone;

  /// No description provided for @cannotDeleteLastConnection.
  ///
  /// In en, this message translates to:
  /// **'Cannot delete the last connection endpoint'**
  String get cannotDeleteLastConnection;

  /// No description provided for @carpVhidToDepend.
  ///
  /// In en, this message translates to:
  /// **'CARP VHID to depend on'**
  String get carpVhidToDepend;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @changePin.
  ///
  /// In en, this message translates to:
  /// **'Change PIN'**
  String get changePin;

  /// No description provided for @changesDiscarded.
  ///
  /// In en, this message translates to:
  /// **'Changes discarded'**
  String get changesDiscarded;

  /// No description provided for @checkIfWireguardIsConfiguredAndRunning.
  ///
  /// In en, this message translates to:
  /// **'Check if WireGuard is configured and running'**
  String get checkIfWireguardIsConfiguredAndRunning;

  /// No description provided for @chooseExportLocation.
  ///
  /// In en, this message translates to:
  /// **'Choose Export Location'**
  String get chooseExportLocation;

  /// No description provided for @cidrNotationRequired.
  ///
  /// In en, this message translates to:
  /// **'CIDR notation is required'**
  String get cidrNotationRequired;

  /// No description provided for @clearLogs.
  ///
  /// In en, this message translates to:
  /// **'Clear Logs'**
  String get clearLogs;

  /// No description provided for @clearSelection.
  ///
  /// In en, this message translates to:
  /// **'Clear selection'**
  String get clearSelection;

  /// No description provided for @client.
  ///
  /// In en, this message translates to:
  /// **'Client'**
  String get client;

  /// No description provided for @clientAddress.
  ///
  /// In en, this message translates to:
  /// **'Client Address'**
  String get clientAddress;

  /// No description provided for @clientName.
  ///
  /// In en, this message translates to:
  /// **'Client name'**
  String get clientName;

  /// No description provided for @clientOverrides.
  ///
  /// In en, this message translates to:
  /// **'Client Overrides'**
  String get clientOverrides;

  /// No description provided for @clientSettings.
  ///
  /// In en, this message translates to:
  /// **'Client Settings'**
  String get clientSettings;

  /// No description provided for @clientSpecificOverrides.
  ///
  /// In en, this message translates to:
  /// **'Client Specific Overrides'**
  String get clientSpecificOverrides;

  /// No description provided for @clientX509CommonNameHelper.
  ///
  /// In en, this message translates to:
  /// **'Enter the client\'s X.509 common name here.'**
  String get clientX509CommonNameHelper;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @commonName.
  ///
  /// In en, this message translates to:
  /// **'Common name'**
  String get commonName;

  /// No description provided for @commonNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Common name is required'**
  String get commonNameRequired;

  /// No description provided for @commonNameWithValue.
  ///
  /// In en, this message translates to:
  /// **'Common Name: {value}'**
  String commonNameWithValue(String value);

  /// No description provided for @configurationAppliedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Configuration applied successfully'**
  String get configurationAppliedSuccessfully;

  /// No description provided for @configurationPreview.
  ///
  /// In en, this message translates to:
  /// **'Configuration Preview'**
  String get configurationPreview;

  /// No description provided for @configureAdvertisedSubnets.
  ///
  /// In en, this message translates to:
  /// **'Configure advertised subnets'**
  String get configureAdvertisedSubnets;

  /// No description provided for @configured.
  ///
  /// In en, this message translates to:
  /// **'Configured'**
  String get configured;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get confirmDelete;

  /// No description provided for @confirmDeleteInstance.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete instance \"{name}\"? This action cannot be undone.'**
  String confirmDeleteInstance(String name);

  /// No description provided for @confirmDeleteOverride.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete override for \"{name}\"? This action cannot be undone.'**
  String confirmDeleteOverride(String name);

  /// No description provided for @confirmDeleteStaticKey.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete static key \"{name}\"? This action cannot be undone.'**
  String confirmDeleteStaticKey(String name);

  /// No description provided for @confirmNewPin.
  ///
  /// In en, this message translates to:
  /// **'Confirm New PIN'**
  String get confirmNewPin;

  /// No description provided for @confirmPin.
  ///
  /// In en, this message translates to:
  /// **'Confirm PIN'**
  String get confirmPin;

  /// Confirmation message for service action
  ///
  /// In en, this message translates to:
  /// **'{action} \"{name}\"?'**
  String confirmServiceAction(String action, String name);

  /// No description provided for @connect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get connect;

  /// No description provided for @connectToYourOpnsenseFirewall.
  ///
  /// In en, this message translates to:
  /// **'Connect to your OPNsense firewall'**
  String get connectToYourOpnsenseFirewall;

  /// No description provided for @connectVpn.
  ///
  /// In en, this message translates to:
  /// **'Connect VPN'**
  String get connectVpn;

  /// No description provided for @connected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get connected;

  /// No description provided for @connectedSince.
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

  /// No description provided for @connectionBlocking.
  ///
  /// In en, this message translates to:
  /// **'Connection blocking'**
  String get connectionBlocking;

  /// No description provided for @connectionDetails.
  ///
  /// In en, this message translates to:
  /// **'Connection Details'**
  String get connectionDetails;

  /// No description provided for @connectionEndpoints.
  ///
  /// In en, this message translates to:
  /// **'Connection Endpoints'**
  String get connectionEndpoints;

  /// No description provided for @connectionEndpointsHelp.
  ///
  /// In en, this message translates to:
  /// **'Manage multiple connection endpoints for this profile. The app will try each endpoint in order until a successful connection is established.'**
  String get connectionEndpointsHelp;

  /// No description provided for @connectionFailed.
  ///
  /// In en, this message translates to:
  /// **'Connection failed. Check console logs for details.\n\nCommon issues:\n• Device not on same network as OPNsense\n• Wrong IP address or port\n• Firewall blocking connection\n• Invalid API credentials'**
  String get connectionFailed;

  /// No description provided for @connectionFailedError.
  ///
  /// In en, this message translates to:
  /// **'Connection failed: {error}'**
  String connectionFailedError(String error);

  /// No description provided for @connectionInformation.
  ///
  /// In en, this message translates to:
  /// **'Connection Information'**
  String get connectionInformation;

  /// No description provided for @connectionStatus.
  ///
  /// In en, this message translates to:
  /// **'Connection Status'**
  String get connectionStatus;

  /// No description provided for @connectionSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Connection Successful'**
  String get connectionSuccessful;

  /// No description provided for @connectionTestFailed.
  ///
  /// In en, this message translates to:
  /// **'Connection test failed'**
  String get connectionTestFailed;

  /// No description provided for @connectionTestResults.
  ///
  /// In en, this message translates to:
  /// **'Connection Test Results'**
  String get connectionTestResults;

  /// No description provided for @content.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get content;

  /// No description provided for @copiedLogEntries.
  ///
  /// In en, this message translates to:
  /// **'Copied {count} log {count, plural, =1{entry} other{entries}}'**
  String copiedLogEntries(int count);

  /// No description provided for @copiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copiedToClipboard;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @copyAllDetails.
  ///
  /// In en, this message translates to:
  /// **'Copy All Details'**
  String get copyAllDetails;

  /// No description provided for @copyHost.
  ///
  /// In en, this message translates to:
  /// **'Copy Host'**
  String get copyHost;

  /// No description provided for @copyKey.
  ///
  /// In en, this message translates to:
  /// **'Copy key'**
  String get copyKey;

  /// No description provided for @copySelected.
  ///
  /// In en, this message translates to:
  /// **'Copy selected'**
  String get copySelected;

  /// No description provided for @cpuUsage.
  ///
  /// In en, this message translates to:
  /// **'CPU Usage'**
  String get cpuUsage;

  /// No description provided for @createAliasComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Create Alias (Coming Soon)'**
  String get createAliasComingSoon;

  /// No description provided for @createFirstAutomationRule.
  ///
  /// In en, this message translates to:
  /// **'Create your first automation rule to get started'**
  String get createFirstAutomationRule;

  /// No description provided for @createFirstProfile.
  ///
  /// In en, this message translates to:
  /// **'Create your first profile to get started'**
  String get createFirstProfile;

  /// No description provided for @createNewProfile.
  ///
  /// In en, this message translates to:
  /// **'Create New Profile'**
  String get createNewProfile;

  /// No description provided for @createOverride.
  ///
  /// In en, this message translates to:
  /// **'Create Override'**
  String get createOverride;

  /// No description provided for @createPeer.
  ///
  /// In en, this message translates to:
  /// **'Create Peer'**
  String get createPeer;

  /// No description provided for @createRule.
  ///
  /// In en, this message translates to:
  /// **'Create Rule'**
  String get createRule;

  /// No description provided for @createServer.
  ///
  /// In en, this message translates to:
  /// **'Create Server'**
  String get createServer;

  /// No description provided for @createStaticKey.
  ///
  /// In en, this message translates to:
  /// **'Create Static Key'**
  String get createStaticKey;

  /// No description provided for @createYourFirstProfile.
  ///
  /// In en, this message translates to:
  /// **'Create your first OPNsense profile to get started'**
  String get createYourFirstProfile;

  /// No description provided for @created.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get created;

  /// No description provided for @critical.
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get critical;

  /// No description provided for @cryptTlsEncryption.
  ///
  /// In en, this message translates to:
  /// **'Crypt (TLS Encryption)'**
  String get cryptTlsEncryption;

  /// No description provided for @cryptV2TlsEncryption.
  ///
  /// In en, this message translates to:
  /// **'Crypt V2 (TLS Encryption)'**
  String get cryptV2TlsEncryption;

  /// No description provided for @currentPin.
  ///
  /// In en, this message translates to:
  /// **'Current PIN'**
  String get currentPin;

  /// No description provided for @currentPinIncorrect.
  ///
  /// In en, this message translates to:
  /// **'Current PIN is incorrect'**
  String get currentPinIncorrect;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'day'**
  String get day;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get days;

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{days}d ago'**
  String daysAgo(int days);

  /// No description provided for @debug.
  ///
  /// In en, this message translates to:
  /// **'Debug'**
  String get debug;

  /// No description provided for @defineRoleOfInstance.
  ///
  /// In en, this message translates to:
  /// **'Define the role of this instance'**
  String get defineRoleOfInstance;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Confirmation message when deleting an alias
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the alias \"{aliasName}\"?'**
  String deleteAliasConfirmation(String aliasName);

  /// No description provided for @deleteConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this item?'**
  String get deleteConfirmation;

  /// No description provided for @deleteConnection.
  ///
  /// In en, this message translates to:
  /// **'Delete Connection'**
  String get deleteConnection;

  /// Confirmation message when deleting a connection endpoint
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the connection \"{connectionName}\"?'**
  String deleteConnectionConfirmation(String connectionName);

  /// No description provided for @deleteHost.
  ///
  /// In en, this message translates to:
  /// **'Delete Host'**
  String get deleteHost;

  /// Confirmation message when deleting a WOL host
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{host}\"?'**
  String deleteHostConfirmation(String host);

  /// No description provided for @deleteInstance.
  ///
  /// In en, this message translates to:
  /// **'Delete Instance'**
  String get deleteInstance;

  /// No description provided for @deleteOverride.
  ///
  /// In en, this message translates to:
  /// **'Delete Override'**
  String get deleteOverride;

  /// No description provided for @deletePeer.
  ///
  /// In en, this message translates to:
  /// **'Delete Peer'**
  String get deletePeer;

  /// No description provided for @deletePeerConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete peer \"{name}\"?'**
  String deletePeerConfirmation(String name);

  /// No description provided for @deleteProfile.
  ///
  /// In en, this message translates to:
  /// **'Delete Profile'**
  String get deleteProfile;

  /// No description provided for @deleteProfileConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"?'**
  String deleteProfileConfirmation(String name);

  /// No description provided for @deleteRule.
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

  /// No description provided for @deleteStaticKey.
  ///
  /// In en, this message translates to:
  /// **'Delete Static Key'**
  String get deleteStaticKey;

  /// No description provided for @deleteSubnet.
  ///
  /// In en, this message translates to:
  /// **'Delete Subnet'**
  String get deleteSubnet;

  /// No description provided for @deleteSubnetConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete subnet {subnet}?'**
  String deleteSubnetConfirmation(String subnet);

  /// No description provided for @demo.
  ///
  /// In en, this message translates to:
  /// **'Demo'**
  String get demo;

  /// No description provided for @dependOnCarp.
  ///
  /// In en, this message translates to:
  /// **'Depend on (CARP)'**
  String get dependOnCarp;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @descriptionHelperText.
  ///
  /// In en, this message translates to:
  /// **'A brief description of this instance'**
  String get descriptionHelperText;

  /// No description provided for @descriptionHelperTextOverride.
  ///
  /// In en, this message translates to:
  /// **'You may enter a description here for your reference (not parsed).'**
  String get descriptionHelperTextOverride;

  /// No description provided for @descriptionHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Living Room PC'**
  String get descriptionHint;

  /// No description provided for @descriptionOptional.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get descriptionOptional;

  /// No description provided for @descriptionRequired.
  ///
  /// In en, this message translates to:
  /// **'Description is required'**
  String get descriptionRequired;

  /// No description provided for @destination.
  ///
  /// In en, this message translates to:
  /// **'Destination'**
  String get destination;

  /// No description provided for @destinationAddress.
  ///
  /// In en, this message translates to:
  /// **'Destination Address'**
  String get destinationAddress;

  /// No description provided for @destinationIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Destination is required'**
  String get destinationIsRequired;

  /// No description provided for @destinationPort.
  ///
  /// In en, this message translates to:
  /// **'Destination Port'**
  String get destinationPort;

  /// No description provided for @destinationPortOptional.
  ///
  /// In en, this message translates to:
  /// **'Destination Port (Optional)'**
  String get destinationPortOptional;

  /// No description provided for @deviceType.
  ///
  /// In en, this message translates to:
  /// **'Device Type'**
  String get deviceType;

  /// No description provided for @dhcpLeases.
  ///
  /// In en, this message translates to:
  /// **'DHCP Leases'**
  String get dhcpLeases;

  /// Label for DHCP server type
  ///
  /// In en, this message translates to:
  /// **'{serverName} Server'**
  String dhcpServerLabel(String serverName);

  /// No description provided for @dhcpServerType.
  ///
  /// In en, this message translates to:
  /// **'DHCP Server Type'**
  String get dhcpServerType;

  /// No description provided for @direction.
  ///
  /// In en, this message translates to:
  /// **'Direction'**
  String get direction;

  /// No description provided for @directionBoth.
  ///
  /// In en, this message translates to:
  /// **'Both'**
  String get directionBoth;

  /// No description provided for @directionIn.
  ///
  /// In en, this message translates to:
  /// **'In'**
  String get directionIn;

  /// No description provided for @directionOut.
  ///
  /// In en, this message translates to:
  /// **'Out'**
  String get directionOut;

  /// No description provided for @disable.
  ///
  /// In en, this message translates to:
  /// **'Disable'**
  String get disable;

  /// No description provided for @disableAutoScroll.
  ///
  /// In en, this message translates to:
  /// **'Disable Auto-scroll'**
  String get disableAutoScroll;

  /// No description provided for @disableRoutes.
  ///
  /// In en, this message translates to:
  /// **'Disable Routes'**
  String get disableRoutes;

  /// No description provided for @disableRoutesDescription.
  ///
  /// In en, this message translates to:
  /// **'Prevent automatic route installation'**
  String get disableRoutesDescription;

  /// No description provided for @disableRule.
  ///
  /// In en, this message translates to:
  /// **'Disable Rule'**
  String get disableRule;

  /// No description provided for @disableSnat.
  ///
  /// In en, this message translates to:
  /// **'Disable SNAT'**
  String get disableSnat;

  /// No description provided for @disableSnatDescription.
  ///
  /// In en, this message translates to:
  /// **'Disable source NAT for subnet routes'**
  String get disableSnatDescription;

  /// No description provided for @disabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get disabled;

  /// No description provided for @disablingRule.
  ///
  /// In en, this message translates to:
  /// **'Disabling rule...'**
  String get disablingRule;

  /// No description provided for @discard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get discard;

  /// No description provided for @disconnect.
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get disconnect;

  /// No description provided for @disconnectVpn.
  ///
  /// In en, this message translates to:
  /// **'Disconnect VPN'**
  String get disconnectVpn;

  /// No description provided for @disconnected.
  ///
  /// In en, this message translates to:
  /// **'Disconnected'**
  String get disconnected;

  /// No description provided for @disconnectingVPN.
  ///
  /// In en, this message translates to:
  /// **'Disconnecting {name}...'**
  String disconnectingVPN(String name);

  /// No description provided for @diskUsage.
  ///
  /// In en, this message translates to:
  /// **'Disk Usage'**
  String get diskUsage;

  /// No description provided for @dnsDomainList.
  ///
  /// In en, this message translates to:
  /// **'DNS Domain List'**
  String get dnsDomainList;

  /// No description provided for @dnsDomainListHelperText.
  ///
  /// In en, this message translates to:
  /// **'Set Connection-specific DNS Suffixes.'**
  String get dnsDomainListHelperText;

  /// No description provided for @dnsDomainSearchList.
  ///
  /// In en, this message translates to:
  /// **'DNS Domain Search List'**
  String get dnsDomainSearchList;

  /// No description provided for @dnsDomainSearchListHelperText.
  ///
  /// In en, this message translates to:
  /// **'Add name to the domain search list. Repeat this option to add more entries. Up to 10 domains are supported.'**
  String get dnsDomainSearchListHelperText;

  /// No description provided for @dnsEnabled.
  ///
  /// In en, this message translates to:
  /// **'DNS Enabled'**
  String get dnsEnabled;

  /// No description provided for @dnsServerIp.
  ///
  /// In en, this message translates to:
  /// **'DNS Server IP'**
  String get dnsServerIp;

  /// No description provided for @dnsServerIsRequired.
  ///
  /// In en, this message translates to:
  /// **'DNS server is required'**
  String get dnsServerIsRequired;

  /// No description provided for @dnsServerOptional.
  ///
  /// In en, this message translates to:
  /// **'DNS Server (Optional)'**
  String get dnsServerOptional;

  /// No description provided for @dnsServers.
  ///
  /// In en, this message translates to:
  /// **'DNS Servers'**
  String get dnsServers;

  /// No description provided for @dnsServersHelperText.
  ///
  /// In en, this message translates to:
  /// **'Set primary domain name server IPv4 or IPv6 address. Repeat this option to set secondary DNS server addresses.'**
  String get dnsServersHelperText;

  /// No description provided for @dnsServersOptional.
  ///
  /// In en, this message translates to:
  /// **'DNS Servers (Optional)'**
  String get dnsServersOptional;

  /// No description provided for @dnsmasqDescription.
  ///
  /// In en, this message translates to:
  /// **'Lightweight DNS and DHCP server'**
  String get dnsmasqDescription;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @dynamicLease.
  ///
  /// In en, this message translates to:
  /// **'Dynamic'**
  String get dynamicLease;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @editClientOverride.
  ///
  /// In en, this message translates to:
  /// **'Edit Client Override'**
  String get editClientOverride;

  /// No description provided for @editConnection.
  ///
  /// In en, this message translates to:
  /// **'Edit Connection'**
  String get editConnection;

  /// No description provided for @editHost.
  ///
  /// In en, this message translates to:
  /// **'Edit Host'**
  String get editHost;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @editRule.
  ///
  /// In en, this message translates to:
  /// **'Edit Rule'**
  String get editRule;

  /// No description provided for @editStaticKey.
  ///
  /// In en, this message translates to:
  /// **'Edit Static Key'**
  String get editStaticKey;

  /// No description provided for @editSubnet.
  ///
  /// In en, this message translates to:
  /// **'Edit Subnet'**
  String get editSubnet;

  /// No description provided for @editWireguardPeer.
  ///
  /// In en, this message translates to:
  /// **'Edit WireGuard Peer'**
  String get editWireguardPeer;

  /// No description provided for @editWireguardServer.
  ///
  /// In en, this message translates to:
  /// **'Edit WireGuard Server'**
  String get editWireguardServer;

  /// No description provided for @emergency.
  ///
  /// In en, this message translates to:
  /// **'Emergency'**
  String get emergency;

  /// No description provided for @enable.
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get enable;

  /// No description provided for @enableAutoScroll.
  ///
  /// In en, this message translates to:
  /// **'Enable Auto-scroll'**
  String get enableAutoScroll;

  /// No description provided for @enableClientSpecificOverride.
  ///
  /// In en, this message translates to:
  /// **'Enable this client specific override'**
  String get enableClientSpecificOverride;

  /// No description provided for @enableDebugLogging.
  ///
  /// In en, this message translates to:
  /// **'Enable debug logging'**
  String get enableDebugLogging;

  /// No description provided for @enablePinLockFirstBiometric.
  ///
  /// In en, this message translates to:
  /// **'Enable PIN lock first to use biometric'**
  String get enablePinLockFirstBiometric;

  /// No description provided for @enableRule.
  ///
  /// In en, this message translates to:
  /// **'Enable Rule'**
  String get enableRule;

  /// No description provided for @enableSsh.
  ///
  /// In en, this message translates to:
  /// **'Enable SSH'**
  String get enableSsh;

  /// No description provided for @enableSshDescription.
  ///
  /// In en, this message translates to:
  /// **'Allow SSH access through Tailscale'**
  String get enableSshDescription;

  /// No description provided for @enableTailscale.
  ///
  /// In en, this message translates to:
  /// **'Enable Tailscale'**
  String get enableTailscale;

  /// No description provided for @enableTailscaleDescription.
  ///
  /// In en, this message translates to:
  /// **'Enable or disable the Tailscale service'**
  String get enableTailscaleDescription;

  /// No description provided for @enableWireguard.
  ///
  /// In en, this message translates to:
  /// **'Enable WireGuard'**
  String get enableWireguard;

  /// No description provided for @enabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get enabled;

  /// No description provided for @enablingRule.
  ///
  /// In en, this message translates to:
  /// **'Enabling rule...'**
  String get enablingRule;

  /// No description provided for @endTime.
  ///
  /// In en, this message translates to:
  /// **'End Time'**
  String get endTime;

  /// No description provided for @endpoint.
  ///
  /// In en, this message translates to:
  /// **'Endpoint'**
  String get endpoint;

  /// No description provided for @endpointAddress.
  ///
  /// In en, this message translates to:
  /// **'Endpoint Address'**
  String get endpointAddress;

  /// No description provided for @endpointPort.
  ///
  /// In en, this message translates to:
  /// **'Endpoint Port'**
  String get endpointPort;

  /// No description provided for @enterBandwidthLimit.
  ///
  /// In en, this message translates to:
  /// **'Enter your connection bandwidth limit in Mbps'**
  String get enterBandwidthLimit;

  /// No description provided for @enterClientCertificateCommonName.
  ///
  /// In en, this message translates to:
  /// **'Enter client certificate common name'**
  String get enterClientCertificateCommonName;

  /// No description provided for @enterDescriptionForOverride.
  ///
  /// In en, this message translates to:
  /// **'Enter a description for this override'**
  String get enterDescriptionForOverride;

  /// No description provided for @enterOrGeneratePresharedKey.
  ///
  /// In en, this message translates to:
  /// **'Enter or generate pre-shared key'**
  String get enterOrGeneratePresharedKey;

  /// No description provided for @enterOrGeneratePrivateKey.
  ///
  /// In en, this message translates to:
  /// **'Enter or generate private key'**
  String get enterOrGeneratePrivateKey;

  /// No description provided for @enterOrGeneratePublicKey.
  ///
  /// In en, this message translates to:
  /// **'Enter or generate public key'**
  String get enterOrGeneratePublicKey;

  /// No description provided for @enterPin.
  ///
  /// In en, this message translates to:
  /// **'Enter PIN'**
  String get enterPin;

  /// No description provided for @enterPinLabel.
  ///
  /// In en, this message translates to:
  /// **'Enter PIN (4-6 digits)'**
  String get enterPinLabel;

  /// No description provided for @enterRuleDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter rule description'**
  String get enterRuleDescription;

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

  /// No description provided for @entries.
  ///
  /// In en, this message translates to:
  /// **'entries'**
  String get entries;

  /// No description provided for @entriesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} entries'**
  String entriesCount(int count);

  /// No description provided for @error.
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

  /// No description provided for @errorLoadingData.
  ///
  /// In en, this message translates to:
  /// **'Error loading data'**
  String get errorLoadingData;

  /// No description provided for @errorLoadingInstance.
  ///
  /// In en, this message translates to:
  /// **'Error loading instance'**
  String get errorLoadingInstance;

  /// No description provided for @errorLoadingLogs.
  ///
  /// In en, this message translates to:
  /// **'Error loading logs'**
  String get errorLoadingLogs;

  /// No description provided for @errorLoadingOverride.
  ///
  /// In en, this message translates to:
  /// **'Error loading override'**
  String get errorLoadingOverride;

  /// No description provided for @errorLoadingRoutes.
  ///
  /// In en, this message translates to:
  /// **'Error loading routes'**
  String get errorLoadingRoutes;

  /// No description provided for @errorLoadingRules.
  ///
  /// In en, this message translates to:
  /// **'Error loading rules'**
  String get errorLoadingRules;

  /// No description provided for @errorLoadingSessions.
  ///
  /// In en, this message translates to:
  /// **'Error loading sessions'**
  String get errorLoadingSessions;

  /// No description provided for @errorLoadingSystemInfo.
  ///
  /// In en, this message translates to:
  /// **'Error loading system information'**
  String get errorLoadingSystemInfo;

  /// No description provided for @errorLoadingVpnConnections.
  ///
  /// In en, this message translates to:
  /// **'Error loading VPN connections'**
  String get errorLoadingVpnConnections;

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

  /// No description provided for @exampleCidr.
  ///
  /// In en, this message translates to:
  /// **'Example: 10.10.10.2/24 or fd00::2/64'**
  String get exampleCidr;

  /// No description provided for @exampleTunnelAddress.
  ///
  /// In en, this message translates to:
  /// **'Example: 10.10.10.1/24 or fd00::1/64'**
  String get exampleTunnelAddress;

  /// No description provided for @examplesAnyIpCidr.
  ///
  /// In en, this message translates to:
  /// **'Examples: any, 192.168.1.0/24, 10.0.0.1'**
  String get examplesAnyIpCidr;

  /// No description provided for @examplesAnyPortRange.
  ///
  /// In en, this message translates to:
  /// **'Examples: any, 80, 1024-65535'**
  String get examplesAnyPortRange;

  /// No description provided for @examplesAnyPortRangeHttp.
  ///
  /// In en, this message translates to:
  /// **'Examples: any, 80, 80-443, http'**
  String get examplesAnyPortRangeHttp;

  /// No description provided for @exitNode.
  ///
  /// In en, this message translates to:
  /// **'Exit Node'**
  String get exitNode;

  /// No description provided for @expired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get expired;

  /// No description provided for @expires.
  ///
  /// In en, this message translates to:
  /// **'Expires'**
  String get expires;

  /// No description provided for @expiryTime.
  ///
  /// In en, this message translates to:
  /// **'Expiry Time'**
  String get expiryTime;

  /// No description provided for @export.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get export;

  /// No description provided for @exportAllProfiles.
  ///
  /// In en, this message translates to:
  /// **'Export All Profiles'**
  String get exportAllProfiles;

  /// No description provided for @exportAllProfilesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Export all profiles to a JSON file'**
  String get exportAllProfilesSubtitle;

  /// No description provided for @exportCredentialsWarning.
  ///
  /// In en, this message translates to:
  /// **'Exporting with credentials will save API keys and secrets in plain text. Only do this if you will store the file securely.'**
  String get exportCredentialsWarning;

  /// No description provided for @exportFailed.
  ///
  /// In en, this message translates to:
  /// **'Export failed'**
  String get exportFailed;

  /// No description provided for @exportFailedError.
  ///
  /// In en, this message translates to:
  /// **'Export failed: {error}'**
  String exportFailedError(String error);

  /// No description provided for @exportLogs.
  ///
  /// In en, this message translates to:
  /// **'Export Logs'**
  String get exportLogs;

  /// No description provided for @exportProfiles.
  ///
  /// In en, this message translates to:
  /// **'Export Profiles'**
  String get exportProfiles;

  /// No description provided for @exportProfilesContent.
  ///
  /// In en, this message translates to:
  /// **'Do you want to include API credentials in the export?\n\nWARNING: Including credentials will store API keys and secrets in plain text. Only include credentials if you will store the file securely.'**
  String get exportProfilesContent;

  /// No description provided for @exportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Export successful'**
  String get exportSuccess;

  /// No description provided for @exportThisProfile.
  ///
  /// In en, this message translates to:
  /// **'Export This Profile'**
  String get exportThisProfile;

  /// No description provided for @failedDevices.
  ///
  /// In en, this message translates to:
  /// **'Failed Devices'**
  String get failedDevices;

  /// No description provided for @failedToActionTailscaleService.
  ///
  /// In en, this message translates to:
  /// **'Failed to {action} Tailscale service'**
  String failedToActionTailscaleService(String action);

  /// No description provided for @failedToApplyConfiguration.
  ///
  /// In en, this message translates to:
  /// **'Failed to apply configuration'**
  String get failedToApplyConfiguration;

  /// No description provided for @failedToSwitchProfile.
  ///
  /// In en, this message translates to:
  /// **'Failed to switch profile: {error}'**
  String failedToSwitchProfile(String error);

  /// No description provided for @failedToBlockHost.
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

  /// No description provided for @failedToDeleteProfile.
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

  /// No description provided for @failedToLoadOpenvpnLogs.
  ///
  /// In en, this message translates to:
  /// **'Failed to load OpenVPN logs'**
  String get failedToLoadOpenvpnLogs;

  /// No description provided for @failedToRestartService.
  ///
  /// In en, this message translates to:
  /// **'Failed to restart {type} service'**
  String failedToRestartService(String type);

  /// No description provided for @failedToSaveAuthSettings.
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

  /// No description provided for @failedToSavePeer.
  ///
  /// In en, this message translates to:
  /// **'Failed to save peer'**
  String get failedToSavePeer;

  /// No description provided for @failedToSaveProfile.
  ///
  /// In en, this message translates to:
  /// **'Failed to save profile'**
  String get failedToSaveProfile;

  /// No description provided for @failedToSaveServer.
  ///
  /// In en, this message translates to:
  /// **'Failed to save server'**
  String get failedToSaveServer;

  /// No description provided for @failedToSaveSettings.
  ///
  /// In en, this message translates to:
  /// **'Failed to save settings'**
  String get failedToSaveSettings;

  /// No description provided for @failedToSaveStaticKey.
  ///
  /// In en, this message translates to:
  /// **'Failed to save static key: {error}'**
  String failedToSaveStaticKey(String error);

  /// No description provided for @failedToStartService.
  ///
  /// In en, this message translates to:
  /// **'Failed to start service'**
  String get failedToStartService;

  /// No description provided for @failedToStopService.
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

  /// No description provided for @featuresList.
  ///
  /// In en, this message translates to:
  /// **'• System monitoring and management\n• Firewall rule configuration\n• Service control\n• Real-time logs\n• Multi-profile support\n• Secure authentication'**
  String get featuresList;

  /// No description provided for @featuresTitle.
  ///
  /// In en, this message translates to:
  /// **'Features'**
  String get featuresTitle;

  /// No description provided for @fieldIsRequired.
  ///
  /// In en, this message translates to:
  /// **'{fieldName} is required'**
  String fieldIsRequired(String fieldName);

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get fieldRequired;

  /// No description provided for @fifteenMin.
  ///
  /// In en, this message translates to:
  /// **'15 min'**
  String get fifteenMin;

  /// No description provided for @filterByAction.
  ///
  /// In en, this message translates to:
  /// **'Filter by Action'**
  String get filterByAction;

  /// No description provided for @filterByType.
  ///
  /// In en, this message translates to:
  /// **'Filter by type'**
  String get filterByType;

  /// No description provided for @filterLabel.
  ///
  /// In en, this message translates to:
  /// **'Filter: '**
  String get filterLabel;

  /// No description provided for @filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// No description provided for @firewall.
  ///
  /// In en, this message translates to:
  /// **'Firewall'**
  String get firewall;

  /// No description provided for @firewallAliases.
  ///
  /// In en, this message translates to:
  /// **'Firewall Aliases'**
  String get firewallAliases;

  /// No description provided for @firewallLogs.
  ///
  /// In en, this message translates to:
  /// **'Firewall Logs'**
  String get firewallLogs;

  /// No description provided for @firewallRuleDetails.
  ///
  /// In en, this message translates to:
  /// **'Firewall Rule Details'**
  String get firewallRuleDetails;

  /// No description provided for @firewallRules.
  ///
  /// In en, this message translates to:
  /// **'Firewall Rules'**
  String get firewallRules;

  /// No description provided for @firmwareDetails.
  ///
  /// In en, this message translates to:
  /// **'Firmware Details'**
  String get firmwareDetails;

  /// No description provided for @fiveMin.
  ///
  /// In en, this message translates to:
  /// **'5 min'**
  String get fiveMin;

  /// No description provided for @fixFormErrors.
  ///
  /// In en, this message translates to:
  /// **'Please fix the errors in the form'**
  String get fixFormErrors;

  /// No description provided for @forbidden.
  ///
  /// In en, this message translates to:
  /// **'Access forbidden'**
  String get forbidden;

  /// No description provided for @gateway.
  ///
  /// In en, this message translates to:
  /// **'Gateway'**
  String get gateway;

  /// No description provided for @gatewayOptional.
  ///
  /// In en, this message translates to:
  /// **'Gateway (Optional)'**
  String get gatewayOptional;

  /// No description provided for @gateways.
  ///
  /// In en, this message translates to:
  /// **'Gateways'**
  String get gateways;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @generalSettings.
  ///
  /// In en, this message translates to:
  /// **'General Settings'**
  String get generalSettings;

  /// No description provided for @generateKey.
  ///
  /// In en, this message translates to:
  /// **'Generate Key'**
  String get generateKey;

  /// No description provided for @generateKeyPair.
  ///
  /// In en, this message translates to:
  /// **'Generate Key Pair'**
  String get generateKeyPair;

  /// No description provided for @generateNewKeyPair.
  ///
  /// In en, this message translates to:
  /// **'Generate New Key Pair'**
  String get generateNewKeyPair;

  /// No description provided for @generateOrPasteKeyHere.
  ///
  /// In en, this message translates to:
  /// **'Generate or paste key here'**
  String get generateOrPasteKeyHere;

  /// No description provided for @generatePresharedKey.
  ///
  /// In en, this message translates to:
  /// **'Generate pre-shared key'**
  String get generatePresharedKey;

  /// No description provided for @generated.
  ///
  /// In en, this message translates to:
  /// **'Generated'**
  String get generated;

  /// No description provided for @generating.
  ///
  /// In en, this message translates to:
  /// **'Generating...'**
  String get generating;

  /// No description provided for @gitCommit.
  ///
  /// In en, this message translates to:
  /// **'Git Commit'**
  String get gitCommit;

  /// No description provided for @healthStatus.
  ///
  /// In en, this message translates to:
  /// **'Health Status'**
  String get healthStatus;

  /// No description provided for @hideControls.
  ///
  /// In en, this message translates to:
  /// **'Hide Controls'**
  String get hideControls;

  /// No description provided for @hideKey.
  ///
  /// In en, this message translates to:
  /// **'Hide key'**
  String get hideKey;

  /// No description provided for @historySize.
  ///
  /// In en, this message translates to:
  /// **'History Size'**
  String get historySize;

  /// No description provided for @host.
  ///
  /// In en, this message translates to:
  /// **'Host'**
  String get host;

  /// No description provided for @hostAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Host added successfully'**
  String get hostAddedSuccessfully;

  /// No description provided for @hostBlocked.
  ///
  /// In en, this message translates to:
  /// **'Host blocked successfully'**
  String get hostBlocked;

  /// No description provided for @hostDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Host deleted successfully'**
  String get hostDeletedSuccessfully;

  /// No description provided for @hostHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., 192.168.1.1 or firewall.example.com'**
  String get hostHint;

  /// No description provided for @hostIpAddress.
  ///
  /// In en, this message translates to:
  /// **'Host / IP Address'**
  String get hostIpAddress;

  /// No description provided for @hostIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Host is required'**
  String get hostIsRequired;

  /// No description provided for @hostPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'192.168.1.1 or firewall.example.com'**
  String get hostPlaceholder;

  /// No description provided for @hostUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Host updated successfully'**
  String get hostUpdatedSuccessfully;

  /// No description provided for @hostname.
  ///
  /// In en, this message translates to:
  /// **'Hostname'**
  String get hostname;

  /// No description provided for @hour.
  ///
  /// In en, this message translates to:
  /// **'hour'**
  String get hour;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'hours'**
  String get hours;

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{hours}h ago'**
  String hoursAgo(int hours);

  /// No description provided for @id.
  ///
  /// In en, this message translates to:
  /// **'ID'**
  String get id;

  /// No description provided for @import.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get import;

  /// No description provided for @importAndExport.
  ///
  /// In en, this message translates to:
  /// **'Import & Export'**
  String get importAndExport;

  /// No description provided for @importExportDescription.
  ///
  /// In en, this message translates to:
  /// **'Export your profiles to back them up or transfer them to another device. Import profiles from a previously exported file.\n\nProfiles are saved in JSON format and can include connection endpoints and settings.'**
  String get importExportDescription;

  /// No description provided for @importFailed.
  ///
  /// In en, this message translates to:
  /// **'Import failed: {error}'**
  String importFailed(String error);

  /// No description provided for @importProfiles.
  ///
  /// In en, this message translates to:
  /// **'Import Profiles'**
  String get importProfiles;

  /// No description provided for @importProfilesDialog.
  ///
  /// In en, this message translates to:
  /// **'How should existing profiles be handled?\n\n• Keep Both: Import with new IDs\n• Overwrite: Replace existing profiles'**
  String get importProfilesDialog;

  /// No description provided for @importProfilesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Import profiles from a JSON file'**
  String get importProfilesSubtitle;

  /// No description provided for @importSuccess.
  ///
  /// In en, this message translates to:
  /// **'Import successful'**
  String get importSuccess;

  /// No description provided for @importedWithFailures.
  ///
  /// In en, this message translates to:
  /// **'Imported {success} profile{success, plural, =1{} other{s}}, {failed} failed'**
  String importedWithFailures(int failed, int success);

  /// Time remaining in days
  ///
  /// In en, this message translates to:
  /// **'in {days}d'**
  String inDays(int days);

  /// Time remaining in hours
  ///
  /// In en, this message translates to:
  /// **'in {hours}h'**
  String inHours(int hours);

  /// Time remaining in minutes
  ///
  /// In en, this message translates to:
  /// **'in {minutes}m'**
  String inMinutes(int minutes);

  /// No description provided for @inbound.
  ///
  /// In en, this message translates to:
  /// **'Inbound'**
  String get inbound;

  /// No description provided for @includeCredentials.
  ///
  /// In en, this message translates to:
  /// **'Include Credentials'**
  String get includeCredentials;

  /// No description provided for @incorrectPin.
  ///
  /// In en, this message translates to:
  /// **'Incorrect PIN'**
  String get incorrectPin;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get info;

  /// No description provided for @instance.
  ///
  /// In en, this message translates to:
  /// **'Instance'**
  String get instance;

  /// No description provided for @instanceCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Instance created successfully'**
  String get instanceCreatedSuccessfully;

  /// No description provided for @instanceDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Instance deleted successfully'**
  String get instanceDeletedSuccessfully;

  /// No description provided for @instanceDetails.
  ///
  /// In en, this message translates to:
  /// **'Instance Details'**
  String get instanceDetails;

  /// No description provided for @instanceToggledSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Instance {status} successfully'**
  String instanceToggledSuccessfully(String status);

  /// No description provided for @instanceUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Instance updated successfully'**
  String get instanceUpdatedSuccessfully;

  /// No description provided for @instanceWillBeActiveWhenEnabled.
  ///
  /// In en, this message translates to:
  /// **'Instance will be active when enabled'**
  String get instanceWillBeActiveWhenEnabled;

  /// No description provided for @instances.
  ///
  /// In en, this message translates to:
  /// **'Instances'**
  String get instances;

  /// No description provided for @interface.
  ///
  /// In en, this message translates to:
  /// **'Interface'**
  String get interface;

  /// No description provided for @invalidApiKeyFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid API Key format'**
  String get invalidApiKeyFormat;

  /// No description provided for @invalidApiSecretFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid API Secret format'**
  String get invalidApiSecretFormat;

  /// No description provided for @invalidBase64Format.
  ///
  /// In en, this message translates to:
  /// **'Invalid Base64 format'**
  String get invalidBase64Format;

  /// No description provided for @invalidCidrNotation.
  ///
  /// In en, this message translates to:
  /// **'Invalid CIDR notation (use format: IP/prefix)'**
  String get invalidCidrNotation;

  /// No description provided for @invalidDestinationFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid destination format'**
  String get invalidDestinationFormat;

  /// No description provided for @invalidFileFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid file: {error}'**
  String invalidFileFormat(String error);

  /// No description provided for @invalidHostnameOrIp.
  ///
  /// In en, this message translates to:
  /// **'Invalid hostname or IP address'**
  String get invalidHostnameOrIp;

  /// No description provided for @invalidInput.
  ///
  /// In en, this message translates to:
  /// **'Invalid input'**
  String get invalidInput;

  /// No description provided for @invalidIpAddress.
  ///
  /// In en, this message translates to:
  /// **'Invalid IP address'**
  String get invalidIpAddress;

  /// No description provided for @invalidIpAddressFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid IP address (must be IPv4 or IPv6)'**
  String get invalidIpAddressFormat;

  /// No description provided for @invalidIpv4Address.
  ///
  /// In en, this message translates to:
  /// **'Invalid IPv4 address'**
  String get invalidIpv4Address;

  /// No description provided for @invalidIpv4CidrNotation.
  ///
  /// In en, this message translates to:
  /// **'Invalid IPv4 CIDR notation'**
  String get invalidIpv4CidrNotation;

  /// No description provided for @invalidIpv4Prefix.
  ///
  /// In en, this message translates to:
  /// **'Invalid IPv4 prefix (must be 0-32)'**
  String get invalidIpv4Prefix;

  /// No description provided for @invalidIpv6Address.
  ///
  /// In en, this message translates to:
  /// **'Invalid IPv6 address'**
  String get invalidIpv6Address;

  /// No description provided for @invalidIpv6CidrNotation.
  ///
  /// In en, this message translates to:
  /// **'Invalid IPv6 CIDR notation'**
  String get invalidIpv6CidrNotation;

  /// No description provided for @invalidIpv6Prefix.
  ///
  /// In en, this message translates to:
  /// **'Invalid IPv6 prefix (must be 0-128)'**
  String get invalidIpv6Prefix;

  /// No description provided for @invalidPin.
  ///
  /// In en, this message translates to:
  /// **'Invalid PIN'**
  String get invalidPin;

  /// No description provided for @invalidPortFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid port format'**
  String get invalidPortFormat;

  /// No description provided for @invalidPrefixLength.
  ///
  /// In en, this message translates to:
  /// **'Invalid prefix length'**
  String get invalidPrefixLength;

  /// No description provided for @invalidSourceFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid source format'**
  String get invalidSourceFormat;

  /// No description provided for @invertDestination.
  ///
  /// In en, this message translates to:
  /// **'Invert destination (NOT)'**
  String get invertDestination;

  /// No description provided for @invertDestinationTooltip.
  ///
  /// In en, this message translates to:
  /// **'Match any address EXCEPT the destination'**
  String get invertDestinationTooltip;

  /// No description provided for @invertSource.
  ///
  /// In en, this message translates to:
  /// **'Invert source (NOT)'**
  String get invertSource;

  /// No description provided for @invertSourceTooltip.
  ///
  /// In en, this message translates to:
  /// **'Match any address EXCEPT the source'**
  String get invertSourceTooltip;

  /// No description provided for @ipAddress.
  ///
  /// In en, this message translates to:
  /// **'IP Address'**
  String get ipAddress;

  /// No description provided for @ipAddresses.
  ///
  /// In en, this message translates to:
  /// **'IP Addresses'**
  String get ipAddresses;

  /// No description provided for @ipAny.
  ///
  /// In en, this message translates to:
  /// **'Any'**
  String get ipAny;

  /// No description provided for @ipProtocol.
  ///
  /// In en, this message translates to:
  /// **'IP Version'**
  String get ipProtocol;

  /// No description provided for @ipv4TunnelNetwork.
  ///
  /// In en, this message translates to:
  /// **'IPv4 Tunnel Network'**
  String get ipv4TunnelNetwork;

  /// No description provided for @ipv6TunnelNetwork.
  ///
  /// In en, this message translates to:
  /// **'IPv6 Tunnel Network'**
  String get ipv6TunnelNetwork;

  /// No description provided for @iscDhcpDescription.
  ///
  /// In en, this message translates to:
  /// **'Internet Systems Consortium DHCP server'**
  String get iscDhcpDescription;

  /// Count of items in a list
  ///
  /// In en, this message translates to:
  /// **'{count} item(s)'**
  String itemsCount(int count);

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// No description provided for @keaDhcpDescription.
  ///
  /// In en, this message translates to:
  /// **'Modern, high-performance DHCP server'**
  String get keaDhcpDescription;

  /// No description provided for @keepAliveIntervalOptional.
  ///
  /// In en, this message translates to:
  /// **'Keep Alive Interval (Optional)'**
  String get keepAliveIntervalOptional;

  /// No description provided for @keepBoth.
  ///
  /// In en, this message translates to:
  /// **'Keep Both'**
  String get keepBoth;

  /// No description provided for @keepState.
  ///
  /// In en, this message translates to:
  /// **'Keep State'**
  String get keepState;

  /// No description provided for @keepalive.
  ///
  /// In en, this message translates to:
  /// **'Keepalive'**
  String get keepalive;

  /// No description provided for @keepaliveOptional.
  ///
  /// In en, this message translates to:
  /// **'Keepalive (Optional)'**
  String get keepaliveOptional;

  /// No description provided for @key.
  ///
  /// In en, this message translates to:
  /// **'Key'**
  String get key;

  /// No description provided for @keyCopiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Key copied to clipboard'**
  String get keyCopiedToClipboard;

  /// No description provided for @keyGeneratedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Key generated successfully'**
  String get keyGeneratedSuccessfully;

  /// No description provided for @keyWithId.
  ///
  /// In en, this message translates to:
  /// **'Key {id}'**
  String keyWithId(String id);

  /// No description provided for @keysGeneratedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Keys generated successfully'**
  String get keysGeneratedSuccessfully;

  /// No description provided for @keysRequired.
  ///
  /// In en, this message translates to:
  /// **'Private and public keys are required'**
  String get keysRequired;

  /// No description provided for @label.
  ///
  /// In en, this message translates to:
  /// **'Label'**
  String get label;

  /// No description provided for @labelHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Home Network, Office VPN'**
  String get labelHint;

  /// No description provided for @labelOptional.
  ///
  /// In en, this message translates to:
  /// **'Label (Optional)'**
  String get labelOptional;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @lastDay.
  ///
  /// In en, this message translates to:
  /// **'Last Day'**
  String get lastDay;

  /// No description provided for @lastDayShort.
  ///
  /// In en, this message translates to:
  /// **'1 Day'**
  String get lastDayShort;

  /// No description provided for @lastMonth.
  ///
  /// In en, this message translates to:
  /// **'Last Month'**
  String get lastMonth;

  /// No description provided for @lastMonthShort.
  ///
  /// In en, this message translates to:
  /// **'1 Month'**
  String get lastMonthShort;

  /// No description provided for @lastUpdate.
  ///
  /// In en, this message translates to:
  /// **'Last Update'**
  String get lastUpdate;

  /// No description provided for @lastUsed.
  ///
  /// In en, this message translates to:
  /// **'Last used: {date}'**
  String lastUsed(String date);

  /// No description provided for @lastWeek.
  ///
  /// In en, this message translates to:
  /// **'Last Week'**
  String get lastWeek;

  /// No description provided for @lastWeekShort.
  ///
  /// In en, this message translates to:
  /// **'1 Week'**
  String get lastWeekShort;

  /// No description provided for @leasesCount.
  ///
  /// In en, this message translates to:
  /// **'{filtered} of {total} lease(s)'**
  String leasesCount(int filtered, int total);

  /// No description provided for @leaveEmptyOrGenerate.
  ///
  /// In en, this message translates to:
  /// **'Leave empty or generate'**
  String get leaveEmptyOrGenerate;

  /// No description provided for @licenses.
  ///
  /// In en, this message translates to:
  /// **'Licenses'**
  String get licenses;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// No description provided for @limit.
  ///
  /// In en, this message translates to:
  /// **'Limit'**
  String get limit;

  /// No description provided for @live.
  ///
  /// In en, this message translates to:
  /// **'LIVE'**
  String get live;

  /// No description provided for @liveNetworkMonitor.
  ///
  /// In en, this message translates to:
  /// **'Live Network Monitor'**
  String get liveNetworkMonitor;

  /// No description provided for @neighborDiscovery.
  ///
  /// In en, this message translates to:
  /// **'Neighbor Discovery'**
  String get neighborDiscovery;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @loadingHostData.
  ///
  /// In en, this message translates to:
  /// **'Loading host data...'**
  String get loadingHostData;

  /// No description provided for @loadingSettings.
  ///
  /// In en, this message translates to:
  /// **'Loading settings...'**
  String get loadingSettings;

  /// No description provided for @localAddress.
  ///
  /// In en, this message translates to:
  /// **'Local Address'**
  String get localAddress;

  /// No description provided for @localNetwork.
  ///
  /// In en, this message translates to:
  /// **'Local Network'**
  String get localNetwork;

  /// No description provided for @localNetworkHelperText.
  ///
  /// In en, this message translates to:
  /// **'These are the networks accessible by the client, these are pushed via route(-ipv6) clauses in OpenVPN to the client.'**
  String get localNetworkHelperText;

  /// No description provided for @lockAfterMinutes.
  ///
  /// In en, this message translates to:
  /// **'Lock after {minutes} {minutes, plural, =1{minute} other{minutes}} of inactivity'**
  String lockAfterMinutes(int minutes);

  /// No description provided for @lockApp.
  ///
  /// In en, this message translates to:
  /// **'Lock App'**
  String get lockApp;

  /// No description provided for @lockTimeoutLabel.
  ///
  /// In en, this message translates to:
  /// **'Lock Timeout'**
  String get lockTimeoutLabel;

  /// No description provided for @lockTimeoutSet.
  ///
  /// In en, this message translates to:
  /// **'Lock timeout set to {value} {value, plural, =1{minute} other{minutes}}'**
  String lockTimeoutSet(int value);

  /// No description provided for @longPressToCopy.
  ///
  /// In en, this message translates to:
  /// **'Long press to copy'**
  String get longPressToCopy;

  /// No description provided for @logDetails.
  ///
  /// In en, this message translates to:
  /// **'Log Details'**
  String get logDetails;

  /// No description provided for @logEntryCopied.
  ///
  /// In en, this message translates to:
  /// **'Log entry copied'**
  String get logEntryCopied;

  /// No description provided for @logEntryDetails.
  ///
  /// In en, this message translates to:
  /// **'Log Entry Details'**
  String get logEntryDetails;

  /// No description provided for @logFile.
  ///
  /// In en, this message translates to:
  /// **'Log File'**
  String get logFile;

  /// No description provided for @logLimit.
  ///
  /// In en, this message translates to:
  /// **'Log Limit'**
  String get logLimit;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @loginServer.
  ///
  /// In en, this message translates to:
  /// **'Login Server'**
  String get loginServer;

  /// No description provided for @loginServerHelperText.
  ///
  /// In en, this message translates to:
  /// **'The Tailscale login server URL'**
  String get loginServerHelperText;

  /// No description provided for @loginServerRequired.
  ///
  /// In en, this message translates to:
  /// **'Login server is required'**
  String get loginServerRequired;

  /// No description provided for @logTraffic.
  ///
  /// In en, this message translates to:
  /// **'Log Traffic'**
  String get logTraffic;

  /// No description provided for @logTrafficSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Log packets matched by this rule'**
  String get logTrafficSubtitle;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logs.
  ///
  /// In en, this message translates to:
  /// **'Logs'**
  String get logs;

  /// No description provided for @logsExportedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Logs exported successfully'**
  String get logsExportedSuccessfully;

  /// No description provided for @logsMatchingFiltersWillAppearHere.
  ///
  /// In en, this message translates to:
  /// **'Logs matching your filters will appear here'**
  String get logsMatchingFiltersWillAppearHere;

  /// No description provided for @logsWillAppear.
  ///
  /// In en, this message translates to:
  /// **'Logs will appear here as they are generated'**
  String get logsWillAppear;

  /// No description provided for @macAddress.
  ///
  /// In en, this message translates to:
  /// **'MAC Address'**
  String get macAddress;

  /// No description provided for @macAddressHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., 00:11:22:33:44:55'**
  String get macAddressHint;

  /// Validation error when MAC address field is empty
  ///
  /// In en, this message translates to:
  /// **'MAC address is required'**
  String get macAddressIsRequired;

  /// Validation error for an invalid MAC address
  ///
  /// In en, this message translates to:
  /// **'Invalid MAC address format (e.g., AA:BB:CC:DD:EE:FF)'**
  String get invalidMacAddressFormat;

  /// No description provided for @manageProfiles.
  ///
  /// In en, this message translates to:
  /// **'Manage Profiles'**
  String get manageProfiles;

  /// No description provided for @manageSubnets.
  ///
  /// In en, this message translates to:
  /// **'Manage Subnets'**
  String get manageSubnets;

  /// No description provided for @manageWireguard.
  ///
  /// In en, this message translates to:
  /// **'Manage WireGuard'**
  String get manageWireguard;

  /// No description provided for @manufacturer.
  ///
  /// In en, this message translates to:
  /// **'Manufacturer'**
  String get manufacturer;

  /// No description provided for @maximumTransmissionUnit.
  ///
  /// In en, this message translates to:
  /// **'Maximum Transmission Unit (576-9000)'**
  String get maximumTransmissionUnit;

  /// No description provided for @memoryUsage.
  ///
  /// In en, this message translates to:
  /// **'Memory Usage'**
  String get memoryUsage;

  /// No description provided for @minute.
  ///
  /// In en, this message translates to:
  /// **'minute'**
  String get minute;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get minutes;

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{minutes}m ago'**
  String minutesAgo(int minutes);

  /// No description provided for @mode.
  ///
  /// In en, this message translates to:
  /// **'Mode'**
  String get mode;

  /// No description provided for @modified.
  ///
  /// In en, this message translates to:
  /// **'Modified'**
  String get modified;

  /// No description provided for @modulateState.
  ///
  /// In en, this message translates to:
  /// **'Modulate State'**
  String get modulateState;

  /// No description provided for @monitorInterface.
  ///
  /// In en, this message translates to:
  /// **'Monitor Interface'**
  String get monitorInterface;

  /// No description provided for @mssFix.
  ///
  /// In en, this message translates to:
  /// **'MSS Fix'**
  String get mssFix;

  /// No description provided for @mssFixDescription.
  ///
  /// In en, this message translates to:
  /// **'Enable MSS fix for this connection'**
  String get mssFixDescription;

  /// No description provided for @mtuOptional.
  ///
  /// In en, this message translates to:
  /// **'MTU (Optional)'**
  String get mtuOptional;

  /// No description provided for @mustBeValidUrl.
  ///
  /// In en, this message translates to:
  /// **'Must be a valid URL starting with http:// or https://'**
  String get mustBeValidUrl;

  /// No description provided for @myOPNsenseRouter.
  ///
  /// In en, this message translates to:
  /// **'My OPNsense Router'**
  String get myOPNsenseRouter;

  /// No description provided for @myOpenvpnInstance.
  ///
  /// In en, this message translates to:
  /// **'My OpenVPN Instance'**
  String get myOpenvpnInstance;

  /// No description provided for @myStaticKey.
  ///
  /// In en, this message translates to:
  /// **'My Static Key'**
  String get myStaticKey;

  /// No description provided for @myWireguardPeer.
  ///
  /// In en, this message translates to:
  /// **'My WireGuard Peer'**
  String get myWireguardPeer;

  /// No description provided for @myWireguardServer.
  ///
  /// In en, this message translates to:
  /// **'My WireGuard Server'**
  String get myWireguardServer;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @needHelpCheckDocumentation.
  ///
  /// In en, this message translates to:
  /// **'Need help? Check the OPNsense documentation for API key generation.'**
  String get needHelpCheckDocumentation;

  /// No description provided for @networkConfiguration.
  ///
  /// In en, this message translates to:
  /// **'Network Configuration'**
  String get networkConfiguration;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Network error occurred'**
  String get networkError;

  /// No description provided for @networkInformation.
  ///
  /// In en, this message translates to:
  /// **'Network Information'**
  String get networkInformation;

  /// No description provided for @networkTotals.
  ///
  /// In en, this message translates to:
  /// **'Network Totals'**
  String get networkTotals;

  /// No description provided for @newPin.
  ///
  /// In en, this message translates to:
  /// **'New PIN (4-6 digits)'**
  String get newPin;

  /// No description provided for @newPinMustBeDifferent.
  ///
  /// In en, this message translates to:
  /// **'New PIN must be different from current PIN'**
  String get newPinMustBeDifferent;

  /// No description provided for @newRule.
  ///
  /// In en, this message translates to:
  /// **'New Rule'**
  String get newRule;

  /// No description provided for @newWireguardPeer.
  ///
  /// In en, this message translates to:
  /// **'New WireGuard Peer'**
  String get newWireguardPeer;

  /// No description provided for @newWireguardServer.
  ///
  /// In en, this message translates to:
  /// **'New WireGuard Server'**
  String get newWireguardServer;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @noAliasesConfigured.
  ///
  /// In en, this message translates to:
  /// **'No aliases configured'**
  String get noAliasesConfigured;

  /// No description provided for @noAliasesMatchFilters.
  ///
  /// In en, this message translates to:
  /// **'No aliases match the current filters'**
  String get noAliasesMatchFilters;

  /// No description provided for @noAutomationRulesFound.
  ///
  /// In en, this message translates to:
  /// **'No automation rules found'**
  String get noAutomationRulesFound;

  /// No description provided for @noClientSpecificOverridesConfigured.
  ///
  /// In en, this message translates to:
  /// **'No client specific overrides configured'**
  String get noClientSpecificOverridesConfigured;

  /// No description provided for @noConnectionsFound.
  ///
  /// In en, this message translates to:
  /// **'No {type} connections found'**
  String noConnectionsFound(String type);

  /// No description provided for @noDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noDataAvailable;

  /// No description provided for @noDescription.
  ///
  /// In en, this message translates to:
  /// **'No Description'**
  String get noDescription;

  /// No description provided for @noDnsDomainSearchEntriesConfigured.
  ///
  /// In en, this message translates to:
  /// **'No DNS domain search entries configured'**
  String get noDnsDomainSearchEntriesConfigured;

  /// No description provided for @noDnsDomainsConfigured.
  ///
  /// In en, this message translates to:
  /// **'No DNS domains configured'**
  String get noDnsDomainsConfigured;

  /// No description provided for @noDnsServersConfigured.
  ///
  /// In en, this message translates to:
  /// **'No DNS servers configured'**
  String get noDnsServersConfigured;

  /// No description provided for @noHostsFound.
  ///
  /// In en, this message translates to:
  /// **'No hosts found'**
  String get noHostsFound;

  /// No description provided for @noInstancesMatchFilters.
  ///
  /// In en, this message translates to:
  /// **'No instances match your filters'**
  String get noInstancesMatchFilters;

  /// No description provided for @noInterfacesWithAutomationRules.
  ///
  /// In en, this message translates to:
  /// **'No interfaces with automation rules'**
  String get noInterfacesWithAutomationRules;

  /// No description provided for @noItemsConfigured.
  ///
  /// In en, this message translates to:
  /// **'No items configured'**
  String get noItemsConfigured;

  /// No description provided for @noLeasesFound.
  ///
  /// In en, this message translates to:
  /// **'No leases found'**
  String get noLeasesFound;

  /// No description provided for @noLimit.
  ///
  /// In en, this message translates to:
  /// **'No Limit'**
  String get noLimit;

  /// No description provided for @noLimitShort.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get noLimitShort;

  /// No description provided for @noLocalNetworksConfigured.
  ///
  /// In en, this message translates to:
  /// **'No local networks configured'**
  String get noLocalNetworksConfigured;

  /// No description provided for @noLogEntriesFound.
  ///
  /// In en, this message translates to:
  /// **'No log entries found'**
  String get noLogEntriesFound;

  /// No description provided for @noLogsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No logs available'**
  String get noLogsAvailable;

  /// No description provided for @noLogsToExport.
  ///
  /// In en, this message translates to:
  /// **'No logs to export'**
  String get noLogsToExport;

  /// No description provided for @noNtpServersConfigured.
  ///
  /// In en, this message translates to:
  /// **'No NTP servers configured'**
  String get noNtpServersConfigured;

  /// No description provided for @noOpenvpnInstancesConfigured.
  ///
  /// In en, this message translates to:
  /// **'No OpenVPN instances configured'**
  String get noOpenvpnInstancesConfigured;

  /// No description provided for @noOpenvpnRoutesConfigured.
  ///
  /// In en, this message translates to:
  /// **'No OpenVPN routes configured'**
  String get noOpenvpnRoutesConfigured;

  /// No description provided for @noOpenvpnSessionsConfigured.
  ///
  /// In en, this message translates to:
  /// **'There are no OpenVPN sessions configured'**
  String get noOpenvpnSessionsConfigured;

  /// No description provided for @noOptionsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No options available'**
  String get noOptionsAvailable;

  /// No description provided for @noOverridesMatchFilter.
  ///
  /// In en, this message translates to:
  /// **'No overrides match your filter'**
  String get noOverridesMatchFilter;

  /// No description provided for @noPeersAvailable.
  ///
  /// In en, this message translates to:
  /// **'No peers available'**
  String get noPeersAvailable;

  /// No description provided for @noPeersMatchSearch.
  ///
  /// In en, this message translates to:
  /// **'No peers match your search'**
  String get noPeersMatchSearch;

  /// No description provided for @noProfiles.
  ///
  /// In en, this message translates to:
  /// **'No Profiles'**
  String get noProfiles;

  /// No description provided for @noProfilesFound.
  ///
  /// In en, this message translates to:
  /// **'No profiles found'**
  String get noProfilesFound;

  /// No description provided for @noProfilesYet.
  ///
  /// In en, this message translates to:
  /// **'No Profiles Yet'**
  String get noProfilesYet;

  /// No description provided for @noRemoteNetworksConfigured.
  ///
  /// In en, this message translates to:
  /// **'No remote networks configured'**
  String get noRemoteNetworksConfigured;

  /// No description provided for @noRoutesConfigured.
  ///
  /// In en, this message translates to:
  /// **'No routes configured'**
  String get noRoutesConfigured;

  /// No description provided for @noRulesForInterface.
  ///
  /// In en, this message translates to:
  /// **'No rules for {interface}'**
  String noRulesForInterface(String interface);

  /// No description provided for @noServersAvailable.
  ///
  /// In en, this message translates to:
  /// **'No servers available'**
  String get noServersAvailable;

  /// No description provided for @noServersMatchSearch.
  ///
  /// In en, this message translates to:
  /// **'No servers match your search'**
  String get noServersMatchSearch;

  /// No description provided for @noServersSelected.
  ///
  /// In en, this message translates to:
  /// **'No servers selected'**
  String get noServersSelected;

  /// No description provided for @noSessionsFound.
  ///
  /// In en, this message translates to:
  /// **'No sessions found'**
  String get noSessionsFound;

  /// No description provided for @noSettingsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No settings available'**
  String get noSettingsAvailable;

  /// No description provided for @noStaticKeysConfigured.
  ///
  /// In en, this message translates to:
  /// **'No static keys configured'**
  String get noStaticKeysConfigured;

  /// No description provided for @noState.
  ///
  /// In en, this message translates to:
  /// **'No State'**
  String get noState;

  /// No description provided for @noSubnetsConfigured.
  ///
  /// In en, this message translates to:
  /// **'No subnets configured'**
  String get noSubnetsConfigured;

  /// No description provided for @noTunnelAddressesConfigured.
  ///
  /// In en, this message translates to:
  /// **'No tunnel addresses configured'**
  String get noTunnelAddressesConfigured;

  /// No description provided for @noVpnConnectionsFound.
  ///
  /// In en, this message translates to:
  /// **'No VPN connections found'**
  String get noVpnConnectionsFound;

  /// No description provided for @noWinsServersConfigured.
  ///
  /// In en, this message translates to:
  /// **'No WINS servers configured'**
  String get noWinsServersConfigured;

  /// No description provided for @noWireguardPeersConfigured.
  ///
  /// In en, this message translates to:
  /// **'No WireGuard peers configured'**
  String get noWireguardPeersConfigured;

  /// No description provided for @noWireguardServersConfigured.
  ///
  /// In en, this message translates to:
  /// **'No WireGuard servers configured'**
  String get noWireguardServersConfigured;

  /// No description provided for @noWireguardStatusDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'No WireGuard status data available'**
  String get noWireguardStatusDataAvailable;

  /// No description provided for @noWolHostsConfigured.
  ///
  /// In en, this message translates to:
  /// **'No Wake on LAN hosts configured'**
  String get noWolHostsConfigured;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// Not available abbreviation
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get notAvailable;

  /// No description provided for @notFound.
  ///
  /// In en, this message translates to:
  /// **'Resource not found'**
  String get notFound;

  /// No description provided for @notice.
  ///
  /// In en, this message translates to:
  /// **'Notice'**
  String get notice;

  /// No description provided for @ntpServers.
  ///
  /// In en, this message translates to:
  /// **'NTP Servers'**
  String get ntpServers;

  /// No description provided for @ntpServersHelperText.
  ///
  /// In en, this message translates to:
  /// **'Set primary NTP server address (Network Time Protocol). Repeat this option to set secondary NTP server addresses.'**
  String get ntpServersHelperText;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @oneHour.
  ///
  /// In en, this message translates to:
  /// **'1 hour'**
  String get oneHour;

  /// No description provided for @oneMin.
  ///
  /// In en, this message translates to:
  /// **'1 min'**
  String get oneMin;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @openvpnConnectionStatus.
  ///
  /// In en, this message translates to:
  /// **'OpenVPN Connection Status'**
  String get openvpnConnectionStatus;

  /// No description provided for @openvpnInstances.
  ///
  /// In en, this message translates to:
  /// **'OpenVPN Instances'**
  String get openvpnInstances;

  /// No description provided for @openvpnLogFile.
  ///
  /// In en, this message translates to:
  /// **'OpenVPN Log File'**
  String get openvpnLogFile;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// No description provided for @optionalBase64EncodedPresharedKey.
  ///
  /// In en, this message translates to:
  /// **'Optional Base64-encoded preshared key'**
  String get optionalBase64EncodedPresharedKey;

  /// No description provided for @outbound.
  ///
  /// In en, this message translates to:
  /// **'Outbound'**
  String get outbound;

  /// No description provided for @overrideCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Override created successfully'**
  String get overrideCreatedSuccessfully;

  /// No description provided for @overrideDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Override deleted successfully'**
  String get overrideDeletedSuccessfully;

  /// No description provided for @overrideDetails.
  ///
  /// In en, this message translates to:
  /// **'Override Details'**
  String get overrideDetails;

  /// No description provided for @overrideToggledSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Override {status} successfully'**
  String overrideToggledSuccessfully(String status);

  /// No description provided for @overrideUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Override updated successfully'**
  String get overrideUpdatedSuccessfully;

  /// No description provided for @overwrite.
  ///
  /// In en, this message translates to:
  /// **'Overwrite'**
  String get overwrite;

  /// No description provided for @packageMirror.
  ///
  /// In en, this message translates to:
  /// **'Package Mirror'**
  String get packageMirror;

  /// No description provided for @packetLength.
  ///
  /// In en, this message translates to:
  /// **'Packet Length'**
  String get packetLength;

  /// No description provided for @pass.
  ///
  /// In en, this message translates to:
  /// **'Pass'**
  String get pass;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @pauseLiveViewToSelect.
  ///
  /// In en, this message translates to:
  /// **'Pause live view to select log entries'**
  String get pauseLiveViewToSelect;

  /// No description provided for @paused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get paused;

  /// No description provided for @peerCreatedReadyForNext.
  ///
  /// In en, this message translates to:
  /// **'Peer created successfully. Ready for next peer.'**
  String get peerCreatedReadyForNext;

  /// No description provided for @peerCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Peer created successfully'**
  String get peerCreatedSuccessfully;

  /// No description provided for @peerDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Peer deleted successfully'**
  String get peerDeletedSuccessfully;

  /// No description provided for @peerDisabledSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Peer disabled successfully'**
  String get peerDisabledSuccessfully;

  /// No description provided for @peerEnabledSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Peer enabled successfully'**
  String get peerEnabledSuccessfully;

  /// No description provided for @peerGenerator.
  ///
  /// In en, this message translates to:
  /// **'Peer Generator'**
  String get peerGenerator;

  /// No description provided for @peerUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Peer updated successfully'**
  String get peerUpdatedSuccessfully;

  /// No description provided for @peerWillBeActiveWhenEnabled.
  ///
  /// In en, this message translates to:
  /// **'Peer will be active when enabled'**
  String get peerWillBeActiveWhenEnabled;

  /// No description provided for @peers.
  ///
  /// In en, this message translates to:
  /// **'Peers'**
  String get peers;

  /// No description provided for @peersConfigured.
  ///
  /// In en, this message translates to:
  /// **'{count} peer(s) configured'**
  String peersConfigured(int count);

  /// No description provided for @peersCount.
  ///
  /// In en, this message translates to:
  /// **'Peers Count'**
  String get peersCount;

  /// No description provided for @peersSelected.
  ///
  /// In en, this message translates to:
  /// **'{count} peer(s) selected'**
  String peersSelected(int count);

  /// No description provided for @persistentKeepaliveSeconds.
  ///
  /// In en, this message translates to:
  /// **'Persistent keepalive in seconds (recommended: 25)'**
  String get persistentKeepaliveSeconds;

  /// No description provided for @pinChangedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'PIN changed successfully'**
  String get pinChangedSuccessfully;

  /// No description provided for @pinLock.
  ///
  /// In en, this message translates to:
  /// **'PIN Lock'**
  String get pinLock;

  /// No description provided for @pinLockDisabled.
  ///
  /// In en, this message translates to:
  /// **'PIN lock disabled. Biometric lock also disabled.'**
  String get pinLockDisabled;

  /// No description provided for @pinLockEnabled.
  ///
  /// In en, this message translates to:
  /// **'PIN lock enabled'**
  String get pinLockEnabled;

  /// No description provided for @pinMismatch.
  ///
  /// In en, this message translates to:
  /// **'PINs do not match'**
  String get pinMismatch;

  /// No description provided for @pinMustContainOnlyNumbers.
  ///
  /// In en, this message translates to:
  /// **'PIN must contain only numbers'**
  String get pinMustContainOnlyNumbers;

  /// No description provided for @pinTooShort.
  ///
  /// In en, this message translates to:
  /// **'PIN must be at least 4 digits'**
  String get pinTooShort;

  /// No description provided for @platform.
  ///
  /// In en, this message translates to:
  /// **'Platform'**
  String get platform;

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

  /// No description provided for @pleaseEnterSubnet.
  ///
  /// In en, this message translates to:
  /// **'Please enter a subnet'**
  String get pleaseEnterSubnet;

  /// No description provided for @pleaseEnterYourPin.
  ///
  /// In en, this message translates to:
  /// **'Please enter your PIN'**
  String get pleaseEnterYourPin;

  /// No description provided for @pleaseSelectAnInstance.
  ///
  /// In en, this message translates to:
  /// **'Please select an instance'**
  String get pleaseSelectAnInstance;

  /// No description provided for @pleaseSelectInterface.
  ///
  /// In en, this message translates to:
  /// **'Please select an interface'**
  String get pleaseSelectInterface;

  /// No description provided for @port.
  ///
  /// In en, this message translates to:
  /// **'Port'**
  String get port;

  /// No description provided for @portHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., 443'**
  String get portHint;

  /// No description provided for @portIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Port is required'**
  String get portIsRequired;

  /// No description provided for @portLabel.
  ///
  /// In en, this message translates to:
  /// **'Port {port}'**
  String portLabel(String port);

  /// No description provided for @portMustBeBetween.
  ///
  /// In en, this message translates to:
  /// **'Port must be between 1 and 65535'**
  String get portMustBeBetween;

  /// No description provided for @preAuthKey.
  ///
  /// In en, this message translates to:
  /// **'Pre-Auth Key'**
  String get preAuthKey;

  /// No description provided for @preAuthKeyHelperText.
  ///
  /// In en, this message translates to:
  /// **'Optional: Pre-authentication key for automatic device registration'**
  String get preAuthKeyHelperText;

  /// No description provided for @presharedKeyGeneratedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Pre-shared key generated successfully'**
  String get presharedKeyGeneratedSuccessfully;

  /// No description provided for @presharedKeyOptional.
  ///
  /// In en, this message translates to:
  /// **'Pre-shared Key (Optional)'**
  String get presharedKeyOptional;

  /// No description provided for @preventAutomaticRouteInstallation.
  ///
  /// In en, this message translates to:
  /// **'Prevent automatic route installation'**
  String get preventAutomaticRouteInstallation;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @privateKey.
  ///
  /// In en, this message translates to:
  /// **'Private Key'**
  String get privateKey;

  /// No description provided for @profileActivated.
  ///
  /// In en, this message translates to:
  /// **'Profile activated successfully'**
  String get profileActivated;

  /// No description provided for @profileAdded.
  ///
  /// In en, this message translates to:
  /// **'Profile added'**
  String get profileAdded;

  /// No description provided for @profileDeleted.
  ///
  /// In en, this message translates to:
  /// **'Profile deleted successfully'**
  String get profileDeleted;

  /// No description provided for @profileHasNoEndpoints.
  ///
  /// In en, this message translates to:
  /// **'Profile has no connection endpoints configured'**
  String get profileHasNoEndpoints;

  /// No description provided for @profileName.
  ///
  /// In en, this message translates to:
  /// **'Profile Name'**
  String get profileName;

  /// No description provided for @profileNameOptional.
  ///
  /// In en, this message translates to:
  /// **'Profile Name (Optional)'**
  String get profileNameOptional;

  /// No description provided for @profileNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Profile name is required'**
  String get profileNameRequired;

  /// No description provided for @profileSaved.
  ///
  /// In en, this message translates to:
  /// **'Profile saved successfully'**
  String get profileSaved;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated'**
  String get profileUpdated;

  /// No description provided for @profiles.
  ///
  /// In en, this message translates to:
  /// **'Profiles'**
  String get profiles;

  /// No description provided for @profilesExportedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Profiles exported successfully!\n{path}'**
  String profilesExportedSuccessfully(String path);

  /// No description provided for @protocol.
  ///
  /// In en, this message translates to:
  /// **'Protocol'**
  String get protocol;

  /// No description provided for @publicKey.
  ///
  /// In en, this message translates to:
  /// **'Public Key'**
  String get publicKey;

  /// No description provided for @publicKeyColon.
  ///
  /// In en, this message translates to:
  /// **'Public Key:'**
  String get publicKeyColon;

  /// No description provided for @publicKeyRequired.
  ///
  /// In en, this message translates to:
  /// **'Public key is required'**
  String get publicKeyRequired;

  /// No description provided for @publicKeyShort.
  ///
  /// In en, this message translates to:
  /// **'{key}...'**
  String publicKeyShort(String key);

  /// No description provided for @pushReset.
  ///
  /// In en, this message translates to:
  /// **'Push reset'**
  String get pushReset;

  /// No description provided for @pushVirtualIpEndpoints.
  ///
  /// In en, this message translates to:
  /// **'Push virtual IP endpoints for client tunnel, overriding dynamic allocation.'**
  String get pushVirtualIpEndpoints;

  /// No description provided for @qrCode.
  ///
  /// In en, this message translates to:
  /// **'QR Code'**
  String get qrCode;

  /// No description provided for @quickRule.
  ///
  /// In en, this message translates to:
  /// **'Quick Rule'**
  String get quickRule;

  /// No description provided for @quickRuleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Stop processing rules after first match'**
  String get quickRuleSubtitle;

  /// No description provided for @reason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get reason;

  /// No description provided for @rebootConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reboot the system?'**
  String get rebootConfirmation;

  /// No description provided for @rebootFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to reboot system'**
  String get rebootFailed;

  /// No description provided for @rebootFailedWithError.
  ///
  /// In en, this message translates to:
  /// **'{message}: {error}'**
  String rebootFailedWithError(String message, String error);

  /// No description provided for @rebootSuccess.
  ///
  /// In en, this message translates to:
  /// **'System reboot initiated'**
  String get rebootSuccess;

  /// No description provided for @rebootSystem.
  ///
  /// In en, this message translates to:
  /// **'Reboot System'**
  String get rebootSystem;

  /// No description provided for @received.
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get received;

  /// No description provided for @recommendedForSecureConnections.
  ///
  /// In en, this message translates to:
  /// **'Recommended for secure connections'**
  String get recommendedForSecureConnections;

  /// No description provided for @redirectGateway.
  ///
  /// In en, this message translates to:
  /// **'Redirect gateway'**
  String get redirectGateway;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @registerDns.
  ///
  /// In en, this message translates to:
  /// **'Register DNS'**
  String get registerDns;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @remoteAddress.
  ///
  /// In en, this message translates to:
  /// **'Remote Address'**
  String get remoteAddress;

  /// No description provided for @remoteNetwork.
  ///
  /// In en, this message translates to:
  /// **'Remote Network'**
  String get remoteNetwork;

  /// No description provided for @remoteNetworkHelperText.
  ///
  /// In en, this message translates to:
  /// **'Remote networks for the server, these are configured via iroute(-ipv6) clauses in OpenVPN and inform the server to send these networks to this specific client.'**
  String get remoteNetworkHelperText;

  /// No description provided for @repository.
  ///
  /// In en, this message translates to:
  /// **'Repository'**
  String get repository;

  /// No description provided for @requirePinToUnlock.
  ///
  /// In en, this message translates to:
  /// **'Require PIN to unlock app'**
  String get requirePinToUnlock;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @restart.
  ///
  /// In en, this message translates to:
  /// **'Restart'**
  String get restart;

  /// No description provided for @restartService.
  ///
  /// In en, this message translates to:
  /// **'Restart Service'**
  String get restartService;

  /// No description provided for @restartServiceConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to restart the {type} service?\n\nThis will temporarily disconnect all active connections.'**
  String restartServiceConfirmation(String type);

  /// No description provided for @restartVpnService.
  ///
  /// In en, this message translates to:
  /// **'Restart VPN Service'**
  String get restartVpnService;

  /// No description provided for @restartingService.
  ///
  /// In en, this message translates to:
  /// **'Restarting {type} service...'**
  String restartingService(String type);

  /// No description provided for @resume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resume;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @role.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// No description provided for @routeGateway.
  ///
  /// In en, this message translates to:
  /// **'Route gateway'**
  String get routeGateway;

  /// No description provided for @routeGatewayHelperText.
  ///
  /// In en, this message translates to:
  /// **'Specify a default gateway to use for the connected client. Without one set the first address in the netblock is being offered. When segmenting the tunnel (server) network, this one might not be accessible from the client.'**
  String get routeGatewayHelperText;

  /// No description provided for @routes.
  ///
  /// In en, this message translates to:
  /// **'Routes'**
  String get routes;

  /// No description provided for @routing.
  ///
  /// In en, this message translates to:
  /// **'Routing'**
  String get routing;

  /// No description provided for @rowsPerPageLabel.
  ///
  /// In en, this message translates to:
  /// **'Rows per page: '**
  String get rowsPerPageLabel;

  /// No description provided for @ruleActionFailed.
  ///
  /// In en, this message translates to:
  /// **'Rule action failed'**
  String get ruleActionFailed;

  /// No description provided for @ruleCreated.
  ///
  /// In en, this message translates to:
  /// **'Rule created successfully'**
  String get ruleCreated;

  /// No description provided for @ruleDeleted.
  ///
  /// In en, this message translates to:
  /// **'Rule deleted successfully'**
  String get ruleDeleted;

  /// No description provided for @ruleDescription.
  ///
  /// In en, this message translates to:
  /// **'Rule Description'**
  String get ruleDescription;

  /// No description provided for @ruleDetails.
  ///
  /// In en, this message translates to:
  /// **'Rule Details'**
  String get ruleDetails;

  /// No description provided for @ruleDisabledSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Rule disabled successfully'**
  String get ruleDisabledSuccessfully;

  /// No description provided for @ruleEnabledSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Rule enabled successfully'**
  String get ruleEnabledSuccessfully;

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

  /// No description provided for @ruleId.
  ///
  /// In en, this message translates to:
  /// **'Rule ID'**
  String get ruleId;

  /// No description provided for @ruleInformation.
  ///
  /// In en, this message translates to:
  /// **'Rule Information'**
  String get ruleInformation;

  /// No description provided for @ruleUpdated.
  ///
  /// In en, this message translates to:
  /// **'Rule updated successfully'**
  String get ruleUpdated;

  /// No description provided for @ruleWillBeActiveWhenEnabled.
  ///
  /// In en, this message translates to:
  /// **'Rule will be active when enabled'**
  String get ruleWillBeActiveWhenEnabled;

  /// No description provided for @running.
  ///
  /// In en, this message translates to:
  /// **'Running'**
  String get running;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @saveAndConnect.
  ///
  /// In en, this message translates to:
  /// **'Save & Connect'**
  String get saveAndConnect;

  /// No description provided for @saveSettings.
  ///
  /// In en, this message translates to:
  /// **'Save Settings'**
  String get saveSettings;

  /// No description provided for @saveWithoutTesting.
  ///
  /// In en, this message translates to:
  /// **'Save without testing'**
  String get saveWithoutTesting;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saving;

  /// No description provided for @savingOverride.
  ///
  /// In en, this message translates to:
  /// **'Saving override...'**
  String get savingOverride;

  /// No description provided for @savingProfile.
  ///
  /// In en, this message translates to:
  /// **'Saving profile...'**
  String get savingProfile;

  /// No description provided for @searchAliases.
  ///
  /// In en, this message translates to:
  /// **'Search aliases...'**
  String get searchAliases;

  /// No description provided for @searchHostnameIpOrMac.
  ///
  /// In en, this message translates to:
  /// **'Search hostname, IP, or MAC address...'**
  String get searchHostnameIpOrMac;

  /// No description provided for @searchHostnameOrIp.
  ///
  /// In en, this message translates to:
  /// **'Search hostname or IP address...'**
  String get searchHostnameOrIp;

  /// No description provided for @searchInstances.
  ///
  /// In en, this message translates to:
  /// **'Search instances...'**
  String get searchInstances;

  /// No description provided for @searchOverrides.
  ///
  /// In en, this message translates to:
  /// **'Search overrides...'**
  String get searchOverrides;

  /// No description provided for @searchPeers.
  ///
  /// In en, this message translates to:
  /// **'Search peers...'**
  String get searchPeers;

  /// No description provided for @searchServers.
  ///
  /// In en, this message translates to:
  /// **'Search servers...'**
  String get searchServers;

  /// No description provided for @second.
  ///
  /// In en, this message translates to:
  /// **'second'**
  String get second;

  /// No description provided for @seconds.
  ///
  /// In en, this message translates to:
  /// **'Seconds'**
  String get seconds;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @securityWarning.
  ///
  /// In en, this message translates to:
  /// **'Security Warning'**
  String get securityWarning;

  /// No description provided for @selectAProfileOrCreateNewOne.
  ///
  /// In en, this message translates to:
  /// **'Select a profile or create a new one'**
  String get selectAProfileOrCreateNewOne;

  /// No description provided for @selectAll.
  ///
  /// In en, this message translates to:
  /// **'Select All'**
  String get selectAll;

  /// No description provided for @selectExitNode.
  ///
  /// In en, this message translates to:
  /// **'Select exit node'**
  String get selectExitNode;

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

  /// No description provided for @selectLabel.
  ///
  /// In en, this message translates to:
  /// **'Select {label}'**
  String selectLabel(String label);

  /// No description provided for @selectMultipleInterfaces.
  ///
  /// In en, this message translates to:
  /// **'Select one or more interfaces to monitor'**
  String get selectMultipleInterfaces;

  /// No description provided for @selectNumberOfEntries.
  ///
  /// In en, this message translates to:
  /// **'Select the number of log entries to display:'**
  String get selectNumberOfEntries;

  /// No description provided for @selectPeers.
  ///
  /// In en, this message translates to:
  /// **'Select Peers'**
  String get selectPeers;

  /// No description provided for @selectServerAndGenerateKeys.
  ///
  /// In en, this message translates to:
  /// **'Select a server and generate keys to preview configuration'**
  String get selectServerAndGenerateKeys;

  /// No description provided for @selectServerForQrCode.
  ///
  /// In en, this message translates to:
  /// **'Select server to generate QR code'**
  String get selectServerForQrCode;

  /// No description provided for @selectServerInstance.
  ///
  /// In en, this message translates to:
  /// **'Please select a server instance'**
  String get selectServerInstance;

  /// No description provided for @selectServers.
  ///
  /// In en, this message translates to:
  /// **'Select Servers'**
  String get selectServers;

  /// No description provided for @selectServersHelperText.
  ///
  /// In en, this message translates to:
  /// **'Select the OpenVPN servers where this override applies to, leave empty for all'**
  String get selectServersHelperText;

  /// No description provided for @selectVhid.
  ///
  /// In en, this message translates to:
  /// **'Select VHID'**
  String get selectVhid;

  /// No description provided for @selected.
  ///
  /// In en, this message translates to:
  /// **'selected'**
  String get selected;

  /// No description provided for @selfSignedCertWarning.
  ///
  /// In en, this message translates to:
  /// **'Warning: Self-signed certificates are less secure. Only enable this if you trust the server.'**
  String get selfSignedCertWarning;

  /// No description provided for @selfSignedCertificatesWarning.
  ///
  /// In en, this message translates to:
  /// **'Only enable this if you trust the server'**
  String get selfSignedCertificatesWarning;

  /// No description provided for @sent.
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get sent;

  /// No description provided for @sequence.
  ///
  /// In en, this message translates to:
  /// **'Sequence'**
  String get sequence;

  /// No description provided for @server.
  ///
  /// In en, this message translates to:
  /// **'Server'**
  String get server;

  /// No description provided for @serverAddress.
  ///
  /// In en, this message translates to:
  /// **'Server Address'**
  String get serverAddress;

  /// No description provided for @serverCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Server created successfully'**
  String get serverCreatedSuccessfully;

  /// No description provided for @serverDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Server deleted successfully'**
  String get serverDeletedSuccessfully;

  /// No description provided for @serverDisabledSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Server disabled successfully'**
  String get serverDisabledSuccessfully;

  /// No description provided for @serverEnabledSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Server enabled successfully'**
  String get serverEnabledSuccessfully;

  /// No description provided for @serverError.
  ///
  /// In en, this message translates to:
  /// **'Server error occurred'**
  String get serverError;

  /// No description provided for @serverInfoNotLoaded.
  ///
  /// In en, this message translates to:
  /// **'Server information not loaded'**
  String get serverInfoNotLoaded;

  /// No description provided for @serverNetwork.
  ///
  /// In en, this message translates to:
  /// **'Server Network'**
  String get serverNetwork;

  /// No description provided for @serverPort.
  ///
  /// In en, this message translates to:
  /// **'Server Port'**
  String get serverPort;

  /// No description provided for @serverSelectionRequired.
  ///
  /// In en, this message translates to:
  /// **'At least one server must be selected'**
  String get serverSelectionRequired;

  /// No description provided for @serverUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Server updated successfully'**
  String get serverUpdatedSuccessfully;

  /// No description provided for @serverWillBeActiveWhenEnabled.
  ///
  /// In en, this message translates to:
  /// **'Server will be active when enabled'**
  String get serverWillBeActiveWhenEnabled;

  /// No description provided for @servers.
  ///
  /// In en, this message translates to:
  /// **'Servers'**
  String get servers;

  /// No description provided for @serversSelected.
  ///
  /// In en, this message translates to:
  /// **'{count} server(s) selected'**
  String serversSelected(int count);

  /// No description provided for @serviceActionFailed.
  ///
  /// In en, this message translates to:
  /// **'Service action failed'**
  String get serviceActionFailed;

  /// No description provided for @serviceControls.
  ///
  /// In en, this message translates to:
  /// **'Service Controls'**
  String get serviceControls;

  /// No description provided for @serviceRestartedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Service restarted successfully'**
  String get serviceRestartedSuccessfully;

  /// No description provided for @serviceRunning.
  ///
  /// In en, this message translates to:
  /// **'Service Running'**
  String get serviceRunning;

  /// No description provided for @serviceStartedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Service started successfully'**
  String get serviceStartedSuccessfully;

  /// No description provided for @serviceStatus.
  ///
  /// In en, this message translates to:
  /// **'Service Status'**
  String get serviceStatus;

  /// No description provided for @serviceStoppedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Service stopped successfully'**
  String get serviceStoppedSuccessfully;

  /// No description provided for @services.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get services;

  /// No description provided for @sessionTimeout.
  ///
  /// In en, this message translates to:
  /// **'Session Timeout'**
  String get sessionTimeout;

  /// No description provided for @sessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get sessions;

  /// No description provided for @setAsActive.
  ///
  /// In en, this message translates to:
  /// **'Set as Active'**
  String get setAsActive;

  /// No description provided for @setPin.
  ///
  /// In en, this message translates to:
  /// **'Set PIN'**
  String get setPin;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @severitiesAndTimeFilter.
  ///
  /// In en, this message translates to:
  /// **'{count} severities • {timeFilter}'**
  String severitiesAndTimeFilter(int count, String timeFilter);

  /// No description provided for @severity.
  ///
  /// In en, this message translates to:
  /// **'Severity'**
  String get severity;

  /// No description provided for @severityEmergency.
  ///
  /// In en, this message translates to:
  /// **'Emergency'**
  String get severityEmergency;

  /// No description provided for @severityEmergencyShort.
  ///
  /// In en, this message translates to:
  /// **'Emerg'**
  String get severityEmergencyShort;

  /// No description provided for @severityError.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get severityError;

  /// No description provided for @severityInformational.
  ///
  /// In en, this message translates to:
  /// **'Informational'**
  String get severityInformational;

  /// No description provided for @severityInformationalShort.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get severityInformationalShort;

  /// No description provided for @showAdvancedSettings.
  ///
  /// In en, this message translates to:
  /// **'Show Advanced Settings'**
  String get showAdvancedSettings;

  /// No description provided for @showAll.
  ///
  /// In en, this message translates to:
  /// **'Show All'**
  String get showAll;

  /// No description provided for @showKey.
  ///
  /// In en, this message translates to:
  /// **'Show key'**
  String get showKey;

  /// No description provided for @showingInstancesCount.
  ///
  /// In en, this message translates to:
  /// **'Showing {count} of {total}'**
  String showingInstancesCount(String count, String total);

  /// No description provided for @showingZeroEntries.
  ///
  /// In en, this message translates to:
  /// **'Showing 0 entries'**
  String get showingZeroEntries;

  /// No description provided for @someConnectionsFailed.
  ///
  /// In en, this message translates to:
  /// **'Some connections failed'**
  String get someConnectionsFailed;

  /// No description provided for @soon.
  ///
  /// In en, this message translates to:
  /// **'soon'**
  String get soon;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort By'**
  String get sortBy;

  /// No description provided for @sortByBandwidth.
  ///
  /// In en, this message translates to:
  /// **'Bandwidth'**
  String get sortByBandwidth;

  /// No description provided for @sortByHostname.
  ///
  /// In en, this message translates to:
  /// **'Hostname'**
  String get sortByHostname;

  /// No description provided for @sortByIP.
  ///
  /// In en, this message translates to:
  /// **'IP Address'**
  String get sortByIP;

  /// No description provided for @sortByManufacturer.
  ///
  /// In en, this message translates to:
  /// **'Manufacturer'**
  String get sortByManufacturer;

  /// No description provided for @source.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get source;

  /// No description provided for @sourceAddress.
  ///
  /// In en, this message translates to:
  /// **'Source Address'**
  String get sourceAddress;

  /// No description provided for @sourceIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Source is required'**
  String get sourceIsRequired;

  /// No description provided for @sourcePort.
  ///
  /// In en, this message translates to:
  /// **'Source Port'**
  String get sourcePort;

  /// No description provided for @sourcePortOptional.
  ///
  /// In en, this message translates to:
  /// **'Source Port (Optional)'**
  String get sourcePortOptional;

  /// No description provided for @sloppyState.
  ///
  /// In en, this message translates to:
  /// **'Sloppy State'**
  String get sloppyState;

  /// No description provided for @sshEnabled.
  ///
  /// In en, this message translates to:
  /// **'SSH Enabled'**
  String get sshEnabled;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @startService.
  ///
  /// In en, this message translates to:
  /// **'Start Service'**
  String get startService;

  /// No description provided for @startTime.
  ///
  /// In en, this message translates to:
  /// **'Start Time'**
  String get startTime;

  /// No description provided for @startWireguardService.
  ///
  /// In en, this message translates to:
  /// **'Start WireGuard service'**
  String get startWireguardService;

  /// No description provided for @staticKeyContentPemFormat.
  ///
  /// In en, this message translates to:
  /// **'Static key content in PEM format'**
  String get staticKeyContentPemFormat;

  /// No description provided for @staticKeyCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Static key created successfully'**
  String get staticKeyCreatedSuccessfully;

  /// No description provided for @staticKeyDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Static key deleted successfully'**
  String get staticKeyDeletedSuccessfully;

  /// No description provided for @staticKeyDetails.
  ///
  /// In en, this message translates to:
  /// **'Static Key Details'**
  String get staticKeyDetails;

  /// No description provided for @staticKeyInformation.
  ///
  /// In en, this message translates to:
  /// **'Static Key Information'**
  String get staticKeyInformation;

  /// No description provided for @staticKeyUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Static key updated successfully'**
  String get staticKeyUpdatedSuccessfully;

  /// No description provided for @staticKeys.
  ///
  /// In en, this message translates to:
  /// **'Static Keys'**
  String get staticKeys;

  /// No description provided for @staticLease.
  ///
  /// In en, this message translates to:
  /// **'Static'**
  String get staticLease;

  /// No description provided for @stateType.
  ///
  /// In en, this message translates to:
  /// **'State Type'**
  String get stateType;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @stop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stop;

  /// No description provided for @stopService.
  ///
  /// In en, this message translates to:
  /// **'Stop Service'**
  String get stopService;

  /// No description provided for @stopped.
  ///
  /// In en, this message translates to:
  /// **'Stopped'**
  String get stopped;

  /// No description provided for @storeAndGenerateNext.
  ///
  /// In en, this message translates to:
  /// **'Store and Generate Next'**
  String get storeAndGenerateNext;

  /// No description provided for @subnetAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Subnet added successfully'**
  String get subnetAddedSuccessfully;

  /// No description provided for @subnetCidr.
  ///
  /// In en, this message translates to:
  /// **'Subnet (CIDR)'**
  String get subnetCidr;

  /// No description provided for @subnetDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Subnet deleted successfully'**
  String get subnetDeletedSuccessfully;

  /// No description provided for @subnetUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Subnet updated successfully'**
  String get subnetUpdatedSuccessfully;

  /// No description provided for @success.
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
  /// **'Successfully woken {successCount} of {totalCount} {successCount, plural, =1{device} other{devices}}'**
  String successfullyWokenDevices(int successCount, int totalCount);

  /// No description provided for @switchProfile.
  ///
  /// In en, this message translates to:
  /// **'Switch Profile'**
  String get switchProfile;

  /// No description provided for @switchProfileConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to switch profiles? You will be returned to the profile selection screen.'**
  String get switchProfileConfirmation;

  /// No description provided for @systemDefault.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get systemDefault;

  /// No description provided for @systemGeneratedRule.
  ///
  /// In en, this message translates to:
  /// **'This is a system-generated rule and cannot be modified or deleted.'**
  String get systemGeneratedRule;

  /// No description provided for @systemGeneratedRulesCannotBeDeleted.
  ///
  /// In en, this message translates to:
  /// **'System-generated rules cannot be deleted'**
  String get systemGeneratedRulesCannotBeDeleted;

  /// No description provided for @systemGeneratedRulesCannotBeModified.
  ///
  /// In en, this message translates to:
  /// **'System-generated rules cannot be modified'**
  String get systemGeneratedRulesCannotBeModified;

  /// No description provided for @systemInformation.
  ///
  /// In en, this message translates to:
  /// **'System Information'**
  String get systemInformation;

  /// No description provided for @systemType.
  ///
  /// In en, this message translates to:
  /// **'System Type'**
  String get systemType;

  /// No description provided for @swapSourceDestination.
  ///
  /// In en, this message translates to:
  /// **'Swap source and destination'**
  String get swapSourceDestination;

  /// No description provided for @synproxyState.
  ///
  /// In en, this message translates to:
  /// **'Synproxy State'**
  String get synproxyState;

  /// No description provided for @tags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get tags;

  /// No description provided for @tailscaleAuthentication.
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

  /// No description provided for @tailscaleSettings.
  ///
  /// In en, this message translates to:
  /// **'Tailscale Settings'**
  String get tailscaleSettings;

  /// No description provided for @tailscaleStatus.
  ///
  /// In en, this message translates to:
  /// **'Tailscale Status'**
  String get tailscaleStatus;

  /// No description provided for @tailscaleSubnets.
  ///
  /// In en, this message translates to:
  /// **'Tailscale Subnets'**
  String get tailscaleSubnets;

  /// Label for Tailscale version information
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get tailscaleVersion;

  /// No description provided for @tapPlusButtonToCreateFirstInstance.
  ///
  /// In en, this message translates to:
  /// **'Tap the + button to create your first instance'**
  String get tapPlusButtonToCreateFirstInstance;

  /// No description provided for @tapPlusButtonToCreateFirstOverride.
  ///
  /// In en, this message translates to:
  /// **'Tap the + button to create your first override'**
  String get tapPlusButtonToCreateFirstOverride;

  /// No description provided for @tapPlusButtonToCreateFirstStaticKey.
  ///
  /// In en, this message translates to:
  /// **'Tap the + button to create your first static key'**
  String get tapPlusButtonToCreateFirstStaticKey;

  /// No description provided for @tcpFlags.
  ///
  /// In en, this message translates to:
  /// **'TCP Flags'**
  String get tcpFlags;

  /// No description provided for @tenMin.
  ///
  /// In en, this message translates to:
  /// **'10 min'**
  String get tenMin;

  /// No description provided for @testConnection.
  ///
  /// In en, this message translates to:
  /// **'Test Connection'**
  String get testConnection;

  /// No description provided for @testConnections.
  ///
  /// In en, this message translates to:
  /// **'Test Connections'**
  String get testConnections;

  /// No description provided for @testProfile.
  ///
  /// In en, this message translates to:
  /// **'Test Profile'**
  String get testProfile;

  /// No description provided for @testingAllConnections.
  ///
  /// In en, this message translates to:
  /// **'Testing all connection points...'**
  String get testingAllConnections;

  /// Message shown when testing a connection endpoint
  ///
  /// In en, this message translates to:
  /// **'Testing connection {current} of {total}: {endpoint}'**
  String testingConnection(String current, String total, String endpoint);

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @thirtyMin.
  ///
  /// In en, this message translates to:
  /// **'30 min'**
  String get thirtyMin;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @timeRange.
  ///
  /// In en, this message translates to:
  /// **'Time range'**
  String get timeRange;

  /// No description provided for @timeout.
  ///
  /// In en, this message translates to:
  /// **'Request timeout'**
  String get timeout;

  /// No description provided for @timestamp.
  ///
  /// In en, this message translates to:
  /// **'Timestamp'**
  String get timestamp;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @totalBandwidth.
  ///
  /// In en, this message translates to:
  /// **'Total Bandwidth'**
  String get totalBandwidth;

  /// No description provided for @totalDownload.
  ///
  /// In en, this message translates to:
  /// **'Total Download'**
  String get totalDownload;

  /// No description provided for @totalEntries.
  ///
  /// In en, this message translates to:
  /// **'Total Entries'**
  String get totalEntries;

  /// No description provided for @totalUpload.
  ///
  /// In en, this message translates to:
  /// **'Total Upload'**
  String get totalUpload;

  /// No description provided for @totalVpns.
  ///
  /// In en, this message translates to:
  /// **'Total VPNs'**
  String get totalVpns;

  /// No description provided for @tryAdjustingFilters.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting the selected severity or date filters.'**
  String get tryAdjustingFilters;

  /// No description provided for @tryDemoMode.
  ///
  /// In en, this message translates to:
  /// **'Try Demo Mode'**
  String get tryDemoMode;

  /// No description provided for @tryDifferentSearch.
  ///
  /// In en, this message translates to:
  /// **'Try a different search term'**
  String get tryDifferentSearch;

  /// No description provided for @tunnelAddress.
  ///
  /// In en, this message translates to:
  /// **'Tunnel Address'**
  String get tunnelAddress;

  /// No description provided for @tunnelAddressCidr.
  ///
  /// In en, this message translates to:
  /// **'Tunnel Address (CIDR)'**
  String get tunnelAddressCidr;

  /// No description provided for @tunnelAddresses.
  ///
  /// In en, this message translates to:
  /// **'Tunnel Addresses'**
  String get tunnelAddresses;

  /// No description provided for @tunnelLabel.
  ///
  /// In en, this message translates to:
  /// **'Tunnel: {network}'**
  String tunnelLabel(String network);

  /// No description provided for @tunnelNetwork.
  ///
  /// In en, this message translates to:
  /// **'Tunnel Network'**
  String get tunnelNetwork;

  /// No description provided for @tunnelSettings.
  ///
  /// In en, this message translates to:
  /// **'Tunnel Settings'**
  String get tunnelSettings;

  /// No description provided for @twoMin.
  ///
  /// In en, this message translates to:
  /// **'2 min'**
  String get twoMin;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @typeWithValue.
  ///
  /// In en, this message translates to:
  /// **'Type: {value}'**
  String typeWithValue(String value);

  /// No description provided for @udpPortDefault51820.
  ///
  /// In en, this message translates to:
  /// **'UDP port (default: 51820)'**
  String get udpPortDefault51820;

  /// No description provided for @unableToAccessFilePath.
  ///
  /// In en, this message translates to:
  /// **'Unable to access file path'**
  String get unableToAccessFilePath;

  /// No description provided for @unableToConnectToAnyEndpoint.
  ///
  /// In en, this message translates to:
  /// **'Unable to connect to any configured endpoints. Please check your network settings and try again.'**
  String get unableToConnectToAnyEndpoint;

  /// No description provided for @unauthorized.
  ///
  /// In en, this message translates to:
  /// **'Unauthorized access'**
  String get unauthorized;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @unlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get unlock;

  /// No description provided for @unlockOpnsenseManager.
  ///
  /// In en, this message translates to:
  /// **'Unlock OPNsense Manager'**
  String get unlockOpnsenseManager;

  /// No description provided for @unnamedHost.
  ///
  /// In en, this message translates to:
  /// **'Unnamed Host'**
  String get unnamedHost;

  /// No description provided for @unnamedInstance.
  ///
  /// In en, this message translates to:
  /// **'Unnamed Instance'**
  String get unnamedInstance;

  /// No description provided for @unnamedRule.
  ///
  /// In en, this message translates to:
  /// **'Unnamed Rule'**
  String get unnamedRule;

  /// No description provided for @unsavedChanges.
  ///
  /// In en, this message translates to:
  /// **'Unsaved Changes'**
  String get unsavedChanges;

  /// No description provided for @unsavedChangesConfirmation.
  ///
  /// In en, this message translates to:
  /// **'You have unsaved changes. Do you want to discard them and continue?'**
  String get unsavedChangesConfirmation;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @updateOverride.
  ///
  /// In en, this message translates to:
  /// **'Update Override'**
  String get updateOverride;

  /// No description provided for @updatePeer.
  ///
  /// In en, this message translates to:
  /// **'Update Peer'**
  String get updatePeer;

  /// No description provided for @updatePinCode.
  ///
  /// In en, this message translates to:
  /// **'Update your PIN code'**
  String get updatePinCode;

  /// No description provided for @updateRule.
  ///
  /// In en, this message translates to:
  /// **'Update Rule'**
  String get updateRule;

  /// No description provided for @updateServer.
  ///
  /// In en, this message translates to:
  /// **'Update Server'**
  String get updateServer;

  /// No description provided for @updateStaticKey.
  ///
  /// In en, this message translates to:
  /// **'Update Static Key'**
  String get updateStaticKey;

  /// No description provided for @upload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get upload;

  /// No description provided for @uptime.
  ///
  /// In en, this message translates to:
  /// **'Uptime'**
  String get uptime;

  /// No description provided for @useBiometric.
  ///
  /// In en, this message translates to:
  /// **'Use Biometric'**
  String get useBiometric;

  /// No description provided for @useBiometricToUnlock.
  ///
  /// In en, this message translates to:
  /// **'Use {biometricType} to unlock app'**
  String useBiometricToUnlock(String biometricType);

  /// No description provided for @useExitNode.
  ///
  /// In en, this message translates to:
  /// **'Use Exit Node'**
  String get useExitNode;

  /// No description provided for @useHttps.
  ///
  /// In en, this message translates to:
  /// **'Use HTTPS'**
  String get useHttps;

  /// No description provided for @useHttpsDescription.
  ///
  /// In en, this message translates to:
  /// **'Use secure HTTPS connection'**
  String get useHttpsDescription;

  /// No description provided for @useProtocolForCommunicating.
  ///
  /// In en, this message translates to:
  /// **'Use this protocol for communicating'**
  String get useProtocolForCommunicating;

  /// No description provided for @valid.
  ///
  /// In en, this message translates to:
  /// **'Valid'**
  String get valid;

  /// No description provided for @validFrom.
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

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @viewFullLicense.
  ///
  /// In en, this message translates to:
  /// **'View Full License'**
  String get viewFullLicense;

  /// No description provided for @virtualAddress.
  ///
  /// In en, this message translates to:
  /// **'Virtual Address'**
  String get virtualAddress;

  /// No description provided for @vpn.
  ///
  /// In en, this message translates to:
  /// **'VPN'**
  String get vpn;

  /// No description provided for @vpnConnections.
  ///
  /// In en, this message translates to:
  /// **'VPN Connections'**
  String get vpnConnections;

  /// No description provided for @vpnConnectionsWillAppear.
  ///
  /// In en, this message translates to:
  /// **'VPN connections will appear here when configured'**
  String get vpnConnectionsWillAppear;

  /// No description provided for @vpnStatus.
  ///
  /// In en, this message translates to:
  /// **'VPN Status'**
  String get vpnStatus;

  /// No description provided for @vpnType.
  ///
  /// In en, this message translates to:
  /// **'VPN Type'**
  String get vpnType;

  /// No description provided for @wakeAll.
  ///
  /// In en, this message translates to:
  /// **'Wake All'**
  String get wakeAll;

  /// No description provided for @wakeAllDevices.
  ///
  /// In en, this message translates to:
  /// **'Wake All Devices'**
  String get wakeAllDevices;

  /// No description provided for @wakeAllDevicesConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to send wake packets to all configured devices?'**
  String get wakeAllDevicesConfirmation;

  /// No description provided for @wakeAllResults.
  ///
  /// In en, this message translates to:
  /// **'Wake All Results'**
  String get wakeAllResults;

  /// No description provided for @wakeHost.
  ///
  /// In en, this message translates to:
  /// **'Wake Host'**
  String get wakeHost;

  /// No description provided for @wakeOnLan.
  ///
  /// In en, this message translates to:
  /// **'Wake on LAN'**
  String get wakeOnLan;

  /// No description provided for @wakingAllDevices.
  ///
  /// In en, this message translates to:
  /// **'Waking all devices...'**
  String get wakingAllDevices;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// No description provided for @winsServers.
  ///
  /// In en, this message translates to:
  /// **'WINS Servers'**
  String get winsServers;

  /// No description provided for @winsServersHelperText.
  ///
  /// In en, this message translates to:
  /// **'Set primary WINS server address (NetBIOS over TCP/IP Name Server). Repeat this option to set secondary WINS server addresses.'**
  String get winsServersHelperText;

  /// No description provided for @wireguardLogs.
  ///
  /// In en, this message translates to:
  /// **'WireGuard Logs'**
  String get wireguardLogs;

  /// No description provided for @wireguardLogsExport.
  ///
  /// In en, this message translates to:
  /// **'WireGuard Logs Export'**
  String get wireguardLogsExport;

  /// No description provided for @wireguardLogsExportedOn.
  ///
  /// In en, this message translates to:
  /// **'WireGuard logs exported on {date}'**
  String wireguardLogsExportedOn(String date);

  /// No description provided for @wireguardPeers.
  ///
  /// In en, this message translates to:
  /// **'WireGuard Peers'**
  String get wireguardPeers;

  /// No description provided for @wireguardServers.
  ///
  /// In en, this message translates to:
  /// **'WireGuard Servers'**
  String get wireguardServers;

  /// No description provided for @wireguardServiceStarted.
  ///
  /// In en, this message translates to:
  /// **'WireGuard service started'**
  String get wireguardServiceStarted;

  /// No description provided for @wireguardServiceStopped.
  ///
  /// In en, this message translates to:
  /// **'WireGuard service stopped'**
  String get wireguardServiceStopped;

  /// No description provided for @wireguardStatus.
  ///
  /// In en, this message translates to:
  /// **'WireGuard Status'**
  String get wireguardStatus;

  /// No description provided for @withoutCredentials.
  ///
  /// In en, this message translates to:
  /// **'Without Credentials'**
  String get withoutCredentials;

  /// Success message when WOL packet is sent
  ///
  /// In en, this message translates to:
  /// **'WOL packet sent to {host}'**
  String wolPacketSentTo(String host);

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @zeroSeconds.
  ///
  /// In en, this message translates to:
  /// **'0 seconds'**
  String get zeroSeconds;

  /// No description provided for @connectionBlockingDescription.
  ///
  /// In en, this message translates to:
  /// **'Block this client connection based on its common name. Don\'t use this option to permanently disable a client due to a compromised key or password. Use a CRL (certificate revocation list) instead.'**
  String get connectionBlockingDescription;

  /// No description provided for @deviceLabel.
  ///
  /// In en, this message translates to:
  /// **'Device: {type}'**
  String deviceLabel(String type);

  /// No description provided for @facility.
  ///
  /// In en, this message translates to:
  /// **'Facility'**
  String get facility;

  /// No description provided for @gatewayLabel.
  ///
  /// In en, this message translates to:
  /// **'Gateway: {gateway}'**
  String gatewayLabel(String gateway);

  /// No description provided for @localLabel.
  ///
  /// In en, this message translates to:
  /// **'Local: {address}'**
  String localLabel(String address);

  /// No description provided for @messageLabel.
  ///
  /// In en, this message translates to:
  /// **'Message:'**
  String get messageLabel;

  /// No description provided for @pageOfTotal.
  ///
  /// In en, this message translates to:
  /// **'Page {current} of {total}'**
  String pageOfTotal(int current, int total);

  /// No description provided for @parser.
  ///
  /// In en, this message translates to:
  /// **'Parser'**
  String get parser;

  /// No description provided for @pidLabel.
  ///
  /// In en, this message translates to:
  /// **'PID: {pid}'**
  String pidLabel(String pid);

  /// No description provided for @processLabel.
  ///
  /// In en, this message translates to:
  /// **'Process: {process}'**
  String processLabel(String process);

  /// No description provided for @pushResetDescription.
  ///
  /// In en, this message translates to:
  /// **'Don\'t inherit the global push list for a specific client instance. NOTE: --push-reset is very thorough: it will remove almost all options from the list of to-be-pushed options. In many cases, some of these options will need to be re-configured afterwards - specifically, --topology subnet and --route-gateway will get lost and this will break client configs in many cases.'**
  String get pushResetDescription;

  /// No description provided for @record.
  ///
  /// In en, this message translates to:
  /// **'Record'**
  String get record;

  /// No description provided for @redirectGatewayDescription.
  ///
  /// In en, this message translates to:
  /// **'Automatically execute routing commands to cause all outgoing IP traffic to be redirected over the VPN.'**
  String get redirectGatewayDescription;

  /// No description provided for @registerDnsDescription.
  ///
  /// In en, this message translates to:
  /// **'Run ipconfig /flushdns and ipconfig /registerdns on connection initiation. This is known to kick Windows into recognizing pushed DNS servers.'**
  String get registerDnsDescription;

  /// No description provided for @remoteLabel.
  ///
  /// In en, this message translates to:
  /// **'Remote: {info}'**
  String remoteLabel(String info);

  /// No description provided for @selectedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String selectedCount(int count);

  /// No description provided for @serverLabel.
  ///
  /// In en, this message translates to:
  /// **'Server: {info}'**
  String serverLabel(String info);

  /// No description provided for @severityLabel.
  ///
  /// In en, this message translates to:
  /// **'Severity: {severity}'**
  String severityLabel(String severity);

  /// No description provided for @showingEntries.
  ///
  /// In en, this message translates to:
  /// **'Showing {start} to {end}'**
  String showingEntries(int start, int end);

  /// No description provided for @timestampLabel.
  ///
  /// In en, this message translates to:
  /// **'Timestamp: {timestamp}'**
  String timestampLabel(String timestamp);

  /// No description provided for @typeLabel.
  ///
  /// In en, this message translates to:
  /// **'Type: {type}'**
  String typeLabel(String type);

  /// No description provided for @unknownNetwork.
  ///
  /// In en, this message translates to:
  /// **'Unknown Network'**
  String get unknownNetwork;

  /// Memory label for actual used amount
  ///
  /// In en, this message translates to:
  /// **'Actual Used'**
  String get actualUsed;

  /// Memory label for ARC cache
  ///
  /// In en, this message translates to:
  /// **'ARC Cache'**
  String get arcCache;

  /// Banner text shown when app is in demo mode
  ///
  /// In en, this message translates to:
  /// **'Demo Mode - Showing sample data'**
  String get demoModeIndicator;

  /// Section title for thermal sensors
  ///
  /// In en, this message translates to:
  /// **'Thermal Sensors'**
  String get thermalSensors;

  /// Shown when no thermal sensors are found
  ///
  /// In en, this message translates to:
  /// **'No thermal sensors available'**
  String get noThermalSensorsAvailable;

  /// Tooltip to collapse all sections
  ///
  /// In en, this message translates to:
  /// **'Collapse All'**
  String get collapseAll;

  /// Tooltip to expand all sections
  ///
  /// In en, this message translates to:
  /// **'Expand All'**
  String get expandAll;

  /// Loading message while saving an OpenVPN instance
  ///
  /// In en, this message translates to:
  /// **'Saving instance...'**
  String get savingInstance;

  /// Helper text for the static key description field
  ///
  /// In en, this message translates to:
  /// **'A descriptive name for this static key'**
  String get staticKeyDescriptionHelper;

  /// Helper text for the static key mode dropdown
  ///
  /// In en, this message translates to:
  /// **'Select the key mode for authentication or encryption'**
  String get selectKeyModeHelper;

  /// Multi-line help text in the static key form info card
  ///
  /// In en, this message translates to:
  /// **'• Auth: Adds HMAC authentication to control channel\n• Crypt: Encrypts and authenticates all control channel packets\n• Crypt V2: Enhanced encryption with improved security\n\nYou can generate a new key or paste an existing one.'**
  String get staticKeyHelpText;

  /// Label for device/interface row
  ///
  /// In en, this message translates to:
  /// **'Device'**
  String get device;

  /// Label for listen port row in WireGuard status
  ///
  /// In en, this message translates to:
  /// **'Listen Port'**
  String get listenPort;

  /// Label for firewall mark row in WireGuard status
  ///
  /// In en, this message translates to:
  /// **'FW Mark'**
  String get fwMark;

  /// Label for peer status row in WireGuard status
  ///
  /// In en, this message translates to:
  /// **'Peer Status'**
  String get peerStatus;

  /// Label for handshake age row in WireGuard status
  ///
  /// In en, this message translates to:
  /// **'Handshake Age'**
  String get handshakeAge;

  /// Displays elapsed time in seconds
  ///
  /// In en, this message translates to:
  /// **'{count} seconds ago'**
  String secondsAgo(int count);

  /// Label for handshake timestamp row in WireGuard status
  ///
  /// In en, this message translates to:
  /// **'Handshake'**
  String get handshake;

  /// Section header for process information in log detail
  ///
  /// In en, this message translates to:
  /// **'Process Information'**
  String get processInformation;

  /// Label for process name row in log detail
  ///
  /// In en, this message translates to:
  /// **'Process Name'**
  String get processName;

  /// Label for process ID row in log detail
  ///
  /// In en, this message translates to:
  /// **'Process ID'**
  String get processId;

  /// Section header for log message in log detail
  ///
  /// In en, this message translates to:
  /// **'Log Message'**
  String get logMessage;

  /// Label for message row in log detail
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// Section header for timestamp information in log detail
  ///
  /// In en, this message translates to:
  /// **'Timestamp Information'**
  String get timestampInformation;

  /// Label for raw timestamp row in log detail
  ///
  /// In en, this message translates to:
  /// **'Raw Timestamp'**
  String get rawTimestamp;

  /// No description provided for @organisationSection.
  ///
  /// In en, this message translates to:
  /// **'Organisation'**
  String get organisationSection;

  /// No description provided for @interfaceSection.
  ///
  /// In en, this message translates to:
  /// **'Interface'**
  String get interfaceSection;

  /// No description provided for @filterSection.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filterSection;

  /// No description provided for @sourceRoutingSection.
  ///
  /// In en, this message translates to:
  /// **'Source Routing'**
  String get sourceRoutingSection;

  /// No description provided for @statefulFirewallSection.
  ///
  /// In en, this message translates to:
  /// **'Stateful Firewall'**
  String get statefulFirewallSection;

  /// No description provided for @trafficShapingSection.
  ///
  /// In en, this message translates to:
  /// **'Traffic Shaping'**
  String get trafficShapingSection;

  /// No description provided for @prioritySection.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get prioritySection;

  /// No description provided for @internalTaggingSection.
  ///
  /// In en, this message translates to:
  /// **'Internal Tagging'**
  String get internalTaggingSection;

  /// No description provided for @showAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Show Advanced'**
  String get showAdvanced;

  /// No description provided for @hideAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Hide Advanced'**
  String get hideAdvanced;

  /// No description provided for @enableThisRule.
  ///
  /// In en, this message translates to:
  /// **'Enable this rule'**
  String get enableThisRule;

  /// No description provided for @categoriesLabel.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categoriesLabel;

  /// No description provided for @categoriesHint.
  ///
  /// In en, this message translates to:
  /// **'For grouping purposes you may select multiple groups here.'**
  String get categoriesHint;

  /// No description provided for @invertInterface.
  ///
  /// In en, this message translates to:
  /// **'Invert Interface'**
  String get invertInterface;

  /// No description provided for @invertInterfaceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use all but selected interfaces'**
  String get invertInterfaceSubtitle;

  /// No description provided for @quickRuleHelp.
  ///
  /// In en, this message translates to:
  /// **'If a packet matches a rule specifying quick, then that rule is considered the last matching rule and the specified action is taken.'**
  String get quickRuleHelp;

  /// No description provided for @actionHelp.
  ///
  /// In en, this message translates to:
  /// **'Choose what to do with packets that match the criteria specified below.'**
  String get actionHelp;

  /// No description provided for @directionHelp.
  ///
  /// In en, this message translates to:
  /// **'Direction of the traffic. The default policy is to filter inbound traffic.'**
  String get directionHelp;

  /// No description provided for @fwVersionLabel.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get fwVersionLabel;

  /// No description provided for @icmpTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'ICMP Type'**
  String get icmpTypeLabel;

  /// No description provided for @sourcePortHelp.
  ///
  /// In en, this message translates to:
  /// **'Source port number or well known name (imap, imaps, http, https, ...), for ranges use a dash'**
  String get sourcePortHelp;

  /// No description provided for @destinationPortHelp.
  ///
  /// In en, this message translates to:
  /// **'Destination port number or well known name (imap, imaps, http, https, ...), for ranges use a dash'**
  String get destinationPortHelp;

  /// No description provided for @logHelp.
  ///
  /// In en, this message translates to:
  /// **'Log packets that are handled by this rule'**
  String get logHelp;

  /// No description provided for @fwGatewayLabel.
  ///
  /// In en, this message translates to:
  /// **'Gateway'**
  String get fwGatewayLabel;

  /// No description provided for @gatewayHelp.
  ///
  /// In en, this message translates to:
  /// **'Leave as default to use the system routing table. Or choose a gateway to utilize policy based routing.'**
  String get gatewayHelp;

  /// No description provided for @sequenceLabel.
  ///
  /// In en, this message translates to:
  /// **'Sequence'**
  String get sequenceLabel;

  /// No description provided for @sequenceHelp.
  ///
  /// In en, this message translates to:
  /// **'The order in which rules are being processed.'**
  String get sequenceHelp;

  /// No description provided for @noXmlrpcSync.
  ///
  /// In en, this message translates to:
  /// **'No XMLRPC Sync'**
  String get noXmlrpcSync;

  /// No description provided for @noXmlrpcSyncHelp.
  ///
  /// In en, this message translates to:
  /// **'Exclude this item from the HA synchronization process.'**
  String get noXmlrpcSyncHelp;

  /// No description provided for @allowOptionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Allow Options'**
  String get allowOptionsLabel;

  /// No description provided for @allowOptionsHelp.
  ///
  /// In en, this message translates to:
  /// **'This allows packets with IP options to pass.'**
  String get allowOptionsHelp;

  /// No description provided for @tcpFlagsLabel.
  ///
  /// In en, this message translates to:
  /// **'TCP Flags'**
  String get tcpFlagsLabel;

  /// No description provided for @tcpFlagsOutLabel.
  ///
  /// In en, this message translates to:
  /// **'TCP Flags [out of]'**
  String get tcpFlagsOutLabel;

  /// No description provided for @tcpFlagsAnyLabel.
  ///
  /// In en, this message translates to:
  /// **'TCP Flags Any'**
  String get tcpFlagsAnyLabel;

  /// No description provided for @scheduleLabel.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get scheduleLabel;

  /// No description provided for @divertToLabel.
  ///
  /// In en, this message translates to:
  /// **'Divert-to'**
  String get divertToLabel;

  /// No description provided for @divertToHelp.
  ///
  /// In en, this message translates to:
  /// **'Send packets matching this rule to the service specified.'**
  String get divertToHelp;

  /// No description provided for @statePolicyLabel.
  ///
  /// In en, this message translates to:
  /// **'State Policy'**
  String get statePolicyLabel;

  /// No description provided for @noPfsyncLabel.
  ///
  /// In en, this message translates to:
  /// **'No pfsync'**
  String get noPfsyncLabel;

  /// No description provided for @noPfsyncHelp.
  ///
  /// In en, this message translates to:
  /// **'Prevents states created by this rule to be synced with pfsync.'**
  String get noPfsyncHelp;

  /// No description provided for @tcpEstablishedLabel.
  ///
  /// In en, this message translates to:
  /// **'TCP Established'**
  String get tcpEstablishedLabel;

  /// No description provided for @udpFirstLabel.
  ///
  /// In en, this message translates to:
  /// **'UDP First'**
  String get udpFirstLabel;

  /// No description provided for @udpSingleLabel.
  ///
  /// In en, this message translates to:
  /// **'UDP Single'**
  String get udpSingleLabel;

  /// No description provided for @udpMultipleLabel.
  ///
  /// In en, this message translates to:
  /// **'UDP Multiple'**
  String get udpMultipleLabel;

  /// No description provided for @adaptiveStartLabel.
  ///
  /// In en, this message translates to:
  /// **'Adaptive Start'**
  String get adaptiveStartLabel;

  /// No description provided for @adaptiveEndLabel.
  ///
  /// In en, this message translates to:
  /// **'Adaptive End'**
  String get adaptiveEndLabel;

  /// No description provided for @maxStatesLabel.
  ///
  /// In en, this message translates to:
  /// **'Max States'**
  String get maxStatesLabel;

  /// No description provided for @maxSrcNodesLabel.
  ///
  /// In en, this message translates to:
  /// **'Max Source Nodes'**
  String get maxSrcNodesLabel;

  /// No description provided for @maxSrcStatesLabel.
  ///
  /// In en, this message translates to:
  /// **'Max Source States'**
  String get maxSrcStatesLabel;

  /// No description provided for @maxSrcConnLabel.
  ///
  /// In en, this message translates to:
  /// **'Max Source Connections'**
  String get maxSrcConnLabel;

  /// No description provided for @maxNewConnCLabel.
  ///
  /// In en, this message translates to:
  /// **'Max New Connections [c]'**
  String get maxNewConnCLabel;

  /// No description provided for @maxNewConnSLabel.
  ///
  /// In en, this message translates to:
  /// **'Max New Connections [s]'**
  String get maxNewConnSLabel;

  /// No description provided for @overloadTableLabel.
  ///
  /// In en, this message translates to:
  /// **'Overload Table'**
  String get overloadTableLabel;

  /// No description provided for @overloadTableHelp.
  ///
  /// In en, this message translates to:
  /// **'Overload table used when max new connections per time interval has been reached.'**
  String get overloadTableHelp;

  /// No description provided for @shaperLabel.
  ///
  /// In en, this message translates to:
  /// **'Traffic Shaper'**
  String get shaperLabel;

  /// No description provided for @shaperReverseLabel.
  ///
  /// In en, this message translates to:
  /// **'Traffic Shaper [reverse]'**
  String get shaperReverseLabel;

  /// No description provided for @disableReplyToLabel.
  ///
  /// In en, this message translates to:
  /// **'Disable Reply-to'**
  String get disableReplyToLabel;

  /// No description provided for @disableReplyToHelp.
  ///
  /// In en, this message translates to:
  /// **'Explicit disable reply-to for this rule'**
  String get disableReplyToHelp;

  /// No description provided for @replyToLabel.
  ///
  /// In en, this message translates to:
  /// **'Reply-to'**
  String get replyToLabel;

  /// No description provided for @replyToHelp.
  ///
  /// In en, this message translates to:
  /// **'Determines how packets route back in the opposite direction.'**
  String get replyToHelp;

  /// No description provided for @matchPriorityLabel.
  ///
  /// In en, this message translates to:
  /// **'Match Priority'**
  String get matchPriorityLabel;

  /// No description provided for @setPriorityLabel.
  ///
  /// In en, this message translates to:
  /// **'Set Priority'**
  String get setPriorityLabel;

  /// No description provided for @setPriorityLowLabel.
  ///
  /// In en, this message translates to:
  /// **'Set Priority [low-delay]'**
  String get setPriorityLowLabel;

  /// No description provided for @matchTosLabel.
  ///
  /// In en, this message translates to:
  /// **'Match TOS / DSCP'**
  String get matchTosLabel;

  /// No description provided for @setLocalTagLabel.
  ///
  /// In en, this message translates to:
  /// **'Set Local Tag'**
  String get setLocalTagLabel;

  /// No description provided for @setLocalTagHelp.
  ///
  /// In en, this message translates to:
  /// **'Packets matching this rule will be tagged with the specified string.'**
  String get setLocalTagHelp;

  /// No description provided for @matchLocalTagLabel.
  ///
  /// In en, this message translates to:
  /// **'Match Local Tag'**
  String get matchLocalTagLabel;

  /// No description provided for @matchLocalTagHelp.
  ///
  /// In en, this message translates to:
  /// **'Packets must already be tagged with the given tag to match the rule.'**
  String get matchLocalTagHelp;

  /// No description provided for @singleHostOrNetwork.
  ///
  /// In en, this message translates to:
  /// **'Single host or network'**
  String get singleHostOrNetwork;

  /// No description provided for @singlePortOrRange.
  ///
  /// In en, this message translates to:
  /// **'Single port or range'**
  String get singlePortOrRange;

  /// No description provided for @thisFirwall.
  ///
  /// In en, this message translates to:
  /// **'This Firewall'**
  String get thisFirwall;

  /// No description provided for @interfaceNet.
  ///
  /// In en, this message translates to:
  /// **'{name} net'**
  String interfaceNet(String name);

  /// No description provided for @interfaceAddress.
  ///
  /// In en, this message translates to:
  /// **'{name} address'**
  String interfaceAddress(String name);

  /// No description provided for @sortOrderLabel.
  ///
  /// In en, this message translates to:
  /// **'Sort Order'**
  String get sortOrderLabel;

  /// No description provided for @sortOrderHelp.
  ///
  /// In en, this message translates to:
  /// **'The order in which rules are being processed (auto-calculated, read-only).'**
  String get sortOrderHelp;
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
