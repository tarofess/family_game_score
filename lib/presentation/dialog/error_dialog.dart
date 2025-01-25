import 'package:flutter/material.dart';

Future<void> showErrorDialog(BuildContext context, dynamic error) async {
  await showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Center(
          child: Text(
            'エラー発生',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        content: Text(
          error.toString(),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
            child: Center(
              child: Text(
                'はい',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
          ),
        ],
      );
    },
  );
}
