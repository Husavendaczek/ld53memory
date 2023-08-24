import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memoryfun/src/helper/app_router.dart';
import 'package:memoryfun/src/start/app_colors.dart';

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  Widget build(BuildContext context) {
    ref
        .read(ColorMode.provider)
        .setColorStyle(MediaQuery.highContrastOf(context));

    return MaterialApp.router(
      routerDelegate: ref.watch(appRouterProvider).delegate(),
      routeInformationParser: ref.watch(appRouterProvider).defaultRouteParser(),
      onGenerateTitle: (context) => 'Memory Fun',
      color: Colors.black,
      theme: ref.watch(ColorMode.provider).lightTheme(context),
      darkTheme: ref.watch(ColorMode.provider).darkTheme(context),
      themeMode: ref.watch(ColorMode.provider).myThemeMode,
      highContrastTheme: ref.watch(ColorMode.provider).lightTheme(context),
      highContrastDarkTheme: ref.watch(ColorMode.provider).darkTheme(context),
    );
  }
}
