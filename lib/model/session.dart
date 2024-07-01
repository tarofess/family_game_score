import 'package:freezed_annotation/freezed_annotation.dart';

part 'session.freezed.dart';

@freezed
class Session with _$Session {
  const factory Session({
    required int id,
    required String begTime,
    required String endTime,
    required int currentRound,
  }) = _Session;
}
