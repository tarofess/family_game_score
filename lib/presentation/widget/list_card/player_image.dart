import 'package:family_game_score/main.dart';
import 'package:family_game_score/domain/entity/player.dart';
import 'package:family_game_score/infrastructure/service/file_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PlayerImage extends StatelessWidget {
  final Player player;
  final FileService fileService = getIt<FileService>();

  PlayerImage({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FileImage?>(
      future: fileService.getFileImageFromPath(player.image),
      builder: (context, snapshot) {
        double avatarRadius = 18.r;
        double iconSize = avatarRadius * 2;

        if (snapshot.hasData) {
          return CircleAvatar(
            backgroundImage: snapshot.data!,
            radius: avatarRadius,
          );
        } else {
          return Icon(
            Icons.person,
            color: Colors.blue,
            size: iconSize,
          );
        }
      },
    );
  }
}
