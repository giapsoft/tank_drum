import 'package:flutter/material.dart';

import '../sound_set.dart';
import 'instrument.dart';

class FreeGrid extends Instrument {
  @override
  SoundSet get defaultSoundSet => SoundSet.harp;

  @override
  int get defaultTune => 0;
  @override
  List<int> get possibleNoteCount => List.generate(42, (index) => index + 7);
  @override
  String get name => Instrument.freeGrid;

  @override
  int get defaultNoteCount => 20;

  @override
  doResizePosition() {
    double minEmpty = 9999;

    final totalNotes = noteList.length;

    getSize() {
      double size = 0;
      for (int i = 50; i < wrapper.width; i++) {
        int col = (wrapper.width / i).floor();
        int row = (totalNotes / col).ceil();
        final emptyPlace = wrapper.height - row * i;
        if (minEmpty > emptyPlace && emptyPlace > 0) {
          minEmpty = emptyPlace;
          size = i.toDouble();
        }
      }
      return size;
    }

    final size = getSize();

    if (size == 0) {
      return [];
    }

    int col = (wrapper.width / size).floor();
    int row = (totalNotes / col).ceil();
    final realSize = 0.9 * size;
    double colGap = (wrapper.width - col * realSize) / (col + 1);
    final rowGap = (wrapper.height - row * realSize) / (row + 1);

    for (int i = 0; i < totalNotes; i++) {
      final top = wrapper.top + rowGap + (i ~/ col) * (realSize + rowGap);
      final isLastRow = i ~/ col == row - 1;
      if (isLastRow && row > 1) {
        final lastRowCount = totalNotes - ((row - 1) * col);
        if (lastRowCount > 0) {
          colGap =
              (wrapper.width - lastRowCount * realSize) / (lastRowCount + 1);
        }
      }
      double left = wrapper.left + colGap + (i % col) * (realSize + colGap);
      final note = noteList[i];
      note.top = top;
      note.left = left;
      note.width = realSize;
      note.height = realSize;
      note.padding = const EdgeInsets.all(3);
      note.borderRadius = BorderRadius.circular(200);
    }
  }
}
