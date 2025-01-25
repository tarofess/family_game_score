import 'package:flutter/material.dart';

Future<bool> showMessageDialog(BuildContext context, String content) async {
  final result = await showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: null,
        content: Text(
          content,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(true);
            },
            child: Center(
              child: Text(
                'OK',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
          ),
        ],
      );
    },
  );

  return result ?? false;
}
