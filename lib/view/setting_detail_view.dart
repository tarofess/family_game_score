import 'dart:io';

import 'package:family_game_score/main.dart';
import 'package:family_game_score/model/entity/player.dart';
import 'package:family_game_score/service/dialog_service.dart';
import 'package:family_game_score/service/navigation_service.dart';
import 'package:family_game_score/viewmodel/setting_detail_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SettingDetailView extends HookConsumerWidget {
  final Player? player;
  final NavigationService navigationService = getIt<NavigationService>();
  final DialogService dialogService = getIt<DialogService>();

  final formKey = GlobalKey<FormState>();

  SettingDetailView({super.key, required this.player});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(playerDetailViewmodelProvider);
    final nameTextEditingController =
        useTextEditingController(text: player?.name ?? '');
    final playerName = useState(nameTextEditingController.text);
    final playerImage = useState<FileImage?>(
      player?.image != null && player!.image.isNotEmpty
          ? FileImage(File(player!.image))
          : null,
    );

    useEffect(() {
      void listener() {
        playerName.value = nameTextEditingController.text;
      }

      nameTextEditingController.addListener(listener);

      return () {
        nameTextEditingController.removeListener(listener);
      };
    }, [nameTextEditingController]);

    return Scaffold(
      appBar: buildAppBar(
          context, ref, playerImage, nameTextEditingController, playerName, vm),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildImageCircle(context, playerImage, vm),
            buildNameWidget(nameTextEditingController, vm),
            buildTotalScoreWidget(vm, player),
          ],
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
      SettingDetailViewModel vm) {
    return AppBar(
      title: Text(player == null ? 'プレイヤーの追加' : 'プレイヤーの詳細'),
      centerTitle: true,
      actions: [
        vm.isEmptyBothImageAndName(playerName.value, playerImage.value)
            ? const SizedBox()
            : TextButton(
                child: const Text('保存'),
                onPressed: () async {
                  try {
                    final isSuccess = await vm.savePlayer(formKey, player,
                        nameTextEditingController.text, playerImage.value, ref);
                    if (isSuccess && context.mounted) {
                      navigationService.pop(context);
                    }
                  } catch (e) {
                    if (context.mounted) {
                      dialogService.showErrorDialog(context, e);
                    }
                  }
                },
              ),
      ],
    );
  }

  Widget buildImageCircle(BuildContext context,
      ValueNotifier<FileImage?> playerImage, SettingDetailViewModel vm) {
    return GestureDetector(
      child: Container(
        width: 240,
        height: 240,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey,
        ),
        child: FutureBuilder<Image?>(
          future: vm.hasAlreadyImage(playerImage.value)
              ? vm.cameraService.getImageFromPath(playerImage.value!.file.path)
              : Future.value(null),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasData && snapshot.data != null) {
              return ClipOval(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: snapshot.data!,
                ),
              );
            } else {
              return const Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 50,
              );
            }
          },
        ),
      ),
      onTap: () => showActionSheet(context, playerImage, vm),
    );
  }

  Widget buildNameWidget(TextEditingController nameTextEditingController,
      SettingDetailViewModel vm) {
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
              validator: (value) => vm.handleNameValidation(value),
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

  Widget buildTotalScoreWidget(SettingDetailViewModel vm, Player? player) {
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

  void showActionSheet(BuildContext context,
      ValueNotifier<FileImage?> playerImage, SettingDetailViewModel vm) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('写真を撮る'),
              onTap: () async {
                try {
                  await vm.takePicture(playerImage);
                  if (context.mounted) navigationService.pop(context);
                } catch (e) {
                  if (context.mounted) {
                    navigationService.pop(context);
                    await dialogService.showErrorDialog(context, e);
                  }
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('フォトライブラリから選択'),
              onTap: () async {
                try {
                  await vm.pickImageFromGallery(playerImage);
                  if (context.mounted) navigationService.pop(context);
                } catch (e) {
                  if (context.mounted) {
                    navigationService.pop(context);
                    dialogService.showErrorDialog(context, e);
                  }
                }
              },
            ),
            ListTile(
                leading: const Icon(Icons.cancel),
                title: const Text('削除する'),
                onTap: () {
                  vm.deleteImage(playerImage);
                  navigationService.pop(context);
                }),
          ],
        );
      },
    );
  }
}
