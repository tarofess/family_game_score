import 'package:flutter/material.dart';

class SnackbarService {
  bool isSnackbarVisible = false;

  void showHomeViewSnackBar(BuildContext context) {
    if (isSnackbarVisible) return;

    isSnackbarVisible = true;

    ScaffoldMessenger.of(context)
        .showSnackBar(
          const SnackBar(
            content: Text('プレイヤーが2名以上登録されていません\n設定画面でプレイヤーを追加してください',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        )
        .closed
        .then((_) => isSnackbarVisible = false);
    ;
  }
}
