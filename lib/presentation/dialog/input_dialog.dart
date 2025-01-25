import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<String?> showInputDialog({
  required BuildContext context,
  required String title,
  required String hintText,
  String inputText = '',
}) async {
  final result = await showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Center(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  inputText = value;
                });
              },
              decoration: InputDecoration(hintText: hintText),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(null),
                child: Text(
                  'キャンセル',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
              TextButton(
                onPressed: inputText.trim().isEmpty
                    ? null
                    : () => Navigator.of(dialogContext).pop(inputText),
                child: Text('登録', style: TextStyle(fontSize: 14.sp)),
              )
            ],
          );
        },
      );
    },
  );
  return result;
}
