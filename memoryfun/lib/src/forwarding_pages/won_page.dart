import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../components/buttons/normal_button.dart';
import '../utils/theme/app_color_mode.dart';
import '../utils/theme/app_color_style.dart';
import '../utils/routing/app_router.dart';

@RoutePage()
class WonPage extends ConsumerWidget {
  const WonPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var monochromeText = const Text(
      'GLÜCKWUNSCH!',
      style: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
      ),
    );
    var coloredText = const Text(
      'GLÜCKWUNSCH!',
      style: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
      ),
    )
        .animate(
          onPlay: (controller) => controller.repeat(),
        )
        .custom(
          duration: 300.ms,
          builder: (context, value, child) => Container(
            color: Color.lerp(Colors.yellow, Colors.orange, value),
            padding: const EdgeInsets.all(8),
            child: child,
          ),
        )
        .custom(
          duration: 300.ms,
          builder: (context, value, child) => Container(
            color: Color.lerp(Colors.orange, Colors.red, value),
            padding: const EdgeInsets.all(8),
            child: child,
          ),
        )
        .custom(
          duration: 300.ms,
          builder: (context, value, child) => Container(
            color: Color.lerp(Colors.red, Colors.purple, value),
            padding: const EdgeInsets.all(8),
            child: child,
          ),
        )
        .custom(
          duration: 300.ms,
          builder: (context, value, child) => Container(
            color: Color.lerp(Colors.purple, Colors.blue, value),
            padding: const EdgeInsets.all(8),
            child: child,
          ),
        )
        .custom(
          duration: 300.ms,
          builder: (context, value, child) => Container(
            color: Color.lerp(Colors.blue, Colors.green, value),
            padding: const EdgeInsets.all(8),
            child: child,
          ),
        )
        .custom(
          duration: 300.ms,
          builder: (context, value, child) => Container(
            color: Color.lerp(Colors.green, Colors.yellow, value),
            padding: const EdgeInsets.all(8),
            child: child,
          ),
        );

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ref.read(AppColorMode.provider).appColorStyle == AppColorStyle.color
                ? coloredText
                : monochromeText,
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32.0),
              child: const Text(
                'Geschafft!',
                style: TextStyle(fontSize: 20),
              )
                  .animate(
                    onPlay: (controller) => controller.repeat(),
                  )
                  .custom(
                    duration: 300.ms,
                    builder: (context, value, child) => _myText(
                      const Color.fromARGB(255, 255, 223, 234),
                      Colors.purple,
                      value,
                    ),
                  ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 48.0),
              child: NormalButton(
                text: 'Neues Memory spielen',
                onTap: () => ref
                    .read(appRouterProvider)
                    .push(const GameTypeOverviewRoute()),
              ),
            )
          ],
        ),
      ),
    );
  }

  Text _myText(Color a, Color b, double value) => Text(
        'Geschafft!',
        style: TextStyle(fontSize: 20, color: Color.lerp(a, b, value)),
      );
}
