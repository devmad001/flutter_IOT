// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'Alpha';

  @override
  String get home => 'Strona główna';

  @override
  String get reports => 'Raporty';

  @override
  String get setup => 'Ustawienia';

  @override
  String get team => 'Zespół';

  @override
  String get temperature => 'Temperatura';

  @override
  String get incidents => 'Incydenty';

  @override
  String get logout => 'Wyloguj';

  @override
  String get login => 'Zaloguj';

  @override
  String get username => 'Nazwa użytkownika';

  @override
  String get password => 'Hasło';

  @override
  String get submit => 'Zatwierdź';

  @override
  String get cancel => 'Anuluj';

  @override
  String get save => 'Zapisz';

  @override
  String get delete => 'Usuń';

  @override
  String get edit => 'Edytuj';

  @override
  String get create => 'Utwórz';

  @override
  String get search => 'Szukaj';

  @override
  String get noData => 'Brak danych';

  @override
  String get loading => 'Ładowanie...';

  @override
  String get error => 'Błąd';

  @override
  String get success => 'Sukces';

  @override
  String get warning => 'Ostrzeżenie';

  @override
  String get info => 'Informacja';

  @override
  String get notifications => 'Powiadomienia';

  @override
  String get notificationsSubtitle => 'Konfiguracja ustawień powiadomień';

  @override
  String get language => 'Język';

  @override
  String get security => 'Bezpieczeństwo';

  @override
  String get securitySubtitle => 'Zarządzanie ustawieniami bezpieczeństwa';

  @override
  String get backup => 'Kopia zapasowa i przywracanie';

  @override
  String get backupSubtitle =>
      'Zarządzanie kopiami zapasowymi i przywracaniem danych';

  @override
  String get viewChecklist => 'ZOBACZ LISTĘ';

  @override
  String get clickToFill => 'KLIKNIJ, ABY WYPEŁNIĆ';

  @override
  String get addIncident => 'DODAJ INCYENT';

  @override
  String get createIncident => 'UTWÓRZ INCYENT';

  @override
  String get openingChecklist => 'Lista kontrolna otwarcia';

  @override
  String get closingChecklist => 'Lista kontrolna zamknięcia';

  @override
  String get unknownRestaurant => 'Nieznana restauracja';

  @override
  String get battery => 'Bateria';

  @override
  String lastUpdated(String datetime) {
    return 'Ostatnia aktualizacja';
  }

  @override
  String get selectDateRange => 'Wybierz zakres dat';

  @override
  String get noTemperatureData =>
      'Brak danych o temperaturze dla wybranego zakresu dat';

  @override
  String get temperatureHistory => 'Historia temperatury';

  @override
  String get temperatureChart => 'Wykres temperatury';

  @override
  String get temperatureTable => 'Tabela temperatury';

  @override
  String get menuHome => 'STRONA GŁÓWNA';

  @override
  String get menuOpeningChecks => 'KONTROLA OTWARCIA';

  @override
  String get menuClosingChecks => 'KONTROLA ZAMKNIĘCIA';

  @override
  String get menuTemperatures => 'TEMPERATURY';

  @override
  String get menuTeam => 'ZESPÓŁ';

  @override
  String get menuIncidents => 'INCIDENTY';

  @override
  String get menuReports => 'RAPORTY';

  @override
  String get menuAllergyCheck => 'KONTROLA ALERGII';

  @override
  String get menuSetup => 'USTAWIENIA';

  @override
  String get menuLogout => 'WYLOGUJ';

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
  String get trainingLevel => 'Poziom szkolenia';

  @override
  String get checklistCompletedSuccessfully =>
      'Lista kontrolna została pomyślnie ukończona';
}
