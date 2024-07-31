import 'package:family_game_score/model/entity/player.dart';
import 'package:family_game_score/service/camera_service.dart';
import 'package:family_game_score/service/dialog_service.dart';
import 'package:family_game_score/service/navigation_service.dart';
import 'package:family_game_score/view/setting_detail_view.dart';
import 'package:family_game_score/view/widget/list_card/player_image.dart';
import 'package:flutter/material.dart';

class PlayerListCard extends StatelessWidget {
  final Player player;
  final NavigationService navigationService;
  final CameraService cameraService;

  const PlayerListCard(
      {super.key,
      required this.player,
      required this.navigationService,
      required this.cameraService});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: PlayerImage(player: player, cameraService: cameraService),
        title: Text(player.name),
        onTap: () => navigationService.push(
          context,
          PlayerDetailView(
            player: player,
            cameraService: CameraService(),
            navigationService: NavigationService(),
            dialogService: DialogService(
              NavigationService(),
            ),
          ),
        ),
      ),
    );
  }
}
