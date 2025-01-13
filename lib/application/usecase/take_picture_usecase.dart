import 'package:family_game_score/application/interface/camera_service.dart';
import 'package:family_game_score/infrastructure/service/permission_handler_service.dart';
import 'package:flutter/material.dart';

class TakePictureUsecase {
  final ICameraService _cameraService;

  TakePictureUsecase(this._cameraService);

  Future<String?> execute(BuildContext context) async {
    try {
      final result = await PermissionHandlerService.requestCameraPermission(
        context,
      );
      if (!result) return null;

      final String? path = await _cameraService.takePicture();
      return path;
    } catch (e) {
      return null;
    }
  }
}
