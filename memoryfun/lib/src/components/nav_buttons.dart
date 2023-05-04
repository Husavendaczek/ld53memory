import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memoryfun/src/components/my_button.dart';

import '../helper/app_router.dart';

class NavButtons extends ConsumerWidget {
  final Function() onRestart;
  const NavButtons({
    required this.onRestart,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 48.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () =>
                ref.read(appRouterProvider).push(const LevelOverviewRoute()),
            child:
                const NormalButtonStyle(text: 'Level overview', fontSize: 18.0),
          ),
          TextButton(
            onPressed: onRestart,
            child:
                const NormalButtonStyle(text: 'Restart game', fontSize: 18.0),
          ),
        ],
      ),
    );
  }
}
