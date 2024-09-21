import 'package:family_game_score/main.dart';
import 'package:family_game_score/model/entity/player.dart';
import 'package:family_game_score/service/camera_service.dart';
import 'package:family_game_score/service/navigation_service.dart';
import 'package:family_game_score/view/widget/list_card/player_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScoringListCard extends StatelessWidget {
  final List<Player> players;
  final int index;
  final NavigationService navigationService = getIt<NavigationService>();
  final CameraService cameraService = getIt<CameraService>();

  ScoringListCard({super.key, required this.players, required this.index});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.r,
      margin: EdgeInsets.symmetric(horizontal: 10.r, vertical: 6.r),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 6.r),
        leading: Text('${index + 1}位', style: TextStyle(fontSize: 16.sp)),
        title: Row(
          children: [
            PlayerImage(player: players[index]),
            SizedBox(width: 12.r),
            Expanded(
              child: Text(
                players[index].name,
                style: TextStyle(fontSize: 18.sp),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        trailing: ReorderableDragStartListener(
          index: index,
          child: Icon(Icons.drag_handle, size: 24.r),
        ),
      ),
    );
  }
}
