import 'package:family_game_score/model/repository/database_helper.dart';
import 'package:family_game_score/view/home_view.dart';
import 'package:family_game_score/view/result_history_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:family_game_score/view/setting_view.dart';

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
