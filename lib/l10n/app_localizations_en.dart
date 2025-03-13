// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Alpha';

  @override
  String get home => 'Home';

  @override
  String get reports => 'Reports';

  @override
  String get setup => 'Setup';

  @override
  String get team => 'Team';

  @override
  String get temperature => 'Temperature';

  @override
  String get incidents => 'Incidents';

  @override
  String get logout => 'Logout';

  @override
  String get login => 'Login';

  @override
  String get username => 'Username';

  @override
  String get password => 'Password';

  @override
  String get submit => 'Submit';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get create => 'Create';

  @override
  String get search => 'Search';

  @override
  String get noData => 'No data available';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'Error';

  @override
  String get success => 'Success';

  @override
  String get warning => 'Warning';

  @override
  String get info => 'Information';

  @override
  String get notifications => 'Notifications';

  @override
  String get notificationsSubtitle => 'Configure notification settings';

  @override
  String get language => 'Language';

  @override
  String get security => 'Security';

  @override
  String get securitySubtitle => 'Manage security settings';

  @override
  String get backup => 'Backup & Restore';

  @override
  String get backupSubtitle => 'Manage data backup and restore';

  @override
  String get viewChecklist => 'VIEW CHECKLIST';

  @override
  String get clickToFill => 'CLICK TO FILL';

  @override
  String get addIncident => 'ADD INCIDENT';

  @override
  String get createIncident => 'CREATE INCIDENT';

  @override
  String get openingChecklist => 'Opening Checklist';

  @override
  String get closingChecklist => 'Closing Checklist';

  @override
  String get unknownRestaurant => 'Unknown Restaurant';

  @override
  String get battery => 'Battery';

  @override
  String lastUpdated(String datetime) {
    return 'Last updated: $datetime';
  }

  @override
  String get selectDateRange => 'Select Date Range';

  @override
  String get noTemperatureData =>
      'No temperature data available for the selected date range';

  @override
  String get temperatureHistory => 'Temperature History';

  @override
  String get temperatureChart => 'Temperature Chart';

  @override
  String get temperatureTable => 'Temperature Table';

  @override
  String get menuHome => 'HOME';

  @override
  String get menuOpeningChecks => 'OPENING CHECKS';

  @override
  String get menuClosingChecks => 'CLOSING CHECKS';

  @override
  String get menuTemperatures => 'TEMPERATURES';

  @override
  String get menuTeam => 'TEAM';

  @override
  String get menuIncidents => 'INCIDENTS';

  @override
  String get menuReports => 'REPORTS';

  @override
  String get menuAllergyCheck => 'ALLERGY CHECK';

  @override
  String get menuSetup => 'SETUP';

  @override
  String get menuLogout => 'LOGOUT';

  @override
  String get temperatureUnit => 'Temperature Unit';

  @override
  String get selectReportFrequency => 'Select your report frequency';

  @override
  String get chooseReportRange => 'Please choose the report range below';

  @override
  String get thisWeek => 'This Week';

  @override
  String get thisMonth => 'This Month';

  @override
  String get customRange => 'Custom Range';

  @override
  String selectedRange(String start, String end) {
    return 'Selected Range: $start - $end';
  }

  @override
  String get reportContents => 'What the report will contain:';

  @override
  String get openingChecks => 'Opening Checks';

  @override
  String get closingChecks => 'Closing Checks';

  @override
  String get temperatureReadings => 'Temperature Readings';

  @override
  String get incidentsLogged => 'Incidents Logged';

  @override
  String get downloading => 'Downloading...';

  @override
  String get downloadReport => 'Download Report';

  @override
  String get selectDateFirst => 'Please select a date range first';

  @override
  String get downloadSuccess => 'Report downloaded successfully';

  @override
  String downloadError(String error) {
    return 'Error downloading report: $error';
  }

  @override
  String get noTasksAvailable => 'No tasks available';

  @override
  String get alertSettings => 'Alert Settings';

  @override
  String get visualAlerts => 'Visual Alerts';

  @override
  String get showPopupNotifications => 'Show popup notifications';

  @override
  String get audioAlerts => 'Audio Alerts';

  @override
  String get playSoundNotifications => 'Play sound notifications';

  @override
  String get temperatures => 'Temperatures';

  @override
  String get selectSensorPrompt =>
      'Select a sensor from the list above to view details.';

  @override
  String get noSensorData => 'No sensor data available.';

  @override
  String sensorId(String id) {
    return 'Sensor ID: $id';
  }

  @override
  String temperatureValue(String value) {
    return 'Temperature: $value°C';
  }

  @override
  String batteryValue(String value) {
    return 'Battery: $value%';
  }

  @override
  String get sensorList => 'Sensor List';

  @override
  String get currentState => 'Current State';

  @override
  String get temperatureSetting => 'Temperature Setting';

  @override
  String get noTemperatureSettings => 'No temperature settings available.';

  @override
  String minTemp(String value) {
    return 'Min: $value°C';
  }

  @override
  String maxTemp(String value) {
    return 'Max: $value°C';
  }

  @override
  String get alertEnabled => 'Alert: Enabled';

  @override
  String get alertDisabled => 'Alert: Disabled';

  @override
  String delayMinutes(String value) {
    return 'Delay: $value minutes';
  }

  @override
  String minTemperature(String value) {
    return 'Min Temperature: $value°C';
  }

  @override
  String maxTemperature(String value) {
    return 'Max Temperature: $value°C';
  }

  @override
  String get temperatureAlert => 'Temperature Alert:';

  @override
  String get delayBeforeAlert => 'Delay Before Alert (minutes):';

  @override
  String get enterDelayMinutes => 'Enter delay in minutes';

  @override
  String get pleaseEnterDelay => 'Please enter a delay value';

  @override
  String get enterValidNumber => 'Please enter a valid non-negative integer';

  @override
  String get customerAllergy => 'CUSTOMER ALLERGY';

  @override
  String get enterAllergens => 'Enter allergens';

  @override
  String get searching => 'Searching...';

  @override
  String get pleaseEnterAllergens => 'Please enter allergens to check';

  @override
  String get safeItems => 'RESULTS NOT INCLUDING ALLERGY INGREDIENT';

  @override
  String get unsafeItems => 'RESULTS INCLUDING ALLERGY INGREDIENT';

  @override
  String get teamMembersList => 'TEAM MEMBERS LIST';

  @override
  String get retry => 'Retry';

  @override
  String failedToLoadTeamMembers(String error) {
    return 'Failed to load team members: $error';
  }

  @override
  String errorFetchingTeamMembers(String error) {
    return 'Error fetching team members: $error';
  }

  @override
  String get name => 'NAME';

  @override
  String get userLevel => 'USER LEVEL';

  @override
  String get emailAddress => 'EMAIL ADDRESS';

  @override
  String get trainingLevel => 'Training Level';

  @override
  String get checklistCompletedSuccessfully =>
      'Checklist completed successfully';
}
