import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:family_game_score/domain/entity/player.dart';
import 'package:family_game_score/presentation/page/home_page.dart';
import 'package:family_game_score/presentation/page/my_tab_page.dart';
import 'package:family_game_score/presentation/page/player_setting_detail_page.dart';
import 'package:family_game_score/presentation/page/player_setting_page.dart';
import 'package:family_game_score/presentation/page/ranking_page.dart';
import 'package:family_game_score/presentation/page/result_history_calendar_page.dart';
import 'package:family_game_score/presentation/page/result_history_detail_page.dart';
import 'package:family_game_score/presentation/page/scoring_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const MyTabPage(),
      ),
      GoRoute(
        path: '/home_page',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/scoring_page',
        pageBuilder: (BuildContext context, GoRouterState state) {
          return CustomTransitionPage(
            child: const ScoringPage(),
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
        path: '/ranking_page',
        builder: (context, state) => const RankingPage(),
      ),
      GoRoute(
        path: '/result_history_calendar_page',
        builder: (context, state) => const ResultHistoryCalendarPage(),
      ),
      GoRoute(
        path: '/result_history_detail_page',
        builder: (context, state) {
          final Map<String, dynamic> extra =
              state.extra as Map<String, dynamic>;
          final selectedDay = extra['selectedDay'] as DateTime;
          return ResultHistoryDetailPage(selectedDay: selectedDay);
        },
      ),
      GoRoute(
        path: '/player_setting_page',
        builder: (context, state) => const PlayerSettingPage(),
      ),
      GoRoute(
        path: '/player_setting_detail_page',
        builder: (context, state) {
          final Map<String, dynamic> extra =
              state.extra as Map<String, dynamic>;
          final player = extra['player'] as Player?;
          return PlayerSettingDetailPage(player: player);
        },
      ),
    ],
  );
});
