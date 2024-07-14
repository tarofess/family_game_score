import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

part 'session.freezed.dart';
part 'session.g.dart';

@freezed
class Session with _$Session {
  const factory Session({
    required int id,
    required int round,
    required String begTime,
    String? endTime,
  }) = _Session;

  factory Session.fromJson(Map<String, dynamic> json) =>
      _$SessionFromJson(json);
}

extension SessionExtension on String {
  String getFormatBegTime() {
    final DateTime dateTime = DateTime.parse(this);
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');
    return formatter.format(dateTime);
  }
}
