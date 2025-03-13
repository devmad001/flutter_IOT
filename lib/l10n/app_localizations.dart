import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_it.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you'll need to edit this
/// file.
///
/// First, open your project's ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project's Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('it'),
    Locale('pl'),
    Locale('tr'),
    Locale('zh')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Alpha'**
  String get appTitle;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @setup.
  ///
  /// In en, this message translates to:
  /// **'Setup'**
  String get setup;

  /// No description provided for @team.
  ///
  /// In en, this message translates to:
  /// **'Team'**
  String get team;

  /// No description provided for @temperature.
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get temperature;

  /// No description provided for @incidents.
  ///
  /// In en, this message translates to:
  /// **'Incidents'**
  String get incidents;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noData;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get info;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @notificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Configure notification settings'**
  String get notificationsSubtitle;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @securitySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage security settings'**
  String get securitySubtitle;

  /// No description provided for @backup.
  ///
  /// In en, this message translates to:
  /// **'Backup & Restore'**
  String get backup;

  /// No description provided for @backupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage data backup and restore'**
  String get backupSubtitle;

  /// No description provided for @viewChecklist.
  ///
  /// In en, this message translates to:
  /// **'VIEW CHECKLIST'**
  String get viewChecklist;

  /// No description provided for @clickToFill.
  ///
  /// In en, this message translates to:
  /// **'CLICK TO FILL'**
  String get clickToFill;

  /// No description provided for @addIncident.
  ///
  /// In en, this message translates to:
  /// **'ADD INCIDENT'**
  String get addIncident;

  /// No description provided for @createIncident.
  ///
  /// In en, this message translates to:
  /// **'CREATE INCIDENT'**
  String get createIncident;

  /// No description provided for @openingChecklist.
  ///
  /// In en, this message translates to:
  /// **'Opening Checklist'**
  String get openingChecklist;

  /// No description provided for @closingChecklist.
  ///
  /// In en, this message translates to:
  /// **'Closing Checklist'**
  String get closingChecklist;

  /// No description provided for @unknownRestaurant.
  ///
  /// In en, this message translates to:
  /// **'Unknown Restaurant'**
  String get unknownRestaurant;

  /// No description provided for @battery.
  ///
  /// In en, this message translates to:
  /// **'Battery'**
  String get battery;

  /// Last updated label with datetime
  ///
  /// In en, this message translates to:
  /// **'Last updated: {datetime}'**
  String lastUpdated(String datetime);

  /// No description provided for @selectDateRange.
  ///
  /// In en, this message translates to:
  /// **'Select Date Range'**
  String get selectDateRange;

  /// No description provided for @noTemperatureData.
  ///
  /// In en, this message translates to:
  /// **'No temperature data available for the selected date range'**
  String get noTemperatureData;

  /// No description provided for @temperatureHistory.
  ///
  /// In en, this message translates to:
  /// **'Temperature History'**
  String get temperatureHistory;

  /// No description provided for @temperatureChart.
  ///
  /// In en, this message translates to:
  /// **'Temperature Chart'**
  String get temperatureChart;

  /// No description provided for @temperatureTable.
  ///
  /// In en, this message translates to:
  /// **'Temperature Table'**
  String get temperatureTable;

  /// No description provided for @menuHome.
  ///
  /// In en, this message translates to:
  /// **'HOME'**
  String get menuHome;

  /// No description provided for @menuOpeningChecks.
  ///
  /// In en, this message translates to:
  /// **'OPENING CHECKS'**
  String get menuOpeningChecks;

  /// No description provided for @menuClosingChecks.
  ///
  /// In en, this message translates to:
  /// **'CLOSING CHECKS'**
  String get menuClosingChecks;

  /// No description provided for @menuTemperatures.
  ///
  /// In en, this message translates to:
  /// **'TEMPERATURES'**
  String get menuTemperatures;

  /// No description provided for @menuTeam.
  ///
  /// In en, this message translates to:
  /// **'TEAM'**
  String get menuTeam;

  /// No description provided for @menuIncidents.
  ///
  /// In en, this message translates to:
  /// **'INCIDENTS'**
  String get menuIncidents;

  /// No description provided for @menuReports.
  ///
  /// In en, this message translates to:
  /// **'REPORTS'**
  String get menuReports;

  /// No description provided for @menuAllergyCheck.
  ///
  /// In en, this message translates to:
  /// **'ALLERGY CHECK'**
  String get menuAllergyCheck;

  /// No description provided for @menuSetup.
  ///
  /// In en, this message translates to:
  /// **'SETUP'**
  String get menuSetup;

  /// No description provided for @menuLogout.
  ///
  /// In en, this message translates to:
  /// **'LOGOUT'**
  String get menuLogout;

  /// No description provided for @temperatureUnit.
  ///
  /// In en, this message translates to:
  /// **'Temperature Unit'**
  String get temperatureUnit;

  /// Title text for report frequency selection
  ///
  /// In en, this message translates to:
  /// **'Select your report frequency'**
  String get selectReportFrequency;

  /// Subtitle text for report range selection
  ///
  /// In en, this message translates to:
  /// **'Please choose the report range below'**
  String get chooseReportRange;

  /// Option for selecting this week's report
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get thisWeek;

  /// Option for selecting this month's report
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// Option for selecting custom date range
  ///
  /// In en, this message translates to:
  /// **'Custom Range'**
  String get customRange;

  /// Shows the selected date range
  ///
  /// In en, this message translates to:
  /// **'Selected Range: {start} - {end}'**
  String selectedRange(String start, String end);

  /// Title for report contents section
  ///
  /// In en, this message translates to:
  /// **'What the report will contain:'**
  String get reportContents;

  /// Report item for opening checks
  ///
  /// In en, this message translates to:
  /// **'Opening Checks'**
  String get openingChecks;

  /// Report item for closing checks
  ///
  /// In en, this message translates to:
  /// **'Closing Checks'**
  String get closingChecks;

  /// Report item for temperature readings
  ///
  /// In en, this message translates to:
  /// **'Temperature Readings'**
  String get temperatureReadings;

  /// Report item for logged incidents
  ///
  /// In en, this message translates to:
  /// **'Incidents Logged'**
  String get incidentsLogged;

  /// Text shown while report is downloading
  ///
  /// In en, this message translates to:
  /// **'Downloading...'**
  String get downloading;

  /// Button text for downloading report
  ///
  /// In en, this message translates to:
  /// **'Download Report'**
  String get downloadReport;

  /// Error message when trying to download without date selection
  ///
  /// In en, this message translates to:
  /// **'Please select a date range first'**
  String get selectDateFirst;

  /// Success message after report download
  ///
  /// In en, this message translates to:
  /// **'Report downloaded successfully'**
  String get downloadSuccess;

  /// Error message when download fails
  ///
  /// In en, this message translates to:
  /// **'Error downloading report: {error}'**
  String downloadError(String error);

  /// Message shown when no tasks are available
  ///
  /// In en, this message translates to:
  /// **'No tasks available'**
  String get noTasksAvailable;

  /// Title for alert settings section
  ///
  /// In en, this message translates to:
  /// **'Alert Settings'**
  String get alertSettings;

  /// Title for visual alerts toggle
  ///
  /// In en, this message translates to:
  /// **'Visual Alerts'**
  String get visualAlerts;

  /// Description for visual alerts toggle
  ///
  /// In en, this message translates to:
  /// **'Show popup notifications'**
  String get showPopupNotifications;

  /// Title for audio alerts toggle
  ///
  /// In en, this message translates to:
  /// **'Audio Alerts'**
  String get audioAlerts;

  /// Description for audio alerts toggle
  ///
  /// In en, this message translates to:
  /// **'Play sound notifications'**
  String get playSoundNotifications;

  /// Title for temperature screen
  ///
  /// In en, this message translates to:
  /// **'Temperatures'**
  String get temperatures;

  /// Message shown when no sensor is selected
  ///
  /// In en, this message translates to:
  /// **'Select a sensor from the list above to view details.'**
  String get selectSensorPrompt;

  /// Message shown when there is no sensor data
  ///
  /// In en, this message translates to:
  /// **'No sensor data available.'**
  String get noSensorData;

  /// Sensor ID label with value
  ///
  /// In en, this message translates to:
  /// **'Sensor ID: {id}'**
  String sensorId(String id);

  /// Temperature value label
  ///
  /// In en, this message translates to:
  /// **'Temperature: {value}°C'**
  String temperatureValue(String value);

  /// Battery value label
  ///
  /// In en, this message translates to:
  /// **'Battery: {value}%'**
  String batteryValue(String value);

  /// Title for sensor list section
  ///
  /// In en, this message translates to:
  /// **'Sensor List'**
  String get sensorList;

  /// Title for current state section
  ///
  /// In en, this message translates to:
  /// **'Current State'**
  String get currentState;

  /// Title for temperature setting section
  ///
  /// In en, this message translates to:
  /// **'Temperature Setting'**
  String get temperatureSetting;

  /// Message shown when no temperature settings exist
  ///
  /// In en, this message translates to:
  /// **'No temperature settings available.'**
  String get noTemperatureSettings;

  /// Minimum temperature label
  ///
  /// In en, this message translates to:
  /// **'Min: {value}°C'**
  String minTemp(String value);

  /// Maximum temperature label
  ///
  /// In en, this message translates to:
  /// **'Max: {value}°C'**
  String maxTemp(String value);

  /// Text shown when alert is enabled
  ///
  /// In en, this message translates to:
  /// **'Alert: Enabled'**
  String get alertEnabled;

  /// Text shown when alert is disabled
  ///
  /// In en, this message translates to:
  /// **'Alert: Disabled'**
  String get alertDisabled;

  /// Delay in minutes label
  ///
  /// In en, this message translates to:
  /// **'Delay: {value} minutes'**
  String delayMinutes(String value);

  /// Minimum temperature setting label
  ///
  /// In en, this message translates to:
  /// **'Min Temperature: {value}°C'**
  String minTemperature(String value);

  /// Maximum temperature setting label
  ///
  /// In en, this message translates to:
  /// **'Max Temperature: {value}°C'**
  String maxTemperature(String value);

  /// Temperature alert toggle label
  ///
  /// In en, this message translates to:
  /// **'Temperature Alert:'**
  String get temperatureAlert;

  /// Delay before alert label
  ///
  /// In en, this message translates to:
  /// **'Delay Before Alert (minutes):'**
  String get delayBeforeAlert;

  /// Placeholder for delay input field
  ///
  /// In en, this message translates to:
  /// **'Enter delay in minutes'**
  String get enterDelayMinutes;

  /// Error message when delay is not entered
  ///
  /// In en, this message translates to:
  /// **'Please enter a delay value'**
  String get pleaseEnterDelay;

  /// Error message when invalid delay is entered
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid non-negative integer'**
  String get enterValidNumber;

  /// Title for allergy check section
  ///
  /// In en, this message translates to:
  /// **'CUSTOMER ALLERGY'**
  String get customerAllergy;

  /// Placeholder for allergens input
  ///
  /// In en, this message translates to:
  /// **'Enter allergens'**
  String get enterAllergens;

  /// Text shown while searching
  ///
  /// In en, this message translates to:
  /// **'Searching...'**
  String get searching;

  /// Error message when no allergens entered
  ///
  /// In en, this message translates to:
  /// **'Please enter allergens to check'**
  String get pleaseEnterAllergens;

  /// Title for safe items section
  ///
  /// In en, this message translates to:
  /// **'RESULTS NOT INCLUDING ALLERGY INGREDIENT'**
  String get safeItems;

  /// Title for unsafe items section
  ///
  /// In en, this message translates to:
  /// **'RESULTS INCLUDING ALLERGY INGREDIENT'**
  String get unsafeItems;

  /// Title for team members list
  ///
  /// In en, this message translates to:
  /// **'TEAM MEMBERS LIST'**
  String get teamMembersList;

  /// Button text for retry action
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Error message when team members loading fails
  ///
  /// In en, this message translates to:
  /// **'Failed to load team members: {error}'**
  String failedToLoadTeamMembers(String error);

  /// Error message when fetching team members fails
  ///
  /// In en, this message translates to:
  /// **'Error fetching team members: {error}'**
  String errorFetchingTeamMembers(String error);

  /// Column header for name
  ///
  /// In en, this message translates to:
  /// **'NAME'**
  String get name;

  /// Column header for user level
  ///
  /// In en, this message translates to:
  /// **'USER LEVEL'**
  String get userLevel;

  /// Column header for email address
  ///
  /// In en, this message translates to:
  /// **'EMAIL ADDRESS'**
  String get emailAddress;

  /// Column header for training level
  ///
  /// In en, this message translates to:
  /// **'TRAINING LEVEL'**
  String get trainingLevel;

  /// Message shown when checklist is completed
  ///
  /// In en, this message translates to:
  /// **'Checklist completed successfully'**
  String get checklistCompletedSuccessfully;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'it', 'pl', 'tr', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'it':
      return AppLocalizationsIt();
    case 'pl':
      return AppLocalizationsPl();
    case 'tr':
      return AppLocalizationsTr();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
