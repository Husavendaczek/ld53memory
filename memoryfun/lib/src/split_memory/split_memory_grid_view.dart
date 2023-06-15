import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
            crossAxisCount: 3,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1,
            padding: const EdgeInsets.all(8),
            children: upperTiles,
          ),
          lowerGrid(),
        ],
      ),
    );
  }

  Widget lowerGrid() {
    if (lowerTiles.isEmpty) return Container();

    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1,
        padding: const EdgeInsets.all(8),
        children: lowerTiles,
      ),
    );
  }
}
