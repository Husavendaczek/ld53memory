import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MemoryCardError extends ConsumerWidget {
  final AssetImage image;

  const MemoryCardError({
    required this.image,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => Padding(
        padding: const EdgeInsets.all(0.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).focusColor,
              width: 2,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Material(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              clipBehavior: Clip.antiAlias,
              child: Image(image: image, fit: BoxFit.cover),
            ),
          ),
        ).animate().shake(),
      );
}
