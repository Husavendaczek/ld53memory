import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'split_memory_grid_view.dart';

class SingleMemoryGridView extends ConsumerWidget {
  final List<Widget> tiles;

  const SingleMemoryGridView({
    required this.tiles,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => SplitMemoryGridView(
        upperTiles: tiles,
        lowerTiles: const [],
      );
}
