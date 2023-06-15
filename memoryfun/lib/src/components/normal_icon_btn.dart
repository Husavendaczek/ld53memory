import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NormalIconBtn extends ConsumerWidget {
  final IconData icon;

  const NormalIconBtn({
    required this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: Colors.amber,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Icon(icon),
      ),
    );
  }
}
