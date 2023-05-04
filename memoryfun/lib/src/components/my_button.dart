import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NormalButtonStyle extends ConsumerWidget {
  final String text;
  final double fontSize;

  const NormalButtonStyle({
    required this.text,
    required this.fontSize,
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
        child: Text(
          text,
          style: TextStyle(fontSize: fontSize),
        ),
      ),
    );
  }
}
