// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'Administrador OPNsense';

  @override
  String get dashboard => 'Panel de Control';

  @override
  String get firewallRules => 'Reglas del Cortafuegos';

  @override
  String get firewallLogs => 'Registros del Cortafuegos';

  @override
  String get systemInfo => 'Información del Sistema';

  @override
  String get vpnConnections => 'Conexiones VPN';

  @override
  String get settings => 'Configuración';

  @override
  String get hostname => 'Nombre del Host';

  @override
  String get versionLabel => 'Versión';

  @override
  String get platform => 'Plataforma';

  @override
  String get uptime => 'Tiempo de Actividad';

  @override
  String get cpuUsage => 'Uso de CPU';

  @override
  String get memoryUsage => 'Uso de Memoria';

  @override
  String get services => 'Servicios';

  @override
  String get gateways => 'Puertas de Enlace';

  @override
  String get running => 'En Ejecución';

  @override
  String get stopped => 'Detenido';

  @override
  String get online => 'En Línea';

  @override
  String get offline => 'Fuera de Línea';

  @override
  String get start => 'Iniciar';

  @override
  String get stop => 'Detener';

  @override
  String get restart => 'Reiniciar';

  @override
  String get enable => 'Habilitar';

  @override
  String get disable => 'Deshabilitar';

  @override
  String get delete => 'Eliminar';

  @override
  String get edit => 'Editar';

  @override
  String get save => 'Guardar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get ok => 'Aceptar';

  @override
  String get yes => 'Sí';

  @override
  String get no => 'No';

  @override
  String get close => 'Cerrar';

  @override
  String get refresh => 'Actualizar';

  @override
  String get apply => 'Aplicar';

  @override
  String get login => 'Iniciar Sesión';

  @override
  String get logout => 'Cerrar Sesión';

  @override
  String get host => 'Host';

  @override
  String get port => 'Puerto';

  @override
  String get apiKey => 'Clave API';

  @override
  String get apiSecret => 'Secreto API';

  @override
  String get useHttps => 'Usar HTTPS';

  @override
  String get allowSelfSigned => 'Permitir Certificado Autofirmado';

  @override
  String get testConnection => 'Probar Conexión';

  @override
  String get connectionSuccessful => 'Conexión Exitosa';

  @override
  String get connectionFailed =>
      'Conexión fallida. Verifique los registros de la consola para más detalles.\n\nProblemas comunes:\n• El dispositivo no está en la misma red que OPNsense\n• Dirección IP o puerto incorrectos\n• Firewall bloqueando la conexión\n• Credenciales API inválidas';

  @override
  String get profiles => 'Perfiles';

  @override
  String get addProfile => 'Agregar Perfil';

  @override
  String get editProfile => 'Editar Perfil';

  @override
  String get deleteProfile => 'Eliminar Perfil';

  @override
  String get profileName => 'Nombre del Perfil';

  @override
  String get activeProfile => 'Perfil Activo';

  @override
  String get switchProfile => 'Cambiar Perfil';

  @override
  String get exportProfiles => 'Exportar Perfiles';

  @override
  String get importProfiles => 'Importar Perfiles';

  @override
  String get security => 'Seguridad';

  @override
  String get pinLock => 'Bloqueo PIN';

  @override
  String get changePIN => 'Cambiar PIN';

  @override
  String get biometricAuth => 'Autenticación Biométrica';

  @override
  String get sessionTimeout => 'Tiempo de Espera de Sesión';

  @override
  String get lockApp => 'Bloquear Aplicación';

  @override
  String get appearance => 'Apariencia';

  @override
  String get theme => 'Tema';

  @override
  String get language => 'Idioma';

  @override
  String get lightMode => 'Modo Claro';

  @override
  String get darkMode => 'Modo Oscuro';

  @override
  String get systemDefault => 'Predeterminado del Sistema';

  @override
  String get general => 'General';

  @override
  String get about => 'Acerca de';

  @override
  String get licenses => 'Licencias';

  @override
  String get firewallRuleDetails => 'Detalles de la Regla del Cortafuegos';

  @override
  String get createRule => 'Crear Regla';

  @override
  String get editRule => 'Editar Regla';

  @override
  String get deleteRule => 'Eliminar Regla';

  @override
  String get action => 'Acción';

  @override
  String get interface => 'Interfaz';

  @override
  String get protocol => 'Protocolo';

  @override
  String get source => 'Origen';

  @override
  String get destination => 'Destino';

  @override
  String get sourcePort => 'Puerto de Origen';

  @override
  String get destinationPort => 'Puerto de Destino';

  @override
  String get description => 'Descripción';

  @override
  String get enabled => 'Habilitado';

  @override
  String get disabled => 'Deshabilitado';

  @override
  String get pass => 'Permitir';

  @override
  String get block => 'Bloquear';

  @override
  String get reject => 'Rechazar';

  @override
  String get logs => 'Registros';

  @override
  String get filterByAction => 'Filtrar por Acción';

  @override
  String get showAll => 'Mostrar Todo';

  @override
  String get autoRefresh => 'Actualización Automática';

  @override
  String get logLimit => 'Límite de Registros';

  @override
  String get paused => 'Pausado';

  @override
  String get live => 'En vivo';

  @override
  String get entries => 'entradas';

  @override
  String get selected => 'seleccionado';

  @override
  String get selectAll => 'Seleccionar todo';

  @override
  String get copy => 'Copiar';

  @override
  String get historySize => 'Tamaño del historial';

  @override
  String get enableAutoScroll => 'Activar desplazamiento automático';

  @override
  String get disableAutoScroll => 'Desactivar desplazamiento automático';

  @override
  String get clearLogs => 'Limpiar registros';

  @override
  String get pause => 'Pausar';

  @override
  String get resume => 'Reanudar';

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
  String get pauseLiveViewToSelect =>
      'Pausa la vista en vivo para seleccionar entradas de registro';

  @override
  String get errorLoadingLogs => 'Error al cargar registros';

  @override
  String get noLogsAvailable => 'No hay registros disponibles';

  @override
  String get logsWillAppear =>
      'Los registros aparecerán aquí a medida que se generen';

  @override
  String get selectNumberOfEntries =>
      'Seleccione el número de entradas de registro para mostrar:';

  @override
  String get reason => 'Razón';

  @override
  String get newRule => 'Nueva Regla';

  @override
  String get ruleDetails => 'Detalles de la regla';

  @override
  String get type => 'Tipo';

  @override
  String get sequence => 'Secuencia';

  @override
  String get status => 'Estado';

  @override
  String get systemGeneratedRule =>
      'Esta es una regla generada por el sistema y no se puede modificar ni eliminar.';

  @override
  String get systemGeneratedRulesCannotBeModified =>
      'Las reglas generadas por el sistema no se pueden modificar';

  @override
  String get systemGeneratedRulesCannotBeDeleted =>
      'Las reglas generadas por el sistema no se pueden eliminar';

  @override
  String get enableRule => 'Activar regla';

  @override
  String get disableRule => 'Desactivar regla';

  @override
  String get enablingRule => 'Activando regla...';

  @override
  String get disablingRule => 'Desactivando regla...';

  @override
  String get ruleEnabledSuccessfully => 'Regla activada correctamente';

  @override
  String get ruleDisabledSuccessfully => 'Regla desactivada correctamente';

  @override
  String errorTogglingRule(String error) {
    return 'Error al cambiar regla: $error';
  }

  @override
  String deleteRuleConfirmation(String description) {
    return '¿Está seguro de que desea eliminar la regla \"$description\"?';
  }

  @override
  String get ruleDeleted => 'Regla eliminada exitosamente';

  @override
  String errorDeletingRule(String error) {
    return 'Error al eliminar regla: $error';
  }

  @override
  String get errorLoadingRules => 'Error al cargar reglas';

  @override
  String get noAutomationRulesFound =>
      'No se encontraron reglas de automatización';

  @override
  String get createFirstAutomationRule =>
      'Cree su primera regla de automatización para comenzar';

  @override
  String get noInterfacesWithAutomationRules =>
      'No hay interfaces con reglas de automatización';

  @override
  String get selectInterface => 'Seleccionar interfaz';

  @override
  String get selectInterfaceToViewRules =>
      'Seleccione una interfaz para ver las reglas';

  @override
  String noRulesForInterface(String interface) {
    return 'No hay reglas para $interface';
  }

  @override
  String get unnamedRule => 'Regla sin nombre';

  @override
  String get systemInformation => 'Información del Sistema';

  @override
  String get firmwareDetails => 'Detalles del Firmware';

  @override
  String get systemType => 'Tipo de Sistema';

  @override
  String get architecture => 'Arquitectura';

  @override
  String get gitCommit => 'Commit de Git';

  @override
  String get packageMirror => 'Espejo de Paquetes';

  @override
  String get repository => 'Repositorio';

  @override
  String get lastUpdate => 'Última Actualización';

  @override
  String get errorLoadingSystemInfo =>
      'Error al cargar información del sistema';

  @override
  String get errorLoadingVPNConnections => 'Error al cargar conexiones VPN';

  @override
  String get noVPNConnectionsFound => 'No se encontraron conexiones VPN';

  @override
  String noConnectionsFound(String type) {
    return 'No se encontraron conexiones $type';
  }

  @override
  String get vpnConnectionsWillAppear =>
      'Las conexiones VPN aparecerán aquí cuando se configuren';

  @override
  String get totalVPNs => 'Total de VPN';

  @override
  String get filterByType => 'Filtrar por tipo';

  @override
  String get allVPNs => 'Todas las VPN';

  @override
  String get connectVPN => 'Conectar VPN';

  @override
  String get disconnectVPN => 'Desconectar VPN';

  @override
  String connectingVPN(String name) {
    return 'Conectando $name...';
  }

  @override
  String disconnectingVPN(String name) {
    return 'Desconectando $name...';
  }

  @override
  String successfullyConnected(String name) {
    return 'Conectado exitosamente a $name';
  }

  @override
  String successfullyDisconnected(String name) {
    return 'Desconectado exitosamente de $name';
  }

  @override
  String failedToConnect(String name) {
    return 'Error al conectar $name';
  }

  @override
  String failedToDisconnect(String name) {
    return 'Error al desconectar $name';
  }

  @override
  String get restartVPNService => 'Reiniciar servicio VPN';

  @override
  String restartServiceConfirmation(String type) {
    return '¿Está seguro de que desea reiniciar el servicio $type?\n\nEsto desconectará temporalmente todas las conexiones activas.';
  }

  @override
  String restartingService(String type) {
    return 'Reiniciando servicio $type...';
  }

  @override
  String successfullyRestartedService(String type) {
    return 'Servicio $type reiniciado exitosamente';
  }

  @override
  String failedToRestartService(String type) {
    return 'Error al reiniciar servicio $type';
  }

  @override
  String get enterRuleDescription => 'Ingrese la descripción de la regla';

  @override
  String get loading => 'Cargando...';

  @override
  String get any => 'Cualquiera';

  @override
  String get anyIpAddressCidrOrAlias =>
      'cualquiera, dirección IP, CIDR o alias';

  @override
  String get examplesAnyIpCidr => 'Ejemplos: any, 192.168.1.0/24, 10.0.0.1';

  @override
  String get sourceIsRequired => 'El origen es obligatorio';

  @override
  String get invalidSourceFormat => 'Formato de origen inválido';

  @override
  String get sourcePortOptional => 'Puerto de Origen (Opcional)';

  @override
  String get anyPortNumberRangeOrAlias =>
      'cualquiera, número de puerto, rango o alias';

  @override
  String get examplesAnyPortRange => 'Ejemplos: any, 80, 1024-65535';

  @override
  String get invalidPortFormat => 'Formato de puerto inválido';

  @override
  String get destinationIsRequired => 'El destino es obligatorio';

  @override
  String get invalidDestinationFormat => 'Formato de destino inválido';

  @override
  String get destinationPortOptional => 'Puerto de Destino (Opcional)';

  @override
  String get examplesAnyPortRangeHttp => 'Ejemplos: any, 80, 80-443, http';

  @override
  String get ruleWillBeActiveWhenEnabled =>
      'La regla estará activa cuando esté habilitada';

  @override
  String get ruleGuidelines => 'Directrices de Reglas';

  @override
  String get ruleGuidelinesText =>
      '• Use \"any\" para coincidir con todas las direcciones o puertos\n• Notación CIDR: 192.168.1.0/24\n• Rangos de puertos: 80-443\n• Las reglas se procesan en orden secuencial\n• Los cambios se aplican inmediatamente';

  @override
  String get updateRule => 'Actualizar Regla';

  @override
  String get ruleUpdated => 'Regla actualizada exitosamente';

  @override
  String get ruleCreated => 'Regla creada exitosamente';

  @override
  String errorSavingRule(String error) {
    return 'Error al guardar la regla: $error';
  }

  @override
  String get connectToYourOPNsenseFirewall =>
      'Conéctese a su firewall OPNsense';

  @override
  String get profileNameOptional => 'Nombre del Perfil (Opcional)';

  @override
  String get myOPNsenseRouter => 'Mi Router OPNsense';

  @override
  String get hostIpAddress => 'Host / Dirección IP';

  @override
  String get hostPlaceholder => '192.168.1.1 o firewall.example.com';

  @override
  String get portPlaceholder => '443';

  @override
  String get recommendedForSecureConnections =>
      'Recomendado para conexiones seguras';

  @override
  String get enterYourApiKey => 'Ingrese su clave API';

  @override
  String get enterYourApiSecret => 'Ingrese su secreto API';

  @override
  String get connect => 'Conectar';

  @override
  String apiError(String message) {
    return 'Error de API: $message';
  }

  @override
  String get needHelpCheckDocumentation =>
      '¿Necesita ayuda? Consulte la documentación de OPNsense para la generación de claves API.';

  @override
  String get selectAProfileOrCreateNewOne =>
      'Seleccione un perfil o cree uno nuevo';

  @override
  String get createNewProfile => 'Crear Nuevo Perfil';

  @override
  String get noProfilesYet => 'Aún No Hay Perfiles';

  @override
  String get createYourFirstProfile =>
      'Cree su primer perfil de OPNsense para comenzar';

  @override
  String lastUsed(String date) {
    return 'Último uso: $date';
  }

  @override
  String get justNow => 'Justo ahora';

  @override
  String minutesAgo(String minutes) {
    return 'Hace ${minutes}m';
  }

  @override
  String hoursAgo(String hours) {
    return 'Hace ${hours}h';
  }

  @override
  String daysAgo(String days) {
    return 'Hace ${days}d';
  }

  @override
  String connectionFailedError(String error) {
    return 'Conexión fallida: $error';
  }

  @override
  String get enterPin => 'Ingresar PIN';

  @override
  String get unlockOPNsenseManager => 'Desbloquear OPNsense Manager';

  @override
  String get pleaseEnterYourPin => 'Por favor ingrese su PIN';

  @override
  String get incorrectPin => 'PIN incorrecto';

  @override
  String get unlock => 'Desbloquear';

  @override
  String get useBiometric => 'Usar Biométrico';

  @override
  String get authenticateToUnlock =>
      'Autentíquese para desbloquear OPNsense Manager';

  @override
  String version(String version) {
    return 'Versión $version';
  }

  @override
  String get remoteAddress => 'Dirección remota';

  @override
  String get localAddress => 'Dirección local';

  @override
  String get received => 'Recibido';

  @override
  String get sent => 'Enviado';

  @override
  String get vpnStatus => 'Estado VPN';

  @override
  String get connected => 'Conectado';

  @override
  String get disconnected => 'Desconectado';

  @override
  String get disconnect => 'Desconectar';

  @override
  String get vpnType => 'Tipo de VPN';

  @override
  String get clientAddress => 'Dirección del Cliente';

  @override
  String get virtualAddress => 'Dirección Virtual';

  @override
  String get bytesReceived => 'Bytes Recibidos';

  @override
  String get bytesSent => 'Bytes Enviados';

  @override
  String get connectedSince => 'Conectado Desde';

  @override
  String get rebootSystem => 'Reiniciar Sistema';

  @override
  String get rebootConfirmation =>
      '¿Está seguro de que desea reiniciar el sistema?';

  @override
  String get rebootSuccess => 'Reinicio del sistema iniciado';

  @override
  String get rebootFailed => 'Error al reiniciar el sistema';

  @override
  String get error => 'Error';

  @override
  String get success => 'Éxito';

  @override
  String get warning => 'Advertencia';

  @override
  String get info => 'Información';

  @override
  String get noData => 'No hay datos disponibles';

  @override
  String get retry => 'Reintentar';

  @override
  String get confirmDelete => 'Confirmar Eliminación';

  @override
  String get deleteConfirmation =>
      '¿Está seguro de que desea eliminar este elemento?';

  @override
  String get cannotBeUndone => 'Esta acción no se puede deshacer.';

  @override
  String get enterPIN => 'Ingresar PIN';

  @override
  String get confirmPIN => 'Confirmar PIN';

  @override
  String get pinMismatch => 'Los PIN no coinciden';

  @override
  String get pinTooShort => 'El PIN debe tener al menos 4 dígitos';

  @override
  String get invalidPIN => 'PIN inválido';

  @override
  String get minutes => 'minutos';

  @override
  String get seconds => 'segundos';

  @override
  String get hours => 'horas';

  @override
  String get days => 'días';

  @override
  String get required => 'Requerido';

  @override
  String get optional => 'Opcional';

  @override
  String get invalidInput => 'Entrada inválida';

  @override
  String get fieldRequired => 'Este campo es requerido';

  @override
  String get exportSuccess => 'Exportación exitosa';

  @override
  String get exportFailed => 'Exportación fallida';

  @override
  String get importSuccess => 'Importación exitosa';

  @override
  String get importFailed => 'Importación fallida';

  @override
  String importedProfiles(int count) {
    return 'Se importaron $count perfil(es)';
  }

  @override
  String get noProfilesFound => 'No se encontraron perfiles';

  @override
  String get createFirstProfile => 'Cree su primer perfil para comenzar';

  @override
  String get serviceStarted => 'Servicio iniciado exitosamente';

  @override
  String get serviceStopped => 'Servicio detenido exitosamente';

  @override
  String get serviceRestarted => 'Servicio reiniciado exitosamente';

  @override
  String get serviceActionFailed => 'Acción del servicio fallida';

  @override
  String get ruleActionFailed => 'Acción de regla fallida';

  @override
  String get profileSaved => 'Perfil guardado exitosamente';

  @override
  String get profileDeleted => 'Perfil eliminado exitosamente';

  @override
  String get profileActivated => 'Perfil activado exitosamente';

  @override
  String get authenticationRequired => 'Autenticación Requerida';

  @override
  String get authenticationFailed => 'Autenticación fallida';

  @override
  String get networkError => 'Ocurrió un error de red';

  @override
  String get serverError => 'Ocurrió un error del servidor';

  @override
  String get unauthorized => 'Acceso no autorizado';

  @override
  String get forbidden => 'Acceso prohibido';

  @override
  String get notFound => 'Recurso no encontrado';

  @override
  String get timeout => 'Tiempo de espera agotado';

  @override
  String get none => 'Ninguno';

  @override
  String get diskUsage => 'Uso del Disco';

  @override
  String get pinLockDisabled =>
      'Bloqueo PIN deshabilitado. Bloqueo biométrico también deshabilitado.';

  @override
  String get setPin => 'Establecer PIN';

  @override
  String get pinLockTitle => 'Bloqueo PIN';

  @override
  String get requirePinToUnlock =>
      'Requiere PIN para desbloquear la aplicación';

  @override
  String get changePinTitle => 'Cambiar PIN';

  @override
  String get updatePinCode => 'Actualizar su código PIN';

  @override
  String get lockTimeoutLabel => 'Tiempo de Espera de Bloqueo';

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
  String get minute => 'minuto';

  @override
  String get add => 'Agregar';

  @override
  String get profileAdded => 'Perfil agregado';

  @override
  String get profileUpdated => 'Perfil actualizado';

  @override
  String get exportProfilesTitle => 'Exportar Perfiles';

  @override
  String get chooseExportLocation => 'Elegir Ubicación de Exportación';

  @override
  String profilesExportedSuccessfully(String path) {
    return '¡Perfiles exportados exitosamente!\n$path';
  }

  @override
  String exportFailedError(String error) {
    return 'Exportación fallida: $error';
  }

  @override
  String get importProfilesTitle => 'Importar Perfiles';

  @override
  String invalidFileError(String error) {
    return 'Archivo inválido: $error';
  }

  @override
  String get importProfilesDialog =>
      '¿Cómo deben manejarse los perfiles existentes?\n\n• Mantener Ambos: Importar con nuevos IDs\n• Sobrescribir: Reemplazar perfiles existentes';

  @override
  String get keepBoth => 'Mantener Ambos';

  @override
  String get overwrite => 'Sobrescribir';

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
  String importFailedWithErrors(String errors) {
    return 'Importación fallida: $errors';
  }

  @override
  String importedWithFailures(int success, int failed) {
    String _temp0 = intl.Intl.pluralLogic(
      success,
      locale: localeName,
      other: 'perfiles',
      one: 'perfil',
    );
    return 'Se importaron $success $_temp0, $failed fallaron';
  }

  @override
  String get deleteProfileTitle => 'Eliminar Perfil';

  @override
  String deleteProfileConfirmation(String name) {
    return '¿Está seguro de que desea eliminar \"$name\"?';
  }

  @override
  String get applicationLegalese =>
      '© 2026 OPNsense Manager\n\nLicenciado bajo la Licencia Pública General de GNU v3.0\n\nEste programa es software libre: puede redistribuirlo y/o modificarlo bajo los términos de la Licencia Pública General de GNU publicada por la Free Software Foundation, ya sea la versión 3 de la Licencia, o (a su elección) cualquier versión posterior.';

  @override
  String get aboutDescription =>
      'Una aplicación móvil Flutter profesional para administrar routers de firewall OPNsense.';

  @override
  String get featuresTitle => 'Características';

  @override
  String get featuresList =>
      '• Monitoreo y gestión del sistema\n• Configuración de reglas de firewall\n• Control de servicios\n• Registros en tiempo real\n• Soporte multi-perfil\n• Autenticación segura';

  @override
  String get viewFullLicense => 'Ver Licencia Completa';

  @override
  String get gnuLicenseTitle => 'Licencia Pública General de GNU v3.0';

  @override
  String get gnuLicenseText =>
      'Este programa es software libre: puede redistribuirlo y/o modificarlo bajo los términos de la Licencia Pública General de GNU publicada por la Free Software Foundation, ya sea la versión 3 de la Licencia, o (a su elección) cualquier versión posterior.\n\nEste programa se distribuye con la esperanza de que sea útil, pero SIN NINGUNA GARANTÍA; sin siquiera la garantía implícita de COMERCIABILIDAD o IDONEIDAD PARA UN PROPÓSITO PARTICULAR. Consulte la Licencia Pública General de GNU para más detalles.\n\nDebería haber recibido una copia de la Licencia Pública General de GNU junto con este programa. Si no es así, consulte <https://www.gnu.org/licenses/>.\n\n¿Por qué GPLv3?\n\n• Garantiza que el software permanezca libre y de código abierto\n• Cualquier modificación o derivado también debe ser de código abierto\n• Los usuarios tienen la libertad de usar, estudiar, compartir y modificar el software\n• La comunidad se beneficia de las mejoras y contribuciones';

  @override
  String get enterPinLabel => 'Ingresar PIN (4-6 dígitos)';

  @override
  String get confirmPin => 'Confirmar PIN';

  @override
  String get pinLockEnabled => 'Bloqueo PIN habilitado';

  @override
  String get currentPin => 'PIN Actual';

  @override
  String get newPin => 'Nuevo PIN (4-6 dígitos)';

  @override
  String get confirmNewPin => 'Confirmar Nuevo PIN';

  @override
  String get currentPinIncorrect => 'El PIN actual es incorrecto';

  @override
  String get pinChangedSuccessfully => 'PIN cambiado exitosamente';

  @override
  String get pleaseEnterCurrentPin => 'Por favor ingrese su PIN actual';

  @override
  String get pleaseEnterNewPin => 'Por favor ingrese un nuevo PIN';

  @override
  String get pinMustContainOnlyNumbers => 'El PIN debe contener solo números';

  @override
  String get newPinMustBeDifferent =>
      'El nuevo PIN debe ser diferente del actual';

  @override
  String get enablePinLockFirst =>
      'Por favor habilite el bloqueo PIN primero antes de usar biométrico';

  @override
  String get biometricNotAvailable =>
      'La autenticación biométrica no está disponible en este dispositivo';

  @override
  String get biometricLockEnabled => 'Bloqueo biométrico habilitado';

  @override
  String get biometricAuthFailed =>
      'La autenticación biométrica falló o fue cancelada';

  @override
  String get biometricLockDisabled => 'Bloqueo biométrico deshabilitado';

  @override
  String biometricLockTitle(String biometricType) {
    return 'Bloqueo $biometricType';
  }

  @override
  String useBiometricToUnlock(String biometricType) {
    return 'Usar $biometricType para desbloquear la aplicación';
  }

  @override
  String get enablePinLockFirstBiometric =>
      'Habilite el bloqueo PIN primero para usar biométrico';

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
  String get oneHour => '1 hora';

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
  String get activate => 'Activar';

  @override
  String get import => 'Importar';

  @override
  String get export => 'Exportar';

  @override
  String get activatingProfile => 'Activando perfil...';

  @override
  String activatedProfile(String name) {
    return 'Perfil activado: $name';
  }

  @override
  String get connectionTestFailed => 'Prueba de conexión fallida';

  @override
  String get profileNameLabel => 'Nombre del Perfil';

  @override
  String get hostIpAddressLabel => 'Host/Dirección IP';

  @override
  String get portLabel => 'Puerto';

  @override
  String get useHttpsLabel => 'Usar HTTPS';

  @override
  String get apiKeyLabel => 'Clave API';

  @override
  String get apiSecretLabel => 'Secreto API';

  @override
  String get profileNameRequired => 'El nombre del perfil es obligatorio';

  @override
  String get exportProfilesContent =>
      '¿Desea incluir las credenciales API en la exportación?\n\nADVERTENCIA: Incluir credenciales almacenará las claves API y secretos en texto plano. Solo incluya credenciales si almacenará el archivo de forma segura.';

  @override
  String get withoutCredentials => 'Sin Credenciales';

  @override
  String get includeCredentials => 'Incluir Credenciales';

  @override
  String get unableToAccessFilePath =>
      'No se puede acceder a la ruta del archivo';

  @override
  String invalidFileFormat(String error) {
    return 'Archivo inválido: $error';
  }

  @override
  String get noProfiles => 'Sin Perfiles';

  @override
  String get addProfileToManageInstances =>
      'Agregue un perfil para administrar instancias de OPNsense';

  @override
  String get unknown => 'Desconocido';

  @override
  String get http => 'http';

  @override
  String get https => 'https';

  @override
  String errorPrefix(String message) {
    return 'Error: $message';
  }

  @override
  String get switchProfileConfirmation => '¿Cambiar perfil?';

  @override
  String rebootFailedWithError(String message, String error) {
    return '$message: $error';
  }

  @override
  String get zeroSeconds => '0 segundos';

  @override
  String get day => 'día';

  @override
  String get hour => 'hora';

  @override
  String get second => 'segundo';

  @override
  String get hostIsRequired => 'El host es obligatorio';

  @override
  String get invalidHostnameOrIp => 'Nombre de host o dirección IP no válidos';

  @override
  String get portIsRequired => 'El puerto es obligatorio';

  @override
  String get portMustBeBetween => 'El puerto debe estar entre 1 y 65535';

  @override
  String get apiKeyIsRequired => 'La clave API es obligatoria';

  @override
  String get invalidApiKeyFormat => 'Formato de clave API no válido';

  @override
  String get apiSecretIsRequired => 'El secreto API es obligatorio';

  @override
  String get invalidApiSecretFormat => 'Formato de secreto API no válido';

  @override
  String fieldIsRequired(String fieldName) {
    return '$fieldName es obligatorio';
  }

  @override
  String actionService(String action) {
    return '$action Servicio';
  }

  @override
  String confirmServiceAction(String action, String name) {
    return '¿$action \"$name\"?';
  }

  @override
  String actioningService(String action, String name) {
    return '$action $name...';
  }

  @override
  String get notAvailable => 'N/D';

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
  String get liveNetworkMonitor => 'Monitor de Red en Vivo';

  @override
  String get searchHostnameOrIp => 'Buscar nombre de host o dirección IP...';

  @override
  String activeHosts(int count) {
    return '$count host(s) activo(s)';
  }

  @override
  String get noHostsFound => 'No se encontraron hosts';

  @override
  String get tryDifferentSearch =>
      'Intente con un término de búsqueda diferente';

  @override
  String get download => 'Descarga';

  @override
  String get upload => 'Carga';

  @override
  String get totalBandwidth => 'Ancho de Banda Total';

  @override
  String get of1Gbps => 'de 1 Gbps';

  @override
  String get networkTotals => 'Totales de Red';

  @override
  String get totalDownload => 'Descarga Total';

  @override
  String get totalUpload => 'Carga Total';

  @override
  String get activeDevices => 'Dispositivos Activos';

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
  String get bandwidthLimit => 'Límite de Ancho de Banda';

  @override
  String get bandwidthLimitMbps => 'Límite de Ancho de Banda (Mbps)';

  @override
  String get enterBandwidthLimit =>
      'Ingrese el límite de ancho de banda de su conexión en Mbps';

  @override
  String get macAddress => 'Dirección MAC';

  @override
  String get monitorInterface => 'Interfaz de Monitoreo';

  @override
  String get selectMultipleInterfaces =>
      'Seleccione una o más interfaces para monitorear';

  @override
  String get dhcpLeases => 'Arrendamientos DHCP';

  @override
  String get searchHostnameIpOrMac => 'Buscar nombre de host, IP o MAC...';

  @override
  String leasesCount(int filtered, int total) {
    return '$filtered de $total arrendamiento(s)';
  }

  @override
  String get noLeasesFound => 'No se encontraron arrendamientos';

  @override
  String get all => 'Todos';

  @override
  String get active => 'Activo';

  @override
  String get expired => 'Expirado';

  @override
  String get expires => 'Expira';

  @override
  String get ipAddress => 'Dirección IP';

  @override
  String get staticLease => 'Estático';

  @override
  String get dynamicLease => 'Dinámico';

  @override
  String get blockHost => 'Bloquear host';

  @override
  String blockHostConfirmation(String hostname, String ip) {
    return '¿Está seguro de que desea bloquear $hostname ($ip)?\n\nEsto creará una regla de firewall para bloquear todo el tráfico de este host.';
  }

  @override
  String get blockingHost => 'Bloqueando host...';

  @override
  String get hostBlocked => 'Host bloqueado exitosamente';

  @override
  String get failedToBlockHost => 'Error al bloquear el host';
}
