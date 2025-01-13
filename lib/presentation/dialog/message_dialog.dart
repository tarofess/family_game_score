import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> showMessageDialog(BuildContext context, String content) async {
  await showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: const Text(''),
        content: Text(content, style: TextStyle(fontSize: 14.sp)),
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
