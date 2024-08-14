import 'package:flutter/material.dart';

class SnackbarService {
  bool isSnackbarVisible = false;

  void showHomeViewSnackBar(BuildContext context) {
    if (isSnackbarVisible) return;

    isSnackbarVisible = true;

    ScaffoldMessenger.of(context)
        .showSnackBar(
          const SnackBar(
            content: Text('有効なプレイヤーが2名以上登録されていません\nプレイヤー設定画面でプレイヤーを登録してください',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        )
        .closed
        .then((_) => isSnackbarVisible = false);
  }
}
