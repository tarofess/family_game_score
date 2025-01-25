import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:family_game_score/domain/entity/player.dart';
import 'package:family_game_score/presentation/widget/list_card/player_image.dart';
import 'package:family_game_score/application/state/player_notifier.dart';
import 'package:family_game_score/presentation/dialog/error_dialog.dart';

class PlayerListCard extends HookWidget {
  final Player player;
  final WidgetRef ref;

  const PlayerListCard({super.key, required this.player, required this.ref});

  @override
  Widget build(BuildContext context) {
    final switchValue = useState(player.status == 1 ? true : false);

    return Card(
      elevation: 4.r,
      margin: EdgeInsets.symmetric(horizontal: 10.r, vertical: 6.r),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 10.r),
        leading: PlayerImage(player: player),
        title: Text(
          player.name,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 18.sp),
        ),
        trailing: Switch(
          value: switchValue.value,
          activeColor: Colors.green,
          activeTrackColor: Colors.green[100],
          onChanged: (value) async {
            try {
              switchValue.value = value;
              value
                  ? ref.read(playerNotifierProvider.notifier).activatePlayer(
                        player.copyWith(status: 1),
                      )
                  : ref.read(playerNotifierProvider.notifier).deactivatePlayer(
                        player.copyWith(status: 0),
                      );
            } catch (e) {
              switchValue.value = !value;
              if (context.mounted) {
                await showErrorDialog(context, e.toString());
              }
            }
          },
        ),
        onTap: () => context.push(
          '/player_setting_detail_page',
          extra: {'player': player},
        ),
      ),
    );
  }
}
