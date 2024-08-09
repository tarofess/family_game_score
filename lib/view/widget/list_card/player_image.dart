import 'dart:typed_data';

import 'package:family_game_score/main.dart';
import 'package:family_game_score/model/entity/player.dart';
import 'package:family_game_score/service/file_service.dart';
import 'package:flutter/material.dart';

class PlayerImage extends StatelessWidget {
  final Player player;
  final FileService fileService = getIt<FileService>();

  PlayerImage({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: fileService.getImageFromPath(player.image),
      builder: (context, snapshot) {
        const double avatarRadius = 18.0;
        const double iconSize = avatarRadius * 2;

        if (snapshot.hasData) {
          return CircleAvatar(
            backgroundImage: MemoryImage(snapshot.data!),
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
