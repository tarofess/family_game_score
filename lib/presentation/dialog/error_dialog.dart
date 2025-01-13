import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> showErrorDialog(BuildContext context, dynamic error) async {
  await showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: const Center(
          child: Text(
            'エラー発生',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        content: Text(error.toString(), style: TextStyle(fontSize: 14.sp)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
            child: Center(child: Text('はい', style: TextStyle(fontSize: 14.sp))),
          ),
        ],
      );
    },
  );
}
