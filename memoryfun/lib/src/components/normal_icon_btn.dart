import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memoryfun/src/start/app_colors.dart';

class NormalIconBtn extends ConsumerWidget {
  final IconData icon;

  const NormalIconBtn({
    required this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        color: ref.watch(AppColors.provider).buttonBackgroundColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Icon(
          icon,
          color: AppColors.buttonTextColor,
        ),
      ),
    );
  }
}
