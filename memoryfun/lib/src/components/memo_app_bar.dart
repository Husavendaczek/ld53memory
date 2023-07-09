import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memoryfun/src/start/app_colors.dart';

import '../helper/app_router.dart';
import 'normal_icon_btn.dart';

class MemoAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final Function()? onRestart;

  const MemoAppBar({
    required this.onRestart,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: AppBar(
        leading: TextButton(
          onPressed: () =>
              ref.read(appRouterProvider).push(const LevelOverviewRoute()),
          child: const NormalIconBtn(icon: Icons.home),
        ),
        title: Text(
          'Memory FUN',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textColor,
          ),
        ),
        actions: [
          if (onRestart != null)
            TextButton(
              onPressed: onRestart,
              child: const NormalIconBtn(icon: Icons.restart_alt),
            ),
        ],
        backgroundColor: Colors.white,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
