import 'package:family_game_score/model/repository/database_helper.dart';
import 'package:family_game_score/view/home_view.dart';
import 'package:family_game_score/view/result_history_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:family_game_score/view/setting_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.initDatabase();
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
          title: Text(
            AppLocalizations.of(context)!.appTitle,
          ),
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
