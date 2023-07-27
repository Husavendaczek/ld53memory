import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NormalButton extends ConsumerWidget {
  final String text;
  final Function() onTap;
  final Color? backgroundColor;

  const NormalButton({
    required this.text,
    required this.onTap,
    this.backgroundColor,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => TextButton(
        onPressed: () => onTap(),
        style: TextButton.styleFrom(backgroundColor: backgroundColor),
        child: Text(text),
      );
}
