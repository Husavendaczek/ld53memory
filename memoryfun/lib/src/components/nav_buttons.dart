import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memoryfun/src/components/normal_icon_btn.dart';

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
      padding: const EdgeInsets.only(top: 48.0, left: 32.0, right: 32.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () =>
                ref.read(appRouterProvider).push(const LevelOverviewRoute()),
            child: const NormalIconBtn(icon: Icons.home),
          ),
          const Text(
            'Memory fun',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextButton(
            onPressed: onRestart,
            child: const NormalIconBtn(icon: Icons.restart_alt),
          ),
        ],
      ),
    );
  }
}
