import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SnackbarService {
  bool isSnackbarVisible = false;

  void showHomeViewSnackBar(BuildContext context) {
    if (isSnackbarVisible) return;

    isSnackbarVisible = true;

    ScaffoldMessenger.of(context)
        .showSnackBar(
          SnackBar(
            content: Text(
                '有効なプレイヤーが2名以上登録されていません。\n'
                'プレイヤー設定画面でプレイヤーを登録してください。',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                )),
          ),
        )
        .closed
        .then((_) => isSnackbarVisible = false);
  }
}
