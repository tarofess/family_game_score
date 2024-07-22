import 'package:family_game_score/model/entity/player.dart';
import 'package:family_game_score/model/entity/result.dart';
import 'package:flutter/material.dart';

class ResultCard extends StatelessWidget {
  final Player player;
  final Result result;

  const ResultCard({super.key, required this.player, required this.result});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          leading:
              Text('${result.rank}位', style: const TextStyle(fontSize: 14)),
          title: Text(player.name),
          trailing: Text('${result.score}ポイント',
              style: const TextStyle(fontSize: 14))),
    );
  }
}
