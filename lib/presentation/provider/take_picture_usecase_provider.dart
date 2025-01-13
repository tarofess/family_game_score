import 'package:family_game_score/application/usecase/take_picture_usecase.dart';
import 'package:family_game_score/infrastructure/service/camera_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final takePictureUsecaseProvider = Provider(
  (ref) => TakePictureUsecase(CameraService()),
);
