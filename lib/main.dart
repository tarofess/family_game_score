import 'dart:async';
import 'dart:ui';
import 'package:family_game_score/presentation/router/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'firebase_options.dart';

import 'package:family_game_score/infrastructure/repository/database_helper.dart';
import 'package:family_game_score/infrastructure/service/camera_service.dart';
import 'package:family_game_score/infrastructure/service/dialog_service.dart';
import 'package:family_game_score/infrastructure/service/file_service.dart';
import 'package:family_game_score/others/service/snackbar_service.dart';
import 'package:family_game_score/presentation/theme/theme.dart';
import 'package:family_game_score/presentation/view/error_view.dart';
import 'package:family_game_score/presentation/view/loading_view.dart';

void main() async {
  setupLocator();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initializeApp = ref.watch(initializationProvider);

    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return initializeApp.when(
          data: (_) => MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: createDefaultTheme(),
            routerConfig: ref.watch(routerProvider),
          ),
          loading: () => const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: LoadingView(),
          ),
          error: (error, stack) => MaterialApp(
            debugShowCheckedModeBanner: false,
            home: ErrorView(
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

final initializationProvider = FutureProvider<void>((ref) async {
  await initializeDateFormatting('ja_JP');
  await setupFirebaseCrashlytics();
  await DatabaseHelper.instance.initDatabase();
});

Future<void> setupFirebaseCrashlytics() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
  getIt.registerLazySingleton(() => DialogService());
  getIt.registerLazySingleton(() => SnackbarService());
  getIt.registerLazySingleton(() => CameraService());
  getIt.registerLazySingleton(() => FileService());
}
