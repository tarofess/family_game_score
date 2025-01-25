import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:family_game_score/domain/entity/player.dart';
import 'package:family_game_score/presentation/provider/pick_image_usecase_provider.dart';
import 'package:family_game_score/presentation/provider/save_player_usecase_provider.dart';
import 'package:family_game_score/presentation/provider/take_picture_usecase_provider.dart';
import 'package:family_game_score/presentation/provider/file_image_get_usecase_provider.dart';
import 'package:family_game_score/presentation/dialog/confirmation_dialog.dart';
import 'package:family_game_score/presentation/dialog/error_dialog.dart';
import 'package:family_game_score/presentation/dialog/message_dialog.dart';
import 'package:family_game_score/domain/result.dart';
import 'package:family_game_score/presentation/provider/delete_player_usecase_provider.dart';
import 'package:family_game_score/presentation/provider/get_total_score_usecase_provider.dart';
import 'package:family_game_score/presentation/widget/loading_overlay.dart';

class PlayerSettingDetailPage extends HookConsumerWidget {
  final formKey = GlobalKey<FormState>();
  final Player? player;

  PlayerSettingDetailPage({super.key, required this.player});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameTextEditingController =
        useTextEditingController(text: player?.name ?? '');
    final playerName = useState(nameTextEditingController.text);
    final playerImage = useState<FileImage?>(null);

    useEffect(() {
      void listener() {
        playerName.value = nameTextEditingController.text;
      }

      Future<void> setPlayerImagePath() async {
        if (player != null && player!.image.isNotEmpty) {
          final fileImage = await ref
              .read(fileImageGetUsecaseProvider)
              .execute(player?.image);
          playerImage.value = fileImage;
        }
      }

      try {
        setPlayerImagePath();
      } catch (e) {
        showErrorDialog(context, e.toString());
      }

      nameTextEditingController.addListener(listener);
      return () {
        nameTextEditingController.removeListener(listener);
      };
    }, []);

    return Scaffold(
      appBar: buildAppBar(
        context,
        ref,
        playerImage,
        nameTextEditingController,
        playerName,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 50.h),
              buildImageCircle(context, ref, playerImage),
              SizedBox(height: 60.h),
              buildNameWidget(context, nameTextEditingController),
              SizedBox(height: 60.h),
              buildTotalScoreWidget(context, ref, player),
              player == null ? const SizedBox() : SizedBox(height: 150.h),
              player == null
                  ? const SizedBox()
                  : buildDeletePlayerButton(context, ref, player),
              SizedBox(height: 50.h),
            ],
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar(
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<FileImage?> playerImage,
    TextEditingController nameTextEditingController,
    ValueNotifier<String> playerName,
  ) {
    return AppBar(
      title: Text(player == null ? 'プレイヤーの追加' : 'プレイヤーの詳細'),
      actions: [
        playerName.value.isEmpty && playerImage.value == null
            ? const SizedBox()
            : TextButton(
                child: const Text('保存'),
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    final result = await LoadingOverlay.of(context).during(
                      () => ref.read(savePlayerUsecaseProvider).execute(
                            ref,
                            player,
                            nameTextEditingController.text,
                            playerImage.value,
                          ),
                    );

                    switch (result) {
                      case Success():
                        if (context.mounted) context.pop();
                        break;
                      case Failure(message: final message):
                        if (context.mounted) showErrorDialog(context, message);
                    }
                  }
                },
              ),
      ],
    );
  }

  Widget buildImageCircle(
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<FileImage?> playerImage,
  ) {
    return GestureDetector(
      child: Container(
        width: 240.r,
        height: 240.r,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey,
        ),
        child: playerImage.value != null
            ? ClipOval(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: Image(image: playerImage.value!),
                ),
              )
            : Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 50.r,
              ),
      ),
      onTap: () => showActionSheet(context, ref, playerImage),
    );
  }

  Widget buildNameWidget(
    BuildContext context,
    TextEditingController nameTextEditingController,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 300.r,
          child: Form(
            key: formKey,
            child: TextFormField(
              controller: nameTextEditingController,
              style: Theme.of(context).textTheme.bodyLarge,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '名前を入力してください';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: '名前',
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Colors.green,
                    width: 2.0,
                  ),
                ),
                errorStyle: TextStyle(fontSize: 14.sp),
                labelStyle: TextStyle(
                  fontSize: 20.sp,
                  color: Colors.grey[700],
                ),
                floatingLabelStyle: Theme.of(context).textTheme.bodyMedium,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: Colors.green[200]!,
                    width: 1.0,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildTotalScoreWidget(
    BuildContext context,
    WidgetRef ref,
    Player? player,
  ) {
    final totalScore = ref.read(getTotalScoreUsecaseProvider).execute(player);

    return player == null
        ? const SizedBox()
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '総獲得ポイント数:',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              SizedBox(width: 10.w),
              Text(
                '$totalScore',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          );
  }

  Widget buildDeletePlayerButton(
    BuildContext context,
    WidgetRef ref,
    Player? player,
  ) {
    return ElevatedButton(
      onPressed: () async {
        if (player == null) return;
        final isConfirmed = await showConfimationDialog(
          context: context,
          title: 'プレイヤー：${player.name}を削除しますか？',
          content: '削除すると元に戻せませんが、本当に削除しますか？',
        );

        if (!isConfirmed || !context.mounted) return;

        final result = await LoadingOverlay.of(context).during(
          () => ref.read(deletePlayerUsecaseProvider).execute(player),
        );

        switch (result) {
          case Success():
            if (context.mounted) {
              await showMessageDialog(context, 'プレイヤーの削除が完了しました。');
            }
            if (context.mounted) context.pop();
            break;
          case Failure(message: final message):
            if (context.mounted) showErrorDialog(context, message);
            break;
        }
      },
      child: Text(
        'プレイヤーを削除する',
        style: Theme.of(context)
            .textTheme
            .bodySmall!
            .copyWith(color: Colors.red, fontWeight: FontWeight.bold),
      ),
    );
  }

  void showActionSheet(
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<FileImage?> playerImage,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt, size: 24.r),
              title: Text(
                '写真を撮る',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              onTap: () async {
                final result = await LoadingOverlay.of(context).during(
                  () => ref.read(takePictureUsecaseProvider).execute(context),
                );

                if (result == null) return;

                switch (result) {
                  case Success(value: final path):
                    playerImage.value = FileImage(File(path!));
                    if (context.mounted) context.pop();
                    break;
                  case Failure(message: final message):
                    if (context.mounted) {
                      await showErrorDialog(context, message);
                    }
                    if (context.mounted) context.pop();
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library, size: 24.r),
              title: Text(
                'フォトライブラリから選択',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              onTap: () async {
                final result = await LoadingOverlay.of(context).during(
                  () => ref.read(pickImageUsecaseProvider).execute(context),
                );

                if (result == null) return;

                switch (result) {
                  case Success(value: final path):
                    playerImage.value = FileImage(File(path!));
                    if (context.mounted) context.pop();
                    break;
                  case Failure(message: final message):
                    if (context.mounted) {
                      await showErrorDialog(context, message);
                    }
                    if (context.mounted) context.pop();
                }
              },
            ),
            ListTile(
                leading: Icon(Icons.cancel, size: 24.r),
                title: Text(
                  '削除する',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                onTap: () {
                  playerImage.value = null;
                  context.pop();
                }),
          ],
        );
      },
    );
  }
}
