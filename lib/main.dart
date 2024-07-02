import 'package:family_game_score/provider/player_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:family_game_score/view/tab_view.dart';
import 'package:family_game_score/view/setting_view.dart';

void main() {
  const app = MaterialApp(home: MyApp());
  const scope = ProviderScope(child: app);
  runApp(scope);
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(playerProvider);

    return Scaffold(
        body: Center(
      child: player.when(
          data: (data) {
            if (data.isEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingView()),
                );
              });
            } else {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const TabView()),
                );
              });
            }
          },
          error: (error, _) => const Text('エラーが発生しました'),
          loading: () => const Center(child: CircularProgressIndicator())),
    ));
  }
}
