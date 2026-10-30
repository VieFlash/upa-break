import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

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
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
    Locale('vi')
  ];

  /// No description provided for @appTitle.
  ///
  /// In vi, this message translates to:
  /// **'Upa Break'**
  String get appTitle;

  /// No description provided for @tabToday.
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay'**
  String get tabToday;

  /// No description provided for @tabLibrary.
  ///
  /// In vi, this message translates to:
  /// **'Bài tập'**
  String get tabLibrary;

  /// No description provided for @tabHistory.
  ///
  /// In vi, this message translates to:
  /// **'Nhật ký'**
  String get tabHistory;

  /// No description provided for @tabSettings.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt'**
  String get tabSettings;

  /// No description provided for @actionContinue.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp tục'**
  String get actionContinue;

  /// No description provided for @actionResume.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp tục'**
  String get actionResume;

  /// No description provided for @actionBack.
  ///
  /// In vi, this message translates to:
  /// **'Quay lại'**
  String get actionBack;

  /// No description provided for @actionDone.
  ///
  /// In vi, this message translates to:
  /// **'Xong'**
  String get actionDone;

  /// No description provided for @actionPause.
  ///
  /// In vi, this message translates to:
  /// **'Tạm dừng'**
  String get actionPause;

  /// No description provided for @actionSkip.
  ///
  /// In vi, this message translates to:
  /// **'Bỏ qua'**
  String get actionSkip;

  /// No description provided for @actionEnable.
  ///
  /// In vi, this message translates to:
  /// **'Bật'**
  String get actionEnable;

  /// No description provided for @actionRefresh.
  ///
  /// In vi, this message translates to:
  /// **'Làm mới'**
  String get actionRefresh;

  /// No description provided for @modeGentle.
  ///
  /// In vi, this message translates to:
  /// **'Nhẹ nhàng'**
  String get modeGentle;

  /// No description provided for @modeGentleDesc.
  ///
  /// In vi, this message translates to:
  /// **'Nhắc mỗi 90 phút, ít làm phiền.'**
  String get modeGentleDesc;

  /// No description provided for @modeSmart.
  ///
  /// In vi, this message translates to:
  /// **'Thông minh'**
  String get modeSmart;

  /// No description provided for @modeSmartDesc.
  ///
  /// In vi, this message translates to:
  /// **'Khoảng 60 phút. Đang làm tốt thì nhắc thưa hơn, bị chậm thì nhắc sớm hơn.'**
  String get modeSmartDesc;

  /// No description provided for @modeFocus.
  ///
  /// In vi, this message translates to:
  /// **'Chăm chỉ'**
  String get modeFocus;

  /// No description provided for @modeFocusDesc.
  ///
  /// In vi, this message translates to:
  /// **'Nhắc đều mỗi 45 phút cho tới khi đạt mục tiêu.'**
  String get modeFocusDesc;

  /// No description provided for @areaNeck.
  ///
  /// In vi, this message translates to:
  /// **'Cổ'**
  String get areaNeck;

  /// No description provided for @areaShoulders.
  ///
  /// In vi, this message translates to:
  /// **'Vai'**
  String get areaShoulders;

  /// No description provided for @areaBack.
  ///
  /// In vi, this message translates to:
  /// **'Lưng'**
  String get areaBack;

  /// No description provided for @areaWrists.
  ///
  /// In vi, this message translates to:
  /// **'Cổ tay'**
  String get areaWrists;

  /// No description provided for @areaEyes.
  ///
  /// In vi, this message translates to:
  /// **'Mắt'**
  String get areaEyes;

  /// No description provided for @areaLegs.
  ///
  /// In vi, this message translates to:
  /// **'Chân'**
  String get areaLegs;

  /// No description provided for @weekdayMon.
  ///
  /// In vi, this message translates to:
  /// **'T2'**
  String get weekdayMon;

  /// No description provided for @weekdayTue.
  ///
  /// In vi, this message translates to:
  /// **'T3'**
  String get weekdayTue;

  /// No description provided for @weekdayWed.
  ///
  /// In vi, this message translates to:
  /// **'T4'**
  String get weekdayWed;

  /// No description provided for @weekdayThu.
  ///
  /// In vi, this message translates to:
  /// **'T5'**
  String get weekdayThu;

  /// No description provided for @weekdayFri.
  ///
  /// In vi, this message translates to:
  /// **'T6'**
  String get weekdayFri;

  /// No description provided for @weekdaySat.
  ///
  /// In vi, this message translates to:
  /// **'T7'**
  String get weekdaySat;

  /// No description provided for @weekdaySun.
  ///
  /// In vi, this message translates to:
  /// **'CN'**
  String get weekdaySun;

  /// No description provided for @moodFresh.
  ///
  /// In vi, this message translates to:
  /// **'Upa đang tỉnh táo ✨'**
  String get moodFresh;

  /// No description provided for @moodSlouch.
  ///
  /// In vi, this message translates to:
  /// **'{minutes, plural, other{Ngồi {minutes} phút rồi, Upa bắt đầu gù lưng}}'**
  String moodSlouch(int minutes);

  /// No description provided for @moodSleepy.
  ///
  /// In vi, this message translates to:
  /// **'Upa ngủ gục mất rồi… đứng dậy thôi!'**
  String get moodSleepy;

  /// No description provided for @moodProud.
  ///
  /// In vi, this message translates to:
  /// **'Đạt mục tiêu hôm nay rồi! 🎉'**
  String get moodProud;

  /// No description provided for @moodPaused.
  ///
  /// In vi, this message translates to:
  /// **'Đang họp, Upa im lặng 🤫'**
  String get moodPaused;

  /// No description provided for @moodOffHours.
  ///
  /// In vi, this message translates to:
  /// **'Ngoài giờ làm, nghỉ ngơi thôi'**
  String get moodOffHours;

  /// No description provided for @moodStretch.
  ///
  /// In vi, this message translates to:
  /// **'Duỗi người nào!'**
  String get moodStretch;

  /// No description provided for @nextReminderToday.
  ///
  /// In vi, this message translates to:
  /// **'Lời nhắc tiếp theo: {time}'**
  String nextReminderToday(String time);

  /// No description provided for @nextReminderTomorrow.
  ///
  /// In vi, this message translates to:
  /// **'Lời nhắc tiếp theo: {time} ngày mai'**
  String nextReminderTomorrow(String time);

  /// No description provided for @nextReminderDate.
  ///
  /// In vi, this message translates to:
  /// **'Lời nhắc tiếp theo: {time} ngày {day}/{month}'**
  String nextReminderDate(String time, int day, int month);

  /// No description provided for @pauseSheetTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tạm dừng nhắc trong…'**
  String get pauseSheetTitle;

  /// No description provided for @pause30m.
  ///
  /// In vi, this message translates to:
  /// **'30 phút'**
  String get pause30m;

  /// No description provided for @pause1h.
  ///
  /// In vi, this message translates to:
  /// **'1 tiếng'**
  String get pause1h;

  /// No description provided for @pause2h.
  ///
  /// In vi, this message translates to:
  /// **'2 tiếng'**
  String get pause2h;

  /// No description provided for @pauseRestOfDay.
  ///
  /// In vi, this message translates to:
  /// **'Hết hôm nay'**
  String get pauseRestOfDay;

  /// No description provided for @breaksOfGoal.
  ///
  /// In vi, this message translates to:
  /// **'{goal, plural, other{ / {goal} lần giãn cơ}}'**
  String breaksOfGoal(int goal);

  /// No description provided for @pausedUntil.
  ///
  /// In vi, this message translates to:
  /// **'Tạm dừng tới {time}'**
  String pausedUntil(String time);

  /// No description provided for @stretchNow.
  ///
  /// In vi, this message translates to:
  /// **'Giãn cơ ngay · 1 phút'**
  String get stretchNow;

  /// No description provided for @inMeeting.
  ///
  /// In vi, this message translates to:
  /// **'Đang họp'**
  String get inMeeting;

  /// No description provided for @exerciseProgress.
  ///
  /// In vi, this message translates to:
  /// **'Bài {current}/{total}'**
  String exerciseProgress(int current, int total);

  /// No description provided for @getReady.
  ///
  /// In vi, this message translates to:
  /// **'Chuẩn bị… {seconds}'**
  String getReady(int seconds);

  /// No description provided for @secondsLeft.
  ///
  /// In vi, this message translates to:
  /// **'{seconds, plural, other{{seconds} giây}}'**
  String secondsLeft(int seconds);

  /// No description provided for @doneNothing.
  ///
  /// In vi, this message translates to:
  /// **'Lần sau mình tập nhé!'**
  String get doneNothing;

  /// No description provided for @doneGreat.
  ///
  /// In vi, this message translates to:
  /// **'Giỏi quá! Upa duỗi người xong rồi'**
  String get doneGreat;

  /// No description provided for @fishReward.
  ///
  /// In vi, this message translates to:
  /// **'+{fish} 🐟 cá khô'**
  String fishReward(int fish);

  /// No description provided for @todayProgress.
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay: {count}/{goal} lần'**
  String todayProgress(int count, int goal);

  /// No description provided for @streakSuffix.
  ///
  /// In vi, this message translates to:
  /// **'{days, plural, other{ · 🔥 {days} ngày}}'**
  String streakSuffix(int days);

  /// No description provided for @goalReachedNote.
  ///
  /// In vi, this message translates to:
  /// **'🎉 Đạt mục tiêu hôm nay! Upa sẽ thôi nhắc tới ngày mai.'**
  String get goalReachedNote;

  /// No description provided for @statStreak.
  ///
  /// In vi, this message translates to:
  /// **'ngày liên tiếp'**
  String get statStreak;

  /// No description provided for @statFish.
  ///
  /// In vi, this message translates to:
  /// **'cá khô'**
  String get statFish;

  /// No description provided for @statDaysMet.
  ///
  /// In vi, this message translates to:
  /// **'ngày đạt'**
  String get statDaysMet;

  /// No description provided for @last7Days.
  ///
  /// In vi, this message translates to:
  /// **'7 ngày gần nhất'**
  String get last7Days;

  /// No description provided for @goalPerDay.
  ///
  /// In vi, this message translates to:
  /// **'Mục tiêu: {goal} lần/ngày'**
  String goalPerDay(int goal);

  /// No description provided for @historyEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có lần giãn cơ nào. Upa đang chờ nè!'**
  String get historyEmpty;

  /// No description provided for @libraryTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bài giãn cơ'**
  String get libraryTitle;

  /// No description provided for @onbWelcomeTitle.
  ///
  /// In vi, this message translates to:
  /// **'Ngồi lâu thì Upa cũng mỏi'**
  String get onbWelcomeTitle;

  /// No description provided for @onbWelcomeBody.
  ///
  /// In vi, this message translates to:
  /// **'Upa sẽ nhắc bạn đứng dậy, giãn cơ 1 phút ngay tại bàn.\nLỡ một lần cũng không sao, Upa không bao giờ trách.'**
  String get onbWelcomeBody;

  /// No description provided for @workEndBeforeStart.
  ///
  /// In vi, this message translates to:
  /// **'Giờ tan làm phải sau giờ vào làm nhé.'**
  String get workEndBeforeStart;

  /// No description provided for @onbScheduleTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bạn làm việc lúc nào?'**
  String get onbScheduleTitle;

  /// No description provided for @onbScheduleSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Upa chỉ nhắc trong giờ làm, không làm phiền buổi tối.'**
  String get onbScheduleSubtitle;

  /// No description provided for @sectionWorkHours.
  ///
  /// In vi, this message translates to:
  /// **'Giờ làm việc'**
  String get sectionWorkHours;

  /// No description provided for @workStartEnd.
  ///
  /// In vi, this message translates to:
  /// **'Vào làm – tan làm'**
  String get workStartEnd;

  /// No description provided for @sectionLunch.
  ///
  /// In vi, this message translates to:
  /// **'Nghỉ trưa'**
  String get sectionLunch;

  /// No description provided for @noRemindLunch.
  ///
  /// In vi, this message translates to:
  /// **'Không nhắc giờ nghỉ trưa'**
  String get noRemindLunch;

  /// No description provided for @lunchTime.
  ///
  /// In vi, this message translates to:
  /// **'Giờ nghỉ trưa'**
  String get lunchTime;

  /// No description provided for @sectionWorkDays.
  ///
  /// In vi, this message translates to:
  /// **'Ngày làm việc'**
  String get sectionWorkDays;

  /// No description provided for @onbStyleTitle.
  ///
  /// In vi, this message translates to:
  /// **'Upa nhắc kiểu nào?'**
  String get onbStyleTitle;

  /// No description provided for @sectionFocusAreas.
  ///
  /// In vi, this message translates to:
  /// **'Bạn hay mỏi ở đâu?'**
  String get sectionFocusAreas;

  /// No description provided for @dailyGoalLine.
  ///
  /// In vi, this message translates to:
  /// **'{goal, plural, other{Mục tiêu: {goal} lần giãn cơ mỗi ngày.}}'**
  String dailyGoalLine(int goal);

  /// No description provided for @onbPermissionTitle.
  ///
  /// In vi, this message translates to:
  /// **'Cho Upa nhắc bạn nhé?'**
  String get onbPermissionTitle;

  /// No description provided for @onbPermissionBody.
  ///
  /// In vi, this message translates to:
  /// **'Upa chỉ lắc chuông trong giờ làm, khi bạn đã ngồi lâu - không spam, không quảng cáo.\nBước tiếp theo điện thoại sẽ hỏi quyền gửi thông báo.'**
  String get onbPermissionBody;

  /// No description provided for @onbPermissionNote.
  ///
  /// In vi, this message translates to:
  /// **'Không cho phép cũng không sao, bạn vẫn dùng app và bật lại sau trong Cài đặt.'**
  String get onbPermissionNote;

  /// No description provided for @allowReminders.
  ///
  /// In vi, this message translates to:
  /// **'Cho phép Upa nhắc'**
  String get allowReminders;

  /// No description provided for @sectionReminderStyle.
  ///
  /// In vi, this message translates to:
  /// **'Kiểu nhắc'**
  String get sectionReminderStyle;

  /// No description provided for @sectionAreas.
  ///
  /// In vi, this message translates to:
  /// **'Vùng hay mỏi'**
  String get sectionAreas;

  /// No description provided for @currentGoal.
  ///
  /// In vi, this message translates to:
  /// **'Mục tiêu hiện tại: {goal} lần/ngày'**
  String currentGoal(int goal);

  /// No description provided for @sectionNotifications.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo'**
  String get sectionNotifications;

  /// No description provided for @notifOn.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo đang bật'**
  String get notifOn;

  /// No description provided for @notifOff.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo đang tắt'**
  String get notifOff;

  /// No description provided for @notifOnSub.
  ///
  /// In vi, this message translates to:
  /// **'Upa sẽ nhắc trong giờ làm'**
  String get notifOnSub;

  /// No description provided for @notifOffSub.
  ///
  /// In vi, this message translates to:
  /// **'Upa không nhắc được cho tới khi bạn bật lại'**
  String get notifOffSub;

  /// No description provided for @sendTestNotification.
  ///
  /// In vi, this message translates to:
  /// **'Gửi thông báo thử'**
  String get sendTestNotification;

  /// No description provided for @sendTestNotificationSub.
  ///
  /// In vi, this message translates to:
  /// **'Kiểm tra xem điện thoại có hiện lời nhắc không'**
  String get sendTestNotificationSub;

  /// No description provided for @sectionSoundVibration.
  ///
  /// In vi, this message translates to:
  /// **'Âm thanh & rung'**
  String get sectionSoundVibration;

  /// No description provided for @soundToggle.
  ///
  /// In vi, this message translates to:
  /// **'Âm thanh khi tập'**
  String get soundToggle;

  /// No description provided for @soundToggleSub.
  ///
  /// In vi, this message translates to:
  /// **'Tiếng \"tách\" ở 3 giây cuối và chuông khi xong bài. Âm lượng nhỏ, tự im khi máy để im lặng.'**
  String get soundToggleSub;

  /// No description provided for @vibrateToggle.
  ///
  /// In vi, this message translates to:
  /// **'Rung'**
  String get vibrateToggle;

  /// No description provided for @vibrateToggleSub.
  ///
  /// In vi, this message translates to:
  /// **'Rung nhẹ theo nhịp đếm'**
  String get vibrateToggleSub;

  /// No description provided for @sectionOnTime.
  ///
  /// In vi, this message translates to:
  /// **'Nhắc đúng giờ'**
  String get sectionOnTime;

  /// No description provided for @batteryIntro.
  ///
  /// In vi, this message translates to:
  /// **'Không nhận được lời nhắc? Máy có thể đang chặn Upa chạy nền.'**
  String get batteryIntro;

  /// No description provided for @onBrand.
  ///
  /// In vi, this message translates to:
  /// **'Trên {brand}:'**
  String onBrand(String brand);

  /// No description provided for @disableBatteryOpt.
  ///
  /// In vi, this message translates to:
  /// **'Tắt tối ưu pin'**
  String get disableBatteryOpt;

  /// No description provided for @appSettings.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt ứng dụng'**
  String get appSettings;

  /// No description provided for @disclaimer.
  ///
  /// In vi, this message translates to:
  /// **'Upa Break là app tạo thói quen, không phải lời khuyên y tế. Nếu bị đau kéo dài, hãy gặp bác sĩ hoặc chuyên gia vật lý trị liệu.'**
  String get disclaimer;

  /// No description provided for @sectionLanguage.
  ///
  /// In vi, this message translates to:
  /// **'Ngôn ngữ'**
  String get sectionLanguage;

  /// No description provided for @languageSystem.
  ///
  /// In vi, this message translates to:
  /// **'Theo máy'**
  String get languageSystem;

  /// No description provided for @languageVi.
  ///
  /// In vi, this message translates to:
  /// **'Tiếng Việt'**
  String get languageVi;

  /// No description provided for @languageEn.
  ///
  /// In vi, this message translates to:
  /// **'English'**
  String get languageEn;

  /// No description provided for @guideXiaomi.
  ///
  /// In vi, this message translates to:
  /// **'Mở Cài đặt ứng dụng của Upa Break.\nTiết kiệm pin → chọn \"Không hạn chế\".\nBật \"Tự khởi động\".\nỞ màn đa nhiệm, nhấn giữ Upa Break → chọn biểu tượng ổ khóa để không bị dọn.'**
  String get guideXiaomi;

  /// No description provided for @guideOppo.
  ///
  /// In vi, this message translates to:
  /// **'Mở Cài đặt ứng dụng của Upa Break.\nMức sử dụng pin → bật \"Cho phép hoạt động nền\" và \"Cho phép tự khởi chạy\".\nỞ màn đa nhiệm, nhấn giữ Upa Break → \"Khóa\" để không bị dọn.'**
  String get guideOppo;

  /// No description provided for @guideVivo.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt → Pin → Mức tiêu thụ điện năng nền cao → bật cho Upa Break.\ni Manager → Quản lý ứng dụng → Tự khởi động → bật Upa Break.\nỞ màn đa nhiệm, kéo Upa Break xuống để khóa.'**
  String get guideVivo;

  /// No description provided for @guideSamsung.
  ///
  /// In vi, this message translates to:
  /// **'Mở Cài đặt ứng dụng của Upa Break → Pin → chọn \"Không hạn chế\".\nCài đặt → Chăm sóc thiết bị → Pin → Giới hạn sử dụng nền: đảm bảo Upa Break không nằm trong \"Ứng dụng ngủ\" hoặc \"Ứng dụng ngủ sâu\".'**
  String get guideSamsung;

  /// No description provided for @guideOther.
  ///
  /// In vi, this message translates to:
  /// **'Bấm \"Tắt tối ưu pin\" bên dưới → tìm Upa Break → chọn \"Không tối ưu hóa\".\nNếu máy có mục \"Tự khởi động\" hoặc \"Chạy nền\", hãy bật cho Upa Break.'**
  String get guideOther;

  /// No description provided for @bannerTitle.
  ///
  /// In vi, this message translates to:
  /// **'Upa chưa được phép nhắc bạn'**
  String get bannerTitle;

  /// No description provided for @bannerBody.
  ///
  /// In vi, this message translates to:
  /// **'Bật thông báo để Upa nhắc bạn đứng dậy đúng giờ. Không bật cũng không sao, bạn vẫn tự giãn cơ được.'**
  String get bannerBody;

  /// No description provided for @enableNotifications.
  ///
  /// In vi, this message translates to:
  /// **'Bật thông báo'**
  String get enableNotifications;

  /// No description provided for @debugTitle.
  ///
  /// In vi, this message translates to:
  /// **'Debug thông báo'**
  String get debugTitle;

  /// No description provided for @debugStatus.
  ///
  /// In vi, this message translates to:
  /// **'Trạng thái'**
  String get debugStatus;

  /// No description provided for @debugError.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi: {error}'**
  String debugError(String error);

  /// No description provided for @debugPermission.
  ///
  /// In vi, this message translates to:
  /// **'Quyền thông báo'**
  String get debugPermission;

  /// No description provided for @permAllowed.
  ///
  /// In vi, this message translates to:
  /// **'Đã cho phép'**
  String get permAllowed;

  /// No description provided for @permDenied.
  ///
  /// In vi, this message translates to:
  /// **'Bị từ chối / đang tắt'**
  String get permDenied;

  /// No description provided for @permUnknown.
  ///
  /// In vi, this message translates to:
  /// **'Không xác định'**
  String get permUnknown;

  /// No description provided for @debugNow.
  ///
  /// In vi, this message translates to:
  /// **'Bây giờ'**
  String get debugNow;

  /// No description provided for @debugTestIn1Min.
  ///
  /// In vi, this message translates to:
  /// **'Nhắc thử sau 1 phút'**
  String get debugTestIn1Min;

  /// No description provided for @debugReschedule.
  ///
  /// In vi, this message translates to:
  /// **'Lên lịch lại'**
  String get debugReschedule;

  /// No description provided for @debugPlanned.
  ///
  /// In vi, this message translates to:
  /// **'Mốc nhắc theo kế hoạch ({count})'**
  String debugPlanned(int count);

  /// No description provided for @debugPlannedEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Không có mốc nào (đã đạt mục tiêu / ngoài giờ làm?)'**
  String get debugPlannedEmpty;

  /// No description provided for @debugPending.
  ///
  /// In vi, this message translates to:
  /// **'Đang chờ trong hệ thống ({count})'**
  String debugPending(int count);

  /// No description provided for @debugPendingEmpty.
  ///
  /// In vi, this message translates to:
  /// **'Không có thông báo nào đang chờ'**
  String get debugPendingEmpty;

  /// No description provided for @debugScheduledAt.
  ///
  /// In vi, this message translates to:
  /// **'Đã hẹn lúc {time}. Có thể tắt app để thử (Android có thể lệch vài phút).'**
  String debugScheduledAt(String time);

  /// No description provided for @notifChannelName.
  ///
  /// In vi, this message translates to:
  /// **'Nhắc giãn cơ'**
  String get notifChannelName;

  /// No description provided for @notifChannelDesc.
  ///
  /// In vi, this message translates to:
  /// **'Lời nhắc đứng dậy, giãn cơ trong giờ làm việc'**
  String get notifChannelDesc;

  /// No description provided for @notifActionStart.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu'**
  String get notifActionStart;

  /// No description provided for @notifActionSnooze.
  ///
  /// In vi, this message translates to:
  /// **'Để sau {minutes}\''**
  String notifActionSnooze(int minutes);

  /// No description provided for @notif1Title.
  ///
  /// In vi, this message translates to:
  /// **'Upa gù lưng rồi'**
  String get notif1Title;

  /// No description provided for @notif1Body.
  ///
  /// In vi, this message translates to:
  /// **'Đứng dậy duỗi người 1 phút cùng mình nhé.'**
  String get notif1Body;

  /// No description provided for @notif2Title.
  ///
  /// In vi, this message translates to:
  /// **'Cổ mỏi chưa?'**
  String get notif2Title;

  /// No description provided for @notif2Body.
  ///
  /// In vi, this message translates to:
  /// **'Nghiêng cổ vài nhịp là đỡ ngay.'**
  String get notif2Body;

  /// No description provided for @notif3Title.
  ///
  /// In vi, this message translates to:
  /// **'Ngồi lâu rồi đó'**
  String get notif3Title;

  /// No description provided for @notif3Body.
  ///
  /// In vi, this message translates to:
  /// **'Upa bắt đầu ngáp… mình giãn cơ chút nha.'**
  String get notif3Body;

  /// No description provided for @notif4Title.
  ///
  /// In vi, this message translates to:
  /// **'Giờ nghỉ 60 giây!'**
  String get notif4Title;

  /// No description provided for @notif4Body.
  ///
  /// In vi, this message translates to:
  /// **'Xoay vai, hít sâu, rồi làm tiếp.'**
  String get notif4Body;

  /// No description provided for @notif5Title.
  ///
  /// In vi, this message translates to:
  /// **'Mắt cần nghỉ 👀'**
  String get notif5Title;

  /// No description provided for @notif5Body.
  ///
  /// In vi, this message translates to:
  /// **'Nhìn ra xa 20 giây, Upa đếm cho.'**
  String get notif5Body;

  /// No description provided for @notif6Title.
  ///
  /// In vi, this message translates to:
  /// **'Upa đợi bạn nè'**
  String get notif6Title;

  /// No description provided for @notif6Body.
  ///
  /// In vi, this message translates to:
  /// **'Một bài nhỏ thôi, ngồi tại chỗ cũng làm được.'**
  String get notif6Body;

  /// No description provided for @notifTestTitle.
  ///
  /// In vi, this message translates to:
  /// **'Upa chào bạn 👋'**
  String get notifTestTitle;

  /// No description provided for @notifTestBody.
  ///
  /// In vi, this message translates to:
  /// **'Thông báo hoạt động tốt. Chạm để thử một bài giãn cơ.'**
  String get notifTestBody;

  /// No description provided for @notifTestScheduledTitle.
  ///
  /// In vi, this message translates to:
  /// **'Upa nhắc thử ⏰'**
  String get notifTestScheduledTitle;

  /// No description provided for @notifTestScheduledBody.
  ///
  /// In vi, this message translates to:
  /// **'Lời nhắc hẹn giờ hoạt động tốt. Chạm để giãn cơ.'**
  String get notifTestScheduledBody;

  /// No description provided for @notifSnoozeTitle.
  ///
  /// In vi, this message translates to:
  /// **'Upa nhắc lại nè ⏰'**
  String get notifSnoozeTitle;

  /// No description provided for @notifSnoozeBody.
  ///
  /// In vi, this message translates to:
  /// **'Đã {minutes} phút rồi, đứng dậy duỗi người 1 phút nhé.'**
  String notifSnoozeBody(int minutes);

  /// No description provided for @exNeckTiltName.
  ///
  /// In vi, this message translates to:
  /// **'Nghiêng cổ'**
  String get exNeckTiltName;

  /// No description provided for @exNeckTiltSteps.
  ///
  /// In vi, this message translates to:
  /// **'Ngồi thẳng, thả lỏng hai vai.\nNghiêng tai phải về phía vai phải, giữ 10 giây.\nVề giữa, nghiêng sang trái, giữ 10 giây.\nThở đều, làm chậm, không gây đau.'**
  String get exNeckTiltSteps;

  /// No description provided for @exChinTuckName.
  ///
  /// In vi, this message translates to:
  /// **'Thu cằm'**
  String get exChinTuckName;

  /// No description provided for @exChinTuckSteps.
  ///
  /// In vi, this message translates to:
  /// **'Ngồi thẳng, mắt nhìn về phía trước.\nKéo cằm lùi ra sau như đang tạo cằm đôi.\nGiữ 5 giây rồi thả lỏng.\nLặp lại khoảng 5 lần.'**
  String get exChinTuckSteps;

  /// No description provided for @exNeckTurnName.
  ///
  /// In vi, this message translates to:
  /// **'Quay cổ trái phải'**
  String get exNeckTurnName;

  /// No description provided for @exNeckTurnSteps.
  ///
  /// In vi, this message translates to:
  /// **'Từ từ quay đầu sang phải, giữ 5 giây.\nQuay về giữa.\nQuay sang trái, giữ 5 giây.\nChỉ quay trái phải, không xoay tròn cả vòng.'**
  String get exNeckTurnSteps;

  /// No description provided for @exShoulderRollName.
  ///
  /// In vi, this message translates to:
  /// **'Xoay vai'**
  String get exShoulderRollName;

  /// No description provided for @exShoulderRollSteps.
  ///
  /// In vi, this message translates to:
  /// **'Nhún hai vai lên gần tai.\nĐưa vai ra sau rồi hạ xuống.\nXoay 5 vòng ra sau.\nĐổi chiều, xoay 5 vòng ra trước.'**
  String get exShoulderRollSteps;

  /// No description provided for @exShoulderShrugName.
  ///
  /// In vi, this message translates to:
  /// **'Nhún vai thả lỏng'**
  String get exShoulderShrugName;

  /// No description provided for @exShoulderShrugSteps.
  ///
  /// In vi, this message translates to:
  /// **'Hít vào, nhún hai vai lên cao.\nGiữ 3 giây.\nThở ra, thả vai rơi xuống thật thả lỏng.\nLặp lại khoảng 6 lần.'**
  String get exShoulderShrugSteps;

  /// No description provided for @exChestOpenName.
  ///
  /// In vi, this message translates to:
  /// **'Mở ngực'**
  String get exChestOpenName;

  /// No description provided for @exChestOpenSteps.
  ///
  /// In vi, this message translates to:
  /// **'Đan hai bàn tay ra sau lưng.\nKéo hai bả vai lại gần nhau.\nƯỡn nhẹ ngực, mắt nhìn hơi lên.\nGiữ và thở đều.'**
  String get exChestOpenSteps;

  /// No description provided for @exOverheadReachName.
  ///
  /// In vi, this message translates to:
  /// **'Vươn người lên cao'**
  String get exOverheadReachName;

  /// No description provided for @exOverheadReachSteps.
  ///
  /// In vi, this message translates to:
  /// **'Đan hai tay, lật lòng bàn tay lên trên.\nVươn thẳng tay qua đầu.\nKéo dài cột sống, giữ 10 giây.\nThả lỏng rồi lặp lại.'**
  String get exOverheadReachSteps;

  /// No description provided for @exSideBendName.
  ///
  /// In vi, this message translates to:
  /// **'Nghiêng người'**
  String get exSideBendName;

  /// No description provided for @exSideBendSteps.
  ///
  /// In vi, this message translates to:
  /// **'Giơ tay phải lên cao.\nNghiêng người sang trái, giữ 10 giây.\nĐổi tay, nghiêng sang phải, giữ 10 giây.\nGiữ mông luôn chạm ghế.'**
  String get exSideBendSteps;

  /// No description provided for @exSeatedTwistName.
  ///
  /// In vi, this message translates to:
  /// **'Vặn mình trên ghế'**
  String get exSeatedTwistName;

  /// No description provided for @exSeatedTwistSteps.
  ///
  /// In vi, this message translates to:
  /// **'Ngồi thẳng, hai bàn chân đặt trên sàn.\nXoay thân sang phải, tay trái đặt lên gối phải.\nGiữ 10 giây, thở đều.\nĐổi bên.'**
  String get exSeatedTwistSteps;

  /// No description provided for @exCatCowName.
  ///
  /// In vi, this message translates to:
  /// **'Cong lưng kiểu mèo'**
  String get exCatCowName;

  /// No description provided for @exCatCowSteps.
  ///
  /// In vi, this message translates to:
  /// **'Ngồi mép ghế, hai tay đặt lên đùi.\nHít vào: ưỡn ngực, nhìn lên.\nThở ra: cong tròn lưng, cúi đầu.\nLặp lại thật chậm, như một chú mèo.'**
  String get exCatCowSteps;

  /// No description provided for @exWristFlexName.
  ///
  /// In vi, this message translates to:
  /// **'Giãn cổ tay (ngửa)'**
  String get exWristFlexName;

  /// No description provided for @exWristFlexSteps.
  ///
  /// In vi, this message translates to:
  /// **'Duỗi tay phải ra trước, lòng bàn tay ngửa.\nTay trái kéo nhẹ các ngón tay xuống.\nGiữ 10 giây rồi đổi tay.\nKéo nhẹ nhàng, không kéo mạnh.'**
  String get exWristFlexSteps;

  /// No description provided for @exWristExtName.
  ///
  /// In vi, this message translates to:
  /// **'Giãn cổ tay (úp)'**
  String get exWristExtName;

  /// No description provided for @exWristExtSteps.
  ///
  /// In vi, this message translates to:
  /// **'Duỗi tay ra trước, lòng bàn tay úp.\nTay kia ấn nhẹ mu bàn tay xuống.\nGiữ 10 giây rồi đổi tay.\nThả lỏng các ngón tay.'**
  String get exWristExtSteps;

  /// No description provided for @exFistSpreadName.
  ///
  /// In vi, this message translates to:
  /// **'Nắm – xòe tay'**
  String get exFistSpreadName;

  /// No description provided for @exFistSpreadSteps.
  ///
  /// In vi, this message translates to:
  /// **'Nắm chặt hai bàn tay.\nXòe rộng hết cỡ các ngón.\nLặp lại khoảng 10 lần.\nXoay cổ tay vài vòng mỗi chiều.'**
  String get exFistSpreadSteps;

  /// No description provided for @exEye2020Name.
  ///
  /// In vi, this message translates to:
  /// **'Nhìn xa 20 giây'**
  String get exEye2020Name;

  /// No description provided for @exEye2020Steps.
  ///
  /// In vi, this message translates to:
  /// **'Rời mắt khỏi màn hình.\nNhìn một vật ở xa khoảng 6 mét.\nChớp mắt chậm vài lần.\nThả lỏng cơ mặt.'**
  String get exEye2020Steps;

  /// No description provided for @exEyePalmingName.
  ///
  /// In vi, this message translates to:
  /// **'Úp tay nghỉ mắt'**
  String get exEyePalmingName;

  /// No description provided for @exEyePalmingSteps.
  ///
  /// In vi, this message translates to:
  /// **'Xoa hai lòng bàn tay cho ấm.\nÚp nhẹ lên mắt, không ấn vào mắt.\nHít thở chậm trong bóng tối.\nBỏ tay ra, mở mắt từ từ.'**
  String get exEyePalmingSteps;

  /// No description provided for @exCalfRaiseName.
  ///
  /// In vi, this message translates to:
  /// **'Kiễng gót'**
  String get exCalfRaiseName;

  /// No description provided for @exCalfRaiseSteps.
  ///
  /// In vi, this message translates to:
  /// **'Đứng dậy, vịn nhẹ vào bàn.\nKiễng gót lên cao, giữ 2 giây.\nHạ gót xuống từ từ.\nLặp lại khoảng 12 lần.'**
  String get exCalfRaiseSteps;

  /// No description provided for @exAnkleCircleName.
  ///
  /// In vi, this message translates to:
  /// **'Xoay cổ chân'**
  String get exAnkleCircleName;

  /// No description provided for @exAnkleCircleSteps.
  ///
  /// In vi, this message translates to:
  /// **'Duỗi chân phải, nhấc nhẹ khỏi sàn.\nXoay cổ chân 5 vòng mỗi chiều.\nĐổi sang chân trái.\nNgồi thẳng lưng khi làm.'**
  String get exAnkleCircleSteps;

  /// No description provided for @exFigureFourName.
  ///
  /// In vi, this message translates to:
  /// **'Giãn hông số 4'**
  String get exFigureFourName;

  /// No description provided for @exFigureFourSteps.
  ///
  /// In vi, this message translates to:
  /// **'Gác mắt cá chân phải lên gối trái.\nLưng thẳng, nghiêng nhẹ người về trước.\nGiữ khoảng 15 giây.\nĐổi chân.'**
  String get exFigureFourSteps;
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
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
