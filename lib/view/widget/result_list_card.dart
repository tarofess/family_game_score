import 'package:family_game_score/model/entity/player.dart';
import 'package:family_game_score/model/entity/result.dart';
import 'package:family_game_score/service/camera_service.dart';
import 'package:flutter/material.dart';

class ResultListCard extends StatelessWidget {
  final Player player;
  final Result result;
  final CameraService cameraService;

  const ResultListCard(
      {super.key,
      required this.player,
      required this.result,
      required this.cameraService});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Text('${result.rank}位', style: const TextStyle(fontSize: 14)),
        title: Row(
          children: [
            FutureBuilder<Image?>(
              future: cameraService.getImageFromPath(player.image),
              builder: (context, snapshot) {
                const double avatarRadius = 18.0;
                const double iconSize = avatarRadius * 2;

                if (snapshot.hasData) {
                  return CircleAvatar(
                    backgroundImage: snapshot.data!.image,
                    radius: avatarRadius,
                  );
                } else {
                  return const Icon(
                    Icons.person,
                    color: Colors.blue,
                    size: iconSize,
                  );
                }
              },
            ),
            const SizedBox(width: 12),
            Text(player.name),
          ],
        ),
        trailing: Text(
          '${result.score}ポイント',
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}
