import 'package:flutter/widgets.dart';

import '../logic/battery_guide.dart';
import '../models/settings.dart';
import 'app_localizations.dart';

export 'app_localizations.dart';

/// `context.l10n.xxx` thay cho `AppLocalizations.of(context).xxx`.
extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

/// Chuỗi đã dịch cho một mã ngôn ngữ, dùng ở nơi không có BuildContext (thông báo, isolate nền).
AppLocalizations l10nFor(String language) => lookupAppLocalizations(Locale(language));

/// Ánh xạ enum / id sang chuỗi đã dịch (gen-l10n không tra key động được).
extension L10nLookup on AppLocalizations {
  String modeLabel(ReminderMode m) => switch (m) {
        ReminderMode.gentle => modeGentle,
        ReminderMode.smart => modeSmart,
        ReminderMode.focus => modeFocus,
      };

  String modeDescription(ReminderMode m) => switch (m) {
        ReminderMode.gentle => modeGentleDesc,
        ReminderMode.smart => modeSmartDesc,
        ReminderMode.focus => modeFocusDesc,
      };

  String areaLabel(BodyArea a) => switch (a) {
        BodyArea.neck => areaNeck,
        BodyArea.shoulders => areaShoulders,
        BodyArea.back => areaBack,
        BodyArea.wrists => areaWrists,
        BodyArea.eyes => areaEyes,
        BodyArea.legs => areaLegs,
      };

  /// Thứ viết tắt theo `DateTime.weekday` (1 = thứ 2 … 7 = chủ nhật).
  String weekdayShort(int weekday) => switch (weekday) {
        1 => weekdayMon,
        2 => weekdayTue,
        3 => weekdayWed,
        4 => weekdayThu,
        5 => weekdayFri,
        6 => weekdaySat,
        _ => weekdaySun,
      };

  String exerciseName(String id) => switch (id) {
        'neck_tilt' => exNeckTiltName,
        'chin_tuck' => exChinTuckName,
        'neck_turn' => exNeckTurnName,
        'shoulder_roll' => exShoulderRollName,
        'shoulder_shrug' => exShoulderShrugName,
        'chest_open' => exChestOpenName,
        'overhead_reach' => exOverheadReachName,
        'side_bend' => exSideBendName,
        'seated_twist' => exSeatedTwistName,
        'cat_cow' => exCatCowName,
        'wrist_flex' => exWristFlexName,
        'wrist_ext' => exWristExtName,
        'fist_spread' => exFistSpreadName,
        'eye_2020' => exEye2020Name,
        'eye_palming' => exEyePalmingName,
        'calf_raise' => exCalfRaiseName,
        'ankle_circle' => exAnkleCircleName,
        'figure_four' => exFigureFourName,
        _ => id,
      };

  /// Các bước của bài tập (trong ARB mỗi bước là một dòng).
  List<String> exerciseSteps(String id) => switch (id) {
        'neck_tilt' => exNeckTiltSteps,
        'chin_tuck' => exChinTuckSteps,
        'neck_turn' => exNeckTurnSteps,
        'shoulder_roll' => exShoulderRollSteps,
        'shoulder_shrug' => exShoulderShrugSteps,
        'chest_open' => exChestOpenSteps,
        'overhead_reach' => exOverheadReachSteps,
        'side_bend' => exSideBendSteps,
        'seated_twist' => exSeatedTwistSteps,
        'cat_cow' => exCatCowSteps,
        'wrist_flex' => exWristFlexSteps,
        'wrist_ext' => exWristExtSteps,
        'fist_spread' => exFistSpreadSteps,
        'eye_2020' => exEye2020Steps,
        'eye_palming' => exEyePalmingSteps,
        'calf_raise' => exCalfRaiseSteps,
        'ankle_circle' => exAnkleCircleSteps,
        'figure_four' => exFigureFourSteps,
        _ => '',
      }
          .split('\n');

  List<String> batteryGuide(OemBrand b) => switch (b) {
        OemBrand.xiaomi => guideXiaomi,
        OemBrand.oppo => guideOppo,
        OemBrand.vivo => guideVivo,
        OemBrand.samsung => guideSamsung,
        OemBrand.other => guideOther,
      }
          .split('\n');

  /// Lời nhắc theo giọng Upa (tiêu đề, nội dung), xoay vòng khi lên lịch.
  List<(String, String)> get reminderMessages => [
        (notif1Title, notif1Body),
        (notif2Title, notif2Body),
        (notif3Title, notif3Body),
        (notif4Title, notif4Body),
        (notif5Title, notif5Body),
        (notif6Title, notif6Body),
      ];
}
