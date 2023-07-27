import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../start/app_colors.dart';

class SplitMemoryGridView extends ConsumerWidget {
  final List<Widget> upperTiles;
  final List<Widget> lowerTiles;

  const SplitMemoryGridView({
    required this.upperTiles,
    required this.lowerTiles,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        children: [
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: ref.watch(MemoryGridRowSize.provider).rowSize,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            childAspectRatio: 1,
            padding: const EdgeInsets.all(4),
            children: upperTiles,
          ),
          lowerGrid(ref),
        ],
      ),
    );
  }

  Widget lowerGrid(WidgetRef ref) {
    if (lowerTiles.isEmpty) return Container();

    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: ref.watch(MemoryGridRowSize.provider).rowSize,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1,
        padding: const EdgeInsets.all(8),
        children: lowerTiles,
      ),
    );
  }
}
