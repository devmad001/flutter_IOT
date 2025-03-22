import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Alpha';

  @override
  String get home => 'ホーム';

  @override
  String get reports => 'レポート';

  @override
  String get setup => '設定';

  @override
  String get team => 'チーム';

  @override
  String get temperature => '温度';

  @override
  String get incidents => 'インシデント';

  @override
  String get logout => 'ログアウト';

  @override
  String get login => 'ログイン';

  @override
  String get username => 'ユーザー名';

  @override
  String get password => 'パスワード';

  @override
  String get submit => '送信';

  @override
  String get cancel => 'キャンセル';

  @override
  String get save => '保存';

  @override
  String get delete => '削除';

  @override
  String get edit => '編集';

  @override
  String get create => '作成';

  @override
  String get search => '検索';

  @override
  String get noData => 'データなし';

  @override
  String get loading => '読み込み中...';

  @override
  String get error => 'エラー';

  @override
  String get success => '成功';

  @override
  String get warning => '警告';

  @override
  String get info => '情報';

  @override
  String get notifications => '通知';

  @override
  String get notificationsSubtitle => '通知設定の構成';

  @override
  String get language => '言語';

  @override
  String get security => 'セキュリティ';

  @override
  String get securitySubtitle => 'セキュリティ設定の管理';

  @override
  String get backup => 'バックアップと復元';

  @override
  String get backupSubtitle => 'データのバックアップと復元の管理';

  @override
  String get viewChecklist => 'チェックリストを表示';

  @override
  String get clickToFill => 'クリックして記入';

  @override
  String get addIncident => 'インシデントを追加';

  @override
  String get createIncident => 'インシデントを作成';

  @override
  String get openingChecklist => '開店チェックリスト';

  @override
  String get closingChecklist => '閉店チェックリスト';

  @override
  String get unknownRestaurant => '不明なレストラン';

  @override
  String get battery => 'バッテリー';

  @override
  String lastUpdated(String datetime) => '最終更新: $datetime';

  @override
  String get selectDateRange => '日付範囲を選択';

  @override
  String get noTemperatureData => '選択した日付範囲の温度データがありません';

  @override
  String get temperatureHistory => '温度履歴';

  @override
  String get temperatureChart => '温度チャート';

  @override
  String get temperatureTable => '温度テーブル';

  @override
  String get menuHome => 'ホーム';

  @override
  String get menuOpeningChecks => '開店チェック';

  @override
  String get menuClosingChecks => '閉店チェック';

  @override
  String get menuTemperatures => '温度';

  @override
  String get menuTeam => 'チーム';

  @override
  String get menuIncidents => 'インシデント';

  @override
  String get menuReports => 'レポート';

  @override
  String get menuAllergyCheck => 'アレルギーチェック';

  @override
  String get menuSetup => '設定';

  @override
  String get menuLogout => 'ログアウト';

  @override
  String get temperatureUnit => '温度単位';

  @override
  String get selectReportFrequency => 'レポート頻度を選択';

  @override
  String get chooseReportRange => 'レポートの日付範囲を選択してください';

  @override
  String get thisWeek => '今週';

  @override
  String get thisMonth => '今月';

  @override
  String get customRange => 'カスタム範囲';

  @override
  String selectedRange(String start, String end) => '選択範囲: $start - $end';

  @override
  String get reportContents => 'レポートには以下が含まれます：';

  @override
  String get openingChecks => '開店チェック';

  @override
  String get closingChecks => '閉店チェック';

  @override
  String get temperatureReadings => '温度記録';

  @override
  String get incidentsLogged => '記録されたインシデント';

  @override
  String get downloading => 'ダウンロード中...';

  @override
  String get downloadReport => 'レポートをダウンロード';

  @override
  String get selectDateFirst => '最初に日付範囲を選択してください';

  @override
  String get downloadSuccess => 'レポートのダウンロードに成功しました';

  @override
  String downloadError(String error) => 'レポートのダウンロードエラー: $error';

  @override
  String get noTasksAvailable => '利用可能なタスクがありません';

  @override
  String get alertSettings => 'アラート設定';

  @override
  String get visualAlerts => '視覚的アラート';

  @override
  String get showPopupNotifications => 'ポップアップ通知を表示';

  @override
  String get audioAlerts => '音声アラート';

  @override
  String get playSoundNotifications => '音声通知を再生';

  @override
  String get temperatures => '温度';

  @override
  String get selectSensorPrompt => '詳細を表示するには上記のリストからセンサーを選択してください';

  @override
  String get noSensorData => 'センサーデータがありません';

  @override
  String sensorId(String id) => 'センサーID: $id';

  @override
  String temperatureValue(String value) => '温度: ${value}°C';

  @override
  String batteryValue(String value) => 'バッテリー: ${value}%';

  @override
  String get sensorList => 'センサーリスト';

  @override
  String get currentState => '現在の状態';

  @override
  String get temperatureSetting => '温度設定';

  @override
  String get noTemperatureSettings => '温度設定がありません';

  @override
  String minTemp(String value) => '最小: ${value}°C';

  @override
  String maxTemp(String value) => '最大: ${value}°C';

  @override
  String get alertEnabled => 'アラート: 有効';

  @override
  String get alertDisabled => 'アラート: 無効';

  @override
  String delayMinutes(String value) => '遅延: ${value}分';

  @override
  String minTemperature(String value) => '最小温度: ${value}°C';

  @override
  String maxTemperature(String value) => '最大温度: ${value}°C';

  @override
  String get temperatureAlert => '温度アラート:';

  @override
  String get delayBeforeAlert => 'アラート前の遅延（分）:';

  @override
  String get enterDelayMinutes => '遅延時間を分単位で入力';

  @override
  String get pleaseEnterDelay => '遅延値を入力してください';

  @override
  String get enterValidNumber => '有効な非負の整数を入力してください';

  @override
  String get customerAllergy => '顧客アレルギー';

  @override
  String get enterAllergens => 'アレルゲンを入力';

  @override
  String get searching => '検索中...';

  @override
  String get pleaseEnterAllergens => 'チェックするアレルゲンを入力してください';

  @override
  String get safeItems => 'アレルゲンを含まない結果';

  @override
  String get unsafeItems => 'アレルゲンを含む結果';

  @override
  String get teamMembersList => 'チームメンバーリスト';

  @override
  String get retry => '再試行';

  @override
  String failedToLoadTeamMembers(String error) => 'チームメンバーの読み込みに失敗: $error';

  @override
  String errorFetchingTeamMembers(String error) => 'チームメンバーの取得エラー: $error';

  @override
  String get name => '名前';

  @override
  String get userLevel => 'ユーザーレベル';

  @override
  String get emailAddress => 'メールアドレス';

  @override
  String get trainingLevel => 'トレーニングレベル';

  @override
  String get checklistCompletedSuccessfully => 'チェックリストが正常に完了しました';
}
