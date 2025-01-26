import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:family_game_score/application/usecase/file_image_get_usecase.dart';
import 'package:family_game_score/infrastructure/service/file_service.dart';

final fileImageGetUsecaseProvider = Provider(
  (ref) => FileImageGetUsecase(
    FileService(),
  ),
);
