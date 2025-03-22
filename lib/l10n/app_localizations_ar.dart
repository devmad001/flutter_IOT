import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'Alpha';

  @override
  String get home => 'الرئيسية';

  @override
  String get reports => 'التقارير';

  @override
  String get setup => 'الإعدادات';

  @override
  String get team => 'الفريق';

  @override
  String get temperature => 'درجة الحرارة';

  @override
  String get incidents => 'الحوادث';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get username => 'اسم المستخدم';

  @override
  String get password => 'كلمة المرور';

  @override
  String get submit => 'إرسال';

  @override
  String get cancel => 'إلغاء';

  @override
  String get save => 'حفظ';

  @override
  String get delete => 'حذف';

  @override
  String get edit => 'تعديل';

  @override
  String get create => 'إنشاء';

  @override
  String get search => 'بحث';

  @override
  String get noData => 'لا توجد بيانات متاحة';

  @override
  String get loading => 'جاري التحميل...';

  @override
  String get error => 'خطأ';

  @override
  String get success => 'نجاح';

  @override
  String get warning => 'تحذير';

  @override
  String get info => 'معلومات';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get notificationsSubtitle => 'تكوين إعدادات الإشعارات';

  @override
  String get language => 'اللغة';

  @override
  String get security => 'الأمان';

  @override
  String get securitySubtitle => 'إدارة إعدادات الأمان';

  @override
  String get backup => 'النسخ الاحتياطي والاستعادة';

  @override
  String get backupSubtitle => 'إدارة النسخ الاحتياطي واستعادة البيانات';

  @override
  String get viewChecklist => 'عرض قائمة المراجعة';

  @override
  String get clickToFill => 'انقر للملء';

  @override
  String get addIncident => 'إضافة حادث';

  @override
  String get createIncident => 'إنشاء حادث';

  @override
  String get openingChecklist => 'قائمة مراجعة الفتح';

  @override
  String get closingChecklist => 'قائمة مراجعة الإغلاق';

  @override
  String get unknownRestaurant => 'مطعم غير معروف';

  @override
  String get battery => 'البطارية';

  @override
  String lastUpdated(String datetime) => 'آخر تحديث: $datetime';

  @override
  String get selectDateRange => 'اختر نطاق التاريخ';

  @override
  String get noTemperatureData => 'لا توجد بيانات درجة حرارة للنطاق المحدد';

  @override
  String get temperatureHistory => 'سجل درجة الحرارة';

  @override
  String get temperatureChart => 'مخطط درجة الحرارة';

  @override
  String get temperatureTable => 'جدول درجة الحرارة';

  @override
  String get menuHome => 'الرئيسية';

  @override
  String get menuOpeningChecks => 'فحوصات الفتح';

  @override
  String get menuClosingChecks => 'فحوصات الإغلاق';

  @override
  String get menuTemperatures => 'درجات الحرارة';

  @override
  String get menuTeam => 'الفريق';

  @override
  String get menuIncidents => 'الحوادث';

  @override
  String get menuReports => 'التقارير';

  @override
  String get menuAllergyCheck => 'فحص الحساسية';

  @override
  String get menuSetup => 'الإعدادات';

  @override
  String get menuLogout => 'تسجيل الخروج';

  @override
  String get temperatureUnit => 'وحدة درجة الحرارة';

  @override
  String get selectReportFrequency => 'اختر تكرار التقرير';

  @override
  String get chooseReportRange => 'الرجاء اختيار نطاق تاريخ التقرير';

  @override
  String get thisWeek => 'هذا الأسبوع';

  @override
  String get thisMonth => 'هذا الشهر';

  @override
  String get customRange => 'نطاق مخصص';

  @override
  String selectedRange(String start, String end) =>
      'النطاق المحدد: $start - $end';

  @override
  String get reportContents => 'سيشمل التقرير:';

  @override
  String get openingChecks => 'فحوصات الفتح';

  @override
  String get closingChecks => 'فحوصات الإغلاق';

  @override
  String get temperatureReadings => 'قراءات درجة الحرارة';

  @override
  String get incidentsLogged => 'الحوادث المسجلة';

  @override
  String get downloading => 'جاري التنزيل...';

  @override
  String get downloadReport => 'تنزيل التقرير';

  @override
  String get selectDateFirst => 'الرجاء اختيار نطاق التاريخ أولاً';

  @override
  String get downloadSuccess => 'تم تنزيل التقرير بنجاح';

  @override
  String downloadError(String error) => 'خطأ في تنزيل التقرير: $error';

  @override
  String get noTasksAvailable => 'لا توجد مهام متاحة';

  @override
  String get alertSettings => 'إعدادات التنبيه';

  @override
  String get visualAlerts => 'تنبيهات مرئية';

  @override
  String get showPopupNotifications => 'إظهار إشعارات منبثقة';

  @override
  String get audioAlerts => 'تنبيهات صوتية';

  @override
  String get playSoundNotifications => 'تشغيل إشعارات صوتية';

  @override
  String get temperatures => 'درجات الحرارة';

  @override
  String get selectSensorPrompt =>
      'اختر مستشعراً من القائمة أعلاه لعرض التفاصيل';

  @override
  String get noSensorData => 'لا توجد بيانات مستشعر متاحة';

  @override
  String sensorId(String id) => 'معرف المستشعر: $id';

  @override
  String temperatureValue(String value) => 'درجة الحرارة: ${value}°C';

  @override
  String batteryValue(String value) => 'البطارية: ${value}%';

  @override
  String get sensorList => 'قائمة المستشعرات';

  @override
  String get currentState => 'الحالة الحالية';

  @override
  String get temperatureSetting => 'إعداد درجة الحرارة';

  @override
  String get noTemperatureSettings => 'لا توجد إعدادات درجة حرارة متاحة';

  @override
  String minTemp(String value) => 'الحد الأدنى: ${value}°C';

  @override
  String maxTemp(String value) => 'الحد الأقصى: ${value}°C';

  @override
  String get alertEnabled => 'التنبيه: مفعل';

  @override
  String get alertDisabled => 'التنبيه: معطل';

  @override
  String delayMinutes(String value) => 'التأخير: ${value} دقيقة';

  @override
  String minTemperature(String value) =>
      'الحد الأدنى لدرجة الحرارة: ${value}°C';

  @override
  String maxTemperature(String value) =>
      'الحد الأقصى لدرجة الحرارة: ${value}°C';

  @override
  String get temperatureAlert => 'تنبيه درجة الحرارة:';

  @override
  String get delayBeforeAlert => 'التأخير قبل التنبيه (بالدقائق):';

  @override
  String get enterDelayMinutes => 'أدخل دقائق التأخير';

  @override
  String get pleaseEnterDelay => 'الرجاء إدخال قيمة التأخير';

  @override
  String get enterValidNumber => 'الرجاء إدخال رقم صحيح غير سالب';

  @override
  String get customerAllergy => 'حساسية العملاء';

  @override
  String get enterAllergens => 'أدخل المواد المسببة للحساسية';

  @override
  String get searching => 'جاري البحث...';

  @override
  String get pleaseEnterAllergens =>
      'الرجاء إدخال المواد المسببة للحساسية للفحص';

  @override
  String get safeItems => 'النتائج الخالية من المواد المسببة للحساسية';

  @override
  String get unsafeItems => 'النتائج التي تحتوي على مواد مسببة للحساسية';

  @override
  String get teamMembersList => 'قائمة أعضاء الفريق';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String failedToLoadTeamMembers(String error) =>
      'فشل في تحميل أعضاء الفريق: $error';

  @override
  String errorFetchingTeamMembers(String error) =>
      'خطأ في جلب أعضاء الفريق: $error';

  @override
  String get name => 'الاسم';

  @override
  String get userLevel => 'مستوى المستخدم';

  @override
  String get emailAddress => 'البريد الإلكتروني';

  @override
  String get trainingLevel => 'مستوى التدريب';

  @override
  String get checklistCompletedSuccessfully => 'تم إكمال قائمة المراجعة بنجاح';
}
