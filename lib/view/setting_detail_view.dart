import 'dart:io';

import 'package:family_game_score/model/entity/player.dart';
import 'package:family_game_score/service/camera_service.dart';
import 'package:family_game_score/service/dialog_service.dart';
import 'package:family_game_score/service/navigation_service.dart';
import 'package:family_game_score/viewmodel/setting_detail_viewmodel.dart';
import 'package:family_game_score/viewmodel/provider/player_provider.dart';
import 'package:family_game_score/viewmodel/provider/result_history_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SettingDetailView extends HookConsumerWidget {
  final Player? player;
  final CameraService cameraService;
  final NavigationService navigationService;
  final DialogService dialogService;

  final formKey = GlobalKey<FormState>();

  SettingDetailView(
      {super.key,
      required this.cameraService,
      required this.player,
      required this.dialogService,
      required this.navigationService});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imagePath = useState<String?>(player?.image);
    final nameTextEditingController =
        useTextEditingController(text: player?.name ?? '');
    final playerName = useState(nameTextEditingController.text);

    useEffect(() {
      void listener() {
        playerName.value = nameTextEditingController.text;
      }

      nameTextEditingController.addListener(listener);

      return () {
        nameTextEditingController.removeListener(listener);
      };
    }, [nameTextEditingController]);

    final vm = ref.watch(playerDetailViewmodelProvider);

    return Scaffold(
      appBar: buildAppBar(
          context, ref, imagePath, nameTextEditingController, playerName, vm),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildImageCircle(context, imagePath, vm),
            buildNameWidget(nameTextEditingController),
            buildTotalScoreWidget(vm, player),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar(
      BuildContext context,
      WidgetRef ref,
      ValueNotifier<String?> imagePath,
      TextEditingController nameTextEditingController,
      ValueNotifier<String> playerName,
      PlayerDetailViewmodel vm) {
    return AppBar(
      title: Text(player == null ? 'プレイヤーの追加' : 'プレイヤーの詳細'),
      centerTitle: true,
      actions: [
        vm.isEmptyBothImageAndName(playerName.value, imagePath.value)
            ? const SizedBox()
            : TextButton(
                child: const Text('保存'),
                onPressed: () async {
                  try {
                    if (formKey.currentState!.validate()) {
                      await savePlayer(
                          nameTextEditingController.text, imagePath.value, ref);
                      if (context.mounted) navigationService.pop(context);
                    }
                  } catch (e) {
                    if (context.mounted) {
                      dialogService.showErrorDialog(
                          context, e, NavigationService());
                    }
                  }
                },
              ),
      ],
    );
  }

  Widget buildImageCircle(BuildContext context,
      ValueNotifier<String?> imagePath, PlayerDetailViewmodel vm) {
    return GestureDetector(
      child: Container(
        width: 240,
        height: 240,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey,
          image: DecorationImage(
            image: FileImage(File(imagePath.value ?? '')),
            fit: BoxFit.cover,
          ),
        ),
        child: vm.isImageAlreadySet(imagePath.value)
            ? null
            : const Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 50,
              ),
      ),
      onTap: () async {
        try {
          showActionSheet(context, imagePath);
        } catch (e) {
          if (context.mounted) {
            dialogService.showErrorDialog(context, e, NavigationService());
          }
        }
      },
    );
  }

  Widget buildNameWidget(TextEditingController nameTextEditingController) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 300,
          child: Form(
            key: formKey,
            child: TextFormField(
              controller: nameTextEditingController,
              style: const TextStyle(fontSize: 20),
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
                labelStyle: TextStyle(
                  fontSize: 20,
                  color: Colors.grey[700],
                ),
                labelText: '名前',
                floatingLabelStyle: const TextStyle(fontSize: 20),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: Colors.green[100]!,
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

  Widget buildTotalScoreWidget(PlayerDetailViewmodel vm, Player? player) {
    return player == null
        ? const SizedBox()
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('総獲得ポイント数:', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 10),
              Text(
                '${vm.getTotalScore(player)}',
                style: const TextStyle(fontSize: 20),
              ),
            ],
          );
  }

  Future<void> savePlayer(String name, String? imagePath, WidgetRef ref) async {
    try {
      await saveImage(name, imagePath, ref);
      await saveName(name, imagePath, ref);
      ref.invalidate(resultHistoryProvider);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveImage(String name, String? imagePath, WidgetRef ref) async {
    if (imagePath == null) {
      return;
    }

    if (player?.image == imagePath) {
      return;
    }

    await cameraService.saveImage(File(imagePath));
  }

  Future<void> saveName(String name, String? imagePath, WidgetRef ref) async {
    try {
      if (player == null) {
        await ref
            .read(playerProvider.notifier)
            .addPlayer(name, imagePath ?? '');
      } else {
        await ref
            .read(playerProvider.notifier)
            .updatePlayer(player!.copyWith(name: name, image: imagePath ?? ''));
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> takePicture(ValueNotifier<String?> imagePath) async {
    try {
      final String? path = await cameraService.takePictureAndSave();
      if (path != null) {
        imagePath.value = path;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> pickImageFromGallery(ValueNotifier<String?> imagePath) async {
    try {
      final String? path = await cameraService.pickImageFromGalleryAndSave();
      if (path != null) {
        imagePath.value = path;
      }
    } catch (e) {
      rethrow;
    }
  }

  void showActionSheet(BuildContext context, ValueNotifier<String?> imagePath) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('写真を撮る'),
              onTap: () async {
                await takePicture(imagePath);
                if (context.mounted) navigationService.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('フォトライブラリから選択'),
              onTap: () async {
                await pickImageFromGallery(imagePath);
                if (context.mounted) navigationService.pop(context);
              },
            ),
            ListTile(
                leading: const Icon(Icons.cancel),
                title: const Text('削除する'),
                onTap: () {
                  imagePath.value = null;
                  navigationService.pop(context);
                }),
          ],
        );
      },
    );
  }
}
