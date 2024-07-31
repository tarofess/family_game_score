import 'package:family_game_score/model/entity/player.dart';
import 'package:family_game_score/service/camera_service.dart';
import 'package:flutter/material.dart';

class PlayerImage extends StatelessWidget {
  final Player player;
  final CameraService cameraService;

  const PlayerImage(
      {super.key, required this.player, required this.cameraService});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Image?>(
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
    );
  }
}
