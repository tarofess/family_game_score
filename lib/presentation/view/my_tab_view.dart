import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:family_game_score/presentation/view/home_view.dart';
import 'package:family_game_score/presentation/view/player_setting_view.dart';
import 'package:family_game_score/presentation/view/result_history_calendar_view.dart';

class MyTabView extends StatelessWidget {
  const MyTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
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
            HomeView(),
            ResultHistoryCalendarView(),
            PlayerSettingView(),
          ],
        ),
      ),
    );
  }
}
