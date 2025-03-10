import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AsyncErrorWidget extends StatelessWidget {
  final Object? error;
  final VoidCallback retry;

  const AsyncErrorWidget({super.key, this.error, required this.retry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'エラーが発生しました',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 20.h),
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
    );
  }
}
