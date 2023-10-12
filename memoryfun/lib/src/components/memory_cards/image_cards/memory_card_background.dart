import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MemoryCardBackground extends ConsumerWidget {
  final Widget widget;
  final Function() onTap;
  final bool isLowerPart;

  const MemoryCardBackground({
    required this.widget,
    required this.onTap,
    this.isLowerPart = false,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => Padding(
        padding: const EdgeInsets.all(4.0),
        child: Material(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          clipBehavior: Clip.antiAlias,
          child: widget,
        ),
      ).animate().flipH();
}
