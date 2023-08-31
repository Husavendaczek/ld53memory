import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memoryfun/src/utils/app_router.dart';
import 'package:memoryfun/src/theme/app_color_mode.dart';

import '../components/normal_button.dart';

@RoutePage()
class StartPage extends ConsumerWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    final fileName = isDarkMode ? "thumbnail_dark" : "thumbnail";

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: Image(
                  image: AssetImage(
                    'assets/${ref.watch(AppColorMode.provider).appColorStyle.name}/other/$fileName.png',
                  ),
                ),
              ),
            ),
            NormalButton(
              text: 'Start game',
              onTap: () => ref
                  .read(appRouterProvider)
                  .push(LevelOverviewRoute(value: 0)),
            ),
          ],
        ),
      ),
    );
  }
}
