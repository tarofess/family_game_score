import 'package:family_game_score/main.dart';
import 'package:family_game_score/service/dialog_service.dart';
import 'package:family_game_score/service/navigation_service.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

class ErrorHandlingService {
  final FirebaseCrashlytics crashlytics = FirebaseCrashlytics.instance;
  final NavigationService navigationService = getIt<NavigationService>();
  final DialogService dialogService = getIt<DialogService>();

  Future<void> handleError(BuildContext context, dynamic error,
      StackTrace? stackTrace, String? reason) async {
    try {
      await crashlytics.recordError(
        error,
        stackTrace,
        reason: reason ?? 'Unspecified error',
      );

      if (context.mounted) {
        await dialogService.showErrorDialog(context, error);
      }
    } catch (e) {
      throw Exception('予期せぬエラーが発生しました\n時間をおいて再度お試しください');
    }
  }
}
