import 'package:family_game_score/main.dart';
import 'package:family_game_score/model/entity/player.dart';
import 'package:family_game_score/model/entity/result.dart';
import 'package:family_game_score/service/camera_service.dart';
import 'package:family_game_score/view/widget/list_card/player_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResultListCard extends StatelessWidget {
  final Player player;
  final Result result;
  final CameraService cameraService = getIt<CameraService>();

  ResultListCard({super.key, required this.player, required this.result});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.r,
      margin: EdgeInsets.symmetric(horizontal: 10.r, vertical: 6.r),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 10.r),
        leading: Text('${result.rank}位', style: TextStyle(fontSize: 14.sp)),
        title: Row(
          children: [
            PlayerImage(player: player),
            SizedBox(width: 12.r),
            Expanded(
              child: Text(
                player.name,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 18.sp),
              ),
            ),
          ],
        ),
        trailing: Text(
          '${result.score}ポイント',
          style: TextStyle(fontSize: 14.sp),
        ),
      ),
    );
  }
}
