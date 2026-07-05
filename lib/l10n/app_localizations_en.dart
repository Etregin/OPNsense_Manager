// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get about => 'About';

  @override
  String get aboutDescription =>
      'A professional Flutter mobile application for managing OPNsense firewall routers.';

  @override
  String get aboutImportExport => 'About Import & Export';

  @override
  String get acceptDns => 'Accept DNS';

  @override
  String get acceptDnsDescription => 'Use DNS servers provided by Tailscale';

  @override
  String get acceptRoutes => 'Accept Routes';

  @override
  String get acceptSubnetRoutes => 'Accept Subnet Routes';

  @override
  String get acceptSubnetRoutesDescription =>
      'Accept routes advertised by other nodes';

  @override
  String get action => 'Action';

  @override
  String actionService(String action) {
    return '$action Service';
  }

  @override
  String actioningService(String action, String name) {
    return '$action $name...';
  }

  @override
  String get activate => 'Activate';

  @override
  String activatedProfile(String name) {
    return 'Activated profile: $name';
  }

  @override
  String get activatingProfile => 'Activating profile...';

  @override
  String get activationFailed => 'Activation failed';

  @override
  String get active => 'Active';

  @override
  String get activeDevices => 'Active Devices';

  @override
  String activeHosts(int count) {
    return '$count active host(s)';
  }

  @override
  String get activeProfile => 'Active Profile';

  @override
  String get add => 'Add';

  @override
  String get addClientOverride => 'Add Client Override';

  @override
  String get addConnection => 'Add Connection';

  @override
  String get addConnectionEndpoint =>
      'Please add at least one connection endpoint';

  @override
  String get addDnsServer => 'Add DNS Server';

  @override
  String get addHost => 'Add Host';

  @override
  String get addHostToGetStarted => 'Add a host to get started';

  @override
  String get addInstance => 'Add Instance';

  @override
  String get addOpenVpnInstance => 'Add OpenVPN Instance';

  @override
  String get addOverride => 'Add Override';

  @override
  String get addProfile => 'Add Profile';

  @override
  String get addProfileToManageInstances =>
      'Add a profile to manage OPNsense instances';

  @override
  String get addStaticKey => 'Add Static Key';

  @override
  String get addStaticKeyTooltip => 'Add Static Key';

  @override
  String get addSubnet => 'Add Subnet';

  @override
  String get addTunnelAddress => 'Add Tunnel Address';

  @override
  String get additionalInformation => 'Additional Information';

  @override
  String get address => 'Address';

  @override
  String get addressIsRequired => 'Address is required';

  @override
  String get advertiseExitNode => 'Advertise Exit Node';

  @override
  String get advertiseExitNodeDescription =>
      'Allow other devices to route through this node';

  @override
  String get advertiseRoutes => 'Advertise Routes';

  @override
  String get alert => 'Alert';

  @override
  String get aliasDeletedSuccessfully => 'Alias deleted successfully';

  @override
  String get aliasDisabledSuccessfully => 'Alias disabled successfully';

  @override
  String get aliasEnabledSuccessfully => 'Alias enabled successfully';

  @override
  String get aliases => 'Aliases';

  @override
  String get all => 'All';

  @override
  String get allConnectionsSuccessful => 'All connections tested successfully';

  @override
  String get allDetailsCopiedToClipboard => 'All details copied to clipboard';

  @override
  String get allRoles => 'All Roles';

  @override
  String get allSettingsSavedSuccessfully => 'All settings saved successfully';

  @override
  String get allStatus => 'All Status';

  @override
  String get allTypes => 'All Types';

  @override
  String get allVpns => 'All VPNs';

  @override
  String get allowSelfSigned => 'Allow Self-Signed Certificate';

  @override
  String get allowSelfSignedCertificates => 'Allow Self-Signed Certificates';

  @override
  String get allowSelfSignedCertificatesDescription =>
      'Accept self-signed SSL certificates';

  @override
  String get allowedIps => 'Allowed IPs';

  @override
  String get any => 'Any';

  @override
  String get anyIpAddressCidrOrAlias => 'any, IP address, CIDR, or alias';

  @override
  String get anyPortNumberRangeOrAlias => 'any, port number, range, or alias';

  @override
  String apiError(String message) {
    return 'API Error: $message';
  }

  @override
  String get apiKey => 'API Key';

  @override
  String get apiKeyIsRequired => 'API Key is required';

  @override
  String get apiSecret => 'API Secret';

  @override
  String get apiSecretIsRequired => 'API Secret is required';

  @override
  String get appearance => 'Appearance';

  @override
  String get apply => 'Apply';

  @override
  String get architecture => 'Architecture';

  @override
  String get atLeastOneTunnelAddressRequired =>
      'At least one tunnel address is required';

  @override
  String get authSettingsSavedSuccessfully =>
      'Authentication settings saved successfully';

  @override
  String get authTlsAuthentication => 'Auth (TLS Authentication)';

  @override
  String get authTokenGeneratedSuccessfully =>
      'Auth token generated successfully';

  @override
  String get authenticate => 'Authenticate';

  @override
  String get authenticateToUnlock => 'Authenticate to unlock the app';

  @override
  String get authentication => 'Authentication';

  @override
  String get authenticationFailed => 'Authentication failed';

  @override
  String get authenticationRequired => 'Authentication Required';

  @override
  String get authenticationSettings => 'Authentication Settings';

  @override
  String get authenticated => 'Authenticated';

  @override
  String get notAuthenticated => 'Not Authenticated';

  @override
  String get tailnet => 'Tailnet';

  @override
  String get deviceName => 'Device Name';

  @override
  String get authUrl => 'Auth URL';

  @override
  String get user => 'User';

  @override
  String get authorizedPeers => 'Authorized Peers';

  @override
  String get autoRefresh => 'Auto Refresh';

  @override
  String get backendState => 'Backend State';

  @override
  String get bandwidthLimit => 'Bandwidth Limit';

  @override
  String get bandwidthLimitMbps => 'Bandwidth Limit (Mbps)';

  @override
  String get base64EncodedPrivateKeyKeepSecret =>
      'Base64-encoded private key (keep secret!)';

  @override
  String get base64EncodedPublicKey => 'Base64-encoded public key';

  @override
  String get biometricAuth => 'Biometric Authentication';

  @override
  String get biometricAuthFailed =>
      'Biometric authentication failed or was cancelled';

  @override
  String get biometricLockDisabled => 'Biometric lock disabled';

  @override
  String get biometricLockEnabled => 'Biometric lock enabled';

  @override
  String biometricLockTitle(String biometricType) {
    return '$biometricType Lock';
  }

  @override
  String get biometricNotAvailable =>
      'Biometric authentication is not available on this device';

  @override
  String get block => 'Block';

  @override
  String get blockHost => 'Block Host';

  @override
  String blockHostConfirmation(String hostname, String ip) {
    return 'Are you sure you want to block $hostname ($ip)?\n\nThis will create a firewall rule to block all traffic from this host.';
  }

  @override
  String get blockingHost => 'Blocking host...';

  @override
  String get bytesReceived => 'Bytes Received';

  @override
  String get bytesSent => 'Bytes Sent';

  @override
  String get cancel => 'Cancel';

  @override
  String get cannotBeUndone => 'This action cannot be undone.';

  @override
  String get cannotDeleteLastConnection =>
      'Cannot delete the last connection endpoint';

  @override
  String get cannotDeleteLastConnectionTooltip =>
      'Cannot delete the last connection endpoint';

  @override
  String get carpVhidToDepend => 'CARP VHID to depend on';

  @override
  String get categories => 'Categories';

  @override
  String get changePin => 'Change PIN';

  @override
  String get changesDiscarded => 'Changes discarded';

  @override
  String get checkIfWireguardIsConfiguredAndRunning =>
      'Check if WireGuard is configured and running';

  @override
  String get chooseExportLocation => 'Choose Export Location';

  @override
  String get cidrNotationRequired => 'CIDR notation is required';

  @override
  String get clearLogs => 'Clear Logs';

  @override
  String get clearSelection => 'Clear selection';

  @override
  String get client => 'Client';

  @override
  String get clientAddress => 'Client Address';

  @override
  String get clientName => 'Client name';

  @override
  String get clientOverrides => 'Client Overrides';

  @override
  String get clientSettings => 'Client Settings';

  @override
  String get clientSpecificOverrides => 'Client Specific Overrides';

  @override
  String get clientX509CommonNameHelper =>
      'Enter the client\'s X.509 common name here.';

  @override
  String get close => 'Close';

  @override
  String get commonName => 'Common name';

  @override
  String get commonNameRequired => 'Common name is required';

  @override
  String commonNameWithValue(String value) {
    return 'Common Name: $value';
  }

  @override
  String get configurationAppliedSuccessfully =>
      'Configuration applied successfully';

  @override
  String get configurationPreview => 'Configuration Preview';

  @override
  String get configureAdvertisedSubnets => 'Configure advertised subnets';

  @override
  String get configured => 'Configured';

  @override
  String get confirmDelete => 'Confirm Delete';

  @override
  String confirmDeleteInstance(String name) {
    return 'Are you sure you want to delete instance \"$name\"? This action cannot be undone.';
  }

  @override
  String confirmDeleteOverride(String name) {
    return 'Are you sure you want to delete override for \"$name\"? This action cannot be undone.';
  }

  @override
  String confirmDeleteStaticKey(String name) {
    return 'Are you sure you want to delete static key \"$name\"? This action cannot be undone.';
  }

  @override
  String get confirmNewPin => 'Confirm New PIN';

  @override
  String get confirmPin => 'Confirm PIN';

  @override
  String confirmServiceAction(String action, String name) {
    return '$action \"$name\"?';
  }

  @override
  String get connect => 'Connect';

  @override
  String get connectToYourOpnsenseFirewall =>
      'Connect to your OPNsense firewall';

  @override
  String get connectVpn => 'Connect VPN';

  @override
  String get connected => 'Connected';

  @override
  String get connectedSince => 'Connected Since';

  @override
  String connectedSuccessfullyVia(String endpoint) {
    return 'Connected successfully via: $endpoint';
  }

  @override
  String connectingVPN(String name) {
    return 'Connecting $name...';
  }

  @override
  String get connectionBlocking => 'Connection blocking';

  @override
  String get connectionDetails => 'Connection Details';

  @override
  String get connectionEndpoints => 'Connection Endpoints';

  @override
  String get connectionEndpointsHelp =>
      'Manage multiple connection endpoints for this profile. The app will try each endpoint in order until a successful connection is established.';

  @override
  String get connectionFailed =>
      'Connection failed. Check console logs for details.\n\nCommon issues:\n• Device not on same network as OPNsense\n• Wrong IP address or port\n• Firewall blocking connection\n• Invalid API credentials';

  @override
  String connectionFailedError(String error) {
    return 'Connection failed: $error';
  }

  @override
  String get connectionInformation => 'Connection Information';

  @override
  String get connectionStatus => 'Connection Status';

  @override
  String get connectionSuccessful => 'Connection Successful';

  @override
  String get connectionTestFailed => 'Connection test failed';

  @override
  String get connectionTestResults => 'Connection Test Results';

  @override
  String get content => 'Content';

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
  String get copiedToClipboard => 'Copied to clipboard';

  @override
  String get copy => 'Copy';

  @override
  String get copyAllDetails => 'Copy All Details';

  @override
  String get copyHost => 'Copy Host';

  @override
  String get copyKey => 'Copy key';

  @override
  String get copySelected => 'Copy selected';

  @override
  String get cpuUsage => 'CPU Usage';

  @override
  String get createAliasComingSoon => 'Create Alias (Coming Soon)';

  @override
  String get createFirstAutomationRule =>
      'Create your first automation rule to get started';

  @override
  String get createFirstProfile => 'Create your first profile to get started';

  @override
  String get createNewProfile => 'Create New Profile';

  @override
  String get createOverride => 'Create Override';

  @override
  String get createPeer => 'Create Peer';

  @override
  String get createRule => 'Create Rule';

  @override
  String get createServer => 'Create Server';

  @override
  String get createStaticKey => 'Create Static Key';

  @override
  String get createYourFirstProfile =>
      'Create your first OPNsense profile to get started';

  @override
  String get created => 'Created';

  @override
  String get critical => 'Critical';

  @override
  String get cryptTlsEncryption => 'Crypt (TLS Encryption)';

  @override
  String get cryptV2TlsEncryption => 'Crypt V2 (TLS Encryption)';

  @override
  String get currentPin => 'Current PIN';

  @override
  String get currentPinIncorrect => 'Current PIN is incorrect';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get day => 'day';

  @override
  String get days => 'days';

  @override
  String daysAgo(int days) {
    return '${days}d ago';
  }

  @override
  String get debug => 'Debug';

  @override
  String get debugDescription => 'Enable debug logging';

  @override
  String get defineRoleOfInstance => 'Define the role of this instance';

  @override
  String get delete => 'Delete';

  @override
  String deleteAliasConfirmation(String aliasName) {
    return 'Are you sure you want to delete the alias \"$aliasName\"?';
  }

  @override
  String get deleteConfirmation => 'Are you sure you want to delete this item?';

  @override
  String get deleteConnection => 'Delete Connection';

  @override
  String deleteConnectionConfirmation(String connectionName) {
    return 'Are you sure you want to delete the connection \"$connectionName\"?';
  }

  @override
  String get deleteHost => 'Delete Host';

  @override
  String deleteHostConfirmation(String host) {
    return 'Are you sure you want to delete \"$host\"?';
  }

  @override
  String get deleteInstance => 'Delete Instance';

  @override
  String get deleteOverride => 'Delete Override';

  @override
  String get deletePeer => 'Delete Peer';

  @override
  String deletePeerConfirmation(String name) {
    return 'Are you sure you want to delete peer \"$name\"?';
  }

  @override
  String get deleteProfile => 'Delete Profile';

  @override
  String deleteProfileConfirmation(String name) {
    return 'Are you sure you want to delete \"$name\"?';
  }

  @override
  String get deleteRule => 'Delete Rule';

  @override
  String deleteRuleConfirmation(String description) {
    return 'Are you sure you want to delete the rule \"$description\"?';
  }

  @override
  String disableRuleConfirmation(String description) {
    return 'Are you sure you want to disable the rule \"$description\"?';
  }

  @override
  String enableRuleConfirmation(String description) {
    return 'Are you sure you want to enable the rule \"$description\"?';
  }

  @override
  String deleteServerConfirmation(String name) {
    return 'Are you sure you want to delete server \"$name\"? This action cannot be undone.';
  }

  @override
  String get deleteStaticKey => 'Delete Static Key';

  @override
  String get deleteSubnet => 'Delete Subnet';

  @override
  String deleteSubnetConfirmation(String subnet) {
    return 'Are you sure you want to delete subnet $subnet?';
  }

  @override
  String get demo => 'Demo';

  @override
  String get dependOnCarp => 'Depend on (CARP)';

  @override
  String get description => 'Description';

  @override
  String get descriptionHelperText => 'A brief description of this instance';

  @override
  String get descriptionHelperTextOverride =>
      'You may enter a description here for your reference (not parsed).';

  @override
  String get descriptionHint => 'e.g., Living Room PC';

  @override
  String get descriptionOptional => 'Description (optional)';

  @override
  String get descriptionRequired => 'Description is required';

  @override
  String get destination => 'Destination';

  @override
  String get destinationAddress => 'Destination Address';

  @override
  String get destinationIsRequired => 'Destination is required';

  @override
  String get destinationPort => 'Destination Port';

  @override
  String get destinationPortOptional => 'Destination Port (Optional)';

  @override
  String get deviceType => 'Device Type';

  @override
  String get dhcpLeases => 'DHCP Leases';

  @override
  String dhcpServerLabel(String serverName) {
    return '$serverName Server';
  }

  @override
  String get dhcpServerType => 'DHCP Server Type';

  @override
  String get direction => 'Direction';

  @override
  String get disable => 'Disable';

  @override
  String get disableAutoScroll => 'Disable Auto-scroll';

  @override
  String get disableRoutes => 'Disable Routes';

  @override
  String get disableRoutesDescription => 'Prevent automatic route installation';

  @override
  String get disableRule => 'Disable Rule';

  @override
  String get disableSnat => 'Disable SNAT';

  @override
  String get disableSnatDescription => 'Disable source NAT for subnet routes';

  @override
  String get disabled => 'Disabled';

  @override
  String get disabledStatus => 'disabled';

  @override
  String get disablingRule => 'Disabling rule...';

  @override
  String get discard => 'Discard';

  @override
  String get disconnect => 'Disconnect';

  @override
  String get disconnectVpn => 'Disconnect VPN';

  @override
  String get disconnected => 'Disconnected';

  @override
  String disconnectingVPN(String name) {
    return 'Disconnecting $name...';
  }

  @override
  String get diskUsage => 'Disk Usage';

  @override
  String get dnsDomainList => 'DNS Domain List';

  @override
  String get dnsDomainListHelperText => 'Set Connection-specific DNS Suffixes.';

  @override
  String get dnsDomainSearchList => 'DNS Domain Search List';

  @override
  String get dnsDomainSearchListHelperText =>
      'Add name to the domain search list. Repeat this option to add more entries. Up to 10 domains are supported.';

  @override
  String get dnsEnabled => 'DNS Enabled';

  @override
  String get dnsServerIp => 'DNS Server IP';

  @override
  String get dnsServerIsRequired => 'DNS server is required';

  @override
  String get dnsServerOptional => 'DNS Server (Optional)';

  @override
  String get dnsServers => 'DNS Servers';

  @override
  String get dnsServersHelperText =>
      'Set primary domain name server IPv4 or IPv6 address. Repeat this option to set secondary DNS server addresses.';

  @override
  String get dnsServersOptional => 'DNS Servers (Optional)';

  @override
  String get dnsmasqDescription => 'Lightweight DNS and DHCP server';

  @override
  String get done => 'Done';

  @override
  String get download => 'Download';

  @override
  String get dynamicLease => 'Dynamic';

  @override
  String get edit => 'Edit';

  @override
  String get editClientOverride => 'Edit Client Override';

  @override
  String get editConnection => 'Edit Connection';

  @override
  String get editHost => 'Edit Host';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get editRule => 'Edit Rule';

  @override
  String get editStaticKey => 'Edit Static Key';

  @override
  String get editSubnet => 'Edit Subnet';

  @override
  String get editWireguardPeer => 'Edit WireGuard Peer';

  @override
  String get editWireguardServer => 'Edit WireGuard Server';

  @override
  String get emergency => 'Emergency';

  @override
  String get enable => 'Enable';

  @override
  String get enableAutoScroll => 'Enable Auto-scroll';

  @override
  String get enableClientSpecificOverride =>
      'Enable this client specific override';

  @override
  String get enableDebugLogging => 'Enable debug logging';

  @override
  String get enablePinLockFirst =>
      'Please enable PIN lock first before using biometric';

  @override
  String get enablePinLockFirstBiometric =>
      'Enable PIN lock first to use biometric';

  @override
  String get enableRule => 'Enable Rule';

  @override
  String get enableSsh => 'Enable SSH';

  @override
  String get enableSshDescription => 'Allow SSH access through Tailscale';

  @override
  String get enableTailscale => 'Enable Tailscale';

  @override
  String get enableTailscaleDescription =>
      'Enable or disable the Tailscale service';

  @override
  String get enableWireguard => 'Enable WireGuard';

  @override
  String get enabled => 'Enabled';

  @override
  String get enabledStatus => 'enabled';

  @override
  String get enablingRule => 'Enabling rule...';

  @override
  String get endTime => 'End Time';

  @override
  String get endpoint => 'Endpoint';

  @override
  String get endpointAddress => 'Endpoint Address';

  @override
  String get endpointPort => 'Endpoint Port';

  @override
  String get enterBandwidthLimit =>
      'Enter your connection bandwidth limit in Mbps';

  @override
  String get enterClientCertificateCommonName =>
      'Enter client certificate common name';

  @override
  String get enterDescriptionForOverride =>
      'Enter a description for this override';

  @override
  String get enterOrGeneratePresharedKey => 'Enter or generate pre-shared key';

  @override
  String get enterOrGeneratePrivateKey => 'Enter or generate private key';

  @override
  String get enterOrGeneratePublicKey => 'Enter or generate public key';

  @override
  String get enterPin => 'Enter PIN';

  @override
  String get enterPinLabel => 'Enter PIN (4-6 digits)';

  @override
  String get enterRuleDescription => 'Enter rule description';

  @override
  String get enterYourApiKey => 'Enter your API key';

  @override
  String get enterYourApiSecret => 'Enter your API secret';

  @override
  String get entries => 'entries';

  @override
  String entriesCount(int count) {
    return '$count entries';
  }

  @override
  String get error => 'Error';

  @override
  String errorAddingSubnet(String error) {
    return 'Error adding subnet: $error';
  }

  @override
  String errorDeletingRule(String error) {
    return 'Error deleting rule: $error';
  }

  @override
  String errorDeletingSubnet(String error) {
    return 'Error deleting subnet: $error';
  }

  @override
  String get errorLoadingData => 'Error loading data';

  @override
  String get errorLoadingInstance => 'Error loading instance';

  @override
  String get errorLoadingLogs => 'Error loading logs';

  @override
  String get errorLoadingOverride => 'Error loading override';

  @override
  String get errorLoadingRoutes => 'Error loading routes';

  @override
  String get errorLoadingRules => 'Error loading rules';

  @override
  String get errorLoadingSessions => 'Error loading sessions';

  @override
  String get errorLoadingSystemInfo => 'Error loading system information';

  @override
  String get errorLoadingVpnConnections => 'Error loading VPN connections';

  @override
  String errorPrefix(String message) {
    return 'Error: $message';
  }

  @override
  String errorRestartingService(String error) {
    return 'Error restarting service: $error';
  }

  @override
  String errorSavingRule(String error) {
    return 'Error saving rule: $error';
  }

  @override
  String errorStartingService(String error) {
    return 'Error starting service: $error';
  }

  @override
  String errorStoppingService(String error) {
    return 'Error stopping service: $error';
  }

  @override
  String errorTogglingRule(String error) {
    return 'Error toggling rule: $error';
  }

  @override
  String errorUpdatingSubnet(String error) {
    return 'Error updating subnet: $error';
  }

  @override
  String get exampleCidr => 'Example: 10.10.10.2/24 or fd00::2/64';

  @override
  String get exampleTunnelAddress => 'Example: 10.10.10.1/24 or fd00::1/64';

  @override
  String get examplesAnyIpCidr => 'Examples: any, 192.168.1.0/24, 10.0.0.1';

  @override
  String get examplesAnyPortRange => 'Examples: any, 80, 1024-65535';

  @override
  String get examplesAnyPortRangeHttp => 'Examples: any, 80, 80-443, http';

  @override
  String get exitNode => 'Exit Node';

  @override
  String get expired => 'Expired';

  @override
  String get expires => 'Expires';

  @override
  String get expiryTime => 'Expiry Time';

  @override
  String get export => 'Export';

  @override
  String get exportAllProfiles => 'Export All Profiles';

  @override
  String get exportAllProfilesSubtitle => 'Export all profiles to a JSON file';

  @override
  String get exportCredentialsWarning =>
      'Exporting with credentials will save API keys and secrets in plain text. Only do this if you will store the file securely.';

  @override
  String get exportFailed => 'Export failed';

  @override
  String exportFailedError(String error) {
    return 'Export failed: $error';
  }

  @override
  String get exportLogs => 'Export Logs';

  @override
  String get exportProfiles => 'Export Profiles';

  @override
  String get exportProfilesContent =>
      'Do you want to include API credentials in the export?\n\nWARNING: Including credentials will store API keys and secrets in plain text. Only include credentials if you will store the file securely.';

  @override
  String get exportSuccess => 'Export successful';

  @override
  String get exportThisProfile => 'Export This Profile';

  @override
  String get failedDevices => 'Failed Devices';

  @override
  String failedToActionTailscaleService(String action) {
    return 'Failed to $action Tailscale service';
  }

  @override
  String get failedToApplyConfiguration => 'Failed to apply configuration';

  @override
  String get failedToBlockHost => 'Failed to block host';

  @override
  String failedToConnect(String name) {
    return 'Failed to connect $name';
  }

  @override
  String failedToCopyHost(String error) {
    return 'Failed to copy host: $error';
  }

  @override
  String failedToDeleteAlias(String error) {
    return 'Failed to delete alias: $error';
  }

  @override
  String failedToDeleteHost(String error) {
    return 'Failed to delete host: $error';
  }

  @override
  String failedToDeleteInstance(String error) {
    return 'Failed to delete instance: $error';
  }

  @override
  String failedToDeleteOverride(String error) {
    return 'Failed to delete override: $error';
  }

  @override
  String failedToDeletePeer(String error) {
    return 'Failed to delete peer: $error';
  }

  @override
  String get failedToDeleteProfile => 'Failed to delete profile';

  @override
  String failedToDeleteServer(String error) {
    return 'Failed to delete server: $error';
  }

  @override
  String failedToDeleteStaticKey(String error) {
    return 'Failed to delete static key: $error';
  }

  @override
  String failedToDisconnect(String name) {
    return 'Failed to disconnect $name';
  }

  @override
  String failedToExportLogs(String error) {
    return 'Failed to export logs: $error';
  }

  @override
  String failedToGenerateKey(String error) {
    return 'Failed to generate key: $error';
  }

  @override
  String failedToGenerateToken(String error) {
    return 'Failed to generate token: $error';
  }

  @override
  String failedToLoadInterfaces(String error) {
    return 'Failed to load interfaces: $error';
  }

  @override
  String get failedToLoadOpenvpnLogs => 'Failed to load OpenVPN logs';

  @override
  String failedToRestartService(String type) {
    return 'Failed to restart $type service';
  }

  @override
  String get failedToSaveAuthSettings =>
      'Failed to save authentication settings';

  @override
  String failedToSaveHost(String error) {
    return 'Failed to save host: $error';
  }

  @override
  String failedToSaveInstance(String error) {
    return 'Failed to save instance: $error';
  }

  @override
  String failedToSaveOverride(String error) {
    return 'Failed to save override: $error';
  }

  @override
  String get failedToSavePeer => 'Failed to save peer';

  @override
  String get failedToSaveProfile => 'Failed to save profile';

  @override
  String get failedToSaveServer => 'Failed to save server';

  @override
  String get failedToSaveSettings => 'Failed to save settings';

  @override
  String failedToSaveStaticKey(String error) {
    return 'Failed to save static key: $error';
  }

  @override
  String get failedToStartService => 'Failed to start service';

  @override
  String get failedToStopService => 'Failed to stop service';

  @override
  String failedToToggleAlias(String error) {
    return 'Failed to toggle alias: $error';
  }

  @override
  String failedToToggleInstance(String error) {
    return 'Failed to toggle instance: $error';
  }

  @override
  String failedToToggleOverride(String error) {
    return 'Failed to toggle override: $error';
  }

  @override
  String failedToTogglePeer(String error) {
    return 'Failed to toggle peer: $error';
  }

  @override
  String failedToToggleServer(String error) {
    return 'Failed to toggle server: $error';
  }

  @override
  String failedToWakeAllHosts(String error) {
    return 'Failed to wake all hosts: $error';
  }

  @override
  String failedToWakeHost(String error) {
    return 'Failed to wake host: $error';
  }

  @override
  String featureComingSoon(String feature) {
    return '$feature - Coming soon';
  }

  @override
  String get featuresList =>
      '• System monitoring and management\n• Firewall rule configuration\n• Service control\n• Real-time logs\n• Multi-profile support\n• Secure authentication';

  @override
  String get featuresTitle => 'Features';

  @override
  String fieldIsRequired(String fieldName) {
    return '$fieldName is required';
  }

  @override
  String get fieldRequired => 'This field is required';

  @override
  String get fifteenMin => '15 min';

  @override
  String get filterByAction => 'Filter by Action';

  @override
  String get filterByType => 'Filter by type';

  @override
  String get filterLabel => 'Filter: ';

  @override
  String get filters => 'Filters';

  @override
  String get firewall => 'Firewall';

  @override
  String get firewallAliases => 'Firewall Aliases';

  @override
  String get firewallLogs => 'Firewall Logs';

  @override
  String get firewallRuleDetails => 'Firewall Rule Details';

  @override
  String get firewallRules => 'Firewall Rules';

  @override
  String get firmwareDetails => 'Firmware Details';

  @override
  String get fiveMin => '5 min';

  @override
  String get fixFormErrors => 'Please fix the errors in the form';

  @override
  String get forbidden => 'Access forbidden';

  @override
  String get gateway => 'Gateway';

  @override
  String get gatewayOptional => 'Gateway (Optional)';

  @override
  String get gateways => 'Gateways';

  @override
  String get general => 'General';

  @override
  String get generalSettings => 'General Settings';

  @override
  String get generateKey => 'Generate Key';

  @override
  String get generateKeyPair => 'Generate Key Pair';

  @override
  String get generateNewKeyPair => 'Generate New Key Pair';

  @override
  String get generateOrPasteKeyHere => 'Generate or paste key here';

  @override
  String get generatePresharedKey => 'Generate pre-shared key';

  @override
  String get generated => 'Generated';

  @override
  String get generating => 'Generating...';

  @override
  String get gitCommit => 'Git Commit';

  @override
  String get healthStatus => 'Health Status';

  @override
  String get hideControls => 'Hide Controls';

  @override
  String get hideKey => 'Hide key';

  @override
  String get historySize => 'History Size';

  @override
  String get host => 'Host';

  @override
  String get hostAddedSuccessfully => 'Host added successfully';

  @override
  String get hostBlocked => 'Host blocked successfully';

  @override
  String get hostDeletedSuccessfully => 'Host deleted successfully';

  @override
  String get hostHint => 'e.g., 192.168.1.1 or firewall.example.com';

  @override
  String get hostIpAddress => 'Host / IP Address';

  @override
  String get hostIpAddressLabel => 'Host/IP Address';

  @override
  String get hostIsRequired => 'Host is required';

  @override
  String get hostPlaceholder => '192.168.1.1 or firewall.example.com';

  @override
  String get hostUpdatedSuccessfully => 'Host updated successfully';

  @override
  String get hostname => 'Hostname';

  @override
  String get hour => 'hour';

  @override
  String get hours => 'hours';

  @override
  String hoursAgo(int hours) {
    return '${hours}h ago';
  }

  @override
  String get id => 'ID';

  @override
  String get import => 'Import';

  @override
  String get importAndExport => 'Import & Export';

  @override
  String get importExportDescription =>
      'Export your profiles to back them up or transfer them to another device. Import profiles from a previously exported file.\n\nProfiles are saved in JSON format and can include connection endpoints and settings.';

  @override
  String importFailed(String error) {
    return 'Import failed: $error';
  }

  @override
  String importFailedWithErrors(String errors) {
    return 'Import failed: $errors';
  }

  @override
  String get importProfiles => 'Import Profiles';

  @override
  String get importProfilesDialog =>
      'How should existing profiles be handled?\n\n• Keep Both: Import with new IDs\n• Overwrite: Replace existing profiles';

  @override
  String get importProfilesSubtitle => 'Import profiles from a JSON file';

  @override
  String get importSuccess => 'Import successful';

  @override
  String importedProfiles(int count) {
    return 'Imported $count profile(s)';
  }

  @override
  String importedWithFailures(int failed, int success) {
    String _temp0 = intl.Intl.pluralLogic(
      success,
      locale: localeName,
      other: 's',
      one: '',
    );
    return 'Imported $success profile$_temp0, $failed failed';
  }

  @override
  String inDays(int days) {
    return 'in ${days}d';
  }

  @override
  String inHours(int hours) {
    return 'in ${hours}h';
  }

  @override
  String inMinutes(int minutes) {
    return 'in ${minutes}m';
  }

  @override
  String get inbound => 'Inbound';

  @override
  String get includeCredentials => 'Include Credentials';

  @override
  String get incorrectPin => 'Incorrect PIN';

  @override
  String get info => 'Information';

  @override
  String get instance => 'Instance';

  @override
  String get instanceCreatedSuccessfully => 'Instance created successfully';

  @override
  String get instanceDeletedSuccessfully => 'Instance deleted successfully';

  @override
  String get instanceDetails => 'Instance Details';

  @override
  String instanceToggledSuccessfully(String status) {
    return 'Instance $status successfully';
  }

  @override
  String get instanceUpdatedSuccessfully => 'Instance updated successfully';

  @override
  String get instanceWillBeActiveWhenEnabled =>
      'Instance will be active when enabled';

  @override
  String get instances => 'Instances';

  @override
  String get interface => 'Interface';

  @override
  String interfaceLabel(String interface) {
    return '$interface';
  }

  @override
  String get invalidApiKeyFormat => 'Invalid API Key format';

  @override
  String get invalidApiSecretFormat => 'Invalid API Secret format';

  @override
  String get invalidBase64Format => 'Invalid Base64 format';

  @override
  String get invalidCidrNotation =>
      'Invalid CIDR notation (use format: IP/prefix)';

  @override
  String get invalidDestinationFormat => 'Invalid destination format';

  @override
  String invalidFileError(String error) {
    return 'Invalid file: $error';
  }

  @override
  String invalidFileFormat(String error) {
    return 'Invalid file: $error';
  }

  @override
  String get invalidHostnameOrIp => 'Invalid hostname or IP address';

  @override
  String get invalidInput => 'Invalid input';

  @override
  String get invalidIpAddress => 'Invalid IP address';

  @override
  String get invalidIpAddressFormat =>
      'Invalid IP address (must be IPv4 or IPv6)';

  @override
  String get invalidIpv4Address => 'Invalid IPv4 address';

  @override
  String get invalidIpv4CidrNotation => 'Invalid IPv4 CIDR notation';

  @override
  String get invalidIpv4Prefix => 'Invalid IPv4 prefix (must be 0-32)';

  @override
  String get invalidIpv6Address => 'Invalid IPv6 address';

  @override
  String get invalidIpv6CidrNotation => 'Invalid IPv6 CIDR notation';

  @override
  String get invalidIpv6Prefix => 'Invalid IPv6 prefix (must be 0-128)';

  @override
  String get invalidPin => 'Invalid PIN';

  @override
  String get invalidPortFormat => 'Invalid port format';

  @override
  String get invalidPrefixLength => 'Invalid prefix length';

  @override
  String get invalidSourceFormat => 'Invalid source format';

  @override
  String get ipAddress => 'IP Address';

  @override
  String get ipAddresses => 'IP Addresses';

  @override
  String get ipv4TunnelNetwork => 'IPv4 Tunnel Network';

  @override
  String get ipv6TunnelNetwork => 'IPv6 Tunnel Network';

  @override
  String get iscDhcpDescription => 'Internet Systems Consortium DHCP server';

  @override
  String itemsCount(int count) {
    return '$count item(s)';
  }

  @override
  String get justNow => 'Just now';

  @override
  String get keaDhcpDescription => 'Modern, high-performance DHCP server';

  @override
  String get keepAliveIntervalOptional => 'Keep Alive Interval (Optional)';

  @override
  String get keepBoth => 'Keep Both';

  @override
  String get keepalive => 'Keepalive';

  @override
  String get keepaliveOptional => 'Keepalive (Optional)';

  @override
  String get key => 'Key';

  @override
  String get keyCopiedToClipboard => 'Key copied to clipboard';

  @override
  String get keyGeneratedSuccessfully => 'Key generated successfully';

  @override
  String keyWithId(String id) {
    return 'Key $id';
  }

  @override
  String get keysGeneratedSuccessfully => 'Keys generated successfully';

  @override
  String get keysRequired => 'Private and public keys are required';

  @override
  String get label => 'Label';

  @override
  String get labelHint => 'e.g., Home Network, Office VPN';

  @override
  String get labelOptional => 'Label (Optional)';

  @override
  String get language => 'Language';

  @override
  String get lastDay => 'Last Day';

  @override
  String get lastDayShort => '1 Day';

  @override
  String get lastMonth => 'Last Month';

  @override
  String get lastMonthShort => '1 Month';

  @override
  String get lastUpdate => 'Last Update';

  @override
  String lastUsed(String date) {
    return 'Last used: $date';
  }

  @override
  String get lastWeek => 'Last Week';

  @override
  String get lastWeekShort => '1 Week';

  @override
  String leasesCount(int filtered, int total) {
    return '$filtered of $total lease(s)';
  }

  @override
  String get leaveEmptyOrGenerate => 'Leave empty or generate';

  @override
  String get licenses => 'Licenses';

  @override
  String get lightMode => 'Light Mode';

  @override
  String get limit => 'Limit';

  @override
  String get live => 'LIVE';

  @override
  String get liveNetworkMonitor => 'Live Network Monitor';

  @override
  String get neighborDiscovery => 'Neighbor Discovery';

  @override
  String get loading => 'Loading...';

  @override
  String get loadingHostData => 'Loading host data...';

  @override
  String get loadingSettings => 'Loading settings...';

  @override
  String get localAddress => 'Local Address';

  @override
  String get localNetwork => 'Local Network';

  @override
  String get localNetworkHelperText =>
      'These are the networks accessible by the client, these are pushed via route(-ipv6) clauses in OpenVPN to the client.';

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
  String get lockApp => 'Lock App';

  @override
  String get lockTimeoutLabel => 'Lock Timeout';

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
  String get logDetails => 'Log Details';

  @override
  String logEntriesCopied(int count, String entries) {
    return '$count log $entries copied';
  }

  @override
  String get logEntryCopied => 'Log entry copied';

  @override
  String get logEntryDetails => 'Log Entry Details';

  @override
  String get logFile => 'Log File';

  @override
  String get logLimit => 'Log Limit';

  @override
  String get login => 'Login';

  @override
  String get loginServer => 'Login Server';

  @override
  String get loginServerHelperText => 'The Tailscale login server URL';

  @override
  String get loginServerRequired => 'Login server is required';

  @override
  String get logout => 'Logout';

  @override
  String get logs => 'Logs';

  @override
  String get logsExportedSuccessfully => 'Logs exported successfully';

  @override
  String get logsMatchingFiltersWillAppearHere =>
      'Logs matching your filters will appear here';

  @override
  String get logsWillAppear => 'Logs will appear here as they are generated';

  @override
  String get macAddress => 'MAC Address';

  @override
  String get macAddressHint => 'e.g., 00:11:22:33:44:55';

  @override
  String get macAddressIsRequired => 'MAC address is required';

  @override
  String get invalidMacAddressFormat =>
      'Invalid MAC address format (e.g., AA:BB:CC:DD:EE:FF)';

  @override
  String get manageProfiles => 'Manage Profiles';

  @override
  String get manageSubnets => 'Manage Subnets';

  @override
  String get manageWireguard => 'Manage WireGuard';

  @override
  String get manufacturer => 'Manufacturer';

  @override
  String get maximumTransmissionUnit => 'Maximum Transmission Unit (576-9000)';

  @override
  String get memoryUsage => 'Memory Usage';

  @override
  String get minute => 'minute';

  @override
  String get minutes => 'minutes';

  @override
  String minutesAgo(int minutes) {
    return '${minutes}m ago';
  }

  @override
  String get mode => 'Mode';

  @override
  String get modified => 'Modified';

  @override
  String get monitorInterface => 'Monitor Interface';

  @override
  String get mssFix => 'MSS Fix';

  @override
  String get mssFixDescription => 'Enable MSS fix for this connection';

  @override
  String get mtuOptional => 'MTU (Optional)';

  @override
  String get mustBeValidUrl =>
      'Must be a valid URL starting with http:// or https://';

  @override
  String get myOPNsenseRouter => 'My OPNsense Router';

  @override
  String get myOpenvpnInstance => 'My OpenVPN Instance';

  @override
  String get myStaticKey => 'My Static Key';

  @override
  String get myWireguardPeer => 'My WireGuard Peer';

  @override
  String get myWireguardServer => 'My WireGuard Server';

  @override
  String get name => 'Name';

  @override
  String get needHelpCheckDocumentation =>
      'Need help? Check the OPNsense documentation for API key generation.';

  @override
  String get networkConfiguration => 'Network Configuration';

  @override
  String get networkError => 'Network error occurred';

  @override
  String get networkInformation => 'Network Information';

  @override
  String get networkTotals => 'Network Totals';

  @override
  String get newPin => 'New PIN (4-6 digits)';

  @override
  String get newPinMustBeDifferent =>
      'New PIN must be different from current PIN';

  @override
  String get newRule => 'New Rule';

  @override
  String get newWireguardPeer => 'New WireGuard Peer';

  @override
  String get newWireguardServer => 'New WireGuard Server';

  @override
  String get next => 'Next';

  @override
  String get no => 'No';

  @override
  String get noAliasesConfigured => 'No aliases configured';

  @override
  String get noAliasesMatchFilters => 'No aliases match the current filters';

  @override
  String get noAutomationRulesFound => 'No automation rules found';

  @override
  String get noClientSpecificOverridesConfigured =>
      'No client specific overrides configured';

  @override
  String noConnectionsFound(String type) {
    return 'No $type connections found';
  }

  @override
  String get noDataAvailable => 'No data available';

  @override
  String get noDescription => 'No Description';

  @override
  String get noDnsDomainSearchEntriesConfigured =>
      'No DNS domain search entries configured';

  @override
  String get noDnsDomainsConfigured => 'No DNS domains configured';

  @override
  String get noDnsServersConfigured => 'No DNS servers configured';

  @override
  String get noHostsFound => 'No hosts found';

  @override
  String get noInstancesMatchFilters => 'No instances match your filters';

  @override
  String get noInterfacesWithAutomationRules =>
      'No interfaces with automation rules';

  @override
  String get noItemsConfigured => 'No items configured';

  @override
  String get noLeasesFound => 'No leases found';

  @override
  String get noLimit => 'No Limit';

  @override
  String get noLimitShort => 'All';

  @override
  String get noLocalNetworksConfigured => 'No local networks configured';

  @override
  String get noLogEntriesFound => 'No log entries found';

  @override
  String get noLogsAvailable => 'No logs available';

  @override
  String get noLogsToExport => 'No logs to export';

  @override
  String get noNtpServersConfigured => 'No NTP servers configured';

  @override
  String get noOpenvpnInstancesConfigured => 'No OpenVPN instances configured';

  @override
  String get noOpenvpnRoutesConfigured => 'No OpenVPN routes configured';

  @override
  String get noOpenvpnSessionsConfigured =>
      'There are no OpenVPN sessions configured';

  @override
  String get noOptionsAvailable => 'No options available';

  @override
  String get noOverridesMatchFilter => 'No overrides match your filter';

  @override
  String get noPeersAvailable => 'No peers available';

  @override
  String get noPeersMatchSearch => 'No peers match your search';

  @override
  String get noProfiles => 'No Profiles';

  @override
  String get noProfilesFound => 'No profiles found';

  @override
  String get noProfilesYet => 'No Profiles Yet';

  @override
  String get noRemoteNetworksConfigured => 'No remote networks configured';

  @override
  String get noRoutesConfigured => 'No routes configured';

  @override
  String noRulesForInterface(String interface) {
    return 'No rules for $interface';
  }

  @override
  String get noServersAvailable => 'No servers available';

  @override
  String get noServersMatchSearch => 'No servers match your search';

  @override
  String get noServersSelected => 'No servers selected';

  @override
  String get noSessionsFound => 'No sessions found';

  @override
  String get noSettingsAvailable => 'No settings available';

  @override
  String get noStaticKeysConfigured => 'No static keys configured';

  @override
  String get noSubnetsConfigured => 'No subnets configured';

  @override
  String get noTunnelAddressesConfigured => 'No tunnel addresses configured';

  @override
  String get noVpnConnectionsFound => 'No VPN connections found';

  @override
  String get noWinsServersConfigured => 'No WINS servers configured';

  @override
  String get noWireguardPeersConfigured => 'No WireGuard peers configured';

  @override
  String get noWireguardServersConfigured => 'No WireGuard servers configured';

  @override
  String get noWireguardStatusDataAvailable =>
      'No WireGuard status data available';

  @override
  String get noWolHostsConfigured => 'No Wake on LAN hosts configured';

  @override
  String get none => 'None';

  @override
  String get notAvailable => 'N/A';

  @override
  String get notFound => 'Resource not found';

  @override
  String get notice => 'Notice';

  @override
  String get ntpServers => 'NTP Servers';

  @override
  String get ntpServersHelperText =>
      'Set primary NTP server address (Network Time Protocol). Repeat this option to set secondary NTP server addresses.';

  @override
  String get offline => 'Offline';

  @override
  String get ok => 'OK';

  @override
  String get oneHour => '1 hour';

  @override
  String get oneMin => '1 min';

  @override
  String get online => 'Online';

  @override
  String get openvpnConnectionStatus => 'OpenVPN Connection Status';

  @override
  String get openvpnInstances => 'OpenVPN Instances';

  @override
  String get openvpnLogFile => 'OpenVPN Log File';

  @override
  String get optional => 'Optional';

  @override
  String get optionalBase64EncodedPresharedKey =>
      'Optional Base64-encoded preshared key';

  @override
  String get outbound => 'Outbound';

  @override
  String get overrideCreatedSuccessfully => 'Override created successfully';

  @override
  String get overrideDeletedSuccessfully => 'Override deleted successfully';

  @override
  String get overrideDetails => 'Override Details';

  @override
  String overrideToggledSuccessfully(String status) {
    return 'Override $status successfully';
  }

  @override
  String get overrideUpdatedSuccessfully => 'Override updated successfully';

  @override
  String get overwrite => 'Overwrite';

  @override
  String get packageMirror => 'Package Mirror';

  @override
  String get packetLength => 'Packet Length';

  @override
  String get pass => 'Pass';

  @override
  String get pause => 'Pause';

  @override
  String get pauseLiveViewToSelect => 'Pause live view to select log entries';

  @override
  String get paused => 'Paused';

  @override
  String get peerCreatedReadyForNext =>
      'Peer created successfully. Ready for next peer.';

  @override
  String get peerCreatedSuccessfully => 'Peer created successfully';

  @override
  String get peerDeletedSuccessfully => 'Peer deleted successfully';

  @override
  String get peerDisabledSuccessfully => 'Peer disabled successfully';

  @override
  String get peerEnabledSuccessfully => 'Peer enabled successfully';

  @override
  String get peerGenerator => 'Peer Generator';

  @override
  String get peerUpdatedSuccessfully => 'Peer updated successfully';

  @override
  String get peerWillBeActiveWhenEnabled => 'Peer will be active when enabled';

  @override
  String get peers => 'Peers';

  @override
  String peersConfigured(int count) {
    return '$count peer(s) configured';
  }

  @override
  String get peersCount => 'Peers Count';

  @override
  String peersSelected(int count) {
    return '$count peer(s) selected';
  }

  @override
  String get persistentKeepaliveSeconds =>
      'Persistent keepalive in seconds (recommended: 25)';

  @override
  String get pinChangedSuccessfully => 'PIN changed successfully';

  @override
  String get pinLock => 'PIN Lock';

  @override
  String get pinLockDisabled =>
      'PIN lock disabled. Biometric lock also disabled.';

  @override
  String get pinLockEnabled => 'PIN lock enabled';

  @override
  String get pinMismatch => 'PINs do not match';

  @override
  String get pinMustContainOnlyNumbers => 'PIN must contain only numbers';

  @override
  String get pinTooShort => 'PIN must be at least 4 digits';

  @override
  String get platform => 'Platform';

  @override
  String get pleaseEnterCurrentPin => 'Please enter your current PIN';

  @override
  String get pleaseEnterNewPin => 'Please enter a new PIN';

  @override
  String get pleaseEnterSubnet => 'Please enter a subnet';

  @override
  String get pleaseEnterYourPin => 'Please enter your PIN';

  @override
  String get pleaseSelectAnInstance => 'Please select an instance';

  @override
  String get pleaseSelectInterface => 'Please select an interface';

  @override
  String get port => 'Port';

  @override
  String get portHint => 'e.g., 443';

  @override
  String get portIsRequired => 'Port is required';

  @override
  String portLabel(String port) {
    return 'Port $port';
  }

  @override
  String get portMustBeBetween => 'Port must be between 1 and 65535';

  @override
  String get preAuthKey => 'Pre-Auth Key';

  @override
  String get preAuthKeyHelperText =>
      'Optional: Pre-authentication key for automatic device registration';

  @override
  String get presharedKeyGeneratedSuccessfully =>
      'Pre-shared key generated successfully';

  @override
  String get presharedKeyOptional => 'Pre-shared Key (Optional)';

  @override
  String get preventAutomaticRouteInstallation =>
      'Prevent automatic route installation';

  @override
  String get previous => 'Previous';

  @override
  String get privateKey => 'Private Key';

  @override
  String get profileActivated => 'Profile activated successfully';

  @override
  String get profileAdded => 'Profile added';

  @override
  String get profileDeleted => 'Profile deleted successfully';

  @override
  String get profileHasNoEndpoints =>
      'Profile has no connection endpoints configured';

  @override
  String get profileName => 'Profile Name';

  @override
  String get profileNameOptional => 'Profile Name (Optional)';

  @override
  String get profileNameRequired => 'Profile name is required';

  @override
  String get profileSaved => 'Profile saved successfully';

  @override
  String get profileUpdated => 'Profile updated';

  @override
  String get profiles => 'Profiles';

  @override
  String profilesExportedSuccessfully(String path) {
    return 'Profiles exported successfully!\n$path';
  }

  @override
  String get protocol => 'Protocol';

  @override
  String get publicKey => 'Public Key';

  @override
  String get publicKeyColon => 'Public Key:';

  @override
  String get publicKeyRequired => 'Public key is required';

  @override
  String publicKeyShort(String key) {
    return '$key...';
  }

  @override
  String get pushReset => 'Push reset';

  @override
  String get pushVirtualIpEndpoints =>
      'Push virtual IP endpoints for client tunnel, overriding dynamic allocation.';

  @override
  String get qrCode => 'QR Code';

  @override
  String get reason => 'Reason';

  @override
  String get rebootConfirmation =>
      'Are you sure you want to reboot the system?';

  @override
  String get rebootFailed => 'Failed to reboot system';

  @override
  String rebootFailedWithError(String message, String error) {
    return '$message: $error';
  }

  @override
  String get rebootSuccess => 'System reboot initiated';

  @override
  String get rebootSystem => 'Reboot System';

  @override
  String get received => 'Received';

  @override
  String get recommendedForSecureConnections =>
      'Recommended for secure connections';

  @override
  String get redirectGateway => 'Redirect gateway';

  @override
  String get refresh => 'Refresh';

  @override
  String get registerDns => 'Register DNS';

  @override
  String get reject => 'Reject';

  @override
  String get remoteAddress => 'Remote Address';

  @override
  String get remoteNetwork => 'Remote Network';

  @override
  String get remoteNetworkHelperText =>
      'Remote networks for the server, these are configured via iroute(-ipv6) clauses in OpenVPN and inform the server to send these networks to this specific client.';

  @override
  String get repository => 'Repository';

  @override
  String get requirePinToUnlock => 'Require PIN to unlock app';

  @override
  String get required => 'Required';

  @override
  String get restart => 'Restart';

  @override
  String get restartService => 'Restart Service';

  @override
  String restartServiceConfirmation(String type) {
    return 'Are you sure you want to restart the $type service?\n\nThis will temporarily disconnect all active connections.';
  }

  @override
  String get restartVpnService => 'Restart VPN Service';

  @override
  String restartingService(String type) {
    return 'Restarting $type service...';
  }

  @override
  String get resume => 'Resume';

  @override
  String get retry => 'Retry';

  @override
  String get role => 'Role';

  @override
  String get routeGateway => 'Route gateway';

  @override
  String get routeGatewayHelperText =>
      'Specify a default gateway to use for the connected client. Without one set the first address in the netblock is being offered. When segmenting the tunnel (server) network, this one might not be accessible from the client.';

  @override
  String get routes => 'Routes';

  @override
  String get routing => 'Routing';

  @override
  String get rowsPerPage => 'Rows per page';

  @override
  String get rowsPerPageLabel => 'Rows per page: ';

  @override
  String get ruleActionFailed => 'Rule action failed';

  @override
  String get ruleCreated => 'Rule created successfully';

  @override
  String get ruleDeleted => 'Rule deleted successfully';

  @override
  String get ruleDescription => 'Rule Description';

  @override
  String get ruleDetails => 'Rule Details';

  @override
  String get ruleDisabledSuccessfully => 'Rule disabled successfully';

  @override
  String get ruleEnabledSuccessfully => 'Rule enabled successfully';

  @override
  String get ruleGuidelines => 'Rule Guidelines';

  @override
  String get ruleGuidelinesText =>
      '• Use \"any\" to match all addresses or ports\n• CIDR notation: 192.168.1.0/24\n• Port ranges: 80-443\n• Rules are processed in sequence order\n• Changes are applied immediately';

  @override
  String get ruleId => 'Rule ID';

  @override
  String get ruleInformation => 'Rule Information';

  @override
  String get ruleUpdated => 'Rule updated successfully';

  @override
  String get ruleWillBeActiveWhenEnabled => 'Rule will be active when enabled';

  @override
  String get running => 'Running';

  @override
  String get runningStatus => 'Running';

  @override
  String get save => 'Save';

  @override
  String get saveAndConnect => 'Save & Connect';

  @override
  String get saveSettings => 'Save Settings';

  @override
  String get saveWithoutTesting => 'Save without testing';

  @override
  String get saving => 'Saving...';

  @override
  String get savingOverride => 'Saving override...';

  @override
  String get savingProfile => 'Saving profile...';

  @override
  String get searchAliases => 'Search aliases...';

  @override
  String get searchHostnameIpOrMac => 'Search hostname, IP, or MAC address...';

  @override
  String get searchHostnameOrIp => 'Search hostname or IP address...';

  @override
  String get searchInstances => 'Search instances...';

  @override
  String get searchOverrides => 'Search overrides...';

  @override
  String get searchPeers => 'Search peers...';

  @override
  String get searchServers => 'Search servers...';

  @override
  String get second => 'second';

  @override
  String get seconds => 'Seconds';

  @override
  String get security => 'Security';

  @override
  String get securityWarning => 'Security Warning';

  @override
  String get selectAProfileOrCreateNewOne =>
      'Select a profile or create a new one';

  @override
  String get selectAll => 'Select All';

  @override
  String get selectExitNode => 'Select exit node';

  @override
  String get selectInterface => 'Select Interface';

  @override
  String get selectInterfaceToViewRules => 'Select an interface to view rules';

  @override
  String selectLabel(String label) {
    return 'Select $label';
  }

  @override
  String get selectMultipleInterfaces =>
      'Select one or more interfaces to monitor';

  @override
  String get selectNumberOfEntries =>
      'Select the number of log entries to display:';

  @override
  String get selectPeers => 'Select Peers';

  @override
  String get selectServerAndGenerateKeys =>
      '# Select a server and generate keys to preview configuration';

  @override
  String get selectServerForQrCode => 'Select server to generate QR code';

  @override
  String get selectServerInstance => 'Please select a server instance';

  @override
  String get selectServerToGenerateQrCode =>
      'Select server to generate QR code';

  @override
  String get selectServers => 'Select Servers';

  @override
  String get selectServersHelperText =>
      'Select the OpenVPN servers where this override applies to, leave empty for all';

  @override
  String get selectVhid => 'Select VHID';

  @override
  String get selected => 'selected';

  @override
  String get selfSignedCertWarning =>
      'Warning: Self-signed certificates are less secure. Only enable this if you trust the server.';

  @override
  String get selfSignedCertificatesWarning =>
      'Only enable this if you trust the server';

  @override
  String get sent => 'Sent';

  @override
  String get sequence => 'Sequence';

  @override
  String get server => 'Server';

  @override
  String get serverActiveWhenEnabled => 'Server will be active when enabled';

  @override
  String get serverAddress => 'Server Address';

  @override
  String get serverCreatedSuccessfully => 'Server created successfully';

  @override
  String get serverDeletedSuccessfully => 'Server deleted successfully';

  @override
  String get serverDisabledSuccessfully => 'Server disabled successfully';

  @override
  String get serverEnabledSuccessfully => 'Server enabled successfully';

  @override
  String get serverError => 'Server error occurred';

  @override
  String get serverInfoNotLoaded => 'Server information not loaded';

  @override
  String get serverNetwork => 'Server Network';

  @override
  String get serverPort => 'Server Port';

  @override
  String get serverSelectionRequired => 'At least one server must be selected';

  @override
  String get serverUpdatedSuccessfully => 'Server updated successfully';

  @override
  String get serverWillBeActiveWhenEnabled =>
      'Server will be active when enabled';

  @override
  String get servers => 'Servers';

  @override
  String serversSelected(int count) {
    return '$count server(s) selected';
  }

  @override
  String get serviceActionFailed => 'Service action failed';

  @override
  String get serviceControls => 'Service Controls';

  @override
  String get serviceRestartedSuccessfully => 'Service restarted successfully';

  @override
  String get serviceRunning => 'Service Running';

  @override
  String get serviceStartedSuccessfully => 'Service started successfully';

  @override
  String get serviceStatus => 'Service Status';

  @override
  String get serviceStoppedSuccessfully => 'Service stopped successfully';

  @override
  String get services => 'Services';

  @override
  String get sessionTimeout => 'Session Timeout';

  @override
  String get sessions => 'Sessions';

  @override
  String get setAsActive => 'Set as Active';

  @override
  String get setPin => 'Set PIN';

  @override
  String get settings => 'Settings';

  @override
  String severitiesAndTimeFilter(int count, String timeFilter) {
    return '$count severities • $timeFilter';
  }

  @override
  String get severity => 'Severity';

  @override
  String get severityAlert => 'Alert';

  @override
  String get severityCritical => 'Critical';

  @override
  String get severityDebug => 'Debug';

  @override
  String get severityEmergency => 'Emergency';

  @override
  String get severityEmergencyShort => 'Emerg';

  @override
  String get severityError => 'Error';

  @override
  String get severityInformational => 'Informational';

  @override
  String get severityInformationalShort => 'Info';

  @override
  String get severityNotice => 'Notice';

  @override
  String get severityWarning => 'Warning';

  @override
  String get showAdvancedSettings => 'Show Advanced Settings';

  @override
  String get showAll => 'Show All';

  @override
  String get showKey => 'Show key';

  @override
  String showingInstancesCount(String count, String total) {
    return 'Showing $count of $total';
  }

  @override
  String get showingZeroEntries => 'Showing 0 entries';

  @override
  String get someConnectionsFailed => 'Some connections failed';

  @override
  String get soon => 'soon';

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
  String get source => 'Source';

  @override
  String get sourceAddress => 'Source Address';

  @override
  String get sourceIsRequired => 'Source is required';

  @override
  String get sourcePort => 'Source Port';

  @override
  String get sourcePortOptional => 'Source Port (Optional)';

  @override
  String get sshEnabled => 'SSH Enabled';

  @override
  String get start => 'Start';

  @override
  String get startService => 'Start Service';

  @override
  String get startTime => 'Start Time';

  @override
  String get startWireguardService => 'Start WireGuard service';

  @override
  String get staticKeyContentPemFormat => 'Static key content in PEM format';

  @override
  String get staticKeyCreatedSuccessfully => 'Static key created successfully';

  @override
  String get staticKeyDeletedSuccessfully => 'Static key deleted successfully';

  @override
  String get staticKeyDetails => 'Static Key Details';

  @override
  String get staticKeyInformation => 'Static Key Information';

  @override
  String get staticKeyUpdatedSuccessfully => 'Static key updated successfully';

  @override
  String get staticKeys => 'Static Keys';

  @override
  String get staticLease => 'Static';

  @override
  String get status => 'Status';

  @override
  String get stop => 'Stop';

  @override
  String get stopService => 'Stop Service';

  @override
  String get stopped => 'Stopped';

  @override
  String get stoppedStatus => 'Stopped';

  @override
  String get storeAndGenerateNext => 'Store and Generate Next';

  @override
  String get subnetAddedSuccessfully => 'Subnet added successfully';

  @override
  String get subnetCidr => 'Subnet (CIDR)';

  @override
  String get subnetDeletedSuccessfully => 'Subnet deleted successfully';

  @override
  String get subnetUpdatedSuccessfully => 'Subnet updated successfully';

  @override
  String get success => 'Success';

  @override
  String successfullyConnected(String name) {
    return 'Successfully connected $name';
  }

  @override
  String successfullyDisconnected(String name) {
    return 'Successfully disconnected $name';
  }

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
  String successfullyRestartedService(String type) {
    return 'Successfully restarted $type service';
  }

  @override
  String successfullyWokenDevices(
    int successCount,
    int totalCount,
    String plural,
  ) {
    return 'Successfully woken $successCount of $totalCount device$plural';
  }

  @override
  String get switchProfile => 'Switch Profile';

  @override
  String get switchProfileConfirmation =>
      'Are you sure you want to switch profiles? You will be returned to the profile selection screen.';

  @override
  String get systemDefault => 'System Default';

  @override
  String get systemGeneratedRule =>
      'This is a system-generated rule and cannot be modified or deleted.';

  @override
  String get systemGeneratedRulesCannotBeDeleted =>
      'System-generated rules cannot be deleted';

  @override
  String get systemGeneratedRulesCannotBeModified =>
      'System-generated rules cannot be modified';

  @override
  String get systemInfo => 'System Information';

  @override
  String get systemInformation => 'System Information';

  @override
  String get systemType => 'System Type';

  @override
  String get tags => 'Tags';

  @override
  String get tailscaleAuthentication => 'Tailscale Authentication';

  @override
  String tailscaleServiceAction(String action) {
    return '$action Tailscale Service';
  }

  @override
  String tailscaleServiceActionConfirmation(String action) {
    return 'Are you sure you want to $action the Tailscale service?';
  }

  @override
  String tailscaleServiceActionSuccess(String action) {
    return 'Tailscale service ${action}ed successfully';
  }

  @override
  String tailscaleServiceActioning(String action) {
    return '${action}ing Tailscale service...';
  }

  @override
  String get tailscaleSettings => 'Tailscale Settings';

  @override
  String get tailscaleStatus => 'Tailscale Status';

  @override
  String get tailscaleSubnets => 'Tailscale Subnets';

  @override
  String get tailscaleVersion => 'Version';

  @override
  String get tapPlusButtonToCreateFirstInstance =>
      'Tap the + button to create your first instance';

  @override
  String get tapPlusButtonToCreateFirstOverride =>
      'Tap the + button to create your first override';

  @override
  String get tapPlusButtonToCreateFirstStaticKey =>
      'Tap the + button to create your first static key';

  @override
  String get tcpFlags => 'TCP Flags';

  @override
  String get tenMin => '10 min';

  @override
  String get testConnection => 'Test Connection';

  @override
  String get testConnections => 'Test Connections';

  @override
  String get testProfile => 'Test Profile';

  @override
  String get testingAllConnections => 'Testing all connection points...';

  @override
  String testingConnection(String current, String total, String endpoint) {
    return 'Testing connection $current of $total: $endpoint';
  }

  @override
  String get theme => 'Theme';

  @override
  String get thirtyMin => '30 min';

  @override
  String get time => 'Time';

  @override
  String get timeRange => 'Time range';

  @override
  String get timeout => 'Request timeout';

  @override
  String get timestamp => 'Timestamp';

  @override
  String get today => 'Today';

  @override
  String get totalBandwidth => 'Total Bandwidth';

  @override
  String get totalDownload => 'Total Download';

  @override
  String get totalEntries => 'Total Entries';

  @override
  String get totalUpload => 'Total Upload';

  @override
  String get totalVpns => 'Total VPNs';

  @override
  String get tryAdjustingFilters =>
      'Try adjusting the selected severity or date filters.';

  @override
  String get tryDemoMode => 'Try Demo Mode';

  @override
  String get tryDifferentSearch => 'Try a different search term';

  @override
  String get tunnelAddress => 'Tunnel Address';

  @override
  String get tunnelAddressCidr => 'Tunnel Address (CIDR)';

  @override
  String get tunnelAddressRequired => 'At least one tunnel address is required';

  @override
  String get tunnelAddresses => 'Tunnel Addresses';

  @override
  String tunnelLabel(String network) {
    return 'Tunnel: $network';
  }

  @override
  String get tunnelNetwork => 'Tunnel Network';

  @override
  String get tunnelSettings => 'Tunnel Settings';

  @override
  String tunnelWithValue(String value) {
    return 'Tunnel: $value';
  }

  @override
  String get twoMin => '2 min';

  @override
  String get type => 'Type';

  @override
  String typeWithValue(String value) {
    return 'Type: $value';
  }

  @override
  String get udpPortDefault51820 => 'UDP port (default: 51820)';

  @override
  String get unableToAccessFilePath => 'Unable to access file path';

  @override
  String get unableToConnectToAnyEndpoint =>
      'Unable to connect to any configured endpoints. Please check your network settings and try again.';

  @override
  String get unauthorized => 'Unauthorized access';

  @override
  String get unknown => 'Unknown';

  @override
  String get unknownStatus => 'Unknown';

  @override
  String get unlock => 'Unlock';

  @override
  String get unlockOpnsenseManager => 'Unlock OPNsense Manager';

  @override
  String get unnamedHost => 'Unnamed Host';

  @override
  String get unnamedInstance => 'Unnamed Instance';

  @override
  String get unnamedRule => 'Unnamed Rule';

  @override
  String get unsavedChanges => 'Unsaved Changes';

  @override
  String get unsavedChangesConfirmation =>
      'You have unsaved changes. Do you want to discard them and continue?';

  @override
  String get update => 'Update';

  @override
  String get updateOverride => 'Update Override';

  @override
  String get updatePeer => 'Update Peer';

  @override
  String get updatePinCode => 'Update your PIN code';

  @override
  String get updateRule => 'Update Rule';

  @override
  String get updateServer => 'Update Server';

  @override
  String get updateStaticKey => 'Update Static Key';

  @override
  String get upload => 'Upload';

  @override
  String get uptime => 'Uptime';

  @override
  String get useBiometric => 'Use Biometric';

  @override
  String useBiometricToUnlock(String biometricType) {
    return 'Use $biometricType to unlock app';
  }

  @override
  String get useExitNode => 'Use Exit Node';

  @override
  String get useHttps => 'Use HTTPS';

  @override
  String get useHttpsDescription => 'Use secure HTTPS connection';

  @override
  String get useProtocolForCommunicating =>
      'Use this protocol for communicating';

  @override
  String get valid => 'Valid';

  @override
  String get validFrom => 'Valid From';

  @override
  String verifyingConnection(String endpoint) {
    return 'Verifying connection to $endpoint...';
  }

  @override
  String version(String version) {
    return 'Version $version';
  }

  @override
  String get versionLabel => 'Version';

  @override
  String get viewDetails => 'View Details';

  @override
  String get viewFullLicense => 'View Full License';

  @override
  String get virtualAddress => 'Virtual Address';

  @override
  String get vpn => 'VPN';

  @override
  String get vpnConnections => 'VPN Connections';

  @override
  String get vpnConnectionsWillAppear =>
      'VPN connections will appear here when configured';

  @override
  String get vpnStatus => 'VPN Status';

  @override
  String get vpnType => 'VPN Type';

  @override
  String get wakeAll => 'Wake All';

  @override
  String get wakeAllDevices => 'Wake All Devices';

  @override
  String get wakeAllDevicesConfirmation =>
      'Are you sure you want to send wake packets to all configured devices?';

  @override
  String get wakeAllResults => 'Wake All Results';

  @override
  String get wakeHost => 'Wake Host';

  @override
  String get wakeOnLan => 'Wake on LAN';

  @override
  String get wakingAllDevices => 'Waking all devices...';

  @override
  String get warning => 'Warning';

  @override
  String get winsServers => 'WINS Servers';

  @override
  String get winsServersHelperText =>
      'Set primary WINS server address (NetBIOS over TCP/IP Name Server). Repeat this option to set secondary WINS server addresses.';

  @override
  String get wireguardLogs => 'WireGuard Logs';

  @override
  String get wireguardLogsExport => 'WireGuard Logs Export';

  @override
  String wireguardLogsExportedOn(String date) {
    return 'WireGuard logs exported on $date';
  }

  @override
  String get wireguardPeers => 'WireGuard Peers';

  @override
  String get wireguardServers => 'WireGuard Servers';

  @override
  String get wireguardServiceStarted => 'WireGuard service started';

  @override
  String get wireguardServiceStopped => 'WireGuard service stopped';

  @override
  String get wireguardStatus => 'WireGuard Status';

  @override
  String get withoutCredentials => 'Without Credentials';

  @override
  String wolPacketSentTo(String host) {
    return 'WOL packet sent to $host';
  }

  @override
  String get yes => 'Yes';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get zeroSeconds => '0 seconds';

  @override
  String get connectionBlockingDescription =>
      'Block this client connection based on its common name. Don\'t use this option to permanently disable a client due to a compromised key or password. Use a CRL (certificate revocation list) instead.';

  @override
  String deviceLabel(String type) {
    return 'Device: $type';
  }

  @override
  String get facility => 'Facility';

  @override
  String gatewayLabel(String gateway) {
    return 'Gateway: $gateway';
  }

  @override
  String localLabel(String address) {
    return 'Local: $address';
  }

  @override
  String get messageLabel => 'Message:';

  @override
  String pageOfTotal(int current, int total) {
    return 'Page $current of $total';
  }

  @override
  String get parser => 'Parser';

  @override
  String pidLabel(String pid) {
    return 'PID: $pid';
  }

  @override
  String processLabel(String process) {
    return 'Process: $process';
  }

  @override
  String get pushResetDescription =>
      'Don\'t inherit the global push list for a specific client instance. NOTE: --push-reset is very thorough: it will remove almost all options from the list of to-be-pushed options. In many cases, some of these options will need to be re-configured afterwards - specifically, --topology subnet and --route-gateway will get lost and this will break client configs in many cases.';

  @override
  String get record => 'Record';

  @override
  String get redirectGatewayDescription =>
      'Automatically execute routing commands to cause all outgoing IP traffic to be redirected over the VPN.';

  @override
  String get registerDnsDescription =>
      'Run ipconfig /flushdns and ipconfig /registerdns on connection initiation. This is known to kick Windows into recognizing pushed DNS servers.';

  @override
  String remoteLabel(String info) {
    return 'Remote: $info';
  }

  @override
  String selectedCount(int count) {
    return '$count selected';
  }

  @override
  String serverLabel(String info) {
    return 'Server: $info';
  }

  @override
  String severityLabel(String severity) {
    return 'Severity: $severity';
  }

  @override
  String showingEntries(int start, int end) {
    return 'Showing $start to $end';
  }

  @override
  String timestampLabel(String timestamp) {
    return 'Timestamp: $timestamp';
  }

  @override
  String typeLabel(String type) {
    return 'Type: $type';
  }

  @override
  String get unknownNetwork => 'Unknown Network';

  @override
  String get actualUsed => 'Actual Used';

  @override
  String get arcCache => 'ARC Cache';

  @override
  String get demoModeIndicator => 'Demo Mode - Showing sample data';

  @override
  String get thermalSensors => 'Thermal Sensors';

  @override
  String get noThermalSensorsAvailable => 'No thermal sensors available';

  @override
  String get collapseAll => 'Collapse All';

  @override
  String get expandAll => 'Expand All';

  @override
  String get savingInstance => 'Saving instance...';

  @override
  String get myStaticKeyHint => 'My Static Key';

  @override
  String get staticKeyDescriptionHelper =>
      'A descriptive name for this static key';

  @override
  String get selectKeyModeHelper =>
      'Select the key mode for authentication or encryption';

  @override
  String get staticKeyHelpText =>
      '• Auth: Adds HMAC authentication to control channel\n• Crypt: Encrypts and authenticates all control channel packets\n• Crypt V2: Enhanced encryption with improved security\n\nYou can generate a new key or paste an existing one.';

  @override
  String get device => 'Device';

  @override
  String get listenPort => 'Listen Port';

  @override
  String get fwMark => 'FW Mark';

  @override
  String get peerStatus => 'Peer Status';

  @override
  String get handshakeAge => 'Handshake Age';

  @override
  String secondsAgo(int count) {
    return '$count seconds ago';
  }

  @override
  String get handshake => 'Handshake';

  @override
  String get processInformation => 'Process Information';

  @override
  String get processName => 'Process Name';

  @override
  String get processId => 'Process ID';

  @override
  String get logMessage => 'Log Message';

  @override
  String get message => 'Message';

  @override
  String get timestampInformation => 'Timestamp Information';

  @override
  String get rawTimestamp => 'Raw Timestamp';
}
