import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:family_game_score/domain/entity/player.dart';
import 'package:family_game_score/domain/entity/result_history.dart';
import 'package:family_game_score/application/state/result_history_notifier.dart';
import 'package:family_game_score/presentation/provider/pick_image_usecase_provider.dart';
import 'package:family_game_score/presentation/provider/save_player_usecase_provider.dart';
import 'package:family_game_score/presentation/provider/take_picture_usecase_provider.dart';
import 'package:family_game_score/presentation/provider/file_image_get_usecase_provider.dart';
import 'package:family_game_score/presentation/dialog/confirmation_dialog.dart';
import 'package:family_game_score/presentation/dialog/error_dialog.dart';
import 'package:family_game_score/presentation/dialog/message_dialog.dart';
import 'package:family_game_score/domain/result.dart';
import 'package:family_game_score/presentation/provider/delete_player_usecase_provider.dart';

class PlayerSettingDetailView extends HookConsumerWidget {
  final formKey = GlobalKey<FormState>();
  final Player? player;

  PlayerSettingDetailView({super.key, required this.player});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameTextEditingController =
        useTextEditingController(text: player?.name ?? '');
    final playerName = useState(nameTextEditingController.text);
    final playerImage = useState<FileImage?>(null);

    useEffect(() {
      Future<void> setPlayerImagePath() async {
        if (player?.image != null && player!.image.isNotEmpty) {
          final fileImage = await ref
              .read(fileImageGetUsecaseProvider)
              .execute(player?.image ?? '');
          playerImage.value = fileImage;
        } else {
          playerImage.value = null;
        }
      }

      void listener() {
        playerName.value = nameTextEditingController.text;
      }

      nameTextEditingController.addListener(listener);
      setPlayerImagePath();
      return () {
        nameTextEditingController.removeListener(listener);
      };
    }, []);

    return Scaffold(
      appBar: buildAppBar(
          context, ref, playerImage, nameTextEditingController, playerName),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 50.r),
              buildImageCircle(context, ref, playerImage),
              SizedBox(height: 60.r),
              buildNameWidget(nameTextEditingController),
              SizedBox(height: 60.r),
              buildTotalScoreWidget(ref, player),
              player == null ? const SizedBox() : SizedBox(height: 150.r),
              player == null
                  ? const SizedBox()
                  : buildDeletePlayerButton(context, ref, player),
              SizedBox(height: 50.r),
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
      toolbarHeight: 56.r,
      title: Text(
        player == null ? 'プレイヤーの追加' : 'プレイヤーの詳細',
        style: TextStyle(fontSize: 20.sp),
      ),
      centerTitle: true,
      actions: [
        playerName.value.isEmpty && playerImage.value == null
            ? const SizedBox()
            : TextButton(
                child: Text('保存', style: TextStyle(fontSize: 14.sp)),
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    final result =
                        await ref.read(savePlayerUsecaseProvider).execute(
                              ref,
                              player,
                              nameTextEditingController.text,
                              playerImage.value,
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

  Widget buildNameWidget(TextEditingController nameTextEditingController) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 300.r,
          child: Form(
            key: formKey,
            child: TextFormField(
              controller: nameTextEditingController,
              style: TextStyle(fontSize: 20.sp),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '名前を入力してください';
                }
                return null;
              },
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Colors.green,
                    width: 2.0,
                  ),
                ),
                errorStyle: TextStyle(
                  fontSize: 14.sp,
                ),
                labelStyle: TextStyle(
                  fontSize: 20.sp,
                  color: Colors.grey[700],
                ),
                labelText: '名前',
                floatingLabelStyle: TextStyle(fontSize: 20.sp),
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

  Widget buildTotalScoreWidget(WidgetRef ref, Player? player) {
    return player == null
        ? const SizedBox()
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('総獲得ポイント数:', style: TextStyle(fontSize: 20.sp)),
              SizedBox(width: 10.r),
              Text(
                '${getTotalScore(ref, player)}',
                style: TextStyle(fontSize: 20.sp),
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
        if (!isConfirmed) return;

        final result =
            await ref.read(deletePlayerUsecaseProvider).execute(player);
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
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
          fontSize: 14.sp,
        ),
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
              title: Text('写真を撮る', style: TextStyle(fontSize: 14.sp)),
              onTap: () async {
                final result =
                    await ref.read(takePictureUsecaseProvider).execute(context);
                if (result == null) return;

                switch (result) {
                  case Success(value: final path):
                    playerImage.value = FileImage(File(path ?? ''));
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
              title: Text('フォトライブラリから選択', style: TextStyle(fontSize: 14.sp)),
              onTap: () async {
                final result =
                    await ref.read(pickImageUsecaseProvider).execute(context);
                if (result == null) return;

                switch (result) {
                  case Success(value: final path):
                    playerImage.value = FileImage(File(path ?? ''));
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
                title: Text('削除する', style: TextStyle(fontSize: 14.sp)),
                onTap: () {
                  playerImage.value = null;
                  context.pop();
                }),
          ],
        );
      },
    );
  }

  int getTotalScore(WidgetRef ref, Player? player) {
    final resultHistories = ref.watch(resultHistoryNotifierProvider).value;

    int totalScore = 0;

    if (player == null) return totalScore;

    for (ResultHistory resultHistory in resultHistories ?? []) {
      if (resultHistory.player.id == player.id) {
        totalScore += resultHistory.result.score;
      }
    }

    return totalScore;
  }
}
