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
      elevation: 2.r,
      margin: EdgeInsets.symmetric(horizontal: 10.r, vertical: 6.r),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 6.r),
        leading: Text(
          '${index + 1}位',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        title: Row(
          children: [
            PlayerImage(player: players[index]),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                players[index].name,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontSize: 18.sp),
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
