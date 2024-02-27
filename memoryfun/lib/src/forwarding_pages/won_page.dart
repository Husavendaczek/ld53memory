import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../components/buttons/normal_button.dart';
import '../utils/theme/app_color_mode.dart';
import '../utils/theme/app_color_style.dart';
import '../utils/routing/app_router.dart';

@RoutePage()
class WonPage extends ConsumerWidget {
  const WonPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var monochromeText = Text(
      AppLocalizations.of(context)!.congratulations,
      style: const TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
      ),
    );
    var coloredText = Text(
      AppLocalizations.of(context)!.congratulations,
      style: const TextStyle(
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
              child: Text(
                AppLocalizations.of(context)!.did_it,
                style: const TextStyle(fontSize: 20),
              )
                  .animate(
                    onPlay: (controller) => controller.repeat(),
                  )
                  .custom(
                    duration: 300.ms,
                    builder: (context, value, child) => _myText(
                      context,
                      const Color.fromARGB(255, 255, 223, 234),
                      Colors.purple,
                      value,
                    ),
                  ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 48.0),
              child: NormalButton(
                text: AppLocalizations.of(context)!.new_game,
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

  Text _myText(BuildContext context, Color a, Color b, double value) => Text(
        AppLocalizations.of(context)!.did_it,
        style: TextStyle(fontSize: 20, color: Color.lerp(a, b, value)),
      );
}
