import 'package:flutter/material.dart';

import 'package:family_game_score/application/interface/camera_service.dart';
import 'package:family_game_score/domain/result.dart';
import 'package:family_game_score/infrastructure/service/permission_handler_service.dart';

class PickImageUsecase {
  final ICameraService _cameraService;

  PickImageUsecase(this._cameraService);

  Future<Result<String>?> execute(BuildContext context) async {
    try {
      final result = await PermissionHandlerService.requestCameraPermission(
        context,
      );
      if (!result) return null;

      final String? path = await _cameraService.pickImageFromGallery();
      if (path == null) return null;

      return Success(path);
    } catch (e) {
      return Failure(e.toString(), e as Exception?);
    }
  }
}
