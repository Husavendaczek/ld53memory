import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../components/nav_buttons.dart';

class SplitMemoryGridView extends ConsumerWidget {
  final List<Widget> upperTiles;
  final List<Widget> lowerTiles;
  final Function() onRestart;

  const SplitMemoryGridView({
    required this.upperTiles,
    required this.lowerTiles,
    required this.onRestart,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          NavButtons(
            onRestart: onRestart,
          ),
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

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 48),
        child: GridView.count(
          shrinkWrap: true,
          crossAxisCount: 3,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 1,
          padding: const EdgeInsets.all(8),
          children: lowerTiles,
        ),
      ),
    );
  }
}
