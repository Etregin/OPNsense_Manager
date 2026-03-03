// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appName => 'OPNsense Manager';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get firewallRules => 'Firewall-Regeln';

  @override
  String get firewallLogs => 'Firewall-Protokolle';

  @override
  String get systemInfo => 'Systeminformationen';

  @override
  String get vpnConnections => 'VPN-Verbindungen';

  @override
  String get settings => 'Einstellungen';

  @override
  String get hostname => 'Hostname';

  @override
  String get versionLabel => 'Version';

  @override
  String get platform => 'Plattform';

  @override
  String get uptime => 'Betriebszeit';

  @override
  String get cpuUsage => 'CPU-Auslastung';

  @override
  String get memoryUsage => 'Speicherauslastung';

  @override
  String get services => 'Dienste';

  @override
  String get gateways => 'Gateways';

  @override
  String get running => 'Läuft';

  @override
  String get stopped => 'Gestoppt';

  @override
  String get online => 'Online';

  @override
  String get offline => 'Offline';

  @override
  String get start => 'Starten';

  @override
  String get stop => 'Stoppen';

  @override
  String get restart => 'Neu starten';

  @override
  String get enable => 'Aktivieren';

  @override
  String get disable => 'Deaktivieren';

  @override
  String get delete => 'Löschen';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get save => 'Speichern';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get ok => 'OK';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nein';

  @override
  String get close => 'Schließen';

  @override
  String get refresh => 'Aktualisieren';

  @override
  String get apply => 'Anwenden';

  @override
  String get login => 'Anmelden';

  @override
  String get logout => 'Abmelden';

  @override
  String get host => 'Host';

  @override
  String get port => 'Port';

  @override
  String get apiKey => 'API-Schlüssel';

  @override
  String get apiSecret => 'API-Geheimnis';

  @override
  String get useHttps => 'HTTPS Verwenden';

  @override
  String get allowSelfSigned => 'Selbstsigniertes Zertifikat zulassen';

  @override
  String get testConnection => 'Verbindung testen';

  @override
  String get connectionSuccessful => 'Verbindung erfolgreich';

  @override
  String get connectionFailed =>
      'Verbindung fehlgeschlagen. Überprüfen Sie die Konsolenprotokolle für Details.\n\nHäufige Probleme:\n• Gerät nicht im selben Netzwerk wie OPNsense\n• Falsche IP-Adresse oder Port\n• Firewall blockiert Verbindung\n• Ungültige API-Anmeldedaten';

  @override
  String get profiles => 'Profile';

  @override
  String get addProfile => 'Profil Hinzufügen';

  @override
  String get editProfile => 'Profil bearbeiten';

  @override
  String get deleteProfile => 'Profil löschen';

  @override
  String get profileName => 'Profilname';

  @override
  String get activeProfile => 'Aktives Profil';

  @override
  String get switchProfile => 'Profil wechseln';

  @override
  String get exportProfiles => 'Profile exportieren';

  @override
  String get importProfiles => 'Profile importieren';

  @override
  String get security => 'Sicherheit';

  @override
  String get pinLock => 'PIN-Sperre';

  @override
  String get changePIN => 'PIN ändern';

  @override
  String get biometricAuth => 'Biometrische Authentifizierung';

  @override
  String get sessionTimeout => 'Sitzungs-Timeout';

  @override
  String get lockApp => 'App sperren';

  @override
  String get appearance => 'Erscheinungsbild';

  @override
  String get theme => 'Design';

  @override
  String get language => 'Sprache';

  @override
  String get lightMode => 'Heller Modus';

  @override
  String get darkMode => 'Dunkler Modus';

  @override
  String get systemDefault => 'Systemstandard';

  @override
  String get general => 'Allgemein';

  @override
  String get about => 'Über';

  @override
  String get licenses => 'Lizenzen';

  @override
  String get firewallRuleDetails => 'Firewall-Regel-Details';

  @override
  String get createRule => 'Regel Erstellen';

  @override
  String get editRule => 'Regel Bearbeiten';

  @override
  String get deleteRule => 'Regel löschen';

  @override
  String get action => 'Aktion';

  @override
  String get interface => 'Schnittstelle';

  @override
  String get protocol => 'Protokoll';

  @override
  String get source => 'Quelle';

  @override
  String get destination => 'Ziel';

  @override
  String get sourcePort => 'Quellport';

  @override
  String get destinationPort => 'Zielport';

  @override
  String get description => 'Beschreibung';

  @override
  String get enabled => 'Aktiviert';

  @override
  String get disabled => 'Deaktiviert';

  @override
  String get pass => 'Zulassen';

  @override
  String get block => 'Blockieren';

  @override
  String get reject => 'Ablehnen';

  @override
  String get logs => 'Protokolle';

  @override
  String get filterByAction => 'Nach Aktion filtern';

  @override
  String get showAll => 'Alle anzeigen';

  @override
  String get autoRefresh => 'Automatische Aktualisierung';

  @override
  String get logLimit => 'Protokollgrenze';

  @override
  String get paused => 'Pausiert';

  @override
  String get live => 'Live';

  @override
  String get entries => 'Einträge';

  @override
  String get selected => 'ausgewählt';

  @override
  String get selectAll => 'Alle auswählen';

  @override
  String get copy => 'Kopieren';

  @override
  String get historySize => 'Verlaufsgröße';

  @override
  String get enableAutoScroll => 'Automatisches Scrollen aktivieren';

  @override
  String get disableAutoScroll => 'Automatisches Scrollen deaktivieren';

  @override
  String get clearLogs => 'Protokolle löschen';

  @override
  String get pause => 'Pause';

  @override
  String get resume => 'Fortsetzen';

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
  String get pauseLiveViewToSelect =>
      'Pausieren Sie die Live-Ansicht, um Protokolleinträge auszuwählen';

  @override
  String get errorLoadingLogs => 'Fehler beim Laden der Protokolle';

  @override
  String get noLogsAvailable => 'Keine Protokolle verfügbar';

  @override
  String get logsWillAppear =>
      'Protokolle werden hier angezeigt, sobald sie generiert werden';

  @override
  String get selectNumberOfEntries =>
      'Wählen Sie die Anzahl der anzuzeigenden Protokolleinträge:';

  @override
  String get reason => 'Grund';

  @override
  String get newRule => 'Neue Regel';

  @override
  String get ruleDetails => 'Regeldetails';

  @override
  String get type => 'Typ';

  @override
  String get sequence => 'Reihenfolge';

  @override
  String get status => 'Status';

  @override
  String get systemGeneratedRule =>
      'Dies ist eine systemgenerierte Regel und kann nicht geändert oder gelöscht werden.';

  @override
  String get systemGeneratedRulesCannotBeModified =>
      'Systemgenerierte Regeln können nicht geändert werden';

  @override
  String get systemGeneratedRulesCannotBeDeleted =>
      'Systemgenerierte Regeln können nicht gelöscht werden';

  @override
  String get enableRule => 'Regel aktivieren';

  @override
  String get disableRule => 'Regel deaktivieren';

  @override
  String get enablingRule => 'Regel wird aktiviert...';

  @override
  String get disablingRule => 'Regel wird deaktiviert...';

  @override
  String get ruleEnabledSuccessfully => 'Regel erfolgreich aktiviert';

  @override
  String get ruleDisabledSuccessfully => 'Regel erfolgreich deaktiviert';

  @override
  String errorTogglingRule(String error) {
    return 'Fehler beim Umschalten der Regel: $error';
  }

  @override
  String deleteRuleConfirmation(String description) {
    return 'Sind Sie sicher, dass Sie die Regel \"$description\" löschen möchten?';
  }

  @override
  String get ruleDeleted => 'Regel erfolgreich gelöscht';

  @override
  String errorDeletingRule(String error) {
    return 'Fehler beim Löschen der Regel: $error';
  }

  @override
  String get errorLoadingRules => 'Fehler beim Laden der Regeln';

  @override
  String get noAutomationRulesFound => 'Keine Automatisierungsregeln gefunden';

  @override
  String get createFirstAutomationRule =>
      'Erstellen Sie Ihre erste Automatisierungsregel, um zu beginnen';

  @override
  String get noInterfacesWithAutomationRules =>
      'Keine Schnittstellen mit Automatisierungsregeln';

  @override
  String get selectInterface => 'Schnittstelle auswählen';

  @override
  String get selectInterfaceToViewRules =>
      'Wählen Sie eine Schnittstelle aus, um Regeln anzuzeigen';

  @override
  String noRulesForInterface(String interface) {
    return 'Keine Regeln für $interface';
  }

  @override
  String get unnamedRule => 'Unbenannte Regel';

  @override
  String get systemInformation => 'Systeminformationen';

  @override
  String get firmwareDetails => 'Firmware-Details';

  @override
  String get systemType => 'Systemtyp';

  @override
  String get architecture => 'Architektur';

  @override
  String get gitCommit => 'Git-Commit';

  @override
  String get packageMirror => 'Paket-Mirror';

  @override
  String get repository => 'Repository';

  @override
  String get lastUpdate => 'Letzte Aktualisierung';

  @override
  String get errorLoadingSystemInfo =>
      'Fehler beim Laden der Systeminformationen';

  @override
  String get errorLoadingVPNConnections =>
      'Fehler beim Laden der VPN-Verbindungen';

  @override
  String get noVPNConnectionsFound => 'Keine VPN-Verbindungen gefunden';

  @override
  String noConnectionsFound(String type) {
    return 'Keine $type-Verbindungen gefunden';
  }

  @override
  String get vpnConnectionsWillAppear =>
      'VPN-Verbindungen werden hier angezeigt, wenn sie konfiguriert sind';

  @override
  String get totalVPNs => 'Gesamt-VPNs';

  @override
  String get filterByType => 'Nach Typ filtern';

  @override
  String get allVPNs => 'Alle VPNs';

  @override
  String get connectVPN => 'VPN verbinden';

  @override
  String get disconnectVPN => 'VPN trennen';

  @override
  String connectingVPN(String name) {
    return 'Verbinde mit $name...';
  }

  @override
  String disconnectingVPN(String name) {
    return 'Trenne $name...';
  }

  @override
  String successfullyConnected(String name) {
    return 'Erfolgreich mit $name verbunden';
  }

  @override
  String successfullyDisconnected(String name) {
    return 'Erfolgreich von $name getrennt';
  }

  @override
  String failedToConnect(String name) {
    return 'Verbindung zu $name fehlgeschlagen';
  }

  @override
  String failedToDisconnect(String name) {
    return 'Trennung von $name fehlgeschlagen';
  }

  @override
  String get restartVPNService => 'VPN-Dienst neu starten';

  @override
  String restartServiceConfirmation(String type) {
    return 'Sind Sie sicher, dass Sie den $type-Dienst neu starten möchten?\n\nDies wird alle aktiven Verbindungen vorübergehend trennen.';
  }

  @override
  String restartingService(String type) {
    return 'Starte $type-Dienst neu...';
  }

  @override
  String successfullyRestartedService(String type) {
    return '$type-Dienst erfolgreich neu gestartet';
  }

  @override
  String failedToRestartService(String type) {
    return 'Neustart des $type-Dienstes fehlgeschlagen';
  }

  @override
  String get enterRuleDescription => 'Regelbeschreibung eingeben';

  @override
  String get loading => 'Lädt...';

  @override
  String get any => 'Beliebig';

  @override
  String get anyIpAddressCidrOrAlias => 'beliebig, IP-Adresse, CIDR oder Alias';

  @override
  String get examplesAnyIpCidr => 'Beispiele: any, 192.168.1.0/24, 10.0.0.1';

  @override
  String get sourceIsRequired => 'Quelle ist erforderlich';

  @override
  String get invalidSourceFormat => 'Ungültiges Quellformat';

  @override
  String get sourcePortOptional => 'Quellport (Optional)';

  @override
  String get anyPortNumberRangeOrAlias =>
      'beliebig, Portnummer, Bereich oder Alias';

  @override
  String get examplesAnyPortRange => 'Beispiele: any, 80, 1024-65535';

  @override
  String get invalidPortFormat => 'Ungültiges Portformat';

  @override
  String get destinationIsRequired => 'Ziel ist erforderlich';

  @override
  String get invalidDestinationFormat => 'Ungültiges Zielformat';

  @override
  String get destinationPortOptional => 'Zielport (Optional)';

  @override
  String get examplesAnyPortRangeHttp => 'Beispiele: any, 80, 80-443, http';

  @override
  String get ruleWillBeActiveWhenEnabled =>
      'Die Regel ist aktiv, wenn sie aktiviert ist';

  @override
  String get ruleGuidelines => 'Regelrichtlinien';

  @override
  String get ruleGuidelinesText =>
      '• Verwenden Sie \"any\" für alle Adressen oder Ports\n• CIDR-Notation: 192.168.1.0/24\n• Portbereiche: 80-443\n• Regeln werden in Reihenfolge verarbeitet\n• Änderungen werden sofort angewendet';

  @override
  String get updateRule => 'Regel Aktualisieren';

  @override
  String get ruleUpdated => 'Regel erfolgreich aktualisiert';

  @override
  String get ruleCreated => 'Regel erfolgreich erstellt';

  @override
  String errorSavingRule(String error) {
    return 'Fehler beim Speichern der Regel: $error';
  }

  @override
  String get connectToYourOPNsenseFirewall =>
      'Verbinden Sie sich mit Ihrer OPNsense-Firewall';

  @override
  String get profileNameOptional => 'Profilname (Optional)';

  @override
  String get myOPNsenseRouter => 'Mein OPNsense-Router';

  @override
  String get hostIpAddress => 'Host / IP-Adresse';

  @override
  String get hostPlaceholder => '192.168.1.1 oder firewall.example.com';

  @override
  String get portPlaceholder => '443';

  @override
  String get recommendedForSecureConnections =>
      'Empfohlen für sichere Verbindungen';

  @override
  String get enterYourApiKey => 'Geben Sie Ihren API-Schlüssel ein';

  @override
  String get enterYourApiSecret => 'Geben Sie Ihr API-Geheimnis ein';

  @override
  String get connect => 'Verbinden';

  @override
  String apiError(String message) {
    return 'API-Fehler: $message';
  }

  @override
  String get needHelpCheckDocumentation =>
      'Benötigen Sie Hilfe? Überprüfen Sie die OPNsense-Dokumentation zur API-Schlüsselgenerierung.';

  @override
  String get selectAProfileOrCreateNewOne =>
      'Wählen Sie ein Profil aus oder erstellen Sie ein neues';

  @override
  String get createNewProfile => 'Neues Profil Erstellen';

  @override
  String get noProfilesYet => 'Noch Keine Profile';

  @override
  String get createYourFirstProfile =>
      'Erstellen Sie Ihr erstes OPNsense-Profil, um zu beginnen';

  @override
  String lastUsed(String date) {
    return 'Zuletzt verwendet: $date';
  }

  @override
  String get justNow => 'Gerade eben';

  @override
  String minutesAgo(String minutes) {
    return 'Vor ${minutes}m';
  }

  @override
  String hoursAgo(String hours) {
    return 'Vor ${hours}h';
  }

  @override
  String daysAgo(String days) {
    return 'Vor ${days}T';
  }

  @override
  String connectionFailedError(String error) {
    return 'Verbindung fehlgeschlagen: $error';
  }

  @override
  String get enterPin => 'PIN Eingeben';

  @override
  String get unlockOPNsenseManager => 'OPNsense Manager Entsperren';

  @override
  String get pleaseEnterYourPin => 'Bitte geben Sie Ihre PIN ein';

  @override
  String get incorrectPin => 'Falsche PIN';

  @override
  String get unlock => 'Entsperren';

  @override
  String get useBiometric => 'Biometrie Verwenden';

  @override
  String get authenticateToUnlock =>
      'Authentifizieren Sie sich, um OPNsense Manager zu entsperren';

  @override
  String version(String version) {
    return 'Version $version';
  }

  @override
  String get remoteAddress => 'Remote-Adresse';

  @override
  String get localAddress => 'Lokale Adresse';

  @override
  String get received => 'Empfangen';

  @override
  String get sent => 'Gesendet';

  @override
  String get vpnStatus => 'VPN-Status';

  @override
  String get connected => 'Verbunden';

  @override
  String get disconnected => 'Getrennt';

  @override
  String get disconnect => 'Trennen';

  @override
  String get vpnType => 'VPN-Typ';

  @override
  String get clientAddress => 'Client-Adresse';

  @override
  String get virtualAddress => 'Virtuelle Adresse';

  @override
  String get bytesReceived => 'Empfangene Bytes';

  @override
  String get bytesSent => 'Gesendete Bytes';

  @override
  String get connectedSince => 'Verbunden seit';

  @override
  String get rebootSystem => 'System neu starten';

  @override
  String get rebootConfirmation =>
      'Sind Sie sicher, dass Sie das System neu starten möchten?';

  @override
  String get rebootSuccess => 'Systemneustart eingeleitet';

  @override
  String get rebootFailed => 'Systemneustart fehlgeschlagen';

  @override
  String get error => 'Fehler';

  @override
  String get success => 'Erfolg';

  @override
  String get warning => 'Warnung';

  @override
  String get info => 'Information';

  @override
  String get noData => 'Keine Daten verfügbar';

  @override
  String get retry => 'Wiederholen';

  @override
  String get confirmDelete => 'Löschen bestätigen';

  @override
  String get deleteConfirmation =>
      'Sind Sie sicher, dass Sie dieses Element löschen möchten?';

  @override
  String get cannotBeUndone =>
      'Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get enterPIN => 'PIN eingeben';

  @override
  String get confirmPIN => 'PIN bestätigen';

  @override
  String get pinMismatch => 'PINs stimmen nicht überein';

  @override
  String get pinTooShort => 'PIN muss mindestens 4 Ziffern haben';

  @override
  String get invalidPIN => 'Ungültige PIN';

  @override
  String get minutes => 'Minuten';

  @override
  String get seconds => 'Sekunden';

  @override
  String get hours => 'Stunden';

  @override
  String get days => 'Tage';

  @override
  String get required => 'Erforderlich';

  @override
  String get optional => 'Optional';

  @override
  String get invalidInput => 'Ungültige Eingabe';

  @override
  String get fieldRequired => 'Dieses Feld ist erforderlich';

  @override
  String get exportSuccess => 'Export erfolgreich';

  @override
  String get exportFailed => 'Export fehlgeschlagen';

  @override
  String get importSuccess => 'Import erfolgreich';

  @override
  String get importFailed => 'Import fehlgeschlagen';

  @override
  String importedProfiles(int count) {
    return '$count Profil(e) importiert';
  }

  @override
  String get noProfilesFound => 'Keine Profile gefunden';

  @override
  String get createFirstProfile =>
      'Erstellen Sie Ihr erstes Profil, um zu beginnen';

  @override
  String get serviceStarted => 'Dienst erfolgreich gestartet';

  @override
  String get serviceStopped => 'Dienst erfolgreich gestoppt';

  @override
  String get serviceRestarted => 'Dienst erfolgreich neu gestartet';

  @override
  String get serviceActionFailed => 'Dienstaktion fehlgeschlagen';

  @override
  String get ruleActionFailed => 'Regelaktion fehlgeschlagen';

  @override
  String get profileSaved => 'Profil erfolgreich gespeichert';

  @override
  String get profileDeleted => 'Profil erfolgreich gelöscht';

  @override
  String get profileActivated => 'Profil erfolgreich aktiviert';

  @override
  String get authenticationRequired => 'Authentifizierung erforderlich';

  @override
  String get authenticationFailed => 'Authentifizierung fehlgeschlagen';

  @override
  String get networkError => 'Netzwerkfehler aufgetreten';

  @override
  String get serverError => 'Serverfehler aufgetreten';

  @override
  String get unauthorized => 'Nicht autorisierter Zugriff';

  @override
  String get forbidden => 'Zugriff verboten';

  @override
  String get notFound => 'Ressource nicht gefunden';

  @override
  String get timeout => 'Zeitüberschreitung';

  @override
  String get none => 'Keine';

  @override
  String get diskUsage => 'Festplattennutzung';

  @override
  String get pinLockDisabled =>
      'PIN-Sperre deaktiviert. Biometrische Sperre ebenfalls deaktiviert.';

  @override
  String get setPin => 'PIN Festlegen';

  @override
  String get pinLockTitle => 'PIN-Sperre';

  @override
  String get requirePinToUnlock => 'Erfordert PIN zum Entsperren der App';

  @override
  String get changePinTitle => 'PIN Ändern';

  @override
  String get updatePinCode => 'Ihren PIN-Code aktualisieren';

  @override
  String get lockTimeoutLabel => 'Sperr-Timeout';

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
  String get minute => 'Minute';

  @override
  String get add => 'Hinzufügen';

  @override
  String get profileAdded => 'Profil hinzugefügt';

  @override
  String get profileUpdated => 'Profil aktualisiert';

  @override
  String get exportProfilesTitle => 'Profile Exportieren';

  @override
  String get chooseExportLocation => 'Export-Speicherort Wählen';

  @override
  String profilesExportedSuccessfully(String path) {
    return 'Profile erfolgreich exportiert!\n$path';
  }

  @override
  String exportFailedError(String error) {
    return 'Export fehlgeschlagen: $error';
  }

  @override
  String get importProfilesTitle => 'Profile Importieren';

  @override
  String invalidFileError(String error) {
    return 'Ungültige Datei: $error';
  }

  @override
  String get importProfilesDialog =>
      'Wie sollen vorhandene Profile behandelt werden?\n\n• Beide Behalten: Mit neuen IDs importieren\n• Überschreiben: Vorhandene Profile ersetzen';

  @override
  String get keepBoth => 'Beide Behalten';

  @override
  String get overwrite => 'Überschreiben';

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
  String importFailedWithErrors(String errors) {
    return 'Import fehlgeschlagen: $errors';
  }

  @override
  String importedWithFailures(int success, int failed) {
    String _temp0 = intl.Intl.pluralLogic(
      success,
      locale: localeName,
      other: 'Profile',
      one: 'Profil',
    );
    return '$success $_temp0 importiert, $failed fehlgeschlagen';
  }

  @override
  String get deleteProfileTitle => 'Profil Löschen';

  @override
  String deleteProfileConfirmation(String name) {
    return 'Sind Sie sicher, dass Sie \"$name\" löschen möchten?';
  }

  @override
  String get applicationLegalese =>
      '© 2026 OPNsense Manager\n\nLizenziert unter der GNU General Public License v3.0\n\nDieses Programm ist freie Software: Sie können es unter den Bedingungen der GNU General Public License, wie von der Free Software Foundation veröffentlicht, weitergeben und/oder modifizieren, entweder gemäß Version 3 der Lizenz oder (nach Ihrer Option) jeder späteren Version.';

  @override
  String get aboutDescription =>
      'Eine professionelle Flutter-Mobile-Anwendung zur Verwaltung von OPNsense-Firewall-Routern.';

  @override
  String get featuresTitle => 'Funktionen';

  @override
  String get featuresList =>
      '• Systemüberwachung und -verwaltung\n• Firewall-Regelkonfiguration\n• Dienststeuerung\n• Echtzeit-Protokolle\n• Multi-Profil-Unterstützung\n• Sichere Authentifizierung';

  @override
  String get viewFullLicense => 'Vollständige Lizenz Anzeigen';

  @override
  String get gnuLicenseTitle => 'GNU General Public License v3.0';

  @override
  String get gnuLicenseText =>
      'Dieses Programm ist freie Software: Sie können es unter den Bedingungen der GNU General Public License, wie von der Free Software Foundation veröffentlicht, weitergeben und/oder modifizieren, entweder gemäß Version 3 der Lizenz oder (nach Ihrer Option) jeder späteren Version.\n\nDieses Programm wird in der Hoffnung verteilt, dass es nützlich sein wird, aber OHNE JEDE GEWÄHRLEISTUNG; sogar ohne die implizite Gewährleistung der MARKTFÄHIGKEIT oder EIGNUNG FÜR EINEN BESTIMMTEN ZWECK. Siehe die GNU General Public License für weitere Details.\n\nSie sollten eine Kopie der GNU General Public License zusammen mit diesem Programm erhalten haben. Wenn nicht, siehe <https://www.gnu.org/licenses/>.\n\nWarum GPLv3?\n\n• Stellt sicher, dass die Software frei und Open Source bleibt\n• Alle Modifikationen oder Ableitungen müssen ebenfalls Open Source sein\n• Benutzer haben die Freiheit, die Software zu verwenden, zu studieren, zu teilen und zu modifizieren\n• Die Gemeinschaft profitiert von Verbesserungen und Beiträgen';

  @override
  String get enterPinLabel => 'PIN eingeben (4-6 Ziffern)';

  @override
  String get confirmPin => 'PIN bestätigen';

  @override
  String get pinLockEnabled => 'PIN-Sperre aktiviert';

  @override
  String get currentPin => 'Aktuelle PIN';

  @override
  String get newPin => 'Neue PIN (4-6 Ziffern)';

  @override
  String get confirmNewPin => 'Neue PIN bestätigen';

  @override
  String get currentPinIncorrect => 'Die aktuelle PIN ist falsch';

  @override
  String get pinChangedSuccessfully => 'PIN erfolgreich geändert';

  @override
  String get pleaseEnterCurrentPin => 'Bitte geben Sie Ihre aktuelle PIN ein';

  @override
  String get pleaseEnterNewPin => 'Bitte geben Sie eine neue PIN ein';

  @override
  String get pinMustContainOnlyNumbers => 'Die PIN darf nur Zahlen enthalten';

  @override
  String get newPinMustBeDifferent =>
      'Die neue PIN muss sich von der aktuellen unterscheiden';

  @override
  String get enablePinLockFirst =>
      'Bitte aktivieren Sie zuerst die PIN-Sperre, bevor Sie Biometrie verwenden';

  @override
  String get biometricNotAvailable =>
      'Biometrische Authentifizierung ist auf diesem Gerät nicht verfügbar';

  @override
  String get biometricLockEnabled => 'Biometrische Sperre aktiviert';

  @override
  String get biometricAuthFailed =>
      'Biometrische Authentifizierung fehlgeschlagen oder abgebrochen';

  @override
  String get biometricLockDisabled => 'Biometrische Sperre deaktiviert';

  @override
  String biometricLockTitle(String biometricType) {
    return '$biometricType-Sperre';
  }

  @override
  String useBiometricToUnlock(String biometricType) {
    return '$biometricType zum Entsperren der App verwenden';
  }

  @override
  String get enablePinLockFirstBiometric =>
      'Aktivieren Sie zuerst die PIN-Sperre, um Biometrie zu verwenden';

  @override
  String get oneMin => '1 Min';

  @override
  String get twoMin => '2 Min';

  @override
  String get fiveMin => '5 Min';

  @override
  String get tenMin => '10 Min';

  @override
  String get fifteenMin => '15 Min';

  @override
  String get thirtyMin => '30 Min';

  @override
  String get oneHour => '1 Stunde';

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
  String get activate => 'Aktivieren';

  @override
  String get import => 'Importieren';

  @override
  String get export => 'Exportieren';

  @override
  String get activatingProfile => 'Profil wird aktiviert...';

  @override
  String activatedProfile(String name) {
    return 'Profil aktiviert: $name';
  }

  @override
  String get connectionTestFailed => 'Verbindungstest fehlgeschlagen';

  @override
  String get profileNameLabel => 'Profilname';

  @override
  String get hostIpAddressLabel => 'Host/IP-Adresse';

  @override
  String get portLabel => 'Port';

  @override
  String get useHttpsLabel => 'HTTPS Verwenden';

  @override
  String get apiKeyLabel => 'API-Schlüssel';

  @override
  String get apiSecretLabel => 'API-Geheimnis';

  @override
  String get profileNameRequired => 'Profilname ist erforderlich';

  @override
  String get exportProfilesContent =>
      'Möchten Sie API-Anmeldedaten in den Export einschließen?\n\nWARNUNG: Das Einschließen von Anmeldedaten speichert API-Schlüssel und Geheimnisse im Klartext. Schließen Sie Anmeldedaten nur ein, wenn Sie die Datei sicher speichern.';

  @override
  String get withoutCredentials => 'Ohne Anmeldedaten';

  @override
  String get includeCredentials => 'Anmeldedaten Einschließen';

  @override
  String get unableToAccessFilePath => 'Zugriff auf Dateipfad nicht möglich';

  @override
  String invalidFileFormat(String error) {
    return 'Ungültige Datei: $error';
  }

  @override
  String get noProfiles => 'Keine Profile';

  @override
  String get addProfileToManageInstances =>
      'Fügen Sie ein Profil hinzu, um OPNsense-Instanzen zu verwalten';

  @override
  String get unknown => 'Unbekannt';

  @override
  String get http => 'http';

  @override
  String get https => 'https';

  @override
  String errorPrefix(String message) {
    return 'Fehler: $message';
  }

  @override
  String get switchProfileConfirmation => 'Profil wechseln?';

  @override
  String rebootFailedWithError(String message, String error) {
    return '$message: $error';
  }

  @override
  String get zeroSeconds => '0 Sekunden';

  @override
  String get day => 'Tag';

  @override
  String get hour => 'Stunde';

  @override
  String get second => 'Sekunde';

  @override
  String get hostIsRequired => 'Host ist erforderlich';

  @override
  String get invalidHostnameOrIp => 'Ungültiger Hostname oder IP-Adresse';

  @override
  String get portIsRequired => 'Port ist erforderlich';

  @override
  String get portMustBeBetween => 'Port muss zwischen 1 und 65535 liegen';

  @override
  String get apiKeyIsRequired => 'API-Schlüssel ist erforderlich';

  @override
  String get invalidApiKeyFormat => 'Ungültiges API-Schlüsselformat';

  @override
  String get apiSecretIsRequired => 'API-Geheimnis ist erforderlich';

  @override
  String get invalidApiSecretFormat => 'Ungültiges API-Geheimnisformat';

  @override
  String fieldIsRequired(String fieldName) {
    return '$fieldName ist erforderlich';
  }

  @override
  String actionService(String action) {
    return '$action Dienst';
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
  String get notAvailable => 'N/V';

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
}
