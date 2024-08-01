import 'package:family_game_score/main.dart';
import 'package:family_game_score/model/entity/player.dart';
import 'package:family_game_score/model/entity/result.dart';
import 'package:family_game_score/service/camera_service.dart';
import 'package:family_game_score/view/widget/list_card/player_image.dart';
import 'package:flutter/material.dart';

class ResultListCard extends StatelessWidget {
  final Player player;
  final Result result;
  final CameraService cameraService = getIt<CameraService>();

  ResultListCard({super.key, required this.player, required this.result});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Text('${result.rank}位', style: const TextStyle(fontSize: 14)),
        title: Row(
          children: [
            PlayerImage(player: player),
            const SizedBox(width: 12),
            Text(player.name),
          ],
        ),
        trailing: Text(
          '${result.score}ポイント',
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}
