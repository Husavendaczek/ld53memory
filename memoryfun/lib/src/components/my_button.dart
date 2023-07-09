import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memoryfun/src/start/app_colors.dart';

class NormalButtonStyle extends ConsumerWidget {
  final String text;
  final double fontSize;
  final Color? backgroundColor;

  const NormalButtonStyle({
    required this.text,
    required this.fontSize,
    this.backgroundColor,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        color: backgroundColor ??
            ref.watch(AppColors.provider).buttonBackgroundColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            color: AppColors.buttonTextColor,
          ),
        ),
      ),
    );
  }
}
