import 'package:family_game_score/service/navigation_service.dart';
import 'package:flutter/material.dart';

class CommonDialog {
  static void showErrorDialog(BuildContext context, dynamic error,
      NavigationService navigationService) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('エラー'),
          content: Text('エラーが発生しました\n${error.toString()}'),
          actions: [
            TextButton(
              onPressed: () {
                navigationService.pop(context);
              },
              child: const Text('閉じる'),
            ),
          ],
        );
      },
    );
  }
}
