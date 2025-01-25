import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ErrorPage extends StatelessWidget {
  final Object? error;
  final VoidCallback retry;

  const ErrorPage({super.key, this.error, required this.retry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(24.w),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'アプリの初期化に失敗しました',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 20.h),
              if (error != null)
                Text(
                  '$error',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              SizedBox(height: 32.h),
              ElevatedButton(
                onPressed: retry,
                child: Text(
                  'リトライ',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
