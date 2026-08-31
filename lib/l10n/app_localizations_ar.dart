// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get about => 'حول';

  @override
  String get aboutDescription =>
      'تطبيق Flutter احترافي لإدارة جدران حماية OPNsense.';

  @override
  String get aboutImportExport => 'حول الاستيراد والتصدير';

  @override
  String get acceptDns => 'قبول DNS';

  @override
  String get acceptDnsDescription => 'استخدام خوادم DNS المقدمة من Tailscale';

  @override
  String get acceptRoutes => 'قبول المسارات';

  @override
  String get acceptSubnetRoutes => 'قبول مسارات الشبكة الفرعية';

  @override
  String get acceptSubnetRoutesDescription =>
      'قبول المسارات المعلن عنها من العقد الأخرى';

  @override
  String get action => 'الإجراء';

  @override
  String actionService(String action) {
    return '$action الخدمة';
  }

  @override
  String actioningService(String action, String name) {
    return '$action $name...';
  }

  @override
  String get activate => 'تفعيل';

  @override
  String activatedProfile(String name) {
    return 'تم تفعيل الملف التعريفي: $name';
  }

  @override
  String get activatingProfile => 'جاري تفعيل الملف التعريفي...';

  @override
  String get activationFailed => 'فشل التفعيل';

  @override
  String get active => 'نشط';

  @override
  String get activeDevices => 'الأجهزة النشطة';

  @override
  String activeHosts(int count) {
    return '$count مضيف نشط';
  }

  @override
  String get activeProfile => 'الملف الشخصي النشط';

  @override
  String get add => 'إضافة';

  @override
  String get addClientOverride => 'إضافة تجاوز العميل';

  @override
  String get addConnection => 'إضافة اتصال';

  @override
  String get addConnectionEndpoint => 'الرجاء إضافة نقطة اتصال واحدة على الأقل';

  @override
  String get addDnsServer => 'إضافة خادم DNS';

  @override
  String get addHost => 'إضافة مضيف';

  @override
  String get addHostToGetStarted => 'أضف مضيفاً للبدء';

  @override
  String get addInstance => 'إضافة مثيل';

  @override
  String get addOpenVpnInstance => 'إضافة مثيل OpenVPN';

  @override
  String get addOverride => 'إضافة تجاوز';

  @override
  String get addProfile => 'إضافة ملف تعريف';

  @override
  String get addProfileToManageInstances =>
      'أضف ملفاً تعريفياً لإدارة مثيلات OPNsense';

  @override
  String get addStaticKey => 'إضافة مفتاح ثابت';

  @override
  String get addSubnet => 'إضافة شبكة فرعية';

  @override
  String get addTunnelAddress => 'إضافة عنوان نفق';

  @override
  String get additionalInformation => 'معلومات إضافية';

  @override
  String get advancedOptions => 'Advanced Options';

  @override
  String get address => 'العنوان';

  @override
  String get addressIsRequired => 'العنوان مطلوب';

  @override
  String get advertiseExitNode => 'الإعلان عن عقدة الخروج';

  @override
  String get advertiseExitNodeDescription =>
      'السماح للأجهزة الأخرى بالتوجيه عبر هذه العقدة';

  @override
  String get advertiseRoutes => 'الإعلان عن المسارات';

  @override
  String get alert => 'تنبيه';

  @override
  String get aliasDeletedSuccessfully => 'تم حذف الاسم المستعار بنجاح';

  @override
  String get aliasDisabledSuccessfully => 'تم تعطيل الاسم المستعار بنجاح';

  @override
  String get aliasEnabledSuccessfully => 'تم تفعيل الاسم المستعار بنجاح';

  @override
  String get aliases => 'الأسماء المستعارة';

  @override
  String get all => 'الكل';

  @override
  String get allConnectionsSuccessful => 'تم اختبار جميع الاتصالات بنجاح';

  @override
  String get allDetailsCopiedToClipboard => 'تم نسخ جميع التفاصيل إلى الحافظة';

  @override
  String get allRoles => 'جميع الأدوار';

  @override
  String get allSettingsSavedSuccessfully => 'تم حفظ جميع الإعدادات بنجاح';

  @override
  String get allStatus => 'جميع الحالات';

  @override
  String get allTypes => 'جميع الأنواع';

  @override
  String get allVpns => 'جميع VPN';

  @override
  String get allowSelfSignedCertificates => 'السماح بالشهادات الموقعة ذاتياً';

  @override
  String get allowSelfSignedCertificatesDescription =>
      'قبول شهادات SSL الموقعة ذاتياً';

  @override
  String get allowedIps => 'عناوين IP المسموح بها';

  @override
  String get any => 'أي';

  @override
  String get anyIpAddressCidrOrAlias => 'أي، عنوان IP، CIDR، أو اسم مستعار';

  @override
  String get anyPortNumberRangeOrAlias => 'أي، رقم منفذ، نطاق، أو اسم مستعار';

  @override
  String apiError(String message) {
    return 'خطأ في API: $message';
  }

  @override
  String get apiKey => 'مفتاح API';

  @override
  String get apiKeyIsRequired => 'مفتاح API مطلوب';

  @override
  String get apiSecret => 'سر API';

  @override
  String get apiSecretIsRequired => 'سر API مطلوب';

  @override
  String get appearance => 'المظهر';

  @override
  String get apply => 'تطبيق';

  @override
  String get architecture => 'البنية';

  @override
  String get atLeastOneTunnelAddressRequired =>
      'مطلوب عنوان نفق واحد على الأقل';

  @override
  String get authSettingsSavedSuccessfully => 'تم حفظ إعدادات المصادقة بنجاح';

  @override
  String get authTlsAuthentication => 'Auth (مصادقة TLS)';

  @override
  String get authTokenGeneratedSuccessfully => 'تم إنشاء رمز المصادقة بنجاح';

  @override
  String get authenticate => 'مصادقة';

  @override
  String get authenticateToUnlock => 'المصادقة لفتح OPNsense Manager';

  @override
  String get authentication => 'المصادقة';

  @override
  String get authenticationFailed => 'فشلت المصادقة';

  @override
  String get authenticationRequired => 'المصادقة مطلوبة';

  @override
  String get authenticationSettings => 'إعدادات المصادقة';

  @override
  String get authenticated => 'مصادق عليه';

  @override
  String get notAuthenticated => 'غير مصادق عليه';

  @override
  String get tailnet => 'تيلنت';

  @override
  String get deviceName => 'اسم الجهاز';

  @override
  String get authUrl => 'رابط المصادقة';

  @override
  String get user => 'المستخدم';

  @override
  String get authorizedPeers => 'الأقران المصرح لهم';

  @override
  String get autoRefresh => 'التحديث التلقائي';

  @override
  String get automaticRule => 'تلقائي';

  @override
  String get backendState => 'حالة الخلفية';

  @override
  String get bandwidthLimit => 'حد النطاق الترددي';

  @override
  String get bandwidthLimitMbps => 'حد النطاق الترددي (ميجابت في الثانية)';

  @override
  String get bandwidthHistory => 'سجل عرض النطاق الترددي';

  @override
  String get base64EncodedPrivateKeyKeepSecret =>
      'مفتاح خاص مشفر بـ Base64 (احتفظ به سرياً!)';

  @override
  String get base64EncodedPublicKey => 'مفتاح عام مشفر بـ Base64';

  @override
  String get biometricAuth => 'المصادقة البيومترية';

  @override
  String get biometricAuthFailed => 'فشلت المصادقة البيومترية أو تم إلغاؤها';

  @override
  String get biometricLockDisabled => 'تم تعطيل القفل البيومتري';

  @override
  String get biometricLockEnabled => 'تم تفعيل القفل البيومتري';

  @override
  String biometricLockTitle(String biometricType) {
    return 'قفل $biometricType';
  }

  @override
  String get biometricNotAvailable =>
      'المصادقة البيومترية غير متوفرة على هذا الجهاز';

  @override
  String get block => 'حظر';

  @override
  String get blockHost => 'حظر المضيف';

  @override
  String blockHostConfirmation(String hostname, String ip) {
    return 'هل أنت متأكد من حظر $hostname ($ip)؟\n\nسيؤدي هذا إلى إنشاء قاعدة جدار ناري لحظر جميع حركة المرور من هذا المضيف.';
  }

  @override
  String get blockingHost => 'جاري حظر المضيف...';

  @override
  String get bytesReceived => 'البايتات المستلمة';

  @override
  String get bytesSent => 'البايتات المرسلة';

  @override
  String get cancel => 'إلغاء';

  @override
  String get checkForUpdates => 'Check for Updates';

  @override
  String get checkingForUpdates => 'Checking for updates…';

  @override
  String get installUpdate => 'Install Update';

  @override
  String get installingUpdate => 'Installing update…';

  @override
  String get updateComplete => 'Update installed successfully';

  @override
  String get rebootRequired => 'A reboot is required to complete the update.';

  @override
  String get rebootNow => 'Reboot Now';

  @override
  String get installUpdateConfirmTitle => 'Install Update';

  @override
  String installUpdateConfirmMessage(int count) {
    return 'This will upgrade $count package(s) and requires a reboot to complete. Continue?';
  }

  @override
  String get cannotBeUndone => 'لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get cannotDeleteLastConnection => 'لا يمكن حذف نقطة الاتصال الأخيرة';

  @override
  String get carpVhidToDepend => 'CARP VHID للاعتماد عليه';

  @override
  String get categories => 'الفئات';

  @override
  String get changePin => 'تغيير PIN';

  @override
  String get changesDiscarded => 'تم تجاهل التغييرات';

  @override
  String get checkIfWireguardIsConfiguredAndRunning =>
      'تحقق من تكوين WireGuard وتشغيله';

  @override
  String get chooseExportLocation => 'اختر موقع التصدير';

  @override
  String get cidrNotationRequired => 'تدوين CIDR مطلوب';

  @override
  String get clearLogs => 'مسح السجلات';

  @override
  String get clearSelection => 'مسح التحديد';

  @override
  String get client => 'عميل';

  @override
  String get clientAddress => 'عنوان العميل';

  @override
  String get clientName => 'اسم العميل';

  @override
  String get clientOverrides => 'تجاوزات العميل';

  @override
  String get clientSettings => 'إعدادات العميل';

  @override
  String get clientSpecificOverrides => 'تجاوزات خاصة بالعميل';

  @override
  String get clientX509CommonNameHelper =>
      'أدخل الاسم الشائع X.509 للعميل هنا.';

  @override
  String get close => 'إغلاق';

  @override
  String get commonName => 'الاسم الشائع';

  @override
  String get commonNameRequired => 'الاسم الشائع مطلوب';

  @override
  String commonNameWithValue(String value) {
    return 'الاسم الشائع: $value';
  }

  @override
  String get configurationAppliedSuccessfully => 'تم تطبيق التكوين بنجاح';

  @override
  String get configurationPreview => 'معاينة التكوين';

  @override
  String get configureAdvertisedSubnets => 'تكوين الشبكات الفرعية المعلن عنها';

  @override
  String get configured => 'تم التكوين';

  @override
  String get confirmDelete => 'تأكيد الحذف';

  @override
  String confirmDeleteInstance(String name) {
    return 'هل أنت متأكد من حذف المثيل \"$name\"؟ لا يمكن التراجع عن هذا الإجراء.';
  }

  @override
  String confirmDeleteOverride(String name) {
    return 'هل أنت متأكد من حذف التجاوز لـ \"$name\"؟ لا يمكن التراجع عن هذا الإجراء.';
  }

  @override
  String confirmDeleteStaticKey(String name) {
    return 'هل أنت متأكد من حذف المفتاح الثابت \"$name\"؟ لا يمكن التراجع عن هذا الإجراء.';
  }

  @override
  String get confirmNewPin => 'تأكيد رمز PIN الجديد';

  @override
  String get confirmPin => 'تأكيد رمز PIN';

  @override
  String confirmServiceAction(String action, String name) {
    return '$action \"$name\"؟';
  }

  @override
  String get connect => 'اتصال';

  @override
  String get connectToYourOpnsenseFirewall =>
      'اتصل بجدار الحماية OPNsense الخاص بك';

  @override
  String get connectVpn => 'اتصال VPN';

  @override
  String get connected => 'متصل';

  @override
  String get connectedSince => 'متصل منذ';

  @override
  String connectedSuccessfullyVia(String endpoint) {
    return 'تم الاتصال بنجاح عبر: $endpoint';
  }

  @override
  String connectingVPN(String name) {
    return 'جاري الاتصال بـ $name...';
  }

  @override
  String get connectionBlocking => 'حظر الاتصال';

  @override
  String get connectionDetails => 'تفاصيل الاتصال';

  @override
  String get connectionEndpoints => 'نقاط الاتصال';

  @override
  String get connectionEndpointsHelp =>
      'إدارة نقاط اتصال متعددة لهذا الملف الشخصي. سيحاول التطبيق كل نقطة نهاية بالترتيب حتى يتم إنشاء اتصال ناجح.';

  @override
  String get connectionFailed =>
      'فشل الاتصال. تحقق من سجلات وحدة التحكم للحصول على التفاصيل.\n\nالمشاكل الشائعة:\n• الجهاز ليس على نفس الشبكة مثل OPNsense\n• عنوان IP أو المنفذ خاطئ\n• جدار الحماية يحظر الاتصال\n• بيانات اعتماد API غير صالحة';

  @override
  String connectionFailedError(String error) {
    return 'فشل الاتصال: $error';
  }

  @override
  String get connectionInformation => 'معلومات الاتصال';

  @override
  String get connectionStatus => 'حالة الاتصال';

  @override
  String get connectionSuccessful => 'نجح الاتصال';

  @override
  String get connectionTestFailed => 'فشل اختبار الاتصال';

  @override
  String get connectionTestResults => 'نتائج اختبار الاتصال';

  @override
  String get content => 'المحتوى';

  @override
  String copiedLogEntries(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'إدخالات',
      one: 'إدخال',
    );
    return 'تم نسخ $count $_temp0';
  }

  @override
  String get copiedToClipboard => 'تم النسخ إلى الحافظة';

  @override
  String get copy => 'نسخ';

  @override
  String get copyAllDetails => 'نسخ جميع التفاصيل';

  @override
  String get copyHost => 'نسخ المضيف';

  @override
  String get copyKey => 'نسخ المفتاح';

  @override
  String get copySelected => 'نسخ المحدد';

  @override
  String get cpuUsage => 'استخدام المعالج';

  @override
  String get createFirstAutomationRule => 'أنشئ أول قاعدة أتمتة للبدء';

  @override
  String get createFirstFirewallRule => 'أنشئ أول قاعدة جدار حماية للبدء';

  @override
  String get createFirstProfile => 'أنشئ ملفك الشخصي الأول للبدء';

  @override
  String get createNewProfile => 'إنشاء ملف شخصي جديد';

  @override
  String get createOverride => 'إنشاء تجاوز';

  @override
  String get createPeer => 'إنشاء نظير';

  @override
  String get createRule => 'إنشاء قاعدة';

  @override
  String get createServer => 'إنشاء خادم';

  @override
  String get createStaticKey => 'إنشاء مفتاح ثابت';

  @override
  String get createYourFirstProfile =>
      'أنشئ ملفك الشخصي الأول في OPNsense للبدء';

  @override
  String get created => 'تم الإنشاء';

  @override
  String get critical => 'حرج';

  @override
  String get cryptTlsEncryption => 'Crypt (تشفير TLS)';

  @override
  String get cryptV2TlsEncryption => 'Crypt V2 (تشفير TLS)';

  @override
  String get currentPin => 'رمز PIN الحالي';

  @override
  String get currentPinIncorrect => 'رمز PIN الحالي غير صحيح';

  @override
  String get darkMode => 'الوضع الداكن';

  @override
  String get dashboard => 'لوحة التحكم';

  @override
  String get day => 'يوم';

  @override
  String get days => 'أيام';

  @override
  String daysAgo(int days) {
    return 'منذ $days أيام';
  }

  @override
  String get debug => 'التصحيح';

  @override
  String get defineRoleOfInstance => 'حدد دور هذا المثيل';

  @override
  String get delete => 'حذف';

  @override
  String deleteAliasConfirmation(String aliasName) {
    return 'هل أنت متأكد من رغبتك في حذف الاسم المستعار \"$aliasName\"؟';
  }

  @override
  String get deleteConfirmation => 'هل أنت متأكد من رغبتك في حذف هذا العنصر؟';

  @override
  String get deleteConnection => 'حذف الاتصال';

  @override
  String deleteConnectionConfirmation(String connectionName) {
    return 'هل أنت متأكد من رغبتك في حذف الاتصال \"$connectionName\"؟';
  }

  @override
  String get deleteHost => 'حذف المضيف';

  @override
  String deleteHostConfirmation(String host) {
    return 'هل أنت متأكد من رغبتك في حذف \"$host\"؟';
  }

  @override
  String get deleteInstance => 'حذف المثيل';

  @override
  String get deleteOverride => 'حذف التجاوز';

  @override
  String get deletePeer => 'حذف النظير';

  @override
  String deletePeerConfirmation(String name) {
    return 'هل أنت متأكد من حذف النظير \"$name\"؟';
  }

  @override
  String get deleteProfile => 'حذف الملف الشخصي';

  @override
  String deleteProfileConfirmation(String name) {
    return 'هل أنت متأكد من رغبتك في حذف \"$name\"؟';
  }

  @override
  String get deleteRule => 'حذف القاعدة';

  @override
  String deleteRuleConfirmation(String description) {
    return 'هل أنت متأكد من رغبتك في حذف القاعدة \"$description\"؟';
  }

  @override
  String disableRuleConfirmation(String description) {
    return 'هل أنت متأكد من أنك تريد تعطيل القاعدة \"$description\"؟';
  }

  @override
  String enableRuleConfirmation(String description) {
    return 'هل أنت متأكد من أنك تريد تفعيل القاعدة \"$description\"؟';
  }

  @override
  String deleteServerConfirmation(String name) {
    return 'هل أنت متأكد من حذف الخادم \"$name\"؟ لا يمكن التراجع عن هذا الإجراء.';
  }

  @override
  String get deleteStaticKey => 'حذف المفتاح الثابت';

  @override
  String get deleteSubnet => 'حذف الشبكة الفرعية';

  @override
  String deleteSubnetConfirmation(String subnet) {
    return 'هل أنت متأكد من حذف الشبكة الفرعية $subnet؟';
  }

  @override
  String get demo => 'عرض توضيحي';

  @override
  String get dependOnCarp => 'يعتمد على (CARP)';

  @override
  String get description => 'الوصف';

  @override
  String get descriptionHelperText => 'وصف موجز لهذا المثيل';

  @override
  String get descriptionHelperTextOverride =>
      'يمكنك إدخال وصف هنا للرجوع إليه (لا يتم تحليله).';

  @override
  String get descriptionHint => 'مثال: كمبيوتر غرفة المعيشة';

  @override
  String get descriptionOptional => 'الوصف (اختياري)';

  @override
  String get descriptionRequired => 'الوصف مطلوب';

  @override
  String get destination => 'الوجهة';

  @override
  String get destinationAddress => 'عنوان الوجهة';

  @override
  String get destinationIsRequired => 'الوجهة مطلوبة';

  @override
  String get destinationPort => 'منفذ الوجهة';

  @override
  String get destinationPortOptional => 'منفذ الوجهة (اختياري)';

  @override
  String get deviceType => 'نوع الجهاز';

  @override
  String get dhcpLeases => 'عقود DHCP';

  @override
  String dhcpServerLabel(String serverName) {
    return 'خادم $serverName';
  }

  @override
  String get dhcpServerType => 'نوع خادم DHCP';

  @override
  String get direction => 'الاتجاه';

  @override
  String get directionBoth => 'Both';

  @override
  String get directionIn => 'In';

  @override
  String get directionOut => 'Out';

  @override
  String get disable => 'تعطيل';

  @override
  String get disableAutoScroll => 'تعطيل التمرير التلقائي';

  @override
  String get disableRoutes => 'تعطيل المسارات';

  @override
  String get disableRoutesDescription => 'منع تثبيت المسارات التلقائي';

  @override
  String get disableRule => 'تعطيل القاعدة';

  @override
  String get disableSnat => 'تعطيل SNAT';

  @override
  String get disableSnatDescription =>
      'تعطيل ترجمة عنوان المصدر لمسارات الشبكة الفرعية';

  @override
  String get disabled => 'معطل';

  @override
  String get disablingRule => 'جاري تعطيل القاعدة...';

  @override
  String get discard => 'تجاهل';

  @override
  String get disconnect => 'قطع الاتصال';

  @override
  String get disconnectVpn => 'قطع اتصال VPN';

  @override
  String get disconnected => 'غير متصل';

  @override
  String disconnectingVPN(String name) {
    return 'جاري قطع الاتصال بـ $name...';
  }

  @override
  String get diskUsage => 'استخدام القرص';

  @override
  String get dnsDomainList => 'قائمة نطاقات DNS';

  @override
  String get dnsDomainListHelperText => 'تعيين لواحق DNS الخاصة بالاتصال.';

  @override
  String get dnsDomainSearchList => 'قائمة بحث نطاقات DNS';

  @override
  String get dnsDomainSearchListHelperText =>
      'إضافة اسم إلى قائمة بحث النطاق. كرر هذا الخيار لإضافة المزيد من الإدخالات. يتم دعم ما يصل إلى 10 نطاقات.';

  @override
  String get dnsEnabled => 'DNS مفعل';

  @override
  String get dnsServerIp => 'عنوان IP لخادم DNS';

  @override
  String get dnsServerIsRequired => 'خادم DNS مطلوب';

  @override
  String get dnsServerOptional => 'خادم DNS (اختياري)';

  @override
  String get dnsServers => 'خوادم DNS';

  @override
  String get dnsServersHelperText =>
      'تعيين عنوان خادم اسم النطاق الأساسي IPv4 أو IPv6. كرر هذا الخيار لتعيين عناوين خادم DNS الثانوية.';

  @override
  String get dnsServersOptional => 'خوادم DNS (اختياري)';

  @override
  String get dnsmasqDescription => 'خادم DNS و DHCP خفيف الوزن';

  @override
  String get done => 'تم';

  @override
  String get download => 'التنزيل';

  @override
  String get dynamicLease => 'ديناميكي';

  @override
  String get edit => 'تعديل';

  @override
  String get editClientOverride => 'تحرير تجاوز العميل';

  @override
  String get editConnection => 'تعديل الاتصال';

  @override
  String get editHost => 'تعديل المضيف';

  @override
  String get editProfile => 'تعديل الملف الشخصي';

  @override
  String get editRule => 'تعديل القاعدة';

  @override
  String get editStaticKey => 'تعديل المفتاح الثابت';

  @override
  String get editSubnet => 'تعديل الشبكة الفرعية';

  @override
  String get editWireguardPeer => 'تحرير نظير WireGuard';

  @override
  String get editWireguardServer => 'تحرير خادم WireGuard';

  @override
  String get emergency => 'طوارئ';

  @override
  String get enable => 'تفعيل';

  @override
  String get enableAutoScroll => 'تفعيل التمرير التلقائي';

  @override
  String get enableClientSpecificOverride => 'تفعيل هذا التجاوز الخاص بالعميل';

  @override
  String get enableDebugLogging => 'تمكين تسجيل التصحيح';

  @override
  String get enablePinLockFirstBiometric =>
      'قم بتفعيل قفل PIN أولاً لاستخدام البيومترية';

  @override
  String get enableRule => 'تفعيل القاعدة';

  @override
  String get enableSsh => 'تفعيل SSH';

  @override
  String get enableSshDescription => 'السماح بالوصول عبر SSH من خلال Tailscale';

  @override
  String get enableTailscale => 'تفعيل Tailscale';

  @override
  String get enableTailscaleDescription => 'تفعيل أو تعطيل خدمة Tailscale';

  @override
  String get enableWireguard => 'تمكين WireGuard';

  @override
  String get enabled => 'مفعّل';

  @override
  String get enablingRule => 'جاري تفعيل القاعدة...';

  @override
  String get endTime => 'وقت الانتهاء';

  @override
  String get endpoint => 'نقطة النهاية';

  @override
  String get endpointAddress => 'عنوان نقطة النهاية';

  @override
  String get endpointPort => 'منفذ نقطة النهاية';

  @override
  String get enterBandwidthLimit =>
      'أدخل حد النطاق الترددي للاتصال بالميجابت في الثانية';

  @override
  String get enterClientCertificateCommonName =>
      'أدخل الاسم الشائع لشهادة العميل';

  @override
  String get enterDescriptionForOverride => 'أدخل وصفًا لهذا التجاوز';

  @override
  String get enterOrGeneratePresharedKey =>
      'أدخل أو أنشئ مفتاحًا مشتركًا مسبقًا';

  @override
  String get enterOrGeneratePrivateKey => 'أدخل أو أنشئ مفتاحًا خاصًا';

  @override
  String get enterOrGeneratePublicKey => 'أدخل أو أنشئ مفتاحًا عامًا';

  @override
  String get enterPin => 'أدخل رمز PIN';

  @override
  String get enterPinLabel => 'أدخل رمز PIN (4-6 أرقام)';

  @override
  String get enterRuleDescription => 'أدخل وصف القاعدة';

  @override
  String get enterYourApiKey => 'أدخل مفتاح API الخاص بك';

  @override
  String get enterYourApiSecret => 'أدخل سر API الخاص بك';

  @override
  String get entries => 'إدخالات';

  @override
  String entriesCount(int count) {
    return '$count إدخالات';
  }

  @override
  String get error => 'خطأ';

  @override
  String errorAddingSubnet(String error) {
    return 'خطأ في إضافة الشبكة الفرعية: $error';
  }

  @override
  String errorDeletingRule(String error) {
    return 'خطأ في حذف القاعدة: $error';
  }

  @override
  String errorDeletingSubnet(String error) {
    return 'خطأ في حذف الشبكة الفرعية: $error';
  }

  @override
  String get errorLoadingData => 'خطأ في تحميل البيانات';

  @override
  String get errorLoadingInstance => 'خطأ في تحميل المثيل';

  @override
  String get errorLoadingLogs => 'خطأ في تحميل السجلات';

  @override
  String get errorLoadingOverride => 'خطأ في تحميل التجاوز';

  @override
  String get errorLoadingRoutes => 'خطأ في تحميل المسارات';

  @override
  String get errorLoadingRules => 'خطأ في تحميل القواعد';

  @override
  String get errorLoadingSessions => 'خطأ في تحميل الجلسات';

  @override
  String get errorLoadingSystemInfo => 'خطأ في تحميل معلومات النظام';

  @override
  String get errorLoadingVpnConnections => 'خطأ في تحميل اتصالات VPN';

  @override
  String errorPrefix(String message) {
    return 'خطأ: $message';
  }

  @override
  String errorRestartingService(String error) {
    return 'خطأ في إعادة تشغيل الخدمة: $error';
  }

  @override
  String errorSavingRule(String error) {
    return 'خطأ في حفظ القاعدة: $error';
  }

  @override
  String errorStartingService(String error) {
    return 'خطأ في بدء الخدمة: $error';
  }

  @override
  String errorStoppingService(String error) {
    return 'خطأ في إيقاف الخدمة: $error';
  }

  @override
  String errorTogglingRule(String error) {
    return 'خطأ في تبديل القاعدة: $error';
  }

  @override
  String errorUpdatingSubnet(String error) {
    return 'خطأ في تحديث الشبكة الفرعية: $error';
  }

  @override
  String get exampleCidr => 'مثال: 10.10.10.2/24 أو fd00::2/64';

  @override
  String get exampleTunnelAddress => 'مثال: 10.10.10.1/24 أو fd00::1/64';

  @override
  String get examplesAnyIpCidr => 'أمثلة: any، 192.168.1.0/24، 10.0.0.1';

  @override
  String get examplesAnyPortRange => 'أمثلة: any، 80، 1024-65535';

  @override
  String get examplesAnyPortRangeHttp => 'أمثلة: any، 80، 80-443، http';

  @override
  String get exitNode => 'عقدة الخروج';

  @override
  String get expired => 'منتهي';

  @override
  String get expires => 'ينتهي';

  @override
  String get expiryTime => 'وقت الانتهاء';

  @override
  String get export => 'تصدير';

  @override
  String get exportAllProfiles => 'تصدير جميع الملفات الشخصية';

  @override
  String get exportAllProfilesSubtitle =>
      'تصدير جميع الملفات الشخصية إلى ملف JSON';

  @override
  String get exportCredentialsWarning =>
      'سيؤدي التصدير مع بيانات الاعتماد إلى حفظ مفاتيح API والأسرار بنص عادي. قم بذلك فقط إذا كنت ستخزن الملف بشكل آمن.';

  @override
  String get exportFailed => 'فشل التصدير';

  @override
  String exportFailedError(String error) {
    return 'فشل التصدير: $error';
  }

  @override
  String get exportLogs => 'تصدير السجلات';

  @override
  String get exportProfiles => 'تصدير الملفات الشخصية';

  @override
  String get exportProfilesContent =>
      'هل تريد تضمين بيانات اعتماد API في التصدير؟\n\nتحذير: سيؤدي تضمين بيانات الاعتماد إلى تخزين مفاتيح API والأسرار بنص عادي. قم بتضمين بيانات الاعتماد فقط إذا كنت ستخزن الملف بشكل آمن.';

  @override
  String get exportSuccess => 'نجح التصدير';

  @override
  String get exportThisProfile => 'تصدير هذا الملف الشخصي';

  @override
  String get failedDevices => 'الأجهزة الفاشلة';

  @override
  String failedToActionTailscaleService(String action) {
    return 'فشل $action خدمة Tailscale';
  }

  @override
  String get failedToApplyConfiguration => 'فشل تطبيق التكوين';

  @override
  String failedToSwitchProfile(String error) {
    return 'فشل تبديل الملف الشخصي: $error';
  }

  @override
  String get failedToBlockHost => 'فشل حظر المضيف';

  @override
  String failedToConnect(String name) {
    return 'فشل الاتصال بـ $name';
  }

  @override
  String failedToCopyHost(String error) {
    return 'فشل نسخ المضيف: $error';
  }

  @override
  String failedToDeleteAlias(String error) {
    return 'فشل حذف الاسم المستعار: $error';
  }

  @override
  String failedToDeleteHost(String error) {
    return 'فشل حذف المضيف: $error';
  }

  @override
  String failedToDeleteInstance(String error) {
    return 'فشل حذف المثيل: $error';
  }

  @override
  String failedToDeleteOverride(String error) {
    return 'فشل حذف التجاوز: $error';
  }

  @override
  String failedToDeletePeer(String error) {
    return 'فشل حذف النظير: $error';
  }

  @override
  String get failedToDeleteProfile => 'فشل حذف الملف الشخصي';

  @override
  String failedToDeleteServer(String error) {
    return 'فشل حذف الخادم: $error';
  }

  @override
  String failedToDeleteStaticKey(String error) {
    return 'فشل حذف المفتاح الثابت: $error';
  }

  @override
  String failedToDisconnect(String name) {
    return 'فشل قطع الاتصال بـ $name';
  }

  @override
  String failedToExportLogs(String error) {
    return 'فشل تصدير السجلات: $error';
  }

  @override
  String failedToGenerateKey(String error) {
    return 'فشل إنشاء المفتاح: $error';
  }

  @override
  String failedToGenerateToken(String error) {
    return 'فشل إنشاء الرمز: $error';
  }

  @override
  String failedToLoadInterfaces(String error) {
    return 'فشل تحميل الواجهات: $error';
  }

  @override
  String get failedToLoadOpenvpnLogs => 'فشل تحميل سجلات OpenVPN';

  @override
  String failedToRestartService(String type) {
    return 'فشل إعادة تشغيل الخدمة';
  }

  @override
  String get failedToSaveAuthSettings => 'فشل حفظ إعدادات المصادقة';

  @override
  String failedToSaveHost(String error) {
    return 'فشل حفظ المضيف: $error';
  }

  @override
  String failedToSaveInstance(String error) {
    return 'فشل حفظ المثيل: $error';
  }

  @override
  String failedToSaveOverride(String error) {
    return 'فشل حفظ التجاوز: $error';
  }

  @override
  String get failedToSavePeer => 'فشل حفظ النظير';

  @override
  String get failedToSaveProfile => 'فشل حفظ الملف الشخصي';

  @override
  String get failedToSaveServer => 'فشل حفظ الخادم';

  @override
  String get failedToSaveSettings => 'فشل حفظ الإعدادات';

  @override
  String failedToSaveStaticKey(String error) {
    return 'فشل حفظ المفتاح الثابت: $error';
  }

  @override
  String get failedToStartService => 'فشل بدء الخدمة';

  @override
  String get failedToStopService => 'فشل إيقاف الخدمة';

  @override
  String failedToToggleAlias(String error) {
    return 'فشل تبديل الاسم المستعار: $error';
  }

  @override
  String failedToToggleInstance(String error) {
    return 'فشل تبديل المثيل: $error';
  }

  @override
  String failedToToggleOverride(String error) {
    return 'فشل تبديل التجاوز: $error';
  }

  @override
  String failedToTogglePeer(String error) {
    return 'فشل تبديل النظير: $error';
  }

  @override
  String failedToToggleServer(String error) {
    return 'فشل تبديل الخادم: $error';
  }

  @override
  String failedToWakeAllHosts(String error) {
    return 'فشل تنبيه جميع المضيفين: $error';
  }

  @override
  String failedToWakeHost(String error) {
    return 'فشل تنبيه المضيف: $error';
  }

  @override
  String featureComingSoon(String feature) {
    return '$feature - قريباً';
  }

  @override
  String get featuresList =>
      '• مراقبة وإدارة النظام\n• تكوين قواعد الجدار الناري\n• التحكم في الخدمات\n• السجلات في الوقت الفعلي\n• دعم ملفات شخصية متعددة\n• مصادقة آمنة';

  @override
  String get featuresTitle => 'الميزات';

  @override
  String fieldIsRequired(String fieldName) {
    return '$fieldName مطلوب';
  }

  @override
  String get fieldRequired => 'هذا الحقل مطلوب';

  @override
  String get fifteenMin => '15 دقيقة';

  @override
  String get filterByAction => 'تصفية حسب الإجراء';

  @override
  String get filterByType => 'تصفية حسب النوع';

  @override
  String get filterLabel => 'تصفية: ';

  @override
  String get filters => 'المرشحات';

  @override
  String get firewall => 'جدار الحماية';

  @override
  String get firewallAliases => 'أسماء جدار الحماية المستعارة';

  @override
  String get firewallLogs => 'سجلات الجدار الناري';

  @override
  String get firewallRuleDetails => 'تفاصيل قاعدة الجدار الناري';

  @override
  String get firewallRules => 'قواعد الجدار الناري';

  @override
  String get firmwareDetails => 'تفاصيل البرنامج الثابت';

  @override
  String get fiveMin => '5 دقائق';

  @override
  String get floatingInterface => 'عائم';

  @override
  String get fixFormErrors => 'الرجاء إصلاح الأخطاء في النموذج';

  @override
  String get forbidden => 'الوصول محظور';

  @override
  String get gateway => 'البوابة';

  @override
  String get gatewayOptional => 'البوابة (اختياري)';

  @override
  String get gateways => 'البوابات';

  @override
  String get general => 'عام';

  @override
  String get generalSettings => 'الإعدادات العامة';

  @override
  String get generateKey => 'إنشاء مفتاح';

  @override
  String get generateKeyPair => 'إنشاء زوج مفاتيح';

  @override
  String get generateNewKeyPair => 'إنشاء زوج مفاتيح جديد';

  @override
  String get generateOrPasteKeyHere => 'قم بإنشاء أو لصق المفتاح هنا';

  @override
  String get generatePresharedKey => 'إنشاء مفتاح مشترك مسبقًا';

  @override
  String get generated => 'تم الإنشاء';

  @override
  String get generating => 'جاري الإنشاء...';

  @override
  String get gitCommit => 'التزام Git';

  @override
  String get healthStatus => 'حالة الصحة';

  @override
  String get hideControls => 'إخفاء عناصر التحكم';

  @override
  String get hideKey => 'إخفاء المفتاح';

  @override
  String get historySize => 'حجم السجل';

  @override
  String get host => 'المضيف';

  @override
  String get hostAddedSuccessfully => 'تمت إضافة المضيف بنجاح';

  @override
  String get hostBlocked => 'تم حظر المضيف بنجاح';

  @override
  String get hostDeletedSuccessfully => 'تم حذف المضيف بنجاح';

  @override
  String get hostHint => 'مثال: 192.168.1.1 أو firewall.example.com';

  @override
  String get hostIpAddress => 'المضيف / عنوان IP';

  @override
  String get hostIsRequired => 'المضيف مطلوب';

  @override
  String get hostPlaceholder => '192.168.1.1 أو firewall.example.com';

  @override
  String get hostUpdatedSuccessfully => 'تم تحديث المضيف بنجاح';

  @override
  String get hostname => 'اسم المضيف';

  @override
  String get hour => 'ساعة';

  @override
  String get hours => 'ساعات';

  @override
  String hoursAgo(int hours) {
    return 'منذ $hours ساعة';
  }

  @override
  String get id => 'المعرف';

  @override
  String get import => 'استيراد';

  @override
  String get importAndExport => 'الاستيراد والتصدير';

  @override
  String get importExportDescription =>
      'قم بتصدير ملفاتك الشخصية لنسخها احتياطياً أو نقلها إلى جهاز آخر. استيراد الملفات الشخصية من ملف تم تصديره مسبقاً.\n\nيتم حفظ الملفات الشخصية بتنسيق JSON ويمكن أن تتضمن نقاط الاتصال والإعدادات.';

  @override
  String importFailed(String error) {
    return 'فشل الاستيراد: $error';
  }

  @override
  String get importProfiles => 'استيراد الملفات الشخصية';

  @override
  String get importProfilesDialog =>
      'كيف يجب التعامل مع الملفات الشخصية الموجودة؟\n\n• الاحتفاظ بكليهما: الاستيراد بمعرفات جديدة\n• الكتابة فوق: استبدال الملفات الشخصية الموجودة';

  @override
  String get importProfilesSubtitle => 'استيراد الملفات الشخصية من ملف JSON';

  @override
  String get importSuccess => 'نجح الاستيراد';

  @override
  String importedWithFailures(int failed, int success) {
    String _temp0 = intl.Intl.pluralLogic(
      success,
      locale: localeName,
      other: 'ملفات شخصية',
      one: 'ملف شخصي',
    );
    return 'تم استيراد $success $_temp0، فشل $failed';
  }

  @override
  String inDays(int days) {
    return 'خلال $days يوم';
  }

  @override
  String inHours(int hours) {
    return 'خلال $hours ساعة';
  }

  @override
  String inMinutes(int minutes) {
    return 'خلال $minutes دقيقة';
  }

  @override
  String get inbound => 'وارد';

  @override
  String get includeCredentials => 'تضمين بيانات الاعتماد';

  @override
  String get incorrectPin => 'رمز PIN غير صحيح';

  @override
  String get info => 'معلومات';

  @override
  String get instance => 'المثيل';

  @override
  String get instanceCreatedSuccessfully => 'تم إنشاء المثيل بنجاح';

  @override
  String get instanceDeletedSuccessfully => 'تم حذف المثيل بنجاح';

  @override
  String get instanceDetails => 'تفاصيل المثيل';

  @override
  String instanceToggledSuccessfully(String status) {
    return 'تم $status المثيل بنجاح';
  }

  @override
  String get instanceUpdatedSuccessfully => 'تم تحديث المثيل بنجاح';

  @override
  String get instanceWillBeActiveWhenEnabled =>
      'سيكون المثيل نشطاً عند التفعيل';

  @override
  String get instances => 'المثيلات';

  @override
  String get interface => 'الواجهة';

  @override
  String get invalidApiKeyFormat => 'تنسيق مفتاح API غير صالح';

  @override
  String get invalidApiSecretFormat => 'تنسيق سر API غير صالح';

  @override
  String get invalidBase64Format => 'تنسيق Base64 غير صالح';

  @override
  String get invalidCidrNotation =>
      'تدوين CIDR غير صالح (استخدم التنسيق: IP/prefix)';

  @override
  String get invalidDestinationFormat => 'تنسيق الوجهة غير صالح';

  @override
  String invalidFileFormat(String error) {
    return 'ملف غير صالح: $error';
  }

  @override
  String get invalidHostnameOrIp => 'اسم مضيف أو عنوان IP غير صالح';

  @override
  String get invalidInput => 'إدخال غير صالح';

  @override
  String get invalidIpAddress => 'عنوان IP غير صالح';

  @override
  String get invalidIpAddressFormat =>
      'عنوان IP غير صالح (يجب أن يكون IPv4 أو IPv6)';

  @override
  String get invalidIpv4Address => 'عنوان IPv4 غير صالح';

  @override
  String get invalidIpv4CidrNotation => 'تدوين CIDR لـ IPv4 غير صالح';

  @override
  String get invalidIpv4Prefix => 'بادئة IPv4 غير صالحة (يجب أن تكون 0-32)';

  @override
  String get invalidIpv6Address => 'عنوان IPv6 غير صالح';

  @override
  String get invalidIpv6CidrNotation => 'تدوين CIDR لـ IPv6 غير صالح';

  @override
  String get invalidIpv6Prefix => 'بادئة IPv6 غير صالحة (يجب أن تكون 0-128)';

  @override
  String get invalidPin => 'PIN غير صالح';

  @override
  String get invalidPortFormat => 'تنسيق المنفذ غير صالح';

  @override
  String get invalidPrefixLength => 'طول البادئة غير صالح';

  @override
  String get invalidSourceFormat => 'تنسيق المصدر غير صالح';

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
  String get ipAddress => 'عنوان IP';

  @override
  String get ipAddresses => 'عناوين IP';

  @override
  String get ipAny => 'Any';

  @override
  String get ipProtocol => 'IP Version';

  @override
  String get ipv4TunnelNetwork => 'شبكة النفق IPv4';

  @override
  String get ipv6TunnelNetwork => 'شبكة النفق IPv6';

  @override
  String get iscDhcpDescription => 'خادم DHCP من Internet Systems Consortium';

  @override
  String itemsCount(int count) {
    return '$count عنصر';
  }

  @override
  String get justNow => 'الآن';

  @override
  String get keaDhcpDescription => 'خادم DHCP حديث وعالي الأداء';

  @override
  String get keepAliveIntervalOptional => 'فترة الحفاظ على الاتصال (اختياري)';

  @override
  String get keepBoth => 'الاحتفاظ بكليهما';

  @override
  String get keepState => 'Keep State';

  @override
  String get keepalive => 'الحفاظ على الاتصال';

  @override
  String get keepaliveOptional => 'الحفاظ على الاتصال (اختياري)';

  @override
  String get key => 'المفتاح';

  @override
  String get keyCopiedToClipboard => 'تم نسخ المفتاح إلى الحافظة';

  @override
  String get keyGeneratedSuccessfully => 'تم إنشاء المفتاح بنجاح';

  @override
  String keyWithId(String id) {
    return 'المفتاح $id';
  }

  @override
  String get keysGeneratedSuccessfully => 'تم إنشاء المفاتيح بنجاح';

  @override
  String get keysRequired => 'المفاتيح الخاصة والعامة مطلوبة';

  @override
  String get label => 'التسمية';

  @override
  String get labelHint => 'مثال: شبكة المنزل، VPN المكتب';

  @override
  String get labelOptional => 'التسمية (اختياري)';

  @override
  String get language => 'اللغة';

  @override
  String get lastDay => 'اليوم الأخير';

  @override
  String get lastDayShort => 'يوم واحد';

  @override
  String get lastMonth => 'الشهر الماضي';

  @override
  String get lastMonthShort => 'شهر واحد';

  @override
  String get lastUpdate => 'آخر تحديث';

  @override
  String lastUsed(String date) {
    return 'آخر استخدام: $date';
  }

  @override
  String get lastWeek => 'الأسبوع الماضي';

  @override
  String get lastWeekShort => 'أسبوع واحد';

  @override
  String leasesCount(int filtered, int total) {
    return '$filtered من $total عقد';
  }

  @override
  String get leaveEmptyOrGenerate => 'اتركه فارغاً أو قم بإنشائه';

  @override
  String get licenses => 'التراخيص';

  @override
  String get lightMode => 'الوضع الفاتح';

  @override
  String get limit => 'الحد';

  @override
  String get live => 'مباشر';

  @override
  String get liveNetworkMonitor => 'مراقب الشبكة المباشر';

  @override
  String get neighborDiscovery => 'اكتشاف الأجهزة المجاورة';

  @override
  String get loading => 'جاري التحميل...';

  @override
  String get loadingHostData => 'جاري تحميل بيانات المضيف...';

  @override
  String get loadingSettings => 'جاري تحميل الإعدادات...';

  @override
  String get localAddress => 'العنوان المحلي';

  @override
  String get localNetwork => 'الشبكة المحلية';

  @override
  String get localNetworkHelperText =>
      'هذه هي الشبكات التي يمكن للعميل الوصول إليها، يتم دفعها عبر بنود route(-ipv6) في OpenVPN إلى العميل.';

  @override
  String lockAfterMinutes(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'دقائق',
      one: 'دقيقة',
    );
    return 'القفل بعد $minutes $_temp0 من عدم النشاط';
  }

  @override
  String get lockApp => 'قفل التطبيق';

  @override
  String get lockTimeoutLabel => 'مهلة القفل';

  @override
  String lockTimeoutSet(int value) {
    String _temp0 = intl.Intl.pluralLogic(
      value,
      locale: localeName,
      other: 'دقائق',
      one: 'دقيقة',
    );
    return 'تم تعيين مهلة القفل إلى $value $_temp0';
  }

  @override
  String get longPressToCopy => 'Long press to copy';

  @override
  String get logDetails => 'تفاصيل السجل';

  @override
  String get logEntryCopied => 'تم نسخ إدخال السجل';

  @override
  String get logEntryDetails => 'تفاصيل إدخال السجل';

  @override
  String get logFile => 'ملف السجل';

  @override
  String get logLimit => 'حد السجلات';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get loginServer => 'خادم تسجيل الدخول';

  @override
  String get loginServerHelperText => 'عنوان URL لخادم تسجيل الدخول Tailscale';

  @override
  String get loginServerRequired => 'خادم تسجيل الدخول مطلوب';

  @override
  String get logTraffic => 'Log Traffic';

  @override
  String get logTrafficSubtitle => 'Log packets matched by this rule';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get logs => 'السجلات';

  @override
  String get logsExportedSuccessfully => 'تم تصدير السجلات بنجاح';

  @override
  String get logsMatchingFiltersWillAppearHere =>
      'ستظهر السجلات المطابقة للمرشحات هنا';

  @override
  String get logsWillAppear => 'ستظهر السجلات هنا عند إنشائها';

  @override
  String get macAddress => 'عنوان MAC';

  @override
  String get macAddressHint => 'مثال: 00:11:22:33:44:55';

  @override
  String get macAddressIsRequired => 'عنوان MAC مطلوب';

  @override
  String get invalidMacAddressFormat =>
      'تنسيق عنوان MAC غير صالح (مثال: AA:BB:CC:DD:EE:FF)';

  @override
  String get manageProfiles => 'إدارة الملفات الشخصية';

  @override
  String get manageSubnets => 'إدارة الشبكات الفرعية';

  @override
  String get manageWireguard => 'إدارة WireGuard';

  @override
  String get manufacturer => 'الشركة المصنعة';

  @override
  String get maximumTransmissionUnit => 'وحدة الإرسال القصوى (576-9000)';

  @override
  String get memoryUsage => 'استخدام الذاكرة';

  @override
  String get minute => 'دقيقة';

  @override
  String get minutes => 'دقائق';

  @override
  String minutesAgo(int minutes) {
    return 'منذ $minutes دقيقة';
  }

  @override
  String get mode => 'الوضع';

  @override
  String get modified => 'تم التعديل';

  @override
  String get modulateState => 'Modulate State';

  @override
  String get monitorInterface => 'واجهة المراقبة';

  @override
  String get mssFix => 'إصلاح MSS';

  @override
  String get mssFixDescription => 'تفعيل إصلاح MSS لهذا الاتصال';

  @override
  String get mtuOptional => 'MTU (اختياري)';

  @override
  String get mustBeValidUrl =>
      'يجب أن يكون عنوان URL صالحًا يبدأ بـ http:// أو https://';

  @override
  String get myOPNsenseRouter => 'جهاز التوجيه OPNsense الخاص بي';

  @override
  String get myOpenvpnInstance => 'مثيل OpenVPN الخاص بي';

  @override
  String get myStaticKey => 'مفتاحي الثابت';

  @override
  String get myWireguardPeer => 'نظير WireGuard الخاص بي';

  @override
  String get myWireguardServer => 'خادم WireGuard الخاص بي';

  @override
  String get name => 'الاسم';

  @override
  String get needHelpCheckDocumentation =>
      'تحتاج مساعدة؟ راجع وثائق OPNsense لإنشاء مفتاح API.';

  @override
  String get networkConfiguration => 'تكوين الشبكة';

  @override
  String get networkError => 'حدث خطأ في الشبكة';

  @override
  String get networkInformation => 'معلومات الشبكة';

  @override
  String get networkTotals => 'إجماليات الشبكة';

  @override
  String get newPin => 'رمز PIN الجديد (4-6 أرقام)';

  @override
  String get newPinMustBeDifferent =>
      'يجب أن يكون رمز PIN الجديد مختلفًا عن الحالي';

  @override
  String get newRule => 'قاعدة جديدة';

  @override
  String get newWireguardPeer => 'نظير WireGuard جديد';

  @override
  String get newWireguardServer => 'خادم WireGuard جديد';

  @override
  String get next => 'التالي';

  @override
  String get no => 'لا';

  @override
  String get noAliasesConfigured => 'لم يتم تكوين أسماء مستعارة';

  @override
  String get noAliasesMatchFilters =>
      'لا توجد أسماء مستعارة تطابق الفلاتر الحالية';

  @override
  String get noAutomationRulesFound => 'لم يتم العثور على قواعد أتمتة';

  @override
  String get noFirewallRulesFound => 'لم يتم العثور على قواعد جدار الحماية';

  @override
  String get noClientSpecificOverridesConfigured =>
      'لم يتم تكوين تجاوزات خاصة بالعميل';

  @override
  String noConnectionsFound(String type) {
    return 'لم يتم العثور على اتصالات $type';
  }

  @override
  String get noDataAvailable => 'لا توجد بيانات متاحة';

  @override
  String get noDescription => 'بدون وصف';

  @override
  String get noDnsDomainSearchEntriesConfigured =>
      'لم يتم تكوين إدخالات بحث نطاق DNS';

  @override
  String get noDnsDomainsConfigured => 'لم يتم تكوين نطاقات DNS';

  @override
  String get noDnsServersConfigured => 'لم يتم تكوين خوادم DNS';

  @override
  String get noHostsFound => 'لم يتم العثور على مضيفين';

  @override
  String get noInstancesMatchFilters => 'لا توجد مثيلات تطابق الفلاتر';

  @override
  String get noInterfacesWithAutomationRules => 'لا توجد واجهات بقواعد أتمتة';

  @override
  String get noInterfacesWithRules => 'لا توجد واجهات بقواعد';

  @override
  String get noItemsConfigured => 'لم يتم تكوين عناصر';

  @override
  String get noLeasesFound => 'لم يتم العثور على عقود';

  @override
  String get noLimit => 'بلا حد';

  @override
  String get noLimitShort => 'الكل';

  @override
  String get noLocalNetworksConfigured => 'لم يتم تكوين شبكات محلية';

  @override
  String get noLogEntriesFound => 'لم يتم العثور على إدخالات سجل';

  @override
  String get noLogsAvailable => 'لا توجد سجلات متاحة';

  @override
  String get noLogsToExport => 'لا توجد سجلات للتصدير';

  @override
  String get noNtpServersConfigured => 'لم يتم تكوين خوادم NTP';

  @override
  String get noOpenvpnInstancesConfigured => 'لم يتم تكوين مثيلات OpenVPN';

  @override
  String get noOpenvpnRoutesConfigured => 'لم يتم تكوين مسارات OpenVPN';

  @override
  String get noOpenvpnSessionsConfigured => 'لا توجد جلسات OpenVPN مكونة';

  @override
  String get noOptionsAvailable => 'لا توجد خيارات متاحة';

  @override
  String get noOverridesMatchFilter => 'لا توجد تجاوزات تطابق المرشح';

  @override
  String get noPeersAvailable => 'لا يوجد نظراء متاحون';

  @override
  String get noPeersMatchSearch => 'لا توجد أنداد تطابق بحثك';

  @override
  String get noProfiles => 'لا توجد ملفات تعريفية';

  @override
  String get noProfilesFound => 'لم يتم العثور على ملفات شخصية';

  @override
  String get noProfilesYet => 'لا توجد ملفات شخصية بعد';

  @override
  String get noRemoteNetworksConfigured => 'لم يتم تكوين شبكات بعيدة';

  @override
  String get noRoutesConfigured => 'لم يتم تكوين مسارات';

  @override
  String noRulesForInterface(String interface) {
    return 'لا توجد قواعد لـ $interface';
  }

  @override
  String get noServersAvailable => 'لا توجد خوادم متاحة';

  @override
  String get noServersMatchSearch => 'لا توجد خوادم تطابق بحثك';

  @override
  String get noServersSelected => 'لم يتم تحديد خوادم';

  @override
  String get noSessionsFound => 'لم يتم العثور على جلسات';

  @override
  String get noSettingsAvailable => 'لا توجد إعدادات متاحة';

  @override
  String get noStaticKeysConfigured => 'لم يتم تكوين مفاتيح ثابتة';

  @override
  String get noState => 'No State';

  @override
  String get noSubnetsConfigured => 'لا توجد شبكات فرعية مكونة';

  @override
  String get noTunnelAddressesConfigured => 'لم يتم تكوين عناوين النفق';

  @override
  String get noVpnConnectionsFound => 'لم يتم العثور على اتصالات VPN';

  @override
  String get noWinsServersConfigured => 'لم يتم تكوين خوادم WINS';

  @override
  String get noWireguardPeersConfigured => 'لم يتم تكوين أنداد WireGuard';

  @override
  String get noWireguardServersConfigured => 'لم يتم تكوين خوادم WireGuard';

  @override
  String get noWireguardStatusDataAvailable =>
      'لا توجد بيانات حالة WireGuard متاحة';

  @override
  String get noWolHostsConfigured => 'لم يتم تكوين مضيفي التنبيه عبر الشبكة';

  @override
  String get none => 'لا شيء';

  @override
  String get notAvailable => 'غير متاح';

  @override
  String get notFound => 'المورد غير موجود';

  @override
  String get notice => 'إشعار';

  @override
  String get ntpServers => 'خوادم NTP';

  @override
  String get ntpServersHelperText =>
      'تعيين عنوان خادم NTP الأساسي (بروتوكول وقت الشبكة). كرر هذا الخيار لتعيين عناوين خادم NTP الثانوية.';

  @override
  String get offline => 'غير متصل';

  @override
  String get ok => 'موافق';

  @override
  String get oneHour => '1 ساعة';

  @override
  String get oneMin => '1 دقيقة';

  @override
  String get online => 'متصل';

  @override
  String get openvpnConnectionStatus => 'حالة اتصال OpenVPN';

  @override
  String get openvpnInstances => 'مثيلات OpenVPN';

  @override
  String get openvpnLogFile => 'ملف سجل OpenVPN';

  @override
  String get optional => 'اختياري';

  @override
  String get optionalBase64EncodedPresharedKey =>
      'مفتاح مشترك مسبقاً مشفر بـ Base64 (اختياري)';

  @override
  String get outbound => 'صادر';

  @override
  String get overrideCreatedSuccessfully => 'تم إنشاء التجاوز بنجاح';

  @override
  String get overrideDeletedSuccessfully => 'تم حذف التجاوز بنجاح';

  @override
  String get overrideDetails => 'تفاصيل التجاوز';

  @override
  String overrideToggledSuccessfully(String status) {
    return 'تم $status التجاوز بنجاح';
  }

  @override
  String get overrideUpdatedSuccessfully => 'تم تحديث التجاوز بنجاح';

  @override
  String get overwrite => 'الكتابة فوق';

  @override
  String get packageMirror => 'مرآة الحزمة';

  @override
  String get packetLength => 'طول الحزمة';

  @override
  String get pass => 'سماح';

  @override
  String get pause => 'إيقاف مؤقت';

  @override
  String get pauseLiveViewToSelect => 'أوقف العرض المباشر لتحديد إدخالات السجل';

  @override
  String get paused => 'متوقف مؤقتاً';

  @override
  String get peerCreatedReadyForNext =>
      'تم إنشاء النظير بنجاح. جاهز للنظير التالي.';

  @override
  String get peerCreatedSuccessfully => 'تم إنشاء النظير بنجاح';

  @override
  String get peerDeletedSuccessfully => 'تم حذف النظير بنجاح';

  @override
  String get peerDisabledSuccessfully => 'تم تعطيل النظير بنجاح';

  @override
  String get peerEnabledSuccessfully => 'تم تمكين النظير بنجاح';

  @override
  String get peerGenerator => 'منشئ النظير';

  @override
  String get peerUpdatedSuccessfully => 'تم تحديث النظير بنجاح';

  @override
  String get peerWillBeActiveWhenEnabled => 'سيكون النظير نشطًا عند التمكين';

  @override
  String get peers => 'النظراء';

  @override
  String peersConfigured(int count) {
    return '$count نظير مكون';
  }

  @override
  String get peersCount => 'عدد الأقران';

  @override
  String peersSelected(int count) {
    return 'تم تحديد $count من الأقران';
  }

  @override
  String get persistentKeepaliveSeconds =>
      'الحفاظ على الاتصال المستمر بالثواني (موصى به: 25)';

  @override
  String get pinChangedSuccessfully => 'تم تغيير رمز PIN بنجاح';

  @override
  String get pinLock => 'قفل PIN';

  @override
  String get pinLockDisabled =>
      'تم تعطيل قفل PIN. تم تعطيل القفل البيومتري أيضاً.';

  @override
  String get pinLockEnabled => 'تم تفعيل قفل PIN';

  @override
  String get pinMismatch => 'رموز PIN غير متطابقة';

  @override
  String get pinMustContainOnlyNumbers => 'يجب أن يحتوي رمز PIN على أرقام فقط';

  @override
  String get pinTooShort => 'يجب أن يكون PIN 4 أرقام على الأقل';

  @override
  String get platform => 'المنصة';

  @override
  String get pleaseEnterCurrentPin => 'الرجاء إدخال رمز PIN الحالي';

  @override
  String get pleaseEnterNewPin => 'الرجاء إدخال رمز PIN جديد';

  @override
  String get pleaseEnterSubnet => 'الرجاء إدخال شبكة فرعية';

  @override
  String get pleaseEnterYourPin => 'الرجاء إدخال رمز PIN الخاص بك';

  @override
  String get pleaseSelectAnInstance => 'يرجى تحديد مثيل';

  @override
  String get pleaseSelectInterface => 'يرجى تحديد واجهة';

  @override
  String get port => 'المنفذ';

  @override
  String get portHint => 'مثال: 443';

  @override
  String get portIsRequired => 'المنفذ مطلوب';

  @override
  String portLabel(String port) {
    return 'المنفذ $port';
  }

  @override
  String get portMustBeBetween => 'يجب أن يكون المنفذ بين 1 و 65535';

  @override
  String get preAuthKey => 'مفتاح المصادقة المسبقة';

  @override
  String get preAuthKeyHelperText =>
      'اختياري: مفتاح المصادقة المسبقة لتسجيل الجهاز التلقائي';

  @override
  String get presharedKeyGeneratedSuccessfully =>
      'تم إنشاء المفتاح المشترك مسبقاً بنجاح';

  @override
  String get presharedKeyOptional => 'المفتاح المشترك مسبقًا (اختياري)';

  @override
  String get preventAutomaticRouteInstallation => 'منع التثبيت التلقائي للمسار';

  @override
  String get previous => 'السابق';

  @override
  String get privateKey => 'المفتاح الخاص';

  @override
  String get profileActivated => 'تم تفعيل الملف الشخصي بنجاح';

  @override
  String get profileAdded => 'تمت إضافة الملف الشخصي';

  @override
  String get profileDeleted => 'تم حذف الملف الشخصي بنجاح';

  @override
  String get profileHasNoEndpoints => 'الملف الشخصي ليس لديه نقاط اتصال مكونة';

  @override
  String get profileName => 'اسم الملف الشخصي';

  @override
  String get profileNameOptional => 'اسم الملف الشخصي (اختياري)';

  @override
  String get profileNameRequired => 'اسم الملف التعريفي مطلوب';

  @override
  String get profileSaved => 'تم حفظ الملف الشخصي بنجاح';

  @override
  String get profileUpdated => 'تم تحديث الملف الشخصي';

  @override
  String get profiles => 'الملفات الشخصية';

  @override
  String profilesExportedSuccessfully(String path) {
    return 'تم تصدير الملفات الشخصية بنجاح!\n$path';
  }

  @override
  String get protocol => 'البروتوكول';

  @override
  String get publicKey => 'المفتاح العام';

  @override
  String get publicKeyColon => 'المفتاح العام:';

  @override
  String get publicKeyRequired => 'المفتاح العام مطلوب';

  @override
  String publicKeyShort(String key) {
    return '$key...';
  }

  @override
  String get pushReset => 'إعادة تعيين الدفع';

  @override
  String get pushVirtualIpEndpoints =>
      'دفع نقاط نهاية IP الافتراضية لنفق العميل، متجاوزًا التخصيص الديناميكي.';

  @override
  String get qrCode => 'رمز QR';

  @override
  String get quickRule => 'Quick Rule';

  @override
  String get quickRuleSubtitle => 'Stop processing rules after first match';

  @override
  String get reason => 'السبب';

  @override
  String get rebootConfirmation =>
      'هل أنت متأكد من رغبتك في إعادة تشغيل النظام؟';

  @override
  String get rebootFailed => 'فشل في إعادة تشغيل النظام';

  @override
  String rebootFailedWithError(String message, String error) {
    return '$message: $error';
  }

  @override
  String get rebootSuccess => 'تم بدء إعادة تشغيل النظام';

  @override
  String get rebootSystem => 'إعادة تشغيل النظام';

  @override
  String get received => 'المستلم';

  @override
  String get recommendedForSecureConnections => 'موصى به للاتصالات الآمنة';

  @override
  String get redirectGateway => 'إعادة توجيه البوابة';

  @override
  String get refresh => 'تحديث';

  @override
  String get registerDns => 'تسجيل DNS';

  @override
  String get reject => 'رفض';

  @override
  String get remoteAddress => 'العنوان البعيد';

  @override
  String get remoteNetwork => 'الشبكة البعيدة';

  @override
  String get remoteNetworkHelperText =>
      'الشبكات البعيدة للخادم، يتم تكوينها عبر بنود iroute(-ipv6) في OpenVPN وتُعلم الخادم بإرسال هذه الشبكات إلى هذا العميل المحدد.';

  @override
  String get repository => 'المستودع';

  @override
  String get requirePinToUnlock => 'يتطلب PIN لفتح التطبيق';

  @override
  String get required => 'مطلوب';

  @override
  String get restart => 'إعادة التشغيل';

  @override
  String get restartService => 'إعادة تشغيل الخدمة';

  @override
  String restartServiceConfirmation(String type) {
    return 'هل أنت متأكد من رغبتك في إعادة تشغيل خدمة $type؟\n\nسيؤدي هذا إلى قطع جميع الاتصالات النشطة مؤقتًا.';
  }

  @override
  String get restartVpnService => 'إعادة تشغيل خدمة VPN';

  @override
  String restartingService(String type) {
    return 'جاري إعادة تشغيل خدمة $type...';
  }

  @override
  String get resume => 'استئناف';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get role => 'الدور';

  @override
  String get routeGateway => 'بوابة المسار';

  @override
  String get routeGatewayHelperText =>
      'حدد بوابة افتراضية لاستخدامها للعميل المتصل. بدون تعيين واحد، يتم تقديم العنوان الأول في كتلة الشبكة. عند تقسيم شبكة النفق (الخادم)، قد لا يكون هذا متاحًا من العميل.';

  @override
  String get routes => 'المسارات';

  @override
  String get routing => 'التوجيه';

  @override
  String get rowsPerPageLabel => 'الصفوف لكل صفحة: ';

  @override
  String get ruleActionFailed => 'فشل إجراء القاعدة';

  @override
  String get ruleCreated => 'تم إنشاء القاعدة بنجاح';

  @override
  String get ruleDeleted => 'تم حذف القاعدة بنجاح';

  @override
  String get ruleDescription => 'وصف القاعدة';

  @override
  String get ruleDetails => 'تفاصيل القاعدة';

  @override
  String get ruleDisabledSuccessfully => 'تم تعطيل القاعدة بنجاح';

  @override
  String get ruleEnabledSuccessfully => 'تم تفعيل القاعدة بنجاح';

  @override
  String get ruleGuidelines => 'إرشادات القاعدة';

  @override
  String get ruleGuidelinesText =>
      '• استخدم \"any\" لمطابقة جميع العناوين أو المنافذ\n• تدوين CIDR: 192.168.1.0/24\n• نطاقات المنافذ: 80-443\n• تتم معالجة القواعد بالترتيب\n• يتم تطبيق التغييرات فوراً';

  @override
  String get ruleId => 'معرف القاعدة';

  @override
  String get ruleInformation => 'معلومات القاعدة';

  @override
  String get ruleUpdated => 'تم تحديث القاعدة بنجاح';

  @override
  String get ruleWillBeActiveWhenEnabled => 'ستكون القاعدة نشطة عند التفعيل';

  @override
  String get running => 'قيد التشغيل';

  @override
  String get save => 'حفظ';

  @override
  String get saveAndConnect => 'حفظ واتصال';

  @override
  String get saveSettings => 'حفظ الإعدادات';

  @override
  String get saveWithoutTesting => 'حفظ بدون اختبار';

  @override
  String get saving => 'جاري الحفظ...';

  @override
  String get savingOverride => 'حفظ التجاوز...';

  @override
  String get savingProfile => 'جاري حفظ الملف الشخصي...';

  @override
  String get searchAliases => 'البحث عن الأسماء المستعارة...';

  @override
  String get searchHostnameIpOrMac => 'البحث عن اسم المضيف أو IP أو MAC...';

  @override
  String get searchHostnameOrIp => 'البحث عن اسم المضيف أو عنوان IP...';

  @override
  String get searchInstances => 'البحث عن المثيلات...';

  @override
  String get searchOverrides => 'البحث عن التجاوزات...';

  @override
  String get searchPeers => 'البحث عن الأنداد...';

  @override
  String get searchServers => 'البحث عن الخوادم...';

  @override
  String get second => 'ثانية';

  @override
  String get seconds => 'ثواني';

  @override
  String get security => 'الأمان';

  @override
  String get securityWarning => 'تحذير أمني';

  @override
  String get selectAProfileOrCreateNewOne =>
      'حدد ملفاً شخصياً أو أنشئ ملفاً جديداً';

  @override
  String get selectAll => 'تحديد الكل';

  @override
  String get selectExitNode => 'تحديد عقدة الخروج';

  @override
  String get selectInterface => 'حدد الواجهة';

  @override
  String get selectInterfaceToViewRules => 'حدد واجهة لعرض القواعد';

  @override
  String selectLabel(String label) {
    return 'اختر $label';
  }

  @override
  String get selectMultipleInterfaces => 'حدد واجهة واحدة أو أكثر للمراقبة';

  @override
  String get selectNumberOfEntries => 'حدد عدد إدخالات السجل المراد عرضها:';

  @override
  String get selectPeers => 'تحديد النظراء';

  @override
  String get selectServerAndGenerateKeys =>
      'حدد خادمًا وأنشئ مفاتيح لمعاينة التكوين';

  @override
  String get selectServerForQrCode => 'تحديد الخادم لإنشاء رمز QR';

  @override
  String get selectServerInstance => 'الرجاء تحديد مثيل الخادم';

  @override
  String get selectServers => 'تحديد الخوادم';

  @override
  String get selectServersHelperText =>
      'حدد خوادم OpenVPN التي ينطبق عليها هذا التجاوز، اتركه فارغاً للكل';

  @override
  String get selectVhid => 'اختر VHID';

  @override
  String get selected => 'محدد';

  @override
  String get selfSignedCertWarning =>
      'تحذير: الشهادات الموقعة ذاتياً أقل أماناً. قم بتفعيل هذا فقط إذا كنت تثق بالخادم.';

  @override
  String get selfSignedCertificatesWarning =>
      'قم بتفعيل هذا فقط إذا كنت تثق بالخادم';

  @override
  String get sent => 'المرسل';

  @override
  String get sequence => 'التسلسل';

  @override
  String get server => 'الخادم';

  @override
  String get serverAddress => 'عنوان الخادم';

  @override
  String get serverCreatedSuccessfully => 'تم إنشاء الخادم بنجاح';

  @override
  String get serverDeletedSuccessfully => 'تم حذف الخادم بنجاح';

  @override
  String get serverDisabledSuccessfully => 'تم تعطيل الخادم بنجاح';

  @override
  String get serverEnabledSuccessfully => 'تم تمكين الخادم بنجاح';

  @override
  String get serverError => 'حدث خطأ في الخادم';

  @override
  String get serverInfoNotLoaded => 'لم يتم تحميل معلومات الخادم';

  @override
  String get serverNetwork => 'شبكة الخادم';

  @override
  String get serverPort => 'منفذ الخادم';

  @override
  String get serverSelectionRequired => 'يجب تحديد خادم واحد على الأقل';

  @override
  String get serverUpdatedSuccessfully => 'تم تحديث الخادم بنجاح';

  @override
  String get serverWillBeActiveWhenEnabled => 'سيكون الخادم نشطًا عند التمكين';

  @override
  String get servers => 'الخوادم';

  @override
  String serversSelected(int count) {
    return '$count خادم (خوادم) محددة';
  }

  @override
  String get serviceActionFailed => 'فشل إجراء الخدمة';

  @override
  String get serviceControls => 'عناصر تحكم الخدمة';

  @override
  String get serviceRestartedSuccessfully => 'تمت إعادة تشغيل الخدمة بنجاح';

  @override
  String get serviceRunning => 'الخدمة قيد التشغيل';

  @override
  String get serviceStartedSuccessfully => 'تم بدء الخدمة بنجاح';

  @override
  String get serviceStatus => 'حالة الخدمة';

  @override
  String get serviceStoppedSuccessfully => 'تم إيقاف الخدمة بنجاح';

  @override
  String get services => 'الخدمات';

  @override
  String get sessionTimeout => 'مهلة الجلسة';

  @override
  String get sessions => 'الجلسات';

  @override
  String get setAsActive => 'تعيين كنشط';

  @override
  String get setPin => 'تعيين PIN';

  @override
  String get settings => 'الإعدادات';

  @override
  String severitiesAndTimeFilter(int count, String timeFilter) {
    return '$count شدة • $timeFilter';
  }

  @override
  String get severity => 'الخطورة';

  @override
  String get severityEmergency => 'طوارئ';

  @override
  String get severityEmergencyShort => 'طوارئ';

  @override
  String get severityError => 'خطأ';

  @override
  String get severityInformational => 'معلوماتي';

  @override
  String get severityInformationalShort => 'معلومات';

  @override
  String get showAdvancedSettings => 'إظهار الإعدادات المتقدمة';

  @override
  String get showAll => 'عرض الكل';

  @override
  String get showKey => 'إظهار المفتاح';

  @override
  String showingInstancesCount(String count, String total) {
    return 'عرض $count من $total';
  }

  @override
  String get showingZeroEntries => 'عرض 0 إدخالات';

  @override
  String get someConnectionsFailed => 'فشلت بعض الاتصالات';

  @override
  String get soon => 'قريباً';

  @override
  String get sortBy => 'ترتيب حسب';

  @override
  String get sortByBandwidth => 'النطاق الترددي';

  @override
  String get sortByHostname => 'اسم المضيف';

  @override
  String get sortByIP => 'عنوان IP';

  @override
  String get sortByManufacturer => 'الشركة المصنعة';

  @override
  String get source => 'المصدر';

  @override
  String get sourceAddress => 'عنوان المصدر';

  @override
  String get sourceIsRequired => 'المصدر مطلوب';

  @override
  String get sourcePort => 'منفذ المصدر';

  @override
  String get sourcePortOptional => 'منفذ المصدر (اختياري)';

  @override
  String get sloppyState => 'Sloppy State';

  @override
  String get sshEnabled => 'SSH مفعل';

  @override
  String get start => 'بدء';

  @override
  String get startService => 'بدء الخدمة';

  @override
  String get startTime => 'وقت البدء';

  @override
  String get startWireguardService => 'بدء خدمة WireGuard';

  @override
  String get staticKeyContentPemFormat => 'محتوى المفتاح الثابت بتنسيق PEM';

  @override
  String get staticKeyCreatedSuccessfully => 'تم إنشاء المفتاح الثابت بنجاح';

  @override
  String get staticKeyDeletedSuccessfully => 'تم حذف المفتاح الثابت بنجاح';

  @override
  String get staticKeyDetails => 'تفاصيل المفتاح الثابت';

  @override
  String get staticKeyInformation => 'معلومات المفتاح الثابت';

  @override
  String get staticKeyUpdatedSuccessfully => 'تم تحديث المفتاح الثابت بنجاح';

  @override
  String get staticKeys => 'المفاتيح الثابتة';

  @override
  String get staticLease => 'ثابت';

  @override
  String get stateType => 'State Type';

  @override
  String get status => 'الحالة';

  @override
  String get stop => 'إيقاف';

  @override
  String get stopService => 'إيقاف الخدمة';

  @override
  String get stopped => 'متوقف';

  @override
  String get storeAndGenerateNext => 'حفظ وإنشاء التالي';

  @override
  String get subnetAddedSuccessfully => 'تمت إضافة الشبكة الفرعية بنجاح';

  @override
  String get subnetCidr => 'الشبكة الفرعية (CIDR)';

  @override
  String get subnetDeletedSuccessfully => 'تم حذف الشبكة الفرعية بنجاح';

  @override
  String get subnetUpdatedSuccessfully => 'تم تحديث الشبكة الفرعية بنجاح';

  @override
  String get success => 'نجاح';

  @override
  String successfullyConnected(String name) {
    return 'تم الاتصال بنجاح بـ $name';
  }

  @override
  String successfullyDisconnected(String name) {
    return 'تم قطع الاتصال بنجاح بـ $name';
  }

  @override
  String successfullyImportedProfiles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ملفات شخصية',
      one: 'ملف شخصي',
    );
    return 'تم استيراد $count $_temp0 بنجاح';
  }

  @override
  String successfullyRestartedService(String type) {
    return 'تم إعادة تشغيل خدمة $type بنجاح';
  }

  @override
  String successfullyWokenDevices(int successCount, int totalCount) {
    String _temp0 = intl.Intl.pluralLogic(
      successCount,
      locale: localeName,
      other: 'جهاز',
      many: 'جهازًا',
      few: 'أجهزة',
      two: 'جهازين',
      one: 'جهاز',
      zero: 'جهاز',
    );
    return 'تم تنبيه $successCount من $totalCount $_temp0 بنجاح';
  }

  @override
  String get switchProfile => 'تبديل الملف الشخصي';

  @override
  String get switchProfileConfirmation =>
      'هل أنت متأكد من رغبتك في تبديل الملفات الشخصية؟ سيتم إرجاعك إلى شاشة اختيار الملف الشخصي.';

  @override
  String get systemDefault => 'افتراضي النظام';

  @override
  String get systemGeneratedRule =>
      'هذه قاعدة تم إنشاؤها بواسطة النظام ولا يمكن تعديلها أو حذفها.';

  @override
  String get systemGeneratedRulesCannotBeDeleted =>
      'لا يمكن حذف القواعد التي تم إنشاؤها بواسطة النظام';

  @override
  String get systemGeneratedRulesCannotBeModified =>
      'لا يمكن تعديل القواعد التي تم إنشاؤها بواسطة النظام';

  @override
  String get systemInformation => 'معلومات النظام';

  @override
  String get systemType => 'نوع النظام';

  @override
  String get swapSourceDestination => 'Swap source and destination';

  @override
  String get synproxyState => 'Synproxy State';

  @override
  String get tags => 'العلامات';

  @override
  String get tailscaleAuthentication => 'مصادقة Tailscale';

  @override
  String tailscaleServiceAction(String action) {
    return '$action خدمة Tailscale';
  }

  @override
  String tailscaleServiceActionConfirmation(String action) {
    return 'هل أنت متأكد أنك تريد $action خدمة Tailscale؟';
  }

  @override
  String tailscaleServiceActionSuccess(String action) {
    return 'تم $action خدمة Tailscale بنجاح';
  }

  @override
  String tailscaleServiceActioning(String action) {
    return 'جاري $action خدمة Tailscale...';
  }

  @override
  String get tailscaleSettings => 'إعدادات Tailscale';

  @override
  String get tailscaleStatus => 'حالة Tailscale';

  @override
  String get tailscaleSubnets => 'شبكات Tailscale الفرعية';

  @override
  String get tailscaleVersion => 'الإصدار';

  @override
  String get tapPlusButtonToCreateFirstInstance =>
      'اضغط على زر + لإنشاء أول مثيل';

  @override
  String get tapPlusButtonToCreateFirstOverride =>
      'اضغط على زر + لإنشاء أول تجاوز';

  @override
  String get tapPlusButtonToCreateFirstStaticKey =>
      'اضغط على زر + لإنشاء أول مفتاح ثابت';

  @override
  String get tcpFlags => 'علامات TCP';

  @override
  String get tenMin => '10 دقائق';

  @override
  String get testConnection => 'اختبار الاتصال';

  @override
  String get testConnections => 'اختبار الاتصالات';

  @override
  String get testProfile => 'اختبار الملف الشخصي';

  @override
  String get testingAllConnections => 'اختبار جميع نقاط الاتصال...';

  @override
  String testingConnection(String current, String total, String endpoint) {
    return 'اختبار الاتصال $current من $total: $endpoint';
  }

  @override
  String get theme => 'السمة';

  @override
  String get thirtyMin => '30 دقيقة';

  @override
  String get time => 'الوقت';

  @override
  String get timeRange => 'النطاق الزمني';

  @override
  String get timeout => 'انتهت مهلة الطلب';

  @override
  String get timestamp => 'الطابع الزمني';

  @override
  String get today => 'اليوم';

  @override
  String get totalBandwidth => 'إجمالي النطاق الترددي';

  @override
  String get totalDownload => 'إجمالي التنزيل';

  @override
  String get totalEntries => 'إجمالي الإدخالات';

  @override
  String get totalUpload => 'إجمالي الرفع';

  @override
  String get totalVpns => 'إجمالي VPN';

  @override
  String get tryAdjustingFilters =>
      'حاول ضبط مستوى الخطورة أو فلاتر التاريخ المحددة.';

  @override
  String get tryDemoMode => 'تجربة وضع العرض التوضيحي';

  @override
  String get tryDifferentSearch => 'جرب مصطلح بحث مختلف';

  @override
  String get tunnelAddress => 'عنوان النفق';

  @override
  String get tunnelAddressCidr => 'عنوان النفق (CIDR)';

  @override
  String get tunnelAddresses => 'عناوين النفق';

  @override
  String tunnelLabel(String network) {
    return 'النفق: $network';
  }

  @override
  String get tunnelNetwork => 'شبكة النفق';

  @override
  String get tunnelSettings => 'إعدادات النفق';

  @override
  String get twoMin => '2 دقيقة';

  @override
  String get type => 'النوع';

  @override
  String typeWithValue(String value) {
    return 'النوع: $value';
  }

  @override
  String get udpPortDefault51820 => 'منفذ UDP (افتراضي: 51820)';

  @override
  String get unableToAccessFilePath => 'غير قادر على الوصول إلى مسار الملف';

  @override
  String get unableToConnectToAnyEndpoint =>
      'تعذر الاتصال بأي من نقاط النهاية المكونة. يرجى التحقق من إعدادات الشبكة والمحاولة مرة أخرى.';

  @override
  String get unauthorized => 'وصول غير مصرح به';

  @override
  String get unknown => 'غير معروف';

  @override
  String get unlock => 'فتح';

  @override
  String get unlockOpnsenseManager => 'فتح OPNsense Manager';

  @override
  String get unnamedHost => 'مضيف بدون اسم';

  @override
  String get unnamedInstance => 'مثيل بدون اسم';

  @override
  String get unnamedRule => 'قاعدة بدون اسم';

  @override
  String get unsavedChanges => 'تغييرات غير محفوظة';

  @override
  String get unsavedChangesConfirmation =>
      'لديك تغييرات غير محفوظة. هل تريد تجاهلها والمتابعة؟';

  @override
  String get update => 'تحديث';

  @override
  String get updateOverride => 'تحديث التجاوز';

  @override
  String get updatePeer => 'تحديث النظير';

  @override
  String get updatePinCode => 'تحديث رمز PIN الخاص بك';

  @override
  String get updateRule => 'تحديث القاعدة';

  @override
  String get updateServer => 'تحديث الخادم';

  @override
  String get updateStaticKey => 'تحديث المفتاح الثابت';

  @override
  String get upload => 'الرفع';

  @override
  String get uptime => 'وقت التشغيل';

  @override
  String get useBiometric => 'استخدام البيومترية';

  @override
  String useBiometricToUnlock(String biometricType) {
    return 'استخدم $biometricType لفتح التطبيق';
  }

  @override
  String get useExitNode => 'استخدام عقدة الخروج';

  @override
  String get useHttps => 'استخدام HTTPS';

  @override
  String get useHttpsDescription => 'استخدام اتصال HTTPS آمن';

  @override
  String get useProtocolForCommunicating => 'استخدم هذا البروتوكول للاتصال';

  @override
  String get valid => 'صالح';

  @override
  String get validFrom => 'صالح من';

  @override
  String verifyingConnection(String endpoint) {
    return 'التحقق من الاتصال بـ $endpoint...';
  }

  @override
  String version(String version) {
    return 'الإصدار $version';
  }

  @override
  String get versionLabel => 'الإصدار';

  @override
  String get viewDetails => 'عرض التفاصيل';

  @override
  String get viewFullLicense => 'عرض الرخصة الكاملة';

  @override
  String get virtualAddress => 'العنوان الافتراضي';

  @override
  String get vpn => 'VPN';

  @override
  String get vpnConnections => 'اتصالات VPN';

  @override
  String get vpnConnectionsWillAppear => 'ستظهر اتصالات VPN هنا عند تكوينها';

  @override
  String get vpnStatus => 'حالة VPN';

  @override
  String get vpnType => 'نوع VPN';

  @override
  String get wakeAll => 'تنبيه الكل';

  @override
  String get wakeAllDevices => 'تنبيه جميع الأجهزة';

  @override
  String get wakeAllDevicesConfirmation =>
      'هل أنت متأكد من رغبتك في إرسال حزم التنبيه إلى جميع الأجهزة المكونة؟';

  @override
  String get wakeAllResults => 'نتائج تنبيه الكل';

  @override
  String get wakeHost => 'تنبيه المضيف';

  @override
  String get wakeOnLan => 'التنبيه عبر الشبكة';

  @override
  String get wakingAllDevices => 'جاري تنبيه جميع الأجهزة...';

  @override
  String get warning => 'تحذير';

  @override
  String get winsServers => 'خوادم WINS';

  @override
  String get winsServersHelperText =>
      'تعيين عنوان خادم WINS الأساسي (خادم اسم NetBIOS عبر TCP/IP). كرر هذا الخيار لتعيين عناوين خادم WINS الثانوية.';

  @override
  String get wireguardLogs => 'سجلات WireGuard';

  @override
  String get wireguardLogsExport => 'تصدير سجلات WireGuard';

  @override
  String wireguardLogsExportedOn(String date) {
    return 'تم تصدير سجلات WireGuard في $date';
  }

  @override
  String get wireguardPeers => 'نظراء WireGuard';

  @override
  String get wireguardServers => 'خوادم WireGuard';

  @override
  String get wireguardServiceStarted => 'تم بدء خدمة WireGuard';

  @override
  String get wireguardServiceStopped => 'تم إيقاف خدمة WireGuard';

  @override
  String get wireguardStatus => 'حالة WireGuard';

  @override
  String get withoutCredentials => 'بدون بيانات الاعتماد';

  @override
  String wolPacketSentTo(String host) {
    return 'تم إرسال حزمة WOL إلى $host';
  }

  @override
  String get yes => 'نعم';

  @override
  String get yesterday => 'أمس';

  @override
  String get zeroSeconds => '0 ثانية';

  @override
  String get connectionBlockingDescription =>
      'حظر اتصال العميل هذا بناءً على اسمه الشائع. لا تستخدم هذا الخيار لتعطيل عميل بشكل دائم بسبب مفتاح أو كلمة مرور مخترقة. استخدم CRL (قائمة إلغاء الشهادات) بدلاً من ذلك.';

  @override
  String deviceLabel(String type) {
    return 'الجهاز: $type';
  }

  @override
  String get facility => 'المرفق';

  @override
  String gatewayLabel(String gateway) {
    return 'البوابة: $gateway';
  }

  @override
  String localLabel(String address) {
    return 'محلي: $address';
  }

  @override
  String get messageLabel => 'الرسالة:';

  @override
  String pageOfTotal(int current, int total) {
    return 'الصفحة $current من $total';
  }

  @override
  String get parser => 'المحلل';

  @override
  String pidLabel(String pid) {
    return 'PID: $pid';
  }

  @override
  String processLabel(String process) {
    return 'العملية: $process';
  }

  @override
  String get pushResetDescription =>
      'لا ترث قائمة الدفع العامة لمثيل عميل معين. ملاحظة: --push-reset شامل جدًا: سيزيل جميع الخيارات تقريبًا من قائمة الخيارات المراد دفعها. في كثير من الحالات، سيحتاج بعض هذه الخيارات إلى إعادة تكوين بعد ذلك - على وجه التحديد، سيتم فقدان --topology subnet و --route-gateway وسيؤدي ذلك إلى كسر تكوينات العميل في كثير من الحالات.';

  @override
  String get record => 'السجل';

  @override
  String get redirectGatewayDescription =>
      'تنفيذ أوامر التوجيه تلقائيًا للتسبب في إعادة توجيه جميع حركة مرور IP الصادرة عبر VPN.';

  @override
  String get registerDnsDescription =>
      'تشغيل ipconfig /flushdns و ipconfig /registerdns عند بدء الاتصال. من المعروف أن هذا يدفع Windows إلى التعرف على خوادم DNS المدفوعة.';

  @override
  String remoteLabel(String info) {
    return 'بعيد: $info';
  }

  @override
  String selectedCount(int count) {
    return '$count محدد';
  }

  @override
  String serverLabel(String info) {
    return 'الخادم: $info';
  }

  @override
  String severityLabel(String severity) {
    return 'الشدة: $severity';
  }

  @override
  String showingEntries(int start, int end) {
    return 'عرض $start إلى $end';
  }

  @override
  String timestampLabel(String timestamp) {
    return 'الطابع الزمني: $timestamp';
  }

  @override
  String typeLabel(String type) {
    return 'النوع: $type';
  }

  @override
  String get unknownNetwork => 'شبكة غير معروفة';

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
  String get staticKeyDescriptionHelper =>
      'A descriptive name for this static key';

  @override
  String get selectKeyModeHelper =>
      'Select the key mode for authentication or encryption';

  @override
  String get staticKeyHelpText =>
      '• Auth: Adds HMAC authentication to control channel\n• Crypt: Encrypts and authenticates all control channel packets\n• Crypt V2: Enhanced encryption with improved security\n\nYou can generate a new key or paste an existing one.';

  @override
  String get device => 'الجهاز';

  @override
  String get listenPort => 'منفذ الاستماع';

  @override
  String get fwMark => 'علامة جدار الحماية';

  @override
  String get peerStatus => 'حالة النظير';

  @override
  String get handshakeAge => 'عمر المصافحة';

  @override
  String secondsAgo(int count) {
    return 'منذ $count ثانية';
  }

  @override
  String get handshake => 'المصافحة';

  @override
  String get processInformation => 'معلومات العملية';

  @override
  String get processName => 'اسم العملية';

  @override
  String get processId => 'معرّف العملية';

  @override
  String get logMessage => 'رسالة السجل';

  @override
  String get message => 'الرسالة';

  @override
  String get timestampInformation => 'معلومات الطابع الزمني';

  @override
  String get rawTimestamp => 'الطابع الزمني الخام';

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

  @override
  String get portsNotSupportedTitle => 'Port Fields Will Be Cleared';

  @override
  String get portsNotSupportedMessage =>
      'The selected protocol does not support source or destination ports. The port fields will be cleared before saving.';

  @override
  String get clearAndSave => 'Clear & Save';

  @override
  String get createAlias => 'Create Alias';

  @override
  String get editAlias => 'Edit Alias';

  @override
  String get aliasCreated => 'Alias created successfully';

  @override
  String get aliasUpdated => 'Alias updated successfully';

  @override
  String errorSavingAlias(String error) {
    return 'Error saving alias: $error';
  }

  @override
  String get aliasNameLabel => 'Name';

  @override
  String get aliasNameHint => 'Letters, digits, and underscores only';

  @override
  String get aliasNameValidation =>
      'Name must start with a letter or underscore, max 32 characters, alphanumeric and underscores only';

  @override
  String get aliasTypeLabel => 'Type';

  @override
  String get refreshFrequencyLabel => 'Refresh Frequency';

  @override
  String get refreshFrequencyHint =>
      'The frequency the list is refreshed. 1 day and 8 hours = refreshed after 32 hours. Leave empty to use defaults.';

  @override
  String get refreshDaysHint => 'Days';

  @override
  String get refreshHoursHint => 'Hours';

  @override
  String get pathExpressionLabel => 'Path Expression';

  @override
  String get pathExpressionHint =>
      'Simplified expression to select a field inside a container, e.g. container.fieldname. jq expressions are also supported.';

  @override
  String get authorizationLabel => 'Authorization';

  @override
  String get authorizationHint =>
      'If the remote server enforces authorization, specify the type here.';

  @override
  String get statisticsLabel => 'Statistics';

  @override
  String get statisticsHint =>
      'Maintain a set of counters for each table entry';

  @override
  String get expireLabel => 'Expire';

  @override
  String get expireHint =>
      'Time in seconds after which addresses are purged from the alias when not being used.';

  @override
  String get aliasContentHint => 'Enter IPs, CIDRs, hostnames, or other values';

  @override
  String get selectCountriesLabel => 'Select Countries';

  @override
  String get selectNetworkAliasesLabel => 'Select Network Aliases';

  @override
  String get selectVpnGroupsLabel => 'Select VPN Groups';

  @override
  String get protoLabel => 'IP Version';

  @override
  String get protoHint => 'Filter by IP protocol version';

  @override
  String get interfaceHint => 'Select the interface for the dynamic IPv6 host';

  @override
  String get enableThisAlias => 'Enable this alias';

  @override
  String get region => 'Region';

  @override
  String get countries => 'Countries';

  @override
  String get noCountriesSelected => 'Nothing Selected';

  @override
  String get geoipRegionsLabel => 'GeoIP Regions';

  @override
  String get basicSettingsLabel => 'Basic Settings';
}
