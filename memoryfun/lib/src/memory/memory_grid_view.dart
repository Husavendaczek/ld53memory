import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memoryfun/src/split_memory/split_memory_grid_view.dart';

class MemoryGridView extends ConsumerWidget {
  final List<Widget> tiles;
  final Function() onRestart;

  const MemoryGridView({
    required this.tiles,
    required this.onRestart,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => SplitMemoryGridView(
        upperTiles: tiles,
        lowerTiles: const [],
        onRestart: onRestart,
      );
}
