import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memoryfun/src/memory_types/models/text_memory_tile.dart';

import '../../../utils/theme/app_color_mode.dart';
import '../image_cards/memory_card_background.dart';
import '../image_cards/memory_card_error.dart';
import '../image_cards/memory_card_visible.dart';
import '../image_cards/tapable_card.dart';

class TextMemoryCard extends ConsumerWidget {
  final TextMemoryTile memoryTile;
  final Function() onTap;

  const TextMemoryCard({
    required this.memoryTile,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var text = Center(
      child: Text(
        memoryTile.text,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );

    var backgroundImage = Image(
      image: AssetImage(
        'assets/${ref.watch(AppColorMode.provider).appColorStyle.name}/other/default_background.png',
      ),
      fit: BoxFit.cover,
    );

    Widget memoryCard = MemoryCardBackground(
      widget: memoryTile.isVisible ? text : backgroundImage,
      onTap: onTap,
    );

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
