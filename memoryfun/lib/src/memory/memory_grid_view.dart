import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../components/nav_buttons.dart';

class MemoryGridView extends ConsumerWidget {
  final List<Widget> tiles;
  final Function() onRestart;

  const MemoryGridView({
    required this.tiles,
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
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 32.0),
            child: Text(
              'Memory fun',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          Flexible(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1600),
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 6, //TODO for apk set to 3
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1,
                padding: const EdgeInsets.all(8),
                children: tiles,
              ),
            ),
          ),
          NavButtons(
            onRestart: onRestart,
          ),
        ],
      ),
    );
  }
}
