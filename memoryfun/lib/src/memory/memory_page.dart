import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memoryfun/src/memory/image_mapper.dart';
import 'package:memoryfun/src/memory/memory_bloc.dart';
import 'package:memoryfun/src/memory/theme_set.dart';
import 'package:riverbloc/riverbloc.dart';

import 'memory_tile.dart';

@RoutePage()
class MemoryPage extends ConsumerStatefulWidget {
  const MemoryPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MemoryPageState();
}

class _MemoryPageState extends ConsumerState<MemoryPage> {
  @override
  void initState() {
    super.initState();

    ref.read(MemoryBloc.provider.bloc).add(
          const MemoryEvent.initGame(4, ThemeSet.food),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ref.watch(MemoryBloc.provider).maybeWhen(
            initialized: (memorySet) => _gridView(memorySet),
            matchResult: (memorySet) => _gridView(memorySet),
            orElse: () => const Text('loading'),
          ),
    );
  }

  GridView _gridView(List<MemoryTile> memorySet) => GridView.count(
        crossAxisCount: 4,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1,
        padding: const EdgeInsets.all(8),
        children: _tiles(memorySet),
      );

  List<Widget> _tiles(List<MemoryTile> memorySet) {
    List<Widget> tiles = [];
    for (var tile in memorySet) {
      final initTile = Material(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        clipBehavior: Clip.antiAlias,
        child: tile.image!.image(fit: BoxFit.cover, width: 200, height: 200),
      );

      print('visible: ' + tile.visible.toString());

      tiles.add(InkWell(
        onTap: () => tile.visible
            ? {}
            : ref
                .read(MemoryBloc.provider.bloc)
                .add(MemoryEvent.handleTap(tile.index, tile.pairValue)),
        child: initTile,
      ));
    }

    return tiles;
  }
}
