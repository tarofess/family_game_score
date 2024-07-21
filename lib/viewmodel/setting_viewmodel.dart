import 'package:family_game_score/model/entity/player.dart';
import 'package:family_game_score/model/entity/session.dart';
import 'package:family_game_score/view/widget/common_dialog.dart';
import 'package:family_game_score/viewmodel/provider/player_provider.dart';
import 'package:family_game_score/viewmodel/provider/session_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingViewModel {
  final Ref ref;

  SettingViewModel(this.ref);

  AsyncValue<List<Player>> get players => ref.watch(playerProvider);
  AsyncValue<Session?> get session => ref.watch(sessionProvider);

  VoidCallback? getFloatingActionButtonCallback(
      BuildContext context, WidgetRef ref) {
    if (players.hasValue && session.hasValue && session.value == null) {
      return () => showAddPlayerDialog(context, ref);
    }
    return null;
  }

  Color? getFloatingActionButtonColor() {
    return players.hasValue && session.hasValue && session.value == null
        ? null
        : Colors.grey[300];
  }

  Future showAddPlayerDialog(BuildContext context, WidgetRef ref) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        String inputText = '';
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.enterYourName),
          content: TextField(
            onChanged: (value) {
              inputText = value;
            },
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.playerName,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await ref.read(playerProvider.notifier).addPlayer(inputText);
                } catch (e) {
                  // ignore: use_build_context_synchronously
                  CommonDialog.showErrorDialog(context, e);
                }
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

final settingViewModelProvider = Provider((ref) => SettingViewModel(ref));
