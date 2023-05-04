import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memoryfun/src/memory/game_type.dart';
import 'package:memoryfun/src/memory/memory_page.dart';
import 'package:memoryfun/src/same_image/simple_memory_page.dart';
import 'package:memoryfun/src/end/won_page.dart';
import 'package:memoryfun/src/level_overview/level_overview_page.dart';
import 'package:memoryfun/src/memory/level_info.dart';
import 'package:flutter/material.dart';

import '../start/start_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        //HomeScreen is generated as HomeRoute because
        //of the replaceInRouteName property
        AutoRoute(page: StartRoute.page, initial: true),
        AutoRoute(page: LevelOverviewRoute.page),
        AutoRoute(page: MemoryRoute.page),
        AutoRoute(page: SimpleMemoryRoute.page),
        AutoRoute(page: WonRoute.page),
      ];
}

final appRouterProvider = Provider((ref) => AppRouter());
