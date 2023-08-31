import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'utils/routing/app_router.dart';
import 'utils/theme/app_color_mode.dart';

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  Widget build(BuildContext context) {
    ref
        .read(AppColorMode.provider)
        .setColorStyle(MediaQuery.highContrastOf(context));

    return MaterialApp.router(
      routerDelegate: ref.watch(appRouterProvider).delegate(),
      routeInformationParser: ref.watch(appRouterProvider).defaultRouteParser(),
      onGenerateTitle: (context) => 'Memory Fun',
      color: Colors.black,
      theme: ref.watch(AppColorMode.provider).lightTheme(context),
      darkTheme: ref.watch(AppColorMode.provider).darkTheme(context),
      themeMode: ref.watch(AppColorMode.provider).myThemeMode,
      highContrastTheme: ref.watch(AppColorMode.provider).lightTheme(context),
      highContrastDarkTheme:
          ref.watch(AppColorMode.provider).darkTheme(context),
    );
  }
}
