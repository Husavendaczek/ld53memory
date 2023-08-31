import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/routing/app_router.dart';
import '../buttons/normal_icon_btn.dart';

class MemoryAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final Function()? onRestart;

  const MemoryAppBar({
    required this.onRestart,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => SafeArea(
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
                onTap: () => onRestart!(),
              ),
          ],
        ),
      );

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
