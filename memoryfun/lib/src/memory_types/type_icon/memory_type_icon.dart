import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memoryfun/src/memory_types/type_icon/memory_type_state.dart';

class MemoryTypeIcon extends ConsumerStatefulWidget {
  const MemoryTypeIcon({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MemoryTypeIconState();
}

class _MemoryTypeIconState extends ConsumerState<MemoryTypeIcon> {
  @override
  Widget build(BuildContext context) {
    return ref.watch(MemoryTypeState.provider).gameTypeIcon(ref);
  }
}
