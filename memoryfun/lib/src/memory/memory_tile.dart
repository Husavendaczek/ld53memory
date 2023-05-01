import 'package:memoryfun/gen/assets.gen.dart';

class MemoryTile {
  final int index;
  final int pairValue;
  final bool isDeliveryPerson;
  AssetGenImage? image;
  bool visible;
  bool hasError;

  MemoryTile({
    required this.index,
    required this.pairValue,
    required this.isDeliveryPerson,
    this.image,
    this.visible = false,
    this.hasError = false,
  });
}
