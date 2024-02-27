import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'utils/routing/app_router.dart';
import 'utils/theme/app_color_mode.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

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
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('de'),
      ],
    );
  }
}
