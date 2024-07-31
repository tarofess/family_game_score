import 'dart:async';
import 'dart:ui';

import 'package:family_game_score/model/repository/database_helper.dart';
import 'package:family_game_score/service/dialog_service.dart';
import 'package:family_game_score/service/navigation_service.dart';
import 'package:family_game_score/service/snackbar_service.dart';
import 'package:family_game_score/view/home_view.dart';
import 'package:family_game_score/view/result_history_calendar_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:family_game_score/view/setting_view.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.initDatabase();
  await initializeDateFormatting('ja_JP');
  await setupFirebaseCrashlytics();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const MaterialApp(
      home: MyTabView(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyTabView extends StatelessWidget {
  const MyTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('ファミリーゲームスコア'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'ホーム'),
              Tab(text: '過去の成績'),
              Tab(text: '設定'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            HomeView(
              navigationService: NavigationService(),
              snackbarService: SnackbarService(),
            ),
            ResultHistoryCalendarView(
              navigationService: NavigationService(),
            ),
            SettingView(
              navigationService: NavigationService(),
              dialogService: DialogService(
                NavigationService(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> setupFirebaseCrashlytics() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
}
