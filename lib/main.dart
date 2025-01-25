import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:family_game_score/presentation/router/router.dart';
import 'package:family_game_score/presentation/theme/light_mode.dart';
import 'package:family_game_score/presentation/theme/dark_mode.dart';
import 'package:family_game_score/presentation/page/error_page.dart';
import 'package:family_game_score/presentation/page/loading_page.dart';
import 'package:family_game_score/presentation/provider/initialization_provider.dart';

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
            theme: createLightMode(),
            darkTheme: createDarkMode(),
            themeMode: ThemeMode.system,
            routerConfig: ref.watch(routerProvider),
            debugShowCheckedModeBanner: false,
          ),
          loading: () => MaterialApp(
            theme: createLightMode(),
            darkTheme: createDarkMode(),
            debugShowCheckedModeBanner: false,
            home: const LoadingPage(),
          ),
          error: (error, stack) => MaterialApp(
            theme: createLightMode(),
            darkTheme: createDarkMode(),
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
