import 'package:family_game_score/service/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CommonDialog {
  static void showErrorDialog(BuildContext context, dynamic error,
      NavigationService navigationService) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.errorTitle),
          content: Text(
              '${AppLocalizations.of(context)!.errorMessage}\n${error.toString()}'),
          actions: [
            TextButton(
              onPressed: () {
                navigationService.pop(context);
              },
              child: Text(AppLocalizations.of(context)!.close),
            ),
          ],
        );
      },
    );
  }
}
