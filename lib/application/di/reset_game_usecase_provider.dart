import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:family_game_score/application/usecase/reset_game_usecase.dart';

final resetGameUsecaseProvider = Provider((ref) => ResetGameUsecase(ref));
