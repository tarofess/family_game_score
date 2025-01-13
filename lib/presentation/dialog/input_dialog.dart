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
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            content: TextField(
                onChanged: (value) {
                  setState(() {
                    inputText = value;
                  });
                },
                decoration: InputDecoration(hintText: hintText),
                style: TextStyle(fontSize: 14.sp)),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(null),
                child: Text('キャンセル', style: TextStyle(fontSize: 14.sp)),
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
