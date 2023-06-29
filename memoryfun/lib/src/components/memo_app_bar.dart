import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memoryfun/src/start/app_colors.dart';

import '../helper/app_router.dart';
import 'normal_icon_btn.dart';

class MemoAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final Function() onRestart;

  const MemoAppBar({
    required this.onRestart,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () =>
                ref.read(appRouterProvider).push(const LevelOverviewRoute()),
            child: const NormalIconBtn(icon: Icons.home),
          ),
          Text(
            'Memory fun',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textColor,
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

  @override
  Size get preferredSize => const Size.fromHeight(120);
}
