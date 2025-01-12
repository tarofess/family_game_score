import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ErrorView extends StatelessWidget {
  final Object? error;
  final VoidCallback retry;

  const ErrorView({super.key, this.error, required this.retry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('アプリの初期化に失敗しました'),
            SizedBox(height: 16.h),
            if (error != null)
              Text(
                '$error',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: retry,
              child: const Text('リトライ'),
            ),
          ],
        ),
      ),
    );
  }
}
