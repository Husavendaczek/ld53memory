import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/app_router.dart';
import 'normal_icon_btn.dart';

class OverviewAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const OverviewAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: AppBar(
        title: const Text('Memory FUN'),
        actions: [
          NormalIconBtn(
            icon: Icons.settings,
            onTap: () =>
                ref.read(appRouterProvider).push(const SettingsRoute()),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(40);
}
