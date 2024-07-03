import 'package:family_game_score/view/home_view.dart';
import 'package:family_game_score/view/result_history_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:family_game_score/view/setting_view.dart';

void main() {
  const app = MaterialApp(home: MyApp());
  const scope = ProviderScope(child: app);
  runApp(scope);
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Family Game Score'),
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
