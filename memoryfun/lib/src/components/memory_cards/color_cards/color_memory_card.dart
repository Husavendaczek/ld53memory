import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../memory_types/same/colors/models/color_memory_tile.dart';
import '../../../utils/theme/app_color_mode.dart';
import '../image_cards/memory_card_background.dart';
import '../image_cards/memory_card_error.dart';
import '../image_cards/memory_card_visible.dart';
import '../image_cards/tapable_card.dart';

class ColorMemoryCard extends ConsumerWidget {
  final ColorMemoryTile memoryTile;
  final Function() onTap;

  const ColorMemoryCard({
    required this.memoryTile,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var coloredContainer = Container(
      color: memoryTile.color,
    );

    var backgroundImage = Image(
      image: AssetImage(
        'assets/${ref.watch(AppColorMode.provider).appColorStyle.name}/other/default_background.png',
      ),
      fit: BoxFit.cover,
    );

    Widget memoryCard = MemoryCardBackground(
      widget: memoryTile.isVisible ? coloredContainer : backgroundImage,
      onTap: onTap,
    );

    if (memoryTile.isCorrect) {
      memoryCard = MemoryCardVisible(
        widget: coloredContainer,
      );
    }

    if (memoryTile.hasError) {
      memoryCard = MemoryCardError(
        widget: coloredContainer,
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
