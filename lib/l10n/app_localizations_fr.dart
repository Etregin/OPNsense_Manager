// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get about => 'À Propos';

  @override
  String get aboutDescription =>
      'Une application mobile Flutter professionnelle pour gérer les routeurs pare-feu OPNsense.';

  @override
  String get aboutImportExport => 'À propos de l\'import et de l\'export';

  @override
  String get acceptDns => 'Accepter DNS';

  @override
  String get acceptDnsDescription =>
      'Utiliser les serveurs DNS fournis par Tailscale';

  @override
  String get acceptRoutes => 'Accepter les Routes';

  @override
  String get acceptSubnetRoutes => 'Accepter les Routes de Sous-réseau';

  @override
  String get acceptSubnetRoutesDescription =>
      'Accepter les routes annoncées par d\'autres nœuds';

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
  String get activate => 'Activer';

  @override
  String activatedProfile(String name) {
    return 'Profil activé : $name';
  }

  @override
  String get activatingProfile => 'Activation du profil...';

  @override
  String get activationFailed => 'Échec de l\'activation';

  @override
  String get active => 'Actif';

  @override
  String get activeDevices => 'Appareils Actifs';

  @override
  String activeHosts(int count) {
    return '$count hôte(s) actif(s)';
  }

  @override
  String get activeProfile => 'Profil Actif';

  @override
  String get add => 'Ajouter';

  @override
  String get addButton => 'Ajouter';

  @override
  String get addClientOverride => 'Ajouter une Substitution du Client';

  @override
  String get addConnection => 'Ajouter une connexion';

  @override
  String get addConnectionEndpoint =>
      'Veuillez ajouter au moins un point de connexion';

  @override
  String get addDnsServer => 'Ajouter un serveur DNS';

  @override
  String get addHost => 'Ajouter un hôte';

  @override
  String get addHostToGetStarted => 'Ajoutez un hôte pour commencer';

  @override
  String get addInstance => 'Ajouter une Instance';

  @override
  String get addOpenVpnInstance => 'Ajouter une Instance OpenVPN';

  @override
  String get addOverride => 'Ajouter une Substitution';

  @override
  String get addProfile => 'Ajouter un Profil';

  @override
  String get addProfileToManageInstances =>
      'Ajoutez un profil pour gérer les instances OPNsense';

  @override
  String get addStaticKey => 'Ajouter une Clé Statique';

  @override
  String get addStaticKeyTooltip => 'Ajouter une Clé Statique';

  @override
  String get addSubnet => 'Ajouter un Sous-réseau';

  @override
  String get addTunnelAddress => 'Ajouter une adresse de tunnel';

  @override
  String get additionalInformation => 'Informations supplémentaires';

  @override
  String get address => 'Adresse';

  @override
  String get addressIsRequired => 'L\'adresse est requise';

  @override
  String get advertiseExitNode => 'Annoncer le Nœud de Sortie';

  @override
  String get advertiseExitNodeDescription =>
      'Permettre aux autres appareils de router via ce nœud';

  @override
  String get advertiseRoutes => 'Annoncer les Routes';

  @override
  String get alert => 'Alerte';

  @override
  String get aliasDeletedSuccessfully => 'Alias supprimé avec succès';

  @override
  String get aliasDisabledSuccessfully => 'Alias désactivé avec succès';

  @override
  String get aliasEnabledSuccessfully => 'Alias activé avec succès';

  @override
  String get aliases => 'Alias';

  @override
  String get all => 'Tous';

  @override
  String get allConnectionsSuccessful =>
      'Toutes les connexions testées avec succès';

  @override
  String get allDetailsCopiedToClipboard =>
      'Tous les détails copiés dans le presse-papiers';

  @override
  String get allRoles => 'Tous les Rôles';

  @override
  String get allSettingsSavedSuccessfully =>
      'Tous les paramètres enregistrés avec succès';

  @override
  String get allStatus => 'Tous les États';

  @override
  String get allTypes => 'Tous les types';

  @override
  String get allVPNs => 'Tous les VPN';

  @override
  String get allowSelfSigned => 'Autoriser Certificat Auto-signé';

  @override
  String get allowSelfSignedCertificates =>
      'Autoriser les certificats auto-signés';

  @override
  String get allowSelfSignedCertificatesDescription =>
      'Accepter les certificats SSL auto-signés';

  @override
  String get allowedIps => 'IPs autorisées';

  @override
  String get allowedIpsLabel => 'IPs autorisées';

  @override
  String get any => 'Tout';

  @override
  String get anyIpAddressCidrOrAlias => 'tout, adresse IP, CIDR ou alias';

  @override
  String get anyPortNumberRangeOrAlias =>
      'tout, numéro de port, plage ou alias';

  @override
  String apiError(String message) {
    return 'Erreur API : $message';
  }

  @override
  String get apiKey => 'Clé API';

  @override
  String get apiKeyIsRequired => 'La clé API est requise';

  @override
  String get apiKeyLabel => 'Clé API';

  @override
  String get apiSecret => 'Secret API';

  @override
  String get apiSecretIsRequired => 'Le secret API est requis';

  @override
  String get apiSecretLabel => 'Secret API';

  @override
  String get appName => 'Gestionnaire OPNsense';

  @override
  String get appearance => 'Apparence';

  @override
  String get applicationLegalese =>
      '© 2026 OPNsense Manager\n\nSous licence GNU General Public License v3.0\n\nCe programme est un logiciel libre : vous pouvez le redistribuer et/ou le modifier selon les termes de la GNU General Public License publiée par la Free Software Foundation, soit la version 3 de la Licence, soit (à votre choix) toute version ultérieure.';

  @override
  String get apply => 'Appliquer';

  @override
  String get architecture => 'Architecture';

  @override
  String get atLeastOneTunnelAddressRequired =>
      'Au moins une adresse de tunnel est requise';

  @override
  String get authSettingsSavedSuccessfully =>
      'Paramètres d\'authentification enregistrés avec succès';

  @override
  String get authTlsAuthentication => 'Auth (Authentification TLS)';

  @override
  String get authTokenGeneratedSuccessfully =>
      'Jeton d\'authentification généré avec succès';

  @override
  String get authenticate => 'Authentifier';

  @override
  String get authenticateToUnlock =>
      'Authentifiez-vous pour déverrouiller OPNsense Manager';

  @override
  String get authentication => 'Authentification';

  @override
  String get authenticationFailed => 'Authentification échouée';

  @override
  String get authenticationRequired => 'Authentification Requise';

  @override
  String get authenticationSettings => 'Paramètres d\'Authentification';

  @override
  String get authenticated => 'Authentifié';

  @override
  String get notAuthenticated => 'Non authentifié';

  @override
  String get tailnet => 'Tailnet';

  @override
  String get deviceName => 'Nom de l\'appareil';

  @override
  String get authUrl => 'URL d\'authentification';

  @override
  String get user => 'Utilisateur';

  @override
  String get authorizedPeers => 'Pairs autorisés';

  @override
  String get autoRefresh => 'Actualisation Automatique';

  @override
  String get backendState => 'État du Backend';

  @override
  String get bandwidthLimit => 'Limite de Bande Passante';

  @override
  String get bandwidthLimitMbps => 'Limite de Bande Passante (Mbps)';

  @override
  String get base64EncodedPrivateKeyKeepSecret =>
      'Clé privée encodée en Base64 (garder secrète !)';

  @override
  String get base64EncodedPublicKey => 'Clé publique encodée en Base64';

  @override
  String get biometricAuth => 'Authentification Biométrique';

  @override
  String get biometricAuthFailed =>
      'L\'authentification biométrique a échoué ou a été annulée';

  @override
  String get biometricLockDisabled => 'Verrouillage biométrique désactivé';

  @override
  String get biometricLockEnabled => 'Verrouillage biométrique activé';

  @override
  String biometricLockTitle(String biometricType) {
    return 'Verrouillage $biometricType';
  }

  @override
  String get biometricNotAvailable =>
      'L\'authentification biométrique n\'est pas disponible sur cet appareil';

  @override
  String get block => 'Bloquer';

  @override
  String get blockHost => 'Bloquer l\'hôte';

  @override
  String blockHostConfirmation(String hostname, String ip) {
    return 'Êtes-vous sûr de vouloir bloquer $hostname ($ip)?\n\nCela créera une règle de pare-feu pour bloquer tout le trafic de cet hôte.';
  }

  @override
  String get blockingHost => 'Blocage de l\'hôte...';

  @override
  String get bytesReceived => 'Octets Reçus';

  @override
  String get bytesSent => 'Octets Envoyés';

  @override
  String get cancel => 'Annuler';

  @override
  String get cancelButton => 'Annuler';

  @override
  String get cannotBeUndone => 'Cette action ne peut pas être annulée.';

  @override
  String get cannotDeleteLastConnection =>
      'Impossible de supprimer le dernier point de terminaison de connexion';

  @override
  String get cannotDeleteLastConnectionTooltip =>
      'Impossible de supprimer le dernier point de terminaison de connexion';

  @override
  String get carpVhidToDepend => 'CARP VHID dont dépendre';

  @override
  String get categories => 'Catégories';

  @override
  String get changePIN => 'Changer le PIN';

  @override
  String get changePinTitle => 'Changer le PIN';

  @override
  String get changesDiscarded => 'Modifications annulées';

  @override
  String get checkIfWireguardIsConfiguredAndRunning =>
      'Vérifiez si WireGuard est configuré et en cours d\'exécution';

  @override
  String get chooseExportLocation => 'Choisir l\'Emplacement d\'Exportation';

  @override
  String get cidrNotationRequired => 'Notation CIDR requise';

  @override
  String get clearLogs => 'Effacer les journaux';

  @override
  String get clearSelection => 'Effacer la sélection';

  @override
  String get client => 'Client';

  @override
  String get clientAddress => 'Adresse Client';

  @override
  String get clientName => 'Nom du client';

  @override
  String get clientOverrides => 'Remplacements client';

  @override
  String get clientSettings => 'Paramètres du Client';

  @override
  String get clientSpecificOverrides => 'Remplacements Spécifiques au Client';

  @override
  String get clientX509CommonNameHelper =>
      'Entrez ici le nom commun X.509 du client.';

  @override
  String get close => 'Fermer';

  @override
  String get commonName => 'Nom Commun';

  @override
  String get commonNameRequired => 'Le nom commun est obligatoire';

  @override
  String commonNameWithValue(String value) {
    return 'Nom Commun : $value';
  }

  @override
  String get configurationAppliedSuccessfully =>
      'Configuration appliquée avec succès';

  @override
  String get configurationPreview => 'Aperçu de la configuration';

  @override
  String get configureAdvertisedSubnets =>
      'Configurer les sous-réseaux annoncés';

  @override
  String get configured => 'Configuré';

  @override
  String get confirmDelete => 'Confirmer la Suppression';

  @override
  String confirmDeleteInstance(String name) {
    return 'Êtes-vous sûr de vouloir supprimer l\'instance \"$name\" ? Cette action ne peut pas être annulée.';
  }

  @override
  String confirmDeleteOverride(String name) {
    return 'Êtes-vous sûr de vouloir supprimer la substitution pour \"$name\" ? Cette action ne peut pas être annulée.';
  }

  @override
  String confirmDeleteStaticKey(String name) {
    return 'Êtes-vous sûr de vouloir supprimer la clé statique \"$name\" ? Cette action ne peut pas être annulée.';
  }

  @override
  String get confirmNewPin => 'Confirmer le Nouveau PIN';

  @override
  String get confirmPIN => 'Confirmer le PIN';

  @override
  String get confirmPin => 'Confirmer le PIN';

  @override
  String confirmServiceAction(String action, String name) {
    return '$action \"$name\" ?';
  }

  @override
  String get connect => 'Connecter';

  @override
  String get connectToYourOPNsenseFirewall =>
      'Connectez-vous à votre pare-feu OPNsense';

  @override
  String get connectVPN => 'Connecter VPN';

  @override
  String get connected => 'Connecté';

  @override
  String get connectedSince => 'Connecté Depuis';

  @override
  String connectedSuccessfullyVia(String endpoint) {
    return 'Connecté avec succès via: $endpoint';
  }

  @override
  String connectingVPN(String name) {
    return 'Connexion à $name...';
  }

  @override
  String get connectionBlocking => 'Blocage de connexion';

  @override
  String get connectionBlockingSubtitle =>
      'Bloquez cette connexion client en fonction de son nom commun. N\'utilisez pas cette option pour désactiver définitivement un client en raison d\'une clé ou d\'un mot de passe compromis. Utilisez plutôt une CRL (liste de révocation de certificats).';

  @override
  String get connectionDetails => 'Détails de Connexion';

  @override
  String get connectionEndpoints => 'Points de terminaison de connexion';

  @override
  String get connectionEndpointsHelp =>
      'Gérez plusieurs points de terminaison de connexion pour ce profil. L\'application essaiera chaque point de terminaison dans l\'ordre jusqu\'à ce qu\'une connexion réussie soit établie.';

  @override
  String get connectionFailed =>
      'Échec de la connexion. Vérifiez les journaux de la console pour plus de détails.\n\nProblèmes courants :\n• L\'appareil n\'est pas sur le même réseau qu\'OPNsense\n• Adresse IP ou port incorrect\n• Pare-feu bloquant la connexion\n• Identifiants API invalides';

  @override
  String connectionFailedError(String error) {
    return 'Échec de la connexion : $error';
  }

  @override
  String get connectionInformation => 'Informations de connexion';

  @override
  String get connectionStatus => 'État de la connexion';

  @override
  String get connectionSuccessful => 'Connexion Réussie';

  @override
  String get connectionTestFailed => 'Test de connexion échoué';

  @override
  String get connectionTestResults => 'Résultats du test de connexion';

  @override
  String get content => 'Contenu';

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
  String get copiedToClipboard => 'Copié dans le presse-papiers';

  @override
  String get copy => 'Copier';

  @override
  String get copyAllDetails => 'Copier tous les détails';

  @override
  String get copyHost => 'Copier l\'hôte';

  @override
  String get copyKey => 'Copier la Clé';

  @override
  String get copyKeyTooltip => 'Copier la clé';

  @override
  String get copySelected => 'Copier la sélection';

  @override
  String get copyTooltip => 'Copier';

  @override
  String get cpuUsage => 'Utilisation CPU';

  @override
  String get createAliasComingSoon => 'Créer un alias (Prochainement)';

  @override
  String get createFirstAutomationRule =>
      'Créez votre première règle d\'automatisation pour commencer';

  @override
  String get createFirstProfile => 'Créez votre premier profil pour commencer';

  @override
  String get createNewProfile => 'Créer un Nouveau Profil';

  @override
  String get createOverride => 'Créer une Substitution';

  @override
  String get createPeer => 'Créer un pair';

  @override
  String get createRule => 'Créer une Règle';

  @override
  String get createServer => 'Créer un serveur';

  @override
  String get createStaticKey => 'Créer une Clé Statique';

  @override
  String get createYourFirstProfile =>
      'Créez votre premier profil OPNsense pour commencer';

  @override
  String get created => 'Créé';

  @override
  String get critical => 'Critique';

  @override
  String get cryptTlsEncryption => 'Crypt (Chiffrement TLS)';

  @override
  String get cryptV2TlsEncryption => 'Crypt V2 (Chiffrement TLS)';

  @override
  String get currentPin => 'PIN Actuel';

  @override
  String get currentPinIncorrect => 'Le PIN actuel est incorrect';

  @override
  String get darkMode => 'Mode Sombre';

  @override
  String get dashboard => 'Tableau de Bord';

  @override
  String get day => 'jour';

  @override
  String get days => 'jours';

  @override
  String daysAgo(int days) {
    return 'il y a $days jours';
  }

  @override
  String get debug => 'Débogage';

  @override
  String get debugDescription => 'Activer la journalisation de débogage';

  @override
  String get defineRoleOfInstance => 'Définir le rôle de cette instance';

  @override
  String get delete => 'Supprimer';

  @override
  String deleteAliasConfirmation(String aliasName) {
    return 'Êtes-vous sûr de vouloir supprimer l\'alias \"$aliasName\" ?';
  }

  @override
  String get deleteConfirmation =>
      'Êtes-vous sûr de vouloir supprimer cet élément ?';

  @override
  String get deleteConnection => 'Supprimer la connexion';

  @override
  String deleteConnectionConfirmation(String connectionName) {
    return 'Êtes-vous sûr de vouloir supprimer la connexion \"$connectionName\" ?';
  }

  @override
  String get deleteHost => 'Supprimer l\'hôte';

  @override
  String deleteHostConfirmation(String host) {
    return 'Êtes-vous sûr de vouloir supprimer \"$host\" ?';
  }

  @override
  String get deleteInstance => 'Supprimer l\'Instance';

  @override
  String get deleteOverride => 'Supprimer le Remplacement';

  @override
  String get deletePeer => 'Supprimer le Pair';

  @override
  String deletePeerConfirmation(String name) {
    return 'Êtes-vous sûr de vouloir supprimer le pair \"$name\" ?';
  }

  @override
  String get deleteProfile => 'Supprimer le Profil';

  @override
  String deleteProfileConfirmation(String name) {
    return 'Êtes-vous sûr de vouloir supprimer \"$name\" ?';
  }

  @override
  String get deleteProfileTitle => 'Supprimer le Profil';

  @override
  String get deleteRule => 'Supprimer la Règle';

  @override
  String deleteRuleConfirmation(String description) {
    return 'Êtes-vous sûr de vouloir supprimer la règle \"$description\"?';
  }

  @override
  String disableRuleConfirmation(String description) {
    return 'Êtes-vous sûr de vouloir désactiver la règle \"$description\" ?';
  }

  @override
  String enableRuleConfirmation(String description) {
    return 'Êtes-vous sûr de vouloir activer la règle \"$description\" ?';
  }

  @override
  String deleteServerConfirmation(String name) {
    return 'Êtes-vous sûr de vouloir supprimer le serveur \"$name\" ? Cette action ne peut pas être annulée.';
  }

  @override
  String get deleteStaticKey => 'Supprimer la Clé Statique';

  @override
  String get deleteSubnet => 'Supprimer le Sous-réseau';

  @override
  String deleteSubnetConfirmation(String subnet) {
    return 'Êtes-vous sûr de vouloir supprimer le sous-réseau $subnet ?';
  }

  @override
  String get demo => 'Démo';

  @override
  String get dependOnCarp => 'Dépendre de (CARP)';

  @override
  String get description => 'Description';

  @override
  String get descriptionHelperText => 'Une brève description de cette instance';

  @override
  String get descriptionHelperTextOverride =>
      'Vous pouvez entrer une description ici pour votre référence (non analysée).';

  @override
  String get descriptionHint => 'par ex., PC du salon';

  @override
  String get descriptionOptional => 'Description (optionnel)';

  @override
  String get descriptionRequired => 'La description est requise';

  @override
  String get descriptiveNameForStaticKey =>
      'Un nom descriptif pour cette clé statique';

  @override
  String get destination => 'Destination';

  @override
  String get destinationAddress => 'Adresse de destination';

  @override
  String get destinationIsRequired => 'La destination est obligatoire';

  @override
  String get destinationPort => 'Port de Destination';

  @override
  String get destinationPortOptional => 'Port de Destination (Optionnel)';

  @override
  String get deviceType => 'Type d\'Appareil';

  @override
  String get dhcpLeases => 'Baux DHCP';

  @override
  String dhcpServerLabel(String serverName) {
    return 'Serveur $serverName';
  }

  @override
  String get dhcpServerType => 'Type de serveur DHCP';

  @override
  String get direction => 'Direction';

  @override
  String get disable => 'Désactiver';

  @override
  String get disableAutoScroll => 'Désactiver le défilement automatique';

  @override
  String get disableRoutes => 'Désactiver les Routes';

  @override
  String get disableRoutesDescription =>
      'Empêcher l\'installation automatique des routes';

  @override
  String get disableRule => 'Désactiver la règle';

  @override
  String get disableSnat => 'Désactiver SNAT';

  @override
  String get disableSnatDescription =>
      'Désactiver le NAT source pour les routes de sous-réseau';

  @override
  String get disabled => 'Désactivé';

  @override
  String get disabledStatus => 'désactivé';

  @override
  String get disablingRule => 'Désactivation de la règle...';

  @override
  String get discard => 'Annuler';

  @override
  String get disconnect => 'Déconnecter';

  @override
  String get disconnectVPN => 'Déconnecter VPN';

  @override
  String get disconnected => 'Déconnecté';

  @override
  String disconnectingVPN(String name) {
    return 'Déconnexion de $name...';
  }

  @override
  String get diskUsage => 'Utilisation du Disque';

  @override
  String get dnsDomainList => 'Liste des Domaines DNS';

  @override
  String get dnsDomainListHelperText =>
      'Définir les suffixes DNS spécifiques à la connexion.';

  @override
  String get dnsDomainSearchList => 'Liste de Recherche de Domaines DNS';

  @override
  String get dnsDomainSearchListHelperText =>
      'Ajouter un nom à la liste de recherche de domaines. Répétez cette option pour ajouter plus d\'entrées. Jusqu\'à 10 domaines sont pris en charge.';

  @override
  String get dnsEnabled => 'DNS Activé';

  @override
  String get dnsServerIp => 'IP du serveur DNS';

  @override
  String get dnsServerIsRequired => 'Le serveur DNS est requis';

  @override
  String get dnsServerOptional => 'Serveur DNS (Optionnel)';

  @override
  String get dnsServers => 'Serveurs DNS';

  @override
  String get dnsServersHelperText =>
      'Définir l\'adresse IPv4 ou IPv6 du serveur de noms de domaine principal. Répétez cette option pour définir les adresses des serveurs DNS secondaires.';

  @override
  String get dnsServersOptional => 'Serveurs DNS (Optionnel)';

  @override
  String get dnsmasqDescription => 'Serveur DNS et DHCP léger';

  @override
  String get dnsmasqServerName => 'Dnsmasq';

  @override
  String get done => 'Terminé';

  @override
  String get doneButton => 'Terminé';

  @override
  String get download => 'Téléchargement';

  @override
  String get dynamicLease => 'Dynamique';

  @override
  String get edit => 'Modifier';

  @override
  String get editClientOverride => 'Modifier la Substitution du Client';

  @override
  String get editConnection => 'Modifier la connexion';

  @override
  String get editHost => 'Modifier l\'hôte';

  @override
  String get editProfile => 'Modifier le Profil';

  @override
  String get editRule => 'Modifier la Règle';

  @override
  String get editStaticKey => 'Modifier la Clé Statique';

  @override
  String get editSubnet => 'Modifier le Sous-réseau';

  @override
  String get editWireguardPeer => 'Modifier le pair WireGuard';

  @override
  String get editWireguardServer => 'Modifier le serveur WireGuard';

  @override
  String get emergency => 'Urgence';

  @override
  String get enable => 'Activer';

  @override
  String get enableAutoScroll => 'Activer le défilement automatique';

  @override
  String get enableClientSpecificOverride =>
      'Activer cette substitution spécifique au client';

  @override
  String get enableDebugLogging => 'Activer la journalisation de débogage';

  @override
  String get enablePinLockFirst =>
      'Veuillez activer le verrouillage PIN d\'abord avant d\'utiliser la biométrie';

  @override
  String get enablePinLockFirstBiometric =>
      'Activez le verrouillage PIN d\'abord pour utiliser la biométrie';

  @override
  String get enableRule => 'Activer la règle';

  @override
  String get enableSsh => 'Activer SSH';

  @override
  String get enableSshDescription => 'Autoriser l\'accès SSH via Tailscale';

  @override
  String get enableTailscale => 'Activer Tailscale';

  @override
  String get enableTailscaleDescription =>
      'Activer ou désactiver le service Tailscale';

  @override
  String get enableWireguard => 'Activer WireGuard';

  @override
  String get enabled => 'Activé';

  @override
  String get enabledLabel => 'Activé';

  @override
  String get enabledStatus => 'activé';

  @override
  String get enablingRule => 'Activation de la règle...';

  @override
  String get endTime => 'Heure de fin';

  @override
  String get endpoint => 'Point de terminaison';

  @override
  String get endpointAddress => 'Adresse du point de terminaison';

  @override
  String get endpointPort => 'Port du point de terminaison';

  @override
  String get enterBandwidthLimit =>
      'Entrez la limite de bande passante de votre connexion en Mbps';

  @override
  String get enterClientCertificateCommonName =>
      'Entrez le nom commun du certificat client';

  @override
  String get enterDescriptionForOverride =>
      'Entrez une description pour cette substitution';

  @override
  String get enterOrGeneratePresharedKey =>
      'Entrez ou générez une clé pré-partagée';

  @override
  String get enterOrGeneratePrivateKey => 'Entrez ou générez une clé privée';

  @override
  String get enterOrGeneratePublicKey => 'Entrez ou générez une clé publique';

  @override
  String get enterPIN => 'Entrer le PIN';

  @override
  String get enterPin => 'Entrer le PIN';

  @override
  String get enterPinLabel => 'Entrer le PIN (4-6 chiffres)';

  @override
  String get enterRuleDescription => 'Entrez la description de la règle';

  @override
  String get enterYourApiKey => 'Entrez votre clé API';

  @override
  String get enterYourApiSecret => 'Entrez votre secret API';

  @override
  String get entries => 'entrées';

  @override
  String entriesCount(int count) {
    return '$count entrées';
  }

  @override
  String get error => 'Erreur';

  @override
  String errorAddingSubnet(String error) {
    return 'Erreur lors de l\'ajout du sous-réseau : $error';
  }

  @override
  String errorDeletingRule(String error) {
    return 'Erreur lors de la suppression de la règle: $error';
  }

  @override
  String errorDeletingSubnet(String error) {
    return 'Erreur lors de la suppression du sous-réseau : $error';
  }

  @override
  String get errorLoadingData => 'Erreur lors du chargement des données';

  @override
  String get errorLoadingInstance => 'Erreur lors du chargement de l\'instance';

  @override
  String get errorLoadingLogs => 'Erreur lors du chargement des journaux';

  @override
  String get errorLoadingOverride =>
      'Erreur lors du chargement du remplacement';

  @override
  String get errorLoadingRoutes => 'Erreur lors du chargement des routes';

  @override
  String get errorLoadingRules => 'Erreur lors du chargement des règles';

  @override
  String get errorLoadingSessions => 'Erreur lors du chargement des sessions';

  @override
  String get errorLoadingSystemInfo =>
      'Erreur lors du chargement des informations système';

  @override
  String get errorLoadingVPNConnections =>
      'Erreur lors du chargement des connexions VPN';

  @override
  String errorPrefix(String message) {
    return 'Erreur: $message';
  }

  @override
  String errorRestartingService(String error) {
    return 'Erreur lors du redémarrage du service : $error';
  }

  @override
  String errorSavingRule(String error) {
    return 'Erreur lors de l\'enregistrement de la règle : $error';
  }

  @override
  String errorStartingService(String error) {
    return 'Erreur lors du démarrage du service : $error';
  }

  @override
  String errorStoppingService(String error) {
    return 'Erreur lors de l\'arrêt du service : $error';
  }

  @override
  String errorTogglingRule(String error) {
    return 'Erreur lors du basculement de la règle: $error';
  }

  @override
  String errorUpdatingSubnet(String error) {
    return 'Erreur lors de la mise à jour du sous-réseau : $error';
  }

  @override
  String get exampleCidr => 'Exemple : 10.10.10.2/24 ou fd00::2/64';

  @override
  String get exampleTunnelAddress => 'Exemple : 10.10.10.1/24 ou fd00::1/64';

  @override
  String get examplesAnyIpCidr => 'Exemples : any, 192.168.1.0/24, 10.0.0.1';

  @override
  String get examplesAnyPortRange => 'Exemples : any, 80, 1024-65535';

  @override
  String get examplesAnyPortRangeHttp => 'Exemples : any, 80, 80-443, http';

  @override
  String get exitNode => 'Nœud de Sortie';

  @override
  String get expired => 'Expiré';

  @override
  String get expires => 'Expire';

  @override
  String get expiryTime => 'Heure d\'expiration';

  @override
  String get export => 'Exporter';

  @override
  String get exportAllProfiles => 'Exporter tous les profils';

  @override
  String get exportAllProfilesSubtitle =>
      'Exporter tous les profils vers un fichier JSON';

  @override
  String get exportCredentialsWarning =>
      'L\'exportation avec les identifiants enregistrera les clés API et les secrets en texte brut. Ne faites cela que si vous stockerez le fichier en toute sécurité.';

  @override
  String get exportFailed => 'Exportation échouée';

  @override
  String exportFailedError(String error) {
    return 'Échec de l\'exportation : $error';
  }

  @override
  String get exportLogs => 'Exporter les journaux';

  @override
  String get exportProfiles => 'Exporter les Profils';

  @override
  String get exportProfilesContent =>
      'Voulez-vous inclure les identifiants API dans l\'exportation ?\n\nAVERTISSEMENT : L\'inclusion des identifiants stockera les clés API et les secrets en texte brut. N\'incluez les identifiants que si vous stockerez le fichier en toute sécurité.';

  @override
  String get exportProfilesTitle => 'Exporter les Profils';

  @override
  String get exportSuccess => 'Exportation réussie';

  @override
  String get exportThisProfile => 'Exporter ce profil';

  @override
  String get failedDevices => 'Appareils en échec';

  @override
  String failedToActionTailscaleService(String action) {
    return 'Échec de $action du service Tailscale';
  }

  @override
  String get failedToApplyConfiguration =>
      'Échec de l\'application de la configuration';

  @override
  String get failedToBlockHost => 'Échec du blocage de l\'hôte';

  @override
  String failedToConnect(String name) {
    return 'Échec de la connexion à $name';
  }

  @override
  String failedToCopyHost(String error) {
    return 'Échec de la copie de l\'hôte : $error';
  }

  @override
  String failedToDeleteAlias(String error) {
    return 'Échec de la suppression de l\'alias : $error';
  }

  @override
  String failedToDeleteHost(String error) {
    return 'Échec de la suppression de l\'hôte : $error';
  }

  @override
  String failedToDeleteInstance(String error) {
    return 'Échec de la suppression de l\'instance : $error';
  }

  @override
  String failedToDeleteOverride(String error) {
    return 'Échec de la suppression du remplacement : $error';
  }

  @override
  String failedToDeletePeer(String error) {
    return 'Échec de la suppression du pair : $error';
  }

  @override
  String get failedToDeleteProfile => 'Échec de la suppression du profil';

  @override
  String failedToDeleteServer(String error) {
    return 'Échec de la suppression du serveur : $error';
  }

  @override
  String failedToDeleteStaticKey(String error) {
    return 'Échec de la suppression de la clé statique : $error';
  }

  @override
  String failedToDisconnect(String name) {
    return 'Échec de la déconnexion de $name';
  }

  @override
  String failedToExportLogs(String error) {
    return 'Échec de l\'exportation des journaux : $error';
  }

  @override
  String failedToGenerateKey(String error) {
    return 'Échec de la génération de la clé : $error';
  }

  @override
  String failedToGenerateToken(String error) {
    return 'Échec de la génération du jeton : $error';
  }

  @override
  String failedToLoadInterfaces(String error) {
    return 'Échec du chargement des interfaces : $error';
  }

  @override
  String get failedToLoadOpenvpnLogs =>
      'Échec du chargement des journaux OpenVPN';

  @override
  String failedToRestartService(String type) {
    return 'Échec du redémarrage du service $type';
  }

  @override
  String get failedToSaveAuthSettings =>
      'Échec de l\'enregistrement des paramètres d\'authentification';

  @override
  String failedToSaveHost(String error) {
    return 'Échec de l\'enregistrement de l\'hôte : $error';
  }

  @override
  String failedToSaveInstance(String error) {
    return 'Échec de l\'enregistrement de l\'instance : $error';
  }

  @override
  String failedToSaveOverride(String error) {
    return 'Échec de l\'enregistrement du remplacement : $error';
  }

  @override
  String get failedToSavePeer => 'Échec de l\'enregistrement du pair';

  @override
  String get failedToSaveProfile => 'Échec de l\'enregistrement du profil';

  @override
  String get failedToSaveServer => 'Échec de l\'enregistrement du serveur';

  @override
  String get failedToSaveSettings =>
      'Échec de l\'enregistrement des paramètres';

  @override
  String failedToSaveStaticKey(String error) {
    return 'Échec de l\'enregistrement de la clé statique : $error';
  }

  @override
  String get failedToStartService => 'Échec du démarrage du service';

  @override
  String get failedToStopService => 'Échec de l\'arrêt du service';

  @override
  String failedToToggleAlias(String error) {
    return 'Échec du basculement de l\'alias : $error';
  }

  @override
  String failedToToggleInstance(String error) {
    return 'Échec du basculement de l\'instance : $error';
  }

  @override
  String failedToToggleOverride(String error) {
    return 'Échec du basculement du remplacement : $error';
  }

  @override
  String failedToTogglePeer(String error) {
    return 'Échec du basculement du pair : $error';
  }

  @override
  String failedToToggleServer(String error) {
    return 'Échec du basculement du serveur : $error';
  }

  @override
  String failedToWakeAllHosts(String error) {
    return 'Échec du réveil de tous les hôtes : $error';
  }

  @override
  String failedToWakeHost(String error) {
    return 'Échec du réveil de l\'hôte : $error';
  }

  @override
  String featureComingSoon(String feature) {
    return '$feature - Bientôt disponible';
  }

  @override
  String get featuresList =>
      '• Surveillance et gestion du système\n• Configuration des règles de pare-feu\n• Contrôle des services\n• Journaux en temps réel\n• Support multi-profils\n• Authentification sécurisée';

  @override
  String get featuresTitle => 'Fonctionnalités';

  @override
  String fieldIsRequired(String fieldName) {
    return '$fieldName est requis';
  }

  @override
  String get fieldRequired => 'Ce champ est requis';

  @override
  String get fifteenMin => '15 min';

  @override
  String get filterByAction => 'Filtrer par Action';

  @override
  String get filterByType => 'Filtrer par type';

  @override
  String get filterLabel => 'Filtre : ';

  @override
  String get filters => 'Filtres';

  @override
  String get filtersLabel => 'Filtres';

  @override
  String get firewall => 'Pare-feu';

  @override
  String get firewallAliases => 'Alias du pare-feu';

  @override
  String get firewallLogs => 'Journaux du Pare-feu';

  @override
  String get firewallRuleDetails => 'Détails de la Règle du Pare-feu';

  @override
  String get firewallRules => 'Règles du Pare-feu';

  @override
  String get firmwareDetails => 'Détails du Firmware';

  @override
  String get fiveMin => '5 min';

  @override
  String get fixFormErrors =>
      'Veuillez corriger les erreurs dans le formulaire';

  @override
  String get forbidden => 'Accès interdit';

  @override
  String get gateway => 'Passerelle';

  @override
  String get gatewayOptional => 'Passerelle (Optionnel)';

  @override
  String get gateways => 'Passerelles';

  @override
  String get general => 'Général';

  @override
  String get generalSettings => 'Paramètres généraux';

  @override
  String get generateKey => 'Générer une Clé';

  @override
  String get generateKeyPair => 'Générer une paire de clés';

  @override
  String get generateNewKeyPair => 'Générer une nouvelle paire de clés';

  @override
  String get generateOrPasteKeyHere => 'Générer ou coller la clé ici';

  @override
  String get generatePresharedKey => 'Générer une clé pré-partagée';

  @override
  String get generated => 'Généré';

  @override
  String get generating => 'Génération en cours...';

  @override
  String get gitCommit => 'Commit Git';

  @override
  String get gnuLicenseText =>
      'Ce programme est un logiciel libre : vous pouvez le redistribuer et/ou le modifier selon les termes de la GNU General Public License publiée par la Free Software Foundation, soit la version 3 de la Licence, soit (à votre choix) toute version ultérieure.\n\nCe programme est distribué dans l\'espoir qu\'il sera utile, mais SANS AUCUNE GARANTIE ; sans même la garantie implicite de QUALITÉ MARCHANDE ou d\'ADÉQUATION À UN USAGE PARTICULIER. Voir la GNU General Public License pour plus de détails.\n\nVous devriez avoir reçu une copie de la GNU General Public License avec ce programme. Si ce n\'est pas le cas, consultez <https://www.gnu.org/licenses/>.\n\nPourquoi GPLv3 ?\n\n• Garantit que le logiciel reste libre et open source\n• Toute modification ou dérivé doit également être open source\n• Les utilisateurs ont la liberté d\'utiliser, d\'étudier, de partager et de modifier le logiciel\n• La communauté bénéficie des améliorations et des contributions';

  @override
  String get gnuLicenseTitle => 'Licence Publique Générale GNU v3.0';

  @override
  String get healthStatus => 'État de Santé';

  @override
  String get hideControls => 'Masquer les Contrôles';

  @override
  String get hideKey => 'Masquer la clé';

  @override
  String get historySize => 'Taille de l\'historique';

  @override
  String get host => 'Hôte';

  @override
  String get hostAddedSuccessfully => 'Hôte ajouté avec succès';

  @override
  String get hostBlocked => 'Hôte bloqué avec succès';

  @override
  String get hostDeletedSuccessfully => 'Hôte supprimé avec succès';

  @override
  String get hostHint => 'par ex., 192.168.1.1 ou firewall.example.com';

  @override
  String get hostIpAddress => 'Hôte / Adresse IP';

  @override
  String get hostIpAddressLabel => 'Hôte/Adresse IP';

  @override
  String get hostIsRequired => 'L\'hôte est requis';

  @override
  String get hostPlaceholder => '192.168.1.1 ou firewall.example.com';

  @override
  String get hostUpdatedSuccessfully => 'Hôte mis à jour avec succès';

  @override
  String get hostname => 'Nom d\'Hôte';

  @override
  String get hour => 'heure';

  @override
  String get hourAbbrev => 'h';

  @override
  String get hours => 'heures';

  @override
  String hoursAgo(String hours) {
    return 'Il y a ${hours}h';
  }

  @override
  String get http => 'http';

  @override
  String get https => 'https';

  @override
  String get id => 'ID';

  @override
  String get import => 'Importer';

  @override
  String get importAndExport => 'Importer et exporter';

  @override
  String get importExport => 'Importer et exporter';

  @override
  String get importExportDescription =>
      'Exportez vos profils pour les sauvegarder ou les transférer vers un autre appareil. Importez des profils depuis un fichier précédemment exporté.\n\nLes profils sont enregistrés au format JSON et peuvent inclure des points de terminaison de connexion et des paramètres.';

  @override
  String importFailed(String error) {
    return 'Échec de l\'importation : $error';
  }

  @override
  String importFailedWithErrors(String errors) {
    return 'Échec de l\'importation : $errors';
  }

  @override
  String get importProfiles => 'Importer les Profils';

  @override
  String get importProfilesDialog =>
      'Comment les profils existants doivent-ils être traités ?\n\n• Conserver les Deux : Importer avec de nouveaux IDs\n• Écraser : Remplacer les profils existants';

  @override
  String get importProfilesSubtitle =>
      'Importer des profils depuis un fichier JSON';

  @override
  String get importProfilesTitle => 'Importer les Profils';

  @override
  String get importSuccess => 'Importation réussie';

  @override
  String importedProfiles(int count) {
    return '$count profil(s) importé(s)';
  }

  @override
  String importedWithFailures(int failed, int success) {
    String _temp0 = intl.Intl.pluralLogic(
      success,
      locale: localeName,
      other: 'profils importés',
      one: 'profil importé',
    );
    return '$success $_temp0, $failed échoué(s)';
  }

  @override
  String inDays(String days) {
    return 'dans ${days}j';
  }

  @override
  String inHours(String hours) {
    return 'dans ${hours}h';
  }

  @override
  String inMinutes(String minutes) {
    return 'dans ${minutes}m';
  }

  @override
  String get inbound => 'Entrant';

  @override
  String get includeCredentials => 'Inclure les Identifiants';

  @override
  String get incorrectPin => 'PIN incorrect';

  @override
  String get info => 'Information';

  @override
  String get instance => 'Instance';

  @override
  String get instanceCreatedSuccessfully => 'Instance créée avec succès';

  @override
  String get instanceDeletedSuccessfully => 'Instance supprimée avec succès';

  @override
  String get instanceDetails => 'Détails de l\'Instance';

  @override
  String instanceToggledSuccessfully(String status) {
    return 'Instance $status avec succès';
  }

  @override
  String get instanceUpdatedSuccessfully => 'Instance mise à jour avec succès';

  @override
  String get instanceWillBeActiveWhenEnabled =>
      'L\'instance sera active lorsqu\'elle est activée';

  @override
  String get instances => 'Instances';

  @override
  String get interface => 'Interface';

  @override
  String interfaceLabel(String interface) {
    return '$interface';
  }

  @override
  String get invalidApiKeyFormat => 'Format de clé API non valide';

  @override
  String get invalidApiSecretFormat => 'Format de secret API non valide';

  @override
  String get invalidBase64Format => 'Format Base64 invalide';

  @override
  String get invalidCidrFormat =>
      'Notation CIDR non valide (utilisez le format : IP/préfixe)';

  @override
  String get invalidCidrNotation => 'Notation CIDR invalide';

  @override
  String get invalidDestinationFormat => 'Format de destination invalide';

  @override
  String invalidFileError(String error) {
    return 'Fichier invalide : $error';
  }

  @override
  String invalidFileFormat(String error) {
    return 'Fichier invalide : $error';
  }

  @override
  String get invalidHostnameOrIp => 'Nom d\'hôte ou adresse IP non valide';

  @override
  String get invalidInput => 'Entrée invalide';

  @override
  String get invalidIpAddress => 'Adresse IP non valide';

  @override
  String get invalidIpAddressFormat =>
      'Format d\'adresse IP non valide (doit être IPv4 ou IPv6)';

  @override
  String get invalidIpv4Address => 'Adresse IPv4 non valide';

  @override
  String get invalidIpv4CidrNotation => 'Notation CIDR IPv4 non valide';

  @override
  String get invalidIpv4Prefix => 'Préfixe IPv4 non valide (doit être 0-32)';

  @override
  String get invalidIpv6Address => 'Adresse IPv6 non valide';

  @override
  String get invalidIpv6CidrNotation => 'Notation CIDR IPv6 non valide';

  @override
  String get invalidIpv6Prefix => 'Préfixe IPv6 non valide (doit être 0-128)';

  @override
  String get invalidPIN => 'PIN invalide';

  @override
  String get invalidPortFormat => 'Format de port invalide';

  @override
  String get invalidPrefixLength => 'Longueur de préfixe non valide';

  @override
  String get invalidSourceFormat => 'Format de source invalide';

  @override
  String get ipAddress => 'Adresse IP';

  @override
  String get ipAddresses => 'Adresses IP';

  @override
  String get ipv4CidrHint => '10.8.0.0/24';

  @override
  String get ipv4OrIpv6CidrHint => '10.8.0.0/24 ou fd00::/64';

  @override
  String get ipv4TunnelNetwork => 'Réseau du Tunnel IPv4';

  @override
  String get ipv4TunnelNetworkHint => '10.8.0.0/24';

  @override
  String get ipv6CidrHint => 'fd00::/64';

  @override
  String get ipv6TunnelNetwork => 'Réseau du Tunnel IPv6';

  @override
  String get ipv6TunnelNetworkHint => 'fd00::/64';

  @override
  String get iscDhcpDescription =>
      'Serveur DHCP d\'Internet Systems Consortium';

  @override
  String get iscDhcpServerName => 'ISC DHCP';

  @override
  String itemsCount(int count) {
    return '$count élément(s)';
  }

  @override
  String get justNow => 'À l\'instant';

  @override
  String get keaDhcpDescription => 'Serveur DHCP moderne et performant';

  @override
  String get keaDhcpServerName => 'Kea DHCP';

  @override
  String get keepAliveIntervalOptional =>
      'Intervalle de maintien en vie (Optionnel)';

  @override
  String get keepBoth => 'Conserver les Deux';

  @override
  String get keepalive => 'Maintien en vie';

  @override
  String get keepaliveOptional => 'Maintien en vie (Optionnel)';

  @override
  String get key => 'Clé';

  @override
  String get keyCopiedToClipboard => 'Clé copiée dans le presse-papiers';

  @override
  String get keyGeneratedSuccessfully => 'Clé générée avec succès';

  @override
  String keyLabel(String id) {
    return 'Clé :';
  }

  @override
  String keyWithId(String id) {
    return 'Clé $id';
  }

  @override
  String get keysGeneratedSuccessfully => 'Clés générées avec succès';

  @override
  String get keysRequired => 'Les clés privées et publiques sont requises';

  @override
  String get label => 'Étiquette';

  @override
  String get labelHint => 'par ex., Réseau domestique, VPN de bureau';

  @override
  String get labelOptional => 'Étiquette (Optionnel)';

  @override
  String get language => 'Langue';

  @override
  String get lastDay => 'Dernier Jour';

  @override
  String get lastDayShort => '1 jour';

  @override
  String get lastMonth => 'Dernier Mois';

  @override
  String get lastMonthShort => '1 mois';

  @override
  String get lastUpdate => 'Dernière Mise à Jour';

  @override
  String lastUsed(String date) {
    return 'Dernière utilisation : $date';
  }

  @override
  String get lastWeek => 'Dernière Semaine';

  @override
  String get lastWeekShort => '1 semaine';

  @override
  String leasesCount(int filtered, int total) {
    return '$filtered sur $total bail/baux';
  }

  @override
  String get leaveEmptyOrGenerate => 'Laisser vide ou générer';

  @override
  String get licenses => 'Licences';

  @override
  String get lightMode => 'Mode Clair';

  @override
  String get limit => 'Limite';

  @override
  String get live => 'En direct';

  @override
  String get liveNetworkMonitor => 'Moniteur Réseau en Direct';

  @override
  String get neighborDiscovery => 'Découverte des Voisins';

  @override
  String get loading => 'Chargement...';

  @override
  String get loadingHostData => 'Chargement des données de l\'hôte...';

  @override
  String get loadingSettings => 'Chargement des paramètres...';

  @override
  String get localAddress => 'Adresse Locale';

  @override
  String get localNetwork => 'Réseau Local';

  @override
  String get localNetworkHelperText =>
      'Ce sont les réseaux accessibles par le client, ils sont poussés via des clauses route(-ipv6) dans OpenVPN au client.';

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
  String get lockApp => 'Verrouiller l\'Application';

  @override
  String get lockTimeoutLabel => 'Délai de Verrouillage';

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
  String get logDetails => 'Détails du journal';

  @override
  String logEntriesCopied(int count, String entries) {
    return '$count $entries de journal copiées';
  }

  @override
  String get logEntryCopied => 'Entrée de journal copiée';

  @override
  String get logEntryDetails => 'Détails de l\'Entrée de Journal';

  @override
  String get logFile => 'Fichier journal';

  @override
  String get logLimit => 'Limite de Journaux';

  @override
  String get login => 'Connexion';

  @override
  String get loginServer => 'Serveur de Connexion';

  @override
  String get loginServerHelperText =>
      'L\'URL du serveur de connexion Tailscale';

  @override
  String get loginServerRequired => 'Le serveur de connexion est requis';

  @override
  String get logout => 'Déconnexion';

  @override
  String get logs => 'Journaux';

  @override
  String get logsExportedSuccessfully => 'Journaux exportés avec succès';

  @override
  String get logsMatchingFiltersWillAppearHere =>
      'Les journaux correspondant aux filtres apparaîtront ici';

  @override
  String get logsWillAppear =>
      'Les journaux apparaîtront ici au fur et à mesure de leur génération';

  @override
  String get macAddress => 'Adresse MAC';

  @override
  String get macAddressHint => 'par ex., 00:11:22:33:44:55';

  @override
  String get macAddressIsRequired => 'L\'adresse MAC est requise';

  @override
  String get invalidMacAddressFormat =>
      'Format d\'adresse MAC invalide (ex. AA:BB:CC:DD:EE:FF)';

  @override
  String get magicDns => 'Magic DNS';

  @override
  String get manageProfiles => 'Gérer les profils';

  @override
  String get manageSubnets => 'Gérer les Sous-réseaux';

  @override
  String get manageWireguard => 'Gérer WireGuard';

  @override
  String get manufacturer => 'Fabricant';

  @override
  String get maximumTransmissionUnit =>
      'Unité de transmission maximale (576-9000)';

  @override
  String get memoryUsage => 'Utilisation Mémoire';

  @override
  String get minute => 'minute';

  @override
  String get minuteAbbrev => 'm';

  @override
  String get minutes => 'minutes';

  @override
  String minutesAgo(String minutes) {
    return 'Il y a ${minutes}m';
  }

  @override
  String get mode => 'Mode';

  @override
  String get modified => 'Modifié';

  @override
  String get monitorInterface => 'Interface de Surveillance';

  @override
  String get mssFix => 'Correction MSS';

  @override
  String get mssFixDescription =>
      'Activer la correction MSS pour cette connexion';

  @override
  String get mtuOptional => 'MTU (Optionnel)';

  @override
  String get mustBeValidUrl =>
      'Doit être une URL valide commençant par http:// ou https://';

  @override
  String get myOPNsenseRouter => 'Mon Routeur OPNsense';

  @override
  String get myOpenvpnInstance => 'Mon instance OpenVPN';

  @override
  String get myStaticKey => 'Ma Clé Statique';

  @override
  String get myWireguardPeer => 'Mon pair WireGuard';

  @override
  String get myWireguardServer => 'Mon serveur WireGuard';

  @override
  String get name => 'Nom';

  @override
  String get needHelpCheckDocumentation =>
      'Besoin d\'aide ? Consultez la documentation OPNsense pour la génération de clés API.';

  @override
  String get networkConfiguration => 'Configuration Réseau';

  @override
  String get networkError => 'Une erreur réseau s\'est produite';

  @override
  String get networkInformation => 'Informations réseau';

  @override
  String get networkTotals => 'Totaux Réseau';

  @override
  String get newPin => 'Nouveau PIN (4-6 chiffres)';

  @override
  String get newPinMustBeDifferent =>
      'Le nouveau PIN doit être différent de l\'actuel';

  @override
  String get newRule => 'Nouvelle Règle';

  @override
  String get newWireguardPeer => 'Nouveau pair WireGuard';

  @override
  String get newWireguardServer => 'Nouveau serveur WireGuard';

  @override
  String get next => 'Suivant';

  @override
  String get nextButton => 'Suivant';

  @override
  String get no => 'Non';

  @override
  String get noAliasesConfigured => 'Aucun alias configuré';

  @override
  String get noAliasesMatchFilters =>
      'Aucun alias ne correspond aux filtres actuels';

  @override
  String get noAutomationRulesFound => 'Aucune règle d\'automatisation trouvée';

  @override
  String get noClientSpecificOverridesConfigured =>
      'Aucune substitution spécifique au client configurée';

  @override
  String noConnectionsFound(String type) {
    return 'Aucune connexion $type trouvée';
  }

  @override
  String get noData => 'Aucune donnée disponible';

  @override
  String get noDataAvailable => 'Aucune donnée disponible';

  @override
  String get noDescription => 'Aucune Description';

  @override
  String get noDnsDomainSearchEntriesConfigured =>
      'Aucune entrée de recherche de domaine DNS configurée';

  @override
  String get noDnsDomainsConfigured => 'Aucun domaine DNS configuré';

  @override
  String get noDnsServersConfigured => 'Aucun serveur DNS configuré';

  @override
  String get noHostsFound => 'Aucun hôte trouvé';

  @override
  String get noInstancesMatchFilters =>
      'Aucune instance ne correspond aux filtres';

  @override
  String get noInterfacesWithAutomationRules =>
      'Aucune interface avec des règles d\'automatisation';

  @override
  String get noItemsConfigured => 'Aucun élément configuré';

  @override
  String get noLeasesFound => 'Aucun bail trouvé';

  @override
  String get noLimit => 'Sans Limite';

  @override
  String get noLimitShort => 'Tous';

  @override
  String get noLocalNetworksConfigured => 'Aucun réseau local configuré';

  @override
  String get noLogEntriesFound => 'Aucune entrée de journal trouvée';

  @override
  String get noLogsAvailable => 'Aucun journal disponible';

  @override
  String get noLogsToExport => 'Aucun journal à exporter';

  @override
  String get noNtpServersConfigured => 'Aucun serveur NTP configuré';

  @override
  String get noOpenvpnInstancesConfigured =>
      'Aucune instance OpenVPN configurée';

  @override
  String get noOpenvpnRoutesConfigured => 'Aucune route OpenVPN configurée';

  @override
  String get noOpenvpnSessionsConfigured => 'Aucune session OpenVPN configurée';

  @override
  String get noOptionsAvailable => 'Aucune option disponible';

  @override
  String get noOverridesMatchFilter =>
      'Aucune substitution ne correspond au filtre';

  @override
  String get noPeersAvailable => 'Aucun pair disponible';

  @override
  String get noPeersMatchSearch => 'Aucun pair ne correspond à votre recherche';

  @override
  String get noProfiles => 'Aucun Profil';

  @override
  String get noProfilesFound => 'Aucun profil trouvé';

  @override
  String get noProfilesYet => 'Aucun Profil Pour le Moment';

  @override
  String get noRemoteNetworksConfigured => 'Aucun réseau distant configuré';

  @override
  String get noRoutesConfigured => 'Aucune route configurée';

  @override
  String noRulesForInterface(String interface) {
    return 'Aucune règle pour $interface';
  }

  @override
  String get noServersAvailable => 'Aucun serveur disponible';

  @override
  String get noServersMatchSearch =>
      'Aucun serveur ne correspond à votre recherche';

  @override
  String get noServersSelected => 'Aucun serveur sélectionné';

  @override
  String get noSessionsFound => 'Aucune session trouvée';

  @override
  String get noSettingsAvailable => 'Aucun paramètre disponible';

  @override
  String get noStaticKeysConfigured => 'Aucune clé statique configurée';

  @override
  String get noSubnetsConfigured => 'Aucun sous-réseau configuré';

  @override
  String get noTunnelAddressesConfigured =>
      'Aucune adresse de tunnel configurée';

  @override
  String get noVPNConnectionsFound => 'Aucune connexion VPN trouvée';

  @override
  String get noWinsServersConfigured => 'Aucun serveur WINS configuré';

  @override
  String get noWireguardPeersConfigured => 'Aucun pair WireGuard configuré';

  @override
  String get noWireguardServersConfigured =>
      'Aucun serveur WireGuard configuré';

  @override
  String get noWireguardStatusDataAvailable =>
      'Aucune donnée d\'état WireGuard disponible';

  @override
  String get noWolHostsConfigured => 'Aucun hôte Wake on LAN configuré';

  @override
  String get none => 'Aucun';

  @override
  String get notAvailable => 'N/D';

  @override
  String get notFound => 'Ressource non trouvée';

  @override
  String get notice => 'Avis';

  @override
  String get ntpServers => 'Serveurs NTP';

  @override
  String get ntpServersHelperText =>
      'Définir l\'adresse du serveur NTP principal (Network Time Protocol). Répétez cette option pour définir les adresses des serveurs NTP secondaires.';

  @override
  String get of1Gbps => 'sur 1 Gbps';

  @override
  String get offline => 'Hors Ligne';

  @override
  String get ok => 'OK';

  @override
  String get oneHour => '1 heure';

  @override
  String get oneMin => '1 min';

  @override
  String get online => 'En Ligne';

  @override
  String get openvpn => 'OpenVPN';

  @override
  String get openvpnConnectionStatus => 'État de connexion OpenVPN';

  @override
  String get openvpnInstances => 'Instances OpenVPN';

  @override
  String get openvpnLogFile => 'Fichier Journal OpenVPN';

  @override
  String get optional => 'Optionnel';

  @override
  String get optionalBase64EncodedPresharedKey =>
      'Clé pré-partagée encodée en Base64 optionnelle';

  @override
  String get outbound => 'Sortant';

  @override
  String get overrideCreatedSuccessfully => 'Remplacement créé avec succès';

  @override
  String get overrideDeletedSuccessfully => 'Remplacement supprimé avec succès';

  @override
  String get overrideDetails => 'Détails de la Substitution';

  @override
  String overrideToggledSuccessfully(String status) {
    return 'Substitution $status avec succès';
  }

  @override
  String get overrideUpdatedSuccessfully =>
      'Remplacement mis à jour avec succès';

  @override
  String get overwrite => 'Écraser';

  @override
  String get packageMirror => 'Miroir de Paquets';

  @override
  String get packetLength => 'Longueur du paquet';

  @override
  String pageOfPages(String current, String total) {
    return 'Page $current sur $total';
  }

  @override
  String get pass => 'Autoriser';

  @override
  String get pause => 'Pause';

  @override
  String get pauseLiveViewToSelect =>
      'Mettez en pause la vue en direct pour sélectionner les entrées de journal';

  @override
  String get paused => 'En pause';

  @override
  String get peerActiveWhenEnabled =>
      'Le pair sera actif lorsqu\'il sera activé';

  @override
  String get peerCreatedReadyForNext =>
      'Pair créé avec succès. Prêt pour le prochain pair.';

  @override
  String get peerCreatedSuccessfully => 'Pair créé avec succès';

  @override
  String get peerDeletedSuccessfully => 'Pair supprimé avec succès';

  @override
  String get peerDisabledSuccessfully => 'Pair désactivé avec succès';

  @override
  String get peerEnabledSuccessfully => 'Pair activé avec succès';

  @override
  String get peerGenerator => 'Générateur de pairs';

  @override
  String get peerUpdatedSuccessfully => 'Pair mis à jour avec succès';

  @override
  String get peerWillBeActiveWhenEnabled =>
      'Le pair sera actif lorsqu\'il sera activé';

  @override
  String get peers => 'Pairs';

  @override
  String peersConfigured(int count) {
    return '$count pair(s) configuré(s)';
  }

  @override
  String get peersCount => 'Nombre de Pairs';

  @override
  String peersSelected(int count) {
    return '$count pair(s) sélectionné(s)';
  }

  @override
  String get persistentKeepaliveSeconds =>
      'Maintien en vie persistant en secondes (recommandé : 25)';

  @override
  String get pinChangedSuccessfully => 'PIN modifié avec succès';

  @override
  String get pinLock => 'Verrouillage PIN';

  @override
  String get pinLockDisabled =>
      'Verrouillage PIN désactivé. Verrouillage biométrique également désactivé.';

  @override
  String get pinLockEnabled => 'Verrouillage PIN activé';

  @override
  String get pinLockTitle => 'Verrouillage PIN';

  @override
  String get pinMismatch => 'Les PIN ne correspondent pas';

  @override
  String get pinMustContainOnlyNumbers =>
      'Le PIN ne doit contenir que des chiffres';

  @override
  String get pinTooShort => 'Le PIN doit contenir au moins 4 chiffres';

  @override
  String get platform => 'Plateforme';

  @override
  String get pleaseAddConnectionEndpoint =>
      'Veuillez ajouter au moins un point de terminaison de connexion';

  @override
  String get pleaseEnterCurrentPin => 'Veuillez entrer votre PIN actuel';

  @override
  String get pleaseEnterNewPin => 'Veuillez entrer un nouveau PIN';

  @override
  String get pleaseEnterSubnet => 'Veuillez entrer un sous-réseau';

  @override
  String get pleaseEnterYourPin => 'Veuillez entrer votre PIN';

  @override
  String get pleaseSelectAnInstance => 'Veuillez sélectionner une instance';

  @override
  String get pleaseSelectInterface => 'Veuillez sélectionner une interface';

  @override
  String get port => 'Port';

  @override
  String get portHint => 'par ex., 443';

  @override
  String get portIsRequired => 'Le port est requis';

  @override
  String portLabel(String port) {
    return 'Port : $port';
  }

  @override
  String get portMustBeBetween => 'Le port doit être entre 1 et 65535';

  @override
  String get portPlaceholder => '443';

  @override
  String get preAuthKey => 'Clé de Pré-Authentification';

  @override
  String get preAuthKeyHelperText =>
      'Optionnel : Clé de pré-authentification pour l\'enregistrement automatique des appareils';

  @override
  String get presharedKeyGeneratedSuccessfully =>
      'Clé pré-partagée générée avec succès';

  @override
  String get presharedKeyOptional => 'Clé pré-partagée (Optionnel)';

  @override
  String get preventAutomaticRouteInstallation =>
      'Empêcher l\'installation automatique des routes';

  @override
  String get previous => 'Précédent';

  @override
  String get previousButton => 'Précédent';

  @override
  String get privateKey => 'Clé privée';

  @override
  String get profileActivated => 'Profil activé avec succès';

  @override
  String get profileAdded => 'Profil ajouté';

  @override
  String get profileDeleted => 'Profil supprimé avec succès';

  @override
  String get profileHasNoEndpoints =>
      'Le profil n\'a pas de points de terminaison de connexion configurés';

  @override
  String get profileName => 'Nom du Profil';

  @override
  String get profileNameLabel => 'Nom du Profil';

  @override
  String get profileNameOptional => 'Nom du Profil (Optionnel)';

  @override
  String get profileNameRequired => 'Le nom du profil est requis';

  @override
  String get profileSaved => 'Profil enregistré avec succès';

  @override
  String get profileUpdated => 'Profil mis à jour';

  @override
  String get profiles => 'Profils';

  @override
  String profilesExportedSuccessfully(String path) {
    return 'Profils exportés avec succès !\n$path';
  }

  @override
  String get protocol => 'Protocole';

  @override
  String get protocolAh => 'AH';

  @override
  String get protocolEsp => 'ESP';

  @override
  String get protocolGre => 'GRE';

  @override
  String get protocolIcmp => 'ICMP';

  @override
  String get protocolIcmpv6 => 'ICMPv6';

  @override
  String get protocolIgmp => 'IGMP';

  @override
  String get protocolIpv6 => 'IPv6';

  @override
  String get protocolOspf => 'OSPF';

  @override
  String get protocolPim => 'PIM';

  @override
  String get protocolTcp => 'TCP';

  @override
  String get protocolTcpUdp => 'TCP/UDP';

  @override
  String get protocolUdp => 'UDP';

  @override
  String get publicKey => 'Clé publique';

  @override
  String get publicKeyColon => 'Clé publique :';

  @override
  String get publicKeyRequired => 'La clé publique est requise';

  @override
  String publicKeyShort(String key) {
    return '$key...';
  }

  @override
  String get pushReset => 'Réinitialisation push';

  @override
  String get pushResetSubtitle =>
      'N\'héritez pas de la liste push globale pour une instance client spécifique. REMARQUE : --push-reset est très complet : il supprimera presque toutes les options de la liste des options à pousser. Dans de nombreux cas, certaines de ces options devront être reconfigurées par la suite - en particulier, --topology subnet et --route-gateway seront perdus et cela cassera les configurations client dans de nombreux cas.';

  @override
  String get pushVirtualIpEndpoints =>
      'Pousser les points de terminaison IP virtuels pour le tunnel client, en remplaçant l\'allocation dynamique.';

  @override
  String get qrCode => 'Code QR';

  @override
  String get reason => 'Raison';

  @override
  String get rebootConfirmation =>
      'Êtes-vous sûr de vouloir redémarrer le système ?';

  @override
  String get rebootFailed => 'Échec du redémarrage du système';

  @override
  String rebootFailedWithError(String message, String error) {
    return '$message: $error';
  }

  @override
  String get rebootSuccess => 'Redémarrage du système initié';

  @override
  String get rebootSystem => 'Redémarrer le Système';

  @override
  String get received => 'Reçu';

  @override
  String get recommendedForSecureConnections =>
      'Recommandé pour les connexions sécurisées';

  @override
  String get redirectGateway => 'Rediriger la passerelle';

  @override
  String get redirectGatewayHelperText =>
      'Exécuter automatiquement les commandes de routage pour rediriger tout le trafic IP sortant via le VPN.';

  @override
  String get refresh => 'Actualiser';

  @override
  String get refreshTooltip => 'Actualiser';

  @override
  String get registerDns => 'Enregistrer DNS';

  @override
  String get registerDnsSubtitle =>
      'Exécuter ipconfig /flushdns et ipconfig /registerdns lors de l\'initiation de la connexion. Cela est connu pour inciter Windows à reconnaître les serveurs DNS poussés.';

  @override
  String get reject => 'Rejeter';

  @override
  String get remoteAddress => 'Adresse Distante';

  @override
  String get remoteNetwork => 'Réseau Distant';

  @override
  String get remoteNetworkHelperText =>
      'Réseaux distants pour le serveur, ils sont configurés via des clauses iroute(-ipv6) dans OpenVPN et informent le serveur d\'envoyer ces réseaux à ce client spécifique.';

  @override
  String get repository => 'Dépôt';

  @override
  String get requirePinToUnlock =>
      'Nécessite un PIN pour déverrouiller l\'application';

  @override
  String get required => 'Requis';

  @override
  String get restart => 'Redémarrer';

  @override
  String get restartButton => 'Redémarrer';

  @override
  String get restartService => 'Redémarrer le Service';

  @override
  String restartServiceConfirmation(String type) {
    return 'Êtes-vous sûr de vouloir redémarrer le service $type?\n\nCela déconnectera temporairement toutes les connexions actives.';
  }

  @override
  String get restartVPNService => 'Redémarrer le service VPN';

  @override
  String restartingService(String type) {
    return 'Redémarrage du service $type...';
  }

  @override
  String get resume => 'Reprendre';

  @override
  String get retry => 'Réessayer';

  @override
  String get retryButton => 'Réessayer';

  @override
  String get role => 'Rôle';

  @override
  String get routeGateway => 'Passerelle de route';

  @override
  String get routeGatewayHelperText =>
      'Spécifiez une passerelle par défaut à utiliser pour le client connecté. Sans une définie, la première adresse du bloc réseau est proposée. Lors de la segmentation du réseau tunnel (serveur), celle-ci peut ne pas être accessible depuis le client.';

  @override
  String get routeGatewayHint => '10.8.0.1';

  @override
  String get routes => 'Routes';

  @override
  String get routing => 'Routage';

  @override
  String get rowsPerPage => 'Lignes par page';

  @override
  String get rowsPerPageDropdown => 'Lignes par page';

  @override
  String get rowsPerPageLabel => 'Lignes par page : ';

  @override
  String get ruleActionFailed => 'Action de règle échouée';

  @override
  String get ruleCreated => 'Règle créée avec succès';

  @override
  String get ruleDeleted => 'Règle supprimée avec succès';

  @override
  String get ruleDescription => 'Description de la règle';

  @override
  String get ruleDetails => 'Détails de la règle';

  @override
  String get ruleDisabledSuccessfully => 'Règle désactivée avec succès';

  @override
  String get ruleEnabledSuccessfully => 'Règle activée avec succès';

  @override
  String get ruleGuidelines => 'Directives des Règles';

  @override
  String get ruleGuidelinesText =>
      '• Utilisez \"any\" pour correspondre à toutes les adresses ou ports\n• Notation CIDR : 192.168.1.0/24\n• Plages de ports : 80-443\n• Les règles sont traitées dans l\'ordre séquentiel\n• Les modifications sont appliquées immédiatement';

  @override
  String get ruleId => 'ID de règle';

  @override
  String get ruleInformation => 'Informations sur la règle';

  @override
  String get ruleUpdated => 'Règle mise à jour avec succès';

  @override
  String get ruleWillBeActiveWhenEnabled =>
      'La règle sera active lorsqu\'elle est activée';

  @override
  String get running => 'En Cours';

  @override
  String get runningStatus => 'En Cours';

  @override
  String get save => 'Enregistrer';

  @override
  String get saveAndConnect => 'Enregistrer et connecter';

  @override
  String get saveSettings => 'Enregistrer les Paramètres';

  @override
  String get saveTooltip => 'Enregistrer';

  @override
  String get saveWithoutTesting => 'Enregistrer sans tester';

  @override
  String get saving => 'Enregistrement...';

  @override
  String get savingOverride => 'Enregistrement de la substitution...';

  @override
  String get savingProfile => 'Enregistrement du profil...';

  @override
  String get searchAliases => 'Rechercher des alias...';

  @override
  String get searchHostnameIpOrMac => 'Rechercher nom d\'hôte, IP ou MAC...';

  @override
  String get searchHostnameOrIp => 'Rechercher nom d\'hôte ou adresse IP...';

  @override
  String get searchInstances => 'Rechercher des instances...';

  @override
  String get searchOverrides => 'Rechercher des substitutions...';

  @override
  String get searchPeers => 'Rechercher des pairs...';

  @override
  String get searchServers => 'Rechercher des serveurs...';

  @override
  String get second => 'seconde';

  @override
  String get secondAbbrev => 's';

  @override
  String get seconds => 'Secondes';

  @override
  String get security => 'Sécurité';

  @override
  String get securityWarning => 'Avertissement de sécurité';

  @override
  String get selectAProfileOrCreateNewOne =>
      'Sélectionnez un profil ou créez-en un nouveau';

  @override
  String get selectAll => 'Tout sélectionner';

  @override
  String get selectExitNode => 'Sélectionner le nœud de sortie';

  @override
  String get selectInterface => 'Sélectionner l\'interface';

  @override
  String get selectInterfaceToViewRules =>
      'Sélectionnez une interface pour afficher les règles';

  @override
  String get selectKeyModeForAuthOrEncryption =>
      'Sélectionnez le mode de clé pour l\'authentification ou le chiffrement';

  @override
  String selectLabel(String label) {
    return 'Sélectionner $label';
  }

  @override
  String get selectMultipleInterfaces =>
      'Sélectionnez une ou plusieurs interfaces à surveiller';

  @override
  String get selectNumberOfEntries =>
      'Sélectionnez le nombre d\'entrées de journal à afficher:';

  @override
  String get selectPeers => 'Sélectionner les Pairs';

  @override
  String get selectServerAndGenerateKeys =>
      '# Sélectionnez un serveur et générez des clés pour prévisualiser la configuration';

  @override
  String get selectServerForQrCode =>
      'Sélectionner le serveur pour générer le code QR';

  @override
  String get selectServerInstance =>
      'Veuillez sélectionner une instance de serveur';

  @override
  String get selectServerToGenerateQrCode =>
      'Sélectionnez le serveur pour générer le code QR';

  @override
  String get selectServers => 'Sélectionner les Serveurs';

  @override
  String get selectServersHelperText =>
      'Sélectionnez les serveurs OpenVPN auxquels cette substitution s\'applique, laissez vide pour tous';

  @override
  String get selectServersTitle => 'Sélectionner les serveurs';

  @override
  String get selectVhid => 'Sélectionner VHID';

  @override
  String get selected => 'sélectionné';

  @override
  String get selfSignedCertWarning =>
      'Avertissement : Les certificats auto-signés sont moins sécurisés. N\'activez ceci que si vous faites confiance au serveur.';

  @override
  String get selfSignedCertificatesWarning =>
      'N\'activez ceci que si vous faites confiance au serveur';

  @override
  String get sent => 'Envoyé';

  @override
  String get sequence => 'Séquence';

  @override
  String get server => 'Serveur';

  @override
  String get serverActiveWhenEnabled =>
      'Le serveur sera actif lorsqu\'il sera activé';

  @override
  String get serverAddress => 'Adresse du serveur';

  @override
  String get serverCreatedSuccessfully => 'Serveur créé avec succès';

  @override
  String get serverDeletedSuccessfully => 'Serveur supprimé avec succès';

  @override
  String get serverDisabledSuccessfully => 'Serveur désactivé avec succès';

  @override
  String get serverEnabledSuccessfully => 'Serveur activé avec succès';

  @override
  String get serverError => 'Une erreur serveur s\'est produite';

  @override
  String get serverInfoNotLoaded => 'Informations du serveur non chargées';

  @override
  String get serverNetwork => 'Réseau du Serveur';

  @override
  String get serverPort => 'Port du serveur';

  @override
  String get serverSelectionRequired =>
      'Au moins un serveur doit être sélectionné';

  @override
  String get serverUpdatedSuccessfully => 'Serveur mis à jour avec succès';

  @override
  String get serverWillBeActiveWhenEnabled =>
      'Le serveur sera actif lorsqu\'il sera activé';

  @override
  String get servers => 'Serveurs';

  @override
  String get serversLabel => 'Serveurs';

  @override
  String serversSelected(int count) {
    return '$count serveur(s) sélectionné(s)';
  }

  @override
  String get serviceActionFailed => 'Action du service échouée';

  @override
  String get serviceControls => 'Contrôles de Service';

  @override
  String get serviceRestarted => 'Service redémarré avec succès';

  @override
  String get serviceRestartedSuccessfully => 'Service redémarré avec succès';

  @override
  String get serviceRunning => 'Service en Cours';

  @override
  String get serviceStarted => 'Service démarré avec succès';

  @override
  String get serviceStartedSuccessfully => 'Service démarré avec succès';

  @override
  String get serviceStatus => 'État du Service';

  @override
  String get serviceStopped => 'Service arrêté avec succès';

  @override
  String get serviceStoppedSuccessfully => 'Service arrêté avec succès';

  @override
  String get services => 'Services';

  @override
  String get sessionTimeout => 'Délai d\'Expiration de Session';

  @override
  String get sessions => 'Sessions';

  @override
  String get setAsActive => 'Définir comme actif';

  @override
  String get setPin => 'Définir le PIN';

  @override
  String get settings => 'Paramètres';

  @override
  String severitiesAndTimeFilter(int count, String timeFilter) {
    return '$count sévérités • $timeFilter';
  }

  @override
  String get severity => 'Gravité';

  @override
  String get severityAlert => 'Alerte';

  @override
  String get severityCritical => 'Critique';

  @override
  String get severityDebug => 'Débogage';

  @override
  String get severityEmergency => 'Urgence';

  @override
  String get severityEmergencyShort => 'Urg';

  @override
  String get severityError => 'Erreur';

  @override
  String get severityInformational => 'Informatif';

  @override
  String get severityInformationalShort => 'Info';

  @override
  String get severityNotice => 'Avis';

  @override
  String get severityWarning => 'Avertissement';

  @override
  String get showAdvancedSettings => 'Afficher les Paramètres Avancés';

  @override
  String get showAll => 'Tout Afficher';

  @override
  String get showKey => 'Afficher la clé';

  @override
  String showingEntriesCount(String start, String end) {
    return 'Affichage de $start à $end';
  }

  @override
  String showingInstancesCount(String count, String total) {
    return 'Affichage de $count sur $total';
  }

  @override
  String get showingZeroEntries => 'Affichage de 0 entrées';

  @override
  String get someConnectionsFailed => 'Certaines connexions ont échoué';

  @override
  String get soon => 'bientôt';

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
  String get source => 'Source';

  @override
  String get sourceAddress => 'Adresse source';

  @override
  String get sourceIsRequired => 'La source est obligatoire';

  @override
  String get sourcePort => 'Port Source';

  @override
  String get sourcePortOptional => 'Port Source (Optionnel)';

  @override
  String get sshEnabled => 'SSH Activé';

  @override
  String get start => 'Démarrer';

  @override
  String get startButton => 'Démarrer';

  @override
  String get startService => 'Démarrer le Service';

  @override
  String get startTime => 'Heure de début';

  @override
  String get startWireguardService => 'Démarrer le service WireGuard';

  @override
  String get staticKeyContentPemFormat =>
      'Contenu de clé statique au format PEM';

  @override
  String get staticKeyCreatedSuccessfully => 'Clé statique créée avec succès';

  @override
  String get staticKeyDeletedSuccessfully =>
      'Clé statique supprimée avec succès';

  @override
  String get staticKeyDetails => 'Détails de la Clé Statique';

  @override
  String get staticKeyInfoHelp =>
      '• Auth : Ajoute l\'authentification HMAC au canal de contrôle\n• Crypt : Chiffre et authentifie tous les paquets du canal de contrôle\n• Crypt V2 : Chiffrement amélioré avec sécurité renforcée\n\nVous pouvez générer une nouvelle clé ou coller une clé existante.';

  @override
  String get staticKeyInformation => 'Informations sur la Clé Statique';

  @override
  String get staticKeyUpdatedSuccessfully =>
      'Clé statique mise à jour avec succès';

  @override
  String get staticKeys => 'Clés Statiques';

  @override
  String get staticLease => 'Statique';

  @override
  String get status => 'Statut';

  @override
  String get stop => 'Arrêter';

  @override
  String get stopButton => 'Arrêter';

  @override
  String get stopService => 'Arrêter le Service';

  @override
  String get stopped => 'Arrêté';

  @override
  String get stoppedStatus => 'Arrêté';

  @override
  String get storeAndGenerateNext => 'Enregistrer et générer le suivant';

  @override
  String get subnetAddedSuccessfully => 'Sous-réseau ajouté avec succès';

  @override
  String get subnetCidr => 'Sous-réseau (CIDR)';

  @override
  String get subnetDeletedSuccessfully => 'Sous-réseau supprimé avec succès';

  @override
  String get subnetUpdatedSuccessfully => 'Sous-réseau mis à jour avec succès';

  @override
  String get success => 'Succès';

  @override
  String successfullyConnected(String name) {
    return 'Connecté avec succès à $name';
  }

  @override
  String successfullyDisconnected(String name) {
    return 'Déconnecté avec succès de $name';
  }

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
  String successfullyRestartedService(String type) {
    return 'Service $type redémarré avec succès';
  }

  @override
  String successfullyWokenDevices(
    int successCount,
    int totalCount,
    String plural,
  ) {
    return '$successCount appareil(s) réveillé(s) avec succès sur $totalCount';
  }

  @override
  String get switchProfile => 'Changer de Profil';

  @override
  String get switchProfileConfirmation =>
      'Êtes-vous sûr de vouloir changer de profil ? Vous serez redirigé vers l\'écran de sélection de profil.';

  @override
  String get systemDefault => 'Par Défaut du Système';

  @override
  String get systemGeneratedRule =>
      'Il s\'agit d\'une règle générée par le système et ne peut pas être modifiée ou supprimée.';

  @override
  String get systemGeneratedRulesCannotBeDeleted =>
      'Les règles générées par le système ne peuvent pas être supprimées';

  @override
  String get systemGeneratedRulesCannotBeModified =>
      'Les règles générées par le système ne peuvent pas être modifiées';

  @override
  String get systemInfo => 'Informations Système';

  @override
  String get systemInformation => 'Informations Système';

  @override
  String get systemType => 'Type de Système';

  @override
  String get tags => 'Étiquettes';

  @override
  String get tailscale => 'Tailscale';

  @override
  String get tailscaleAuthentication => 'Authentification Tailscale';

  @override
  String tailscaleServiceAction(String action) {
    return '$action le Service Tailscale';
  }

  @override
  String tailscaleServiceActionConfirmation(String action) {
    return 'Êtes-vous sûr de vouloir $action le service Tailscale ?';
  }

  @override
  String tailscaleServiceActionSuccess(String action) {
    return 'Service Tailscale $action avec succès';
  }

  @override
  String tailscaleServiceActioning(String action) {
    return '$action du service Tailscale en cours...';
  }

  @override
  String get tailscaleSettings => 'Paramètres Tailscale';

  @override
  String get tailscaleStatus => 'État de Tailscale';

  @override
  String get tailscaleSubnets => 'Sous-réseaux Tailscale';

  @override
  String get tailscaleVersion => 'Version';

  @override
  String get tapPlusButtonToCreateFirstInstance =>
      'Appuyez sur le bouton + pour créer votre première instance';

  @override
  String get tapPlusButtonToCreateFirstOverride =>
      'Appuyez sur le bouton + pour créer votre première substitution';

  @override
  String get tapPlusButtonToCreateFirstStaticKey =>
      'Appuyez sur le bouton + pour créer votre première clé statique';

  @override
  String get tcpFlags => 'Drapeaux TCP';

  @override
  String get tenMin => '10 min';

  @override
  String get testConnection => 'Tester la Connexion';

  @override
  String get testConnections => 'Tester les connexions';

  @override
  String get testProfile => 'Tester le profil';

  @override
  String get testingAllConnections => 'Test de tous les points de connexion...';

  @override
  String testingConnection(String current, String total, String endpoint) {
    return 'Test de connexion $current sur $total: $endpoint';
  }

  @override
  String get theme => 'Thème';

  @override
  String get thirtyMin => '30 min';

  @override
  String get time => 'Temps';

  @override
  String get timeRange => 'Plage de temps';

  @override
  String get timeRangeLabel => 'Plage de temps';

  @override
  String get timeout => 'Délai d\'attente dépassé';

  @override
  String get timestamp => 'Horodatage';

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get totalBandwidth => 'Bande Passante Totale';

  @override
  String get totalDownload => 'Téléchargement Total';

  @override
  String get totalEntries => 'Entrées totales';

  @override
  String get totalUpload => 'Envoi Total';

  @override
  String get totalVPNs => 'Total VPN';

  @override
  String get tryAdjustingFilters =>
      'Essayez d\'ajuster les filtres de sévérité ou de date sélectionnés.';

  @override
  String get tryDemoMode => 'Essayer le mode démo';

  @override
  String get tryDifferentSearch => 'Essayez un terme de recherche différent';

  @override
  String get tunnelAddress => 'Adresse du tunnel';

  @override
  String get tunnelAddressCidr => 'Adresse du tunnel (CIDR)';

  @override
  String get tunnelAddressRequired =>
      'Au moins une adresse de tunnel est requise';

  @override
  String get tunnelAddresses => 'Adresses du tunnel';

  @override
  String tunnelLabel(String network) {
    return 'Tunnel : $network';
  }

  @override
  String get tunnelNetwork => 'Réseau du Tunnel';

  @override
  String get tunnelSettings => 'Paramètres du Tunnel';

  @override
  String tunnelWithValue(String value) {
    return 'Tunnel : $value';
  }

  @override
  String get twoMin => '2 min';

  @override
  String get type => 'Type';

  @override
  String typeWithValue(String value) {
    return 'Type : $value';
  }

  @override
  String get udpPortDefault51820 => 'Port UDP (par défaut : 51820)';

  @override
  String get unableToAccessFilePath =>
      'Impossible d\'accéder au chemin du fichier';

  @override
  String get unableToConnectToAnyEndpoint =>
      'Impossible de se connecter à l\'un des points de terminaison configurés. Veuillez vérifier vos paramètres réseau et réessayer.';

  @override
  String get unauthorized => 'Accès non autorisé';

  @override
  String get unitBytes => 'o';

  @override
  String get unitGigabytes => 'Go';

  @override
  String get unitKilobytes => 'Ko';

  @override
  String get unitMegabytes => 'Mo';

  @override
  String get unitPerSecond => '/s';

  @override
  String get unitPetabytes => 'Po';

  @override
  String get unitTerabytes => 'To';

  @override
  String get unknown => 'Inconnu';

  @override
  String get unknownStatus => 'Inconnu';

  @override
  String get unlock => 'Déverrouiller';

  @override
  String get unlockOPNsenseManager => 'Déverrouiller OPNsense Manager';

  @override
  String get unnamedHost => 'Hôte sans nom';

  @override
  String get unnamedInstance => 'Instance sans Nom';

  @override
  String get unnamedRule => 'Règle sans nom';

  @override
  String get unsavedChanges => 'Modifications Non Enregistrées';

  @override
  String get unsavedChangesConfirmation =>
      'Vous avez des modifications non enregistrées. Voulez-vous les annuler et continuer ?';

  @override
  String get update => 'Mettre à jour';

  @override
  String get updateOverride => 'Mettre à Jour la Substitution';

  @override
  String get updatePeer => 'Mettre à jour le pair';

  @override
  String get updatePinCode => 'Mettre à jour votre code PIN';

  @override
  String get updateRule => 'Mettre à Jour la Règle';

  @override
  String get updateServer => 'Mettre à jour le serveur';

  @override
  String get updateStaticKey => 'Mettre à Jour la Clé Statique';

  @override
  String get upload => 'Envoi';

  @override
  String get uptime => 'Temps de Fonctionnement';

  @override
  String get useBiometric => 'Utiliser la Biométrie';

  @override
  String useBiometricToUnlock(String biometricType) {
    return 'Utiliser $biometricType pour déverrouiller l\'application';
  }

  @override
  String get useExitNode => 'Utiliser le Nœud de Sortie';

  @override
  String get useHttps => 'Utiliser HTTPS';

  @override
  String get useHttpsDescription => 'Utiliser une connexion HTTPS sécurisée';

  @override
  String get useHttpsLabel => 'Utiliser HTTPS';

  @override
  String get useProtocolForCommunicating =>
      'Utiliser ce protocole pour communiquer';

  @override
  String get valid => 'Valide';

  @override
  String get validFrom => 'Valide à partir de';

  @override
  String verifyingConnection(String endpoint) {
    return 'Vérification de la connexion à $endpoint...';
  }

  @override
  String version(String version) {
    return 'Version $version';
  }

  @override
  String get versionLabel => 'Version';

  @override
  String get viewDetails => 'Voir les détails';

  @override
  String get viewFullLicense => 'Voir la Licence Complète';

  @override
  String get virtualAddress => 'Adresse Virtuelle';

  @override
  String get vpn => 'VPN';

  @override
  String get vpnConnections => 'Connexions VPN';

  @override
  String get vpnConnectionsWillAppear =>
      'Les connexions VPN apparaîtront ici lorsqu\'elles seront configurées';

  @override
  String get vpnStatus => 'État VPN';

  @override
  String get vpnType => 'Type de VPN';

  @override
  String get wakeAll => 'Réveiller tout';

  @override
  String get wakeAllDevices => 'Réveiller tous les appareils';

  @override
  String get wakeAllDevicesConfirmation =>
      'Êtes-vous sûr de vouloir envoyer des paquets de réveil à tous les appareils configurés ?';

  @override
  String get wakeAllResults => 'Résultats du réveil de tous';

  @override
  String get wakeHost => 'Réveiller l\'hôte';

  @override
  String get wakeOnLan => 'Wake on LAN';

  @override
  String get wakingAllDevices => 'Réveil de tous les appareils...';

  @override
  String get warning => 'Avertissement';

  @override
  String get winsServers => 'Serveurs WINS';

  @override
  String get winsServersHelperText =>
      'Définir l\'adresse du serveur WINS principal (NetBIOS over TCP/IP Name Server). Répétez cette option pour définir les adresses des serveurs WINS secondaires.';

  @override
  String get wireguard => 'WireGuard';

  @override
  String get wireguardLogs => 'Journaux WireGuard';

  @override
  String get wireguardLogsExport => 'Exporter les journaux WireGuard';

  @override
  String wireguardLogsExportedOn(String date) {
    return 'Journaux WireGuard exportés le $date';
  }

  @override
  String get wireguardPeers => 'Pairs WireGuard';

  @override
  String get wireguardServers => 'Serveurs WireGuard';

  @override
  String get wireguardServiceStarted => 'Service WireGuard démarré';

  @override
  String get wireguardServiceStopped => 'Service WireGuard arrêté';

  @override
  String get wireguardStatus => 'État de WireGuard';

  @override
  String get withoutCredentials => 'Sans Identifiants';

  @override
  String wolPacketSentTo(String host) {
    return 'Paquet WOL envoyé à $host';
  }

  @override
  String get yes => 'Oui';

  @override
  String get yesterday => 'Hier';

  @override
  String get zeroSeconds => '0 secondes';

  @override
  String get addToList => 'Add';

  @override
  String get allFilterOption => 'All';

  @override
  String get commonNameLabel => 'Common Name';

  @override
  String get connectionBlockingDescription =>
      'Block this client connection based on its common name. Don\'t use this option to permanently disable a client due to a compromised key or password. Use a CRL (certificate revocation list) instead.';

  @override
  String deviceLabel(String type) {
    return 'Device: $type';
  }

  @override
  String get enableThisClientOverride => 'Enable this client specific override';

  @override
  String get enterClientX509CommonName =>
      'Enter the client\'s X.509 common name here.';

  @override
  String get facility => 'Facility';

  @override
  String gatewayLabel(String gateway) {
    return 'Gateway: $gateway';
  }

  @override
  String get invalidIpAddressMustBeIpv4OrIpv6 =>
      'Invalid IP address (must be IPv4 or IPv6)';

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
  String get statusLabel => 'Status';

  @override
  String timestampLabel(String timestamp) {
    return 'Timestamp: $timestamp';
  }

  @override
  String typeLabel(String type) {
    return 'Type: $type';
  }

  @override
  String get udp => 'UDP';

  @override
  String get unknownNetwork => 'Unknown Network';

  @override
  String get youMayEnterDescriptionForReference =>
      'You may enter a description here for your reference (not parsed).';

  @override
  String get actualUsed => 'Réellement utilisé';

  @override
  String get arcCache => 'Cache ARC';

  @override
  String get demoModeIndicator =>
      'Mode démo - Affichage des données d\'exemple';

  @override
  String get thermalSensors => 'Capteurs thermiques';

  @override
  String get noThermalSensorsAvailable => 'Aucun capteur thermique disponible';

  @override
  String get collapseAll => 'Tout réduire';

  @override
  String get expandAll => 'Tout développer';

  @override
  String get savingInstance => 'Enregistrement de l\'instance...';

  @override
  String get myStaticKeyHint => 'Ma clé statique';

  @override
  String get staticKeyDescriptionHelper =>
      'Un nom descriptif pour cette clé statique';

  @override
  String get selectKeyModeHelper =>
      'Sélectionnez le mode de clé pour l\'authentification ou le chiffrement';

  @override
  String get staticKeyHelpText =>
      '• Auth : Ajoute l\'authentification HMAC au canal de contrôle\n• Crypt : Chiffre et authentifie tous les paquets du canal de contrôle\n• Crypt V2 : Chiffrement amélioré avec une sécurité accrue\n\nVous pouvez générer une nouvelle clé ou coller une clé existante.';
}
