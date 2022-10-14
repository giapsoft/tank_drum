import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tankdrum_learning/models/instruments/instrument_size_mode.dart';
import 'package:tankdrum_learning/tank_icon_icons.dart';

import '../sound_note.dart';
import 'instrument.dart';
import 'instrument_note.dart';

class Kalimba extends Instrument {
  @override
  int get sizeMode => InstrumentSizeMode.adaptive;
  @override
  IconData get iconData => TankIcon.instrument_kalimba;

  @override
  BoxDecoration buildDecoration(InstrumentNote note, {Color? color}) {
    return BoxDecoration(
        border: Border.all(),
        color: Color.fromARGB(255, 2, 162, 190),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(200),
          bottomRight: Radius.circular(200),
        ));
  }

  @override
  bool get isAllowTuning => true;
  @override
  List<InstrumentNote> getNotes(int totalNotes) {
    const maxHeight = 1;
    const minHeight = 0.35;
    final noteList = <InstrumentNote>[];

    double widthHolder = min(1 / possibleNoteCount.last, 1 / totalNotes);
    double paddingLeft = (1 - widthHolder * totalNotes) / 2;
    double width = 1 * widthHolder;
    double padding = (widthHolder - width) / 2;
    double heightStep = (maxHeight - minHeight) / (totalNotes / 2).ceil();
    int halfNotes = (totalNotes / 2 + 1).floor();
    for (int i = 1; i <= totalNotes; i++) {
      final x = (i * 0.4) / halfNotes;
      double height =
          ((totalNotes * 1.8) / 21) * x * x / (totalNotes * heightStep) +
              minHeight;
      minHeight + heightStep * i; //
      if (i > halfNotes) {
        final symetricI = halfNotes - (i - halfNotes) - 1;
        final symetricHeight = noteList[symetricI].height;
        if (symetricI > 0) {
          height = (noteList[symetricI - 1].height + symetricHeight) / 2;
        } else {
          height = noteList[symetricI].height;
        }
      }
      final note = InstrumentNote();
      note.top = 0.0;
      note.left = paddingLeft + padding + (i - 1) * (width + 2 * padding);
      note.width = width;
      note.height = height;
      note.posIdx = i;
      noteList.add(note);
    }
    _sortIdx(noteList);
    return noteList;
  }

  _sortIdx(List<InstrumentNote> noteList) {
    final rootIdx = (noteList.length / 2).floor();
    int lastPositive = 0;
    int lastNegative = 0;
    bool isNegative = true;
    int posIdx = 1;
    noteList[rootIdx].posIdx = 0;
    int idx;
    for (int i = 1; i < noteList.length; i++) {
      if (isNegative) {
        lastNegative--;
        idx = rootIdx + lastNegative;
      } else {
        lastPositive++;
        idx = rootIdx + lastPositive;
      }
      noteList[idx].posIdx = posIdx;
      // prepare for next loop
      isNegative = !isNegative;
      posIdx++;
    }
    noteList.sort((n1, n2) => n1.posIdx - n2.posIdx);
    int count = 0;
    for (final delta
        in SoundNote.genDeltaListByLength(deltaCycleIdx, noteList.length)) {
      noteList[count++].deltaSoundIdx = delta;
    }
  }

  @override
  List<int> get possibleNoteCount {
    return List.generate(15, (index) => index + 7);
  }

  @override
  String get name => Instrument.kalimba;

  @override
  int get defaultNoteCount => 21;

  @override
  List<List<int>> playableNoteSet(Set<int> soundIdxSet) {
    final properIdxSet = SoundNote.findProperSoundSet(
        deltaCycleIdx, soundIdxSet, possibleNoteCount.last);
    if (possibleNoteCount.last < properIdxSet.first.length) {
      return [];
    }
    return properIdxSet;
  }
}
