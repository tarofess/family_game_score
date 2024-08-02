import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CommonAsyncWidgets {
  static Widget showLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  static Widget showDataFetchErrorMessage(BuildContext context, WidgetRef ref,
      AsyncNotifierProvider provider, Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('エラーが発生しました\n再度お試しください'),
                const SizedBox(height: 12),
                Text(error.toString()),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // ignore: unused_result
              ref.refresh(provider);
            },
            child: const Text('リトライ'),
          ),
        ],
      ),
    );
  }
}
