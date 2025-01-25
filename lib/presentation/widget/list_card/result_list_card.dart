import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:family_game_score/domain/entity/player.dart';
import 'package:family_game_score/domain/entity/result.dart';
import 'package:family_game_score/presentation/widget/list_card/player_image.dart';

class ResultListCard extends StatelessWidget {
  final Player player;
  final Result result;

  const ResultListCard({super.key, required this.player, required this.result});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.r,
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
