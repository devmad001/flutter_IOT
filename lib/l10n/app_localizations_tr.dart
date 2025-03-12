// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Alpha';

  @override
  String get home => 'Ana Sayfa';

  @override
  String get reports => 'Raporlar';

  @override
  String get setup => 'Ayarlar';

  @override
  String get team => 'Ekip';

  @override
  String get temperature => 'Sıcaklık';

  @override
  String get incidents => 'Olaylar';

  @override
  String get logout => 'Çıkış';

  @override
  String get login => 'Giriş';

  @override
  String get username => 'Kullanıcı Adı';

  @override
  String get password => 'Şifre';

  @override
  String get submit => 'Gönder';

  @override
  String get cancel => 'İptal';

  @override
  String get save => 'Kaydet';

  @override
  String get delete => 'Sil';

  @override
  String get edit => 'Düzenle';

  @override
  String get create => 'Oluştur';

  @override
  String get search => 'Ara';

  @override
  String get noData => 'Veri yok';

  @override
  String get loading => 'Yükleniyor...';

  @override
  String get error => 'Hata';

  @override
  String get success => 'Başarılı';

  @override
  String get warning => 'Uyarı';

  @override
  String get info => 'Bilgi';

  @override
  String get notifications => 'Bildirimler';

  @override
  String get notificationsSubtitle => 'Bildirim ayarlarını yapılandır';

  @override
  String get language => 'Dil';

  @override
  String get security => 'Güvenlik';

  @override
  String get securitySubtitle => 'Güvenlik ayarlarını yönet';

  @override
  String get backup => 'Yedekleme ve Geri Yükleme';

  @override
  String get backupSubtitle => 'Veri yedekleme ve geri yüklemeyi yönet';

  @override
  String get viewChecklist => 'KONTROL LİSTESİNİ GÖRÜNTÜLE';

  @override
  String get clickToFill => 'DOLDURMAK İÇİN TIKLA';

  @override
  String get addIncident => 'OLAY EKLE';

  @override
  String get createIncident => 'OLAY OLUŞTUR';

  @override
  String get openingChecklist => 'Açılış Kontrol Listesi';

  @override
  String get closingChecklist => 'Kapanış Kontrol Listesi';

  @override
  String get unknownRestaurant => 'Bilinmeyen Restoran';

  @override
  String get battery => 'Pil';

  @override
  String lastUpdated(String datetime) {
    return 'Son güncelleme: $datetime';
  }

  @override
  String get selectDateRange => 'Tarih Aralığı Seç';

  @override
  String get noTemperatureData => 'Seçilen tarih aralığında sıcaklık verisi yok';

  @override
  String get temperatureHistory => 'Sıcaklık Geçmişi';

  @override
  String get temperatureChart => 'Sıcaklık Grafiği';

  @override
  String get temperatureTable => 'Sıcaklık Tablosu';

  @override
  String get menuHome => 'ANA SAYFA';

  @override
  String get menuOpeningChecks => 'AÇILIŞ KONTROLLERİ';

  @override
  String get menuClosingChecks => 'KAPANIŞ KONTROLLERİ';

  @override
  String get menuTemperatures => 'SICAKLIKLAR';

  @override
  String get menuTeam => 'EKİP';

  @override
  String get menuIncidents => 'OLAYLAR';

  @override
  String get menuReports => 'RAPORLAR';

  @override
  String get menuAllergyCheck => 'ALERJİ KONTROLÜ';

  @override
  String get menuSetup => 'AYARLAR';

  @override
  String get menuLogout => 'ÇIKIŞ';

  @override
  String get temperatureUnit => 'Sıcaklık Birimi';

  @override
  String get selectReportFrequency => 'Rapor sıklığını seçin';

  @override
  String get chooseReportRange => 'Lütfen aşağıdan rapor aralığını seçin';

  @override
  String get thisWeek => 'Bu Hafta';

  @override
  String get thisMonth => 'Bu Ay';

  @override
  String get customRange => 'Özel Aralık';

  @override
  String selectedRange(String start, String end) {
    return 'Seçilen Aralık: $start - $end';
  }

  @override
  String get reportContents => 'Rapor içeriği:';

  @override
  String get openingChecks => 'Açılış Kontrolleri';

  @override
  String get closingChecks => 'Kapanış Kontrolleri';

  @override
  String get temperatureReadings => 'Sıcaklık Okumaları';

  @override
  String get incidentsLogged => 'Kaydedilen Olaylar';

  @override
  String get downloading => 'İndiriliyor...';

  @override
  String get downloadReport => 'Raporu İndir';

  @override
  String get selectDateFirst => 'Lütfen önce bir tarih aralığı seçin';

  @override
  String get downloadSuccess => 'Rapor başarıyla indirildi';

  @override
  String downloadError(String error) {
    return 'Rapor indirilirken hata: $error';
  }

  @override
  String get noTasksAvailable => 'Görev yok';

  @override
  String get alertSettings => 'Uyarı Ayarları';

  @override
  String get visualAlerts => 'Görsel Uyarılar';

  @override
  String get showPopupNotifications => 'Açılır bildirimleri göster';

  @override
  String get audioAlerts => 'Sesli Uyarılar';

  @override
  String get playSoundNotifications => 'Sesli bildirimleri çal';

  @override
  String get temperatures => 'Sıcaklıklar';

  @override
  String get selectSensorPrompt => 'Detayları görmek için yukarıdaki listeden bir sensör seçin';

  @override
  String get noSensorData => 'Sensör verisi yok';

  @override
  String sensorId(String id) {
    return 'Sensör ID: $id';
  }

  @override
  String temperatureValue(String value) {
    return 'Sıcaklık: $value°C';
  }

  @override
  String batteryValue(String value) {
    return 'Pil: $value%';
  }

  @override
  String get sensorList => 'Sensör Listesi';

  @override
  String get currentState => 'Mevcut Durum';

  @override
  String get temperatureSetting => 'Sıcaklık Ayarı';

  @override
  String get noTemperatureSettings => 'Sıcaklık ayarı yok';

  @override
  String minTemp(String value) {
    return 'Min: $value°C';
  }

  @override
  String maxTemp(String value) {
    return 'Maks: $value°C';
  }

  @override
  String get alertEnabled => 'Uyarı: Açık';

  @override
  String get alertDisabled => 'Uyarı: Kapalı';

  @override
  String delayMinutes(String value) {
    return 'Gecikme: $value dakika';
  }

  @override
  String minTemperature(String value) {
    return 'Min Sıcaklık: $value°C';
  }

  @override
  String maxTemperature(String value) {
    return 'Maks Sıcaklık: $value°C';
  }

  @override
  String get temperatureAlert => 'Sıcaklık Uyarısı:';

  @override
  String get delayBeforeAlert => 'Uyarı Öncesi Gecikme (dakika):';

  @override
  String get enterDelayMinutes => 'Gecikme dakikasını girin';

  @override
  String get pleaseEnterDelay => 'Lütfen bir gecikme değeri girin';

  @override
  String get enterValidNumber => 'Lütfen geçerli bir pozitif tam sayı girin';

  @override
  String get customerAllergy => 'MÜŞTERİ ALERJİSİ';

  @override
  String get enterAllergens => 'Alerjenleri girin';

  @override
  String get searching => 'Aranıyor...';

  @override
  String get pleaseEnterAllergens => 'Lütfen kontrol edilecek alerjenleri girin';

  @override
  String get safeItems => 'ALERJİ İÇERMEYEN SONUÇLAR';

  @override
  String get unsafeItems => 'ALERJİ İÇEREN SONUÇLAR';

  @override
  String get teamMembersList => 'EKİP ÜYELERİ LİSTESİ';

  @override
  String get retry => 'Tekrar Dene';

  @override
  String failedToLoadTeamMembers(String error) {
    return 'Ekip üyeleri yüklenemedi: $error';
  }

  @override
  String errorFetchingTeamMembers(String error) {
    return 'Ekip üyeleri alınırken hata: $error';
  }

  @override
  String get name => 'AD';

  @override
  String get userLevel => 'KULLANICI SEVİYESİ';

  @override
  String get emailAddress => 'E-POSTA ADRESİ';

  @override
  String get trainingLevel => 'EĞİTİM SEVİYESİ';
}
