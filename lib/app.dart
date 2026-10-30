import 'dart:async';

import 'package:flutter/material.dart';

import 'l10n/l10n.dart';
import 'state/app_state.dart';
import 'ui/screens/break_screen.dart';
import 'ui/screens/history_screen.dart';
import 'ui/screens/home_screen.dart';
import 'ui/screens/library_screen.dart';
import 'ui/screens/onboarding_screen.dart';
import 'ui/screens/settings_screen.dart';
import 'ui/theme.dart';

final navigatorKey = GlobalKey<NavigatorState>();

/// Mở phiên giãn cơ từ thông báo (nếu đã qua onboarding).
void openBreakFromNotification(AppState state) {
  final nav = navigatorKey.currentState;
  if (nav == null || !state.settings.onboarded) return;
  openQuickBreak(nav, state);
}

class UpaBreakApp extends StatefulWidget {
  const UpaBreakApp({super.key, required this.state});
  final AppState state;

  @override
  State<UpaBreakApp> createState() => _UpaBreakAppState();
}

class _UpaBreakAppState extends State<UpaBreakApp> with WidgetsBindingObserver {
  Timer? _minuteTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _minuteTimer = Timer.periodic(const Duration(minutes: 1), (_) => widget.state.tick());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _minuteTimer?.cancel();
    super.dispose();
  }

  /// Đổi ngôn ngữ máy khi app đang mở: cập nhật UI + ngôn ngữ thông báo.
  @override
  void didChangeLocales(List<Locale>? locales) => widget.state.refresh();

  @override
  void didChangeAppLifecycleState(AppLifecycleState s) {
    if (s == AppLifecycleState.resumed) widget.state.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return AppScope(
      state: widget.state,
      child: ListenableBuilder(
        listenable: widget.state,
        builder: (context, _) => MaterialApp(
          onGenerateTitle: (context) => context.l10n.appTitle,
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          theme: buildTheme(),
          // Ngôn ngữ: người dùng chọn trong Cài đặt, mặc định theo máy (ngoài vi/en thì tiếng Anh).
          locale: Locale(widget.state.language),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: const _Root(),
        ),
      ),
    );
  }
}

class _Root extends StatelessWidget {
  const _Root();

  @override
  Widget build(BuildContext context) {
    final onboarded = AppScope.of(context).settings.onboarded;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: onboarded ? const MainShell() : const OnboardingScreen(),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _tab = 0;

  static const _screens = [HomeScreen(), LibraryScreen(), HistoryScreen(), SettingsScreen()];

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      body: IndexedStack(index: _tab, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        destinations: [
          NavigationDestination(
              icon: const Icon(Icons.pets_outlined), selectedIcon: const Icon(Icons.pets), label: l.tabToday),
          NavigationDestination(
              icon: const Icon(Icons.self_improvement_outlined),
              selectedIcon: const Icon(Icons.self_improvement),
              label: l.tabLibrary),
          NavigationDestination(
              icon: const Icon(Icons.bar_chart_outlined), selectedIcon: const Icon(Icons.bar_chart), label: l.tabHistory),
          NavigationDestination(
              icon: const Icon(Icons.tune_outlined), selectedIcon: const Icon(Icons.tune), label: l.tabSettings),
        ],
      ),
    );
  }
}
