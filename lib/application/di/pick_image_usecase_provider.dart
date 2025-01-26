import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:family_game_score/application/usecase/pick_image_usecase.dart';
import 'package:family_game_score/infrastructure/service/camera_service.dart';

final pickImageUsecaseProvider = Provider(
  (ref) => PickImageUsecase(CameraService()),
);
