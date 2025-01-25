import 'package:flutter/material.dart';

Future<bool> showConfimationDialog({
  required BuildContext context,
  required String title,
  required String content,
}) async {
  final result = await showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Center(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        content: Text(
          content,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(false);
            },
            child: Text(
              'いいえ',
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop(true);
            },
            child: Text(
              'はい',
              style: Theme.of(context).textTheme.labelMedium,
            ),
          )
        ],
      );
    },
  );
  return result ?? false;
}
