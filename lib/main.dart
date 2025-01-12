import 'dart:async';
import 'dart:ui';

import 'package:family_game_score/infrastructure/repository/database_helper.dart';
import 'package:family_game_score/infrastructure/service/camera_service.dart';
import 'package:family_game_score/infrastructure/service/dialog_service.dart';
import 'package:family_game_score/infrastructure/service/file_service.dart';
import 'package:family_game_score/others/service/navigation_service.dart';
import 'package:family_game_score/others/service/snackbar_service.dart';
import 'package:family_game_score/presentation/theme/theme.dart';
import 'package:family_game_score/presentation/view/home_view.dart';
import 'package:family_game_score/presentation/view/result_history_calendar_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:family_game_score/presentation/view/player_setting_view.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(const ProviderScope(child: MyApp()));
}

final initializationProvider = FutureProvider<void>((ref) async {
  await initializeDateFormatting('ja_JP');
  await setupFirebaseCrashlytics();
  await DatabaseHelper.instance.initDatabase();
});

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initialization = ref.watch(initializationProvider);

    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          theme: createTheme(),
          debugShowCheckedModeBanner: false,
          home: initialization.when(
            data: (_) => const MyTabView(),
            loading: () => const SplashScreen(),
            error: (error, stack) => ErrorScreen(
              error: error,
              retry: () {
                // ignore: unused_result
                ref.refresh(initializationProvider);
              },
            ),
          ),
        );
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

class ErrorScreen extends StatelessWidget {
  final Object? error;
  final VoidCallback retry;

  const ErrorScreen({super.key, this.error, required this.retry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('アプリの初期化に失敗しました'),
            const SizedBox(height: 16),
            if (error != null)
              Text(
                '$error',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: retry,
              child: const Text('リトライ'),
            ),
          ],
        ),
      ),
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
          toolbarHeight: 56.r,
          title: Text('ファミリーゲームスコア', style: TextStyle(fontSize: 20.sp)),
          bottom: TabBar(
            labelStyle: TextStyle(fontSize: 14.sp),
            tabs: const [
              Tab(text: 'ホーム'),
              Tab(text: '過去の成績'),
              Tab(text: 'プレイヤー'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            HomeView(),
            const ResultHistoryCalendarView(),
            PlayerSettingView(),
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

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton(() => NavigationService());
  getIt.registerLazySingleton(() => DialogService());
  getIt.registerLazySingleton(() => SnackbarService());
  getIt.registerLazySingleton(() => CameraService());
  getIt.registerLazySingleton(() => FileService());
}
