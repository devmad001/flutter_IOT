import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'Alpha';

  @override
  String get home => 'होम';

  @override
  String get reports => 'रिपोर्ट';

  @override
  String get setup => 'सेटअप';

  @override
  String get team => 'टीम';

  @override
  String get temperature => 'तापमान';

  @override
  String get incidents => 'घटनाएं';

  @override
  String get logout => 'लॉग आउट';

  @override
  String get login => 'लॉग इन';

  @override
  String get username => 'उपयोगकर्ता नाम';

  @override
  String get password => 'पासवर्ड';

  @override
  String get submit => 'जमा करें';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get save => 'सहेजें';

  @override
  String get delete => 'हटाएं';

  @override
  String get edit => 'संपादित करें';

  @override
  String get create => 'बनाएं';

  @override
  String get search => 'खोजें';

  @override
  String get noData => 'कोई डेटा उपलब्ध नहीं';

  @override
  String get loading => 'लोड हो रहा है...';

  @override
  String get error => 'त्रुटि';

  @override
  String get success => 'सफल';

  @override
  String get warning => 'चेतावनी';

  @override
  String get info => 'जानकारी';

  @override
  String get notifications => 'सूचनाएं';

  @override
  String get notificationsSubtitle => 'सूचना सेटिंग्स कॉन्फ़िगर करें';

  @override
  String get language => 'भाषा';

  @override
  String get security => 'सुरक्षा';

  @override
  String get securitySubtitle => 'सुरक्षा सेटिंग्स प्रबंधित करें';

  @override
  String get backup => 'बैकअप और पुनर्स्थापना';

  @override
  String get backupSubtitle => 'डेटा बैकअप और पुनर्स्थापना प्रबंधित करें';

  @override
  String get viewChecklist => 'चेकलिस्ट देखें';

  @override
  String get clickToFill => 'भरने के लिए क्लिक करें';

  @override
  String get addIncident => 'घटना जोड़ें';

  @override
  String get createIncident => 'घटना बनाएं';

  @override
  String get openingChecklist => 'खुलने की चेकलिस्ट';

  @override
  String get closingChecklist => 'बंद होने की चेकलिस्ट';

  @override
  String get unknownRestaurant => 'अज्ञात रेस्तरां';

  @override
  String get battery => 'बैटरी';

  @override
  String lastUpdated(String datetime) => 'अंतिम अपडेट: $datetime';

  @override
  String get selectDateRange => 'दिनांक सीमा चुनें';

  @override
  String get noTemperatureData =>
      'चयनित दिनांक सीमा के लिए कोई तापमान डेटा उपलब्ध नहीं';

  @override
  String get temperatureHistory => 'तापमान इतिहास';

  @override
  String get temperatureChart => 'तापमान चार्ट';

  @override
  String get temperatureTable => 'तापमान तालिका';

  @override
  String get menuHome => 'होम';

  @override
  String get menuOpeningChecks => 'खुलने की जांच';

  @override
  String get menuClosingChecks => 'बंद होने की जांच';

  @override
  String get menuTemperatures => 'तापमान';

  @override
  String get menuTeam => 'टीम';

  @override
  String get menuIncidents => 'घटनाएं';

  @override
  String get menuReports => 'रिपोर्ट';

  @override
  String get menuAllergyCheck => 'एलर्जी जांच';

  @override
  String get menuSetup => 'सेटअप';

  @override
  String get menuLogout => 'लॉग आउट';

  @override
  String get temperatureUnit => 'तापमान इकाई';

  @override
  String get selectReportFrequency => 'रिपोर्ट आवृत्ति चुनें';

  @override
  String get chooseReportRange => 'कृपया रिपोर्ट दिनांक सीमा चुनें';

  @override
  String get thisWeek => 'इस सप्ताह';

  @override
  String get thisMonth => 'इस महीने';

  @override
  String get customRange => 'कस्टम सीमा';

  @override
  String selectedRange(String start, String end) => 'चयनित सीमा: $start - $end';

  @override
  String get reportContents => 'रिपोर्ट में शामिल होंगे:';

  @override
  String get openingChecks => 'खुलने की जांच';

  @override
  String get closingChecks => 'बंद होने की जांच';

  @override
  String get temperatureReadings => 'तापमान रीडिंग';

  @override
  String get incidentsLogged => 'दर्ज की गई घटनाएं';

  @override
  String get downloading => 'डाउनलोड हो रहा है...';

  @override
  String get downloadReport => 'रिपोर्ट डाउनलोड करें';

  @override
  String get selectDateFirst => 'कृपया पहले दिनांक सीमा चुनें';

  @override
  String get downloadSuccess => 'रिपोर्ट सफलतापूर्वक डाउनलोड हो गई';

  @override
  String downloadError(String error) =>
      'रिपोर्ट डाउनलोड करने में त्रुटि: $error';

  @override
  String get noTasksAvailable => 'कोई कार्य उपलब्ध नहीं';

  @override
  String get alertSettings => 'अलर्ट सेटिंग्स';

  @override
  String get visualAlerts => 'विजुअल अलर्ट';

  @override
  String get showPopupNotifications => 'पॉपअप सूचनाएं दिखाएं';

  @override
  String get audioAlerts => 'ऑडियो अलर्ट';

  @override
  String get playSoundNotifications => 'ध्वनि सूचनाएं चलाएं';

  @override
  String get temperatures => 'तापमान';

  @override
  String get selectSensorPrompt =>
      'विवरण देखने के लिए ऊपर की सूची से एक सेंसर चुनें';

  @override
  String get noSensorData => 'कोई सेंसर डेटा उपलब्ध नहीं';

  @override
  String sensorId(String id) => 'सेंसर आईडी: $id';

  @override
  String temperatureValue(String value) => 'तापमान: ${value}°C';

  @override
  String batteryValue(String value) => 'बैटरी: ${value}%';

  @override
  String get sensorList => 'सेंसर सूची';

  @override
  String get currentState => 'वर्तमान स्थिति';

  @override
  String get temperatureSetting => 'तापमान सेटिंग';

  @override
  String get noTemperatureSettings => 'कोई तापमान सेटिंग उपलब्ध नहीं';

  @override
  String minTemp(String value) => 'न्यूनतम: ${value}°C';

  @override
  String maxTemp(String value) => 'अधिकतम: ${value}°C';

  @override
  String get alertEnabled => 'अलर्ट: सक्षम';

  @override
  String get alertDisabled => 'अलर्ट: अक्षम';

  @override
  String delayMinutes(String value) => 'विलंब: ${value} मिनट';

  @override
  String minTemperature(String value) => 'न्यूनतम तापमान: ${value}°C';

  @override
  String maxTemperature(String value) => 'अधिकतम तापमान: ${value}°C';

  @override
  String get temperatureAlert => 'तापमान अलर्ट:';

  @override
  String get delayBeforeAlert => 'अलर्ट से पहले विलंब (मिनट):';

  @override
  String get enterDelayMinutes => 'विलंब मिनटों में दर्ज करें';

  @override
  String get pleaseEnterDelay => 'कृपया विलंब मान दर्ज करें';

  @override
  String get enterValidNumber =>
      'कृपया एक मान्य गैर-नकारात्मक पूर्णांक दर्ज करें';

  @override
  String get customerAllergy => 'ग्राहक एलर्जी';

  @override
  String get enterAllergens => 'एलर्जेन दर्ज करें';

  @override
  String get searching => 'खोज रहा है...';

  @override
  String get pleaseEnterAllergens => 'कृपया जांच करने के लिए एलर्जेन दर्ज करें';

  @override
  String get safeItems => 'एलर्जेन-मुक्त परिणाम';

  @override
  String get unsafeItems => 'एलर्जेन युक्त परिणाम';

  @override
  String get teamMembersList => 'टीम सदस्य सूची';

  @override
  String get retry => 'पुनः प्रयास करें';

  @override
  String failedToLoadTeamMembers(String error) =>
      'टीम सदस्यों को लोड करने में विफल: $error';

  @override
  String errorFetchingTeamMembers(String error) =>
      'टीम सदस्यों को प्राप्त करने में त्रुटि: $error';

  @override
  String get name => 'नाम';

  @override
  String get userLevel => 'उपयोगकर्ता स्तर';

  @override
  String get emailAddress => 'ईमेल पता';

  @override
  String get trainingLevel => 'प्रशिक्षण स्तर';

  @override
  String get checklistCompletedSuccessfully =>
      'चेकलिस्ट सफलतापूर्वक पूरी हो गई';
}
