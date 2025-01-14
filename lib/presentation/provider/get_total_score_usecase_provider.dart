import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:family_game_score/application/usecase/get_total_score_usecase.dart';

final getTotalScoreUsecaseProvider = Provider(
  (ref) => GetTotalScoreUsecase(ref),
);
