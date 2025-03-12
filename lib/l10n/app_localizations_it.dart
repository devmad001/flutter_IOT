// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Alpha';

  @override
  String get home => 'Home';

  @override
  String get reports => 'Rapporti';

  @override
  String get setup => 'Configurazione';

  @override
  String get team => 'Team';

  @override
  String get temperature => 'Temperatura';

  @override
  String get incidents => 'Incidenti';

  @override
  String get logout => 'Esci';

  @override
  String get login => 'Accedi';

  @override
  String get username => 'Nome utente';

  @override
  String get password => 'Password';

  @override
  String get submit => 'Invia';

  @override
  String get cancel => 'Annulla';

  @override
  String get save => 'Salva';

  @override
  String get delete => 'Elimina';

  @override
  String get edit => 'Modifica';

  @override
  String get create => 'Crea';

  @override
  String get search => 'Cerca';

  @override
  String get noData => 'Nessun dato disponibile';

  @override
  String get loading => 'Caricamento...';

  @override
  String get error => 'Errore';

  @override
  String get success => 'Successo';

  @override
  String get warning => 'Avviso';

  @override
  String get info => 'Informazione';

  @override
  String get notifications => 'Notifiche';

  @override
  String get notificationsSubtitle => 'Configura le impostazioni delle notifiche';

  @override
  String get language => 'Lingua';

  @override
  String get security => 'Sicurezza';

  @override
  String get securitySubtitle => 'Gestisci le impostazioni di sicurezza';

  @override
  String get backup => 'Backup e Ripristino';

  @override
  String get backupSubtitle => 'Gestisci il backup e il ripristino dei dati';

  @override
  String get viewChecklist => 'VISUALIZZA CHECKLIST';

  @override
  String get clickToFill => 'CLICCA PER COMPILARE';

  @override
  String get addIncident => 'AGGIUNGI INCIDENTE';

  @override
  String get createIncident => 'CREA INCIDENTE';

  @override
  String get openingChecklist => 'Checklist di Apertura';

  @override
  String get closingChecklist => 'Checklist di Chiusura';

  @override
  String get unknownRestaurant => 'Ristorante Sconosciuto';

  @override
  String get battery => 'Batteria';

  @override
  String lastUpdated(String datetime) {
    return 'Ultimo aggiornamento: $datetime';
  }

  @override
  String get selectDateRange => 'Seleziona Intervallo Date';

  @override
  String get noTemperatureData => 'Nessun dato di temperatura disponibile per l\'intervallo selezionato';

  @override
  String get temperatureHistory => 'Storico Temperature';

  @override
  String get temperatureChart => 'Grafico Temperature';

  @override
  String get temperatureTable => 'Tabella Temperature';

  @override
  String get menuHome => 'HOME';

  @override
  String get menuOpeningChecks => 'CONTROLLI APERTURA';

  @override
  String get menuClosingChecks => 'CONTROLLI CHIUSURA';

  @override
  String get menuTemperatures => 'TEMPERATURE';

  @override
  String get menuTeam => 'TEAM';

  @override
  String get menuIncidents => 'INCIDENTI';

  @override
  String get menuReports => 'RAPPORTI';

  @override
  String get menuAllergyCheck => 'CONTROLLO ALLERGIE';

  @override
  String get menuSetup => 'CONFIGURAZIONE';

  @override
  String get menuLogout => 'ESCI';

  @override
  String get temperatureUnit => 'Unità di Temperatura';

  @override
  String get selectReportFrequency => 'Seleziona la frequenza dei rapporti';

  @override
  String get chooseReportRange => 'Seleziona l\'intervallo del rapporto qui sotto';

  @override
  String get thisWeek => 'Questa Settimana';

  @override
  String get thisMonth => 'Questo Mese';

  @override
  String get customRange => 'Intervallo Personalizzato';

  @override
  String selectedRange(String start, String end) {
    return 'Intervallo Selezionato: $start - $end';
  }

  @override
  String get reportContents => 'Contenuto del rapporto:';

  @override
  String get openingChecks => 'Controlli di Apertura';

  @override
  String get closingChecks => 'Controlli di Chiusura';

  @override
  String get temperatureReadings => 'Letture Temperatura';

  @override
  String get incidentsLogged => 'Incidenti Registrati';

  @override
  String get downloading => 'Download in corso...';

  @override
  String get downloadReport => 'Scarica Rapporto';

  @override
  String get selectDateFirst => 'Seleziona prima un intervallo di date';

  @override
  String get downloadSuccess => 'Rapporto scaricato con successo';

  @override
  String downloadError(String error) {
    return 'Errore durante il download del rapporto: $error';
  }

  @override
  String get noTasksAvailable => 'Nessuna attività disponibile';

  @override
  String get alertSettings => 'Impostazioni Avvisi';

  @override
  String get visualAlerts => 'Avvisi Visivi';

  @override
  String get showPopupNotifications => 'Mostra notifiche popup';

  @override
  String get audioAlerts => 'Avvisi Audio';

  @override
  String get playSoundNotifications => 'Riproduci notifiche sonore';

  @override
  String get temperatures => 'Temperature';

  @override
  String get selectSensorPrompt => 'Seleziona un sensore dalla lista sopra per vedere i dettagli';

  @override
  String get noSensorData => 'Nessun dato del sensore disponibile';

  @override
  String sensorId(String id) {
    return 'ID Sensore: $id';
  }

  @override
  String temperatureValue(String value) {
    return 'Temperatura: $value°C';
  }

  @override
  String batteryValue(String value) {
    return 'Batteria: $value%';
  }

  @override
  String get sensorList => 'Lista Sensori';

  @override
  String get currentState => 'Stato Attuale';

  @override
  String get temperatureSetting => 'Impostazione Temperatura';

  @override
  String get noTemperatureSettings => 'Nessuna impostazione temperatura disponibile';

  @override
  String minTemp(String value) {
    return 'Min: $value°C';
  }

  @override
  String maxTemp(String value) {
    return 'Max: $value°C';
  }

  @override
  String get alertEnabled => 'Avviso: Attivato';

  @override
  String get alertDisabled => 'Avviso: Disattivato';

  @override
  String delayMinutes(String value) {
    return 'Ritardo: $value minuti';
  }

  @override
  String minTemperature(String value) {
    return 'Temperatura Min: $value°C';
  }

  @override
  String maxTemperature(String value) {
    return 'Temperatura Max: $value°C';
  }

  @override
  String get temperatureAlert => 'Avviso Temperatura:';

  @override
  String get delayBeforeAlert => 'Ritardo Prima dell\'Avviso (minuti):';

  @override
  String get enterDelayMinutes => 'Inserisci ritardo in minuti';

  @override
  String get pleaseEnterDelay => 'Inserisci un valore di ritardo';

  @override
  String get enterValidNumber => 'Inserisci un numero intero non negativo valido';

  @override
  String get customerAllergy => 'ALLERGIE CLIENTE';

  @override
  String get enterAllergens => 'Inserisci allergeni';

  @override
  String get searching => 'Ricerca in corso...';

  @override
  String get pleaseEnterAllergens => 'Inserisci gli allergeni da controllare';

  @override
  String get safeItems => 'RISULTATI SENZA INGREDIENTI ALLERGENI';

  @override
  String get unsafeItems => 'RISULTATI CON INGREDIENTI ALLERGENI';

  @override
  String get teamMembersList => 'LISTA MEMBRI DEL TEAM';

  @override
  String get retry => 'Riprova';

  @override
  String failedToLoadTeamMembers(String error) {
    return 'Caricamento membri del team fallito: $error';
  }

  @override
  String errorFetchingTeamMembers(String error) {
    return 'Errore nel recupero dei membri del team: $error';
  }

  @override
  String get name => 'NOME';

  @override
  String get userLevel => 'LIVELLO UTENTE';

  @override
  String get emailAddress => 'INDIRIZZO EMAIL';

  @override
  String get trainingLevel => 'LIVELLO DI FORMAZIONE';
}
