import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:family_game_score/presentation/page/home_page.dart';
import 'package:family_game_score/presentation/page/player_setting_page.dart';
import 'package:family_game_score/presentation/page/result_history_calendar_page.dart';

class MyTabPage extends StatelessWidget {
  const MyTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 56.r,
          title: Text('ファミリーゲームスコア', style: TextStyle(fontSize: 20.sp)),
          bottom: TabBar(
            labelStyle: TextStyle(fontSize: 14.sp),
            tabs: const [
              Tab(text: 'ホーム'),
              Tab(text: '過去の成績'),
              Tab(text: 'プレイヤー'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            HomePage(),
            ResultHistoryCalendarPage(),
            PlayerSettingPage(),
          ],
        ),
      ),
    );
  }
}
