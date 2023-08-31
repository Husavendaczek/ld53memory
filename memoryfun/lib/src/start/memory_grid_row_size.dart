import 'package:flutter_riverpod/flutter_riverpod.dart';

class MemoryGridRowSize {
  int rowSize;

  MemoryGridRowSize({this.rowSize = 4});

  static final provider = Provider<MemoryGridRowSize>((ref) {
    return MemoryGridRowSize();
  });

  void setRowSize(int size) {
    rowSize = size;
  }
}
