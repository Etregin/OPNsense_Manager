// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'مدير OPNsense';

  @override
  String get dashboard => 'لوحة التحكم';

  @override
  String get firewallRules => 'قواعد الجدار الناري';

  @override
  String get firewallLogs => 'سجلات الجدار الناري';

  @override
  String get systemInfo => 'معلومات النظام';

  @override
  String get vpnConnections => 'اتصالات VPN';

  @override
  String get settings => 'الإعدادات';

  @override
  String get hostname => 'اسم المضيف';

  @override
  String get versionLabel => 'الإصدار';

  @override
  String get platform => 'المنصة';

  @override
  String get uptime => 'وقت التشغيل';

  @override
  String get cpuUsage => 'استخدام المعالج';

  @override
  String get memoryUsage => 'استخدام الذاكرة';

  @override
  String get services => 'الخدمات';

  @override
  String get gateways => 'البوابات';

  @override
  String get running => 'قيد التشغيل';

  @override
  String get stopped => 'متوقف';

  @override
  String get online => 'متصل';

  @override
  String get offline => 'غير متصل';

  @override
  String get start => 'تشغيل';

  @override
  String get stop => 'إيقاف';

  @override
  String get restart => 'إعادة تشغيل';

  @override
  String get enable => 'تفعيل';

  @override
  String get disable => 'تعطيل';

  @override
  String get delete => 'حذف';

  @override
  String get edit => 'تعديل';

  @override
  String get save => 'حفظ';

  @override
  String get cancel => 'إلغاء';

  @override
  String get ok => 'موافق';

  @override
  String get yes => 'نعم';

  @override
  String get no => 'لا';

  @override
  String get close => 'إغلاق';

  @override
  String get refresh => 'تحديث';

  @override
  String get apply => 'تطبيق';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get host => 'المضيف';

  @override
  String get port => 'المنفذ';

  @override
  String get apiKey => 'مفتاح API';

  @override
  String get apiSecret => 'سر API';

  @override
  String get useHttps => 'استخدام HTTPS';

  @override
  String get allowSelfSigned => 'السماح بالشهادة الموقعة ذاتياً';

  @override
  String get testConnection => 'اختبار الاتصال';

  @override
  String get connectionSuccessful => 'نجح الاتصال';

  @override
  String get connectionFailed =>
      'فشل الاتصال. تحقق من سجلات وحدة التحكم للحصول على التفاصيل.\n\nالمشاكل الشائعة:\n• الجهاز ليس على نفس الشبكة مثل OPNsense\n• عنوان IP أو المنفذ خاطئ\n• جدار الحماية يحظر الاتصال\n• بيانات اعتماد API غير صالحة';

  @override
  String get profiles => 'الملفات الشخصية';

  @override
  String get addProfile => 'إضافة ملف تعريف';

  @override
  String get editProfile => 'تعديل الملف الشخصي';

  @override
  String get deleteProfile => 'حذف الملف الشخصي';

  @override
  String get profileName => 'اسم الملف الشخصي';

  @override
  String get activeProfile => 'الملف الشخصي النشط';

  @override
  String get switchProfile => 'تبديل الملف الشخصي';

  @override
  String get exportProfiles => 'تصدير الملفات الشخصية';

  @override
  String get importProfiles => 'استيراد الملفات الشخصية';

  @override
  String get security => 'الأمان';

  @override
  String get pinLock => 'قفل PIN';

  @override
  String get changePIN => 'تغيير PIN';

  @override
  String get biometricAuth => 'المصادقة البيومترية';

  @override
  String get sessionTimeout => 'مهلة الجلسة';

  @override
  String get lockApp => 'قفل التطبيق';

  @override
  String get appearance => 'المظهر';

  @override
  String get theme => 'السمة';

  @override
  String get language => 'اللغة';

  @override
  String get lightMode => 'الوضع الفاتح';

  @override
  String get darkMode => 'الوضع الداكن';

  @override
  String get systemDefault => 'افتراضي النظام';

  @override
  String get general => 'عام';

  @override
  String get about => 'حول';

  @override
  String get licenses => 'التراخيص';

  @override
  String get firewallRuleDetails => 'تفاصيل قاعدة الجدار الناري';

  @override
  String get createRule => 'إنشاء قاعدة';

  @override
  String get editRule => 'تعديل القاعدة';

  @override
  String get deleteRule => 'حذف القاعدة';

  @override
  String get action => 'الإجراء';

  @override
  String get interface => 'الواجهة';

  @override
  String get protocol => 'البروتوكول';

  @override
  String get source => 'المصدر';

  @override
  String get destination => 'الوجهة';

  @override
  String get sourcePort => 'منفذ المصدر';

  @override
  String get destinationPort => 'منفذ الوجهة';

  @override
  String get description => 'الوصف';

  @override
  String get enabled => 'مفعّل';

  @override
  String get disabled => 'معطّل';

  @override
  String get pass => 'سماح';

  @override
  String get block => 'حظر';

  @override
  String get reject => 'رفض';

  @override
  String get logs => 'السجلات';

  @override
  String get filterByAction => 'تصفية حسب الإجراء';

  @override
  String get showAll => 'عرض الكل';

  @override
  String get autoRefresh => 'التحديث التلقائي';

  @override
  String get logLimit => 'حد السجلات';

  @override
  String get paused => 'متوقف مؤقتاً';

  @override
  String get live => 'مباشر';

  @override
  String get entries => 'إدخالات';

  @override
  String get selected => 'محدد';

  @override
  String get selectAll => 'تحديد الكل';

  @override
  String get copy => 'نسخ';

  @override
  String get historySize => 'حجم السجل';

  @override
  String get enableAutoScroll => 'تفعيل التمرير التلقائي';

  @override
  String get disableAutoScroll => 'تعطيل التمرير التلقائي';

  @override
  String get clearLogs => 'مسح السجلات';

  @override
  String get pause => 'إيقاف مؤقت';

  @override
  String get resume => 'استئناف';

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
  String get pauseLiveViewToSelect => 'أوقف العرض المباشر لتحديد إدخالات السجل';

  @override
  String get errorLoadingLogs => 'خطأ في تحميل السجلات';

  @override
  String get noLogsAvailable => 'لا توجد سجلات متاحة';

  @override
  String get logsWillAppear => 'ستظهر السجلات هنا عند إنشائها';

  @override
  String get selectNumberOfEntries => 'حدد عدد إدخالات السجل المراد عرضها:';

  @override
  String get reason => 'السبب';

  @override
  String get newRule => 'قاعدة جديدة';

  @override
  String get ruleDetails => 'تفاصيل القاعدة';

  @override
  String get type => 'النوع';

  @override
  String get sequence => 'التسلسل';

  @override
  String get status => 'الحالة';

  @override
  String get systemGeneratedRule =>
      'هذه قاعدة تم إنشاؤها بواسطة النظام ولا يمكن تعديلها أو حذفها.';

  @override
  String get systemGeneratedRulesCannotBeModified =>
      'لا يمكن تعديل القواعد التي تم إنشاؤها بواسطة النظام';

  @override
  String get systemGeneratedRulesCannotBeDeleted =>
      'لا يمكن حذف القواعد التي تم إنشاؤها بواسطة النظام';

  @override
  String get enableRule => 'تفعيل القاعدة';

  @override
  String get disableRule => 'تعطيل القاعدة';

  @override
  String get enablingRule => 'جاري تفعيل القاعدة...';

  @override
  String get disablingRule => 'جاري تعطيل القاعدة...';

  @override
  String get ruleEnabledSuccessfully => 'تم تفعيل القاعدة بنجاح';

  @override
  String get ruleDisabledSuccessfully => 'تم تعطيل القاعدة بنجاح';

  @override
  String errorTogglingRule(String error) {
    return 'خطأ في تبديل القاعدة: $error';
  }

  @override
  String deleteRuleConfirmation(String description) {
    return 'هل أنت متأكد من رغبتك في حذف القاعدة \"$description\"؟';
  }

  @override
  String get ruleDeleted => 'تم حذف القاعدة بنجاح';

  @override
  String errorDeletingRule(String error) {
    return 'خطأ في حذف القاعدة: $error';
  }

  @override
  String get errorLoadingRules => 'خطأ في تحميل القواعد';

  @override
  String get noAutomationRulesFound => 'لم يتم العثور على قواعد أتمتة';

  @override
  String get createFirstAutomationRule => 'أنشئ أول قاعدة أتمتة للبدء';

  @override
  String get noInterfacesWithAutomationRules => 'لا توجد واجهات بقواعد أتمتة';

  @override
  String get selectInterface => 'حدد الواجهة';

  @override
  String get selectInterfaceToViewRules => 'حدد واجهة لعرض القواعد';

  @override
  String noRulesForInterface(String interface) {
    return 'لا توجد قواعد لـ $interface';
  }

  @override
  String get unnamedRule => 'قاعدة بدون اسم';

  @override
  String get systemInformation => 'معلومات النظام';

  @override
  String get firmwareDetails => 'تفاصيل البرنامج الثابت';

  @override
  String get systemType => 'نوع النظام';

  @override
  String get architecture => 'البنية';

  @override
  String get gitCommit => 'التزام Git';

  @override
  String get packageMirror => 'مرآة الحزمة';

  @override
  String get repository => 'المستودع';

  @override
  String get lastUpdate => 'آخر تحديث';

  @override
  String get errorLoadingSystemInfo => 'خطأ في تحميل معلومات النظام';

  @override
  String get errorLoadingVPNConnections => 'خطأ في تحميل اتصالات VPN';

  @override
  String get noVPNConnectionsFound => 'لم يتم العثور على اتصالات VPN';

  @override
  String noConnectionsFound(String type) {
    return 'لم يتم العثور على اتصالات $type';
  }

  @override
  String get vpnConnectionsWillAppear => 'ستظهر اتصالات VPN هنا عند تكوينها';

  @override
  String get totalVPNs => 'إجمالي VPN';

  @override
  String get filterByType => 'تصفية حسب النوع';

  @override
  String get allVPNs => 'جميع VPN';

  @override
  String get connectVPN => 'اتصال VPN';

  @override
  String get disconnectVPN => 'قطع اتصال VPN';

  @override
  String connectingVPN(String name) {
    return 'جاري الاتصال بـ $name...';
  }

  @override
  String disconnectingVPN(String name) {
    return 'جاري قطع الاتصال بـ $name...';
  }

  @override
  String successfullyConnected(String name) {
    return 'تم الاتصال بنجاح بـ $name';
  }

  @override
  String successfullyDisconnected(String name) {
    return 'تم قطع الاتصال بنجاح بـ $name';
  }

  @override
  String failedToConnect(String name) {
    return 'فشل الاتصال بـ $name';
  }

  @override
  String failedToDisconnect(String name) {
    return 'فشل قطع الاتصال بـ $name';
  }

  @override
  String get restartVPNService => 'إعادة تشغيل خدمة VPN';

  @override
  String restartServiceConfirmation(String type) {
    return 'هل أنت متأكد من رغبتك في إعادة تشغيل خدمة $type؟\n\nسيؤدي هذا إلى قطع جميع الاتصالات النشطة مؤقتًا.';
  }

  @override
  String restartingService(String type) {
    return 'جاري إعادة تشغيل خدمة $type...';
  }

  @override
  String successfullyRestartedService(String type) {
    return 'تم إعادة تشغيل خدمة $type بنجاح';
  }

  @override
  String failedToRestartService(String type) {
    return 'فشل إعادة تشغيل خدمة $type';
  }

  @override
  String get enterRuleDescription => 'أدخل وصف القاعدة';

  @override
  String get loading => 'جاري التحميل...';

  @override
  String get any => 'أي';

  @override
  String get anyIpAddressCidrOrAlias => 'أي، عنوان IP، CIDR، أو اسم مستعار';

  @override
  String get examplesAnyIpCidr => 'أمثلة: any، 192.168.1.0/24، 10.0.0.1';

  @override
  String get sourceIsRequired => 'المصدر مطلوب';

  @override
  String get invalidSourceFormat => 'تنسيق المصدر غير صالح';

  @override
  String get sourcePortOptional => 'منفذ المصدر (اختياري)';

  @override
  String get anyPortNumberRangeOrAlias => 'أي، رقم منفذ، نطاق، أو اسم مستعار';

  @override
  String get examplesAnyPortRange => 'أمثلة: any، 80، 1024-65535';

  @override
  String get invalidPortFormat => 'تنسيق المنفذ غير صالح';

  @override
  String get destinationIsRequired => 'الوجهة مطلوبة';

  @override
  String get invalidDestinationFormat => 'تنسيق الوجهة غير صالح';

  @override
  String get destinationPortOptional => 'منفذ الوجهة (اختياري)';

  @override
  String get examplesAnyPortRangeHttp => 'أمثلة: any، 80، 80-443، http';

  @override
  String get ruleWillBeActiveWhenEnabled => 'ستكون القاعدة نشطة عند التفعيل';

  @override
  String get ruleGuidelines => 'إرشادات القاعدة';

  @override
  String get ruleGuidelinesText =>
      '• استخدم \"any\" لمطابقة جميع العناوين أو المنافذ\n• تدوين CIDR: 192.168.1.0/24\n• نطاقات المنافذ: 80-443\n• تتم معالجة القواعد بالترتيب\n• يتم تطبيق التغييرات فوراً';

  @override
  String get updateRule => 'تحديث القاعدة';

  @override
  String get ruleUpdated => 'تم تحديث القاعدة بنجاح';

  @override
  String get ruleCreated => 'تم إنشاء القاعدة بنجاح';

  @override
  String errorSavingRule(String error) {
    return 'خطأ في حفظ القاعدة: $error';
  }

  @override
  String get connectToYourOPNsenseFirewall =>
      'اتصل بجدار الحماية OPNsense الخاص بك';

  @override
  String get profileNameOptional => 'اسم الملف الشخصي (اختياري)';

  @override
  String get myOPNsenseRouter => 'جهاز التوجيه OPNsense الخاص بي';

  @override
  String get hostIpAddress => 'المضيف / عنوان IP';

  @override
  String get hostPlaceholder => '192.168.1.1 أو firewall.example.com';

  @override
  String get portPlaceholder => '443';

  @override
  String get recommendedForSecureConnections => 'موصى به للاتصالات الآمنة';

  @override
  String get enterYourApiKey => 'أدخل مفتاح API الخاص بك';

  @override
  String get enterYourApiSecret => 'أدخل سر API الخاص بك';

  @override
  String get connect => 'اتصال';

  @override
  String apiError(String message) {
    return 'خطأ في API: $message';
  }

  @override
  String get needHelpCheckDocumentation =>
      'تحتاج مساعدة؟ راجع وثائق OPNsense لإنشاء مفتاح API.';

  @override
  String get selectAProfileOrCreateNewOne =>
      'حدد ملفاً شخصياً أو أنشئ ملفاً جديداً';

  @override
  String get createNewProfile => 'إنشاء ملف شخصي جديد';

  @override
  String get noProfilesYet => 'لا توجد ملفات شخصية بعد';

  @override
  String get createYourFirstProfile =>
      'أنشئ ملفك الشخصي الأول في OPNsense للبدء';

  @override
  String lastUsed(String date) {
    return 'آخر استخدام: $date';
  }

  @override
  String get justNow => 'الآن';

  @override
  String minutesAgo(String minutes) {
    return 'منذ $minutes دقيقة';
  }

  @override
  String hoursAgo(String hours) {
    return 'منذ $hours ساعة';
  }

  @override
  String daysAgo(String days) {
    return 'منذ $days يوم';
  }

  @override
  String connectionFailedError(String error) {
    return 'فشل الاتصال: $error';
  }

  @override
  String get enterPin => 'أدخل رمز PIN';

  @override
  String get unlockOPNsenseManager => 'فتح OPNsense Manager';

  @override
  String get pleaseEnterYourPin => 'الرجاء إدخال رمز PIN الخاص بك';

  @override
  String get incorrectPin => 'رمز PIN غير صحيح';

  @override
  String get unlock => 'فتح';

  @override
  String get useBiometric => 'استخدام البيومترية';

  @override
  String get authenticateToUnlock => 'المصادقة لفتح OPNsense Manager';

  @override
  String version(String version) {
    return 'الإصدار $version';
  }

  @override
  String get remoteAddress => 'العنوان البعيد';

  @override
  String get localAddress => 'العنوان المحلي';

  @override
  String get received => 'المستلم';

  @override
  String get sent => 'المرسل';

  @override
  String get vpnStatus => 'حالة VPN';

  @override
  String get connected => 'متصل';

  @override
  String get disconnected => 'غير متصل';

  @override
  String get disconnect => 'قطع الاتصال';

  @override
  String get vpnType => 'نوع VPN';

  @override
  String get clientAddress => 'عنوان العميل';

  @override
  String get virtualAddress => 'العنوان الافتراضي';

  @override
  String get bytesReceived => 'البايتات المستلمة';

  @override
  String get bytesSent => 'البايتات المرسلة';

  @override
  String get connectedSince => 'متصل منذ';

  @override
  String get rebootSystem => 'إعادة تشغيل النظام';

  @override
  String get rebootConfirmation =>
      'هل أنت متأكد من رغبتك في إعادة تشغيل النظام؟';

  @override
  String get rebootSuccess => 'تم بدء إعادة تشغيل النظام';

  @override
  String get rebootFailed => 'فشل في إعادة تشغيل النظام';

  @override
  String get error => 'خطأ';

  @override
  String get success => 'نجاح';

  @override
  String get warning => 'تحذير';

  @override
  String get info => 'معلومات';

  @override
  String get noData => 'لا توجد بيانات متاحة';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get confirmDelete => 'تأكيد الحذف';

  @override
  String get deleteConfirmation => 'هل أنت متأكد من رغبتك في حذف هذا العنصر؟';

  @override
  String get cannotBeUndone => 'لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get enterPIN => 'أدخل PIN';

  @override
  String get confirmPIN => 'تأكيد PIN';

  @override
  String get pinMismatch => 'رموز PIN غير متطابقة';

  @override
  String get pinTooShort => 'يجب أن يكون PIN 4 أرقام على الأقل';

  @override
  String get invalidPIN => 'PIN غير صالح';

  @override
  String get minutes => 'دقائق';

  @override
  String get seconds => 'ثواني';

  @override
  String get hours => 'ساعات';

  @override
  String get days => 'أيام';

  @override
  String get required => 'مطلوب';

  @override
  String get optional => 'اختياري';

  @override
  String get invalidInput => 'إدخال غير صالح';

  @override
  String get fieldRequired => 'هذا الحقل مطلوب';

  @override
  String get exportSuccess => 'نجح التصدير';

  @override
  String get exportFailed => 'فشل التصدير';

  @override
  String get importSuccess => 'نجح الاستيراد';

  @override
  String get importFailed => 'فشل الاستيراد';

  @override
  String importedProfiles(int count) {
    return 'تم استيراد $count ملف شخصي';
  }

  @override
  String get noProfilesFound => 'لم يتم العثور على ملفات شخصية';

  @override
  String get createFirstProfile => 'أنشئ ملفك الشخصي الأول للبدء';

  @override
  String get serviceStarted => 'تم تشغيل الخدمة بنجاح';

  @override
  String get serviceStopped => 'تم إيقاف الخدمة بنجاح';

  @override
  String get serviceRestarted => 'تمت إعادة تشغيل الخدمة بنجاح';

  @override
  String get serviceActionFailed => 'فشل إجراء الخدمة';

  @override
  String get ruleActionFailed => 'فشل إجراء القاعدة';

  @override
  String get profileSaved => 'تم حفظ الملف الشخصي بنجاح';

  @override
  String get profileDeleted => 'تم حذف الملف الشخصي بنجاح';

  @override
  String get profileActivated => 'تم تفعيل الملف الشخصي بنجاح';

  @override
  String get authenticationRequired => 'المصادقة مطلوبة';

  @override
  String get authenticationFailed => 'فشلت المصادقة';

  @override
  String get networkError => 'حدث خطأ في الشبكة';

  @override
  String get serverError => 'حدث خطأ في الخادم';

  @override
  String get unauthorized => 'وصول غير مصرح به';

  @override
  String get forbidden => 'الوصول محظور';

  @override
  String get notFound => 'المورد غير موجود';

  @override
  String get timeout => 'انتهت مهلة الطلب';

  @override
  String get none => 'لا شيء';

  @override
  String get diskUsage => 'استخدام القرص';

  @override
  String get pinLockDisabled =>
      'تم تعطيل قفل PIN. تم تعطيل القفل البيومتري أيضاً.';

  @override
  String get setPin => 'تعيين PIN';

  @override
  String get pinLockTitle => 'قفل PIN';

  @override
  String get requirePinToUnlock => 'يتطلب PIN لفتح التطبيق';

  @override
  String get changePinTitle => 'تغيير PIN';

  @override
  String get updatePinCode => 'تحديث رمز PIN الخاص بك';

  @override
  String get lockTimeoutLabel => 'مهلة القفل';

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
  String get minute => 'دقيقة';

  @override
  String get add => 'إضافة';

  @override
  String get profileAdded => 'تمت إضافة الملف الشخصي';

  @override
  String get profileUpdated => 'تم تحديث الملف الشخصي';

  @override
  String get exportProfilesTitle => 'تصدير الملفات الشخصية';

  @override
  String get chooseExportLocation => 'اختر موقع التصدير';

  @override
  String profilesExportedSuccessfully(String path) {
    return 'تم تصدير الملفات الشخصية بنجاح!\n$path';
  }

  @override
  String exportFailedError(String error) {
    return 'فشل التصدير: $error';
  }

  @override
  String get importProfilesTitle => 'استيراد الملفات التعريفية';

  @override
  String invalidFileError(String error) {
    return 'ملف غير صالح: $error';
  }

  @override
  String get importProfilesDialog =>
      'كيف يجب التعامل مع الملفات الشخصية الموجودة؟\n\n• الاحتفاظ بكليهما: الاستيراد بمعرفات جديدة\n• الكتابة فوق: استبدال الملفات الشخصية الموجودة';

  @override
  String get keepBoth => 'الاحتفاظ بكليهما';

  @override
  String get overwrite => 'الكتابة فوق';

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
  String importFailedWithErrors(String errors) {
    return 'فشل الاستيراد: $errors';
  }

  @override
  String importedWithFailures(int success, int failed) {
    String _temp0 = intl.Intl.pluralLogic(
      success,
      locale: localeName,
      other: 'ملفات شخصية',
      one: 'ملف شخصي',
    );
    return 'تم استيراد $success $_temp0، فشل $failed';
  }

  @override
  String get deleteProfileTitle => 'حذف الملف الشخصي';

  @override
  String deleteProfileConfirmation(String name) {
    return 'هل أنت متأكد من رغبتك في حذف \"$name\"؟';
  }

  @override
  String get applicationLegalese =>
      '© 2026 OPNsense Manager\n\nمرخص بموجب رخصة جنو العمومية الإصدار 3.0\n\nهذا البرنامج مجاني: يمكنك إعادة توزيعه و/أو تعديله بموجب شروط رخصة جنو العمومية كما نشرتها مؤسسة البرمجيات الحرة، سواء الإصدار 3 من الرخصة، أو (حسب اختيارك) أي إصدار لاحق.';

  @override
  String get aboutDescription =>
      'تطبيق Flutter احترافي لإدارة جدران حماية OPNsense.';

  @override
  String get featuresTitle => 'الميزات';

  @override
  String get featuresList =>
      '• مراقبة وإدارة النظام\n• تكوين قواعد الجدار الناري\n• التحكم في الخدمات\n• السجلات في الوقت الفعلي\n• دعم ملفات شخصية متعددة\n• مصادقة آمنة';

  @override
  String get viewFullLicense => 'عرض الرخصة الكاملة';

  @override
  String get gnuLicenseTitle => 'رخصة جنو العمومية الإصدار 3.0';

  @override
  String get gnuLicenseText =>
      'هذا البرنامج مجاني: يمكنك إعادة توزيعه و/أو تعديله بموجب شروط رخصة جنو العمومية كما نشرتها مؤسسة البرمجيات الحرة، سواء الإصدار 3 من الرخصة، أو (حسب اختيارك) أي إصدار لاحق.\n\nيتم توزيع هذا البرنامج على أمل أن يكون مفيداً، ولكن دون أي ضمان؛ حتى بدون الضمان الضمني للتسويق أو الملاءمة لغرض معين. راجع رخصة جنو العمومية لمزيد من التفاصيل.\n\nيجب أن تكون قد تلقيت نسخة من رخصة جنو العمومية مع هذا البرنامج. إذا لم يكن الأمر كذلك، راجع <https://www.gnu.org/licenses/>.\n\nلماذا GPLv3؟\n\n• يضمن بقاء البرنامج مجانياً ومفتوح المصدر\n• يجب أن تكون أي تعديلات أو مشتقات مفتوحة المصدر أيضاً\n• للمستخدمين حرية استخدام ودراسة ومشاركة وتعديل البرنامج\n• يستفيد المجتمع من التحسينات والمساهمات';

  @override
  String get enterPinLabel => 'أدخل رمز PIN (4-6 أرقام)';

  @override
  String get confirmPin => 'تأكيد رمز PIN';

  @override
  String get pinLockEnabled => 'تم تفعيل قفل PIN';

  @override
  String get currentPin => 'رمز PIN الحالي';

  @override
  String get newPin => 'رمز PIN الجديد (4-6 أرقام)';

  @override
  String get confirmNewPin => 'تأكيد رمز PIN الجديد';

  @override
  String get currentPinIncorrect => 'رمز PIN الحالي غير صحيح';

  @override
  String get pinChangedSuccessfully => 'تم تغيير رمز PIN بنجاح';

  @override
  String get pleaseEnterCurrentPin => 'الرجاء إدخال رمز PIN الحالي';

  @override
  String get pleaseEnterNewPin => 'الرجاء إدخال رمز PIN جديد';

  @override
  String get pinMustContainOnlyNumbers => 'يجب أن يحتوي رمز PIN على أرقام فقط';

  @override
  String get newPinMustBeDifferent =>
      'يجب أن يكون رمز PIN الجديد مختلفًا عن الحالي';

  @override
  String get enablePinLockFirst =>
      'يرجى تفعيل قفل PIN أولاً قبل استخدام البيومترية';

  @override
  String get biometricNotAvailable =>
      'المصادقة البيومترية غير متوفرة على هذا الجهاز';

  @override
  String get biometricLockEnabled => 'تم تفعيل القفل البيومتري';

  @override
  String get biometricAuthFailed => 'فشلت المصادقة البيومترية أو تم إلغاؤها';

  @override
  String get biometricLockDisabled => 'تم تعطيل القفل البيومتري';

  @override
  String biometricLockTitle(String biometricType) {
    return 'قفل $biometricType';
  }

  @override
  String useBiometricToUnlock(String biometricType) {
    return 'استخدم $biometricType لفتح التطبيق';
  }

  @override
  String get enablePinLockFirstBiometric =>
      'قم بتفعيل قفل PIN أولاً لاستخدام البيومترية';

  @override
  String get oneMin => '1 دقيقة';

  @override
  String get twoMin => '2 دقيقة';

  @override
  String get fiveMin => '5 دقائق';

  @override
  String get tenMin => '10 دقائق';

  @override
  String get fifteenMin => '15 دقيقة';

  @override
  String get thirtyMin => '30 دقيقة';

  @override
  String get oneHour => '1 ساعة';

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
  String get activate => 'تفعيل';

  @override
  String get import => 'استيراد';

  @override
  String get export => 'تصدير';

  @override
  String get activatingProfile => 'جاري تفعيل الملف التعريفي...';

  @override
  String activatedProfile(String name) {
    return 'تم تفعيل الملف التعريفي: $name';
  }

  @override
  String get connectionTestFailed => 'فشل اختبار الاتصال';

  @override
  String get profileNameLabel => 'اسم الملف التعريفي';

  @override
  String get hostIpAddressLabel => 'المضيف/عنوان IP';

  @override
  String get portLabel => 'المنفذ';

  @override
  String get useHttpsLabel => 'استخدام HTTPS';

  @override
  String get apiKeyLabel => 'مفتاح API';

  @override
  String get apiSecretLabel => 'سر API';

  @override
  String get profileNameRequired => 'اسم الملف التعريفي مطلوب';

  @override
  String get exportProfilesContent =>
      'هل تريد تضمين بيانات اعتماد API في التصدير؟\n\nتحذير: سيؤدي تضمين بيانات الاعتماد إلى تخزين مفاتيح API والأسرار بنص عادي. قم بتضمين بيانات الاعتماد فقط إذا كنت ستخزن الملف بشكل آمن.';

  @override
  String get withoutCredentials => 'بدون بيانات الاعتماد';

  @override
  String get includeCredentials => 'تضمين بيانات الاعتماد';

  @override
  String get exportProfile => 'تصدير الملف التعريفي';

  @override
  String get exportProfileTitle => 'تصدير الملف التعريفي';

  @override
  String get exportProfileContent =>
      'هل تريد تضمين بيانات اعتماد API في التصدير؟\n\nتحذير: سيؤدي تضمين بيانات الاعتماد إلى تخزين مفاتيح API والأسرار بنص عادي. قم بتضمين بيانات الاعتماد فقط إذا كنت ستخزن الملف بشكل آمن.';

  @override
  String get unableToAccessFilePath => 'غير قادر على الوصول إلى مسار الملف';

  @override
  String invalidFileFormat(String error) {
    return 'ملف غير صالح: $error';
  }

  @override
  String get noProfiles => 'لا توجد ملفات تعريفية';

  @override
  String get addProfileToManageInstances =>
      'أضف ملفاً تعريفياً لإدارة مثيلات OPNsense';

  @override
  String get unknown => 'غير معروف';

  @override
  String get http => 'http';

  @override
  String get https => 'https';

  @override
  String errorPrefix(String message) {
    return 'خطأ: $message';
  }

  @override
  String get switchProfileConfirmation => 'تبديل الملف التعريفي؟';

  @override
  String rebootFailedWithError(String message, String error) {
    return '$message: $error';
  }

  @override
  String get zeroSeconds => '0 ثانية';

  @override
  String get day => 'يوم';

  @override
  String get hour => 'ساعة';

  @override
  String get second => 'ثانية';

  @override
  String get hostIsRequired => 'المضيف مطلوب';

  @override
  String get invalidHostnameOrIp => 'اسم مضيف أو عنوان IP غير صالح';

  @override
  String get portIsRequired => 'المنفذ مطلوب';

  @override
  String get portMustBeBetween => 'يجب أن يكون المنفذ بين 1 و 65535';

  @override
  String get apiKeyIsRequired => 'مفتاح API مطلوب';

  @override
  String get invalidApiKeyFormat => 'تنسيق مفتاح API غير صالح';

  @override
  String get apiSecretIsRequired => 'سر API مطلوب';

  @override
  String get invalidApiSecretFormat => 'تنسيق سر API غير صالح';

  @override
  String fieldIsRequired(String fieldName) {
    return '$fieldName مطلوب';
  }

  @override
  String actionService(String action) {
    return '$action الخدمة';
  }

  @override
  String confirmServiceAction(String action, String name) {
    return '$action \"$name\"؟';
  }

  @override
  String actioningService(String action, String name) {
    return '$action $name...';
  }

  @override
  String get notAvailable => 'غير متاح';

  @override
  String get unitBytes => 'بايت';

  @override
  String get unitKilobytes => 'كيلوبايت';

  @override
  String get unitMegabytes => 'ميجابايت';

  @override
  String get unitGigabytes => 'جيجابايت';

  @override
  String get unitTerabytes => 'تيرابايت';

  @override
  String get unitPetabytes => 'بيتابايت';

  @override
  String get unitPerSecond => '/ث';

  @override
  String get hourAbbrev => 'س';

  @override
  String get minuteAbbrev => 'د';

  @override
  String get secondAbbrev => 'ث';

  @override
  String get liveNetworkMonitor => 'مراقب الشبكة المباشر';

  @override
  String get searchHostnameOrIp => 'البحث عن اسم المضيف أو عنوان IP...';

  @override
  String activeHosts(int count) {
    return '$count مضيف نشط';
  }

  @override
  String get noHostsFound => 'لم يتم العثور على مضيفين';

  @override
  String get tryDifferentSearch => 'جرب مصطلح بحث مختلف';

  @override
  String get download => 'التنزيل';

  @override
  String get upload => 'الرفع';

  @override
  String get totalBandwidth => 'إجمالي النطاق الترددي';

  @override
  String get of1Gbps => 'من 1 جيجابت في الثانية';

  @override
  String get networkTotals => 'إجماليات الشبكة';

  @override
  String get totalDownload => 'إجمالي التنزيل';

  @override
  String get totalUpload => 'إجمالي الرفع';

  @override
  String get activeDevices => 'الأجهزة النشطة';

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
  String get bandwidthLimit => 'حد النطاق الترددي';

  @override
  String get bandwidthLimitMbps => 'حد النطاق الترددي (ميجابت في الثانية)';

  @override
  String get enterBandwidthLimit =>
      'أدخل حد النطاق الترددي للاتصال بالميجابت في الثانية';

  @override
  String get macAddress => 'عنوان MAC';

  @override
  String get monitorInterface => 'واجهة المراقبة';

  @override
  String get selectMultipleInterfaces => 'حدد واجهة واحدة أو أكثر للمراقبة';

  @override
  String get dhcpLeases => 'عقود DHCP';

  @override
  String get searchHostnameIpOrMac => 'البحث عن اسم المضيف أو IP أو MAC...';

  @override
  String leasesCount(int filtered, int total) {
    return '$filtered من $total عقد';
  }

  @override
  String get noLeasesFound => 'لم يتم العثور على عقود';

  @override
  String get all => 'الكل';

  @override
  String get active => 'نشط';

  @override
  String get expired => 'منتهي';

  @override
  String get expires => 'ينتهي';

  @override
  String get ipAddress => 'عنوان IP';

  @override
  String get staticLease => 'ثابت';

  @override
  String get dynamicLease => 'ديناميكي';

  @override
  String get blockHost => 'حظر المضيف';

  @override
  String blockHostConfirmation(String hostname, String ip) {
    return 'هل أنت متأكد من حظر $hostname ($ip)؟\n\nسيؤدي هذا إلى إنشاء قاعدة جدار ناري لحظر جميع حركة المرور من هذا المضيف.';
  }

  @override
  String get blockingHost => 'جاري حظر المضيف...';

  @override
  String get hostBlocked => 'تم حظر المضيف بنجاح';

  @override
  String get failedToBlockHost => 'فشل حظر المضيف';
}
