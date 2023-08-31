import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/app_router.dart';
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
        leading: NormalIconBtn(
          icon: Icons.home,
          onTap: () => ref
              .read(appRouterProvider)
              .navigate(LevelOverviewRoute(value: 10)),
        ),
        title: const Text('Memory FUN'),
        actions: [
          if (onRestart != null)
            NormalIconBtn(
              icon: Icons.restart_alt,
              onTap: () => onRestart,
            ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
