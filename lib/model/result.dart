import 'package:freezed_annotation/freezed_annotation.dart';

part 'result.freezed.dart';

@freezed
class Result with _$Result {
  const factory Result({
    required int id,
    required int playerId,
    required int sessionId,
    required int round,
    required int score,
  }) = _Result;
}
