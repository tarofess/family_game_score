import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
            child: Text(title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ))),
        content: Text(content, style: TextStyle(fontSize: 14.sp)),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: Text('いいえ', style: TextStyle(fontSize: 14.sp))),
          TextButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop(true);
            },
            child: Text('はい', style: TextStyle(fontSize: 14.sp)),
          )
        ],
      );
    },
  );
  return result ?? false;
}
