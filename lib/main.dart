import 'package:flutter/material.dart';

import 'app.dart';
import 'data/storage.dart';
import 'services/notification_service.dart';
import 'state/app_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storage = await Storage.open();
  late final AppState state;
  final notifications = NotificationService(onTapBreak: () => openBreakFromNotification(state));
  state = AppState(storage, notifications);
  await notifications.init(state.language);

  runApp(UpaBreakApp(state: state));

  await state.refreshPermission();
  await state.reschedule();
  if (await notifications.launchedFromNotification()) {
    WidgetsBinding.instance.addPostFrameCallback((_) => openBreakFromNotification(state));
  }
}
