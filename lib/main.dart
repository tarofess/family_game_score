import 'dart:async';
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'firebase_options.dart';

import 'package:family_game_score/presentation/router/router.dart';
import 'package:family_game_score/infrastructure/repository/database_helper.dart';
import 'package:family_game_score/presentation/theme/theme.dart';
import 'package:family_game_score/presentation/page/error_page.dart';
import 'package:family_game_score/presentation/page/loading_page.dart';

void main() async {
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
            home: LoadingPage(),
          ),
          error: (error, stack) => MaterialApp(
            debugShowCheckedModeBanner: false,
            home: ErrorPage(
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
