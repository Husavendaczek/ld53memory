import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memoryfun/src/helper/app_router.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      routerDelegate: ref.watch(appRouterProvider).delegate(),
      routeInformationParser: ref.watch(appRouterProvider).defaultRouteParser(),
      onGenerateTitle: (context) => 'Memory Fun',
    );
  }
}
