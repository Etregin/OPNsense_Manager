// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get about => 'Acerca de';

  @override
  String get aboutDescription =>
      'Una aplicación móvil Flutter profesional para administrar routers de firewall OPNsense.';

  @override
  String get aboutImportExport => 'Acerca de importar y exportar';

  @override
  String get acceptDns => 'Aceptar DNS';

  @override
  String get acceptDnsDescription =>
      'Usar servidores DNS proporcionados por Tailscale';

  @override
  String get acceptRoutes => 'Aceptar Rutas';

  @override
  String get acceptSubnetRoutes => 'Aceptar Rutas de Subred';

  @override
  String get acceptSubnetRoutesDescription =>
      'Aceptar rutas anunciadas por otros nodos';

  @override
  String get action => 'Acción';

  @override
  String actionService(String action) {
    return '$action Servicio';
  }

  @override
  String actioningService(String action, String name) {
    return '$action $name...';
  }

  @override
  String get activate => 'Activar';

  @override
  String activatedProfile(String name) {
    return 'Perfil activado: $name';
  }

  @override
  String get activatingProfile => 'Activando perfil...';

  @override
  String get activationFailed => 'Activación fallida';

  @override
  String get active => 'Activo';

  @override
  String get activeDevices => 'Dispositivos Activos';

  @override
  String activeHosts(int count) {
    return '$count host(s) activo(s)';
  }

  @override
  String get activeProfile => 'Perfil Activo';

  @override
  String get add => 'Agregar';

  @override
  String get addClientOverride => 'Agregar Anulación del Cliente';

  @override
  String get addConnection => 'Agregar conexión';

  @override
  String get addConnectionEndpoint =>
      'Por favor agregue al menos un punto de conexión';

  @override
  String get addDnsServer => 'Agregar servidor DNS';

  @override
  String get addHost => 'Agregar host';

  @override
  String get addHostToGetStarted => 'Agregue un host para comenzar';

  @override
  String get addInstance => 'Agregar Instancia';

  @override
  String get addOpenVpnInstance => 'Agregar Instancia OpenVPN';

  @override
  String get addOverride => 'Agregar Anulación';

  @override
  String get addProfile => 'Agregar Perfil';

  @override
  String get addProfileToManageInstances =>
      'Agregue un perfil para administrar instancias de OPNsense';

  @override
  String get addStaticKey => 'Agregar Clave Estática';

  @override
  String get addSubnet => 'Agregar Subred';

  @override
  String get addTunnelAddress => 'Agregar dirección de túnel';

  @override
  String get additionalInformation => 'Información adicional';

  @override
  String get address => 'Dirección';

  @override
  String get addressIsRequired => 'La dirección es obligatoria';

  @override
  String get advertiseExitNode => 'Anunciar Nodo de Salida';

  @override
  String get advertiseExitNodeDescription =>
      'Permitir que otros dispositivos enruten a través de este nodo';

  @override
  String get advertiseRoutes => 'Anunciar Rutas';

  @override
  String get alert => 'Alerta';

  @override
  String get aliasDeletedSuccessfully => 'Alias eliminado exitosamente';

  @override
  String get aliasDisabledSuccessfully => 'Alias deshabilitado exitosamente';

  @override
  String get aliasEnabledSuccessfully => 'Alias habilitado exitosamente';

  @override
  String get aliases => 'Alias';

  @override
  String get all => 'Todos';

  @override
  String get allConnectionsSuccessful =>
      'Todas las conexiones probadas exitosamente';

  @override
  String get allDetailsCopiedToClipboard =>
      'Todos los detalles copiados al portapapeles';

  @override
  String get allRoles => 'Todos los Roles';

  @override
  String get allSettingsSavedSuccessfully =>
      'Todas las configuraciones guardadas exitosamente';

  @override
  String get allStatus => 'Todos los Estados';

  @override
  String get allTypes => 'Todos los tipos';

  @override
  String get allVpns => 'Todas las VPN';

  @override
  String get allowSelfSignedCertificates =>
      'Permitir certificados autofirmados';

  @override
  String get allowSelfSignedCertificatesDescription =>
      'Aceptar certificados SSL autofirmados';

  @override
  String get allowedIps => 'IPs permitidas';

  @override
  String get any => 'Cualquiera';

  @override
  String get anyIpAddressCidrOrAlias =>
      'cualquiera, dirección IP, CIDR o alias';

  @override
  String get anyPortNumberRangeOrAlias =>
      'cualquiera, número de puerto, rango o alias';

  @override
  String apiError(String message) {
    return 'Error de API: $message';
  }

  @override
  String get apiKey => 'Clave API';

  @override
  String get apiKeyIsRequired => 'La clave API es obligatoria';

  @override
  String get apiSecret => 'Secreto API';

  @override
  String get apiSecretIsRequired => 'El secreto API es obligatorio';

  @override
  String get appearance => 'Apariencia';

  @override
  String get apply => 'Aplicar';

  @override
  String get architecture => 'Arquitectura';

  @override
  String get atLeastOneTunnelAddressRequired =>
      'Se requiere al menos una dirección de túnel';

  @override
  String get authSettingsSavedSuccessfully =>
      'Configuración de autenticación guardada exitosamente';

  @override
  String get authTlsAuthentication => 'Auth (Autenticación TLS)';

  @override
  String get authTokenGeneratedSuccessfully =>
      'Token de autenticación generado exitosamente';

  @override
  String get authenticate => 'Autenticar';

  @override
  String get authenticateToUnlock =>
      'Autentíquese para desbloquear OPNsense Manager';

  @override
  String get authentication => 'Autenticación';

  @override
  String get authenticationFailed => 'Autenticación fallida';

  @override
  String get authenticationRequired => 'Autenticación Requerida';

  @override
  String get authenticationSettings => 'Configuración de Autenticación';

  @override
  String get authenticated => 'Autenticado';

  @override
  String get notAuthenticated => 'No autenticado';

  @override
  String get tailnet => 'Tailnet';

  @override
  String get deviceName => 'Nombre del dispositivo';

  @override
  String get authUrl => 'URL de autenticación';

  @override
  String get user => 'Usuario';

  @override
  String get authorizedPeers => 'Pares autorizados';

  @override
  String get autoRefresh => 'Actualización Automática';

  @override
  String get backendState => 'Estado del Backend';

  @override
  String get bandwidthLimit => 'Límite de Ancho de Banda';

  @override
  String get bandwidthLimitMbps => 'Límite de Ancho de Banda (Mbps)';

  @override
  String get bandwidthHistory => 'Historial de Ancho de Banda';

  @override
  String get base64EncodedPrivateKeyKeepSecret =>
      'Clave privada codificada en Base64 (¡mantener en secreto!)';

  @override
  String get base64EncodedPublicKey => 'Clave pública codificada en Base64';

  @override
  String get biometricAuth => 'Autenticación Biométrica';

  @override
  String get biometricAuthFailed =>
      'La autenticación biométrica falló o fue cancelada';

  @override
  String get biometricLockDisabled => 'Bloqueo biométrico deshabilitado';

  @override
  String get biometricLockEnabled => 'Bloqueo biométrico habilitado';

  @override
  String biometricLockTitle(String biometricType) {
    return 'Bloqueo $biometricType';
  }

  @override
  String get biometricNotAvailable =>
      'La autenticación biométrica no está disponible en este dispositivo';

  @override
  String get block => 'Bloquear';

  @override
  String get blockHost => 'Bloquear host';

  @override
  String blockHostConfirmation(String hostname, String ip) {
    return '¿Está seguro de que desea bloquear $hostname ($ip)?\n\nEsto creará una regla de firewall para bloquear todo el tráfico de este host.';
  }

  @override
  String get blockingHost => 'Bloqueando host...';

  @override
  String get bytesReceived => 'Bytes Recibidos';

  @override
  String get bytesSent => 'Bytes Enviados';

  @override
  String get cancel => 'Cancelar';

  @override
  String get cannotBeUndone => 'Esta acción no se puede deshacer.';

  @override
  String get cannotDeleteLastConnection =>
      'No se puede eliminar el último punto de conexión';

  @override
  String get carpVhidToDepend => 'CARP VHID del que depender';

  @override
  String get categories => 'Categorías';

  @override
  String get changePin => 'Cambiar PIN';

  @override
  String get changesDiscarded => 'Cambios descartados';

  @override
  String get checkIfWireguardIsConfiguredAndRunning =>
      'Verifique si WireGuard está configurado y en ejecución';

  @override
  String get chooseExportLocation => 'Elegir Ubicación de Exportación';

  @override
  String get cidrNotationRequired => 'Se requiere notación CIDR';

  @override
  String get clearLogs => 'Limpiar registros';

  @override
  String get clearSelection => 'Limpiar selección';

  @override
  String get client => 'Cliente';

  @override
  String get clientAddress => 'Dirección del Cliente';

  @override
  String get clientName => 'Nombre del cliente';

  @override
  String get clientOverrides => 'Anulaciones de cliente';

  @override
  String get clientSettings => 'Configuración del Cliente';

  @override
  String get clientSpecificOverrides => 'Anulaciones Específicas del Cliente';

  @override
  String get clientX509CommonNameHelper =>
      'Ingrese aquí el nombre común X.509 del cliente.';

  @override
  String get close => 'Cerrar';

  @override
  String get commonName => 'Nombre Común';

  @override
  String get commonNameRequired => 'El nombre común es obligatorio';

  @override
  String commonNameWithValue(String value) {
    return 'Nombre Común: $value';
  }

  @override
  String get configurationAppliedSuccessfully =>
      'Configuración aplicada exitosamente';

  @override
  String get configurationPreview => 'Vista previa de configuración';

  @override
  String get configureAdvertisedSubnets => 'Configurar subredes anunciadas';

  @override
  String get configured => 'Configurado';

  @override
  String get confirmDelete => 'Confirmar Eliminación';

  @override
  String confirmDeleteInstance(String name) {
    return '¿Está seguro de que desea eliminar la instancia \"$name\"? Esta acción no se puede deshacer.';
  }

  @override
  String confirmDeleteOverride(String name) {
    return '¿Está seguro de que desea eliminar la anulación para \"$name\"? Esta acción no se puede deshacer.';
  }

  @override
  String confirmDeleteStaticKey(String name) {
    return '¿Está seguro de que desea eliminar la clave estática \"$name\"? Esta acción no se puede deshacer.';
  }

  @override
  String get confirmNewPin => 'Confirmar Nuevo PIN';

  @override
  String get confirmPin => 'Confirmar PIN';

  @override
  String confirmServiceAction(String action, String name) {
    return '¿$action \"$name\"?';
  }

  @override
  String get connect => 'Conectar';

  @override
  String get connectToYourOpnsenseFirewall =>
      'Conéctese a su firewall OPNsense';

  @override
  String get connectVpn => 'Conectar VPN';

  @override
  String get connected => 'Conectado';

  @override
  String get connectedSince => 'Conectado Desde';

  @override
  String connectedSuccessfullyVia(String endpoint) {
    return 'Conectado exitosamente a través de: $endpoint';
  }

  @override
  String connectingVPN(String name) {
    return 'Conectando $name...';
  }

  @override
  String get connectionBlocking => 'Bloqueo de conexión';

  @override
  String get connectionDetails => 'Detalles de Conexión';

  @override
  String get connectionEndpoints => 'Puntos de conexión';

  @override
  String get connectionEndpointsHelp =>
      'Administre múltiples puntos de conexión para este perfil. La aplicación intentará cada punto final en orden hasta que se establezca una conexión exitosa.';

  @override
  String get connectionFailed =>
      'Conexión fallida. Verifique los registros de la consola para más detalles.\n\nProblemas comunes:\n• El dispositivo no está en la misma red que OPNsense\n• Dirección IP o puerto incorrectos\n• Firewall bloqueando la conexión\n• Credenciales API inválidas';

  @override
  String connectionFailedError(String error) {
    return 'Conexión fallida: $error';
  }

  @override
  String get connectionInformation => 'Información de conexión';

  @override
  String get connectionStatus => 'Estado de conexión';

  @override
  String get connectionSuccessful => 'Conexión Exitosa';

  @override
  String get connectionTestFailed => 'Prueba de conexión fallida';

  @override
  String get connectionTestResults => 'Resultados de prueba de conexión';

  @override
  String get content => 'Contenido';

  @override
  String copiedLogEntries(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'entradas',
      one: 'entrada',
    );
    return 'Copiadas $count $_temp0 de registro';
  }

  @override
  String get copiedToClipboard => 'Copiado al portapapeles';

  @override
  String get copy => 'Copiar';

  @override
  String get copyAllDetails => 'Copiar todos los detalles';

  @override
  String get copyHost => 'Copiar host';

  @override
  String get copyKey => 'Copiar Clave';

  @override
  String get copySelected => 'Copiar seleccionados';

  @override
  String get cpuUsage => 'Uso de CPU';

  @override
  String get createAliasComingSoon => 'Crear alias (Próximamente)';

  @override
  String get createFirstAutomationRule =>
      'Cree su primera regla de automatización para comenzar';

  @override
  String get createFirstProfile => 'Cree su primer perfil para comenzar';

  @override
  String get createNewProfile => 'Crear Nuevo Perfil';

  @override
  String get createOverride => 'Crear Anulación';

  @override
  String get createPeer => 'Crear peer';

  @override
  String get createRule => 'Crear Regla';

  @override
  String get createServer => 'Crear servidor';

  @override
  String get createStaticKey => 'Crear Clave Estática';

  @override
  String get createYourFirstProfile =>
      'Cree su primer perfil de OPNsense para comenzar';

  @override
  String get created => 'Creado';

  @override
  String get critical => 'Crítico';

  @override
  String get cryptTlsEncryption => 'Crypt (Cifrado TLS)';

  @override
  String get cryptV2TlsEncryption => 'Crypt V2 (Cifrado TLS)';

  @override
  String get currentPin => 'PIN Actual';

  @override
  String get currentPinIncorrect => 'El PIN actual es incorrecto';

  @override
  String get darkMode => 'Modo Oscuro';

  @override
  String get dashboard => 'Panel de Control';

  @override
  String get day => 'día';

  @override
  String get days => 'días';

  @override
  String daysAgo(int days) {
    return 'hace $days días';
  }

  @override
  String get debug => 'Depuración';

  @override
  String get defineRoleOfInstance => 'Definir el rol de esta instancia';

  @override
  String get delete => 'Eliminar';

  @override
  String deleteAliasConfirmation(String aliasName) {
    return '¿Está seguro de que desea eliminar el alias \"$aliasName\"?';
  }

  @override
  String get deleteConfirmation =>
      '¿Está seguro de que desea eliminar este elemento?';

  @override
  String get deleteConnection => 'Eliminar conexión';

  @override
  String deleteConnectionConfirmation(String connectionName) {
    return '¿Está seguro de que desea eliminar la conexión \"$connectionName\"?';
  }

  @override
  String get deleteHost => 'Eliminar host';

  @override
  String deleteHostConfirmation(String host) {
    return '¿Está seguro de que desea eliminar \"$host\"?';
  }

  @override
  String get deleteInstance => 'Eliminar Instancia';

  @override
  String get deleteOverride => 'Eliminar Anulación';

  @override
  String get deletePeer => 'Eliminar Peer';

  @override
  String deletePeerConfirmation(String name) {
    return '¿Está seguro de que desea eliminar el peer \"$name\"?';
  }

  @override
  String get deleteProfile => 'Eliminar Perfil';

  @override
  String deleteProfileConfirmation(String name) {
    return '¿Está seguro de que desea eliminar \"$name\"?';
  }

  @override
  String get deleteRule => 'Eliminar Regla';

  @override
  String deleteRuleConfirmation(String description) {
    return '¿Está seguro de que desea eliminar la regla \"$description\"?';
  }

  @override
  String disableRuleConfirmation(String description) {
    return '¿Está seguro de que desea deshabilitar la regla \"$description\"?';
  }

  @override
  String enableRuleConfirmation(String description) {
    return '¿Está seguro de que desea habilitar la regla \"$description\"?';
  }

  @override
  String deleteServerConfirmation(String name) {
    return '¿Está seguro de que desea eliminar el servidor \"$name\"? Esta acción no se puede deshacer.';
  }

  @override
  String get deleteStaticKey => 'Eliminar Clave Estática';

  @override
  String get deleteSubnet => 'Eliminar Subred';

  @override
  String deleteSubnetConfirmation(String subnet) {
    return '¿Está seguro de que desea eliminar la subred $subnet?';
  }

  @override
  String get demo => 'Demo';

  @override
  String get dependOnCarp => 'Depender de (CARP)';

  @override
  String get description => 'Descripción';

  @override
  String get descriptionHelperText => 'Una breve descripción de esta instancia';

  @override
  String get descriptionHelperTextOverride =>
      'Puede ingresar una descripción aquí para su referencia (no se analiza).';

  @override
  String get descriptionHint => 'ej., PC de la sala de estar';

  @override
  String get descriptionOptional => 'Descripción (opcional)';

  @override
  String get descriptionRequired => 'Se requiere descripción';

  @override
  String get destination => 'Destino';

  @override
  String get destinationAddress => 'Dirección de destino';

  @override
  String get destinationIsRequired => 'El destino es obligatorio';

  @override
  String get destinationPort => 'Puerto de Destino';

  @override
  String get destinationPortOptional => 'Puerto de Destino (Opcional)';

  @override
  String get deviceType => 'Tipo de Dispositivo';

  @override
  String get dhcpLeases => 'Arrendamientos DHCP';

  @override
  String dhcpServerLabel(String serverName) {
    return 'Servidor $serverName';
  }

  @override
  String get dhcpServerType => 'Tipo de servidor DHCP';

  @override
  String get direction => 'Dirección';

  @override
  String get disable => 'Deshabilitar';

  @override
  String get disableAutoScroll => 'Desactivar desplazamiento automático';

  @override
  String get disableRoutes => 'Deshabilitar Rutas';

  @override
  String get disableRoutesDescription =>
      'Prevenir la instalación automática de rutas';

  @override
  String get disableRule => 'Desactivar regla';

  @override
  String get disableSnat => 'Deshabilitar SNAT';

  @override
  String get disableSnatDescription =>
      'Deshabilitar NAT de origen para rutas de subred';

  @override
  String get disabled => 'Deshabilitado';

  @override
  String get disablingRule => 'Desactivando regla...';

  @override
  String get discard => 'Descartar';

  @override
  String get disconnect => 'Desconectar';

  @override
  String get disconnectVpn => 'Desconectar VPN';

  @override
  String get disconnected => 'Desconectado';

  @override
  String disconnectingVPN(String name) {
    return 'Desconectando $name...';
  }

  @override
  String get diskUsage => 'Uso del Disco';

  @override
  String get dnsDomainList => 'Lista de Dominios DNS';

  @override
  String get dnsDomainListHelperText =>
      'Establecer sufijos DNS específicos de la conexión.';

  @override
  String get dnsDomainSearchList => 'Lista de Búsqueda de Dominios DNS';

  @override
  String get dnsDomainSearchListHelperText =>
      'Agregar nombre a la lista de búsqueda de dominios. Repita esta opción para agregar más entradas. Se admiten hasta 10 dominios.';

  @override
  String get dnsEnabled => 'DNS Habilitado';

  @override
  String get dnsServerIp => 'IP del servidor DNS';

  @override
  String get dnsServerIsRequired => 'Se requiere servidor DNS';

  @override
  String get dnsServerOptional => 'Servidor DNS (Opcional)';

  @override
  String get dnsServers => 'Servidores DNS';

  @override
  String get dnsServersHelperText =>
      'Establecer dirección IPv4 o IPv6 del servidor de nombres de dominio principal. Repita esta opción para establecer direcciones de servidores DNS secundarios.';

  @override
  String get dnsServersOptional => 'Servidores DNS (Opcional)';

  @override
  String get dnsmasqDescription => 'Servidor DNS y DHCP ligero';

  @override
  String get done => 'Hecho';

  @override
  String get download => 'Descarga';

  @override
  String get dynamicLease => 'Dinámico';

  @override
  String get edit => 'Editar';

  @override
  String get editClientOverride => 'Editar Anulación del Cliente';

  @override
  String get editConnection => 'Editar conexión';

  @override
  String get editHost => 'Editar host';

  @override
  String get editProfile => 'Editar Perfil';

  @override
  String get editRule => 'Editar Regla';

  @override
  String get editStaticKey => 'Editar Clave Estática';

  @override
  String get editSubnet => 'Editar Subred';

  @override
  String get editWireguardPeer => 'Editar peer WireGuard';

  @override
  String get editWireguardServer => 'Editar servidor WireGuard';

  @override
  String get emergency => 'Emergencia';

  @override
  String get enable => 'Habilitar';

  @override
  String get enableAutoScroll => 'Activar desplazamiento automático';

  @override
  String get enableClientSpecificOverride =>
      'Habilitar esta anulación específica del cliente';

  @override
  String get enableDebugLogging => 'Habilitar registro de depuración';

  @override
  String get enablePinLockFirstBiometric =>
      'Habilite el bloqueo PIN primero para usar biométrico';

  @override
  String get enableRule => 'Activar regla';

  @override
  String get enableSsh => 'Habilitar SSH';

  @override
  String get enableSshDescription =>
      'Permitir acceso SSH a través de Tailscale';

  @override
  String get enableTailscale => 'Habilitar Tailscale';

  @override
  String get enableTailscaleDescription =>
      'Habilitar o deshabilitar el servicio Tailscale';

  @override
  String get enableWireguard => 'Habilitar WireGuard';

  @override
  String get enabled => 'Habilitado';

  @override
  String get enablingRule => 'Activando regla...';

  @override
  String get endTime => 'Hora de finalización';

  @override
  String get endpoint => 'Punto final';

  @override
  String get endpointAddress => 'Dirección del punto final';

  @override
  String get endpointPort => 'Puerto del punto final';

  @override
  String get enterBandwidthLimit =>
      'Ingrese el límite de ancho de banda de su conexión en Mbps';

  @override
  String get enterClientCertificateCommonName =>
      'Ingrese el nombre común del certificado del cliente';

  @override
  String get enterDescriptionForOverride =>
      'Ingrese una descripción para esta anulación';

  @override
  String get enterOrGeneratePresharedKey =>
      'Ingrese o genere una clave precompartida';

  @override
  String get enterOrGeneratePrivateKey => 'Ingrese o genere una clave privada';

  @override
  String get enterOrGeneratePublicKey => 'Ingrese o genere una clave pública';

  @override
  String get enterPin => 'Ingresar PIN';

  @override
  String get enterPinLabel => 'Ingresar PIN (4-6 dígitos)';

  @override
  String get enterRuleDescription => 'Ingrese la descripción de la regla';

  @override
  String get enterYourApiKey => 'Ingrese su clave API';

  @override
  String get enterYourApiSecret => 'Ingrese su secreto API';

  @override
  String get entries => 'entradas';

  @override
  String entriesCount(int count) {
    return '$count entradas';
  }

  @override
  String get error => 'Error';

  @override
  String errorAddingSubnet(String error) {
    return 'Error al agregar subred: $error';
  }

  @override
  String errorDeletingRule(String error) {
    return 'Error al eliminar regla: $error';
  }

  @override
  String errorDeletingSubnet(String error) {
    return 'Error al eliminar subred: $error';
  }

  @override
  String get errorLoadingData => 'Error al cargar datos';

  @override
  String get errorLoadingInstance => 'Error al cargar la instancia';

  @override
  String get errorLoadingLogs => 'Error al cargar registros';

  @override
  String get errorLoadingOverride => 'Error al cargar la anulación';

  @override
  String get errorLoadingRoutes => 'Error al cargar rutas';

  @override
  String get errorLoadingRules => 'Error al cargar reglas';

  @override
  String get errorLoadingSessions => 'Error al cargar sesiones';

  @override
  String get errorLoadingSystemInfo =>
      'Error al cargar información del sistema';

  @override
  String get errorLoadingVpnConnections => 'Error al cargar conexiones VPN';

  @override
  String errorPrefix(String message) {
    return 'Error: $message';
  }

  @override
  String errorRestartingService(String error) {
    return 'Error al reiniciar el servicio: $error';
  }

  @override
  String errorSavingRule(String error) {
    return 'Error al guardar la regla: $error';
  }

  @override
  String errorStartingService(String error) {
    return 'Error al iniciar el servicio: $error';
  }

  @override
  String errorStoppingService(String error) {
    return 'Error al detener el servicio: $error';
  }

  @override
  String errorTogglingRule(String error) {
    return 'Error al cambiar regla: $error';
  }

  @override
  String errorUpdatingSubnet(String error) {
    return 'Error al actualizar subred: $error';
  }

  @override
  String get exampleCidr => 'Ejemplo: 10.10.10.2/24 o fd00::2/64';

  @override
  String get exampleTunnelAddress => 'Ejemplo: 10.10.10.1/24 o fd00::1/64';

  @override
  String get examplesAnyIpCidr => 'Ejemplos: any, 192.168.1.0/24, 10.0.0.1';

  @override
  String get examplesAnyPortRange => 'Ejemplos: any, 80, 1024-65535';

  @override
  String get examplesAnyPortRangeHttp => 'Ejemplos: any, 80, 80-443, http';

  @override
  String get exitNode => 'Nodo de Salida';

  @override
  String get expired => 'Expirado';

  @override
  String get expires => 'Expira';

  @override
  String get expiryTime => 'Tiempo de expiración';

  @override
  String get export => 'Exportar';

  @override
  String get exportAllProfiles => 'Exportar todos los perfiles';

  @override
  String get exportAllProfilesSubtitle =>
      'Exportar todos los perfiles a un archivo JSON';

  @override
  String get exportCredentialsWarning =>
      'Exportar con credenciales guardará las claves API y secretos en texto plano. Solo haga esto si almacenará el archivo de forma segura.';

  @override
  String get exportFailed => 'Exportación fallida';

  @override
  String exportFailedError(String error) {
    return 'Exportación fallida: $error';
  }

  @override
  String get exportLogs => 'Exportar registros';

  @override
  String get exportProfiles => 'Exportar Perfiles';

  @override
  String get exportProfilesContent =>
      '¿Desea incluir las credenciales API en la exportación?\n\nADVERTENCIA: Incluir credenciales almacenará las claves API y secretos en texto plano. Solo incluya credenciales si almacenará el archivo de forma segura.';

  @override
  String get exportSuccess => 'Exportación exitosa';

  @override
  String get exportThisProfile => 'Exportar este perfil';

  @override
  String get failedDevices => 'Dispositivos fallidos';

  @override
  String failedToActionTailscaleService(String action) {
    return 'Error al $action el servicio Tailscale';
  }

  @override
  String get failedToApplyConfiguration => 'Error al aplicar la configuración';

  @override
  String failedToSwitchProfile(String error) {
    return 'Error al cambiar de perfil: $error';
  }

  @override
  String get failedToBlockHost => 'Error al bloquear el host';

  @override
  String failedToConnect(String name) {
    return 'Error al conectar $name';
  }

  @override
  String failedToCopyHost(String error) {
    return 'Error al copiar host: $error';
  }

  @override
  String failedToDeleteAlias(String error) {
    return 'Error al eliminar alias: $error';
  }

  @override
  String failedToDeleteHost(String error) {
    return 'Error al eliminar host: $error';
  }

  @override
  String failedToDeleteInstance(String error) {
    return 'Error al eliminar la instancia: $error';
  }

  @override
  String failedToDeleteOverride(String error) {
    return 'Error al eliminar la anulación: $error';
  }

  @override
  String failedToDeletePeer(String error) {
    return 'Error al eliminar el peer: $error';
  }

  @override
  String get failedToDeleteProfile => 'Error al eliminar el perfil';

  @override
  String failedToDeleteServer(String error) {
    return 'Error al eliminar el servidor: $error';
  }

  @override
  String failedToDeleteStaticKey(String error) {
    return 'Error al eliminar la clave estática: $error';
  }

  @override
  String failedToDisconnect(String name) {
    return 'Error al desconectar $name';
  }

  @override
  String failedToExportLogs(String error) {
    return 'Error al exportar registros: $error';
  }

  @override
  String failedToGenerateKey(String error) {
    return 'Error al generar la clave: $error';
  }

  @override
  String failedToGenerateToken(String error) {
    return 'Error al generar el token: $error';
  }

  @override
  String failedToLoadInterfaces(String error) {
    return 'Error al cargar interfaces: $error';
  }

  @override
  String get failedToLoadOpenvpnLogs => 'Error al cargar registros de OpenVPN';

  @override
  String failedToRestartService(String type) {
    return 'Error al reiniciar servicio $type';
  }

  @override
  String get failedToSaveAuthSettings =>
      'Error al guardar la configuración de autenticación';

  @override
  String failedToSaveHost(String error) {
    return 'Error al guardar host: $error';
  }

  @override
  String failedToSaveInstance(String error) {
    return 'Error al guardar la instancia: $error';
  }

  @override
  String failedToSaveOverride(String error) {
    return 'Error al guardar la anulación: $error';
  }

  @override
  String get failedToSavePeer => 'Error al guardar el peer';

  @override
  String get failedToSaveProfile => 'Error al guardar el perfil';

  @override
  String get failedToSaveServer => 'Error al guardar el servidor';

  @override
  String get failedToSaveSettings => 'Error al guardar configuraciones';

  @override
  String failedToSaveStaticKey(String error) {
    return 'Error al guardar la clave estática: $error';
  }

  @override
  String get failedToStartService => 'Error al iniciar el servicio';

  @override
  String get failedToStopService => 'Error al detener el servicio';

  @override
  String failedToToggleAlias(String error) {
    return 'Error al cambiar alias: $error';
  }

  @override
  String failedToToggleInstance(String error) {
    return 'Error al cambiar la instancia: $error';
  }

  @override
  String failedToToggleOverride(String error) {
    return 'Error al cambiar la anulación: $error';
  }

  @override
  String failedToTogglePeer(String error) {
    return 'Error al cambiar el peer: $error';
  }

  @override
  String failedToToggleServer(String error) {
    return 'Error al cambiar el servidor: $error';
  }

  @override
  String failedToWakeAllHosts(String error) {
    return 'Error al despertar todos los hosts: $error';
  }

  @override
  String failedToWakeHost(String error) {
    return 'Error al despertar host: $error';
  }

  @override
  String featureComingSoon(String feature) {
    return '$feature - Próximamente';
  }

  @override
  String get featuresList =>
      '• Monitoreo y gestión del sistema\n• Configuración de reglas de firewall\n• Control de servicios\n• Registros en tiempo real\n• Soporte multi-perfil\n• Autenticación segura';

  @override
  String get featuresTitle => 'Características';

  @override
  String fieldIsRequired(String fieldName) {
    return '$fieldName es obligatorio';
  }

  @override
  String get fieldRequired => 'Este campo es requerido';

  @override
  String get fifteenMin => '15 min';

  @override
  String get filterByAction => 'Filtrar por Acción';

  @override
  String get filterByType => 'Filtrar por tipo';

  @override
  String get filterLabel => 'Filtro: ';

  @override
  String get filters => 'Filtros';

  @override
  String get firewall => 'Cortafuegos';

  @override
  String get firewallAliases => 'Alias del cortafuegos';

  @override
  String get firewallLogs => 'Registros del Cortafuegos';

  @override
  String get firewallRuleDetails => 'Detalles de la Regla del Cortafuegos';

  @override
  String get firewallRules => 'Reglas del Cortafuegos';

  @override
  String get firmwareDetails => 'Detalles del Firmware';

  @override
  String get fiveMin => '5 min';

  @override
  String get fixFormErrors => 'Por favor corrija los errores en el formulario';

  @override
  String get forbidden => 'Acceso prohibido';

  @override
  String get gateway => 'Puerta de enlace';

  @override
  String get gatewayOptional => 'Puerta de enlace (Opcional)';

  @override
  String get gateways => 'Puertas de Enlace';

  @override
  String get general => 'General';

  @override
  String get generalSettings => 'Configuración general';

  @override
  String get generateKey => 'Generar Clave';

  @override
  String get generateKeyPair => 'Generar par de claves';

  @override
  String get generateNewKeyPair => 'Generar nuevo par de claves';

  @override
  String get generateOrPasteKeyHere => 'Generar o pegar clave aquí';

  @override
  String get generatePresharedKey => 'Generar clave precompartida';

  @override
  String get generated => 'Generado';

  @override
  String get generating => 'Generando...';

  @override
  String get gitCommit => 'Commit de Git';

  @override
  String get healthStatus => 'Estado de Salud';

  @override
  String get hideControls => 'Ocultar Controles';

  @override
  String get hideKey => 'Ocultar clave';

  @override
  String get historySize => 'Tamaño del historial';

  @override
  String get host => 'Host';

  @override
  String get hostAddedSuccessfully => 'Host agregado exitosamente';

  @override
  String get hostBlocked => 'Host bloqueado exitosamente';

  @override
  String get hostDeletedSuccessfully => 'Host eliminado exitosamente';

  @override
  String get hostHint => 'ej., 192.168.1.1 o firewall.example.com';

  @override
  String get hostIpAddress => 'Host / Dirección IP';

  @override
  String get hostIsRequired => 'El host es obligatorio';

  @override
  String get hostPlaceholder => '192.168.1.1 o firewall.example.com';

  @override
  String get hostUpdatedSuccessfully => 'Host actualizado exitosamente';

  @override
  String get hostname => 'Nombre del Host';

  @override
  String get hour => 'hora';

  @override
  String get hours => 'horas';

  @override
  String hoursAgo(int hours) {
    return 'Hace ${hours}h';
  }

  @override
  String get id => 'ID';

  @override
  String get import => 'Importar';

  @override
  String get importAndExport => 'Importar y exportar';

  @override
  String get importExportDescription =>
      'Exporte sus perfiles para hacer una copia de seguridad o transferirlos a otro dispositivo. Importe perfiles desde un archivo exportado previamente.\n\nLos perfiles se guardan en formato JSON y pueden incluir puntos de conexión y configuraciones.';

  @override
  String importFailed(String error) {
    return 'Importación fallida: $error';
  }

  @override
  String get importProfiles => 'Importar Perfiles';

  @override
  String get importProfilesDialog =>
      '¿Cómo deben manejarse los perfiles existentes?\n\n• Mantener Ambos: Importar con nuevos IDs\n• Sobrescribir: Reemplazar perfiles existentes';

  @override
  String get importProfilesSubtitle =>
      'Importar perfiles desde un archivo JSON';

  @override
  String get importSuccess => 'Importación exitosa';

  @override
  String importedWithFailures(int failed, int success) {
    String _temp0 = intl.Intl.pluralLogic(
      success,
      locale: localeName,
      other: 'perfiles',
      one: 'perfil',
    );
    return 'Se importaron $success $_temp0, $failed fallaron';
  }

  @override
  String inDays(int days) {
    return 'en ${days}d';
  }

  @override
  String inHours(int hours) {
    return 'en ${hours}h';
  }

  @override
  String inMinutes(int minutes) {
    return 'en ${minutes}m';
  }

  @override
  String get inbound => 'Entrante';

  @override
  String get includeCredentials => 'Incluir Credenciales';

  @override
  String get incorrectPin => 'PIN incorrecto';

  @override
  String get info => 'Información';

  @override
  String get instance => 'Instancia';

  @override
  String get instanceCreatedSuccessfully => 'Instancia creada exitosamente';

  @override
  String get instanceDeletedSuccessfully => 'Instancia eliminada exitosamente';

  @override
  String get instanceDetails => 'Detalles de la Instancia';

  @override
  String instanceToggledSuccessfully(String status) {
    return 'Instancia $status exitosamente';
  }

  @override
  String get instanceUpdatedSuccessfully =>
      'Instancia actualizada exitosamente';

  @override
  String get instanceWillBeActiveWhenEnabled =>
      'La instancia estará activa cuando esté habilitada';

  @override
  String get instances => 'Instancias';

  @override
  String get interface => 'Interfaz';

  @override
  String get invalidApiKeyFormat => 'Formato de clave API no válido';

  @override
  String get invalidApiSecretFormat => 'Formato de secreto API no válido';

  @override
  String get invalidBase64Format => 'Formato Base64 no válido';

  @override
  String get invalidCidrNotation => 'Notación CIDR inválida';

  @override
  String get invalidDestinationFormat => 'Formato de destino inválido';

  @override
  String invalidFileFormat(String error) {
    return 'Archivo inválido: $error';
  }

  @override
  String get invalidHostnameOrIp => 'Nombre de host o dirección IP no válidos';

  @override
  String get invalidInput => 'Entrada inválida';

  @override
  String get invalidIpAddress => 'Dirección IP no válida';

  @override
  String get invalidIpAddressFormat =>
      'Formato de dirección IP no válido (debe ser IPv4 o IPv6)';

  @override
  String get invalidIpv4Address => 'Dirección IPv4 no válida';

  @override
  String get invalidIpv4CidrNotation => 'Notación CIDR IPv4 no válida';

  @override
  String get invalidIpv4Prefix => 'Prefijo IPv4 no válido (debe ser 0-32)';

  @override
  String get invalidIpv6Address => 'Dirección IPv6 no válida';

  @override
  String get invalidIpv6CidrNotation => 'Notación CIDR IPv6 no válida';

  @override
  String get invalidIpv6Prefix => 'Prefijo IPv6 no válido (debe ser 0-128)';

  @override
  String get invalidPin => 'PIN inválido';

  @override
  String get invalidPortFormat => 'Formato de puerto inválido';

  @override
  String get invalidPrefixLength => 'Longitud de prefijo no válida';

  @override
  String get invalidSourceFormat => 'Formato de origen inválido';

  @override
  String get ipAddress => 'Dirección IP';

  @override
  String get ipAddresses => 'Direcciones IP';

  @override
  String get ipv4TunnelNetwork => 'Red del Túnel IPv4';

  @override
  String get ipv6TunnelNetwork => 'Red del Túnel IPv6';

  @override
  String get iscDhcpDescription =>
      'Servidor DHCP de Internet Systems Consortium';

  @override
  String itemsCount(int count) {
    return '$count elemento(s)';
  }

  @override
  String get justNow => 'Justo ahora';

  @override
  String get keaDhcpDescription =>
      'Servidor DHCP moderno y de alto rendimiento';

  @override
  String get keepAliveIntervalOptional =>
      'Intervalo de mantener vivo (Opcional)';

  @override
  String get keepBoth => 'Mantener Ambos';

  @override
  String get keepalive => 'Mantener vivo';

  @override
  String get keepaliveOptional => 'Mantener vivo (Opcional)';

  @override
  String get key => 'Clave';

  @override
  String get keyCopiedToClipboard => 'Clave copiada al portapapeles';

  @override
  String get keyGeneratedSuccessfully => 'Clave generada exitosamente';

  @override
  String keyWithId(String id) {
    return 'Clave $id';
  }

  @override
  String get keysGeneratedSuccessfully => 'Claves generadas exitosamente';

  @override
  String get keysRequired => 'Se requieren claves privadas y públicas';

  @override
  String get label => 'Etiqueta';

  @override
  String get labelHint => 'ej., Red doméstica, VPN de oficina';

  @override
  String get labelOptional => 'Etiqueta (Opcional)';

  @override
  String get language => 'Idioma';

  @override
  String get lastDay => 'Último Día';

  @override
  String get lastDayShort => '1 día';

  @override
  String get lastMonth => 'Último Mes';

  @override
  String get lastMonthShort => '1 mes';

  @override
  String get lastUpdate => 'Última Actualización';

  @override
  String lastUsed(String date) {
    return 'Último uso: $date';
  }

  @override
  String get lastWeek => 'Última Semana';

  @override
  String get lastWeekShort => '1 semana';

  @override
  String leasesCount(int filtered, int total) {
    return '$filtered de $total arrendamiento(s)';
  }

  @override
  String get leaveEmptyOrGenerate => 'Dejar vacío o generar';

  @override
  String get licenses => 'Licencias';

  @override
  String get lightMode => 'Modo Claro';

  @override
  String get limit => 'Límite';

  @override
  String get live => 'En vivo';

  @override
  String get liveNetworkMonitor => 'Monitor de Red en Vivo';

  @override
  String get neighborDiscovery => 'Descubrimiento de Vecinos';

  @override
  String get loading => 'Cargando...';

  @override
  String get loadingHostData => 'Cargando datos del host...';

  @override
  String get loadingSettings => 'Cargando configuraciones...';

  @override
  String get localAddress => 'Dirección Local';

  @override
  String get localNetwork => 'Red Local';

  @override
  String get localNetworkHelperText =>
      'Estas son las redes accesibles por el cliente, se envían a través de cláusulas route(-ipv6) en OpenVPN al cliente.';

  @override
  String lockAfterMinutes(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'minutos',
      one: 'minuto',
    );
    return 'Bloquear después de $minutes $_temp0 de inactividad';
  }

  @override
  String get lockApp => 'Bloquear Aplicación';

  @override
  String get lockTimeoutLabel => 'Tiempo de Espera de Bloqueo';

  @override
  String lockTimeoutSet(int value) {
    String _temp0 = intl.Intl.pluralLogic(
      value,
      locale: localeName,
      other: 'minutos',
      one: 'minuto',
    );
    return 'Tiempo de espera de bloqueo establecido en $value $_temp0';
  }

  @override
  String get longPressToCopy => 'Long press to copy';

  @override
  String get logDetails => 'Detalles del registro';

  @override
  String get logEntryCopied => 'Entrada de registro copiada';

  @override
  String get logEntryDetails => 'Detalles de la Entrada de Registro';

  @override
  String get logFile => 'Archivo de registro';

  @override
  String get logLimit => 'Límite de Registros';

  @override
  String get login => 'Iniciar Sesión';

  @override
  String get loginServer => 'Servidor de Inicio de Sesión';

  @override
  String get loginServerHelperText =>
      'La URL del servidor de inicio de sesión de Tailscale';

  @override
  String get loginServerRequired =>
      'El servidor de inicio de sesión es obligatorio';

  @override
  String get logout => 'Cerrar Sesión';

  @override
  String get logs => 'Registros';

  @override
  String get logsExportedSuccessfully => 'Registros exportados exitosamente';

  @override
  String get logsMatchingFiltersWillAppearHere =>
      'Los registros que coincidan con los filtros aparecerán aquí';

  @override
  String get logsWillAppear =>
      'Los registros aparecerán aquí a medida que se generen';

  @override
  String get macAddress => 'Dirección MAC';

  @override
  String get macAddressHint => 'ej., 00:11:22:33:44:55';

  @override
  String get macAddressIsRequired => 'Se requiere la dirección MAC';

  @override
  String get invalidMacAddressFormat =>
      'Formato de dirección MAC inválido (ej., AA:BB:CC:DD:EE:FF)';

  @override
  String get manageProfiles => 'Administrar perfiles';

  @override
  String get manageSubnets => 'Administrar Subredes';

  @override
  String get manageWireguard => 'Administrar WireGuard';

  @override
  String get manufacturer => 'Fabricante';

  @override
  String get maximumTransmissionUnit =>
      'Unidad de transmisión máxima (576-9000)';

  @override
  String get memoryUsage => 'Uso de Memoria';

  @override
  String get minute => 'minuto';

  @override
  String get minutes => 'minutos';

  @override
  String minutesAgo(int minutes) {
    return 'Hace ${minutes}m';
  }

  @override
  String get mode => 'Modo';

  @override
  String get modified => 'Modificado';

  @override
  String get monitorInterface => 'Interfaz de Monitoreo';

  @override
  String get mssFix => 'Corrección MSS';

  @override
  String get mssFixDescription => 'Habilitar corrección MSS para esta conexión';

  @override
  String get mtuOptional => 'MTU (Opcional)';

  @override
  String get mustBeValidUrl =>
      'Debe ser una URL válida que comience con http:// o https://';

  @override
  String get myOPNsenseRouter => 'Mi Router OPNsense';

  @override
  String get myOpenvpnInstance => 'Mi instancia OpenVPN';

  @override
  String get myStaticKey => 'Mi Clave Estática';

  @override
  String get myWireguardPeer => 'Mi peer WireGuard';

  @override
  String get myWireguardServer => 'Mi servidor WireGuard';

  @override
  String get name => 'Nombre';

  @override
  String get needHelpCheckDocumentation =>
      '¿Necesita ayuda? Consulte la documentación de OPNsense para la generación de claves API.';

  @override
  String get networkConfiguration => 'Configuración de Red';

  @override
  String get networkError => 'Ocurrió un error de red';

  @override
  String get networkInformation => 'Información de red';

  @override
  String get networkTotals => 'Totales de Red';

  @override
  String get newPin => 'Nuevo PIN (4-6 dígitos)';

  @override
  String get newPinMustBeDifferent =>
      'El nuevo PIN debe ser diferente del actual';

  @override
  String get newRule => 'Nueva Regla';

  @override
  String get newWireguardPeer => 'Nuevo peer WireGuard';

  @override
  String get newWireguardServer => 'Nuevo servidor WireGuard';

  @override
  String get next => 'Siguiente';

  @override
  String get no => 'No';

  @override
  String get noAliasesConfigured => 'No hay alias configurados';

  @override
  String get noAliasesMatchFilters =>
      'Ningún alias coincide con los filtros actuales';

  @override
  String get noAutomationRulesFound =>
      'No se encontraron reglas de automatización';

  @override
  String get noClientSpecificOverridesConfigured =>
      'No hay anulaciones específicas del cliente configuradas';

  @override
  String noConnectionsFound(String type) {
    return 'No se encontraron conexiones $type';
  }

  @override
  String get noDataAvailable => 'No hay datos disponibles';

  @override
  String get noDescription => 'Sin Descripción';

  @override
  String get noDnsDomainSearchEntriesConfigured =>
      'No hay entradas de búsqueda de dominios DNS configuradas';

  @override
  String get noDnsDomainsConfigured => 'No hay dominios DNS configurados';

  @override
  String get noDnsServersConfigured => 'No hay servidores DNS configurados';

  @override
  String get noHostsFound => 'No se encontraron hosts';

  @override
  String get noInstancesMatchFilters =>
      'Ninguna instancia coincide con los filtros';

  @override
  String get noInterfacesWithAutomationRules =>
      'No hay interfaces con reglas de automatización';

  @override
  String get noItemsConfigured => 'No hay elementos configurados';

  @override
  String get noLeasesFound => 'No se encontraron arrendamientos';

  @override
  String get noLimit => 'Sin Límite';

  @override
  String get noLimitShort => 'Todos';

  @override
  String get noLocalNetworksConfigured => 'No hay redes locales configuradas';

  @override
  String get noLogEntriesFound => 'No se encontraron entradas de registro';

  @override
  String get noLogsAvailable => 'No hay registros disponibles';

  @override
  String get noLogsToExport => 'No hay registros para exportar';

  @override
  String get noNtpServersConfigured => 'No hay servidores NTP configurados';

  @override
  String get noOpenvpnInstancesConfigured =>
      'No hay instancias OpenVPN configuradas';

  @override
  String get noOpenvpnRoutesConfigured => 'No hay rutas OpenVPN configuradas';

  @override
  String get noOpenvpnSessionsConfigured =>
      'No hay sesiones OpenVPN configuradas';

  @override
  String get noOptionsAvailable => 'No hay opciones disponibles';

  @override
  String get noOverridesMatchFilter =>
      'Ninguna anulación coincide con el filtro';

  @override
  String get noPeersAvailable => 'No hay peers disponibles';

  @override
  String get noPeersMatchSearch => 'Ningún peer coincide con su búsqueda';

  @override
  String get noProfiles => 'Sin Perfiles';

  @override
  String get noProfilesFound => 'No se encontraron perfiles';

  @override
  String get noProfilesYet => 'Aún No Hay Perfiles';

  @override
  String get noRemoteNetworksConfigured => 'No hay redes remotas configuradas';

  @override
  String get noRoutesConfigured => 'No hay rutas configuradas';

  @override
  String noRulesForInterface(String interface) {
    return 'No hay reglas para $interface';
  }

  @override
  String get noServersAvailable => 'No hay servidores disponibles';

  @override
  String get noServersMatchSearch => 'Ningún servidor coincide con su búsqueda';

  @override
  String get noServersSelected => 'No hay servidores seleccionados';

  @override
  String get noSessionsFound => 'No se encontraron sesiones';

  @override
  String get noSettingsAvailable => 'No hay configuraciones disponibles';

  @override
  String get noStaticKeysConfigured => 'No hay claves estáticas configuradas';

  @override
  String get noSubnetsConfigured => 'No hay subredes configuradas';

  @override
  String get noTunnelAddressesConfigured =>
      'No hay direcciones de túnel configuradas';

  @override
  String get noVpnConnectionsFound => 'No se encontraron conexiones VPN';

  @override
  String get noWinsServersConfigured => 'No hay servidores WINS configurados';

  @override
  String get noWireguardPeersConfigured =>
      'No hay peers WireGuard configurados';

  @override
  String get noWireguardServersConfigured =>
      'No hay servidores WireGuard configurados';

  @override
  String get noWireguardStatusDataAvailable =>
      'No hay datos de estado de WireGuard disponibles';

  @override
  String get noWolHostsConfigured => 'No hay hosts Wake on LAN configurados';

  @override
  String get none => 'Ninguno';

  @override
  String get notAvailable => 'N/D';

  @override
  String get notFound => 'Recurso no encontrado';

  @override
  String get notice => 'Aviso';

  @override
  String get ntpServers => 'Servidores NTP';

  @override
  String get ntpServersHelperText =>
      'Establecer dirección del servidor NTP principal (Protocolo de Tiempo de Red). Repita esta opción para establecer direcciones de servidores NTP secundarios.';

  @override
  String get offline => 'Fuera de Línea';

  @override
  String get ok => 'Aceptar';

  @override
  String get oneHour => '1 hora';

  @override
  String get oneMin => '1 min';

  @override
  String get online => 'En Línea';

  @override
  String get openvpnConnectionStatus => 'Estado de conexión OpenVPN';

  @override
  String get openvpnInstances => 'Instancias de OpenVPN';

  @override
  String get openvpnLogFile => 'Archivo de Registro OpenVPN';

  @override
  String get optional => 'Opcional';

  @override
  String get optionalBase64EncodedPresharedKey =>
      'Clave precompartida codificada en Base64 opcional';

  @override
  String get outbound => 'Saliente';

  @override
  String get overrideCreatedSuccessfully => 'Anulación creada exitosamente';

  @override
  String get overrideDeletedSuccessfully => 'Anulación eliminada exitosamente';

  @override
  String get overrideDetails => 'Detalles de la Anulación';

  @override
  String overrideToggledSuccessfully(String status) {
    return 'Anulación $status exitosamente';
  }

  @override
  String get overrideUpdatedSuccessfully =>
      'Anulación actualizada exitosamente';

  @override
  String get overwrite => 'Sobrescribir';

  @override
  String get packageMirror => 'Espejo de Paquetes';

  @override
  String get packetLength => 'Longitud del paquete';

  @override
  String get pass => 'Permitir';

  @override
  String get pause => 'Pausar';

  @override
  String get pauseLiveViewToSelect =>
      'Pausa la vista en vivo para seleccionar entradas de registro';

  @override
  String get paused => 'Pausado';

  @override
  String get peerCreatedReadyForNext =>
      'Peer creado exitosamente. Listo para el siguiente peer.';

  @override
  String get peerCreatedSuccessfully => 'Peer creado exitosamente';

  @override
  String get peerDeletedSuccessfully => 'Peer eliminado exitosamente';

  @override
  String get peerDisabledSuccessfully => 'Peer deshabilitado exitosamente';

  @override
  String get peerEnabledSuccessfully => 'Peer habilitado exitosamente';

  @override
  String get peerGenerator => 'Generador de peers';

  @override
  String get peerUpdatedSuccessfully => 'Peer actualizado exitosamente';

  @override
  String get peerWillBeActiveWhenEnabled =>
      'El peer estará activo cuando esté habilitado';

  @override
  String get peers => 'Pares';

  @override
  String peersConfigured(int count) {
    return '$count peer(s) configurado(s)';
  }

  @override
  String get peersCount => 'Cantidad de Pares';

  @override
  String peersSelected(int count) {
    return '$count par(es) seleccionado(s)';
  }

  @override
  String get persistentKeepaliveSeconds =>
      'Mantener vivo persistente en segundos (recomendado: 25)';

  @override
  String get pinChangedSuccessfully => 'PIN cambiado exitosamente';

  @override
  String get pinLock => 'Bloqueo PIN';

  @override
  String get pinLockDisabled =>
      'Bloqueo PIN deshabilitado. Bloqueo biométrico también deshabilitado.';

  @override
  String get pinLockEnabled => 'Bloqueo PIN habilitado';

  @override
  String get pinMismatch => 'Los PIN no coinciden';

  @override
  String get pinMustContainOnlyNumbers => 'El PIN debe contener solo números';

  @override
  String get pinTooShort => 'El PIN debe tener al menos 4 dígitos';

  @override
  String get platform => 'Plataforma';

  @override
  String get pleaseEnterCurrentPin => 'Por favor ingrese su PIN actual';

  @override
  String get pleaseEnterNewPin => 'Por favor ingrese un nuevo PIN';

  @override
  String get pleaseEnterSubnet => 'Por favor ingrese una subred';

  @override
  String get pleaseEnterYourPin => 'Por favor ingrese su PIN';

  @override
  String get pleaseSelectAnInstance => 'Por favor seleccione una instancia';

  @override
  String get pleaseSelectInterface => 'Por favor seleccione una interfaz';

  @override
  String get port => 'Puerto';

  @override
  String get portHint => 'ej., 443';

  @override
  String get portIsRequired => 'El puerto es obligatorio';

  @override
  String portLabel(String port) {
    return 'Puerto: $port';
  }

  @override
  String get portMustBeBetween => 'El puerto debe estar entre 1 y 65535';

  @override
  String get preAuthKey => 'Clave de Pre-Autenticación';

  @override
  String get preAuthKeyHelperText =>
      'Opcional: Clave de pre-autenticación para registro automático de dispositivos';

  @override
  String get presharedKeyGeneratedSuccessfully =>
      'Clave precompartida generada exitosamente';

  @override
  String get presharedKeyOptional => 'Clave precompartida (Opcional)';

  @override
  String get preventAutomaticRouteInstallation =>
      'Prevenir la instalación automática de rutas';

  @override
  String get previous => 'Anterior';

  @override
  String get privateKey => 'Clave privada';

  @override
  String get profileActivated => 'Perfil activado exitosamente';

  @override
  String get profileAdded => 'Perfil agregado';

  @override
  String get profileDeleted => 'Perfil eliminado exitosamente';

  @override
  String get profileHasNoEndpoints =>
      'El perfil no tiene puntos de conexión configurados';

  @override
  String get profileName => 'Nombre del Perfil';

  @override
  String get profileNameOptional => 'Nombre del Perfil (Opcional)';

  @override
  String get profileNameRequired => 'El nombre del perfil es obligatorio';

  @override
  String get profileSaved => 'Perfil guardado exitosamente';

  @override
  String get profileUpdated => 'Perfil actualizado';

  @override
  String get profiles => 'Perfiles';

  @override
  String profilesExportedSuccessfully(String path) {
    return '¡Perfiles exportados exitosamente!\n$path';
  }

  @override
  String get protocol => 'Protocolo';

  @override
  String get publicKey => 'Clave pública';

  @override
  String get publicKeyColon => 'Clave pública:';

  @override
  String get publicKeyRequired => 'Se requiere clave pública';

  @override
  String publicKeyShort(String key) {
    return '$key...';
  }

  @override
  String get pushReset => 'Restablecer push';

  @override
  String get pushVirtualIpEndpoints =>
      'Enviar puntos finales de IP virtual para el túnel del cliente, anulando la asignación dinámica.';

  @override
  String get qrCode => 'Código QR';

  @override
  String get reason => 'Razón';

  @override
  String get rebootConfirmation =>
      '¿Está seguro de que desea reiniciar el sistema?';

  @override
  String get rebootFailed => 'Error al reiniciar el sistema';

  @override
  String rebootFailedWithError(String message, String error) {
    return '$message: $error';
  }

  @override
  String get rebootSuccess => 'Reinicio del sistema iniciado';

  @override
  String get rebootSystem => 'Reiniciar Sistema';

  @override
  String get received => 'Recibido';

  @override
  String get recommendedForSecureConnections =>
      'Recomendado para conexiones seguras';

  @override
  String get redirectGateway => 'Redirigir puerta de enlace';

  @override
  String get refresh => 'Actualizar';

  @override
  String get registerDns => 'Registrar DNS';

  @override
  String get reject => 'Rechazar';

  @override
  String get remoteAddress => 'Dirección Remota';

  @override
  String get remoteNetwork => 'Red Remota';

  @override
  String get remoteNetworkHelperText =>
      'Redes remotas para el servidor, se configuran a través de cláusulas iroute(-ipv6) en OpenVPN e informan al servidor que envíe estas redes a este cliente específico.';

  @override
  String get repository => 'Repositorio';

  @override
  String get requirePinToUnlock =>
      'Requiere PIN para desbloquear la aplicación';

  @override
  String get required => 'Requerido';

  @override
  String get restart => 'Reiniciar';

  @override
  String get restartService => 'Reiniciar Servicio';

  @override
  String restartServiceConfirmation(String type) {
    return '¿Está seguro de que desea reiniciar el servicio $type?\n\nEsto desconectará temporalmente todas las conexiones activas.';
  }

  @override
  String get restartVpnService => 'Reiniciar servicio VPN';

  @override
  String restartingService(String type) {
    return 'Reiniciando servicio $type...';
  }

  @override
  String get resume => 'Reanudar';

  @override
  String get retry => 'Reintentar';

  @override
  String get role => 'Rol';

  @override
  String get routeGateway => 'Puerta de enlace de ruta';

  @override
  String get routeGatewayHelperText =>
      'Especifique una puerta de enlace predeterminada para usar para el cliente conectado. Sin una configurada, se ofrece la primera dirección en el bloque de red. Al segmentar la red del túnel (servidor), es posible que esta no sea accesible desde el cliente.';

  @override
  String get routes => 'Rutas';

  @override
  String get routing => 'Enrutamiento';

  @override
  String get rowsPerPageLabel => 'Filas por página: ';

  @override
  String get ruleActionFailed => 'Acción de regla fallida';

  @override
  String get ruleCreated => 'Regla creada exitosamente';

  @override
  String get ruleDeleted => 'Regla eliminada exitosamente';

  @override
  String get ruleDescription => 'Descripción de la regla';

  @override
  String get ruleDetails => 'Detalles de la regla';

  @override
  String get ruleDisabledSuccessfully => 'Regla desactivada correctamente';

  @override
  String get ruleEnabledSuccessfully => 'Regla activada correctamente';

  @override
  String get ruleGuidelines => 'Directrices de Reglas';

  @override
  String get ruleGuidelinesText =>
      '• Use \"any\" para coincidir con todas las direcciones o puertos\n• Notación CIDR: 192.168.1.0/24\n• Rangos de puertos: 80-443\n• Las reglas se procesan en orden secuencial\n• Los cambios se aplican inmediatamente';

  @override
  String get ruleId => 'ID de regla';

  @override
  String get ruleInformation => 'Información de la regla';

  @override
  String get ruleUpdated => 'Regla actualizada exitosamente';

  @override
  String get ruleWillBeActiveWhenEnabled =>
      'La regla estará activa cuando esté habilitada';

  @override
  String get running => 'En Ejecución';

  @override
  String get save => 'Guardar';

  @override
  String get saveAndConnect => 'Guardar y conectar';

  @override
  String get saveSettings => 'Guardar Configuración';

  @override
  String get saveWithoutTesting => 'Guardar sin probar';

  @override
  String get saving => 'Guardando...';

  @override
  String get savingOverride => 'Guardando anulación...';

  @override
  String get savingProfile => 'Guardando perfil...';

  @override
  String get searchAliases => 'Buscar alias...';

  @override
  String get searchHostnameIpOrMac => 'Buscar nombre de host, IP o MAC...';

  @override
  String get searchHostnameOrIp => 'Buscar nombre de host o dirección IP...';

  @override
  String get searchInstances => 'Buscar instancias...';

  @override
  String get searchOverrides => 'Buscar anulaciones...';

  @override
  String get searchPeers => 'Buscar peers...';

  @override
  String get searchServers => 'Buscar servidores...';

  @override
  String get second => 'segundo';

  @override
  String get seconds => 'Segundos';

  @override
  String get security => 'Seguridad';

  @override
  String get securityWarning => 'Advertencia de seguridad';

  @override
  String get selectAProfileOrCreateNewOne =>
      'Seleccione un perfil o cree uno nuevo';

  @override
  String get selectAll => 'Seleccionar todo';

  @override
  String get selectExitNode => 'Seleccionar nodo de salida';

  @override
  String get selectInterface => 'Seleccionar interfaz';

  @override
  String get selectInterfaceToViewRules =>
      'Seleccione una interfaz para ver las reglas';

  @override
  String selectLabel(String label) {
    return 'Seleccionar $label';
  }

  @override
  String get selectMultipleInterfaces =>
      'Seleccione una o más interfaces para monitorear';

  @override
  String get selectNumberOfEntries =>
      'Seleccione el número de entradas de registro para mostrar:';

  @override
  String get selectPeers => 'Seleccionar Peers';

  @override
  String get selectServerAndGenerateKeys =>
      'Seleccione un servidor y genere claves para previsualizar la configuración';

  @override
  String get selectServerForQrCode =>
      'Seleccionar servidor para generar código QR';

  @override
  String get selectServerInstance =>
      'Por favor seleccione una instancia de servidor';

  @override
  String get selectServers => 'Seleccionar Servidores';

  @override
  String get selectServersHelperText =>
      'Seleccione los servidores OpenVPN donde se aplica esta anulación, déjelo vacío para todos';

  @override
  String get selectVhid => 'Seleccionar VHID';

  @override
  String get selected => 'seleccionado';

  @override
  String get selfSignedCertWarning =>
      'Advertencia: Los certificados autofirmados son menos seguros. Solo habilite esto si confía en el servidor.';

  @override
  String get selfSignedCertificatesWarning =>
      'Solo habilite esto si confía en el servidor';

  @override
  String get sent => 'Enviado';

  @override
  String get sequence => 'Secuencia';

  @override
  String get server => 'Servidor';

  @override
  String get serverAddress => 'Dirección del servidor';

  @override
  String get serverCreatedSuccessfully => 'Servidor creado exitosamente';

  @override
  String get serverDeletedSuccessfully => 'Servidor eliminado exitosamente';

  @override
  String get serverDisabledSuccessfully =>
      'Servidor deshabilitado exitosamente';

  @override
  String get serverEnabledSuccessfully => 'Servidor habilitado exitosamente';

  @override
  String get serverError => 'Ocurrió un error del servidor';

  @override
  String get serverInfoNotLoaded => 'Información del servidor no cargada';

  @override
  String get serverNetwork => 'Red del Servidor';

  @override
  String get serverPort => 'Puerto del servidor';

  @override
  String get serverSelectionRequired =>
      'Se debe seleccionar al menos un servidor';

  @override
  String get serverUpdatedSuccessfully => 'Servidor actualizado exitosamente';

  @override
  String get serverWillBeActiveWhenEnabled =>
      'El servidor estará activo cuando esté habilitado';

  @override
  String get servers => 'Servidores';

  @override
  String serversSelected(int count) {
    return '$count servidor(es) seleccionado(s)';
  }

  @override
  String get serviceActionFailed => 'Acción del servicio fallida';

  @override
  String get serviceControls => 'Controles de Servicio';

  @override
  String get serviceRestartedSuccessfully => 'Servicio reiniciado exitosamente';

  @override
  String get serviceRunning => 'Servicio en Ejecución';

  @override
  String get serviceStartedSuccessfully => 'Servicio iniciado exitosamente';

  @override
  String get serviceStatus => 'Estado del Servicio';

  @override
  String get serviceStoppedSuccessfully => 'Servicio detenido exitosamente';

  @override
  String get services => 'Servicios';

  @override
  String get sessionTimeout => 'Tiempo de Espera de Sesión';

  @override
  String get sessions => 'Sesiones';

  @override
  String get setAsActive => 'Establecer como activo';

  @override
  String get setPin => 'Establecer PIN';

  @override
  String get settings => 'Configuración';

  @override
  String severitiesAndTimeFilter(int count, String timeFilter) {
    return '$count severidades • $timeFilter';
  }

  @override
  String get severity => 'Gravedad';

  @override
  String get severityEmergency => 'Emergencia';

  @override
  String get severityEmergencyShort => 'Emerg';

  @override
  String get severityError => 'Error';

  @override
  String get severityInformational => 'Informativo';

  @override
  String get severityInformationalShort => 'Info';

  @override
  String get showAdvancedSettings => 'Mostrar Configuración Avanzada';

  @override
  String get showAll => 'Mostrar Todo';

  @override
  String get showKey => 'Mostrar clave';

  @override
  String showingInstancesCount(String count, String total) {
    return 'Mostrando $count de $total';
  }

  @override
  String get showingZeroEntries => 'Mostrando 0 entradas';

  @override
  String get someConnectionsFailed => 'Algunas conexiones fallaron';

  @override
  String get soon => 'pronto';

  @override
  String get sortBy => 'Ordenar por';

  @override
  String get sortByBandwidth => 'Ancho de Banda';

  @override
  String get sortByHostname => 'Nombre de Host';

  @override
  String get sortByIP => 'Dirección IP';

  @override
  String get sortByManufacturer => 'Fabricante';

  @override
  String get source => 'Origen';

  @override
  String get sourceAddress => 'Dirección de origen';

  @override
  String get sourceIsRequired => 'El origen es obligatorio';

  @override
  String get sourcePort => 'Puerto de Origen';

  @override
  String get sourcePortOptional => 'Puerto de Origen (Opcional)';

  @override
  String get sshEnabled => 'SSH Habilitado';

  @override
  String get start => 'Iniciar';

  @override
  String get startService => 'Iniciar Servicio';

  @override
  String get startTime => 'Hora de inicio';

  @override
  String get startWireguardService => 'Iniciar servicio WireGuard';

  @override
  String get staticKeyContentPemFormat =>
      'Contenido de clave estática en formato PEM';

  @override
  String get staticKeyCreatedSuccessfully =>
      'Clave estática creada exitosamente';

  @override
  String get staticKeyDeletedSuccessfully =>
      'Clave estática eliminada exitosamente';

  @override
  String get staticKeyDetails => 'Detalles de la Clave Estática';

  @override
  String get staticKeyInformation => 'Información de la Clave Estática';

  @override
  String get staticKeyUpdatedSuccessfully =>
      'Clave estática actualizada exitosamente';

  @override
  String get staticKeys => 'Claves Estáticas';

  @override
  String get staticLease => 'Estático';

  @override
  String get status => 'Estado';

  @override
  String get stop => 'Detener';

  @override
  String get stopService => 'Detener Servicio';

  @override
  String get stopped => 'Detenido';

  @override
  String get storeAndGenerateNext => 'Guardar y generar siguiente';

  @override
  String get subnetAddedSuccessfully => 'Subred agregada exitosamente';

  @override
  String get subnetCidr => 'Subred (CIDR)';

  @override
  String get subnetDeletedSuccessfully => 'Subred eliminada exitosamente';

  @override
  String get subnetUpdatedSuccessfully => 'Subred actualizada exitosamente';

  @override
  String get success => 'Éxito';

  @override
  String successfullyConnected(String name) {
    return 'Conectado exitosamente a $name';
  }

  @override
  String successfullyDisconnected(String name) {
    return 'Desconectado exitosamente de $name';
  }

  @override
  String successfullyImportedProfiles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'perfiles',
      one: 'perfil',
    );
    return 'Se importaron exitosamente $count $_temp0';
  }

  @override
  String successfullyRestartedService(String type) {
    return 'Servicio $type reiniciado exitosamente';
  }

  @override
  String successfullyWokenDevices(int successCount, int totalCount) {
    String _temp0 = intl.Intl.pluralLogic(
      successCount,
      locale: localeName,
      other: 'despertaron exitosamente $successCount dispositivos',
      one: 'despertó exitosamente $successCount dispositivo',
    );
    return 'Se $_temp0 de $totalCount';
  }

  @override
  String get switchProfile => 'Cambiar Perfil';

  @override
  String get switchProfileConfirmation =>
      '¿Está seguro de que desea cambiar de perfil? Será devuelto a la pantalla de selección de perfil.';

  @override
  String get systemDefault => 'Predeterminado del Sistema';

  @override
  String get systemGeneratedRule =>
      'Esta es una regla generada por el sistema y no se puede modificar ni eliminar.';

  @override
  String get systemGeneratedRulesCannotBeDeleted =>
      'Las reglas generadas por el sistema no se pueden eliminar';

  @override
  String get systemGeneratedRulesCannotBeModified =>
      'Las reglas generadas por el sistema no se pueden modificar';

  @override
  String get systemInformation => 'Información del Sistema';

  @override
  String get systemType => 'Tipo de Sistema';

  @override
  String get tags => 'Etiquetas';

  @override
  String get tailscaleAuthentication => 'Autenticación de Tailscale';

  @override
  String tailscaleServiceAction(String action) {
    return '$action Servicio Tailscale';
  }

  @override
  String tailscaleServiceActionConfirmation(String action) {
    return '¿Está seguro de que desea $action el servicio Tailscale?';
  }

  @override
  String tailscaleServiceActionSuccess(String action) {
    return 'Servicio Tailscale ${action}ado exitosamente';
  }

  @override
  String tailscaleServiceActioning(String action) {
    return '${action}ando servicio Tailscale...';
  }

  @override
  String get tailscaleSettings => 'Configuración de Tailscale';

  @override
  String get tailscaleStatus => 'Estado de Tailscale';

  @override
  String get tailscaleSubnets => 'Subredes de Tailscale';

  @override
  String get tailscaleVersion => 'Versión';

  @override
  String get tapPlusButtonToCreateFirstInstance =>
      'Toque el botón + para crear su primera instancia';

  @override
  String get tapPlusButtonToCreateFirstOverride =>
      'Toque el botón + para crear su primera anulación';

  @override
  String get tapPlusButtonToCreateFirstStaticKey =>
      'Toque el botón + para crear su primera clave estática';

  @override
  String get tcpFlags => 'Banderas TCP';

  @override
  String get tenMin => '10 min';

  @override
  String get testConnection => 'Probar Conexión';

  @override
  String get testConnections => 'Probar conexiones';

  @override
  String get testProfile => 'Probar perfil';

  @override
  String get testingAllConnections =>
      'Probando todos los puntos de conexión...';

  @override
  String testingConnection(String current, String total, String endpoint) {
    return 'Probando conexión $current de $total: $endpoint';
  }

  @override
  String get theme => 'Tema';

  @override
  String get thirtyMin => '30 min';

  @override
  String get time => 'Tiempo';

  @override
  String get timeRange => 'Rango de tiempo';

  @override
  String get timeout => 'Tiempo de espera agotado';

  @override
  String get timestamp => 'Marca de tiempo';

  @override
  String get today => 'Hoy';

  @override
  String get totalBandwidth => 'Ancho de Banda Total';

  @override
  String get totalDownload => 'Descarga Total';

  @override
  String get totalEntries => 'Entradas totales';

  @override
  String get totalUpload => 'Carga Total';

  @override
  String get totalVpns => 'Total de VPN';

  @override
  String get tryAdjustingFilters =>
      'Intente ajustar los filtros de severidad o fecha seleccionados.';

  @override
  String get tryDemoMode => 'Probar modo de demostración';

  @override
  String get tryDifferentSearch =>
      'Intente con un término de búsqueda diferente';

  @override
  String get tunnelAddress => 'Dirección del túnel';

  @override
  String get tunnelAddressCidr => 'Dirección del túnel (CIDR)';

  @override
  String get tunnelAddresses => 'Direcciones del túnel';

  @override
  String tunnelLabel(String network) {
    return 'Túnel: $network';
  }

  @override
  String get tunnelNetwork => 'Red del Túnel';

  @override
  String get tunnelSettings => 'Configuración del Túnel';

  @override
  String get twoMin => '2 min';

  @override
  String get type => 'Tipo';

  @override
  String typeWithValue(String value) {
    return 'Tipo: $value';
  }

  @override
  String get udpPortDefault51820 => 'Puerto UDP (predeterminado: 51820)';

  @override
  String get unableToAccessFilePath =>
      'No se puede acceder a la ruta del archivo';

  @override
  String get unableToConnectToAnyEndpoint =>
      'No se pudo conectar a ninguno de los puntos finales configurados. Por favor, verifique su configuración de red e intente nuevamente.';

  @override
  String get unauthorized => 'Acceso no autorizado';

  @override
  String get unknown => 'Desconocido';

  @override
  String get unlock => 'Desbloquear';

  @override
  String get unlockOpnsenseManager => 'Desbloquear OPNsense Manager';

  @override
  String get unnamedHost => 'Host sin nombre';

  @override
  String get unnamedInstance => 'Instancia sin Nombre';

  @override
  String get unnamedRule => 'Regla sin nombre';

  @override
  String get unsavedChanges => 'Cambios No Guardados';

  @override
  String get unsavedChangesConfirmation =>
      'Tiene cambios no guardados. ¿Desea descartarlos y continuar?';

  @override
  String get update => 'Actualizar';

  @override
  String get updateOverride => 'Actualizar Anulación';

  @override
  String get updatePeer => 'Actualizar peer';

  @override
  String get updatePinCode => 'Actualizar su código PIN';

  @override
  String get updateRule => 'Actualizar Regla';

  @override
  String get updateServer => 'Actualizar servidor';

  @override
  String get updateStaticKey => 'Actualizar Clave Estática';

  @override
  String get upload => 'Carga';

  @override
  String get uptime => 'Tiempo de Actividad';

  @override
  String get useBiometric => 'Usar Biométrico';

  @override
  String useBiometricToUnlock(String biometricType) {
    return 'Usar $biometricType para desbloquear la aplicación';
  }

  @override
  String get useExitNode => 'Usar Nodo de Salida';

  @override
  String get useHttps => 'Usar HTTPS';

  @override
  String get useHttpsDescription => 'Usar conexión HTTPS segura';

  @override
  String get useProtocolForCommunicating =>
      'Usar este protocolo para comunicarse';

  @override
  String get valid => 'Válido';

  @override
  String get validFrom => 'Válido desde';

  @override
  String verifyingConnection(String endpoint) {
    return 'Verificando conexión a $endpoint...';
  }

  @override
  String version(String version) {
    return 'Versión $version';
  }

  @override
  String get versionLabel => 'Versión';

  @override
  String get viewDetails => 'Ver detalles';

  @override
  String get viewFullLicense => 'Ver Licencia Completa';

  @override
  String get virtualAddress => 'Dirección Virtual';

  @override
  String get vpn => 'VPN';

  @override
  String get vpnConnections => 'Conexiones VPN';

  @override
  String get vpnConnectionsWillAppear =>
      'Las conexiones VPN aparecerán aquí cuando se configuren';

  @override
  String get vpnStatus => 'Estado VPN';

  @override
  String get vpnType => 'Tipo de VPN';

  @override
  String get wakeAll => 'Despertar todos';

  @override
  String get wakeAllDevices => 'Despertar todos los dispositivos';

  @override
  String get wakeAllDevicesConfirmation =>
      '¿Está seguro de que desea enviar paquetes de activación a todos los dispositivos configurados?';

  @override
  String get wakeAllResults => 'Resultados de despertar todos';

  @override
  String get wakeHost => 'Despertar host';

  @override
  String get wakeOnLan => 'Wake on LAN';

  @override
  String get wakingAllDevices => 'Despertando todos los dispositivos...';

  @override
  String get warning => 'Advertencia';

  @override
  String get winsServers => 'Servidores WINS';

  @override
  String get winsServersHelperText =>
      'Establecer dirección del servidor WINS principal (Servidor de Nombres NetBIOS sobre TCP/IP). Repita esta opción para establecer direcciones de servidores WINS secundarios.';

  @override
  String get wireguardLogs => 'Registros de WireGuard';

  @override
  String get wireguardLogsExport => 'Exportar registros de WireGuard';

  @override
  String wireguardLogsExportedOn(String date) {
    return 'Registros de WireGuard exportados el $date';
  }

  @override
  String get wireguardPeers => 'Peers de WireGuard';

  @override
  String get wireguardServers => 'Servidores WireGuard';

  @override
  String get wireguardServiceStarted => 'Servicio WireGuard iniciado';

  @override
  String get wireguardServiceStopped => 'Servicio WireGuard detenido';

  @override
  String get wireguardStatus => 'Estado de WireGuard';

  @override
  String get withoutCredentials => 'Sin Credenciales';

  @override
  String wolPacketSentTo(String host) {
    return 'Paquete WOL enviado a $host';
  }

  @override
  String get yes => 'Sí';

  @override
  String get yesterday => 'Ayer';

  @override
  String get zeroSeconds => '0 segundos';

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
  String get actualUsed => 'Uso real';

  @override
  String get arcCache => 'Caché ARC';

  @override
  String get demoModeIndicator => 'Modo demo - Mostrando datos de muestra';

  @override
  String get thermalSensors => 'Sensores térmicos';

  @override
  String get noThermalSensorsAvailable =>
      'No hay sensores térmicos disponibles';

  @override
  String get collapseAll => 'Contraer todo';

  @override
  String get expandAll => 'Expandir todo';

  @override
  String get savingInstance => 'Guardando instancia...';

  @override
  String get staticKeyDescriptionHelper =>
      'Un nombre descriptivo para esta clave estática';

  @override
  String get selectKeyModeHelper =>
      'Seleccione el modo de clave para autenticación o cifrado';

  @override
  String get staticKeyHelpText =>
      '• Auth: Agrega autenticación HMAC al canal de control\n• Crypt: Cifra y autentica todos los paquetes del canal de control\n• Crypt V2: Cifrado mejorado con mayor seguridad\n\nPuede generar una nueva clave o pegar una existente.';

  @override
  String get device => 'Dispositivo';

  @override
  String get listenPort => 'Puerto de escucha';

  @override
  String get fwMark => 'Marca FW';

  @override
  String get peerStatus => 'Estado del par';

  @override
  String get handshakeAge => 'Antigüedad del handshake';

  @override
  String secondsAgo(int count) {
    return 'hace $count segundos';
  }

  @override
  String get handshake => 'Handshake';

  @override
  String get processInformation => 'Información del proceso';

  @override
  String get processName => 'Nombre del proceso';

  @override
  String get processId => 'ID del proceso';

  @override
  String get logMessage => 'Mensaje del registro';

  @override
  String get message => 'Mensaje';

  @override
  String get timestampInformation => 'Información de marca temporal';

  @override
  String get rawTimestamp => 'Marca temporal sin procesar';
}
