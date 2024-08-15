import 'package:family_game_score/main.dart';
import 'package:family_game_score/model/entity/player.dart';
import 'package:family_game_score/service/camera_service.dart';
import 'package:family_game_score/service/dialog_service.dart';
import 'package:family_game_score/service/navigation_service.dart';
import 'package:family_game_score/view/player_setting_detail_view.dart';
import 'package:family_game_score/view/widget/list_card/player_image.dart';
import 'package:family_game_score/view/widget/loading_overlay.dart';
import 'package:family_game_score/viewmodel/provider/player_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PlayerListCard extends HookWidget {
  final Player player;
  final WidgetRef ref;
  final NavigationService navigationService = getIt<NavigationService>();
  final DialogService dialogService = getIt<DialogService>();
  final CameraService cameraService = getIt<CameraService>();

  PlayerListCard({super.key, required this.player, required this.ref});

  @override
  Widget build(BuildContext context) {
    final switchValue = useState(player.status == 1 ? true : false);

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
        trailing: Switch(
          value: switchValue.value,
          activeColor: Colors.green,
          activeTrackColor: Colors.green[100],
          onChanged: (value) async {
            try {
              switchValue.value = value;
              value
                  ? await LoadingOverlay.of(context).during(() => ref
                      .read(playerProvider.notifier)
                      .activatePlayer(player.copyWith(status: 1)))
                  : await LoadingOverlay.of(context).during(() => ref
                      .read(playerProvider.notifier)
                      .deactivatePlayer(player.copyWith(status: 0)));
            } catch (e) {
              switchValue.value = !value;
              if (context.mounted) {
                await dialogService.showErrorDialog(context, e.toString());
              }
            }
          },
        ),
        onTap: () => navigationService.push(
          context,
          PlayerSettingDetailView(player: player),
        ),
      ),
    );
  }
}
