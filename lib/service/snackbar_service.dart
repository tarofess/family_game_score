import 'package:flutter/material.dart';

class SnackbarService {
  void showHomeViewSnackBar(
    BuildContext context,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('プレイヤーが2名以上登録されていません\n設定画面でプレイヤーを追加してください',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
