import 'package:flutter/material.dart';

Future<void> showMessageDialog(BuildContext context, String content) async {
  await showDialog(
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
              Navigator.of(dialogContext).pop();
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
}
