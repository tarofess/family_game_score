import 'package:family_game_score/model/entity/player.dart';
import 'package:family_game_score/service/camera_service.dart';
import 'package:family_game_score/service/navigation_service.dart';
import 'package:family_game_score/view/widget/list_card/player_image.dart';
import 'package:flutter/material.dart';

class ScoringListCard extends StatelessWidget {
  final List<Player> players;
  final int index;
  final NavigationService navigationService;
  final CameraService cameraService;

  const ScoringListCard(
      {super.key,
      required this.players,
      required this.index,
      required this.navigationService,
      required this.cameraService});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: ListTile(
        leading: Text('${index + 1}位', style: const TextStyle(fontSize: 16)),
        title: Row(
          children: [
            PlayerImage(player: players[index], cameraService: cameraService),
            const SizedBox(width: 12),
            Text(players[index].name, style: const TextStyle(fontSize: 18)),
          ],
        ),
        trailing: ReorderableDragStartListener(
          index: index,
          child: const Icon(Icons.drag_handle),
        ),
      ),
    );
  }
}
