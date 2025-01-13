import 'package:family_game_score/application/usecase/reset_game_usecase.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final resetGameUsecaseProvider = Provider((ref) => ResetGameUsecase(ref));
