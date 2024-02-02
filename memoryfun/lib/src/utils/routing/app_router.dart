import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../../memory_types/same/animated_image/pages/animated_image_memory_page.dart';
import '../../memory_types/same/same_image/pages/same_image_memory_page.dart';
import '../../memory_types/same/same_number/pages/same_number_memory_page.dart';
import '../../memory_types/same/same_text/pages/same_text_memory_page.dart';
import '../../memory_types/same/colors/pages/same_color_memory_page.dart';
import '../../memory_types/different/calculating_numbers/pages/calculating_numbers_memory_page.dart';
import '../../memory_types/different/different_image/pages/different_image_memory_page.dart';
import '../../memory_types/different/text_image/pages/text_image_memory_page.dart';
import '../../game_type/game_type_overview_page.dart';
import '../../game_type/game_type.dart';
import '../../forwarding_pages/won_page.dart';
import '../../levels/level_overview_page.dart';
import '../../forwarding_pages/level_done_page.dart';
import '../../levels/level_info.dart';
import '../../settings/settings_page.dart';
import '../../forwarding_pages/start_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: StartRoute.page, initial: true),
        AutoRoute(page: GameTypeOverviewRoute.page),
        AutoRoute(page: LevelOverviewRoute.page),
        AutoRoute(page: SettingsRoute.page),
        AutoRoute(page: TextImageMemoryRoute.page),
        AutoRoute(page: DifferentImageMemoryRoute.page),
        AutoRoute(page: SameImageMemoryRoute.page),
        AutoRoute(page: AnimatedImageMemoryRoute.page),
        AutoRoute(page: SameNumberMemoryRoute.page),
        AutoRoute(page: SameTextMemoryRoute.page),
        AutoRoute(page: CalculatingNumbersMemoryRoute.page),
        AutoRoute(page: SameColorMemoryRoute.page),
        AutoRoute(page: LevelDoneRoute.page),
        AutoRoute(page: WonRoute.page),
      ];
}

final appRouterProvider = Provider((ref) => AppRouter());
