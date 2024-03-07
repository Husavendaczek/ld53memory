import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memoryfun/src/memory_types/type_icon/memory_type_icon.dart';

import '../../utils/routing/app_router.dart';
import '../buttons/normal_icon_btn.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
                .navigate(const GameTypeOverviewRoute()),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(AppLocalizations.of(context)!.game_name),
              const MemoryTypeIcon(),
            ],
          ),
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
