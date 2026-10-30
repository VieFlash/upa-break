// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Upa Break';

  @override
  String get tabToday => 'Today';

  @override
  String get tabLibrary => 'Exercises';

  @override
  String get tabHistory => 'Log';

  @override
  String get tabSettings => 'Settings';

  @override
  String get actionContinue => 'Continue';

  @override
  String get actionResume => 'Resume';

  @override
  String get actionBack => 'Back';

  @override
  String get actionDone => 'Done';

  @override
  String get actionPause => 'Pause';

  @override
  String get actionSkip => 'Skip';

  @override
  String get actionEnable => 'Turn on';

  @override
  String get actionRefresh => 'Refresh';

  @override
  String get modeGentle => 'Gentle';

  @override
  String get modeGentleDesc => 'Every 90 minutes, rarely interrupts.';

  @override
  String get modeSmart => 'Smart';

  @override
  String get modeSmartDesc =>
      'About every 60 minutes. Fewer reminders when you\'re on track, earlier ones when you fall behind.';

  @override
  String get modeFocus => 'Diligent';

  @override
  String get modeFocusDesc => 'Every 45 minutes until you reach your goal.';

  @override
  String get areaNeck => 'Neck';

  @override
  String get areaShoulders => 'Shoulders';

  @override
  String get areaBack => 'Back';

  @override
  String get areaWrists => 'Wrists';

  @override
  String get areaEyes => 'Eyes';

  @override
  String get areaLegs => 'Legs';

  @override
  String get weekdayMon => 'Mon';

  @override
  String get weekdayTue => 'Tue';

  @override
  String get weekdayWed => 'Wed';

  @override
  String get weekdayThu => 'Thu';

  @override
  String get weekdayFri => 'Fri';

  @override
  String get weekdaySat => 'Sat';

  @override
  String get weekdaySun => 'Sun';

  @override
  String get moodFresh => 'Upa is wide awake ✨';

  @override
  String moodSlouch(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minutes of sitting, Upa is starting to slouch',
      one: '1 minute of sitting, Upa is starting to slouch',
    );
    return '$_temp0';
  }

  @override
  String get moodSleepy => 'Upa dozed off… time to get up!';

  @override
  String get moodProud => 'Today\'s goal reached! 🎉';

  @override
  String get moodPaused => 'In a meeting, Upa stays quiet 🤫';

  @override
  String get moodOffHours => 'Outside work hours, time to rest';

  @override
  String get moodStretch => 'Let\'s stretch!';

  @override
  String nextReminderToday(String time) {
    return 'Next reminder: $time';
  }

  @override
  String nextReminderTomorrow(String time) {
    return 'Next reminder: $time tomorrow';
  }

  @override
  String nextReminderDate(String time, int day, int month) {
    return 'Next reminder: $time on $day/$month';
  }

  @override
  String get pauseSheetTitle => 'Pause reminders for…';

  @override
  String get pause30m => '30 minutes';

  @override
  String get pause1h => '1 hour';

  @override
  String get pause2h => '2 hours';

  @override
  String get pauseRestOfDay => 'Rest of today';

  @override
  String breaksOfGoal(int goal) {
    String _temp0 = intl.Intl.pluralLogic(
      goal,
      locale: localeName,
      other: ' / $goal breaks',
      one: ' / 1 break',
    );
    return '$_temp0';
  }

  @override
  String pausedUntil(String time) {
    return 'Paused until $time';
  }

  @override
  String get stretchNow => 'Stretch now · 1 min';

  @override
  String get inMeeting => 'In a meeting';

  @override
  String exerciseProgress(int current, int total) {
    return 'Exercise $current/$total';
  }

  @override
  String getReady(int seconds) {
    return 'Get ready… $seconds';
  }

  @override
  String secondsLeft(int seconds) {
    String _temp0 = intl.Intl.pluralLogic(
      seconds,
      locale: localeName,
      other: '$seconds seconds',
      one: '1 second',
    );
    return '$_temp0';
  }

  @override
  String get doneNothing => 'Let\'s stretch next time!';

  @override
  String get doneGreat => 'Great job! Upa feels all stretched out';

  @override
  String fishReward(int fish) {
    return '+$fish 🐟 dried fish';
  }

  @override
  String todayProgress(int count, int goal) {
    return 'Today: $count/$goal';
  }

  @override
  String streakSuffix(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: ' · 🔥 $days days',
      one: ' · 🔥 1 day',
    );
    return '$_temp0';
  }

  @override
  String get goalReachedNote =>
      '🎉 Goal reached! Upa won\'t remind you again until tomorrow.';

  @override
  String get statStreak => 'day streak';

  @override
  String get statFish => 'dried fish';

  @override
  String get statDaysMet => 'days met';

  @override
  String get last7Days => 'Last 7 days';

  @override
  String goalPerDay(int goal) {
    return 'Goal: $goal per day';
  }

  @override
  String get historyEmpty => 'No stretches yet. Upa is waiting!';

  @override
  String get libraryTitle => 'Stretches';

  @override
  String get onbWelcomeTitle => 'Upa gets tired from sitting too';

  @override
  String get onbWelcomeBody =>
      'Upa will remind you to get up and stretch for a minute right at your desk.\nMissed one? No worries, Upa never scolds.';

  @override
  String get workEndBeforeStart => 'End time must be after start time.';

  @override
  String get onbScheduleTitle => 'When do you work?';

  @override
  String get onbScheduleSubtitle =>
      'Upa only reminds you during work hours, never in the evening.';

  @override
  String get sectionWorkHours => 'Work hours';

  @override
  String get workStartEnd => 'Start – end';

  @override
  String get sectionLunch => 'Lunch break';

  @override
  String get noRemindLunch => 'No reminders during lunch';

  @override
  String get lunchTime => 'Lunch time';

  @override
  String get sectionWorkDays => 'Work days';

  @override
  String get onbStyleTitle => 'How should Upa remind you?';

  @override
  String get sectionFocusAreas => 'Where do you usually feel stiff?';

  @override
  String dailyGoalLine(int goal) {
    String _temp0 = intl.Intl.pluralLogic(
      goal,
      locale: localeName,
      other: 'Goal: $goal stretch breaks a day.',
      one: 'Goal: 1 stretch break a day.',
    );
    return '$_temp0';
  }

  @override
  String get onbPermissionTitle => 'Can Upa remind you?';

  @override
  String get onbPermissionBody =>
      'Upa only rings the bell during work hours, after you\'ve been sitting a while - no spam, no ads.\nNext, your phone will ask for permission to send notifications.';

  @override
  String get onbPermissionNote =>
      'It\'s fine to say no - you can still use the app and turn it on later in Settings.';

  @override
  String get allowReminders => 'Let Upa remind me';

  @override
  String get sectionReminderStyle => 'Reminder style';

  @override
  String get sectionAreas => 'Stiff areas';

  @override
  String currentGoal(int goal) {
    return 'Current goal: $goal per day';
  }

  @override
  String get sectionNotifications => 'Notifications';

  @override
  String get notifOn => 'Notifications are on';

  @override
  String get notifOff => 'Notifications are off';

  @override
  String get notifOnSub => 'Upa will remind you during work hours';

  @override
  String get notifOffSub => 'Upa can\'t remind you until you turn them back on';

  @override
  String get sendTestNotification => 'Send a test notification';

  @override
  String get sendTestNotificationSub =>
      'Check that reminders show up on your phone';

  @override
  String get sectionOnTime => 'On-time reminders';

  @override
  String get batteryIntro =>
      'Not getting reminders? Your phone may be blocking Upa in the background.';

  @override
  String onBrand(String brand) {
    return 'On $brand:';
  }

  @override
  String get disableBatteryOpt => 'Disable battery optimization';

  @override
  String get appSettings => 'App settings';

  @override
  String get disclaimer =>
      'Upa Break is a habit app, not medical advice. If pain persists, see a doctor or physical therapist.';

  @override
  String get sectionLanguage => 'Language';

  @override
  String get languageSystem => 'System default';

  @override
  String get languageVi => 'Tiếng Việt';

  @override
  String get languageEn => 'English';

  @override
  String get guideXiaomi =>
      'Open Upa Break\'s app settings.\nBattery saver → choose \"No restrictions\".\nTurn on \"Autostart\".\nIn recent apps, long-press Upa Break → tap the lock icon so it isn\'t cleared.';

  @override
  String get guideOppo =>
      'Open Upa Break\'s app settings.\nBattery usage → turn on \"Allow background activity\" and \"Allow auto launch\".\nIn recent apps, long-press Upa Break → \"Lock\" so it isn\'t cleared.';

  @override
  String get guideVivo =>
      'Settings → Battery → High background power consumption → turn on for Upa Break.\ni Manager → App manager → Autostart → turn on Upa Break.\nIn recent apps, pull Upa Break down to lock it.';

  @override
  String get guideSamsung =>
      'Open Upa Break\'s app settings → Battery → choose \"Unrestricted\".\nSettings → Device care → Battery → Background usage limits: make sure Upa Break isn\'t in \"Sleeping apps\" or \"Deep sleeping apps\".';

  @override
  String get guideOther =>
      'Tap \"Disable battery optimization\" below → find Upa Break → choose \"Don\'t optimize\".\nIf your phone has \"Autostart\" or \"Run in background\", turn it on for Upa Break.';

  @override
  String get bannerTitle => 'Upa isn\'t allowed to remind you';

  @override
  String get bannerBody =>
      'Turn on notifications so Upa can remind you to get up on time. No worries if not - you can still stretch on your own.';

  @override
  String get enableNotifications => 'Turn on notifications';

  @override
  String get debugTitle => 'Notification debug';

  @override
  String get debugStatus => 'Status';

  @override
  String debugError(String error) {
    return 'Error: $error';
  }

  @override
  String get debugPermission => 'Notification permission';

  @override
  String get permAllowed => 'Allowed';

  @override
  String get permDenied => 'Denied / off';

  @override
  String get permUnknown => 'Unknown';

  @override
  String get debugNow => 'Now';

  @override
  String get debugTestIn1Min => 'Test reminder in 1 minute';

  @override
  String get debugReschedule => 'Reschedule';

  @override
  String debugPlanned(int count) {
    return 'Planned reminders ($count)';
  }

  @override
  String get debugPlannedEmpty => 'None (goal reached / outside work hours?)';

  @override
  String debugPending(int count) {
    return 'Pending in the system ($count)';
  }

  @override
  String get debugPendingEmpty => 'No pending notifications';

  @override
  String debugScheduledAt(String time) {
    return 'Scheduled for $time. You can close the app to test (Android may be a few minutes late).';
  }

  @override
  String get notifChannelName => 'Stretch reminders';

  @override
  String get notifChannelDesc =>
      'Reminders to get up and stretch during work hours';

  @override
  String get notifActionStart => 'Start';

  @override
  String notifActionSnooze(int minutes) {
    return 'Later ($minutes min)';
  }

  @override
  String get notif1Title => 'Upa is slouching';

  @override
  String get notif1Body => 'Get up and stretch with me for a minute.';

  @override
  String get notif2Title => 'Stiff neck yet?';

  @override
  String get notif2Body => 'A few gentle neck tilts will help right away.';

  @override
  String get notif3Title => 'You\'ve been sitting a while';

  @override
  String get notif3Body => 'Upa is starting to yawn… time for a quick stretch.';

  @override
  String get notif4Title => '60-second break!';

  @override
  String get notif4Body =>
      'Roll your shoulders, breathe deep, then back to it.';

  @override
  String get notif5Title => 'Eyes need a rest 👀';

  @override
  String get notif5Body => 'Look far away for 20 seconds, Upa will count.';

  @override
  String get notif6Title => 'Upa is waiting for you';

  @override
  String get notif6Body =>
      'Just one small exercise, you can even do it seated.';

  @override
  String get notifTestTitle => 'Hi from Upa 👋';

  @override
  String get notifTestBody => 'Notifications work. Tap to try a stretch.';

  @override
  String get notifTestScheduledTitle => 'Upa test reminder ⏰';

  @override
  String get notifTestScheduledBody =>
      'Scheduled reminders work. Tap to stretch.';

  @override
  String get notifSnoozeTitle => 'Upa again ⏰';

  @override
  String notifSnoozeBody(int minutes) {
    return 'It\'s been $minutes minutes - get up and stretch for a minute.';
  }

  @override
  String get exNeckTiltName => 'Neck tilt';

  @override
  String get exNeckTiltSteps =>
      'Sit up straight, relax your shoulders.\nTilt your right ear toward your right shoulder, hold 10 seconds.\nBack to center, tilt to the left, hold 10 seconds.\nBreathe evenly, go slowly, never into pain.';

  @override
  String get exChinTuckName => 'Chin tuck';

  @override
  String get exChinTuckSteps =>
      'Sit up straight, eyes looking forward.\nDraw your chin straight back, like making a double chin.\nHold 5 seconds, then relax.\nRepeat about 5 times.';

  @override
  String get exNeckTurnName => 'Neck turn';

  @override
  String get exNeckTurnSteps =>
      'Slowly turn your head to the right, hold 5 seconds.\nBack to center.\nTurn to the left, hold 5 seconds.\nOnly turn left and right, no full circles.';

  @override
  String get exShoulderRollName => 'Shoulder rolls';

  @override
  String get exShoulderRollSteps =>
      'Shrug both shoulders up toward your ears.\nMove them back, then down.\nRoll backward 5 times.\nSwitch direction, roll forward 5 times.';

  @override
  String get exShoulderShrugName => 'Shrug and release';

  @override
  String get exShoulderShrugSteps =>
      'Breathe in, shrug both shoulders up high.\nHold 3 seconds.\nBreathe out, let your shoulders drop and relax.\nRepeat about 6 times.';

  @override
  String get exChestOpenName => 'Chest opener';

  @override
  String get exChestOpenSteps =>
      'Clasp your hands behind your back.\nSqueeze your shoulder blades together.\nLift your chest gently, look slightly up.\nHold and breathe evenly.';

  @override
  String get exOverheadReachName => 'Overhead reach';

  @override
  String get exOverheadReachSteps =>
      'Interlace your fingers, palms facing up.\nReach straight up over your head.\nLengthen your spine, hold 10 seconds.\nRelax, then repeat.';

  @override
  String get exSideBendName => 'Side bend';

  @override
  String get exSideBendSteps =>
      'Raise your right arm up high.\nLean to the left, hold 10 seconds.\nSwitch arms, lean to the right, hold 10 seconds.\nKeep your hips on the chair.';

  @override
  String get exSeatedTwistName => 'Seated twist';

  @override
  String get exSeatedTwistSteps =>
      'Sit up straight, feet flat on the floor.\nTwist to the right, left hand on your right knee.\nHold 10 seconds, breathing evenly.\nSwitch sides.';

  @override
  String get exCatCowName => 'Seated cat-cow';

  @override
  String get exCatCowSteps =>
      'Sit at the edge of your chair, hands on your thighs.\nBreathe in: open your chest, look up.\nBreathe out: round your back, drop your head.\nRepeat slowly, like a cat.';

  @override
  String get exWristFlexName => 'Wrist stretch (palm up)';

  @override
  String get exWristFlexSteps =>
      'Extend your right arm, palm facing up.\nWith your left hand, gently pull your fingers down.\nHold 10 seconds, then switch hands.\nPull gently, never hard.';

  @override
  String get exWristExtName => 'Wrist stretch (palm down)';

  @override
  String get exWristExtSteps =>
      'Extend your arm, palm facing down.\nWith the other hand, gently press the back of your hand down.\nHold 10 seconds, then switch hands.\nRelax your fingers.';

  @override
  String get exFistSpreadName => 'Fist and spread';

  @override
  String get exFistSpreadSteps =>
      'Make tight fists with both hands.\nSpread your fingers as wide as you can.\nRepeat about 10 times.\nRoll your wrists a few times each way.';

  @override
  String get exEye2020Name => 'Look far for 20 seconds';

  @override
  String get exEye2020Steps =>
      'Look away from the screen.\nFocus on something about 6 meters away.\nBlink slowly a few times.\nRelax your face.';

  @override
  String get exEyePalmingName => 'Palming';

  @override
  String get exEyePalmingSteps =>
      'Rub your palms together until warm.\nCup them gently over your eyes, without pressing.\nBreathe slowly in the dark.\nRemove your hands, open your eyes slowly.';

  @override
  String get exCalfRaiseName => 'Calf raises';

  @override
  String get exCalfRaiseSteps =>
      'Stand up, lightly holding the desk.\nRise onto your toes, hold 2 seconds.\nLower your heels slowly.\nRepeat about 12 times.';

  @override
  String get exAnkleCircleName => 'Ankle circles';

  @override
  String get exAnkleCircleSteps =>
      'Extend your right leg, lift it slightly off the floor.\nCircle your ankle 5 times each way.\nSwitch to your left leg.\nKeep your back straight.';

  @override
  String get exFigureFourName => 'Figure-four stretch';

  @override
  String get exFigureFourSteps =>
      'Rest your right ankle on your left knee.\nKeep your back straight, lean forward slightly.\nHold about 15 seconds.\nSwitch legs.';
}
