import 'package:family_game_score/provider/player_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResultHistoryView extends ConsumerWidget {
  const ResultHistoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        body: Container(
      child: Text('ResultHistory'),
    ));
  }
}
