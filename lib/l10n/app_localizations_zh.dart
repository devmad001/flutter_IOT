// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Alpha';

  @override
  String get home => '首页';

  @override
  String get reports => '报告';

  @override
  String get setup => '设置';

  @override
  String get team => '团队';

  @override
  String get temperature => '温度';

  @override
  String get incidents => '事件';

  @override
  String get logout => '退出';

  @override
  String get login => '登录';

  @override
  String get username => '用户名';

  @override
  String get password => '密码';

  @override
  String get submit => '提交';

  @override
  String get cancel => '取消';

  @override
  String get save => '保存';

  @override
  String get delete => '删除';

  @override
  String get edit => '编辑';

  @override
  String get create => '创建';

  @override
  String get search => '搜索';

  @override
  String get noData => '暂无数据';

  @override
  String get loading => '加载中...';

  @override
  String get error => '错误';

  @override
  String get success => '成功';

  @override
  String get warning => '警告';

  @override
  String get info => '信息';

  @override
  String get notifications => '通知';

  @override
  String get notificationsSubtitle => '配置通知设置';

  @override
  String get language => '语言';

  @override
  String get security => '安全';

  @override
  String get securitySubtitle => '管理安全设置';

  @override
  String get backup => '备份和恢复';

  @override
  String get backupSubtitle => '管理数据备份和恢复';

  @override
  String get viewChecklist => '查看清单';

  @override
  String get clickToFill => '点击填写';

  @override
  String get addIncident => '添加事件';

  @override
  String get createIncident => '创建事件';

  @override
  String get openingChecklist => '开业清单';

  @override
  String get closingChecklist => '闭店清单';

  @override
  String get unknownRestaurant => '未知餐厅';

  @override
  String get battery => '电池';

  @override
  String lastUpdated(String datetime) {
    return '最后更新: $datetime';
  }

  @override
  String get selectDateRange => '选择日期范围';

  @override
  String get noTemperatureData => '所选日期范围内没有温度数据';

  @override
  String get temperatureHistory => '温度历史';

  @override
  String get temperatureChart => '温度图表';

  @override
  String get temperatureTable => '温度表格';

  @override
  String get menuHome => '首页';

  @override
  String get menuOpeningChecks => '开业检查';

  @override
  String get menuClosingChecks => '闭店检查';

  @override
  String get menuTemperatures => '温度';

  @override
  String get menuTeam => '团队';

  @override
  String get menuIncidents => '事件';

  @override
  String get menuReports => '报告';

  @override
  String get menuAllergyCheck => '过敏检查';

  @override
  String get menuSetup => '设置';

  @override
  String get menuLogout => '退出';

  @override
  String get temperatureUnit => '温度单位';

  @override
  String get selectReportFrequency => '选择报告频率';

  @override
  String get chooseReportRange => '请选择报告日期范围';

  @override
  String get thisWeek => '本周';

  @override
  String get thisMonth => '本月';

  @override
  String get customRange => '自定义范围';

  @override
  String selectedRange(String start, String end) {
    return '已选择范围: $start - $end';
  }

  @override
  String get reportContents => '报告将包含：';

  @override
  String get openingChecks => '开业检查';

  @override
  String get closingChecks => '闭店检查';

  @override
  String get temperatureReadings => '温度读数';

  @override
  String get incidentsLogged => '记录的事件';

  @override
  String get downloading => '下载中...';

  @override
  String get downloadReport => '下载报告';

  @override
  String get selectDateFirst => '请先选择日期范围';

  @override
  String get downloadSuccess => '报告下载成功';

  @override
  String downloadError(String error) {
    return '下载报告出错：$error';
  }

  @override
  String get noTasksAvailable => '暂无任务';

  @override
  String get alertSettings => '提醒设置';

  @override
  String get visualAlerts => '视觉提醒';

  @override
  String get showPopupNotifications => '显示弹出通知';

  @override
  String get audioAlerts => '声音提醒';

  @override
  String get playSoundNotifications => '播放声音通知';

  @override
  String get temperatures => '温度';

  @override
  String get selectSensorPrompt => '请从上方列表选择传感器以查看详情';

  @override
  String get noSensorData => '暂无传感器数据';

  @override
  String sensorId(String id) {
    return '传感器ID：$id';
  }

  @override
  String temperatureValue(String value) {
    return '温度：$value°C';
  }

  @override
  String batteryValue(String value) {
    return '电池：$value%';
  }

  @override
  String get sensorList => '传感器列表';

  @override
  String get currentState => '当前状态';

  @override
  String get temperatureSetting => '温度设置';

  @override
  String get noTemperatureSettings => '暂无温度设置';

  @override
  String minTemp(String value) {
    return '最低：$value°C';
  }

  @override
  String maxTemp(String value) {
    return '最高：$value°C';
  }

  @override
  String get alertEnabled => '提醒：已启用';

  @override
  String get alertDisabled => '提醒：已禁用';

  @override
  String delayMinutes(String value) {
    return '延迟：$value分钟';
  }

  @override
  String minTemperature(String value) {
    return '最低温度：$value°C';
  }

  @override
  String maxTemperature(String value) {
    return '最高温度：$value°C';
  }

  @override
  String get temperatureAlert => '温度提醒：';

  @override
  String get delayBeforeAlert => '提醒延迟（分钟）：';

  @override
  String get enterDelayMinutes => '输入延迟分钟数';

  @override
  String get pleaseEnterDelay => '请输入延迟值';

  @override
  String get enterValidNumber => '请输入有效的非负整数';

  @override
  String get customerAllergy => '顾客过敏';

  @override
  String get enterAllergens => '输入过敏原';

  @override
  String get searching => '搜索中...';

  @override
  String get pleaseEnterAllergens => '请输入要检查的过敏原';

  @override
  String get safeItems => '不含过敏原的结果';

  @override
  String get unsafeItems => '含有过敏原的结果';

  @override
  String get teamMembersList => '团队成员列表';

  @override
  String get retry => '重试';

  @override
  String failedToLoadTeamMembers(String error) {
    return '加载团队成员失败：$error';
  }

  @override
  String errorFetchingTeamMembers(String error) {
    return '获取团队成员出错：$error';
  }

  @override
  String get name => '姓名';

  @override
  String get userLevel => '用户级别';

  @override
  String get emailAddress => '电子邮箱';

  @override
  String get trainingLevel => '培训级别';
}
