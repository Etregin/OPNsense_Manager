// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get about => 'Über';

  @override
  String get aboutDescription =>
      'Eine professionelle Flutter-Mobile-Anwendung zur Verwaltung von OPNsense-Firewall-Routern.';

  @override
  String get aboutImportExport => 'Über Import & Export';

  @override
  String get acceptDns => 'DNS akzeptieren';

  @override
  String get acceptDnsDescription =>
      'Von Tailscale bereitgestellte DNS-Server verwenden';

  @override
  String get acceptRoutes => 'Routen akzeptieren';

  @override
  String get acceptSubnetRoutes => 'Subnetz-Routen akzeptieren';

  @override
  String get acceptSubnetRoutesDescription =>
      'Von anderen Knoten angekündigte Routen akzeptieren';

  @override
  String get action => 'Aktion';

  @override
  String actionService(String action) {
    return '$action Dienst';
  }

  @override
  String actioningService(String action, String name) {
    return '$action $name...';
  }

  @override
  String get activate => 'Aktivieren';

  @override
  String activatedProfile(String name) {
    return 'Profil aktiviert: $name';
  }

  @override
  String get activatingProfile => 'Profil wird aktiviert...';

  @override
  String get activationFailed => 'Aktivierung fehlgeschlagen';

  @override
  String get active => 'Aktiv';

  @override
  String get activeDevices => 'Aktive Geräte';

  @override
  String activeHosts(int count) {
    return '$count aktive(r) Host(s)';
  }

  @override
  String get activeProfile => 'Aktives Profil';

  @override
  String get add => 'Hinzufügen';

  @override
  String get addClientOverride => 'Client-Überschreibung hinzufügen';

  @override
  String get addConnection => 'Verbindung hinzufügen';

  @override
  String get addConnectionEndpoint =>
      'Bitte fügen Sie mindestens einen Verbindungsendpunkt hinzu';

  @override
  String get addDnsServer => 'DNS-Server hinzufügen';

  @override
  String get addHost => 'Host hinzufügen';

  @override
  String get addHostToGetStarted =>
      'Fügen Sie einen Host hinzu, um zu beginnen';

  @override
  String get addInstance => 'Instanz hinzufügen';

  @override
  String get addOpenVpnInstance => 'OpenVPN-Instanz hinzufügen';

  @override
  String get addOverride => 'Überschreibung hinzufügen';

  @override
  String get addProfile => 'Profil Hinzufügen';

  @override
  String get addProfileToManageInstances =>
      'Fügen Sie ein Profil hinzu, um OPNsense-Instanzen zu verwalten';

  @override
  String get addStaticKey => 'Statischen Schlüssel hinzufügen';

  @override
  String get addSubnet => 'Subnetz hinzufügen';

  @override
  String get addTunnelAddress => 'Tunnel-Adresse hinzufügen';

  @override
  String get additionalInformation => 'Zusätzliche Informationen';

  @override
  String get advancedOptions => 'Advanced Options';

  @override
  String get address => 'Adresse';

  @override
  String get addressIsRequired => 'Adresse ist erforderlich';

  @override
  String get advertiseExitNode => 'Exit-Node ankündigen';

  @override
  String get advertiseExitNodeDescription =>
      'Anderen Geräten erlauben, über diesen Knoten zu routen';

  @override
  String get advertiseRoutes => 'Routen ankündigen';

  @override
  String get alert => 'Alarm';

  @override
  String get aliasDeletedSuccessfully => 'Alias erfolgreich gelöscht';

  @override
  String get aliasDisabledSuccessfully => 'Alias erfolgreich deaktiviert';

  @override
  String get aliasEnabledSuccessfully => 'Alias erfolgreich aktiviert';

  @override
  String get aliases => 'Aliase';

  @override
  String get all => 'Alle';

  @override
  String get allConnectionsSuccessful =>
      'Alle Verbindungen erfolgreich getestet';

  @override
  String get allDetailsCopiedToClipboard =>
      'Alle Details in Zwischenablage kopiert';

  @override
  String get allRoles => 'Alle Rollen';

  @override
  String get allSettingsSavedSuccessfully =>
      'Alle Einstellungen erfolgreich gespeichert';

  @override
  String get allStatus => 'Alle Status';

  @override
  String get allTypes => 'Alle Typen';

  @override
  String get allVpns => 'Alle VPNs';

  @override
  String get allowSelfSignedCertificates =>
      'Selbstsignierte Zertifikate zulassen';

  @override
  String get allowSelfSignedCertificatesDescription =>
      'Selbstsignierte SSL-Zertifikate akzeptieren';

  @override
  String get allowedIps => 'Erlaubte IPs';

  @override
  String get any => 'Beliebig';

  @override
  String get anyIpAddressCidrOrAlias => 'beliebig, IP-Adresse, CIDR oder Alias';

  @override
  String get anyPortNumberRangeOrAlias =>
      'beliebig, Portnummer, Bereich oder Alias';

  @override
  String apiError(String message) {
    return 'API-Fehler: $message';
  }

  @override
  String get apiKey => 'API-Schlüssel';

  @override
  String get apiKeyIsRequired => 'API-Schlüssel ist erforderlich';

  @override
  String get apiSecret => 'API-Geheimnis';

  @override
  String get apiSecretIsRequired => 'API-Geheimnis ist erforderlich';

  @override
  String get appearance => 'Erscheinungsbild';

  @override
  String get apply => 'Anwenden';

  @override
  String get architecture => 'Architektur';

  @override
  String get atLeastOneTunnelAddressRequired =>
      'Mindestens eine Tunneladresse ist erforderlich';

  @override
  String get authSettingsSavedSuccessfully =>
      'Authentifizierungseinstellungen erfolgreich gespeichert';

  @override
  String get authTlsAuthentication => 'Auth (TLS-Authentifizierung)';

  @override
  String get authTokenGeneratedSuccessfully =>
      'Auth-Token erfolgreich generiert';

  @override
  String get authenticate => 'Authentifizieren';

  @override
  String get authenticateToUnlock =>
      'Authentifizieren Sie sich, um OPNsense Manager zu entsperren';

  @override
  String get authentication => 'Authentifizierung';

  @override
  String get authenticationFailed => 'Authentifizierung fehlgeschlagen';

  @override
  String get authenticationRequired => 'Authentifizierung erforderlich';

  @override
  String get authenticationSettings => 'Authentifizierungseinstellungen';

  @override
  String get authenticated => 'Authentifiziert';

  @override
  String get notAuthenticated => 'Nicht authentifiziert';

  @override
  String get tailnet => 'Tailnet';

  @override
  String get deviceName => 'Gerätename';

  @override
  String get authUrl => 'Auth-URL';

  @override
  String get user => 'Benutzer';

  @override
  String get authorizedPeers => 'Autorisierte Peers';

  @override
  String get autoRefresh => 'Automatische Aktualisierung';

  @override
  String get automaticRule => 'Automatisch';

  @override
  String get backendState => 'Backend-Status';

  @override
  String get bandwidthLimit => 'Bandbreitenlimit';

  @override
  String get bandwidthLimitMbps => 'Bandbreitenlimit (Mbps)';

  @override
  String get bandwidthHistory => 'Bandbreitenverlauf';

  @override
  String get base64EncodedPrivateKeyKeepSecret =>
      'Base64-kodierter privater Schlüssel (geheim halten!)';

  @override
  String get base64EncodedPublicKey =>
      'Base64-kodierter öffentlicher Schlüssel';

  @override
  String get biometricAuth => 'Biometrische Authentifizierung';

  @override
  String get biometricAuthFailed =>
      'Biometrische Authentifizierung fehlgeschlagen oder abgebrochen';

  @override
  String get biometricLockDisabled => 'Biometrische Sperre deaktiviert';

  @override
  String get biometricLockEnabled => 'Biometrische Sperre aktiviert';

  @override
  String biometricLockTitle(String biometricType) {
    return '$biometricType-Sperre';
  }

  @override
  String get biometricNotAvailable =>
      'Biometrische Authentifizierung ist auf diesem Gerät nicht verfügbar';

  @override
  String get block => 'Blockieren';

  @override
  String get blockHost => 'Host blockieren';

  @override
  String blockHostConfirmation(String hostname, String ip) {
    return 'Möchten Sie $hostname ($ip) wirklich blockieren?\n\nDies erstellt eine Firewall-Regel, um den gesamten Datenverkehr von diesem Host zu blockieren.';
  }

  @override
  String get blockingHost => 'Host wird blockiert...';

  @override
  String get bytesReceived => 'Empfangene Bytes';

  @override
  String get bytesSent => 'Gesendete Bytes';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get cannotBeUndone =>
      'Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get cannotDeleteLastConnection =>
      'Der letzte Verbindungsendpunkt kann nicht gelöscht werden';

  @override
  String get carpVhidToDepend => 'CARP VHID, von dem abhängig';

  @override
  String get categories => 'Kategorien';

  @override
  String get changePin => 'PIN ändern';

  @override
  String get changesDiscarded => 'Änderungen verworfen';

  @override
  String get checkIfWireguardIsConfiguredAndRunning =>
      'Überprüfen Sie, ob WireGuard konfiguriert ist und läuft';

  @override
  String get chooseExportLocation => 'Export-Speicherort Wählen';

  @override
  String get cidrNotationRequired => 'CIDR-Notation erforderlich';

  @override
  String get clearLogs => 'Protokolle löschen';

  @override
  String get clearSelection => 'Auswahl löschen';

  @override
  String get client => 'Client';

  @override
  String get clientAddress => 'Client-Adresse';

  @override
  String get clientName => 'Client-Name';

  @override
  String get clientOverrides => 'Client-Überschreibungen';

  @override
  String get clientSettings => 'Client-Einstellungen';

  @override
  String get clientSpecificOverrides => 'Clientspezifische Überschreibungen';

  @override
  String get clientX509CommonNameHelper =>
      'Geben Sie hier den X.509 Common Name des Clients ein.';

  @override
  String get close => 'Schließen';

  @override
  String get commonName => 'Common Name';

  @override
  String get commonNameRequired => 'Common Name ist erforderlich';

  @override
  String commonNameWithValue(String value) {
    return 'Common Name: $value';
  }

  @override
  String get configurationAppliedSuccessfully =>
      'Konfiguration erfolgreich angewendet';

  @override
  String get configurationPreview => 'Konfigurationsvorschau';

  @override
  String get configureAdvertisedSubnets =>
      'Angekündigte Subnetze konfigurieren';

  @override
  String get configured => 'Konfiguriert';

  @override
  String get confirmDelete => 'Löschen bestätigen';

  @override
  String confirmDeleteInstance(String name) {
    return 'Möchten Sie die Instanz \"$name\" wirklich löschen? Diese Aktion kann nicht rückgängig gemacht werden.';
  }

  @override
  String confirmDeleteOverride(String name) {
    return 'Möchten Sie die Überschreibung für \"$name\" wirklich löschen? Diese Aktion kann nicht rückgängig gemacht werden.';
  }

  @override
  String confirmDeleteStaticKey(String name) {
    return 'Möchten Sie den statischen Schlüssel \"$name\" wirklich löschen? Diese Aktion kann nicht rückgängig gemacht werden.';
  }

  @override
  String get confirmNewPin => 'Neue PIN bestätigen';

  @override
  String get confirmPin => 'PIN bestätigen';

  @override
  String confirmServiceAction(String action, String name) {
    return '$action \"$name\"?';
  }

  @override
  String get connect => 'Verbinden';

  @override
  String get connectToYourOpnsenseFirewall =>
      'Verbinden Sie sich mit Ihrer OPNsense-Firewall';

  @override
  String get connectVpn => 'VPN verbinden';

  @override
  String get connected => 'Verbunden';

  @override
  String get connectedSince => 'Verbunden seit';

  @override
  String connectedSuccessfullyVia(String endpoint) {
    return 'Erfolgreich verbunden über: $endpoint';
  }

  @override
  String connectingVPN(String name) {
    return 'Verbinde mit $name...';
  }

  @override
  String get connectionBlocking => 'Verbindungsblockierung';

  @override
  String get connectionDetails => 'Verbindungsdetails';

  @override
  String get connectionEndpoints => 'Verbindungsendpunkte';

  @override
  String get connectionEndpointsHelp =>
      'Verwalten Sie mehrere Verbindungsendpunkte für dieses Profil. Die App versucht jeden Endpunkt der Reihe nach, bis eine erfolgreiche Verbindung hergestellt wird.';

  @override
  String get connectionFailed =>
      'Verbindung fehlgeschlagen. Überprüfen Sie die Konsolenprotokolle für Details.\n\nHäufige Probleme:\n• Gerät nicht im selben Netzwerk wie OPNsense\n• Falsche IP-Adresse oder Port\n• Firewall blockiert Verbindung\n• Ungültige API-Anmeldedaten';

  @override
  String connectionFailedError(String error) {
    return 'Verbindung fehlgeschlagen: $error';
  }

  @override
  String get connectionInformation => 'Verbindungsinformationen';

  @override
  String get connectionStatus => 'Verbindungsstatus';

  @override
  String get connectionSuccessful => 'Verbindung erfolgreich';

  @override
  String get connectionTestFailed => 'Verbindungstest fehlgeschlagen';

  @override
  String get connectionTestResults => 'Verbindungstestergebnisse';

  @override
  String get content => 'Inhalt';

  @override
  String copiedLogEntries(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'einträge',
      one: 'eintrag',
    );
    return '$count Protokoll$_temp0 kopiert';
  }

  @override
  String get copiedToClipboard => 'In Zwischenablage kopiert';

  @override
  String get copy => 'Kopieren';

  @override
  String get copyAllDetails => 'Alle Details kopieren';

  @override
  String get copyHost => 'Host kopieren';

  @override
  String get copyKey => 'Schlüssel kopieren';

  @override
  String get copySelected => 'Ausgewählte kopieren';

  @override
  String get cpuUsage => 'CPU-Auslastung';

  @override
  String get createAliasComingSoon => 'Alias erstellen (Demnächst)';

  @override
  String get createFirstAutomationRule =>
      'Erstellen Sie Ihre erste Automatisierungsregel, um zu beginnen';

  @override
  String get createFirstFirewallRule =>
      'Erstellen Sie Ihre erste Firewall-Regel, um zu beginnen';

  @override
  String get createFirstProfile =>
      'Erstellen Sie Ihr erstes Profil, um zu beginnen';

  @override
  String get createNewProfile => 'Neues Profil Erstellen';

  @override
  String get createOverride => 'Überschreibung erstellen';

  @override
  String get createPeer => 'Peer erstellen';

  @override
  String get createRule => 'Regel Erstellen';

  @override
  String get createServer => 'Server erstellen';

  @override
  String get createStaticKey => 'Statischen Schlüssel erstellen';

  @override
  String get createYourFirstProfile =>
      'Erstellen Sie Ihr erstes OPNsense-Profil, um zu beginnen';

  @override
  String get created => 'Erstellt';

  @override
  String get critical => 'Kritisch';

  @override
  String get cryptTlsEncryption => 'Crypt (TLS-Verschlüsselung)';

  @override
  String get cryptV2TlsEncryption => 'Crypt V2 (TLS-Verschlüsselung)';

  @override
  String get currentPin => 'Aktuelle PIN';

  @override
  String get currentPinIncorrect => 'Die aktuelle PIN ist falsch';

  @override
  String get darkMode => 'Dunkler Modus';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get day => 'Tag';

  @override
  String get days => 'Tage';

  @override
  String daysAgo(int days) {
    return 'vor $days Tagen';
  }

  @override
  String get debug => 'Debug';

  @override
  String get defineRoleOfInstance => 'Definieren Sie die Rolle dieser Instanz';

  @override
  String get delete => 'Löschen';

  @override
  String deleteAliasConfirmation(String aliasName) {
    return 'Möchten Sie den Alias \"$aliasName\" wirklich löschen?';
  }

  @override
  String get deleteConfirmation =>
      'Sind Sie sicher, dass Sie dieses Element löschen möchten?';

  @override
  String get deleteConnection => 'Verbindung löschen';

  @override
  String deleteConnectionConfirmation(String connectionName) {
    return 'Möchten Sie die Verbindung \"$connectionName\" wirklich löschen?';
  }

  @override
  String get deleteHost => 'Host löschen';

  @override
  String deleteHostConfirmation(String host) {
    return 'Möchten Sie \"$host\" wirklich löschen?';
  }

  @override
  String get deleteInstance => 'Instanz löschen';

  @override
  String get deleteOverride => 'Überschreibung löschen';

  @override
  String get deletePeer => 'Peer löschen';

  @override
  String deletePeerConfirmation(String name) {
    return 'Möchten Sie den Peer \"$name\" wirklich löschen?';
  }

  @override
  String get deleteProfile => 'Profil löschen';

  @override
  String deleteProfileConfirmation(String name) {
    return 'Sind Sie sicher, dass Sie \"$name\" löschen möchten?';
  }

  @override
  String get deleteRule => 'Regel löschen';

  @override
  String deleteRuleConfirmation(String description) {
    return 'Sind Sie sicher, dass Sie die Regel \"$description\" löschen möchten?';
  }

  @override
  String disableRuleConfirmation(String description) {
    return 'Sind Sie sicher, dass Sie die Regel \"$description\" deaktivieren möchten?';
  }

  @override
  String enableRuleConfirmation(String description) {
    return 'Sind Sie sicher, dass Sie die Regel \"$description\" aktivieren möchten?';
  }

  @override
  String deleteServerConfirmation(String name) {
    return 'Möchten Sie den Server \"$name\" wirklich löschen? Diese Aktion kann nicht rückgängig gemacht werden.';
  }

  @override
  String get deleteStaticKey => 'Statischen Schlüssel löschen';

  @override
  String get deleteSubnet => 'Subnetz löschen';

  @override
  String deleteSubnetConfirmation(String subnet) {
    return 'Möchten Sie das Subnetz $subnet wirklich löschen?';
  }

  @override
  String get demo => 'Demo';

  @override
  String get dependOnCarp => 'Abhängig von (CARP)';

  @override
  String get description => 'Beschreibung';

  @override
  String get descriptionHelperText => 'Eine kurze Beschreibung dieser Instanz';

  @override
  String get descriptionHelperTextOverride =>
      'Sie können hier eine Beschreibung zu Ihrer Referenz eingeben (wird nicht geparst).';

  @override
  String get descriptionHint => 'z.B. Wohnzimmer-PC';

  @override
  String get descriptionOptional => 'Beschreibung (optional)';

  @override
  String get descriptionRequired => 'Beschreibung ist erforderlich';

  @override
  String get destination => 'Ziel';

  @override
  String get destinationAddress => 'Zieladresse';

  @override
  String get destinationIsRequired => 'Ziel ist erforderlich';

  @override
  String get destinationPort => 'Zielport';

  @override
  String get destinationPortOptional => 'Zielport (Optional)';

  @override
  String get deviceType => 'Gerätetyp';

  @override
  String get dhcpLeases => 'DHCP-Leases';

  @override
  String dhcpServerLabel(String serverName) {
    return '$serverName-Server';
  }

  @override
  String get dhcpServerType => 'DHCP-Servertyp';

  @override
  String get direction => 'Richtung';

  @override
  String get directionBoth => 'Both';

  @override
  String get directionIn => 'In';

  @override
  String get directionOut => 'Out';

  @override
  String get disable => 'Deaktivieren';

  @override
  String get disableAutoScroll => 'Automatisches Scrollen deaktivieren';

  @override
  String get disableRoutes => 'Routen deaktivieren';

  @override
  String get disableRoutesDescription =>
      'Automatische Routeninstallation verhindern';

  @override
  String get disableRule => 'Regel deaktivieren';

  @override
  String get disableSnat => 'SNAT deaktivieren';

  @override
  String get disableSnatDescription =>
      'Quell-NAT für Subnetz-Routen deaktivieren';

  @override
  String get disabled => 'Deaktiviert';

  @override
  String get disablingRule => 'Regel wird deaktiviert...';

  @override
  String get discard => 'Verwerfen';

  @override
  String get disconnect => 'Trennen';

  @override
  String get disconnectVpn => 'VPN trennen';

  @override
  String get disconnected => 'Getrennt';

  @override
  String disconnectingVPN(String name) {
    return 'Trenne $name...';
  }

  @override
  String get diskUsage => 'Festplattennutzung';

  @override
  String get dnsDomainList => 'DNS-Domänenliste';

  @override
  String get dnsDomainListHelperText =>
      'Verbindungsspezifische DNS-Suffixe festlegen.';

  @override
  String get dnsDomainSearchList => 'DNS-Domänensuchliste';

  @override
  String get dnsDomainSearchListHelperText =>
      'Namen zur Domänensuchliste hinzufügen. Wiederholen Sie diese Option, um weitere Einträge hinzuzufügen. Bis zu 10 Domänen werden unterstützt.';

  @override
  String get dnsEnabled => 'DNS aktiviert';

  @override
  String get dnsServerIp => 'DNS-Server-IP';

  @override
  String get dnsServerIsRequired => 'DNS-Server ist erforderlich';

  @override
  String get dnsServerOptional => 'DNS-Server (Optional)';

  @override
  String get dnsServers => 'DNS-Server';

  @override
  String get dnsServersHelperText =>
      'Primäre Domain Name Server IPv4- oder IPv6-Adresse festlegen. Wiederholen Sie diese Option, um sekundäre DNS-Serveradressen festzulegen.';

  @override
  String get dnsServersOptional => 'DNS-Server (Optional)';

  @override
  String get dnsmasqDescription => 'Leichtgewichtiger DNS- und DHCP-Server';

  @override
  String get done => 'Fertig';

  @override
  String get download => 'Download';

  @override
  String get dynamicLease => 'Dynamisch';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get editClientOverride => 'Client-Überschreibung bearbeiten';

  @override
  String get editConnection => 'Verbindung bearbeiten';

  @override
  String get editHost => 'Host bearbeiten';

  @override
  String get editProfile => 'Profil bearbeiten';

  @override
  String get editRule => 'Regel Bearbeiten';

  @override
  String get editStaticKey => 'Statischen Schlüssel bearbeiten';

  @override
  String get editSubnet => 'Subnetz bearbeiten';

  @override
  String get editWireguardPeer => 'WireGuard-Peer bearbeiten';

  @override
  String get editWireguardServer => 'WireGuard-Server bearbeiten';

  @override
  String get emergency => 'Notfall';

  @override
  String get enable => 'Aktivieren';

  @override
  String get enableAutoScroll => 'Automatisches Scrollen aktivieren';

  @override
  String get enableClientSpecificOverride =>
      'Diese clientspezifische Überschreibung aktivieren';

  @override
  String get enableDebugLogging => 'Debug-Protokollierung aktivieren';

  @override
  String get enablePinLockFirstBiometric =>
      'Aktivieren Sie zuerst die PIN-Sperre, um Biometrie zu verwenden';

  @override
  String get enableRule => 'Regel aktivieren';

  @override
  String get enableSsh => 'SSH aktivieren';

  @override
  String get enableSshDescription => 'SSH-Zugriff über Tailscale erlauben';

  @override
  String get enableTailscale => 'Tailscale aktivieren';

  @override
  String get enableTailscaleDescription =>
      'Tailscale-Dienst aktivieren oder deaktivieren';

  @override
  String get enableWireguard => 'WireGuard aktivieren';

  @override
  String get enabled => 'Aktiviert';

  @override
  String get enablingRule => 'Regel wird aktiviert...';

  @override
  String get endTime => 'Endzeit';

  @override
  String get endpoint => 'Endpunkt';

  @override
  String get endpointAddress => 'Endpunktadresse';

  @override
  String get endpointPort => 'Endpunkt-Port';

  @override
  String get enterBandwidthLimit =>
      'Geben Sie Ihr Verbindungsbandbreitenlimit in Mbps ein';

  @override
  String get enterClientCertificateCommonName =>
      'Geben Sie den Common Name des Client-Zertifikats ein';

  @override
  String get enterDescriptionForOverride =>
      'Geben Sie eine Beschreibung für diese Überschreibung ein';

  @override
  String get enterOrGeneratePresharedKey =>
      'Pre-Shared-Key eingeben oder generieren';

  @override
  String get enterOrGeneratePrivateKey =>
      'Privaten Schlüssel eingeben oder generieren';

  @override
  String get enterOrGeneratePublicKey =>
      'Öffentlichen Schlüssel eingeben oder generieren';

  @override
  String get enterPin => 'PIN Eingeben';

  @override
  String get enterPinLabel => 'PIN eingeben (4-6 Ziffern)';

  @override
  String get enterRuleDescription => 'Regelbeschreibung eingeben';

  @override
  String get enterYourApiKey => 'Geben Sie Ihren API-Schlüssel ein';

  @override
  String get enterYourApiSecret => 'Geben Sie Ihr API-Geheimnis ein';

  @override
  String get entries => 'Einträge';

  @override
  String entriesCount(int count) {
    return '$count Einträge';
  }

  @override
  String get error => 'Fehler';

  @override
  String errorAddingSubnet(String error) {
    return 'Fehler beim Hinzufügen des Subnetzes: $error';
  }

  @override
  String errorDeletingRule(String error) {
    return 'Fehler beim Löschen der Regel: $error';
  }

  @override
  String errorDeletingSubnet(String error) {
    return 'Fehler beim Löschen des Subnetzes: $error';
  }

  @override
  String get errorLoadingData => 'Fehler beim Laden der Daten';

  @override
  String get errorLoadingInstance => 'Fehler beim Laden der Instanz';

  @override
  String get errorLoadingLogs => 'Fehler beim Laden der Protokolle';

  @override
  String get errorLoadingOverride => 'Fehler beim Laden der Überschreibung';

  @override
  String get errorLoadingRoutes => 'Fehler beim Laden der Routen';

  @override
  String get errorLoadingRules => 'Fehler beim Laden der Regeln';

  @override
  String get errorLoadingSessions => 'Fehler beim Laden der Sitzungen';

  @override
  String get errorLoadingSystemInfo =>
      'Fehler beim Laden der Systeminformationen';

  @override
  String get errorLoadingVpnConnections =>
      'Fehler beim Laden der VPN-Verbindungen';

  @override
  String errorPrefix(String message) {
    return 'Fehler: $message';
  }

  @override
  String errorRestartingService(String error) {
    return 'Fehler beim Neustarten des Dienstes: $error';
  }

  @override
  String errorSavingRule(String error) {
    return 'Fehler beim Speichern der Regel: $error';
  }

  @override
  String errorStartingService(String error) {
    return 'Fehler beim Starten des Dienstes: $error';
  }

  @override
  String errorStoppingService(String error) {
    return 'Fehler beim Stoppen des Dienstes: $error';
  }

  @override
  String errorTogglingRule(String error) {
    return 'Fehler beim Umschalten der Regel: $error';
  }

  @override
  String errorUpdatingSubnet(String error) {
    return 'Fehler beim Aktualisieren des Subnetzes: $error';
  }

  @override
  String get exampleCidr => 'Beispiel: 10.10.10.2/24 oder fd00::2/64';

  @override
  String get exampleTunnelAddress => 'Beispiel: 10.10.10.1/24 oder fd00::1/64';

  @override
  String get examplesAnyIpCidr => 'Beispiele: any, 192.168.1.0/24, 10.0.0.1';

  @override
  String get examplesAnyPortRange => 'Beispiele: any, 80, 1024-65535';

  @override
  String get examplesAnyPortRangeHttp => 'Beispiele: any, 80, 80-443, http';

  @override
  String get exitNode => 'Exit-Knoten';

  @override
  String get expired => 'Abgelaufen';

  @override
  String get expires => 'Läuft ab';

  @override
  String get expiryTime => 'Ablaufzeit';

  @override
  String get export => 'Exportieren';

  @override
  String get exportAllProfiles => 'Alle Profile exportieren';

  @override
  String get exportAllProfilesSubtitle =>
      'Alle Profile in eine JSON-Datei exportieren';

  @override
  String get exportCredentialsWarning =>
      'Beim Export mit Anmeldedaten werden API-Schlüssel und Geheimnisse im Klartext gespeichert. Tun Sie dies nur, wenn Sie die Datei sicher speichern.';

  @override
  String get exportFailed => 'Export fehlgeschlagen';

  @override
  String exportFailedError(String error) {
    return 'Export fehlgeschlagen: $error';
  }

  @override
  String get exportLogs => 'Protokolle exportieren';

  @override
  String get exportProfiles => 'Profile exportieren';

  @override
  String get exportProfilesContent =>
      'Möchten Sie API-Anmeldedaten in den Export einschließen?\n\nWARNUNG: Das Einschließen von Anmeldedaten speichert API-Schlüssel und Geheimnisse im Klartext. Schließen Sie Anmeldedaten nur ein, wenn Sie die Datei sicher speichern.';

  @override
  String get exportSuccess => 'Export erfolgreich';

  @override
  String get exportThisProfile => 'Dieses Profil exportieren';

  @override
  String get failedDevices => 'Fehlgeschlagene Geräte';

  @override
  String failedToActionTailscaleService(String action) {
    return 'Fehler beim $action des Tailscale-Dienstes';
  }

  @override
  String get failedToApplyConfiguration =>
      'Fehler beim Anwenden der Konfiguration';

  @override
  String failedToSwitchProfile(String error) {
    return 'Profil wechseln fehlgeschlagen: $error';
  }

  @override
  String get failedToBlockHost => 'Host konnte nicht blockiert werden';

  @override
  String failedToConnect(String name) {
    return 'Verbindung zu $name fehlgeschlagen';
  }

  @override
  String failedToCopyHost(String error) {
    return 'Host konnte nicht kopiert werden: $error';
  }

  @override
  String failedToDeleteAlias(String error) {
    return 'Alias konnte nicht gelöscht werden: $error';
  }

  @override
  String failedToDeleteHost(String error) {
    return 'Host konnte nicht gelöscht werden: $error';
  }

  @override
  String failedToDeleteInstance(String error) {
    return 'Fehler beim Löschen der Instanz: $error';
  }

  @override
  String failedToDeleteOverride(String error) {
    return 'Fehler beim Löschen der Überschreibung: $error';
  }

  @override
  String failedToDeletePeer(String error) {
    return 'Fehler beim Löschen des Peers: $error';
  }

  @override
  String get failedToDeleteProfile => 'Profil konnte nicht gelöscht werden';

  @override
  String failedToDeleteServer(String error) {
    return 'Fehler beim Löschen des Servers: $error';
  }

  @override
  String failedToDeleteStaticKey(String error) {
    return 'Fehler beim Löschen des statischen Schlüssels: $error';
  }

  @override
  String failedToDisconnect(String name) {
    return 'Trennung von $name fehlgeschlagen';
  }

  @override
  String failedToExportLogs(String error) {
    return 'Fehler beim Exportieren der Protokolle: $error';
  }

  @override
  String failedToGenerateKey(String error) {
    return 'Fehler beim Generieren des Schlüssels: $error';
  }

  @override
  String failedToGenerateToken(String error) {
    return 'Fehler beim Generieren des Tokens: $error';
  }

  @override
  String failedToLoadInterfaces(String error) {
    return 'Schnittstellen konnten nicht geladen werden: $error';
  }

  @override
  String get failedToLoadOpenvpnLogs =>
      'Fehler beim Laden der OpenVPN-Protokolle';

  @override
  String failedToRestartService(String type) {
    return 'Neustart des $type-Dienstes fehlgeschlagen';
  }

  @override
  String get failedToSaveAuthSettings =>
      'Fehler beim Speichern der Authentifizierungseinstellungen';

  @override
  String failedToSaveHost(String error) {
    return 'Host konnte nicht gespeichert werden: $error';
  }

  @override
  String failedToSaveInstance(String error) {
    return 'Fehler beim Speichern der Instanz: $error';
  }

  @override
  String failedToSaveOverride(String error) {
    return 'Fehler beim Speichern der Überschreibung: $error';
  }

  @override
  String get failedToSavePeer => 'Fehler beim Speichern des Peers';

  @override
  String get failedToSaveProfile => 'Profil konnte nicht gespeichert werden';

  @override
  String get failedToSaveServer => 'Fehler beim Speichern des Servers';

  @override
  String get failedToSaveSettings => 'Fehler beim Speichern der Einstellungen';

  @override
  String failedToSaveStaticKey(String error) {
    return 'Fehler beim Speichern des statischen Schlüssels: $error';
  }

  @override
  String get failedToStartService => 'Dienst konnte nicht gestartet werden';

  @override
  String get failedToStopService => 'Dienst konnte nicht gestoppt werden';

  @override
  String failedToToggleAlias(String error) {
    return 'Alias konnte nicht umgeschaltet werden: $error';
  }

  @override
  String failedToToggleInstance(String error) {
    return 'Fehler beim Umschalten der Instanz: $error';
  }

  @override
  String failedToToggleOverride(String error) {
    return 'Fehler beim Umschalten der Überschreibung: $error';
  }

  @override
  String failedToTogglePeer(String error) {
    return 'Fehler beim Umschalten des Peers: $error';
  }

  @override
  String failedToToggleServer(String error) {
    return 'Fehler beim Umschalten des Servers: $error';
  }

  @override
  String failedToWakeAllHosts(String error) {
    return 'Alle Hosts konnten nicht aufgeweckt werden: $error';
  }

  @override
  String failedToWakeHost(String error) {
    return 'Host konnte nicht aufgeweckt werden: $error';
  }

  @override
  String featureComingSoon(String feature) {
    return '$feature - Demnächst verfügbar';
  }

  @override
  String get featuresList =>
      '• Systemüberwachung und -verwaltung\n• Firewall-Regelkonfiguration\n• Dienststeuerung\n• Echtzeit-Protokolle\n• Multi-Profil-Unterstützung\n• Sichere Authentifizierung';

  @override
  String get featuresTitle => 'Funktionen';

  @override
  String fieldIsRequired(String fieldName) {
    return '$fieldName ist erforderlich';
  }

  @override
  String get fieldRequired => 'Dieses Feld ist erforderlich';

  @override
  String get fifteenMin => '15 Min';

  @override
  String get filterByAction => 'Nach Aktion filtern';

  @override
  String get filterByType => 'Nach Typ filtern';

  @override
  String get filterLabel => 'Filter: ';

  @override
  String get filters => 'Filter';

  @override
  String get firewall => 'Firewall';

  @override
  String get firewallAliases => 'Firewall-Aliase';

  @override
  String get firewallLogs => 'Firewall-Protokolle';

  @override
  String get firewallRuleDetails => 'Firewall-Regel-Details';

  @override
  String get firewallRules => 'Firewall-Regeln';

  @override
  String get firmwareDetails => 'Firmware-Details';

  @override
  String get fiveMin => '5 Min';

  @override
  String get floatingInterface => 'Schwebend';

  @override
  String get fixFormErrors => 'Bitte beheben Sie die Fehler im Formular';

  @override
  String get forbidden => 'Zugriff verboten';

  @override
  String get gateway => 'Gateway';

  @override
  String get gatewayOptional => 'Gateway (Optional)';

  @override
  String get gateways => 'Gateways';

  @override
  String get general => 'Allgemein';

  @override
  String get generalSettings => 'Allgemeine Einstellungen';

  @override
  String get generateKey => 'Schlüssel generieren';

  @override
  String get generateKeyPair => 'Schlüsselpaar generieren';

  @override
  String get generateNewKeyPair => 'Neues Schlüsselpaar generieren';

  @override
  String get generateOrPasteKeyHere =>
      'Schlüssel generieren oder hier einfügen';

  @override
  String get generatePresharedKey => 'Pre-Shared-Key generieren';

  @override
  String get generated => 'Generiert';

  @override
  String get generating => 'Wird generiert...';

  @override
  String get gitCommit => 'Git-Commit';

  @override
  String get healthStatus => 'Gesundheitsstatus';

  @override
  String get hideControls => 'Steuerelemente ausblenden';

  @override
  String get hideKey => 'Schlüssel ausblenden';

  @override
  String get historySize => 'Verlaufsgröße';

  @override
  String get host => 'Host';

  @override
  String get hostAddedSuccessfully => 'Host erfolgreich hinzugefügt';

  @override
  String get hostBlocked => 'Host erfolgreich blockiert';

  @override
  String get hostDeletedSuccessfully => 'Host erfolgreich gelöscht';

  @override
  String get hostHint => 'z.B. 192.168.1.1 oder firewall.example.com';

  @override
  String get hostIpAddress => 'Host / IP-Adresse';

  @override
  String get hostIsRequired => 'Host ist erforderlich';

  @override
  String get hostPlaceholder => '192.168.1.1 oder firewall.example.com';

  @override
  String get hostUpdatedSuccessfully => 'Host erfolgreich aktualisiert';

  @override
  String get hostname => 'Hostname';

  @override
  String get hour => 'Stunde';

  @override
  String get hours => 'Stunden';

  @override
  String hoursAgo(int hours) {
    return 'Vor ${hours}h';
  }

  @override
  String get id => 'ID';

  @override
  String get import => 'Importieren';

  @override
  String get importAndExport => 'Import & Export';

  @override
  String get importExportDescription =>
      'Exportieren Sie Ihre Profile, um sie zu sichern oder auf ein anderes Gerät zu übertragen. Importieren Sie Profile aus einer zuvor exportierten Datei.\n\nProfile werden im JSON-Format gespeichert und können Verbindungsendpunkte und Einstellungen enthalten.';

  @override
  String importFailed(String error) {
    return 'Import fehlgeschlagen: $error';
  }

  @override
  String get importProfiles => 'Profile importieren';

  @override
  String get importProfilesDialog =>
      'Wie sollen vorhandene Profile behandelt werden?\n\n• Beide Behalten: Mit neuen IDs importieren\n• Überschreiben: Vorhandene Profile ersetzen';

  @override
  String get importProfilesSubtitle =>
      'Profile aus einer JSON-Datei importieren';

  @override
  String get importSuccess => 'Import erfolgreich';

  @override
  String importedWithFailures(int failed, int success) {
    String _temp0 = intl.Intl.pluralLogic(
      success,
      locale: localeName,
      other: 'Profile',
      one: 'Profil',
    );
    return '$success $_temp0 importiert, $failed fehlgeschlagen';
  }

  @override
  String inDays(int days) {
    return 'in ${days}T';
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
  String get inbound => 'Eingehend';

  @override
  String get includeCredentials => 'Anmeldedaten Einschließen';

  @override
  String get incorrectPin => 'Falsche PIN';

  @override
  String get info => 'Information';

  @override
  String get instance => 'Instanz';

  @override
  String get instanceCreatedSuccessfully => 'Instanz erfolgreich erstellt';

  @override
  String get instanceDeletedSuccessfully => 'Instanz erfolgreich gelöscht';

  @override
  String get instanceDetails => 'Instanzdetails';

  @override
  String instanceToggledSuccessfully(String status) {
    return 'Instanz erfolgreich $status';
  }

  @override
  String get instanceUpdatedSuccessfully => 'Instanz erfolgreich aktualisiert';

  @override
  String get instanceWillBeActiveWhenEnabled =>
      'Instanz wird aktiv sein, wenn aktiviert';

  @override
  String get instances => 'Instanzen';

  @override
  String get interface => 'Schnittstelle';

  @override
  String get invalidApiKeyFormat => 'Ungültiges API-Schlüsselformat';

  @override
  String get invalidApiSecretFormat => 'Ungültiges API-Geheimnisformat';

  @override
  String get invalidBase64Format => 'Ungültiges Base64-Format';

  @override
  String get invalidCidrNotation => 'Ungültige CIDR-Notation';

  @override
  String get invalidDestinationFormat => 'Ungültiges Zielformat';

  @override
  String invalidFileFormat(String error) {
    return 'Ungültige Datei: $error';
  }

  @override
  String get invalidHostnameOrIp => 'Ungültiger Hostname oder IP-Adresse';

  @override
  String get invalidInput => 'Ungültige Eingabe';

  @override
  String get invalidIpAddress => 'Ungültige IP-Adresse';

  @override
  String get invalidIpAddressFormat =>
      'Ungültiges IP-Adressformat (muss IPv4 oder IPv6 sein)';

  @override
  String get invalidIpv4Address => 'Ungültige IPv4-Adresse';

  @override
  String get invalidIpv4CidrNotation => 'Ungültige IPv4-CIDR-Notation';

  @override
  String get invalidIpv4Prefix => 'Ungültiges IPv4-Präfix (muss 0-32 sein)';

  @override
  String get invalidIpv6Address => 'Ungültige IPv6-Adresse';

  @override
  String get invalidIpv6CidrNotation => 'Ungültige IPv6-CIDR-Notation';

  @override
  String get invalidIpv6Prefix => 'Ungültiges IPv6-Präfix (muss 0-128 sein)';

  @override
  String get invalidPin => 'Ungültige PIN';

  @override
  String get invalidPortFormat => 'Ungültiges Portformat';

  @override
  String get invalidPrefixLength => 'Ungültige Präfixlänge';

  @override
  String get invalidSourceFormat => 'Ungültiges Quellformat';

  @override
  String get invertDestination => 'Invert destination';

  @override
  String get invertDestinationTooltip =>
      'Match any address EXCEPT the destination';

  @override
  String get invertSource => 'Invert source';

  @override
  String get invertSourceTooltip => 'Match any address EXCEPT the source';

  @override
  String get ipAddress => 'IP-Adresse';

  @override
  String get ipAddresses => 'IP-Adressen';

  @override
  String get ipAny => 'Any';

  @override
  String get ipProtocol => 'IP Version';

  @override
  String get ipv4TunnelNetwork => 'IPv4-Tunnel-Netzwerk';

  @override
  String get ipv6TunnelNetwork => 'IPv6-Tunnel-Netzwerk';

  @override
  String get iscDhcpDescription => 'Internet Systems Consortium DHCP-Server';

  @override
  String itemsCount(int count) {
    return '$count Element(e)';
  }

  @override
  String get justNow => 'Gerade eben';

  @override
  String get keaDhcpDescription => 'Moderner, leistungsstarker DHCP-Server';

  @override
  String get keepAliveIntervalOptional => 'Keep-Alive-Intervall (Optional)';

  @override
  String get keepBoth => 'Beide Behalten';

  @override
  String get keepState => 'Keep State';

  @override
  String get keepalive => 'Keepalive';

  @override
  String get keepaliveOptional => 'Keepalive (Optional)';

  @override
  String get key => 'Schlüssel';

  @override
  String get keyCopiedToClipboard => 'Schlüssel in Zwischenablage kopiert';

  @override
  String get keyGeneratedSuccessfully => 'Schlüssel erfolgreich generiert';

  @override
  String keyWithId(String id) {
    return 'Schlüssel $id';
  }

  @override
  String get keysGeneratedSuccessfully => 'Schlüssel erfolgreich generiert';

  @override
  String get keysRequired =>
      'Private und öffentliche Schlüssel sind erforderlich';

  @override
  String get label => 'Bezeichnung';

  @override
  String get labelHint => 'z.B. Heimnetzwerk, Büro-VPN';

  @override
  String get labelOptional => 'Bezeichnung (Optional)';

  @override
  String get language => 'Sprache';

  @override
  String get lastDay => 'Letzter Tag';

  @override
  String get lastDayShort => '1 Tag';

  @override
  String get lastMonth => 'Letzter Monat';

  @override
  String get lastMonthShort => '1 Monat';

  @override
  String get lastUpdate => 'Letzte Aktualisierung';

  @override
  String lastUsed(String date) {
    return 'Zuletzt verwendet: $date';
  }

  @override
  String get lastWeek => 'Letzte Woche';

  @override
  String get lastWeekShort => '1 Woche';

  @override
  String leasesCount(int filtered, int total) {
    return '$filtered von $total Lease(s)';
  }

  @override
  String get leaveEmptyOrGenerate => 'Leer lassen oder generieren';

  @override
  String get licenses => 'Lizenzen';

  @override
  String get lightMode => 'Heller Modus';

  @override
  String get limit => 'Limit';

  @override
  String get live => 'Live';

  @override
  String get liveNetworkMonitor => 'Live-Netzwerkmonitor';

  @override
  String get neighborDiscovery => 'Nachbarerkennung';

  @override
  String get loading => 'Lädt...';

  @override
  String get loadingHostData => 'Host-Daten werden geladen...';

  @override
  String get loadingSettings => 'Einstellungen werden geladen...';

  @override
  String get localAddress => 'Lokale Adresse';

  @override
  String get localNetwork => 'Lokales Netzwerk';

  @override
  String get localNetworkHelperText =>
      'Dies sind die vom Client zugänglichen Netzwerke, die über route(-ipv6)-Klauseln in OpenVPN an den Client gepusht werden.';

  @override
  String lockAfterMinutes(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'Minuten',
      one: 'Minute',
    );
    return 'Sperren nach $minutes $_temp0 Inaktivität';
  }

  @override
  String get lockApp => 'App sperren';

  @override
  String get lockTimeoutLabel => 'Sperr-Timeout';

  @override
  String lockTimeoutSet(int value) {
    String _temp0 = intl.Intl.pluralLogic(
      value,
      locale: localeName,
      other: 'Minuten',
      one: 'Minute',
    );
    return 'Sperr-Timeout auf $value $_temp0 gesetzt';
  }

  @override
  String get longPressToCopy => 'Long press to copy';

  @override
  String get logDetails => 'Protokolldetails';

  @override
  String get logEntryCopied => 'Protokolleintrag kopiert';

  @override
  String get logEntryDetails => 'Protokolleintrag-Details';

  @override
  String get logFile => 'Protokolldatei';

  @override
  String get logLimit => 'Protokollgrenze';

  @override
  String get login => 'Anmelden';

  @override
  String get loginServer => 'Anmeldeserver';

  @override
  String get loginServerHelperText => 'Die Tailscale-Anmeldeserver-URL';

  @override
  String get loginServerRequired => 'Anmeldeserver ist erforderlich';

  @override
  String get logTraffic => 'Log Traffic';

  @override
  String get logTrafficSubtitle => 'Log packets matched by this rule';

  @override
  String get logout => 'Abmelden';

  @override
  String get logs => 'Protokolle';

  @override
  String get logsExportedSuccessfully => 'Protokolle erfolgreich exportiert';

  @override
  String get logsMatchingFiltersWillAppearHere =>
      'Protokolle, die den Filtern entsprechen, werden hier angezeigt';

  @override
  String get logsWillAppear =>
      'Protokolle werden hier angezeigt, sobald sie generiert werden';

  @override
  String get macAddress => 'MAC-Adresse';

  @override
  String get macAddressHint => 'z.B. 00:11:22:33:44:55';

  @override
  String get macAddressIsRequired => 'MAC-Adresse ist erforderlich';

  @override
  String get invalidMacAddressFormat =>
      'Ungültiges MAC-Adressformat (z.B. AA:BB:CC:DD:EE:FF)';

  @override
  String get manageProfiles => 'Profile verwalten';

  @override
  String get manageSubnets => 'Subnetze verwalten';

  @override
  String get manageWireguard => 'WireGuard verwalten';

  @override
  String get manufacturer => 'Hersteller';

  @override
  String get maximumTransmissionUnit =>
      'Maximale Übertragungseinheit (576-9000)';

  @override
  String get memoryUsage => 'Speicherauslastung';

  @override
  String get minute => 'Minute';

  @override
  String get minutes => 'Minuten';

  @override
  String minutesAgo(int minutes) {
    return 'Vor ${minutes}m';
  }

  @override
  String get mode => 'Modus';

  @override
  String get modified => 'Geändert';

  @override
  String get modulateState => 'Modulate State';

  @override
  String get monitorInterface => 'Überwachungsschnittstelle';

  @override
  String get mssFix => 'MSS-Fix';

  @override
  String get mssFixDescription => 'MSS-Fix für diese Verbindung aktivieren';

  @override
  String get mtuOptional => 'MTU (Optional)';

  @override
  String get mustBeValidUrl =>
      'Muss eine gültige URL sein, die mit http:// oder https:// beginnt';

  @override
  String get myOPNsenseRouter => 'Mein OPNsense-Router';

  @override
  String get myOpenvpnInstance => 'Meine OpenVPN-Instanz';

  @override
  String get myStaticKey => 'Mein statischer Schlüssel';

  @override
  String get myWireguardPeer => 'Mein WireGuard-Peer';

  @override
  String get myWireguardServer => 'Mein WireGuard-Server';

  @override
  String get name => 'Name';

  @override
  String get needHelpCheckDocumentation =>
      'Benötigen Sie Hilfe? Überprüfen Sie die OPNsense-Dokumentation zur API-Schlüsselgenerierung.';

  @override
  String get networkConfiguration => 'Netzwerkkonfiguration';

  @override
  String get networkError => 'Netzwerkfehler aufgetreten';

  @override
  String get networkInformation => 'Netzwerkinformationen';

  @override
  String get networkTotals => 'Netzwerk-Summen';

  @override
  String get newPin => 'Neue PIN (4-6 Ziffern)';

  @override
  String get newPinMustBeDifferent =>
      'Die neue PIN muss sich von der aktuellen unterscheiden';

  @override
  String get newRule => 'Neue Regel';

  @override
  String get newWireguardPeer => 'Neuer WireGuard-Peer';

  @override
  String get newWireguardServer => 'Neuer WireGuard-Server';

  @override
  String get next => 'Weiter';

  @override
  String get no => 'Nein';

  @override
  String get noAliasesConfigured => 'Keine Aliase konfiguriert';

  @override
  String get noAliasesMatchFilters =>
      'Keine Aliase entsprechen den aktuellen Filtern';

  @override
  String get noAutomationRulesFound => 'Keine Automatisierungsregeln gefunden';

  @override
  String get noFirewallRulesFound => 'Keine Firewall-Regeln gefunden';

  @override
  String get noClientSpecificOverridesConfigured =>
      'Keine clientspezifischen Überschreibungen konfiguriert';

  @override
  String noConnectionsFound(String type) {
    return 'Keine $type-Verbindungen gefunden';
  }

  @override
  String get noDataAvailable => 'Keine Daten verfügbar';

  @override
  String get noDescription => 'Keine Beschreibung';

  @override
  String get noDnsDomainSearchEntriesConfigured =>
      'Keine DNS-Domänensucheinträge konfiguriert';

  @override
  String get noDnsDomainsConfigured => 'Keine DNS-Domänen konfiguriert';

  @override
  String get noDnsServersConfigured => 'Keine DNS-Server konfiguriert';

  @override
  String get noHostsFound => 'Keine Hosts gefunden';

  @override
  String get noInstancesMatchFilters =>
      'Keine Instanzen entsprechen den Filtern';

  @override
  String get noInterfacesWithAutomationRules =>
      'Keine Schnittstellen mit Automatisierungsregeln';

  @override
  String get noInterfacesWithRules => 'Keine Schnittstellen mit Regeln';

  @override
  String get noItemsConfigured => 'Keine Elemente konfiguriert';

  @override
  String get noLeasesFound => 'Keine Leases gefunden';

  @override
  String get noLimit => 'Keine Begrenzung';

  @override
  String get noLimitShort => 'Alle';

  @override
  String get noLocalNetworksConfigured =>
      'Keine lokalen Netzwerke konfiguriert';

  @override
  String get noLogEntriesFound => 'Keine Protokolleinträge gefunden';

  @override
  String get noLogsAvailable => 'Keine Protokolle verfügbar';

  @override
  String get noLogsToExport => 'Keine Protokolle zum Exportieren';

  @override
  String get noNtpServersConfigured => 'Keine NTP-Server konfiguriert';

  @override
  String get noOpenvpnInstancesConfigured =>
      'Keine OpenVPN-Instanzen konfiguriert';

  @override
  String get noOpenvpnRoutesConfigured => 'Keine OpenVPN-Routen konfiguriert';

  @override
  String get noOpenvpnSessionsConfigured =>
      'Es sind keine OpenVPN-Sitzungen konfiguriert';

  @override
  String get noOptionsAvailable => 'Keine Optionen verfügbar';

  @override
  String get noOverridesMatchFilter =>
      'Keine Überschreibungen entsprechen dem Filter';

  @override
  String get noPeersAvailable => 'Keine Peers verfügbar';

  @override
  String get noPeersMatchSearch => 'Keine Peers entsprechen Ihrer Suche';

  @override
  String get noProfiles => 'Keine Profile';

  @override
  String get noProfilesFound => 'Keine Profile gefunden';

  @override
  String get noProfilesYet => 'Noch Keine Profile';

  @override
  String get noRemoteNetworksConfigured =>
      'Keine Remote-Netzwerke konfiguriert';

  @override
  String get noRoutesConfigured => 'Keine Routen konfiguriert';

  @override
  String noRulesForInterface(String interface) {
    return 'Keine Regeln für $interface';
  }

  @override
  String get noServersAvailable => 'Keine Server verfügbar';

  @override
  String get noServersMatchSearch => 'Keine Server entsprechen Ihrer Suche';

  @override
  String get noServersSelected => 'Keine Server ausgewählt';

  @override
  String get noSessionsFound => 'Keine Sitzungen gefunden';

  @override
  String get noSettingsAvailable => 'Keine Einstellungen verfügbar';

  @override
  String get noStaticKeysConfigured =>
      'Keine statischen Schlüssel konfiguriert';

  @override
  String get noState => 'No State';

  @override
  String get noSubnetsConfigured => 'Keine Subnetze konfiguriert';

  @override
  String get noTunnelAddressesConfigured =>
      'Keine Tunnel-Adressen konfiguriert';

  @override
  String get noVpnConnectionsFound => 'Keine VPN-Verbindungen gefunden';

  @override
  String get noWinsServersConfigured => 'Keine WINS-Server konfiguriert';

  @override
  String get noWireguardPeersConfigured => 'Keine WireGuard-Peers konfiguriert';

  @override
  String get noWireguardServersConfigured =>
      'Keine WireGuard-Server konfiguriert';

  @override
  String get noWireguardStatusDataAvailable =>
      'Keine WireGuard-Statusdaten verfügbar';

  @override
  String get noWolHostsConfigured => 'Keine Wake on LAN-Hosts konfiguriert';

  @override
  String get none => 'Keine';

  @override
  String get notAvailable => 'N/V';

  @override
  String get notFound => 'Ressource nicht gefunden';

  @override
  String get notice => 'Hinweis';

  @override
  String get ntpServers => 'NTP-Server';

  @override
  String get ntpServersHelperText =>
      'Primäre NTP-Serveradresse (Network Time Protocol) festlegen. Wiederholen Sie diese Option, um sekundäre NTP-Serveradressen festzulegen.';

  @override
  String get offline => 'Offline';

  @override
  String get ok => 'OK';

  @override
  String get oneHour => '1 Stunde';

  @override
  String get oneMin => '1 Min';

  @override
  String get online => 'Online';

  @override
  String get openvpnConnectionStatus => 'OpenVPN-Verbindungsstatus';

  @override
  String get openvpnInstances => 'OpenVPN-Instanzen';

  @override
  String get openvpnLogFile => 'OpenVPN-Protokolldatei';

  @override
  String get optional => 'Optional';

  @override
  String get optionalBase64EncodedPresharedKey =>
      'Optionaler Base64-kodierter vorgeteilter Schlüssel';

  @override
  String get outbound => 'Ausgehend';

  @override
  String get overrideCreatedSuccessfully =>
      'Überschreibung erfolgreich erstellt';

  @override
  String get overrideDeletedSuccessfully =>
      'Überschreibung erfolgreich gelöscht';

  @override
  String get overrideDetails => 'Überschreibungsdetails';

  @override
  String overrideToggledSuccessfully(String status) {
    return 'Überschreibung erfolgreich $status';
  }

  @override
  String get overrideUpdatedSuccessfully =>
      'Überschreibung erfolgreich aktualisiert';

  @override
  String get overwrite => 'Überschreiben';

  @override
  String get packageMirror => 'Paket-Mirror';

  @override
  String get packetLength => 'Paketlänge';

  @override
  String get pass => 'Zulassen';

  @override
  String get pause => 'Pause';

  @override
  String get pauseLiveViewToSelect =>
      'Pausieren Sie die Live-Ansicht, um Protokolleinträge auszuwählen';

  @override
  String get paused => 'Pausiert';

  @override
  String get peerCreatedReadyForNext =>
      'Peer erfolgreich erstellt. Bereit für nächsten Peer.';

  @override
  String get peerCreatedSuccessfully => 'Peer erfolgreich erstellt';

  @override
  String get peerDeletedSuccessfully => 'Peer erfolgreich gelöscht';

  @override
  String get peerDisabledSuccessfully => 'Peer erfolgreich deaktiviert';

  @override
  String get peerEnabledSuccessfully => 'Peer erfolgreich aktiviert';

  @override
  String get peerGenerator => 'Peer-Generator';

  @override
  String get peerUpdatedSuccessfully => 'Peer erfolgreich aktualisiert';

  @override
  String get peerWillBeActiveWhenEnabled =>
      'Peer wird aktiv sein, wenn aktiviert';

  @override
  String get peers => 'Peers';

  @override
  String peersConfigured(int count) {
    return '$count Peer(s) konfiguriert';
  }

  @override
  String get peersCount => 'Anzahl der Peers';

  @override
  String peersSelected(int count) {
    return '$count Peer(s) ausgewählt';
  }

  @override
  String get persistentKeepaliveSeconds =>
      'Persistentes Keepalive in Sekunden (empfohlen: 25)';

  @override
  String get pinChangedSuccessfully => 'PIN erfolgreich geändert';

  @override
  String get pinLock => 'PIN-Sperre';

  @override
  String get pinLockDisabled =>
      'PIN-Sperre deaktiviert. Biometrische Sperre ebenfalls deaktiviert.';

  @override
  String get pinLockEnabled => 'PIN-Sperre aktiviert';

  @override
  String get pinMismatch => 'PINs stimmen nicht überein';

  @override
  String get pinMustContainOnlyNumbers => 'Die PIN darf nur Zahlen enthalten';

  @override
  String get pinTooShort => 'PIN muss mindestens 4 Ziffern haben';

  @override
  String get platform => 'Plattform';

  @override
  String get pleaseEnterCurrentPin => 'Bitte geben Sie Ihre aktuelle PIN ein';

  @override
  String get pleaseEnterNewPin => 'Bitte geben Sie eine neue PIN ein';

  @override
  String get pleaseEnterSubnet => 'Bitte geben Sie ein Subnetz ein';

  @override
  String get pleaseEnterYourPin => 'Bitte geben Sie Ihre PIN ein';

  @override
  String get pleaseSelectAnInstance => 'Bitte wählen Sie eine Instanz';

  @override
  String get pleaseSelectInterface => 'Bitte wählen Sie eine Schnittstelle';

  @override
  String get port => 'Port';

  @override
  String get portHint => 'z.B. 443';

  @override
  String get portIsRequired => 'Port ist erforderlich';

  @override
  String portLabel(String port) {
    return 'Port: $port';
  }

  @override
  String get portMustBeBetween => 'Port muss zwischen 1 und 65535 liegen';

  @override
  String get preAuthKey => 'Vorauthentifizierungsschlüssel';

  @override
  String get preAuthKeyHelperText =>
      'Optional: Vorauthentifizierungsschlüssel für automatische Geräteregistrierung';

  @override
  String get presharedKeyGeneratedSuccessfully =>
      'Pre-Shared-Key erfolgreich generiert';

  @override
  String get presharedKeyOptional => 'Pre-Shared-Key (Optional)';

  @override
  String get preventAutomaticRouteInstallation =>
      'Automatische Routeninstallation verhindern';

  @override
  String get previous => 'Zurück';

  @override
  String get privateKey => 'Privater Schlüssel';

  @override
  String get profileActivated => 'Profil erfolgreich aktiviert';

  @override
  String get profileAdded => 'Profil hinzugefügt';

  @override
  String get profileDeleted => 'Profil erfolgreich gelöscht';

  @override
  String get profileHasNoEndpoints =>
      'Profil hat keine Verbindungsendpunkte konfiguriert';

  @override
  String get profileName => 'Profilname';

  @override
  String get profileNameOptional => 'Profilname (Optional)';

  @override
  String get profileNameRequired => 'Profilname ist erforderlich';

  @override
  String get profileSaved => 'Profil erfolgreich gespeichert';

  @override
  String get profileUpdated => 'Profil aktualisiert';

  @override
  String get profiles => 'Profile';

  @override
  String profilesExportedSuccessfully(String path) {
    return 'Profile erfolgreich exportiert!\n$path';
  }

  @override
  String get protocol => 'Protokoll';

  @override
  String get publicKey => 'Öffentlicher Schlüssel';

  @override
  String get publicKeyColon => 'Öffentlicher Schlüssel:';

  @override
  String get publicKeyRequired => 'Öffentlicher Schlüssel ist erforderlich';

  @override
  String publicKeyShort(String key) {
    return '$key...';
  }

  @override
  String get pushReset => 'Push zurücksetzen';

  @override
  String get pushVirtualIpEndpoints =>
      'Virtuelle IP-Endpunkte für Client-Tunnel pushen und dynamische Zuweisung überschreiben.';

  @override
  String get qrCode => 'QR-Code';

  @override
  String get quickRule => 'Quick Rule';

  @override
  String get quickRuleSubtitle => 'Stop processing rules after first match';

  @override
  String get reason => 'Grund';

  @override
  String get rebootConfirmation =>
      'Sind Sie sicher, dass Sie das System neu starten möchten?';

  @override
  String get rebootFailed => 'Systemneustart fehlgeschlagen';

  @override
  String rebootFailedWithError(String message, String error) {
    return '$message: $error';
  }

  @override
  String get rebootSuccess => 'Systemneustart eingeleitet';

  @override
  String get rebootSystem => 'System neu starten';

  @override
  String get received => 'Empfangen';

  @override
  String get recommendedForSecureConnections =>
      'Empfohlen für sichere Verbindungen';

  @override
  String get redirectGateway => 'Gateway umleiten';

  @override
  String get refresh => 'Aktualisieren';

  @override
  String get registerDns => 'DNS registrieren';

  @override
  String get reject => 'Ablehnen';

  @override
  String get remoteAddress => 'Remote-Adresse';

  @override
  String get remoteNetwork => 'Remote-Netzwerk';

  @override
  String get remoteNetworkHelperText =>
      'Remote-Netzwerke für den Server, die über iroute(-ipv6)-Klauseln in OpenVPN konfiguriert werden und den Server informieren, diese Netzwerke an diesen spezifischen Client zu senden.';

  @override
  String get repository => 'Repository';

  @override
  String get requirePinToUnlock => 'Erfordert PIN zum Entsperren der App';

  @override
  String get required => 'Erforderlich';

  @override
  String get restart => 'Neu starten';

  @override
  String get restartService => 'Dienst neu starten';

  @override
  String restartServiceConfirmation(String type) {
    return 'Sind Sie sicher, dass Sie den $type-Dienst neu starten möchten?\n\nDies wird alle aktiven Verbindungen vorübergehend trennen.';
  }

  @override
  String get restartVpnService => 'VPN-Dienst neu starten';

  @override
  String restartingService(String type) {
    return 'Starte $type-Dienst neu...';
  }

  @override
  String get resume => 'Fortsetzen';

  @override
  String get retry => 'Wiederholen';

  @override
  String get role => 'Rolle';

  @override
  String get routeGateway => 'Routen-Gateway';

  @override
  String get routeGatewayHelperText =>
      'Geben Sie ein Standard-Gateway für den verbundenen Client an. Ohne eines wird die erste Adresse im Netzblock angeboten. Bei der Segmentierung des Tunnel-(Server-)Netzwerks ist diese möglicherweise nicht vom Client aus zugänglich.';

  @override
  String get routes => 'Routen';

  @override
  String get routing => 'Routing';

  @override
  String get rowsPerPageLabel => 'Zeilen pro Seite: ';

  @override
  String get ruleActionFailed => 'Regelaktion fehlgeschlagen';

  @override
  String get ruleCreated => 'Regel erfolgreich erstellt';

  @override
  String get ruleDeleted => 'Regel erfolgreich gelöscht';

  @override
  String get ruleDescription => 'Regelbeschreibung';

  @override
  String get ruleDetails => 'Regeldetails';

  @override
  String get ruleDisabledSuccessfully => 'Regel erfolgreich deaktiviert';

  @override
  String get ruleEnabledSuccessfully => 'Regel erfolgreich aktiviert';

  @override
  String get ruleGuidelines => 'Regelrichtlinien';

  @override
  String get ruleGuidelinesText =>
      '• Verwenden Sie \"any\" für alle Adressen oder Ports\n• CIDR-Notation: 192.168.1.0/24\n• Portbereiche: 80-443\n• Regeln werden in Reihenfolge verarbeitet\n• Änderungen werden sofort angewendet';

  @override
  String get ruleId => 'Regel-ID';

  @override
  String get ruleInformation => 'Regelinformationen';

  @override
  String get ruleUpdated => 'Regel erfolgreich aktualisiert';

  @override
  String get ruleWillBeActiveWhenEnabled =>
      'Die Regel ist aktiv, wenn sie aktiviert ist';

  @override
  String get running => 'Läuft';

  @override
  String get save => 'Speichern';

  @override
  String get saveAndConnect => 'Speichern & Verbinden';

  @override
  String get saveSettings => 'Einstellungen speichern';

  @override
  String get saveWithoutTesting => 'Ohne Test speichern';

  @override
  String get saving => 'Speichern...';

  @override
  String get savingOverride => 'Überschreibung wird gespeichert...';

  @override
  String get savingProfile => 'Profil wird gespeichert...';

  @override
  String get searchAliases => 'Aliase suchen...';

  @override
  String get searchHostnameIpOrMac => 'Hostname, IP oder MAC suchen...';

  @override
  String get searchHostnameOrIp => 'Hostname oder IP-Adresse suchen...';

  @override
  String get searchInstances => 'Instanzen suchen...';

  @override
  String get searchOverrides => 'Überschreibungen durchsuchen...';

  @override
  String get searchPeers => 'Peers suchen...';

  @override
  String get searchServers => 'Server suchen...';

  @override
  String get second => 'Sekunde';

  @override
  String get seconds => 'Sekunden';

  @override
  String get security => 'Sicherheit';

  @override
  String get securityWarning => 'Sicherheitswarnung';

  @override
  String get selectAProfileOrCreateNewOne =>
      'Wählen Sie ein Profil aus oder erstellen Sie ein neues';

  @override
  String get selectAll => 'Alle auswählen';

  @override
  String get selectExitNode => 'Exit-Node auswählen';

  @override
  String get selectInterface => 'Schnittstelle auswählen';

  @override
  String get selectInterfaceToViewRules =>
      'Wählen Sie eine Schnittstelle aus, um Regeln anzuzeigen';

  @override
  String selectLabel(String label) {
    return '$label auswählen';
  }

  @override
  String get selectMultipleInterfaces =>
      'Wählen Sie eine oder mehrere Schnittstellen zur Überwachung aus';

  @override
  String get selectNumberOfEntries =>
      'Wählen Sie die Anzahl der anzuzeigenden Protokolleinträge:';

  @override
  String get selectPeers => 'Peers auswählen';

  @override
  String get selectServerAndGenerateKeys =>
      'Server auswählen und Schlüssel generieren, um Konfiguration anzuzeigen';

  @override
  String get selectServerForQrCode => 'Server für QR-Code auswählen';

  @override
  String get selectServerInstance => 'Bitte wählen Sie eine Serverinstanz aus';

  @override
  String get selectServers => 'Server auswählen';

  @override
  String get selectServersHelperText =>
      'Wählen Sie die OpenVPN-Server aus, für die diese Überschreibung gilt. Leer lassen für alle';

  @override
  String get selectVhid => 'VHID auswählen';

  @override
  String get selected => 'ausgewählt';

  @override
  String get selfSignedCertWarning =>
      'Warnung: Selbstsignierte Zertifikate sind weniger sicher. Aktivieren Sie dies nur, wenn Sie dem Server vertrauen.';

  @override
  String get selfSignedCertificatesWarning =>
      'Aktivieren Sie dies nur, wenn Sie dem Server vertrauen';

  @override
  String get sent => 'Gesendet';

  @override
  String get sequence => 'Reihenfolge';

  @override
  String get server => 'Server';

  @override
  String get serverAddress => 'Server-Adresse';

  @override
  String get serverCreatedSuccessfully => 'Server erfolgreich erstellt';

  @override
  String get serverDeletedSuccessfully => 'Server erfolgreich gelöscht';

  @override
  String get serverDisabledSuccessfully => 'Server erfolgreich deaktiviert';

  @override
  String get serverEnabledSuccessfully => 'Server erfolgreich aktiviert';

  @override
  String get serverError => 'Serverfehler aufgetreten';

  @override
  String get serverInfoNotLoaded => 'Serverinformationen nicht geladen';

  @override
  String get serverNetwork => 'Server-Netzwerk';

  @override
  String get serverPort => 'Server-Port';

  @override
  String get serverSelectionRequired =>
      'Mindestens ein Server muss ausgewählt werden';

  @override
  String get serverUpdatedSuccessfully => 'Server erfolgreich aktualisiert';

  @override
  String get serverWillBeActiveWhenEnabled =>
      'Server wird aktiv sein, wenn aktiviert';

  @override
  String get servers => 'Server';

  @override
  String serversSelected(int count) {
    return '$count Server ausgewählt';
  }

  @override
  String get serviceActionFailed => 'Dienstaktion fehlgeschlagen';

  @override
  String get serviceControls => 'Dienst-Steuerelemente';

  @override
  String get serviceRestartedSuccessfully => 'Dienst erfolgreich neu gestartet';

  @override
  String get serviceRunning => 'Dienst läuft';

  @override
  String get serviceStartedSuccessfully => 'Dienst erfolgreich gestartet';

  @override
  String get serviceStatus => 'Dienststatus';

  @override
  String get serviceStoppedSuccessfully => 'Dienst erfolgreich gestoppt';

  @override
  String get services => 'Dienste';

  @override
  String get sessionTimeout => 'Sitzungs-Timeout';

  @override
  String get sessions => 'Sitzungen';

  @override
  String get setAsActive => 'Als aktiv setzen';

  @override
  String get setPin => 'PIN Festlegen';

  @override
  String get settings => 'Einstellungen';

  @override
  String severitiesAndTimeFilter(int count, String timeFilter) {
    return '$count Schweregrade • $timeFilter';
  }

  @override
  String get severity => 'Schweregrad';

  @override
  String get severityEmergency => 'Notfall';

  @override
  String get severityEmergencyShort => 'Notf';

  @override
  String get severityError => 'Fehler';

  @override
  String get severityInformational => 'Informativ';

  @override
  String get severityInformationalShort => 'Info';

  @override
  String get showAdvancedSettings => 'Erweiterte Einstellungen anzeigen';

  @override
  String get showAll => 'Alle anzeigen';

  @override
  String get showKey => 'Schlüssel anzeigen';

  @override
  String showingInstancesCount(String count, String total) {
    return 'Zeige $count von $total';
  }

  @override
  String get showingZeroEntries => 'Zeige 0 Einträge';

  @override
  String get someConnectionsFailed => 'Einige Verbindungen fehlgeschlagen';

  @override
  String get soon => 'bald';

  @override
  String get sortBy => 'Sortieren nach';

  @override
  String get sortByBandwidth => 'Bandbreite';

  @override
  String get sortByHostname => 'Hostname';

  @override
  String get sortByIP => 'IP-Adresse';

  @override
  String get sortByManufacturer => 'Hersteller';

  @override
  String get source => 'Quelle';

  @override
  String get sourceAddress => 'Quelladresse';

  @override
  String get sourceIsRequired => 'Quelle ist erforderlich';

  @override
  String get sourcePort => 'Quellport';

  @override
  String get sourcePortOptional => 'Quellport (Optional)';

  @override
  String get sloppyState => 'Sloppy State';

  @override
  String get sshEnabled => 'SSH aktiviert';

  @override
  String get start => 'Starten';

  @override
  String get startService => 'Dienst starten';

  @override
  String get startTime => 'Startzeit';

  @override
  String get startWireguardService => 'WireGuard-Dienst starten';

  @override
  String get staticKeyContentPemFormat =>
      'Statischer Schlüsselinhalt im PEM-Format';

  @override
  String get staticKeyCreatedSuccessfully =>
      'Statischer Schlüssel erfolgreich erstellt';

  @override
  String get staticKeyDeletedSuccessfully =>
      'Statischer Schlüssel erfolgreich gelöscht';

  @override
  String get staticKeyDetails => 'Details zum statischen Schlüssel';

  @override
  String get staticKeyInformation => 'Informationen zum statischen Schlüssel';

  @override
  String get staticKeyUpdatedSuccessfully =>
      'Statischer Schlüssel erfolgreich aktualisiert';

  @override
  String get staticKeys => 'Statische Schlüssel';

  @override
  String get staticLease => 'Statisch';

  @override
  String get stateType => 'State Type';

  @override
  String get status => 'Status';

  @override
  String get stop => 'Stoppen';

  @override
  String get stopService => 'Dienst stoppen';

  @override
  String get stopped => 'Gestoppt';

  @override
  String get storeAndGenerateNext => 'Speichern und nächsten generieren';

  @override
  String get subnetAddedSuccessfully => 'Subnetz erfolgreich hinzugefügt';

  @override
  String get subnetCidr => 'Subnetz (CIDR)';

  @override
  String get subnetDeletedSuccessfully => 'Subnetz erfolgreich gelöscht';

  @override
  String get subnetUpdatedSuccessfully => 'Subnetz erfolgreich aktualisiert';

  @override
  String get success => 'Erfolg';

  @override
  String successfullyConnected(String name) {
    return 'Erfolgreich mit $name verbunden';
  }

  @override
  String successfullyDisconnected(String name) {
    return 'Erfolgreich von $name getrennt';
  }

  @override
  String successfullyImportedProfiles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Profile',
      one: 'Profil',
    );
    return '$count $_temp0 erfolgreich importiert';
  }

  @override
  String successfullyRestartedService(String type) {
    return '$type-Dienst erfolgreich neu gestartet';
  }

  @override
  String successfullyWokenDevices(int successCount, int totalCount) {
    String _temp0 = intl.Intl.pluralLogic(
      successCount,
      locale: localeName,
      other: 'Geräte',
      one: 'Gerät',
    );
    return '$successCount von $totalCount $_temp0 erfolgreich aufgeweckt';
  }

  @override
  String get switchProfile => 'Profil wechseln';

  @override
  String get switchProfileConfirmation =>
      'Sind Sie sicher, dass Sie das Profil wechseln möchten? Sie werden zum Profilauswahlbildschirm zurückgekehrt.';

  @override
  String get systemDefault => 'Systemstandard';

  @override
  String get systemGeneratedRule =>
      'Dies ist eine systemgenerierte Regel und kann nicht geändert oder gelöscht werden.';

  @override
  String get systemGeneratedRulesCannotBeDeleted =>
      'Systemgenerierte Regeln können nicht gelöscht werden';

  @override
  String get systemGeneratedRulesCannotBeModified =>
      'Systemgenerierte Regeln können nicht geändert werden';

  @override
  String get systemInformation => 'Systeminformationen';

  @override
  String get systemType => 'Systemtyp';

  @override
  String get swapSourceDestination => 'Swap source and destination';

  @override
  String get synproxyState => 'Synproxy State';

  @override
  String get tags => 'Tags';

  @override
  String get tailscaleAuthentication => 'Tailscale-Authentifizierung';

  @override
  String tailscaleServiceAction(String action) {
    return 'Tailscale-Dienst $action';
  }

  @override
  String tailscaleServiceActionConfirmation(String action) {
    return 'Sind Sie sicher, dass Sie den Tailscale-Dienst $action möchten?';
  }

  @override
  String tailscaleServiceActionSuccess(String action) {
    return 'Tailscale-Dienst erfolgreich $action';
  }

  @override
  String tailscaleServiceActioning(String action) {
    return 'Tailscale-Dienst wird $action...';
  }

  @override
  String get tailscaleSettings => 'Tailscale-Einstellungen';

  @override
  String get tailscaleStatus => 'Tailscale-Status';

  @override
  String get tailscaleSubnets => 'Tailscale-Subnetze';

  @override
  String get tailscaleVersion => 'Version';

  @override
  String get tapPlusButtonToCreateFirstInstance =>
      'Tippen Sie auf die +-Schaltfläche, um Ihre erste Instanz zu erstellen';

  @override
  String get tapPlusButtonToCreateFirstOverride =>
      'Tippen Sie auf die +-Schaltfläche, um Ihre erste Überschreibung zu erstellen';

  @override
  String get tapPlusButtonToCreateFirstStaticKey =>
      'Tippen Sie auf die +-Schaltfläche, um Ihren ersten statischen Schlüssel zu erstellen';

  @override
  String get tcpFlags => 'TCP-Flags';

  @override
  String get tenMin => '10 Min';

  @override
  String get testConnection => 'Verbindung testen';

  @override
  String get testConnections => 'Verbindungen testen';

  @override
  String get testProfile => 'Profil testen';

  @override
  String get testingAllConnections =>
      'Alle Verbindungspunkte werden getestet...';

  @override
  String testingConnection(String current, String total, String endpoint) {
    return 'Teste Verbindung $current von $total: $endpoint';
  }

  @override
  String get theme => 'Design';

  @override
  String get thirtyMin => '30 Min';

  @override
  String get time => 'Zeit';

  @override
  String get timeRange => 'Zeitbereich';

  @override
  String get timeout => 'Zeitüberschreitung';

  @override
  String get timestamp => 'Zeitstempel';

  @override
  String get today => 'Heute';

  @override
  String get totalBandwidth => 'Gesamtbandbreite';

  @override
  String get totalDownload => 'Gesamt-Download';

  @override
  String get totalEntries => 'Gesamteinträge';

  @override
  String get totalUpload => 'Gesamt-Upload';

  @override
  String get totalVpns => 'Gesamt-VPNs';

  @override
  String get tryAdjustingFilters =>
      'Versuchen Sie, die ausgewählten Schweregrad- oder Datumsfilter anzupassen.';

  @override
  String get tryDemoMode => 'Demo-Modus ausprobieren';

  @override
  String get tryDifferentSearch => 'Versuchen Sie einen anderen Suchbegriff';

  @override
  String get tunnelAddress => 'Tunnel-Adresse';

  @override
  String get tunnelAddressCidr => 'Tunnel-Adresse (CIDR)';

  @override
  String get tunnelAddresses => 'Tunnel-Adressen';

  @override
  String tunnelLabel(String network) {
    return 'Tunnel: $network';
  }

  @override
  String get tunnelNetwork => 'Tunnel-Netzwerk';

  @override
  String get tunnelSettings => 'Tunnel-Einstellungen';

  @override
  String get twoMin => '2 Min';

  @override
  String get type => 'Typ';

  @override
  String typeWithValue(String value) {
    return 'Typ: $value';
  }

  @override
  String get udpPortDefault51820 => 'UDP-Port (Standard: 51820)';

  @override
  String get unableToAccessFilePath => 'Zugriff auf Dateipfad nicht möglich';

  @override
  String get unableToConnectToAnyEndpoint =>
      'Verbindung zu keinem der konfigurierten Endpunkte möglich. Bitte überprüfen Sie Ihre Netzwerkeinstellungen und versuchen Sie es erneut.';

  @override
  String get unauthorized => 'Nicht autorisierter Zugriff';

  @override
  String get unknown => 'Unbekannt';

  @override
  String get unlock => 'Entsperren';

  @override
  String get unlockOpnsenseManager => 'OPNsense Manager Entsperren';

  @override
  String get unnamedHost => 'Unbenannter Host';

  @override
  String get unnamedInstance => 'Unbenannte Instanz';

  @override
  String get unnamedRule => 'Unbenannte Regel';

  @override
  String get unsavedChanges => 'Nicht gespeicherte Änderungen';

  @override
  String get unsavedChangesConfirmation =>
      'Sie haben nicht gespeicherte Änderungen. Möchten Sie diese verwerfen und fortfahren?';

  @override
  String get update => 'Aktualisieren';

  @override
  String get updateOverride => 'Überschreibung aktualisieren';

  @override
  String get updatePeer => 'Peer aktualisieren';

  @override
  String get updatePinCode => 'Ihren PIN-Code aktualisieren';

  @override
  String get updateRule => 'Regel Aktualisieren';

  @override
  String get updateServer => 'Server aktualisieren';

  @override
  String get updateStaticKey => 'Statischen Schlüssel aktualisieren';

  @override
  String get upload => 'Upload';

  @override
  String get uptime => 'Betriebszeit';

  @override
  String get useBiometric => 'Biometrie Verwenden';

  @override
  String useBiometricToUnlock(String biometricType) {
    return '$biometricType zum Entsperren der App verwenden';
  }

  @override
  String get useExitNode => 'Exit-Node verwenden';

  @override
  String get useHttps => 'HTTPS Verwenden';

  @override
  String get useHttpsDescription => 'Sichere HTTPS-Verbindung verwenden';

  @override
  String get useProtocolForCommunicating =>
      'Verwenden Sie dieses Protokoll für die Kommunikation';

  @override
  String get valid => 'Gültig';

  @override
  String get validFrom => 'Gültig ab';

  @override
  String verifyingConnection(String endpoint) {
    return 'Überprüfe Verbindung zu $endpoint...';
  }

  @override
  String version(String version) {
    return 'Version $version';
  }

  @override
  String get versionLabel => 'Version';

  @override
  String get viewDetails => 'Details anzeigen';

  @override
  String get viewFullLicense => 'Vollständige Lizenz Anzeigen';

  @override
  String get virtualAddress => 'Virtuelle Adresse';

  @override
  String get vpn => 'VPN';

  @override
  String get vpnConnections => 'VPN-Verbindungen';

  @override
  String get vpnConnectionsWillAppear =>
      'VPN-Verbindungen werden hier angezeigt, wenn sie konfiguriert sind';

  @override
  String get vpnStatus => 'VPN-Status';

  @override
  String get vpnType => 'VPN-Typ';

  @override
  String get wakeAll => 'Alle aufwecken';

  @override
  String get wakeAllDevices => 'Alle Geräte aufwecken';

  @override
  String get wakeAllDevicesConfirmation =>
      'Möchten Sie wirklich Wake-Pakete an alle konfigurierten Geräte senden?';

  @override
  String get wakeAllResults => 'Ergebnisse Alle aufwecken';

  @override
  String get wakeHost => 'Host aufwecken';

  @override
  String get wakeOnLan => 'Wake on LAN';

  @override
  String get wakingAllDevices => 'Alle Geräte werden aufgeweckt...';

  @override
  String get warning => 'Warnung';

  @override
  String get winsServers => 'WINS-Server';

  @override
  String get winsServersHelperText =>
      'Primäre WINS-Serveradresse (NetBIOS over TCP/IP Name Server) festlegen. Wiederholen Sie diese Option, um sekundäre WINS-Serveradressen festzulegen.';

  @override
  String get wireguardLogs => 'WireGuard-Protokolle';

  @override
  String get wireguardLogsExport => 'WireGuard-Protokolle exportieren';

  @override
  String wireguardLogsExportedOn(String date) {
    return 'WireGuard-Protokolle exportiert am $date';
  }

  @override
  String get wireguardPeers => 'WireGuard-Peers';

  @override
  String get wireguardServers => 'WireGuard-Server';

  @override
  String get wireguardServiceStarted => 'WireGuard-Dienst gestartet';

  @override
  String get wireguardServiceStopped => 'WireGuard-Dienst gestoppt';

  @override
  String get wireguardStatus => 'WireGuard-Status';

  @override
  String get withoutCredentials => 'Ohne Anmeldedaten';

  @override
  String wolPacketSentTo(String host) {
    return 'WOL-Paket gesendet an $host';
  }

  @override
  String get yes => 'Ja';

  @override
  String get yesterday => 'Gestern';

  @override
  String get zeroSeconds => '0 Sekunden';

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
  String get actualUsed => 'Tatsächlich verwendet';

  @override
  String get arcCache => 'ARC-Cache';

  @override
  String get demoModeIndicator => 'Demo-Modus - Beispieldaten werden angezeigt';

  @override
  String get thermalSensors => 'Thermosensoren';

  @override
  String get noThermalSensorsAvailable => 'Keine Thermosensoren verfügbar';

  @override
  String get collapseAll => 'Alle einklappen';

  @override
  String get expandAll => 'Alle ausklappen';

  @override
  String get savingInstance => 'Instanz wird gespeichert...';

  @override
  String get staticKeyDescriptionHelper =>
      'Ein beschreibender Name für diesen statischen Schlüssel';

  @override
  String get selectKeyModeHelper =>
      'Wählen Sie den Schlüsselmodus für Authentifizierung oder Verschlüsselung';

  @override
  String get staticKeyHelpText =>
      '• Auth: Fügt HMAC-Authentifizierung zum Steuerkanal hinzu\n• Crypt: Verschlüsselt und authentifiziert alle Steuerkanalpakete\n• Crypt V2: Erweiterte Verschlüsselung mit verbesserter Sicherheit\n\nSie können einen neuen Schlüssel generieren oder einen vorhandenen einfügen.';

  @override
  String get device => 'Gerät';

  @override
  String get listenPort => 'Lausch-Port';

  @override
  String get fwMark => 'FW-Markierung';

  @override
  String get peerStatus => 'Peer-Status';

  @override
  String get handshakeAge => 'Handshake-Alter';

  @override
  String secondsAgo(int count) {
    return 'vor $count Sekunden';
  }

  @override
  String get handshake => 'Handshake';

  @override
  String get processInformation => 'Prozessinformationen';

  @override
  String get processName => 'Prozessname';

  @override
  String get processId => 'Prozess-ID';

  @override
  String get logMessage => 'Protokollnachricht';

  @override
  String get message => 'Nachricht';

  @override
  String get timestampInformation => 'Zeitstempel-Informationen';

  @override
  String get rawTimestamp => 'Roh-Zeitstempel';

  @override
  String get organisationSection => 'Organisation';

  @override
  String get interfaceSection => 'Interface';

  @override
  String get filterSection => 'Filter';

  @override
  String get sourceRoutingSection => 'Source Routing';

  @override
  String get statefulFirewallSection => 'Stateful Firewall';

  @override
  String get trafficShapingSection => 'Traffic Shaping';

  @override
  String get prioritySection => 'Priority';

  @override
  String get internalTaggingSection => 'Internal Tagging';

  @override
  String get showAdvanced => 'Show Advanced';

  @override
  String get hideAdvanced => 'Hide Advanced';

  @override
  String get enableThisRule => 'Enable this rule';

  @override
  String get categoriesLabel => 'Categories';

  @override
  String get categoriesHint =>
      'For grouping purposes you may select multiple groups here.';

  @override
  String get invertInterface => 'Invert Interface';

  @override
  String get invertInterfaceSubtitle => 'Use all but selected interfaces';

  @override
  String get quickRuleHelp =>
      'If a packet matches a rule specifying quick, then that rule is considered the last matching rule and the specified action is taken.';

  @override
  String get actionHelp =>
      'Choose what to do with packets that match the criteria specified below.';

  @override
  String get directionHelp =>
      'Direction of the traffic. The default policy is to filter inbound traffic.';

  @override
  String get fwVersionLabel => 'Version';

  @override
  String get icmpTypeLabel => 'ICMP Type';

  @override
  String get icmp6TypeLabel => 'ICMPv6 Type';

  @override
  String get sourcePortHelp =>
      'Source port number or well known name (imap, imaps, http, https, ...), for ranges use a dash';

  @override
  String get destinationPortHelp =>
      'Destination port number or well known name (imap, imaps, http, https, ...), for ranges use a dash';

  @override
  String get logHelp => 'Log packets that are handled by this rule';

  @override
  String get fwGatewayLabel => 'Gateway';

  @override
  String get gatewayHelp =>
      'Leave as default to use the system routing table. Or choose a gateway to utilize policy based routing.';

  @override
  String get sequenceLabel => 'Sequence';

  @override
  String get sequenceHelp => 'The order in which rules are being processed.';

  @override
  String get noXmlrpcSync => 'No XMLRPC Sync';

  @override
  String get noXmlrpcSyncHelp =>
      'Exclude this item from the HA synchronization process.';

  @override
  String get allowOptionsLabel => 'Allow Options';

  @override
  String get allowOptionsHelp => 'This allows packets with IP options to pass.';

  @override
  String get tcpFlagsLabel => 'TCP Flags';

  @override
  String get tcpFlagsOutLabel => 'TCP Flags [out of]';

  @override
  String get tcpFlagsAnyLabel => 'TCP Flags Any';

  @override
  String get scheduleLabel => 'Schedule';

  @override
  String get divertToLabel => 'Divert-to';

  @override
  String get divertToHelp =>
      'Send packets matching this rule to the service specified.';

  @override
  String get statePolicyLabel => 'State Policy';

  @override
  String get noPfsyncLabel => 'No pfsync';

  @override
  String get noPfsyncHelp =>
      'Prevents states created by this rule to be synced with pfsync.';

  @override
  String get tcpEstablishedLabel => 'TCP Established';

  @override
  String get udpFirstLabel => 'UDP First';

  @override
  String get udpSingleLabel => 'UDP Single';

  @override
  String get udpMultipleLabel => 'UDP Multiple';

  @override
  String get adaptiveStartLabel => 'Adaptive Start';

  @override
  String get adaptiveEndLabel => 'Adaptive End';

  @override
  String get maxStatesLabel => 'Max States';

  @override
  String get maxSrcNodesLabel => 'Max Source Nodes';

  @override
  String get maxSrcStatesLabel => 'Max Source States';

  @override
  String get maxSrcConnLabel => 'Max Source Connections';

  @override
  String get maxNewConnCLabel => 'Max New Connections [c]';

  @override
  String get maxNewConnSLabel => 'Max New Connections [s]';

  @override
  String get overloadTableLabel => 'Overload Table';

  @override
  String get overloadTableHelp =>
      'Overload table used when max new connections per time interval has been reached.';

  @override
  String get shaperLabel => 'Traffic Shaper';

  @override
  String get shaperReverseLabel => 'Traffic Shaper [reverse]';

  @override
  String get disableReplyToLabel => 'Disable Reply-to';

  @override
  String get disableReplyToHelp => 'Explicit disable reply-to for this rule';

  @override
  String get replyToLabel => 'Reply-to';

  @override
  String get replyToHelp =>
      'Determines how packets route back in the opposite direction.';

  @override
  String get matchPriorityLabel => 'Match Priority';

  @override
  String get setPriorityLabel => 'Set Priority';

  @override
  String get setPriorityLowLabel => 'Set Priority [low-delay]';

  @override
  String get matchTosLabel => 'Match TOS / DSCP';

  @override
  String get setLocalTagLabel => 'Set Local Tag';

  @override
  String get setLocalTagHelp =>
      'Packets matching this rule will be tagged with the specified string.';

  @override
  String get matchLocalTagLabel => 'Match Local Tag';

  @override
  String get matchLocalTagHelp =>
      'Packets must already be tagged with the given tag to match the rule.';

  @override
  String get singleHostOrNetwork => 'Single host or network';

  @override
  String get singlePortOrRange => 'Single port or range';

  @override
  String get thisFirwall => 'This Firewall';

  @override
  String interfaceNet(String name) {
    return '$name net';
  }

  @override
  String interfaceAddress(String name) {
    return '$name address';
  }

  @override
  String get sortOrderLabel => 'Sort Order';

  @override
  String get sortOrderHelp =>
      'The order in which rules are being processed (auto-calculated, read-only).';
}
