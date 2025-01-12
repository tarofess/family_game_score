import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:family_game_score/domain/entity/player.dart';
import 'package:family_game_score/presentation/view/home_view.dart';
import 'package:family_game_score/presentation/view/my_tab_view.dart';
import 'package:family_game_score/presentation/view/player_setting_detail_view.dart';
import 'package:family_game_score/presentation/view/player_setting_view.dart';
import 'package:family_game_score/presentation/view/ranking_view.dart';
import 'package:family_game_score/presentation/view/result_history_calendar_view.dart';
import 'package:family_game_score/presentation/view/result_history_detail_view.dart';
import 'package:family_game_score/presentation/view/scoring_view.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const MyTabView(),
      ),
      GoRoute(
        path: '/home_view',
        builder: (context, state) => HomeView(),
      ),
      GoRoute(
        path: '/scoring_view',
        pageBuilder: (BuildContext context, GoRouterState state) {
          return CustomTransitionPage(
            child: ScoringView(),
            transitionDuration: const Duration(milliseconds: 800),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              var begin = const Offset(0.0, 1.0);
              var end = Offset.zero;
              var curve = Curves.fastLinearToSlowEaseIn;

              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);

              return SlideTransition(position: offsetAnimation, child: child);
            },
          );
        },
      ),
      GoRoute(
        path: '/ranking_view',
        builder: (context, state) => RankingView(),
      ),
      GoRoute(
        path: '/result_history_calendar_view',
        builder: (context, state) => const ResultHistoryCalendarView(),
      ),
      GoRoute(
        path: '/result_history_detail_view',
        builder: (context, state) {
          final Map<String, dynamic> extra =
              state.extra as Map<String, dynamic>;
          final selectedDay = extra['selectedDay'] as DateTime;
          return ResultHistoryDetailView(selectedDay: selectedDay);
        },
      ),
      GoRoute(
        path: '/player_setting_view',
        builder: (context, state) => PlayerSettingView(),
      ),
      GoRoute(
        path: '/player_setting_detail_view',
        builder: (context, state) {
          final Map<String, dynamic> extra =
              state.extra as Map<String, dynamic>;
          final player = extra['player'] as Player?;
          return PlayerSettingDetailView(player: player);
        },
      ),
    ],
  );
});
