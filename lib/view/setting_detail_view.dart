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

    return Scaffold(
      appBar: buildAppBar(
          context, ref, imagePath, nameTextEditingController, playerName, vm),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildImageCircle(context, imagePath, vm),
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
      ValueNotifier<String?> imagePath,
      TextEditingController nameTextEditingController,
      ValueNotifier<String> playerName,
      SettingDetailViewModel vm) {
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
                    final isSuccess = await vm.savePlayer(player, formKey,
                        nameTextEditingController.text, imagePath.value, ref);
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
      ValueNotifier<String?> imagePath, SettingDetailViewModel vm) {
    return GestureDetector(
      child: Container(
        width: 240,
        height: 240,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey,
          image: vm.hasImage(imagePath)
              ? DecorationImage(
                  image: FileImage(File(imagePath.value!)),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: vm.isImageAlreadySet(imagePath.value)
            ? null
            : const Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 50,
              ),
      ),
      onTap: () => showActionSheet(context, imagePath, vm),
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

  void showActionSheet(BuildContext context, ValueNotifier<String?> imagePath,
      SettingDetailViewModel vm) {
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
                  await vm.takePicture(imagePath);
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
                  await vm.pickImageFromGallery(imagePath);
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
                  vm.deleteImage(imagePath);
                  navigationService.pop(context);
                }),
          ],
        );
      },
    );
  }
}
