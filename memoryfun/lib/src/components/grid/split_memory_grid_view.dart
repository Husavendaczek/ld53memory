import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../game_type/memory_grid_row_size.dart';

class SplitMemoryGridView extends ConsumerWidget {
  final List<Widget> upperTiles;
  final List<Widget> lowerTiles;

  const SplitMemoryGridView({
    required this.upperTiles,
    required this.lowerTiles,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => SingleChildScrollView(
        child: Column(
          children: [
            grid(ref, upperTiles),
            lowerGrid(ref),
          ],
        ),
      );

  Widget grid(WidgetRef ref, List<Widget> tiles) => Padding(
        padding: const EdgeInsets.only(top: 20),
        child: GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: ref.watch(MemoryGridRowSize.provider).rowSize,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
          childAspectRatio: 1,
          padding: const EdgeInsets.all(15),
          children: tiles,
        ),
      );

  Widget lowerGrid(WidgetRef ref) {
    if (lowerTiles.isEmpty) return Container();

    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child: grid(ref, lowerTiles),
    );
  }
}
