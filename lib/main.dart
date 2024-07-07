import 'package:family_game_score/view/home_view.dart';
import 'package:family_game_score/view/result_history_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:family_game_score/view/setting_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const MaterialApp(
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('ja', ''),
        Locale('en', ''),
      ],
      home: MyTabView(),
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
          title: const Text('Family Game Score'),
          bottom: TabBar(
            tabs: [
              Tab(text: AppLocalizations.of(context)!.home),
              Tab(text: AppLocalizations.of(context)!.resultHistory),
              Tab(text: AppLocalizations.of(context)!.setting),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            HomeView(),
            ResultHistoryView(),
            SettingView(),
          ],
        ),
      ),
    );
  }
}
