import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:tankdrum_learning/models/sound_set.dart';

import '../sound_note.dart';
import 'instrument.dart';

class Kalimba extends Instrument {
  @override
  doResizePosition() {
    final maxHeight = 0.7 * wrapper.height;
    final minHeight = 0.4 * wrapper.height;

    final totalNotes = noteList.length;
    double widthHolder = min(30, wrapper.width / totalNotes);
    double paddingLeft = (wrapper.width - widthHolder * totalNotes) / 2;
    double width = 1 * widthHolder;
    double padding = (widthHolder - width) / 2;
    double heightStep = (maxHeight - minHeight) / (totalNotes / 2).ceil();
    int halfNotes = (totalNotes / 2 + 1).floor();
    final borderPadding = 0.05 * width;
    final addIfOverHalfNotes =
        totalNotes % 2 == 0 ? heightStep / 2 : -heightStep / 2;
    for (int i = 1; i <= totalNotes; i++) {
      double height = minHeight + heightStep * i;
      if (i > halfNotes) {
        height = maxHeight - heightStep * (i - halfNotes) + addIfOverHalfNotes;
      }
      final note = noteList[i - 1];
      note.top = wrapper.top;
      note.left = wrapper.left +
          paddingLeft +
          padding +
          (i - 1) * (width + 2 * padding);
      note.width = width;
      note.height = height;
      note.padding =
          EdgeInsets.fromLTRB(borderPadding, 0, borderPadding, borderPadding);
      note.borderRadius = const BorderRadius.only(
          bottomLeft: Radius.circular(200), bottomRight: Radius.circular(200));
    }
  }

  @override
  List<int> get possibleNoteCount {
    return List.generate(15, (index) => index + 7);
  }

  @override
  SoundSet get defaultSoundSet => SoundSet.kalimba;

  @override
  String get name => Instrument.kalimba;

  @override
  int get defaultNoteCount => 21;
}
