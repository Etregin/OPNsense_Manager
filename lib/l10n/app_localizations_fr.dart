// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'Gestionnaire OPNsense';

  @override
  String get dashboard => 'Tableau de Bord';

  @override
  String get firewallRules => 'Règles du Pare-feu';

  @override
  String get firewallLogs => 'Journaux du Pare-feu';

  @override
  String get systemInfo => 'Informations Système';

  @override
  String get vpnConnections => 'Connexions VPN';

  @override
  String get settings => 'Paramètres';

  @override
  String get hostname => 'Nom d\'Hôte';

  @override
  String get versionLabel => 'Version';

  @override
  String get platform => 'Plateforme';

  @override
  String get uptime => 'Temps de Fonctionnement';

  @override
  String get cpuUsage => 'Utilisation CPU';

  @override
  String get memoryUsage => 'Utilisation Mémoire';

  @override
  String get services => 'Services';

  @override
  String get gateways => 'Passerelles';

  @override
  String get running => 'En Cours';

  @override
  String get stopped => 'Arrêté';

  @override
  String get online => 'En Ligne';

  @override
  String get offline => 'Hors Ligne';

  @override
  String get start => 'Démarrer';

  @override
  String get stop => 'Arrêter';

  @override
  String get restart => 'Redémarrer';

  @override
  String get enable => 'Activer';

  @override
  String get disable => 'Désactiver';

  @override
  String get delete => 'Supprimer';

  @override
  String get edit => 'Modifier';

  @override
  String get save => 'Enregistrer';

  @override
  String get cancel => 'Annuler';

  @override
  String get ok => 'OK';

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

  @override
  String get close => 'Fermer';

  @override
  String get refresh => 'Actualiser';

  @override
  String get apply => 'Appliquer';

  @override
  String get login => 'Connexion';

  @override
  String get logout => 'Déconnexion';

  @override
  String get host => 'Hôte';

  @override
  String get port => 'Port';

  @override
  String get apiKey => 'Clé API';

  @override
  String get apiSecret => 'Secret API';

  @override
  String get useHttps => 'Utiliser HTTPS';

  @override
  String get allowSelfSigned => 'Autoriser Certificat Auto-signé';

  @override
  String get testConnection => 'Tester la Connexion';

  @override
  String get connectionSuccessful => 'Connexion Réussie';

  @override
  String get connectionFailed =>
      'Échec de la connexion. Vérifiez les journaux de la console pour plus de détails.\n\nProblèmes courants :\n• L\'appareil n\'est pas sur le même réseau qu\'OPNsense\n• Adresse IP ou port incorrect\n• Pare-feu bloquant la connexion\n• Identifiants API invalides';

  @override
  String get profiles => 'Profils';

  @override
  String get addProfile => 'Ajouter un Profil';

  @override
  String get editProfile => 'Modifier le Profil';

  @override
  String get deleteProfile => 'Supprimer le Profil';

  @override
  String get profileName => 'Nom du Profil';

  @override
  String get activeProfile => 'Profil Actif';

  @override
  String get switchProfile => 'Changer de Profil';

  @override
  String get exportProfiles => 'Exporter les Profils';

  @override
  String get importProfiles => 'Importer les Profils';

  @override
  String get security => 'Sécurité';

  @override
  String get pinLock => 'Verrouillage PIN';

  @override
  String get changePIN => 'Changer le PIN';

  @override
  String get biometricAuth => 'Authentification Biométrique';

  @override
  String get sessionTimeout => 'Délai d\'Expiration de Session';

  @override
  String get lockApp => 'Verrouiller l\'Application';

  @override
  String get appearance => 'Apparence';

  @override
  String get theme => 'Thème';

  @override
  String get language => 'Langue';

  @override
  String get lightMode => 'Mode Clair';

  @override
  String get darkMode => 'Mode Sombre';

  @override
  String get systemDefault => 'Par Défaut du Système';

  @override
  String get general => 'Général';

  @override
  String get about => 'À Propos';

  @override
  String get licenses => 'Licences';

  @override
  String get firewallRuleDetails => 'Détails de la Règle du Pare-feu';

  @override
  String get createRule => 'Créer une Règle';

  @override
  String get editRule => 'Modifier la Règle';

  @override
  String get deleteRule => 'Supprimer la Règle';

  @override
  String get action => 'Action';

  @override
  String get interface => 'Interface';

  @override
  String get protocol => 'Protocole';

  @override
  String get source => 'Source';

  @override
  String get destination => 'Destination';

  @override
  String get sourcePort => 'Port Source';

  @override
  String get destinationPort => 'Port de Destination';

  @override
  String get description => 'Description';

  @override
  String get enabled => 'Activé';

  @override
  String get disabled => 'Désactivé';

  @override
  String get pass => 'Autoriser';

  @override
  String get block => 'Bloquer';

  @override
  String get reject => 'Rejeter';

  @override
  String get logs => 'Journaux';

  @override
  String get filterByAction => 'Filtrer par Action';

  @override
  String get showAll => 'Tout Afficher';

  @override
  String get autoRefresh => 'Actualisation Automatique';

  @override
  String get logLimit => 'Limite de Journaux';

  @override
  String get paused => 'En pause';

  @override
  String get live => 'En direct';

  @override
  String get entries => 'entrées';

  @override
  String get selected => 'sélectionné';

  @override
  String get selectAll => 'Tout sélectionner';

  @override
  String get copy => 'Copier';

  @override
  String get historySize => 'Taille de l\'historique';

  @override
  String get enableAutoScroll => 'Activer le défilement automatique';

  @override
  String get disableAutoScroll => 'Désactiver le défilement automatique';

  @override
  String get clearLogs => 'Effacer les journaux';

  @override
  String get pause => 'Pause';

  @override
  String get resume => 'Reprendre';

  @override
  String copiedLogEntries(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'entrées',
      one: 'entrée',
    );
    return 'Copié $count $_temp0 de journal';
  }

  @override
  String get pauseLiveViewToSelect =>
      'Mettez en pause la vue en direct pour sélectionner les entrées de journal';

  @override
  String get errorLoadingLogs => 'Erreur lors du chargement des journaux';

  @override
  String get noLogsAvailable => 'Aucun journal disponible';

  @override
  String get logsWillAppear =>
      'Les journaux apparaîtront ici au fur et à mesure de leur génération';

  @override
  String get selectNumberOfEntries =>
      'Sélectionnez le nombre d\'entrées de journal à afficher:';

  @override
  String get reason => 'Raison';

  @override
  String get newRule => 'Nouvelle Règle';

  @override
  String get ruleDetails => 'Détails de la règle';

  @override
  String get type => 'Type';

  @override
  String get sequence => 'Séquence';

  @override
  String get status => 'Statut';

  @override
  String get systemGeneratedRule =>
      'Il s\'agit d\'une règle générée par le système et ne peut pas être modifiée ou supprimée.';

  @override
  String get systemGeneratedRulesCannotBeModified =>
      'Les règles générées par le système ne peuvent pas être modifiées';

  @override
  String get systemGeneratedRulesCannotBeDeleted =>
      'Les règles générées par le système ne peuvent pas être supprimées';

  @override
  String get enableRule => 'Activer la règle';

  @override
  String get disableRule => 'Désactiver la règle';

  @override
  String get enablingRule => 'Activation de la règle...';

  @override
  String get disablingRule => 'Désactivation de la règle...';

  @override
  String get ruleEnabledSuccessfully => 'Règle activée avec succès';

  @override
  String get ruleDisabledSuccessfully => 'Règle désactivée avec succès';

  @override
  String errorTogglingRule(String error) {
    return 'Erreur lors du basculement de la règle: $error';
  }

  @override
  String deleteRuleConfirmation(String description) {
    return 'Êtes-vous sûr de vouloir supprimer la règle \"$description\"?';
  }

  @override
  String get ruleDeleted => 'Règle supprimée avec succès';

  @override
  String errorDeletingRule(String error) {
    return 'Erreur lors de la suppression de la règle: $error';
  }

  @override
  String get errorLoadingRules => 'Erreur lors du chargement des règles';

  @override
  String get noAutomationRulesFound => 'Aucune règle d\'automatisation trouvée';

  @override
  String get createFirstAutomationRule =>
      'Créez votre première règle d\'automatisation pour commencer';

  @override
  String get noInterfacesWithAutomationRules =>
      'Aucune interface avec des règles d\'automatisation';

  @override
  String get selectInterface => 'Sélectionner l\'interface';

  @override
  String get selectInterfaceToViewRules =>
      'Sélectionnez une interface pour afficher les règles';

  @override
  String noRulesForInterface(String interface) {
    return 'Aucune règle pour $interface';
  }

  @override
  String get unnamedRule => 'Règle sans nom';

  @override
  String get systemInformation => 'Informations Système';

  @override
  String get firmwareDetails => 'Détails du Firmware';

  @override
  String get systemType => 'Type de Système';

  @override
  String get architecture => 'Architecture';

  @override
  String get gitCommit => 'Commit Git';

  @override
  String get packageMirror => 'Miroir de Paquets';

  @override
  String get repository => 'Dépôt';

  @override
  String get lastUpdate => 'Dernière Mise à Jour';

  @override
  String get errorLoadingSystemInfo =>
      'Erreur lors du chargement des informations système';

  @override
  String get errorLoadingVPNConnections =>
      'Erreur lors du chargement des connexions VPN';

  @override
  String get noVPNConnectionsFound => 'Aucune connexion VPN trouvée';

  @override
  String noConnectionsFound(String type) {
    return 'Aucune connexion $type trouvée';
  }

  @override
  String get vpnConnectionsWillAppear =>
      'Les connexions VPN apparaîtront ici lorsqu\'elles seront configurées';

  @override
  String get totalVPNs => 'Total VPN';

  @override
  String get filterByType => 'Filtrer par type';

  @override
  String get allVPNs => 'Tous les VPN';

  @override
  String get connectVPN => 'Connecter VPN';

  @override
  String get disconnectVPN => 'Déconnecter VPN';

  @override
  String connectingVPN(String name) {
    return 'Connexion à $name...';
  }

  @override
  String disconnectingVPN(String name) {
    return 'Déconnexion de $name...';
  }

  @override
  String successfullyConnected(String name) {
    return 'Connecté avec succès à $name';
  }

  @override
  String successfullyDisconnected(String name) {
    return 'Déconnecté avec succès de $name';
  }

  @override
  String failedToConnect(String name) {
    return 'Échec de la connexion à $name';
  }

  @override
  String failedToDisconnect(String name) {
    return 'Échec de la déconnexion de $name';
  }

  @override
  String get restartVPNService => 'Redémarrer le service VPN';

  @override
  String restartServiceConfirmation(String type) {
    return 'Êtes-vous sûr de vouloir redémarrer le service $type?\n\nCela déconnectera temporairement toutes les connexions actives.';
  }

  @override
  String restartingService(String type) {
    return 'Redémarrage du service $type...';
  }

  @override
  String successfullyRestartedService(String type) {
    return 'Service $type redémarré avec succès';
  }

  @override
  String failedToRestartService(String type) {
    return 'Échec du redémarrage du service $type';
  }

  @override
  String get enterRuleDescription => 'Entrez la description de la règle';

  @override
  String get loading => 'Chargement...';

  @override
  String get any => 'Tout';

  @override
  String get anyIpAddressCidrOrAlias => 'tout, adresse IP, CIDR ou alias';

  @override
  String get examplesAnyIpCidr => 'Exemples : any, 192.168.1.0/24, 10.0.0.1';

  @override
  String get sourceIsRequired => 'La source est obligatoire';

  @override
  String get invalidSourceFormat => 'Format de source invalide';

  @override
  String get sourcePortOptional => 'Port Source (Optionnel)';

  @override
  String get anyPortNumberRangeOrAlias =>
      'tout, numéro de port, plage ou alias';

  @override
  String get examplesAnyPortRange => 'Exemples : any, 80, 1024-65535';

  @override
  String get invalidPortFormat => 'Format de port invalide';

  @override
  String get destinationIsRequired => 'La destination est obligatoire';

  @override
  String get invalidDestinationFormat => 'Format de destination invalide';

  @override
  String get destinationPortOptional => 'Port de Destination (Optionnel)';

  @override
  String get examplesAnyPortRangeHttp => 'Exemples : any, 80, 80-443, http';

  @override
  String get ruleWillBeActiveWhenEnabled =>
      'La règle sera active lorsqu\'elle est activée';

  @override
  String get ruleGuidelines => 'Directives des Règles';

  @override
  String get ruleGuidelinesText =>
      '• Utilisez \"any\" pour correspondre à toutes les adresses ou ports\n• Notation CIDR : 192.168.1.0/24\n• Plages de ports : 80-443\n• Les règles sont traitées dans l\'ordre séquentiel\n• Les modifications sont appliquées immédiatement';

  @override
  String get updateRule => 'Mettre à Jour la Règle';

  @override
  String get ruleUpdated => 'Règle mise à jour avec succès';

  @override
  String get ruleCreated => 'Règle créée avec succès';

  @override
  String errorSavingRule(String error) {
    return 'Erreur lors de l\'enregistrement de la règle : $error';
  }

  @override
  String get connectToYourOPNsenseFirewall =>
      'Connectez-vous à votre pare-feu OPNsense';

  @override
  String get profileNameOptional => 'Nom du Profil (Optionnel)';

  @override
  String get myOPNsenseRouter => 'Mon Routeur OPNsense';

  @override
  String get hostIpAddress => 'Hôte / Adresse IP';

  @override
  String get hostPlaceholder => '192.168.1.1 ou firewall.example.com';

  @override
  String get portPlaceholder => '443';

  @override
  String get recommendedForSecureConnections =>
      'Recommandé pour les connexions sécurisées';

  @override
  String get enterYourApiKey => 'Entrez votre clé API';

  @override
  String get enterYourApiSecret => 'Entrez votre secret API';

  @override
  String get connect => 'Connecter';

  @override
  String apiError(String message) {
    return 'Erreur API : $message';
  }

  @override
  String get needHelpCheckDocumentation =>
      'Besoin d\'aide ? Consultez la documentation OPNsense pour la génération de clés API.';

  @override
  String get selectAProfileOrCreateNewOne =>
      'Sélectionnez un profil ou créez-en un nouveau';

  @override
  String get createNewProfile => 'Créer un Nouveau Profil';

  @override
  String get noProfilesYet => 'Aucun Profil Pour le Moment';

  @override
  String get createYourFirstProfile =>
      'Créez votre premier profil OPNsense pour commencer';

  @override
  String lastUsed(String date) {
    return 'Dernière utilisation : $date';
  }

  @override
  String get justNow => 'À l\'instant';

  @override
  String minutesAgo(String minutes) {
    return 'Il y a ${minutes}m';
  }

  @override
  String hoursAgo(String hours) {
    return 'Il y a ${hours}h';
  }

  @override
  String daysAgo(String days) {
    return 'Il y a ${days}j';
  }

  @override
  String connectionFailedError(String error) {
    return 'Échec de la connexion : $error';
  }

  @override
  String get enterPin => 'Entrer le PIN';

  @override
  String get unlockOPNsenseManager => 'Déverrouiller OPNsense Manager';

  @override
  String get pleaseEnterYourPin => 'Veuillez entrer votre PIN';

  @override
  String get incorrectPin => 'PIN incorrect';

  @override
  String get unlock => 'Déverrouiller';

  @override
  String get useBiometric => 'Utiliser la Biométrie';

  @override
  String get authenticateToUnlock =>
      'Authentifiez-vous pour déverrouiller OPNsense Manager';

  @override
  String version(String version) {
    return 'Version $version';
  }

  @override
  String get remoteAddress => 'Adresse distante';

  @override
  String get localAddress => 'Adresse locale';

  @override
  String get received => 'Reçu';

  @override
  String get sent => 'Envoyé';

  @override
  String get vpnStatus => 'État VPN';

  @override
  String get connected => 'Connecté';

  @override
  String get disconnected => 'Déconnecté';

  @override
  String get disconnect => 'Déconnecter';

  @override
  String get vpnType => 'Type de VPN';

  @override
  String get clientAddress => 'Adresse Client';

  @override
  String get virtualAddress => 'Adresse Virtuelle';

  @override
  String get bytesReceived => 'Octets Reçus';

  @override
  String get bytesSent => 'Octets Envoyés';

  @override
  String get connectedSince => 'Connecté Depuis';

  @override
  String get rebootSystem => 'Redémarrer le Système';

  @override
  String get rebootConfirmation =>
      'Êtes-vous sûr de vouloir redémarrer le système ?';

  @override
  String get rebootSuccess => 'Redémarrage du système initié';

  @override
  String get rebootFailed => 'Échec du redémarrage du système';

  @override
  String get error => 'Erreur';

  @override
  String get success => 'Succès';

  @override
  String get warning => 'Avertissement';

  @override
  String get info => 'Information';

  @override
  String get noData => 'Aucune donnée disponible';

  @override
  String get retry => 'Réessayer';

  @override
  String get confirmDelete => 'Confirmer la Suppression';

  @override
  String get deleteConfirmation =>
      'Êtes-vous sûr de vouloir supprimer cet élément ?';

  @override
  String get cannotBeUndone => 'Cette action ne peut pas être annulée.';

  @override
  String get enterPIN => 'Entrer le PIN';

  @override
  String get confirmPIN => 'Confirmer le PIN';

  @override
  String get pinMismatch => 'Les PIN ne correspondent pas';

  @override
  String get pinTooShort => 'Le PIN doit contenir au moins 4 chiffres';

  @override
  String get invalidPIN => 'PIN invalide';

  @override
  String get minutes => 'minutes';

  @override
  String get seconds => 'secondes';

  @override
  String get hours => 'heures';

  @override
  String get days => 'jours';

  @override
  String get required => 'Requis';

  @override
  String get optional => 'Optionnel';

  @override
  String get invalidInput => 'Entrée invalide';

  @override
  String get fieldRequired => 'Ce champ est requis';

  @override
  String get exportSuccess => 'Exportation réussie';

  @override
  String get exportFailed => 'Exportation échouée';

  @override
  String get importSuccess => 'Importation réussie';

  @override
  String get importFailed => 'Importation échouée';

  @override
  String importedProfiles(int count) {
    return '$count profil(s) importé(s)';
  }

  @override
  String get noProfilesFound => 'Aucun profil trouvé';

  @override
  String get createFirstProfile => 'Créez votre premier profil pour commencer';

  @override
  String get serviceStarted => 'Service démarré avec succès';

  @override
  String get serviceStopped => 'Service arrêté avec succès';

  @override
  String get serviceRestarted => 'Service redémarré avec succès';

  @override
  String get serviceActionFailed => 'Action du service échouée';

  @override
  String get ruleActionFailed => 'Action de règle échouée';

  @override
  String get profileSaved => 'Profil enregistré avec succès';

  @override
  String get profileDeleted => 'Profil supprimé avec succès';

  @override
  String get profileActivated => 'Profil activé avec succès';

  @override
  String get authenticationRequired => 'Authentification Requise';

  @override
  String get authenticationFailed => 'Authentification échouée';

  @override
  String get networkError => 'Une erreur réseau s\'est produite';

  @override
  String get serverError => 'Une erreur serveur s\'est produite';

  @override
  String get unauthorized => 'Accès non autorisé';

  @override
  String get forbidden => 'Accès interdit';

  @override
  String get notFound => 'Ressource non trouvée';

  @override
  String get timeout => 'Délai d\'attente dépassé';

  @override
  String get none => 'Aucun';

  @override
  String get diskUsage => 'Utilisation du Disque';

  @override
  String get pinLockDisabled =>
      'Verrouillage PIN désactivé. Verrouillage biométrique également désactivé.';

  @override
  String get setPin => 'Définir le PIN';

  @override
  String get pinLockTitle => 'Verrouillage PIN';

  @override
  String get requirePinToUnlock =>
      'Nécessite un PIN pour déverrouiller l\'application';

  @override
  String get changePinTitle => 'Changer le PIN';

  @override
  String get updatePinCode => 'Mettre à jour votre code PIN';

  @override
  String get lockTimeoutLabel => 'Délai de Verrouillage';

  @override
  String lockAfterMinutes(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'minutes',
      one: 'minute',
    );
    return 'Verrouiller après $minutes $_temp0 d\'inactivité';
  }

  @override
  String get minute => 'minute';

  @override
  String get add => 'Ajouter';

  @override
  String get profileAdded => 'Profil ajouté';

  @override
  String get profileUpdated => 'Profil mis à jour';

  @override
  String get exportProfilesTitle => 'Exporter les Profils';

  @override
  String get chooseExportLocation => 'Choisir l\'Emplacement d\'Exportation';

  @override
  String profilesExportedSuccessfully(String path) {
    return 'Profils exportés avec succès !\n$path';
  }

  @override
  String exportFailedError(String error) {
    return 'Échec de l\'exportation : $error';
  }

  @override
  String get importProfilesTitle => 'Importer les Profils';

  @override
  String invalidFileError(String error) {
    return 'Fichier invalide : $error';
  }

  @override
  String get importProfilesDialog =>
      'Comment les profils existants doivent-ils être traités ?\n\n• Conserver les Deux : Importer avec de nouveaux IDs\n• Écraser : Remplacer les profils existants';

  @override
  String get keepBoth => 'Conserver les Deux';

  @override
  String get overwrite => 'Écraser';

  @override
  String successfullyImportedProfiles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'profils importés',
      one: 'profil importé',
    );
    return '$count $_temp0 avec succès';
  }

  @override
  String importFailedWithErrors(String errors) {
    return 'Échec de l\'importation : $errors';
  }

  @override
  String importedWithFailures(int success, int failed) {
    String _temp0 = intl.Intl.pluralLogic(
      success,
      locale: localeName,
      other: 'profils importés',
      one: 'profil importé',
    );
    return '$success $_temp0, $failed échoué(s)';
  }

  @override
  String get deleteProfileTitle => 'Supprimer le Profil';

  @override
  String deleteProfileConfirmation(String name) {
    return 'Êtes-vous sûr de vouloir supprimer \"$name\" ?';
  }

  @override
  String get applicationLegalese =>
      '© 2026 OPNsense Manager\n\nSous licence GNU General Public License v3.0\n\nCe programme est un logiciel libre : vous pouvez le redistribuer et/ou le modifier selon les termes de la GNU General Public License publiée par la Free Software Foundation, soit la version 3 de la Licence, soit (à votre choix) toute version ultérieure.';

  @override
  String get aboutDescription =>
      'Une application mobile Flutter professionnelle pour gérer les routeurs pare-feu OPNsense.';

  @override
  String get featuresTitle => 'Fonctionnalités';

  @override
  String get featuresList =>
      '• Surveillance et gestion du système\n• Configuration des règles de pare-feu\n• Contrôle des services\n• Journaux en temps réel\n• Support multi-profils\n• Authentification sécurisée';

  @override
  String get viewFullLicense => 'Voir la Licence Complète';

  @override
  String get gnuLicenseTitle => 'Licence Publique Générale GNU v3.0';

  @override
  String get gnuLicenseText =>
      'Ce programme est un logiciel libre : vous pouvez le redistribuer et/ou le modifier selon les termes de la GNU General Public License publiée par la Free Software Foundation, soit la version 3 de la Licence, soit (à votre choix) toute version ultérieure.\n\nCe programme est distribué dans l\'espoir qu\'il sera utile, mais SANS AUCUNE GARANTIE ; sans même la garantie implicite de QUALITÉ MARCHANDE ou d\'ADÉQUATION À UN USAGE PARTICULIER. Voir la GNU General Public License pour plus de détails.\n\nVous devriez avoir reçu une copie de la GNU General Public License avec ce programme. Si ce n\'est pas le cas, consultez <https://www.gnu.org/licenses/>.\n\nPourquoi GPLv3 ?\n\n• Garantit que le logiciel reste libre et open source\n• Toute modification ou dérivé doit également être open source\n• Les utilisateurs ont la liberté d\'utiliser, d\'étudier, de partager et de modifier le logiciel\n• La communauté bénéficie des améliorations et des contributions';

  @override
  String get enterPinLabel => 'Entrer le PIN (4-6 chiffres)';

  @override
  String get confirmPin => 'Confirmer le PIN';

  @override
  String get pinLockEnabled => 'Verrouillage PIN activé';

  @override
  String get currentPin => 'PIN Actuel';

  @override
  String get newPin => 'Nouveau PIN (4-6 chiffres)';

  @override
  String get confirmNewPin => 'Confirmer le Nouveau PIN';

  @override
  String get currentPinIncorrect => 'Le PIN actuel est incorrect';

  @override
  String get pinChangedSuccessfully => 'PIN modifié avec succès';

  @override
  String get pleaseEnterCurrentPin => 'Veuillez entrer votre PIN actuel';

  @override
  String get pleaseEnterNewPin => 'Veuillez entrer un nouveau PIN';

  @override
  String get pinMustContainOnlyNumbers =>
      'Le PIN ne doit contenir que des chiffres';

  @override
  String get newPinMustBeDifferent =>
      'Le nouveau PIN doit être différent de l\'actuel';

  @override
  String get enablePinLockFirst =>
      'Veuillez activer le verrouillage PIN d\'abord avant d\'utiliser la biométrie';

  @override
  String get biometricNotAvailable =>
      'L\'authentification biométrique n\'est pas disponible sur cet appareil';

  @override
  String get biometricLockEnabled => 'Verrouillage biométrique activé';

  @override
  String get biometricAuthFailed =>
      'L\'authentification biométrique a échoué ou a été annulée';

  @override
  String get biometricLockDisabled => 'Verrouillage biométrique désactivé';

  @override
  String biometricLockTitle(String biometricType) {
    return 'Verrouillage $biometricType';
  }

  @override
  String useBiometricToUnlock(String biometricType) {
    return 'Utiliser $biometricType pour déverrouiller l\'application';
  }

  @override
  String get enablePinLockFirstBiometric =>
      'Activez le verrouillage PIN d\'abord pour utiliser la biométrie';

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
  String get oneHour => '1 heure';

  @override
  String lockTimeoutSet(int value) {
    String _temp0 = intl.Intl.pluralLogic(
      value,
      locale: localeName,
      other: 'minutes',
      one: 'minute',
    );
    return 'Délai de verrouillage défini à $value $_temp0';
  }

  @override
  String get activate => 'Activer';

  @override
  String get import => 'Importer';

  @override
  String get export => 'Exporter';

  @override
  String get activatingProfile => 'Activation du profil...';

  @override
  String activatedProfile(String name) {
    return 'Profil activé : $name';
  }

  @override
  String get connectionTestFailed => 'Test de connexion échoué';

  @override
  String get profileNameLabel => 'Nom du Profil';

  @override
  String get hostIpAddressLabel => 'Hôte/Adresse IP';

  @override
  String get portLabel => 'Port';

  @override
  String get useHttpsLabel => 'Utiliser HTTPS';

  @override
  String get apiKeyLabel => 'Clé API';

  @override
  String get apiSecretLabel => 'Secret API';

  @override
  String get profileNameRequired => 'Le nom du profil est requis';

  @override
  String get exportProfilesContent =>
      'Voulez-vous inclure les identifiants API dans l\'exportation ?\n\nAVERTISSEMENT : L\'inclusion des identifiants stockera les clés API et les secrets en texte brut. N\'incluez les identifiants que si vous stockerez le fichier en toute sécurité.';

  @override
  String get withoutCredentials => 'Sans Identifiants';

  @override
  String get includeCredentials => 'Inclure les Identifiants';

  @override
  String get exportProfile => 'Exporter le Profil';

  @override
  String get exportProfileTitle => 'Exporter le Profil';

  @override
  String get exportProfileContent =>
      'Voulez-vous inclure les identifiants API dans l\'exportation ?\n\nAVERTISSEMENT : L\'inclusion des identifiants stockera les clés API et les secrets en texte brut. N\'incluez les identifiants que si vous stockerez le fichier en toute sécurité.';

  @override
  String get unableToAccessFilePath =>
      'Impossible d\'accéder au chemin du fichier';

  @override
  String invalidFileFormat(String error) {
    return 'Fichier invalide : $error';
  }

  @override
  String get noProfiles => 'Aucun Profil';

  @override
  String get addProfileToManageInstances =>
      'Ajoutez un profil pour gérer les instances OPNsense';

  @override
  String get unknown => 'Inconnu';

  @override
  String get http => 'http';

  @override
  String get https => 'https';

  @override
  String errorPrefix(String message) {
    return 'Erreur: $message';
  }

  @override
  String get switchProfileConfirmation => 'Changer de profil?';

  @override
  String rebootFailedWithError(String message, String error) {
    return '$message: $error';
  }

  @override
  String get zeroSeconds => '0 secondes';

  @override
  String get day => 'jour';

  @override
  String get hour => 'heure';

  @override
  String get second => 'seconde';

  @override
  String get hostIsRequired => 'L\'hôte est requis';

  @override
  String get invalidHostnameOrIp => 'Nom d\'hôte ou adresse IP non valide';

  @override
  String get portIsRequired => 'Le port est requis';

  @override
  String get portMustBeBetween => 'Le port doit être entre 1 et 65535';

  @override
  String get apiKeyIsRequired => 'La clé API est requise';

  @override
  String get invalidApiKeyFormat => 'Format de clé API non valide';

  @override
  String get apiSecretIsRequired => 'Le secret API est requis';

  @override
  String get invalidApiSecretFormat => 'Format de secret API non valide';

  @override
  String fieldIsRequired(String fieldName) {
    return '$fieldName est requis';
  }

  @override
  String actionService(String action) {
    return '$action Service';
  }

  @override
  String confirmServiceAction(String action, String name) {
    return '$action \"$name\" ?';
  }

  @override
  String actioningService(String action, String name) {
    return '$action $name...';
  }

  @override
  String get notAvailable => 'N/D';

  @override
  String get unitBytes => 'o';

  @override
  String get unitKilobytes => 'Ko';

  @override
  String get unitMegabytes => 'Mo';

  @override
  String get unitGigabytes => 'Go';

  @override
  String get unitTerabytes => 'To';

  @override
  String get unitPetabytes => 'Po';

  @override
  String get unitPerSecond => '/s';

  @override
  String get hourAbbrev => 'h';

  @override
  String get minuteAbbrev => 'm';

  @override
  String get secondAbbrev => 's';

  @override
  String get liveNetworkMonitor => 'Moniteur Réseau en Direct';

  @override
  String get searchHostnameOrIp => 'Rechercher nom d\'hôte ou adresse IP...';

  @override
  String activeHosts(int count) {
    return '$count hôte(s) actif(s)';
  }

  @override
  String get noHostsFound => 'Aucun hôte trouvé';

  @override
  String get tryDifferentSearch => 'Essayez un terme de recherche différent';

  @override
  String get download => 'Téléchargement';

  @override
  String get upload => 'Envoi';

  @override
  String get totalBandwidth => 'Bande Passante Totale';

  @override
  String get of1Gbps => 'sur 1 Gbps';

  @override
  String get networkTotals => 'Totaux Réseau';

  @override
  String get totalDownload => 'Téléchargement Total';

  @override
  String get totalUpload => 'Envoi Total';

  @override
  String get activeDevices => 'Appareils Actifs';

  @override
  String get sortBy => 'Trier par';

  @override
  String get sortByBandwidth => 'Bande Passante';

  @override
  String get sortByHostname => 'Nom d\'Hôte';

  @override
  String get sortByIP => 'Adresse IP';

  @override
  String get sortByManufacturer => 'Fabricant';

  @override
  String get bandwidthLimit => 'Limite de Bande Passante';

  @override
  String get bandwidthLimitMbps => 'Limite de Bande Passante (Mbps)';

  @override
  String get enterBandwidthLimit =>
      'Entrez la limite de bande passante de votre connexion en Mbps';

  @override
  String get macAddress => 'Adresse MAC';

  @override
  String get monitorInterface => 'Interface de Surveillance';

  @override
  String get selectMultipleInterfaces =>
      'Sélectionnez une ou plusieurs interfaces à surveiller';

  @override
  String get dhcpLeases => 'Baux DHCP';

  @override
  String get searchHostnameIpOrMac => 'Rechercher nom d\'hôte, IP ou MAC...';

  @override
  String leasesCount(int filtered, int total) {
    return '$filtered sur $total bail/baux';
  }

  @override
  String get noLeasesFound => 'Aucun bail trouvé';

  @override
  String get all => 'Tous';

  @override
  String get active => 'Actif';

  @override
  String get expired => 'Expiré';

  @override
  String get expires => 'Expire';

  @override
  String get ipAddress => 'Adresse IP';

  @override
  String get staticLease => 'Statique';

  @override
  String get dynamicLease => 'Dynamique';

  @override
  String get blockHost => 'Bloquer l\'hôte';

  @override
  String blockHostConfirmation(String hostname, String ip) {
    return 'Êtes-vous sûr de vouloir bloquer $hostname ($ip)?\n\nCela créera une règle de pare-feu pour bloquer tout le trafic de cet hôte.';
  }

  @override
  String get blockingHost => 'Blocage de l\'hôte...';

  @override
  String get hostBlocked => 'Hôte bloqué avec succès';

  @override
  String get failedToBlockHost => 'Échec du blocage de l\'hôte';
}
