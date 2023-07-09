import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memoryfun/src/start/app_colors.dart';

import '../helper/app_router.dart';
import 'normal_icon_btn.dart';

class OverviewAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const OverviewAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: AppBar(
        title: Text(
          'Memory FUN',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () =>
                ref.read(appRouterProvider).push(const SettingsRoute()),
            child: const NormalIconBtn(icon: Icons.settings),
          ),
        ],
        backgroundColor: Colors.white,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
