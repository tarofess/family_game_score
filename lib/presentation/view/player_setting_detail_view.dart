import 'package:family_game_score/main.dart';
import 'package:family_game_score/domain/entity/player.dart';
import 'package:family_game_score/infrastructure/service/dialog_service.dart';
import 'package:family_game_score/others/service/navigation_service.dart';
import 'package:family_game_score/presentation/widget/loading_overlay.dart';
import 'package:family_game_score/others/viewmodel/player_setting_detail_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PlayerSettingDetailView extends HookConsumerWidget {
  final Player? player;
  final NavigationService navigationService = getIt<NavigationService>();
  final DialogService dialogService = getIt<DialogService>();

  final formKey = GlobalKey<FormState>();

  PlayerSettingDetailView({super.key, required this.player});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(playerDetailViewmodelProvider);
    final nameTextEditingController =
        useTextEditingController(text: player?.name ?? '');
    final playerName = useState(nameTextEditingController.text);
    final playerImage = useState<FileImage?>(null);

    useEffect(() {
      vm.setPlayerImagePath(player, playerImage);

      void listener() {
        playerName.value = nameTextEditingController.text;
      }

      nameTextEditingController.addListener(listener);
      return () {
        nameTextEditingController.removeListener(listener);
      };
    }, []);

    return Scaffold(
      appBar: buildAppBar(
          context, ref, playerImage, nameTextEditingController, playerName, vm),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 50.r),
              buildImageCircle(context, playerImage, vm),
              SizedBox(height: 60.r),
              buildNameWidget(nameTextEditingController, vm),
              SizedBox(height: 60.r),
              buildTotalScoreWidget(vm, player),
              vm.isPlayerNull(player)
                  ? const SizedBox()
                  : SizedBox(height: 150.r),
              vm.isPlayerNull(player)
                  ? const SizedBox()
                  : buildDeletePlayerButton(context, ref, player, vm),
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
      PlayerSettingDetailViewModel vm) {
    return AppBar(
      toolbarHeight: 56.r,
      title: Text(vm.getAppBarTitle(player), style: TextStyle(fontSize: 20.sp)),
      centerTitle: true,
      actions: [
        vm.isEmptyBothImageAndName(playerName.value, playerImage.value)
            ? const SizedBox()
            : TextButton(
                child: Text('保存', style: TextStyle(fontSize: 14.sp)),
                onPressed: () async {
                  try {
                    final isSuccess = await LoadingOverlay.of(context).during(
                      () => vm.savePlayer(
                          formKey,
                          player,
                          nameTextEditingController.text,
                          playerImage.value,
                          ref),
                    );
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
      ValueNotifier<FileImage?> playerImage, PlayerSettingDetailViewModel vm) {
    return GestureDetector(
      child: Container(
        width: 240.r,
        height: 240.r,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey,
        ),
        child: vm.hasAlreadyImage(playerImage.value)
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
      onTap: () => showActionSheet(context, playerImage, vm),
    );
  }

  Widget buildNameWidget(TextEditingController nameTextEditingController,
      PlayerSettingDetailViewModel vm) {
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
              validator: (value) => vm.handleNameValidation(value),
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

  Widget buildTotalScoreWidget(
      PlayerSettingDetailViewModel vm, Player? player) {
    return vm.isPlayerNull(player)
        ? const SizedBox()
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('総獲得ポイント数:', style: TextStyle(fontSize: 20.sp)),
              SizedBox(width: 10.r),
              Text(
                '${vm.getTotalScore(player)}',
                style: TextStyle(fontSize: 20.sp),
              ),
            ],
          );
  }

  Widget buildDeletePlayerButton(BuildContext context, WidgetRef ref,
      Player? player, PlayerSettingDetailViewModel vm) {
    return ElevatedButton(
      onPressed: () async {
        final isSuccess =
            await dialogService.showDeletePlayerDialog(context, ref, player!);
        if (isSuccess) {
          if (context.mounted) {
            await dialogService.showMessageDialog(context, 'プレイヤーの削除が完了しました。');
          }
          if (context.mounted) navigationService.pop(context);
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

  void showActionSheet(BuildContext context,
      ValueNotifier<FileImage?> playerImage, PlayerSettingDetailViewModel vm) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.camera_alt, size: 24.r),
              title: Text('写真を撮る', style: TextStyle(fontSize: 14.sp)),
              onTap: () async {
                try {
                  await vm.handleCameraAction(
                    playerImage,
                    (message) => dialogService.showPermissionDeniedDialog(
                        context, message),
                    (message) =>
                        dialogService.showPermissionPermanentlyDeniedDialog(
                            context, message),
                    () => navigationService.pop(context),
                  );
                } catch (e) {
                  if (context.mounted) {
                    navigationService.pop(context);
                    dialogService.showErrorDialog(context, e);
                  }
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library, size: 24.r),
              title: Text('フォトライブラリから選択', style: TextStyle(fontSize: 14.sp)),
              onTap: () async {
                try {
                  await vm.handleGalleryAction(
                    playerImage,
                    (message) => dialogService.showPermissionDeniedDialog(
                        context, message),
                    (message, action) =>
                        dialogService.showPermissionPermanentlyDeniedDialog(
                            context, message),
                    () => navigationService.pop(context),
                  );
                } catch (e) {
                  if (context.mounted) {
                    navigationService.pop(context);
                    dialogService.showErrorDialog(context, e);
                  }
                }
              },
            ),
            ListTile(
                leading: Icon(Icons.cancel, size: 24.r),
                title: Text('削除する', style: TextStyle(fontSize: 14.sp)),
                onTap: () {
                  vm.deleteImageFromImageCircle(playerImage);
                  navigationService.pop(context);
                }),
          ],
        );
      },
    );
  }
}
