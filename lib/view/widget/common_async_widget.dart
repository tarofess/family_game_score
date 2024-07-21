import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
            child: Text(
              '${AppLocalizations.of(context)!.errorMessage}\n${error.toString()}',
              textAlign: TextAlign.center,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // ignore: unused_result
              ref.refresh(provider);
            },
            child: Text(AppLocalizations.of(context)!.retry),
          ),
        ],
      ),
    );
  }
}
