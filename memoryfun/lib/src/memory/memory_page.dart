import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memoryfun/src/components/my_button.dart';
import 'package:memoryfun/src/helper/app_router.dart';
import 'package:memoryfun/src/level_overview/level_done.dart';
import 'package:memoryfun/src/memory/level_info.dart';
import 'package:memoryfun/src/different_image/memory_bloc.dart';

import 'memory_tile.dart';

@RoutePage()
class MemoryPage extends ConsumerStatefulWidget {
  final LevelInfo levelInfo;

  const MemoryPage({
    required this.levelInfo,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MemoryPageState();
}

class _MemoryPageState extends ConsumerState<MemoryPage> {
  @override
  void initState() {
    super.initState();

    ref.read(MemoryBloc.provider.bloc).add(
          MemoryEvent.initGame(widget.levelInfo),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ref.watch(MemoryBloc.provider).maybeWhen(
            initialized: (memorySet) => _gridView(memorySet, true),
            matchResult: (memorySet) => _gridView(memorySet, false),
            nextLevel: (nextLevel) => LevelDone(nextLevel: nextLevel),
            orElse: () => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('loading'),
                TextButton(
                  onPressed: () => ref.read(MemoryBloc.provider.bloc).add(
                        MemoryEvent.initGame(widget.levelInfo),
                      ),
                  child: const MyButton(text: 'Restart game', fontSize: 18.0),
                ),
              ],
            ),
          ),
    );
  }

  Widget _gridView(List<MemoryTile> memorySet, bool fadeIn) => Center(
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
                  children: _tiles(memorySet, fadeIn),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 48.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => ref
                        .read(appRouterProvider)
                        .push(const LevelOverviewRoute()),
                    child:
                        const MyButton(text: 'Level overview', fontSize: 18.0),
                  ),
                  TextButton(
                    onPressed: () => ref.read(MemoryBloc.provider.bloc).add(
                          MemoryEvent.initGame(widget.levelInfo),
                        ),
                    child: const MyButton(text: 'Restart game', fontSize: 18.0),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  List<Widget> _tiles(List<MemoryTile> memorySet, bool fadeIn) {
    List<Widget> tiles = [];
    for (var tile in memorySet) {
      var initTile = Container(
        child: Material(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          clipBehavior: Clip.antiAlias,
          child: tile.image!.image(fit: BoxFit.cover),
        ),
      ).animate();

      if (tile.hasError) {
        initTile = Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.red,
              width: 2,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: tile.image!.image(fit: BoxFit.cover),
          ),
        ).animate().shake();
      }

      tiles.add(
        InkWell(
          onTap: () => tile.visible
              ? {}
              : ref.read(MemoryBloc.provider.bloc).add(MemoryEvent.handleTap(
                  tile.index, tile.pairValue, tile.isDeliveryPerson)),
          child: initTile,
        )
            .animate()
            .fadeIn(
              duration: 600.ms,
              curve: Curves.easeIn,
            )
            .blurXY(begin: 1, end: 0, duration: 600.ms, delay: 300.ms),
      );
    }

    return tiles;
  }
}
