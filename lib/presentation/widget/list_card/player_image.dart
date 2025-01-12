import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:family_game_score/domain/entity/player.dart';
import 'package:family_game_score/presentation/provider/file_image_get_usecase_provider.dart';

class PlayerImage extends ConsumerWidget {
  final Player player;

  const PlayerImage({super.key, required this.player});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<FileImage?>(
      future: ref.read(fileImageGetUsecaseProvider).execute(player.image),
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
