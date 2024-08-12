import 'package:family_game_score/main.dart';
import 'package:family_game_score/model/entity/player.dart';
import 'package:family_game_score/service/camera_service.dart';
import 'package:family_game_score/service/dialog_service.dart';
import 'package:family_game_score/service/navigation_service.dart';
import 'package:family_game_score/view/player_setting_detail_view.dart';
import 'package:family_game_score/view/widget/list_card/player_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PlayerListCard extends StatelessWidget {
  final Player player;
  final WidgetRef ref;
  final NavigationService navigationService = getIt<NavigationService>();
  final DialogService dialogService = getIt<DialogService>();
  final CameraService cameraService = getIt<CameraService>();

  PlayerListCard({super.key, required this.player, required this.ref});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: PlayerImage(player: player),
        title: Text(
          player.name,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () => navigationService.push(
          context,
          PlayerSettingDetailView(player: player),
        ),
        onLongPress: () async {
          try {
            await dialogService.showDeletePlayerDialog(context, ref, player);
          } catch (e) {
            if (context.mounted) {
              dialogService.showErrorDialog(context, e.toString());
            }
          }
        },
      ),
    );
  }
}
