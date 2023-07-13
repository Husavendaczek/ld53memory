import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memoryfun/src/helper/app_router.dart';
import 'package:memoryfun/src/styling/app_theme.dart';

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: ref.watch(appRouterProvider).delegate(),
      routeInformationParser: ref.watch(appRouterProvider).defaultRouteParser(),
      onGenerateTitle: (context) => 'Memory Fun',
      color: Colors.black,
      theme: AppTheme.lightTheme(context),
      darkTheme: AppTheme.darkTheme(context),
      themeMode: ThemeMode.system,
      highContrastTheme: AppTheme.lightMonoTheme(context),
      highContrastDarkTheme: AppTheme.darkMonoTheme(context),
    );
  }
}
