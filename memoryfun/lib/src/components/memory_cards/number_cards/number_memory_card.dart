import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memoryfun/src/memory_types/models/number_memory_tile.dart';

import '../../../utils/theme/app_color_mode.dart';
import '../image_cards/memory_card_background.dart';
import '../image_cards/memory_card_error.dart';
import '../image_cards/memory_card_visible.dart';
import '../image_cards/tapable_card.dart';

class NumberMemoryCard extends ConsumerWidget {
  final NumberMemoryTile memoryTile;
  final Function() onTap;

  const NumberMemoryCard({
    required this.memoryTile,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var text = Text('${memoryTile.number}');

    Widget memoryCard = MemoryCardBackground(
        image: AssetImage(
          'assets/${ref.watch(AppColorMode.provider).appColorStyle.name}/other/default_background.png',
        ),
        onTap: onTap);

    if (memoryTile.isCorrect) {
      memoryCard = MemoryCardVisible(
        widget: text,
      );
    }

    if (memoryTile.hasError) {
      memoryCard = MemoryCardError(
        widget: text,
      );
    }

    return TapableCard(
      card: memoryCard,
      rotationAngle: memoryTile.angle,
      shouldFlip: memoryTile.isVisible,
      onTap: () =>
          memoryTile.isVisible && memoryTile.isCorrect ? null : onTap(),
    );
  }
}
