import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NormalIconBtn extends ConsumerWidget {
  final IconData icon;
  final Function() onTap;

  const NormalIconBtn({
    required this.icon,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => TextButton(
        onPressed: () => onTap(),
        child: Icon(
          icon,
        ),
      );
}
