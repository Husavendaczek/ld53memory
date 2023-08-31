import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memoryfun/src/animated_image/animated_image_memory_page.dart';
import 'package:memoryfun/src/memory_types/different/different_image/different_image_memory_page.dart';
import 'package:memoryfun/src/memory_types/same_image/same_image_memory_page.dart';
import 'package:memoryfun/src/end/won_page.dart';
import 'package:memoryfun/src/levels/level_overview_page.dart';
import 'package:memoryfun/src/end/level_done_page.dart';
import 'package:memoryfun/src/levels/level_info.dart';
import 'package:flutter/material.dart';
import 'package:memoryfun/src/settings/settings_page.dart';

import '../start/start_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: StartRoute.page, initial: true),
        AutoRoute(page: LevelOverviewRoute.page),
        AutoRoute(page: SettingsRoute.page),
        AutoRoute(page: DifferentImageMemoryRoute.page),
        AutoRoute(page: SameImageMemoryRoute.page),
        AutoRoute(page: AnimatedImageMemoryRoute.page),
        AutoRoute(page: LevelDoneRoute.page),
        AutoRoute(page: WonRoute.page),
      ];
}

final appRouterProvider = Provider((ref) => AppRouter());
