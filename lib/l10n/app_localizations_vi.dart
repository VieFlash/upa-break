// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Upa Break';

  @override
  String get tabToday => 'Hôm nay';

  @override
  String get tabLibrary => 'Bài tập';

  @override
  String get tabHistory => 'Nhật ký';

  @override
  String get tabSettings => 'Cài đặt';

  @override
  String get actionContinue => 'Tiếp tục';

  @override
  String get actionResume => 'Tiếp tục';

  @override
  String get actionBack => 'Quay lại';

  @override
  String get actionDone => 'Xong';

  @override
  String get actionPause => 'Tạm dừng';

  @override
  String get actionSkip => 'Bỏ qua';

  @override
  String get actionEnable => 'Bật';

  @override
  String get actionRefresh => 'Làm mới';

  @override
  String get modeGentle => 'Nhẹ nhàng';

  @override
  String get modeGentleDesc => 'Nhắc mỗi 90 phút, ít làm phiền.';

  @override
  String get modeSmart => 'Thông minh';

  @override
  String get modeSmartDesc =>
      'Khoảng 60 phút. Đang làm tốt thì nhắc thưa hơn, bị chậm thì nhắc sớm hơn.';

  @override
  String get modeFocus => 'Chăm chỉ';

  @override
  String get modeFocusDesc => 'Nhắc đều mỗi 45 phút cho tới khi đạt mục tiêu.';

  @override
  String get areaNeck => 'Cổ';

  @override
  String get areaShoulders => 'Vai';

  @override
  String get areaBack => 'Lưng';

  @override
  String get areaWrists => 'Cổ tay';

  @override
  String get areaEyes => 'Mắt';

  @override
  String get areaLegs => 'Chân';

  @override
  String get weekdayMon => 'T2';

  @override
  String get weekdayTue => 'T3';

  @override
  String get weekdayWed => 'T4';

  @override
  String get weekdayThu => 'T5';

  @override
  String get weekdayFri => 'T6';

  @override
  String get weekdaySat => 'T7';

  @override
  String get weekdaySun => 'CN';

  @override
  String get moodFresh => 'Upa đang tỉnh táo ✨';

  @override
  String moodSlouch(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: 'Ngồi $minutes phút rồi, Upa bắt đầu gù lưng',
    );
    return '$_temp0';
  }

  @override
  String get moodSleepy => 'Upa ngủ gục mất rồi… đứng dậy thôi!';

  @override
  String get moodProud => 'Đạt mục tiêu hôm nay rồi! 🎉';

  @override
  String get moodPaused => 'Đang họp, Upa im lặng 🤫';

  @override
  String get moodOffHours => 'Ngoài giờ làm, nghỉ ngơi thôi';

  @override
  String get moodStretch => 'Duỗi người nào!';

  @override
  String nextReminderToday(String time) {
    return 'Lời nhắc tiếp theo: $time';
  }

  @override
  String nextReminderTomorrow(String time) {
    return 'Lời nhắc tiếp theo: $time ngày mai';
  }

  @override
  String nextReminderDate(String time, int day, int month) {
    return 'Lời nhắc tiếp theo: $time ngày $day/$month';
  }

  @override
  String get pauseSheetTitle => 'Tạm dừng nhắc trong…';

  @override
  String get pause30m => '30 phút';

  @override
  String get pause1h => '1 tiếng';

  @override
  String get pause2h => '2 tiếng';

  @override
  String get pauseRestOfDay => 'Hết hôm nay';

  @override
  String breaksOfGoal(int goal) {
    String _temp0 = intl.Intl.pluralLogic(
      goal,
      locale: localeName,
      other: ' / $goal lần giãn cơ',
    );
    return '$_temp0';
  }

  @override
  String pausedUntil(String time) {
    return 'Tạm dừng tới $time';
  }

  @override
  String get stretchNow => 'Giãn cơ ngay · 1 phút';

  @override
  String get inMeeting => 'Đang họp';

  @override
  String exerciseProgress(int current, int total) {
    return 'Bài $current/$total';
  }

  @override
  String getReady(int seconds) {
    return 'Chuẩn bị… $seconds';
  }

  @override
  String secondsLeft(int seconds) {
    String _temp0 = intl.Intl.pluralLogic(
      seconds,
      locale: localeName,
      other: '$seconds giây',
    );
    return '$_temp0';
  }

  @override
  String get doneNothing => 'Lần sau mình tập nhé!';

  @override
  String get doneGreat => 'Giỏi quá! Upa duỗi người xong rồi';

  @override
  String fishReward(int fish) {
    return '+$fish 🐟 cá khô';
  }

  @override
  String todayProgress(int count, int goal) {
    return 'Hôm nay: $count/$goal lần';
  }

  @override
  String streakSuffix(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: ' · 🔥 $days ngày',
    );
    return '$_temp0';
  }

  @override
  String get goalReachedNote =>
      '🎉 Đạt mục tiêu hôm nay! Upa sẽ thôi nhắc tới ngày mai.';

  @override
  String get statStreak => 'ngày liên tiếp';

  @override
  String get statFish => 'cá khô';

  @override
  String get statDaysMet => 'ngày đạt';

  @override
  String get last7Days => '7 ngày gần nhất';

  @override
  String goalPerDay(int goal) {
    return 'Mục tiêu: $goal lần/ngày';
  }

  @override
  String get historyEmpty => 'Chưa có lần giãn cơ nào. Upa đang chờ nè!';

  @override
  String get libraryTitle => 'Bài giãn cơ';

  @override
  String get onbWelcomeTitle => 'Ngồi lâu thì Upa cũng mỏi';

  @override
  String get onbWelcomeBody =>
      'Upa sẽ nhắc bạn đứng dậy, giãn cơ 1 phút ngay tại bàn.\nLỡ một lần cũng không sao, Upa không bao giờ trách.';

  @override
  String get workEndBeforeStart => 'Giờ tan làm phải sau giờ vào làm nhé.';

  @override
  String get onbScheduleTitle => 'Bạn làm việc lúc nào?';

  @override
  String get onbScheduleSubtitle =>
      'Upa chỉ nhắc trong giờ làm, không làm phiền buổi tối.';

  @override
  String get sectionWorkHours => 'Giờ làm việc';

  @override
  String get workStartEnd => 'Vào làm – tan làm';

  @override
  String get sectionLunch => 'Nghỉ trưa';

  @override
  String get noRemindLunch => 'Không nhắc giờ nghỉ trưa';

  @override
  String get lunchTime => 'Giờ nghỉ trưa';

  @override
  String get sectionWorkDays => 'Ngày làm việc';

  @override
  String get onbStyleTitle => 'Upa nhắc kiểu nào?';

  @override
  String get sectionFocusAreas => 'Bạn hay mỏi ở đâu?';

  @override
  String dailyGoalLine(int goal) {
    String _temp0 = intl.Intl.pluralLogic(
      goal,
      locale: localeName,
      other: 'Mục tiêu: $goal lần giãn cơ mỗi ngày.',
    );
    return '$_temp0';
  }

  @override
  String get onbPermissionTitle => 'Cho Upa nhắc bạn nhé?';

  @override
  String get onbPermissionBody =>
      'Upa chỉ lắc chuông trong giờ làm, khi bạn đã ngồi lâu - không spam, không quảng cáo.\nBước tiếp theo điện thoại sẽ hỏi quyền gửi thông báo.';

  @override
  String get onbPermissionNote =>
      'Không cho phép cũng không sao, bạn vẫn dùng app và bật lại sau trong Cài đặt.';

  @override
  String get allowReminders => 'Cho phép Upa nhắc';

  @override
  String get sectionReminderStyle => 'Kiểu nhắc';

  @override
  String get sectionAreas => 'Vùng hay mỏi';

  @override
  String currentGoal(int goal) {
    return 'Mục tiêu hiện tại: $goal lần/ngày';
  }

  @override
  String get sectionNotifications => 'Thông báo';

  @override
  String get notifOn => 'Thông báo đang bật';

  @override
  String get notifOff => 'Thông báo đang tắt';

  @override
  String get notifOnSub => 'Upa sẽ nhắc trong giờ làm';

  @override
  String get notifOffSub => 'Upa không nhắc được cho tới khi bạn bật lại';

  @override
  String get sendTestNotification => 'Gửi thông báo thử';

  @override
  String get sendTestNotificationSub =>
      'Kiểm tra xem điện thoại có hiện lời nhắc không';

  @override
  String get sectionSoundVibration => 'Âm thanh & rung';

  @override
  String get soundToggle => 'Âm thanh khi tập';

  @override
  String get soundToggleSub =>
      'Tiếng \"tách\" ở 3 giây cuối và chuông khi xong bài. Âm lượng nhỏ, tự im khi máy để im lặng.';

  @override
  String get vibrateToggle => 'Rung';

  @override
  String get vibrateToggleSub => 'Rung nhẹ theo nhịp đếm';

  @override
  String get sectionOnTime => 'Nhắc đúng giờ';

  @override
  String get batteryIntro =>
      'Không nhận được lời nhắc? Máy có thể đang chặn Upa chạy nền.';

  @override
  String onBrand(String brand) {
    return 'Trên $brand:';
  }

  @override
  String get disableBatteryOpt => 'Tắt tối ưu pin';

  @override
  String get appSettings => 'Cài đặt ứng dụng';

  @override
  String get disclaimer =>
      'Upa Break là app tạo thói quen, không phải lời khuyên y tế. Nếu bị đau kéo dài, hãy gặp bác sĩ hoặc chuyên gia vật lý trị liệu.';

  @override
  String get sectionLanguage => 'Ngôn ngữ';

  @override
  String get languageSystem => 'Theo máy';

  @override
  String get languageVi => 'Tiếng Việt';

  @override
  String get languageEn => 'English';

  @override
  String get guideXiaomi =>
      'Mở Cài đặt ứng dụng của Upa Break.\nTiết kiệm pin → chọn \"Không hạn chế\".\nBật \"Tự khởi động\".\nỞ màn đa nhiệm, nhấn giữ Upa Break → chọn biểu tượng ổ khóa để không bị dọn.';

  @override
  String get guideOppo =>
      'Mở Cài đặt ứng dụng của Upa Break.\nMức sử dụng pin → bật \"Cho phép hoạt động nền\" và \"Cho phép tự khởi chạy\".\nỞ màn đa nhiệm, nhấn giữ Upa Break → \"Khóa\" để không bị dọn.';

  @override
  String get guideVivo =>
      'Cài đặt → Pin → Mức tiêu thụ điện năng nền cao → bật cho Upa Break.\ni Manager → Quản lý ứng dụng → Tự khởi động → bật Upa Break.\nỞ màn đa nhiệm, kéo Upa Break xuống để khóa.';

  @override
  String get guideSamsung =>
      'Mở Cài đặt ứng dụng của Upa Break → Pin → chọn \"Không hạn chế\".\nCài đặt → Chăm sóc thiết bị → Pin → Giới hạn sử dụng nền: đảm bảo Upa Break không nằm trong \"Ứng dụng ngủ\" hoặc \"Ứng dụng ngủ sâu\".';

  @override
  String get guideOther =>
      'Bấm \"Tắt tối ưu pin\" bên dưới → tìm Upa Break → chọn \"Không tối ưu hóa\".\nNếu máy có mục \"Tự khởi động\" hoặc \"Chạy nền\", hãy bật cho Upa Break.';

  @override
  String get bannerTitle => 'Upa chưa được phép nhắc bạn';

  @override
  String get bannerBody =>
      'Bật thông báo để Upa nhắc bạn đứng dậy đúng giờ. Không bật cũng không sao, bạn vẫn tự giãn cơ được.';

  @override
  String get enableNotifications => 'Bật thông báo';

  @override
  String get debugTitle => 'Debug thông báo';

  @override
  String get debugStatus => 'Trạng thái';

  @override
  String debugError(String error) {
    return 'Lỗi: $error';
  }

  @override
  String get debugPermission => 'Quyền thông báo';

  @override
  String get permAllowed => 'Đã cho phép';

  @override
  String get permDenied => 'Bị từ chối / đang tắt';

  @override
  String get permUnknown => 'Không xác định';

  @override
  String get debugNow => 'Bây giờ';

  @override
  String get debugTestIn1Min => 'Nhắc thử sau 1 phút';

  @override
  String get debugReschedule => 'Lên lịch lại';

  @override
  String debugPlanned(int count) {
    return 'Mốc nhắc theo kế hoạch ($count)';
  }

  @override
  String get debugPlannedEmpty =>
      'Không có mốc nào (đã đạt mục tiêu / ngoài giờ làm?)';

  @override
  String debugPending(int count) {
    return 'Đang chờ trong hệ thống ($count)';
  }

  @override
  String get debugPendingEmpty => 'Không có thông báo nào đang chờ';

  @override
  String debugScheduledAt(String time) {
    return 'Đã hẹn lúc $time. Có thể tắt app để thử (Android có thể lệch vài phút).';
  }

  @override
  String get notifChannelName => 'Nhắc giãn cơ';

  @override
  String get notifChannelDesc =>
      'Lời nhắc đứng dậy, giãn cơ trong giờ làm việc';

  @override
  String get notifActionStart => 'Bắt đầu';

  @override
  String notifActionSnooze(int minutes) {
    return 'Để sau $minutes\'';
  }

  @override
  String get notif1Title => 'Upa gù lưng rồi';

  @override
  String get notif1Body => 'Đứng dậy duỗi người 1 phút cùng mình nhé.';

  @override
  String get notif2Title => 'Cổ mỏi chưa?';

  @override
  String get notif2Body => 'Nghiêng cổ vài nhịp là đỡ ngay.';

  @override
  String get notif3Title => 'Ngồi lâu rồi đó';

  @override
  String get notif3Body => 'Upa bắt đầu ngáp… mình giãn cơ chút nha.';

  @override
  String get notif4Title => 'Giờ nghỉ 60 giây!';

  @override
  String get notif4Body => 'Xoay vai, hít sâu, rồi làm tiếp.';

  @override
  String get notif5Title => 'Mắt cần nghỉ 👀';

  @override
  String get notif5Body => 'Nhìn ra xa 20 giây, Upa đếm cho.';

  @override
  String get notif6Title => 'Upa đợi bạn nè';

  @override
  String get notif6Body => 'Một bài nhỏ thôi, ngồi tại chỗ cũng làm được.';

  @override
  String get notifTestTitle => 'Upa chào bạn 👋';

  @override
  String get notifTestBody =>
      'Thông báo hoạt động tốt. Chạm để thử một bài giãn cơ.';

  @override
  String get notifTestScheduledTitle => 'Upa nhắc thử ⏰';

  @override
  String get notifTestScheduledBody =>
      'Lời nhắc hẹn giờ hoạt động tốt. Chạm để giãn cơ.';

  @override
  String get notifSnoozeTitle => 'Upa nhắc lại nè ⏰';

  @override
  String notifSnoozeBody(int minutes) {
    return 'Đã $minutes phút rồi, đứng dậy duỗi người 1 phút nhé.';
  }

  @override
  String get exNeckTiltName => 'Nghiêng cổ';

  @override
  String get exNeckTiltSteps =>
      'Ngồi thẳng, thả lỏng hai vai.\nNghiêng tai phải về phía vai phải, giữ 10 giây.\nVề giữa, nghiêng sang trái, giữ 10 giây.\nThở đều, làm chậm, không gây đau.';

  @override
  String get exChinTuckName => 'Thu cằm';

  @override
  String get exChinTuckSteps =>
      'Ngồi thẳng, mắt nhìn về phía trước.\nKéo cằm lùi ra sau như đang tạo cằm đôi.\nGiữ 5 giây rồi thả lỏng.\nLặp lại khoảng 5 lần.';

  @override
  String get exNeckTurnName => 'Quay cổ trái phải';

  @override
  String get exNeckTurnSteps =>
      'Từ từ quay đầu sang phải, giữ 5 giây.\nQuay về giữa.\nQuay sang trái, giữ 5 giây.\nChỉ quay trái phải, không xoay tròn cả vòng.';

  @override
  String get exShoulderRollName => 'Xoay vai';

  @override
  String get exShoulderRollSteps =>
      'Nhún hai vai lên gần tai.\nĐưa vai ra sau rồi hạ xuống.\nXoay 5 vòng ra sau.\nĐổi chiều, xoay 5 vòng ra trước.';

  @override
  String get exShoulderShrugName => 'Nhún vai thả lỏng';

  @override
  String get exShoulderShrugSteps =>
      'Hít vào, nhún hai vai lên cao.\nGiữ 3 giây.\nThở ra, thả vai rơi xuống thật thả lỏng.\nLặp lại khoảng 6 lần.';

  @override
  String get exChestOpenName => 'Mở ngực';

  @override
  String get exChestOpenSteps =>
      'Đan hai bàn tay ra sau lưng.\nKéo hai bả vai lại gần nhau.\nƯỡn nhẹ ngực, mắt nhìn hơi lên.\nGiữ và thở đều.';

  @override
  String get exOverheadReachName => 'Vươn người lên cao';

  @override
  String get exOverheadReachSteps =>
      'Đan hai tay, lật lòng bàn tay lên trên.\nVươn thẳng tay qua đầu.\nKéo dài cột sống, giữ 10 giây.\nThả lỏng rồi lặp lại.';

  @override
  String get exSideBendName => 'Nghiêng người';

  @override
  String get exSideBendSteps =>
      'Giơ tay phải lên cao.\nNghiêng người sang trái, giữ 10 giây.\nĐổi tay, nghiêng sang phải, giữ 10 giây.\nGiữ mông luôn chạm ghế.';

  @override
  String get exSeatedTwistName => 'Vặn mình trên ghế';

  @override
  String get exSeatedTwistSteps =>
      'Ngồi thẳng, hai bàn chân đặt trên sàn.\nXoay thân sang phải, tay trái đặt lên gối phải.\nGiữ 10 giây, thở đều.\nĐổi bên.';

  @override
  String get exCatCowName => 'Cong lưng kiểu mèo';

  @override
  String get exCatCowSteps =>
      'Ngồi mép ghế, hai tay đặt lên đùi.\nHít vào: ưỡn ngực, nhìn lên.\nThở ra: cong tròn lưng, cúi đầu.\nLặp lại thật chậm, như một chú mèo.';

  @override
  String get exWristFlexName => 'Giãn cổ tay (ngửa)';

  @override
  String get exWristFlexSteps =>
      'Duỗi tay phải ra trước, lòng bàn tay ngửa.\nTay trái kéo nhẹ các ngón tay xuống.\nGiữ 10 giây rồi đổi tay.\nKéo nhẹ nhàng, không kéo mạnh.';

  @override
  String get exWristExtName => 'Giãn cổ tay (úp)';

  @override
  String get exWristExtSteps =>
      'Duỗi tay ra trước, lòng bàn tay úp.\nTay kia ấn nhẹ mu bàn tay xuống.\nGiữ 10 giây rồi đổi tay.\nThả lỏng các ngón tay.';

  @override
  String get exFistSpreadName => 'Nắm – xòe tay';

  @override
  String get exFistSpreadSteps =>
      'Nắm chặt hai bàn tay.\nXòe rộng hết cỡ các ngón.\nLặp lại khoảng 10 lần.\nXoay cổ tay vài vòng mỗi chiều.';

  @override
  String get exEye2020Name => 'Nhìn xa 20 giây';

  @override
  String get exEye2020Steps =>
      'Rời mắt khỏi màn hình.\nNhìn một vật ở xa khoảng 6 mét.\nChớp mắt chậm vài lần.\nThả lỏng cơ mặt.';

  @override
  String get exEyePalmingName => 'Úp tay nghỉ mắt';

  @override
  String get exEyePalmingSteps =>
      'Xoa hai lòng bàn tay cho ấm.\nÚp nhẹ lên mắt, không ấn vào mắt.\nHít thở chậm trong bóng tối.\nBỏ tay ra, mở mắt từ từ.';

  @override
  String get exCalfRaiseName => 'Kiễng gót';

  @override
  String get exCalfRaiseSteps =>
      'Đứng dậy, vịn nhẹ vào bàn.\nKiễng gót lên cao, giữ 2 giây.\nHạ gót xuống từ từ.\nLặp lại khoảng 12 lần.';

  @override
  String get exAnkleCircleName => 'Xoay cổ chân';

  @override
  String get exAnkleCircleSteps =>
      'Duỗi chân phải, nhấc nhẹ khỏi sàn.\nXoay cổ chân 5 vòng mỗi chiều.\nĐổi sang chân trái.\nNgồi thẳng lưng khi làm.';

  @override
  String get exFigureFourName => 'Giãn hông số 4';

  @override
  String get exFigureFourSteps =>
      'Gác mắt cá chân phải lên gối trái.\nLưng thẳng, nghiêng nhẹ người về trước.\nGiữ khoảng 15 giây.\nĐổi chân.';
}
