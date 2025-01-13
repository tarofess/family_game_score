import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:family_game_score/domain/entity/player.dart';
import 'package:family_game_score/presentation/widget/list_card/player_image.dart';

class ScoringListCard extends StatelessWidget {
  final List<Player> players;
  final int index;

  const ScoringListCard({
    super.key,
    required this.players,
    required this.index,
  });

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
