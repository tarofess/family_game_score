import 'package:family_game_score/service/navigation_service.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

class ErrorHandlingService {
  final FirebaseCrashlytics crashlytics = FirebaseCrashlytics.instance;
  final NavigationService navigationService;

  ErrorHandlingService(this.navigationService);

  Future<void> handleError(BuildContext context, dynamic error,
      StackTrace? stackTrace, String? reason) async {
    try {
      await crashlytics.recordError(
        error,
        stackTrace,
        reason: reason ?? 'Unspecified error',
      );
    } catch (e) {
      throw Exception('予期せぬエラーが発生しました\n時間をおいて再度お試しください');
    }

    if (context.mounted) {
      await showErrorDialog(context, error);
    }
  }

  Future<void> showErrorDialog(BuildContext context, dynamic error) async {
    await showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('エラー発生'),
        content: Text(error.toString()),
        actions: [
          TextButton(
            child: const Text('はい'),
            onPressed: () => navigationService.pop(dialogContext),
          ),
        ],
      ),
    );
  }
}
